#! /bin/bash
# Use fd 12 as the lock
[ -v MCEDITOR_INC_input ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Input header loaded'
	MCEDITOR_INC_input=
	. "$dirp"/operate.sh
	. "$dirp"/fifo.sh
	function InputThread {
		while read inputop <&12;do
			[ "$inputop" == E ] && {
				echo 'Input Thrad Ended' >&2
				break
			}
			[ "$inputop" == I ] && {
				# Inventory Mode
				read -N 1 op
				case "$op" in

				esac
				continue
			}
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
				']') echo 'UseBlock' ;;
				' ') echo 'Jump' ;;
				[1-9] ) echo 'SwitchHotbar '"$[op-1]";;
				'[') echo 'Dig' ;;
				$'\e') Input_ParseEscape ;;
				/) echo 'Command';;
				*) echo 'Nothing' ;;
			esac
			read -N 2147483647 -t 0.03
		done
		[ "$MCEDITOR_dbgl" -ge 1 ] && echo 'Input Thrad Ended' >&2
	}
	function Input_ParseEscape {
		local op=
		read -N 1 -t 0.05 op
		case "$op" in
			'[')
				read -N 1 -t 0.05 op
				case "$op" in
					A) echo MoveUpwards ;;
					B) echo MoveDownwards ;;
					D) echo MoveLeft ;;
					C) echo MoveRight ;;
				esac
		esac
	}
}
