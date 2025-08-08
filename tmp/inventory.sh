#! /bin/bash
[ -v MCEDITOR_INC_inventory ] || {
	[ "$debug" -ge 2 ] && echo 'Inventory header loaded'
	MCEDITOR_INC_inventory=
	inv=() invc=() invdispcache=() invsize=45 selhotbar=0 lselhotbar=-1
	for((i=0;i<invsize;++i));do
		inv[i]='' invc[i]=0 invdispcache[i]=''
	done
	# InvPick <Container> <Type> <Count>
	#  pickup item
	#  return invPickRemaining as the remaining count
	function InvPick {
		local cnt="${3:-1}"
		declare -n _inv="$1"
		declare -n _invc="${1}c"
		declare -n _invdispcache="${1}dispcache"
		for((invi=0;invi<invsize;++invi));do
			invmaxstack=64
			[ "${_inv[invi]:-$2}" == "$2" ] && [ "${_invc[invi]}" -lt "$invmaxstack" ] && {
				_invdispcache[invi]=''
				_inv[invi]="$2"
				_invc[invi]="$[${_invc[invi]}+cnt]"
				[ "${_invc[invi]}" -gt "$invmaxstack" ] && {
					cnt="$[${_invc[invi]}-invmaxstack]"
					_invc[invi]="$invmaxstack"
					true
				} || {
					break
				}
			}
		done
		invPickRemaining="$cnt"
	}
	# InvTake <Slot> <Num>
	#  return if successfully take the items
	#  when fail, do nothing
	function InvTake {
		declare -n _inv="$1"
		declare -n _invc="${1}c"
		declare -n _invdispcache="${1}dispcache"
		[ "${_invc[$1]}" -ge "$2" ] && {
			_invdispcache[$1]=''
			_invc[$1]="$[${_invc[$1]}-$2]"
			[ "${_invc[$1]}" == 0 ] && {
				_inv[$1]=''
			}
			return 0
		}
		return 1
	}
	# InvAdd <Slot> <Type> <Num>
	#  Add some item to a slot
	#  return fail if cannot add(type not match or too much to add) then do nothing
	function InvAdd {
		declare -n _inv="$1"
		declare -n _invc="${1}c"
		declare -n _invdispcache="${1}dispcache"
		invmaxstack=64
		[ "${_inv[$1]:-$2}" == "$2" ] && [ "$[${_invc[$1]}+$3]" -le "$invmaxstack" ] && {
			_invdispcache[$1]=''
			_invc[$1]="$[${_invc[$1]}+$3]"
			_inv[$1]="$2"
			return 0
		}
		return 1
	}

	# InvSwap <Slot1> <Slot2>
	function InvSwap {
		declare -n _inv="$1"
		declare -n _invc="${1}c"
		declare -n _invdispcache="${1}dispcache"
		_invdispcache[$1]=0 _invdispcache[$2]=0
		invcswtmp="${_invc[$1]}" invswtmp="${_inv[$1]}"
		_invc[$1]="${_invc[$2]}" _inv[$1]="${_inv[$2]}"
		_invc[$2]="$invcswtmp" _inv[$2]="$invswtmp"
	}
	# DescribeItem <Type> <Num> <Tags>
	#  output the item describtion
	function DescribeItem {
		[ "$2" -gt 1 ] && echo -n "$2 * "
		dscItem="${1:-NDC}"
		[ "$1" == ' ' ] && dscItem='VSP'
		PrintChar "$dscItem" "$3" "$defaultstyle"
	}
	# ShowInventory 
	function ShowInventory {
		declare -n _inv="$1"
		declare -n _invc="${1}c"
		declare -n _invdispcache="${1}dispcache"
		local warp=9
		[ "$selhotbar" != "$lselhotbar" ] && {
			_invdispcache[selhotbar]='' _invdispcache[lselhotbar]=''
		}
		echo -n $'Inventory:\e[K'
		local i=
		for((i=0;i<invsize;++i));do
			[ "$[i%warp]" == 0 ] && echo -n $'\n\e[K'
			[ "${_invdispcache[i]}" == '' ] && {
				{ # Just DescribeItem but it's so slow to call the func
					local sinvtgitem="$(
						dscItem="${_inv[i]:-NDC}" dscCnt="${_invc[i]}"  dscTag=` [ "$selhotbar" == "$i" ] && { echo -n E;true; } || echo -n e `
						[ "$dscCnt" -lt 1 ] && {
							PrintChar "$dscItem" "$dscTag" "$defaultstyle"
							echo -n Nothing
							true
						} || {
							[ "$dscCnt" -gt 1 ] && echo -n "$dscCnt * "
							[ "$dscItem" == ' ' ] && dscItem='VSP'
							PrintChar "$dscItem" "$dscTag" "$defaultstyle"
						}
					)"
				}
				_invdispcache[i]="$sinvtgitem"
			}
			echo -n "${_invdispcache[i]}"
			echo -n $'\t\e[0m'
		done
	}
}
