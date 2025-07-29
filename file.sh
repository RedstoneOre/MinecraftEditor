#! /bin/bash
[ -v MCEDITOR_INC_file ] || {
	[ "$debug" -ge 2 ] && echo 'File loading header loaded'
	MCEDITOR_INC_file=
	. "$dirp"/map.sh
	. "$dirp"/espmap.sh
	# Read_File <Dimension> < (standard input)
	#  Read a file into a dimension
	function Read_File {
		readfileend=0
		ldim=$dim
		dim="${1:-0}"
		heap_init fcm$dim
		local i= j=
		for((i=0;;++i));do
			setChar 0 $i 'BOL'
			for((j=1;;));do
				read -n 1 -d $'\0' tfc || {
					readfileend=1
					break
				}
				[ "$tfc" == $'\n' ] && break
				mceespace "$tfc"
				for((k=0;k<"${#tfcres[@]}";++k));do
					setChar $j $i "${tfcres[k]}"
					(( ++j ))
				done
			done
			[ "$readfileend" == 1 ] && break
		done
		lines[$dim]="$i"
		dim=$ldim
	}
	function _file_connect_str {
		local i=
		for i;do echo -n "$i"; done
	}
}
