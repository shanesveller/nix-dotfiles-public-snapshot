function exguard
	set -q TEST_DATABASE_URL; and set -x DATABASE_URL $TEST_DATABASE_URL
	watchexec -c -e 'ex,exs,lock,eex' -- mix $argv
end
