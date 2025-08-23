#! /bin/bash
[ -v MCEDITOR_INC_print_window ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Window Infos & OPs loaded'
	MCEDITOR_INC_print_window=
	. "$dirp"/base/check.sh
	unset winX winY
	# getWindowSize
	#  Set winX to the window width and winY to the window height
	function getWindowSize {
		IFS=' '
		read winY winX < <(stty size)
		IFS=
		winX="${winX:-20}" winY="${winY:-20}"
	}
	# getCursorPos
	#  Must make stdin, stdout /dev/tty
	# Set curX to the cursor X and curY to the cursor y
	function getCursorPos {
		read -N 2147483647 -t 0.03
		echo -n $'\e[6n'
		read -d $'['
		curX= curY=
		read -d ';' curY
		read -d 'R' curX
		IsNumber "$curX" || curX=0
		IsNumber "$curY" || curY=0
	}
}
