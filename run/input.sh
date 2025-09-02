#! /bin/bash
# Use fd 12 as the lock
[ -v MCEDITOR_INC_input ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Input header loaded'
	MCEDITOR_INC_input=
	. "$dirp"/operate.sh
	. "$dirp"/fifo.sh
	function InputThread {
		trap '' SIGINT
		while :;do
			read inputop <&12 || inputop=E
			[ "$inputop" == E ] && {
				echo 'Input Thrad Ended' >&2
				break
			}
			[ "$inputop" == I ] && {
				# Inventory Mode
				read -N 1 op
				case "$op" in
					\[) echo 'InvLC' ;;
					\]) echo 'InvRC' ;;
					$'\033') Input_InvParseEscape ;;
					$'\035') echo 'InvCRC' ;;
					\{) echo 'InvSLC' ;;
					\}) echo 'InvSRC' ;;
					[1-9]) echo 'InvSwithHotbar '"$[op-1]" ;;
					[eq]) echo 'InvClose' ;;
					*) echo '' ;;
				esac
				true
			} || {
				op=
				echo Start Reading OP>&2
				while ! read -t 0.05 <&12;do
					echo Reading OP "$op">&2
					[ "$op" ] || read -N 1 -t 0.05 op
				done
				echo Operate OP "$op">&2
				case "$op" in
					w) echo 'MoveUpwards' ;;
					a) echo 'MoveLeft' ;;
					s) echo 'MoveDownwards' ;;
					d) echo 'MoveRight' ;;
					i) echo 'MoveFocusUpwards' ;;
					j) echo 'MoveFocusLeft' ;;
					k) echo 'MoveFocusDownwards' ;;
					l) echo 'MoveFocusRight' ;;
					e) echo 'OpenInventory' ;;
					q) echo 'Leave' ;;
					']') echo 'UseBlock' ;;
					' ') echo 'Jump' ;;
					[1-9] ) echo 'SwitchHotbar '"$[op-1]";;
					'[') echo 'Dig' ;;
					$'\e') Input_ParseEscape ;;
					/) echo 'Command';;
					*) echo 'Nothing' ;;
				esac
			}
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
				esac ;;
		esac
	}
	function Input_InvParseEscape {
		local op=
		read -N 1 -t 0.05 op
		case "$op" in
			'[')
				read -N 1 -t 0.05 op
				case "$op" in
					A) echo InvMU ;;
					B) echo InvMD ;;
					D) echo InvML ;;
					C) echo InvMR ;;
				esac ;;
			'')
				echo InvCLC ;;
		esac
	}
}
