import traceback

from helpers import telegram_bot

import settings


def board_crawler(event=None, context=None):
    from tasks.board_crawler import main
    try:
        return main()
    except:
        e_str = traceback.format_exc()
        telegram_bot.send_message(e_str, settings.TELEGRAM_ALERT_CHANNEL_ID)
        return


if __name__ == '__main__':
    board_crawler()
