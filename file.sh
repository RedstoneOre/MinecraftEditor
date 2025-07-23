#! /bin/bash
[ -v MCEDITOR_INC_file ] || {
	[ "$debug" -ge 2 ] && echo 'File loading header loaded'
	MCEDITOR_INC_file=
	. "$dirp"/espmap.sh
	# Read_File <Dimension> < (standard input)
	#  Read a file into a dimension
	function Read_File {
		readfileend=0
		rdim="${1:-0}"
		for((i=0;;++i));do
			fc["$rdim.$i.0"]='BOL'
			for((j=1;;));do
				read -n 1 -d $'\0' tfc || {
					readfileend=1
					break
				}
				[ "$tfc" == $'\n' ] && break
				mceespace "$tfc"
				for((k=0;k<"${#tfcres[@]}";++k));do
					fc["$rdim.$i.$j"]="${tfcres[k]}"
					j="$[j+1]"
				done
			done
			[ "$readfileend" == 1 ] && break
			fc["$rdim.$i.c"]="$j"
		done
		lines[$rdim]="$i"
	}
	# Save_File <Dimension> > (output)
	#  Save a dimension to a file
	function Save_File {
		savefdim="${1:-0}"
		
	}
}
