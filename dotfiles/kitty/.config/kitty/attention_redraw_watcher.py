import sys
from os.path import dirname
from typing import Any

from kitty.boss import Boss
from kitty.window import Window

# Kitty loads this file with runpy, without adding its directory to sys.path.
sys.path.insert(0, dirname(__file__))
try:
    from attention_state import needs_attention
finally:
    sys.path.pop(0)

needs_attention_by_os_window: dict[int, bool] = {}


def on_tab_bar_dirty(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    """Global watcher: kitty redraws only the tab bar of the OS window that changed,
    so redraw the others when this OS window's attention state changes."""
    tab_manager = data["tab_manager"]
    attention = needs_attention(tab_manager.list_tabs())
    if needs_attention_by_os_window.get(tab_manager.os_window_id) == attention:
        return
    needs_attention_by_os_window[tab_manager.os_window_id] = attention
    for other in boss.all_tab_managers:
        if other is not tab_manager:
            other.mark_tab_bar_dirty()


def on_close(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    """Global watcher: closing an OS window doesn't trigger on_tab_bar_dirty,
    so redraw the remaining ones if the closed OS window needed attention."""
    open_os_window_ids = {
        tab_manager.os_window_id for tab_manager in boss.all_tab_managers
    }
    closed_os_window_ids = needs_attention_by_os_window.keys() - open_os_window_ids
    closed_attention = [
        needs_attention_by_os_window.pop(id) for id in closed_os_window_ids
    ]
    if not any(closed_attention):
        return
    for tab_manager in boss.all_tab_managers:
        tab_manager.mark_tab_bar_dirty()
