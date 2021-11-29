function read_confirm
  while true
    read -p 'echo "Confirm? (y/n):"' -l confirm

    switch $confirm
      case Y y
        return 0
      case '' N n
        return 1
    end
  end
end
