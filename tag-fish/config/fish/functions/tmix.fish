function tmix
	set -q TEST_DATABASE_URL; and set -x DATABASE_URL $TEST_DATABASE_URL
	env MIX_ENV=test mix $argv
end
