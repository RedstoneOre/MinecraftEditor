#! /bin/bash
[ -v MCEDITOR_INC_editor ] || {
	MCEDITOR_INC_editor=
	# dirp as the .../run/ path required
	. "$dirp"/arguments.sh
	. "$dirp"/input.sh
	. "$dirp"/map.sh
	. "$dirp"/block/proportions.sh
	. "$dirp"/print.sh
	. "$dirp"/print/progress.sh
	. "$dirp"/block.sh
	. "$dirp"/entity.sh
	. "$dirp"/container.sh
	. "$dirp"/file.sh
	. "$dirp"/dimension.sh
	. "$dirp"/fifo.sh
	function editorrecover {
		echo -n $'\e[0m'
		[ "$MCEDITOR_dbgl" -ge 1 ] && echo 'Main Thread Ended'
		echo -n $'\e[?25h'
		stty "$ltty"
	}
	function editormain {
		end=0
		IFS=''
		# Special Chars
		#  PLY - Coder
		#  BOL - Begin of Line
		#  OOT - Out of Text(border)
		#  SOT - Start of Tab
		#  POT - Part of Tab
		#  EOT - End of Tab
		#  SCT - Single char Tab
		#  DIG - Focus char
		#  ESP - Espace the following 1 char
		#  ELB - Brack espace left brack
		#  ERB - Brack espace right brack
		#  NDC - No displaying char, only for formattinng
		#  VSP - Visible Space
		trap 'end=1' SIGINT
		ltty=`stty -g`
		stty -echo icanon
		ReadArguments "$@"
		[ "$MCEDITOR_dbgl" -gt 1 ] && {
			set | grep -w '^ArgResult'
		}
		eval local dims=(${ArgResult['alldims']})
		local efile=
		for i in "${dims[@]}";do
			efile="${ArgResult["dim$i"]}"
			NewDimension "$i" "$efile"
			local did=`GetDimensionID "$i"`
			local filesize=`wc -m "$efile" | { read -d ' ' -r l;echo -n $l ; }`
			Read_File "$did" "$filesize" < <(<"$efile") 6> >(ShowProgressBar "Reading $i from $efile[" ']' 50)
			[ "$MCEDITOR_dbgl" -gt 1 ] && {
				echo "Load dimension: $i(ID: $did) from $efile"
				heap_print "fcm$did"
			}
		done
		GetDimensionID mcide:overworld >/dev/null || NewDimension mcide:overworld
		dim=`GetDimensionID mcide:overworld`
		[ "$MCEDITOR_dbgl" -gt 1 ] && {
			set | grep -Ew '^(num2dim|dim2num)'
			echo "Target Dimension: $dim"
			read
		}
		[ "$end" == 1 ] && {
			editorrecover
			return
		}

		[ "$MCEDITOR_dbgl" -lt 2 ] && {
			echo -n $'\e[0m\e[?25l'
			clear
		}
		[ "$MCEDITOR_dbgl" -ge 3 ] && {
			for((i=0;i<lines;++i));do
				echo -n '['"${fc["$rdim.$i.c"]}"']'
				for((j=0;j<${fc["$rdim.$i.c"]};++j));do
					echo -n "${fc["$rdim.$i.$j"]}"'|'
				done
				echo;echo
			done
			read
		}
		px=0 py=0 vx=10 vy=5
		InvInit inv 45

		[ "$MCEDITOR_dbgl" -ge 2 ] && {
			CreateEntity $ENTITY_ITEM `GetItemEntityData BOL 5` 1 0 0
			CreateEntity $ENTITY_ITEM `GetItemEntityData BOL 2` 1 1 0
			CreateEntity $ENTITY_ITEM `GetItemEntityData BOL 1` 2 1 0
			CreateEntity $ENTITY_ITEM `GetItemEntityData BOL 63` 2 2 0
		}

		local power=100 prignore=0 isdig=0 canceldrop=0 opsuc=0
		. "$dirp"/operate.sh
		tickc=0
		while true;do
			echo >&12
			[ "$end" == 1 ] && break
			echo -n $'\e[0;0H'
			PrintCharStyle="$defaultstyle"
			GetScreenLeftUpperCorner "$px" "$py"
			sScrLeft="$ScrLeft" sScrUpper="$ScrUpper"
			local i= j=
			for((i=sScrUpper;i<=py+vy;++i));do
				[ "$UpdScreen" != 1 ] && [ "${UpdScreen[i-(sScrUpper)+1]}" != 1 ] && {
					echo
					continue
				}
				for((j=sScrLeft;j<=px+vx;++j));do
					prc=`getChar "$j" "$i"`
					[ "$i" == "$focy" ] && [ "$j" == "$focx" ] && prc=DIG
					[ "$i" == "$py" ] && [ "$j" == "$px" ] && prc=PLY
					[ "${entopos["$dim.$j.$i.c"]:-0}" -gt 0 ] && {
						hasentity='E'
						true
					} || hasentity='e'
					SetScreenShow "$[i-py]" "$[j-px]" "$hasentity$prc" && {
						PrintIgnore "$prignore"
						prignore=0
						PrintChar "$prc" "$hasentity" "$PrintCharStyle"
						true
					} || {
						prignore="$[prignore+1]"
					}
				done
				PrintIgnore "$prignore"
				prignore=0
				PrintChar NDC '' "$PrintCharStyle"
				echo $'\e[K'
			done
			true
			UpdScreen=()
			echo -n "Pos: ($px, $py), Focus: ($focx, $focy), Dim: `GetDimensionName "$dim"`, Tick $tickc"$'\e[K\n'
			[ "$dip" -gt 0 ] && {
				echo -n 'Mining char '"$(PrintChar `getChar "$focx" "$focy"`)"$'\e[0m at ('"$focx"', '"$focy"'), progress '"$dip"'/'"$(getHardness `getChar "$focx" "$focy"`)"$'\e[K\n'
			}
			echo -n 'Power: '"$power"$'\e[K\n'
			prentsz="${entopos["$dim.$px.$py.c"]:-0}"
			[ "$prentsz" -gt 0 ] && {
				echo $'Entities: \e[K'
				for((prenti=0;prenti<prentsz;++prenti));do
					echo -n '  '
					DiscribeEntity "${entopos["$dim.$px.$py.$prenti"]}"
					echo $'\e[0m\e[K'
				done
			}
			ShowInventory inv 9 0 9

			echo -n $'\e[K\n\e[K\n\e[K\n'
			[ "${entopos["$dim.$px.$py.c"]:-0}" -gt 0 ] && {
				apickcnt="${entopos["$dim.$px.$py.c"]}" apick=()
				for((i=0;i<apickcnt;++i));do
					apicktt="${entopos["$dim.$px.$py.$i"]}"
					[ "${entities["$apicktt"]}" == $ENTITY_ITEM ] && {
						apick[${#apick[@]}]="$apicktt"
					}
				done
				for i in "${apick[@]}";do
					ParseItemEntityData "${entdatas[$i]}"
					InvPick inv "$entityitemtype" "$entityitemcnt"
					DeleteEntity "$i"
				done
			}
			opsuc=0
			while [ "$opsuc" == 0 ] && [ "$end" != 1 ];do
				isdig=0 ismove=0
				op=''
				IFS=' '
				read -a op <&4
				IFS=''
				"Operate_${op[@]}"
				[ "$opsuc" == 0 ] && echo >&12
			done
			[ "$canceldrop" -gt 0 ] && {
				canceldrop="$[canceldrop-1]"
			} || {
				[ "`getChar "$px" "$[py+1]"`" == ' ' ] && {
					move 0 1
					ismove=1
				}
			}
			power="$[power+1]"
			[ "$isdig" == 0 ] && {
				dip="$[dip-3]"
				[ "$dip" -lt 0 ] && dip=0
				true
			} || {
				[ "$power" -gt 0 ] && power="$[power-1]"
			}
			[ "$ismove" == 1 ] && {
				movefocus "$px" "$py" s
			}
			tickc="$[tickc+1]"
		done 4< <(InputThread)
		echo -n $'\ec\e[?25l'
		local i=
		for i in "${num2dim[@]}";do
			{
				local efile="${dimfile["`GetDimensionID "$i"`"]}"
				echo t'Backing up original file' >&6
				echo p0 >&6
				cp -- "$efile" "$efile".meditor.backup
				Save_File `GetDimensionID "$i"` "$efile" >"$efile" &&
				rm -- "$efile".meditor.backup
			} 6> >(ShowProgressBar "Saving $i to $efile [" ']' 50 >&2 )
		done 2>&1
		echo 'File saved'
		echo 'Endding process...'
		echo 'E' >&12
		[ "$MCEDITOR_dbgl" -ge 1 ] && {
			echo 'Waiting...'
		}
		wait
		editorrecover
	}
}
