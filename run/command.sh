
#! /bin/bash
[ -v MCEDITOR_INC_command ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Command parsing loaded'
	MCEDITOR_INC_command=
	. "$dirp"/dimension.sh
	function RunCommand {
		dim=`GetDimensionID "$cmd"`
	}
}
