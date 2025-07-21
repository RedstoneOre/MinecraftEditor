#! /bin/bash
[ -v MCEDITOR_INC_block ] || {
	[ "$debug" -ge 1 ] && echo 'Block interacting header loaded'
	MCEDITOR_INC_block=
	focx=0 focy=0 dip=0
	function dig {
		[ "$focx" == "$1" ] && [ "$focy" == "$2" ] && {
			dip="$[dip+1]"
			[ "$dip" -ge "$(getHardness `getCharOnPos "$focx" "$focy"`)" ] && {
				dip=0
				CreateEntity $ENTITY_ITEM `GetItemEntityData ${fc["$dim.$focy.$focx"]}` "$focx" "$focy" "$dim"
				fc["$dim.$focy.$focx"]=' '
			}
			true
		} || {
			focx="$1" focy="$2" dip=0
		}
	}
	# place <x> <y> <Char>
	function place {
		fc["$dim.$2.$1"]="$3"
	}
	function movefocus {
		tpx="$1" tpy="$2"
		[ "$3" == s ] && {
			true
		} || {
			tpx="$[$1+focx]" tpy="$[$2+focy]"
		}
		[ "$tpx" -ge "$[px-2]" ] && [ "$tpx" -le "$[px+2]" ] &&
		[ "$tpy" -ge "$[py-2]" ] && [ "$tpy" -le "$[py+2]" ] && {
			focx="$tpx" focy="$tpy"
			return 0
		}
		return 1
	}
}
