#! /bin/bash
[ -v MCEDITOR_INC_operate ] || {
	[ "$debug" -ge 1 ] && echo 'Operations loaded'
	MCEDITOR_INC_operate=
	. "$dirp"/map.sh
	. "$dirp"/block.sh
	function Operate_MoveUpwards {
		[ `getCharOnPos "$px" "$[py-1]"` != BOL ] && {
			move 0 -1; ismove=1
			opsuc=1
		}
	}
	function Operate_MoveLeft {
		move -1 0; ismove=1;opsuc=1
	}
	function Operate_MoveDownwards {
		move 0 1; ismove=1;opsuc=1
	}
	function Operate_MoveRight {
		move 1 0; ismove=1;opsuc=1
	}
	function Operate_Jump {
		[ "$power" -ge 20 ] && {
			[ `getCharOnPos "$px" "$[py-1]"` != BOL ] && move 0 -1
			canceldrop="$[canceldrop+1]"
			power="$[power-20]"
			opsuc=1 ismove=1
		}
	}

	function Operate_MoveFocusUpwards {
		movefocus 0 -1; opsuc=1
	}
	function Operate_MoveFocusLeft {
		movefocus -1 0; opsuc=1
	}
	function Operate_MoveFocusDownwards {
		movefocus 0 1; opsuc=1
	}
	function Operate_MoveFocusRight {
		movefocus 1 0; opsuc=1
	}

	function Operate_Nothing {
		opsuc=1
	}
	function Operate_SwitchHotbar {
		lselhotbar="$selhotbar" selhotbar="$1"
		opsuc=1
	}
	function Operate_Dig {
		 [ `getCharOnPos "$focx" "$focy"` != ' ' ] && dig "$focx" "$focy" && {
			opsuc=1;isdig=1
		}
	}
	function Operate_Place {
		[ "${invc["$selhotbar"]}" -ge 1 ] && {
			place "$focx" "$focy" "${inv["$selhotbar"]}" && {
				InvTake "$selhotbar" 1
				opsuc=1 isdig=1
			}
		}
	}
}
