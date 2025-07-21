#! /bin/bash
[ -v MCEDITOR_INC_map ] || {
	[ "$debug" -ge 1 ] && echo 'Map header loaded'
	MCEDITOR_INC_map=
	declare -A lines
	declare -A fc

	function getCharOnPos {
		echo -n "${fc["$dim.$2.$1"]:-OOT}"
	}
	function move {
		tpx="$[$1+px]" tpy="$[$2+py]"
		[ "${fc["$dim.$tpy.$tpx"]:-OOT}" != OOT ] && {
			px="$tpx" py="$tpy"
			return 0
		}
		return 1
	}
}
