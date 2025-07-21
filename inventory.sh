#! /bin/bash
[ -v MCEDITOR_INC_inventory ] || {
	[ "$debug" -ge 1 ] && echo 'Inventory header loaded'
	MCEDITOR_INC_inventory=
	inv=() invc=() invsize=40 selhotbar=0 lselhotbar=-1
	for((i=0;i<invsize;++i));do
		inv[i]='' invc[i]=0
	done
	# InvPick <Type> <Count>
	#  pickup item
	#  return invPickRemaining as the remaining count
	function InvPick {
		invpickcnt="${2:-1}"
		for((invi=0;invi<invsize;++invi));do
			[ "${inv[invi]:-$1}" == "$1" ] && {
				inv[invi]="$1"
				invc[invi]="$[${invc[invi]}+invpickcnt]"
				invmaxstack=64
				[ "${invc[invi]}" -gt "$invmaxstack" ] && {
					invpickcnt="$[${invc[invi]}-invmaxstack]"
					invc[invi]="$invmaxstack"
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
		showinvwarp=5
		echo -n $'Inventory:\e[K'
		for((invi=0;invi<invsize;++invi));do
			[ "$[invi%showinvwarp]" == 0 ] && echo -n $'\n\e[K'
			{ # Just DescribeItem but it's so slow to call the func
				dscItem="${inv[invi]:-NDC}" dscCnt="${invc[invi]}"  dscTag=` [ "$selhotbar" == "$invi" ] && { echo -n E;true; } || echo -n e `
				[ "$dscCnt" -gt 1 ] && echo -n "$dscCnt * "
				[ "$dscItem" == ' ' ] && dscItem='VSP'
				PrintChar "$dscItem" "$dscTag" "$defaultstyle"
			}
			[ "${inv[invi]}" == '' ] && echo -n 'Nothing'
			echo -n $'\t\e[0m'
		done
	}
}
