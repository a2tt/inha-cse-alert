from urllib.parse import urlparse
from typing import List, Type, Union

from bs4 import BeautifulSoup
import requests

from model.article import Article
from crawler.parser import NormalParser, BBSParser

import configs


class Crawler:
    def __init__(self, url: str, parser: Type[Union[NormalParser, BBSParser]]):
        self.url = url
        self.parser = parser(self.url)

    def _send_request(self):
        return requests.get(self.url, headers={"User-Agent": configs.USER_AGENT})

    def get_articles(self) -> List[Article]:
        resp = self._send_request()

        el = BeautifulSoup(resp.text, "html.parser")
        return self.parser.parse_list(el)


def get_crawler(url: str) -> Crawler:
    res = urlparse(url)

    if res.path.startswith("/bbs/"):
        return Crawler(url, BBSParser)
    else:
        return Crawler(url, NormalParser)
