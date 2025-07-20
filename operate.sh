#! /bin/bash
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
	movedig 0 -1; opsuc=1
}
function Operate_MoveFocusLeft {
	movedig -1 0; opsuc=1
}
function Operate_MoveFocusDownwards {
	movedig 0 1; opsuc=1
}
function Operate_MoveFocusRight {
	movedig 1 0; opsuc=1
}

function Operate_Nothing {
	opsuc=1
}
function Operate_Dig {
	dig "$dix" "$diy" && {
		opsuc=1;isdig=1
	}
}
