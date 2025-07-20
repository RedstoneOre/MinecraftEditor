#! /bin/bash
[ -v MCEDITOR_INC_inventory ] || {
	[ "$debug" -ge 1 ] && echo 'Inventory header loaded'
	MCEDITOR_INC_inventory=
	inv=() invc=() invsize=40
	for((i=0;i<invsize;++i));do
		inv[i]='' invc[i]=0
	done
	# InvPick <Type> <Count>
	#  pickup item
	#  return invPickRemaining as the remaining count
	function InvPick {
		invpickcnt="${2:-1}"
		for((invi=0;invi<invsize;++invi));do
			[ "${inv[i]:-$1}" == "$1" ] && {
				inv[i]="$1"
				invc[i]="$[invc+invpickcnt]"
				invmaxstack=64
				[ "$invpickcnt" -gt "$invmaxstack" ] && {
					invpickcnt="$[invpickcnt-invmaxstack]"
					true
				} || {
					break
				}
			}
		done
		invPickRemaining="$invpickcnt"
	}
	# InvTake <Slot> <Num>
	#  return if successfully take the items
	#  when fail, do nothing
	function InvTake {
		[ "${invc[$1]}" -ge "$2" ] && {
			invc[$1]="$[${invc[$1]}-$2]"
			[ "${invc[$1]}" == 0 ] && {
				inv[$1]=''
			}
			return 0
		}
		return 1
	}
	# InvAdd <Slot> <Type> <Num>
	#  Add some item to a slot
	#  return fail if cannot add(type not match or too much to add) then do nothing
	function InvAdd {
		invmaxstack=64
		[ "${inv[$1]:-$2}" == "$2" ] && [ "$[${invc[$1]}+$3]" -le "$invmaxstack" ] && {
			invc[$1]="$[${invc[$1]}+$3]"
			inv[$1]="$2"
			return 0
		}
		return 1
	}

	# InvSwap <Slot1> <Slot2>
	function InvSwap {
		invcswtmp="${invc[$1]}" invswtmp="${inv[$1]}"
		invc[$1]="${invc[$2]}" inv[$1]="${inv[$2]}"
		invc[$2]="$invcswtmp" inv[$2]="$invswtmp"
	}
}
