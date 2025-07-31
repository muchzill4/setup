from kitty.fast_data_types import Screen, get_boss
from kitty.tabs import TabDict
from kitty.boss import OSWindowDict
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    draw_tab_with_slant,
)


def is_same_tab(drawn_tab: TabBarData, os_window_tab: TabDict) -> bool:
    return os_window_tab["id"] == drawn_tab.tab_id


def find_matching_os_window(last_tab: TabBarData) -> OSWindowDict:
    for os_window in get_boss().list_os_windows():
        last_os_window_tab = os_window["tabs"][-1]
        if is_same_tab(last_tab, last_os_window_tab):
            return os_window


def draw_right_status(
    last_tab: TabBarData,
    screen: Screen,
):
    os_window = find_matching_os_window(last_tab)
    right_status = f" {os_window['wm_name']} "
    right_status_length = len(right_status)

    padding = screen.columns - right_status_length - screen.cursor.x
    screen.cursor.bg = 0
    screen.cursor.bold = False
    screen.draw(" " * padding)
    screen.draw(right_status)


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
    draw_tab_with_slant(
        draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data
    )
    if is_last:
        draw_right_status(tab, screen)
    return screen.cursor.x
