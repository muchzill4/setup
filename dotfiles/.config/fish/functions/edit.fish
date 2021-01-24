function edit -d "edit using nvim with obsession"
    set -l cmd nvim
    if test (count $argv) -gt 0
      set cmd nvim $argv
    else if test -f Session.vim
      set cmd nvim -S
    end
    command $cmd
end
