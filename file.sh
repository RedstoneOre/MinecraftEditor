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
				read -r -n 1 -d $'\0' tfc || {
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
	# Save_File <Dimension> > (output)
	#  Save a dimension to a file
	function Save_File {
		local unkespmsg='(What is this fucking char?)'
		ldim=$dim
		dim="${1:-0}"
		heap_copy fcm$dim fcmsave
		local charp= char= espst=0 espc=() esps= esprs= started=0
		while [ `heap_getsize fcmsave` -gt 0 ]; do
			charp=`heap_gettop fcmsave`
			char=`getChar ${charp//.*/} ${charp//*./}`
			heap_pop fcmsave
			case "$espst" in
				0) 
					case "${char:-OOT}" in
						BOL) 
							[ "$started" == 1 ] && echo
							started=1 ;;
						OOT) ;;
						ESP) espst=1 ;;
						ELB) espst=2 ;;
						ERB) ;;
						SOT) espst=3 ;;
						POT) echo -n $'\t' ;;
						EOT) echo -n $'\t' ;;
						*) echo -n "$char" ;;
					esac ;;
				1)
					esprs="${unesp["e$char"]:-"$unkespmsg"}"
					[ "$esprs" == 'NUL' ] && {
						echo -n $'\0'
					} || {
						echo -n "$esprs"
					}
					espst=0 ;;
				2)
					[ "$char" == 'ERB' ] && {
						esps=`_file_connect_str "${espc[@]}"`
						esprs="${unesp["e$esps"]:-"$unkespmsg"}"
						[ "$esprs" == 'NUL' ] && {
							echo -n $'\0'
							true
						} || {
							echo -n "$esprs"
						}
						espst=0 espc=() esps=
						true
					} || {
						espc[${#espc[@]}]="$char"
					} ;;
					3)
						[ "$char" == 'EOT' ] && {
							echo -n $'\t'
							espst=0
						}
				esac
		done
		dim=$ldim
	}
}
