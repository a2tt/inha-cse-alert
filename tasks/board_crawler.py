import json

from crawler.base import get_crawler
from helpers import s3
from helpers import telegram_bot

import configs


def crawl(board_name, url):
    # Load history from S3
    s3_key = s3.s3_key_gen(url)
    history = json.loads(s3.get_object(s3_key) or "{}")

    # Parse
    crawler = get_crawler(url)
    articles = crawler.get_articles()

    # Send telegram, and update history if each article has a title that has never been seen
    updated = False
    for article in articles:
        if article.hashed_title not in history:
            res = telegram_bot.send_message(article.format(board_name), parse_mode="HTML")
            if res:
                history[article.hashed_title] = article.as_list()
                updated = True

    # Upload S3 object
    if updated:
        s3.put_object(s3_key, json.dumps(history))


def main():
    for url in configs.CrawlUrl:
        crawl(url.name, url.value)
