function ed
  eval cd (emacsclient -e "(with-current-buffer (car (buffer-list)) (expand-file-name default-directory))")
end
