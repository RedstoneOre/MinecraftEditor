#! /bin/bash
[ -v MCEDITOR_INC_dimension ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Dimension header loaded'
	MCEDITOR_INC_dimension=
	. "$dirp"/map.sh
	. "$dirp"/heap.sh
	unset dim2num num2dim dimfile dimidcnt
	declare -g -A dim2num=
	num2dim=() dimfile=()
	dimidcnt=0
	# NewDimension <name> <file>
	#  Register a new dimension
	function NewDimension {
		local newid=$((dimidcnt++))
		dim2num[d"$1"]=$newid
		num2dim[$newid]="$1"
		dimfile[$newid]="$2"
		# create heap
		heap_init fcm$newid
	}
	# DeleteDimension <name>
	#  Deregister a dimension and delete its data
	function DeleteDimension {
		# (Not Completed qwq)
		# Delete dimension data
		local did="${dim2num[d"$1"]}"
		unset dim2num[d"$1"] num2dim[$did] dimfile[$did]
		heap_delete fcm$newid
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
