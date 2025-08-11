#! /bin/bash
[ -v MCEDITOR_INC_block_piston ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Piston header loaded'
	MCEDITOR_INC_block_piston=
	. "$dirp"/map.sh
	. "$dirp"/block/proportions.sh
	. "$dirp"/print.sh
	# ExtendPiston <x> <y> <strength> <dx> <dy>
	function ExtendPiston {
		local pisw=0 pisx="$1" pisy="$2" piss="${3:-100}"
		while true;do
			matchChar "$pisx" "$pisy" ' ' && break
			pisw="$[pisw+`getHardness "$(getChar "$pisx" "$pisy")"`]"
			[ "$pisw" -gt "$piss" ] && return 1
			pisx="$[pisx+($4)]" pisy="$[pisy+($5)]"
		done
		while [ "$pisx" != "$1" ] || [ "$pisy" != "$2" ] ;do
			setChar "$pisx" "$pisy" `getChar "$[pisx-($4)]" "$[pisy-($5)]"`
			ScheduleScreenUpdate "$[pisy-(ScrUpper)+1]"
			pisx="$[pisx-($4)]" pisy="$[pisy-($5)]"
		done
	}
	function ContractPiston {
		local pisw=0 pisx="$1" pisy="$2" piss="${3:-100}"
		for((pisi=1;pisi<=2;++pisi));do
			setChar "$pisx" "$pisy" `getChar "$[pisx+($4)]" "$[pisy+($5)]"`
			ScheduleScreenUpdate "$[pisy-(ScrUpper)+1]"
			pisw="$[pisw+`getHardness "$(getChar "$pisx" "$pisy")"`]"
			[ "$pisw" -gt "$piss" ] && break
			pisx="$[pisx+($4)]" pisy="$[pisy+($5)]"
		done
		setChar "$pisx" "$pisy" ' '
		ScheduleScreenUpdate "$[pisy-(ScrUpper)+1]"
	}
	function UsePiston {
		local pisx="$1" pisy="$2"
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
