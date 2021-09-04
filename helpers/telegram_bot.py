import time
import telegram
from telegram.error import RetryAfter, TimedOut, NetworkError

import settings

bot = telegram.Bot(token=settings.TELEGRAM_TOKEN)
RETRY = 5


def send_message(message, chat_id=settings.TELEGRAM_TARGET_ID, parse_mode=None):
    """ parse_mode : None | 'HTML' """
    if not message:
        return None

    for idx in range(0, RETRY):
        try:
            return bot.send_message(chat_id=chat_id, text=message, timeout=5,
                                    parse_mode=parse_mode, disable_web_page_preview=True)
        except TimedOut:
            break
        except (NetworkError, RetryAfter) as e:
            time.sleep(5)
