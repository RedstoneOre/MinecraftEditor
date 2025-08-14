#! /bin/bash
[ -v MCEDITOR_INC_map ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Map header loaded'
	MCEDITOR_INC_map=
	. "$dirp"/heap.sh
	unset lines fc fcn fcp fcu fcd fcdelid
	declare -A lines
	declare -A fc fcn fcp fcu fcd
	declare -A fcdelid; fcidc=0
	# _newCharID
	function _newCharID {
		[ "${#fcdelid[@]}" -gt 0 ] && {
			echo -n "${fcdelid[-1]}"
			unset 'fcdelid[-1]'
			true
		} || {
			echo -n "$fcidc"
			fcidc="$[fcidc+1]"
		}
	}
	# setChar <x> <y> <Char>
	function setChar {
		[ "$3" == OOT ] && {
			[ -v fc["$dim#$2.$1"] ] && {
				unset fc["$dim#$2.$1"]
				heap_delete_val fcm$dim "$1.$2"
			}
			true
		} || {
			[ -v fc["$dim#$2.$1"] ] || {
				heap_insert fcm$dim "$1.$2"
			}
			fc["$dim.$2.$1"]="$3"
		}
	}
	false && {
		sposid="$1"
		[ "$2" != OOT ] && {
			fc["$dim#$sposid"]="$2"
			true
		} || {
			unset fc["$dim#$sposid"]
			fcdelid[${#fcdelid[@]}]="$1"
		}
	}
	# getChar <PosID>
	function getChar {
		echo -n "${fc["$dim#$2.$1"]:-OOT}"
	}
	# matchChar <x> <y> <Char>
	function matchChar {
		[ `getChar "$1" "$2"` == "$3" ]
	}
	# getChar <PosID> <offsetx> <offsety>
	function getCharID {
		:
	}
	function move {
		tpx="$[$1+px]" tpy="$[$2+py]"
		[ "${fc["$dim#$tpy.$tpx"]:-OOT}" != OOT ] && {
			px="$tpx" py="$tpy"
			return 0
		}
		return 1
	}
}
