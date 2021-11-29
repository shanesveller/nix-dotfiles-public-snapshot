# Defined in /var/folders/tb/t9gk472j3yv0zmj88kdkygdm0000gn/T//fish.dTDm8e/sortvars.fish @ line 1
function sortvars
	grep variable $argv | sort -c
end
