from typing import Any
from enum import Enum

import yaml


def load_configs() -> dict:
    with open("configs.yml", "rt") as fp:
        configs = yaml.load(fp.read(), Loader=yaml.FullLoader)

    return configs["application"].copy()


def get_value(key: str, type_: type = str) -> Any:
    return type_(app_configs.get(key))


class CrawlUrl(Enum):
    학생회소식 = "https://cse.inha.ac.kr/cse/884/subview.do"
    공지사항 = "https://cse.inha.ac.kr/cse/888/subview.do"
    졸업예정자공지 = "https://cse.inha.ac.kr/cse/889/subview.do"
    인하대공지 = "https://www.inha.ac.kr/kr/950/subview.do"


# Load configs
app_configs: dict = load_configs()

# Parse
SENTRY_DSN = get_value("SENTRY_DSN")
TELEGRAM_TOKEN = get_value("TELEGRAM_TOKEN")
TELEGRAM_TARGET_ID = get_value("TELEGRAM_TARGET_ID")

S3_BUCKET_NAME = get_value("S3_BUCKET_NAME")
S3_BOARD_FOLDER = get_value("S3_BOARD_FOLDER")

USER_AGENT = get_value("USER_AGENT")
