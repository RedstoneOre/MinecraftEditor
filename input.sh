#! /bin/bash
# Use fd 12 as te lock
[ -v MCEDITOR_INC_input ] || {
	[ "$debug" -ge 1 ] && echo 'Input header loaded'
	MCEDITOR_INC_input=
	. "$dirp"/operate.sh
	inputtmpfifo="$dirp"/tmp/$$.fifo
	mkfifo "$inputtmpfifo"
	exec 12<> "$inputtmpfifo"
	rm "$inputtmpfifo"
	function InputThread {
		while read inputop <&12;do
			[ "$inputop" == end ] && break
			read -N 1 op
			case "$op" in
				w) echo 'Operate_MoveUpwards' ;;
				a) echo 'Operate_MoveLeft' ;;
				s) echo 'Operate_MoveDownwards' ;;
				d) echo 'Operate_MoveRight' ;;
				i) echo 'Operate_MoveFocusUpwards' ;;
				j) echo 'Operate_MoveFocusLeft' ;;
				k) echo 'Operate_MoveFocusDownwards' ;;
				l) echo 'Operate_MoveFocusRight' ;;
				' ') echo 'Operate_Jump' ;;
				[1-9] ) echo 'Operate_SwitchHotbar '"$[op-1]";;
				'[') echo 'Operate_Dig' ;;
				']') echo 'Operate_Place' ;;
				*) echo 'Operate_Nothing' ;;
			esac
			read -N 2147483647 -t 0.03
		done
	}
}
