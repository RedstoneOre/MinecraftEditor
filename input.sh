#! /bin/bash
# Use fd 12 as te lock
[ -v MCEDITOR_INC_input ] || {
	[ "$debug" -ge 2 ] && echo 'Input header loaded'
	MCEDITOR_INC_input=
	. "$dirp"/operate.sh
	inputtmpfifo="$dirp"/tmp/$$.fifo
	mkfifo "$inputtmpfifo"
	exec 12<> "$inputtmpfifo"
	rm "$inputtmpfifo"
	function InputThread {
		# trap '' SIGINT
		while read inputop <&12;do
			[ "$inputop" == E ] && break
			read -N 1 op
			case "$op" in
				w) echo 'MoveUpwards' ;;
				a) echo 'MoveLeft' ;;
				s) echo 'MoveDownwards' ;;
				d) echo 'MoveRight' ;;
				i) echo 'MoveFocusUpwards' ;;
				j) echo 'MoveFocusLeft' ;;
				k) echo 'MoveFocusDownwards' ;;
				l) echo 'MoveFocusRight' ;;
				'\') echo 'UseBlock' ;;
				' ') echo 'Jump' ;;
				[1-9] ) echo 'SwitchHotbar '"$[op-1]";;
				'[') echo 'Dig' ;;
				']') echo 'Place' ;;
				*) echo 'Nothing' ;;
			esac
			read -N 2147483647 -t 0.03
		done
	}
}
