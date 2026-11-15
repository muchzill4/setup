import sys
from os.path import dirname

from kitty.fast_data_types import Screen, get_boss, wcswidth
from kitty.tabs import TabDict
from kitty.boss import OSWindowDict
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    draw_tab_with_slant,
)

# Kitty loads this file with runpy, without adding its directory to sys.path.
sys.path.insert(0, dirname(__file__))
try:
    from attention_state import needs_attention
finally:
    sys.path.pop(0)

ATTENTION_ICON = "🔔"
TITLE_TEMPLATE = "{title}{' 🔎' if layout_name == 'stack' and num_windows > 1 else ''}"


def is_same_tab(drawn_tab: TabBarData, os_window_tab: TabDict) -> bool:
    return os_window_tab["id"] == drawn_tab.tab_id


def find_matching_os_window(last_tab: TabBarData) -> OSWindowDict:
    for os_window in get_boss().list_os_windows():
        last_os_window_tab = os_window["tabs"][-1]
        if is_same_tab(last_tab, last_os_window_tab):
            return os_window


def other_os_windows_need_attention(current: OSWindowDict) -> bool:
    return any(
        needs_attention(os_window["tabs"])
        for os_window in get_boss().list_os_windows()
        if os_window["id"] != current["id"]
    )


def draw_right_status(
    last_tab: TabBarData,
    screen: Screen,
):
    os_window = find_matching_os_window(last_tab)
    attention_status = f" {ATTENTION_ICON}" if other_os_windows_need_attention(os_window) else ""
    session_status = f" {os_window['wm_name']} "

    padding = screen.columns - wcswidth(attention_status + session_status) - screen.cursor.x
    screen.cursor.bg = 0
    screen.cursor.bold = False
    screen.draw(" " * padding)
    screen.draw(attention_status + session_status)


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    draw_data = draw_data._replace(title_template=TITLE_TEMPLATE, active_title_template=None)
    draw_tab_with_slant(
        draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data
    )
    if is_last:
        draw_right_status(tab, screen)
    return screen.cursor.x
