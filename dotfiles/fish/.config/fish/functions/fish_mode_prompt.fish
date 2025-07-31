# https://github.com/jorgebucaran/hydro/blob/75ab7168a35358b3d08eeefad4ff0dd306bd80d4/functions/fish_mode_prompt.fish
function fish_mode_prompt
    if test "$fish_key_bindings" != fish_default_key_bindings
        set --local vi_mode_color
        set --local vi_mode_symbol
        switch $fish_bind_mode
            case default
                set vi_mode_color (set_color $fish_color_selection)
                set vi_mode_symbol N
            case insert
                set vi_mode_color (set_color $fish_color_selection)
                set vi_mode_symbol I
            case replace replace_one
                set vi_mode_color (set_color $fish_color_match)
                set vi_mode_symbol R
            case visual
                set vi_mode_color (set_color $fish_color_match)
                set vi_mode_symbol V
        end
        echo -e "$vi_mode_color $vi_mode_symbol \x1b[0m "
    end
end
