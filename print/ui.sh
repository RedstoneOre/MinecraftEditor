
#! /bin/bash
[ -v MCEDITOR_INC_print_ui ] || {
	[ "$debug" -ge 2 ] && echo 'UIs loaded'
	MCEDITOR_INC_print_ui=
}
