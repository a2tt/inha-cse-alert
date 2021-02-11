from enum import Enum


class CrawlUrl(Enum):
    학생회소식 = 'https://cse.inha.ac.kr/cse/884/subview.do'
    공지사항 = 'https://cse.inha.ac.kr/cse/888/subview.do'
    졸업예정자공지 = 'https://cse.inha.ac.kr/cse/889/subview.do'


USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36'

S3_BUCKET_NAME = 'inha-univ'
S3_BOARD_FOLDER = 'board'
