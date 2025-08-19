#! /bin/bash
[ -v MCEDITOR_INC_print_window ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Window Infos & OPs loaded'
	MCEDITOR_INC_print_window=
	unset winX winY
	# getWindowSize
	#  Set winX to the window width and winY to the window height
	function getWindowSize {
		IFS=' '
		read winY winX < <(stty size)
		IFS=
		winX="${winX:-20}" winY="${winY:-20}"
	}
}
