from dataclasses import dataclass


@dataclass(frozen=True)
class Article:
    num: str
    date: str
    title: str
    link: str
    hashed_title: str

    def format(self, board_name: str):
        return "".join(
            [
                f'<a href="{self.link}">{self.num}. {self.title}</a>\n',
                f"  - {board_name} ({self.date})",
            ]
        )

    def as_list(self):
        return [self.num, self.date, self.title, self.link]
