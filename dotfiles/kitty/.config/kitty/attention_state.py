from collections.abc import Iterable

from kitty.tabs import TabDict


def needs_attention(tabs: Iterable[TabDict]) -> bool:
    return any(window["needs_attention"] for tab in tabs for window in tab["windows"])
