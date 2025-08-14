#! /bin/bash
[ -v MCEDITOR_INC_dimension ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'dimension loaded'
	MCEDITOR_INC_dimension=
	. "$dirp"/map.sh
	declare -g -A dim2num=
	num2dim=()
	dimidcnt=0
	# NewDimension <name>
	#  Register a new dimension
	function NewDimension {
		local newid=$((dimidcnt++))
		dim2num[d"$1"]=$newid
		num2dim[$newid]="$1"
	}
	# DeleteDimension <name>
	#  Deregister a dimension and delete its data
	function DeleteDimension {
		# (Not Completed qwq)
		# Delete dimension data
		local did="${dim2num[d"$1"]}"
		unset dim2num[d"$1"] num2dim[$did]
	}
	# GetDimensionID <name>
	function GetDimensionID {
		[ -v dim2num[d"$1"] ] || return 1
		echo -n "${dim2num[d"$1"]}"
	}
	# GetDimensionName <did>
	function GetDimensionName {
		{ [ "$1" -ge 0 ] 2>/dev/null && [ -v num2dim[$1] ] ;} || return 1
		echo -n "${num2dim[$1]}"
	}
}
