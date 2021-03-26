import os

PROJECT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))


def abspath(file: str) -> str:
    return os.path.join(PROJECT_DIR, file)
