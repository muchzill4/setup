from kitty.fast_data_types import Screen, get_boss, current_os_window
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    draw_tab_with_slant,
)


def get_session_name() -> str:
    id = current_os_window()
    boss = get_boss()
    name = boss.os_window_map.get(id).wm_name
    return name


def draw_right_status(
    screen: Screen,
    is_last: bool,
) -> int:
    if not is_last:
        return screen.cursor.x
    right_status = f"{get_session_name()} "
    right_status_length = len(right_status)
    screen.cursor.x = max(screen.cursor.x, screen.columns - right_status_length)
    screen.cursor.bg = 0
    screen.cursor.bold = False
    screen.draw(right_status)
    return screen.cursor.x


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
    draw_right_status(screen, is_last)
    return screen.cursor.x
