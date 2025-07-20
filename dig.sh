#! /bin/bash
[ -v MCEDITOR_INC_dig ] || {
	[ "$debug" -ge 1 ] && echo 'Digging header loaded'
	MCEDITOR_INC_dig=
	dix=0 diy=0 dip=0
	function dig {
		[ "$dix" == "$1" ] && [ "$diy" == "$2" ] && {
			dip="$[dip+1]"
			[ "$dip" -ge "$(getHardness `getCharOnPos "$dix" "$diy"`)" ] && {
				dip=0
				CreateEntity $ENTITY_ITEM "1#${fc["$dim.$diy.$dix"]}" "$dix" "$diy" "$dim"
				fc["$dim.$diy.$dix"]=' '
			}
			true
		} || {
			dix="$1" diy="$2" dip=0
		}
	}
	function movedig {
		tpx="$1" tpy="$2"
		[ "$3" == s ] && {
			true
		} || {
			tpx="$[$1+dix]" tpy="$[$2+diy]"
		}
		[ "$tpx" -ge "$[px-2]" ] && [ "$tpx" -le "$[px+2]" ] &&
		[ "$tpy" -ge "$[py-2]" ] && [ "$tpy" -le "$[py+2]" ] && {
			dix="$tpx" diy="$tpy"
			return 0
		}
		return 1
	}
}
