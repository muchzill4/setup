# Some stuff stolen from pure prompt
function __git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function __is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _git_status
  set -l git_info ''
  if test (__git_branch_name)
    set -l git_branch (__git_branch_name)
    set git_info $git_branch

    if test (__is_git_dirty)
      set -l dirty "*"
      set git_info "$git_info$dirty"
    end
  end
  echo $git_info
end

function _remote_user_host
  set -l user_host ''
  if test $SSH_CONNECTION
    set -l user (whoami)
    set -l host (hostname)
    set user_host " $user@$host"
  end
  echo "$user_host"
end

function __prompt_command_not_found_handler --on-event fish_command_not_found
  set -g prompt_arrow_not_found 1
end

function __prompt_arrow_status
  if set -q prompt_arrow_not_found
    set -e prompt_arrow_not_found
    return 1
  else
    if test "$es" = 1
      return 1
    else
      return 0
    end
  end
end

function fish_prompt
  # FIXME: I think this is required for prompt arrow to get last command success.
  set -g es $status

  set -l cyan (set_color cyan)
  set -l normal (set_color normal)
  set -l blue (set_color blue)
  set -l red (set_color red)
  set -l white (set_color white)

  if __prompt_arrow_status
    set arrow_color "$white"
  else
    set arrow_color "$red"
  end

  printf '\n%s%s%s%s %s%s\n%s%s %s' $blue (prompt_pwd) $cyan (_remote_user_host) $cyan (_git_status) $arrow_color "▸" $normal
end
