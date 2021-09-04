import os
import json
import hashlib
import requests

from bs4 import BeautifulSoup
from urllib.parse import urlparse, urljoin

from helpers import s3
from helpers import telegram_bot

import configs


def s3_key_gen(url):
    """ url 으로 s3 object 이름 생성 """
    path = urlparse(url).path
    return os.path.join(configs.S3_BOARD_FOLDER, path.strip('/').replace('/', '_') + '.json')


def _build_message(board_name, num, date, title, link):
    """ 텔레그램 메시지 빌드
    ex)
    43. [공지] 제 6회 인하대학교 IUPC 신청 안내 (12.18 ~ 12.30)
      - 학생회공지 (2020.12.21)
    """
    message = [
        f'<a href="{link}">{num}. {title}</a>', '\n',
        f'  - {board_name} ({date})'
    ]
    return ''.join(message)


def crawl(board_name, url):
    # S3 가져오기
    s3_key = s3_key_gen(url)
    history = json.loads(s3.get_object(s3_key) or '{}')

    # 파싱
    resp = requests.get(url, headers={'User-Agent': configs.USER_AGENT})

    bs = BeautifulSoup(resp.text, 'lxml')
    article = bs.find('article', {'id': '_contentBuilder'})
    tbody = article.find('table', {'class': 'artclTable'}).find('tbody')

    trs = tbody.find_all('tr')
    for tr in trs[::-1]:  # 예전 것부터 -> ASC order 알림
        num = tr.find(attrs={'class': '_artclTdNum'}).text.strip()
        date = tr.find(attrs={'class': '_artclTdRdate'}).text.strip()
        title = tr.find(attrs={'class': '_artclTdTitle'}).find('a').text.replace('새글', '').strip()
        _link_path = tr.find('a', attrs={'class': 'artclLinkView'}).attrs.get('href').strip()
        link = urljoin(url, _link_path)

        # 알림 보낸 적 없는 제목일 때, 알림 & 저장
        hashed_title = hashlib.md5(title.encode()).hexdigest()  # 제목 변경도 감지하도록
        if hashed_title not in history:
            telegram_bot.send_message(_build_message(board_name, num, date, title, link), parse_mode='HTML')
            history[hashed_title] = [num, date, title, link]

    # S3 업로드
    s3.put_object(s3_key, json.dumps(history))


def main():
    for url in configs.CrawlUrl:
        crawl(url.name, url.value)
