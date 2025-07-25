#! /bin/bash
[ -v MCEDITOR_INC_block_piston ] || {
	[ "$debug" -ge 2 ] && echo 'Piston header loaded'
	MCEDITOR_INC_block_piston=
	. "$dirp"/map.sh
	. "$dirp"/block/proportions.sh
	. "$dirp"/print.sh
	# ExtendPiston <x> <y> <strength> <dx> <dy>
	function ExtendPiston {
		episw=0
		episx="$1" episy="$2" episs="${3:-100}"
		while true;do
			matchChar "$episx" "$episy" ' ' && break
			episw="$[episw+`getHardness "$(getChar "$episx" "$episy")"`]"
			[ "$episw" -gt "$episs" ] && return 1
			episx="$[episx+($4)]" episy="$[episy+($5)]"
		done
		while [ "$episx" != "$1" ] || [ "$episy" != "$2" ] ;do
			setChar "$episx" "$episy" `getChar "$[episx-($4)]" "$[episy-($5)]"`
			ScheduleScreenUpdate "$[episy-(ScrUpper)+1]"
			episx="$[episx-($4)]" episy="$[episy-($5)]"
		done
	}
	function ContractPiston {
		cpisw=0
                cpisx="$1" cpisy="$2" cpiss="${3:-100}"
		for((cpisi=1;cpisi<=2;++cpisi));do
			setChar "$cpisx" "$cpisy" `getChar "$[cpisx+($4)]" "$[cpisy+($5)]"`
			ScheduleScreenUpdate "$[cpisy-(ScrUpper)+1]"
			cpisw="$[cpisw+`getHardness "$(getChar "$cpisx" "$cpisy")"`]"
			[ "$cpisw" -gt "$cpiss" ] && break
			cpisx="$[cpisx+($4)]" cpisy="$[cpisy+($5)]"
		done
		setChar "$cpisx" "$cpisy" ' '
		ScheduleScreenUpdate "$[cpisy-(ScrUpper)+1]"
	}
	function UsePiston {
		pisx="$1" pisy="$2"
		GetScreenLeftUpperCorner "$px" "$py"
		matchChar "$[pisx+1]" "$pisy" ']' && {
			ExtendPiston "$[pisx+1]" "$pisy" '' 1 0 && setChar "$[pisx+1]" "$pisy" '-'
			true
		} || {
			matchChar "$[pisx+1]" "$pisy" '-' && matchChar "$[pisx+2]" "$pisy" ']' && {
				ContractPiston "$[pisx+1]" "$pisy" '' 1 0
			}
		}
		matchChar "$[pisx-1]" "$pisy" '[' && {
			ExtendPiston "$[pisx-1]" "$pisy" '' -1 0 && setChar "$[pisx-1]" "$pisy" '-'
			true
		} || {
			matchChar "$[pisx-1]" "$pisy" '-' && matchChar "$[pisx-2]" "$pisy" '[' && {
				ContractPiston "$[pisx-1]" "$pisy" '' -1 0
			}
		}
		matchChar "$pisx" "$[pisy+1]" '-' && {
			ExtendPiston "$pisx" "$[pisy+1]" '' 0 1 && {
				setChar "$pisx" "$[pisy+1]" '|'
				ScheduleScreenUpdate "$[pisy-(ScrUpper)+2]"
			}
			true
		} || {
			matchChar "$pisx" "$[pisy+1]" '|' && matchChar "$pisx" "$[pisy+2]" '-' && {
				ContractPiston "$pisx" "$[pisy+1]" '' 0 1
			}
		}
		matchChar "$pisx" "$[pisy-1]" '-' && {
			ExtendPiston "$pisx" "$[pisy-1]" '' 0 -1 && {
				setChar "$pisx" "$[pisy-1]" '|'
				ScheduleScreenUpdate "$[pisy-(ScrUpper)]"
			}
			true
		} || {
			matchChar "$pisx" "$[pisy-1]" '|' && matchChar "$pisx" "$[pisy-2]" '-' && {
				ContractPiston "$pisx" "$[pisy-1]" '' 0 -1
			}
		}
	}
}
