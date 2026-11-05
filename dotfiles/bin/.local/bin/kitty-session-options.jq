# Produce session lines for kitty-projects from `kitty @ ls` output.
# Arguments: $prefix, $bell_icon, $osc_7501_status_icons
#
# Input:  `kitty @ ls` JSON (array of OS windows)
# Output: one line per OS window, e.g.:
#   + kitty
#   + my/setup [🔄 osc]
#   + work/api [❌ build, 🔄 deploy]
#   + misc/notes [🔔 ~]

def urgency:
  {"idle": 0, "working": 1, "done": 2, "error": 3, "blocked": 4}[.] // 0;

def notable_windows:
  [ .tabs[].windows[] | . as $w
    | (.program_status[0] // empty) as $ps
    | select($ps.state | urgency > 0)
    | (if $ps.app != "" then $ps.app else null end) as $app_label
    | { label: ([$app_label, $ps.msg] | map(select(. and . != "")) | join(" - ") // $w.title // ""),
        icon:  $osc_7501_status_icons[$ps.state],
        urgency: ($ps.state | urgency) }
  ];

def status_summary:
  sort_by(-.urgency)
  | map(.icon + " " + .label)
  | join(", ");

def bell_windows:
  [ .tabs[].windows[]
    | select(.needs_attention)
    | $bell_icon + " " + .title
  ];

def suffix:
  notable_windows as $notable |
  if ($notable | length) > 0
  then " [" + ($notable | status_summary) + "]"
  else
    bell_windows as $bells |
    if ($bells | length) > 0
    then " [" + ($bells | join(", ")) + "]"
    else ""
    end
  end;

.[] | $prefix + .wm_name + suffix
