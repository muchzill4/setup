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
    return (
        os_window_tab["id"] == drawn_tab.tab_id
        and os_window_tab["title"] == drawn_tab.title
    )


# This is a bit jank, but it seems kitty doesn't expose the information about what os window we're drawing the tab bar for.
# So, the only way to identify the os window the tab bar is drawn for is to compare its tabs.
# Here, I'm only using the last tab to find a matching os window.
def find_matching_os_window(last_tab: TabBarData) -> OSWindowDict:
    boss = get_boss()
    os_windows = boss.list_os_windows()
    for os_window in os_windows:
        last_os_window_tab = os_window["tabs"][-1]
        if is_same_tab(last_tab, last_os_window_tab):
            return os_window


def draw_right_status(
    last_tab: TabBarData,
    screen: Screen,
):
    os_window = find_matching_os_window(last_tab)

    right_status = f"{os_window['wm_name']} "
    right_status_length = len(right_status)

    screen.cursor.x = max(screen.cursor.x, screen.columns - right_status_length)
    screen.cursor.bg = 0
    screen.cursor.bold = False
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
