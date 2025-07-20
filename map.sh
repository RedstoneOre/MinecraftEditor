#! /bin/bash
[ -v MCEDITOR_INC_map ] || {
	[ "$debug" -ge 1 ] && echo 'Map header loaded'
	MCEDITOR_INC_map=
	declare -A lines
	declare -A fc

	function getCharOnPos {
		echo -n "${fc["$dim.$2.$1"]:-OOT}"
	}
}
