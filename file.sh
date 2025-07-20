#! /bin/bash
[ -v MCEDITOR_INC_file ] || {
	[ "$debug" -ge 1 ] && echo 'File loading header loaded'
	MCEDITOR_INC_file=
	. "$dirp"/espmap.sh
	# Read_File <Dimension> < (standard input)
	#  Read a file into a dimension
	function Read_File {
		rdim="${1:-0}"
		for((i=0;;++i));do
			read fc[$i] || break
			fc["$rdim.$i.0"]='BOL'
			for((j=1;;));do
				read -n 1 -d $'\0' tfc || break
				mceespace "$tfc"
				for((k=0;k<"${#tfcres[@]}";++k));do
					fc["$rdim.$i.$j"]="${tfcres[k]}"
					j="$[j+1]"
				done
			done < <(echo -n "${fc[$i]}")
			fc["$rdim.$i.c"]="$j"
		done
		lines[$rdim]="$i"
	}
}
