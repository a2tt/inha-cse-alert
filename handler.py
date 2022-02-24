from helpers.sentry import init_sentry

init_sentry()


def board_crawler(event=None, context=None):
    from tasks.board_crawler import main

    return main()


if __name__ == "__main__":
    board_crawler()
