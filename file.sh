#! /bin/bash
[ -v MCEDITOR_INC_file ] || {
	[ "$debug" -ge 1 ] && echo 'File loading header loaded'
	MCEDITOR_INC_file=
	# Read_File <Dimension> < (standard input)
	#  Read a file into a dimension
	function Read_File {
		rdim="${1:-0}"
		for((i=0;;++i));do
			read fc[$i] || break
			fc["$rdim.$i.0"]='BOL'
			for((j=1;;));do
				read -N 1 tfc || break
				tfcres=()
				case "$tfc" in
					$'\t') tfcres=( SOT POT POT POT POT POT POT EOT ) ;;
					*) tfcres=( "$tfc" ) ;;
				esac
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
