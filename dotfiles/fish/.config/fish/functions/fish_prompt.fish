# https://github.com/jorgebucaran/hydro/blob/75ab7168a35358b3d08eeefad4ff0dd306bd80d4/functions/fish_prompt.fish
function fish_prompt --description Hydro
    echo -e "$_hydro_color_start$hydro_symbol_start$hydro_color_normal$_hydro_color_pwd$_hydro_pwd$hydro_color_normal $_hydro_color_git$$_hydro_git$hydro_color_normal$_hydro_color_duration$_hydro_cmd_duration$hydro_color_normal$_hydro_status$hydro_color_normal "
end
