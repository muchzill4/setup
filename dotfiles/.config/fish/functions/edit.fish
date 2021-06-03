function edit -d "edit using nvim with obsession"
    if test (count $argv) -gt 0
      command nvim $argv
    else if test -f Session.vim
      command nvim -S
    else
      command nvim
    end
end
