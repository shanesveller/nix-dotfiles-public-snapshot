function erldident --argument imageName
    docker inspect --format='{{index .RepoDigests 0}}' $imageName
    docker run -it --rm $imageName sh -c "elixir -v"
    docker run -it --rm $imageName sh -c "erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), \"releases\", erlang:system_info(otp_release), \"OTP_VERSION\"])), io:fwrite(Version), halt().' -noshell"
    docker run -it --rm $imageName sh -c "cat /etc/issue"
end
