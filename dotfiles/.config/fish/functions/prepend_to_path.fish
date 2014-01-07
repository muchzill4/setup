function prepend_to_path
  if not contains $argv $PATH
    set -x PATH $argv $PATH
  end
end
