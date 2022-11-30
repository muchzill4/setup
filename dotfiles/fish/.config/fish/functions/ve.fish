function ve -d "Execute in python venv"
  source .venv/bin/activate.fish
  if count $argv > /dev/null
    $argv
    deactivate
  else
    echo "Empty \$argv"
    deactivate
    return 1
  end
end
