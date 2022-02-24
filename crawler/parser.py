import hashlib
from urllib.parse import urljoin
from typing import Optional, List

from bs4.element import Tag

from model.article import Article
from model.parser import ParseRule


class BaseParser:
    """
    Note that, because there is no exception handlers, parsing errors will
    occur when the HTML structure is changed or in other cases. But it is
    an intended behavior
    """

    def __init__(self, url, list_rule: List[ParseRule]):
        self.url = url
        self.list_rule = list_rule

    def parse_list(self, el: Optional[Tag]) -> List[Article]:
        """Parse article list and return Articles"""
        articles = []

        for rule in self.list_rule:
            rule: ParseRule
            el = el.find(rule.tag, rule.attr)

        trs = el.find_all("tr")

        for tr in trs[::-1]:  # Read by asc order
            article = self.parse_article(tr)
            if article:
                articles.append(article)

        return articles

    def parse_article(self, el: Optional[Tag]) -> Optional[Article]:
        """Parse each article into Article instance"""
        num = el.find(attrs={"class": "_artclTdNum"}).text.strip()
        if not num.isdigit():
            return
        date = el.find(attrs={"class": "_artclTdRdate"}).text.strip()
        title = el.find(attrs={"class": "_artclTdTitle"}).find("a").text.replace("새글", "").strip()

        _link_path = el.find("a", attrs={"class": "artclLinkView"}).attrs.get("href").strip()
        link = urljoin(self.url, _link_path)
        hashed_title = hashlib.md5(title.encode()).hexdigest()  # Detect a change in title

        article = Article(num=num, date=date, title=title, link=link, hashed_title=hashed_title)
        return article


class NormalParser(BaseParser):
    def __init__(self, url: str):
        list_rule = [
            ParseRule(tag="article", attr={"id": "_contentBuilder"}),
            ParseRule(tag="table", attr={"class": "artclTable"}),
            ParseRule(tag="tbody", attr={}),
        ]
        super().__init__(url, list_rule)


class BBSParser(BaseParser):
    def __init__(self, url: str):
        list_rule = [
            ParseRule(tag="div", attr={"class": "_articleTable"}),
            ParseRule(tag="table", attr={"class": "artclTable"}),
            ParseRule(tag="tbody", attr={}),
        ]
        super().__init__(url, list_rule)
