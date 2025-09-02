#! /bin/bash
[ -v MCEDITOR_INC_world ] || {
	MCEDITOR_INC_world=
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
	. "$dirp"/save.sh
	. "$dirp"/dimension.sh
	. "$dirp"/fifo.sh
	. "$dirp"/base/check.sh
	. "$dirp"/operate.sh
	# worldmain <worldname> [create|simple|load]
	function resetworlddata {
		for i in "${num2dim[@]}";do
			DeleteDimension "$i"
		done
		ResetScreenShow
		ScheduleScreenUpdate 0
		echo 'disconnect' >&12
	}
	function worldmain {
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
		unset showlogonexit
		[ -v ArgResult['show log on exit'] ]; showlogonexit=$[1-$?]

		local worldname=$1
		local createmode=${2:-load}
		local worlddir="$dirgame/saves/$worldname"
		[ "$createmode" == create ] && [ "$worldname" == '' ] && {
			createmode=simple
		}
		[ "$createmode" == simple ] && [ -z "${ArgResult[no simple mode prompt]}" ] && {
			echo $'\e[31mWARN: You are now in simple mode, it means ur world will be lost after u exit the editor.\e[0m'
			echo $'\e[31mTo prevent this, use -n|--world-name <name> option to set the world name\e[0m'
			echo $'\e[31mIf you want to ignore this prompt, add --no-simple-mode-prompt\e[0m'
			echo $'\e[31mIf you want to continue, press Enter\e[0m'
			echo $'\e[31mIf you want to leave, press any other key\e[0m'
			local op=
			read -N 1 op
			[ "$op" != $'\n' ] && {
				editorpage=exit
				return 1
			}
		}
		[ "$createmode" == create ] && [ -e "$worlddir" ] && {
			echo $'\e[31mWARN: You are trying to override a exist world.\e[0m'
			echo $'\e[31mTo open the world, use `-w|--open-world|--load-world <name>`\e[0m'
			echo $'\e[31mTo override the world, delete the original one manually.\e[0m'
			read -N 1
			editorpage=exit
			return 1
		}
		[ "$end" == 1 ] && {
			return 1
		}
		[ "$MCEDITOR_dbgl" -ge 1 ] && {
			echo "World name: $worldname"
			echo "World dir: $worlddir"
			echo "Create mode: $createmode"
		}
		[ "$createmode" == load ] && {
			[ ! -d "$worlddir" ] && {
				echo 'World does not exist'
				return 1
			}
			[ ! -f "$worlddir"/level.json ] && {
				echo 'World is invalid (level.json not found)'
				return 1
			}
		}
		[ "$createmode" != load ] && {
			eval local dims=(${ArgResult['alldims']})
			local efile=
			for i in "${dims[@]}";do
				efile="${ArgResult["dim$i"]}"
				NewDimension "$i" "$efile"
				local did=`GetDimensionID "$i"`
				local filesize=`wc -m "$efile" | { read -d ' ' -r l;echo -n $l ; }`
				Read_File "$did" "$filesize" <"$efile" 6> >(ShowProgressBar "Reading $i from $efile[" ']' 50)
				[ "$MCEDITOR_dbgl" -gt 1 ] && {
					echo "Load dimension: $i(ID: $did) from $efile"
					heap_print "fcm$did"
				}
			done
			[ "$MCEDITOR_dbgl" -gt 1 ] && {
				set | grep -Ew '^(num2dim|dim2num)'
				echo "Target Dimension: $dim"
				read
			}
			InvInit inv 46
			px=0 py=0
			true
		} || {
			load_save "$worlddir" || {
				echo 'Error loading world' >&2
				return 1
			}
			local i=
			echo 'This save could modify these files:'
			for i in "${dimfile[@]}";do
				echo $'\t'"$i"
			done
			echo 'Press Other Keys to Leave'
			echo 'Press Enter to Continue'
			local op=
			read -N 1 op
			[ "$op" != $'\n' ] && {
				resetworlddata
				return 1
			}
		}
		GetDimensionID mcide:overworld >/dev/null || NewDimension mcide:overworld
		dim=`GetDimensionID mcide:overworld`
		[ "$end" == 1 ] && {
			return
		}

		[ "$MCEDITOR_dbgl" -lt 2 ] && {
			echo -n $'\e[0m\e[?25l\ec'
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
		vx="${ArgResult[vis width]:-10}" vy="${ArgResult[vis height]:-5}"

		[ "$MCEDITOR_dbgl" -ge 2 ] && {
			CreateEntity $ENTITY_ITEM `GetItemEntityData BOL 5` 1 0 0
			CreateEntity $ENTITY_ITEM `GetItemEntityData BOL 2` 1 1 0
			CreateEntity $ENTITY_ITEM `GetItemEntityData BOL 1` 2 1 0
			CreateEntity $ENTITY_ITEM `GetItemEntityData BOL 63` 2 2 0
		}
		CreateEntity $ENTITY_ITEM `GetItemEntityData 'The Illegal Item' ` -20 -20 0

		local power=100 prignore=0 isdig=0 canceldrop=0 opsuc=0 invopen=0 linvopen=0 linvselected=
		unset invselected; invselected=
		tickc=0
		local lttime="`date +%s%N`" tgnspt=500000000
		while true;do
			local tinvopen=$invopen
			[ "$invopen" == 1 ] && {
				echo -n $'\e[0;0H'
				[ "$end" == 1 ] && break
				[ -z "$invselected" ] && {
					invselected=$selhotbar
					linvselected=$invselected
				}
				RemoveCache inv $selhotbar
				ShowInventory inv 9 0 45 $invselected $linvselected
				echo -n $'\nCursor: '
				RemoveCache inv $invselected
				ShowInventory inv 1 45
				echo -n $'\e[K'
				echo
				linvselected=$invselected
				true
			} || {
				echo op >&12
				[ "$end" == 1 ] && break
				echo -n $'\e[0;0H'
				[ "$linvopen" == 1 ] && {
					invselected= linvselected=
					ScheduleScreenUpdate 0
					ResetScreenShow
				}
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
			}
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
			ShowInventory inv 9 0 9 '' $lselhotbar ;echo

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
			[ "$tinvopen" != 1 ] && {
				local ntdate="`date +%s%N`"
				((ltdate+=tgnspt, ntdate>ltdate)) && ltdate="$((ntdate+tgnspt))"
				while [ "$ntdate" -lt "$ltdate" ] ;do
					sleep 0.02
					ntdate="`date +%s%N`"
				done
				opsuc=0
				echo opend >&12
				{
					isdig=0 ismove=0
					op=''
					IFS=' '
					#echo 'qwqwqwq'
					read -a op -t 0.2 <&4
					echo "ciallo~It's ${op[@]} meow~"$'\e[K' >&2
					[ "$op" ] && Operate_"${op[@]}"
					IFS=''
					[ "`date +%s%N`" -gt "$ltdate" ] && opsuc=1
				}
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
				linvopen="$invopen"
				tickc="$[tickc+1]"
				true
			} || {
				op=''
				IFS=' '
				echo opinv >&12
				read -a op <&4
				IFS=''
				"OperateInv_${op[@]}"
				echo "cinvllo~It's ${op[@]} meow~"$'\e[K' >&2
			}
		done 4< <(InputThread)
		echo -n $'\ec'
		local i=
		for i in "${num2dim[@]}";do
			local efile="${dimfile["`GetDimensionID "$i"`"]}"
			{
				echo t'Backing up original file' >&6
				echo p0 >&6
				cp -- "$efile" "$efile".meditor.backup
				Save_File `GetDimensionID "$i"` "$efile" >"$efile" &&
				rm -- "$efile".meditor.backup
			} 6> >(ShowProgressBar "Saving $i to $efile [" ']' 50 >&2 )
		done 2>&1
		echo 'File saved'
		[ "$createmode" != simple ] && {
			echo '(test) Saving save...'
			save_save "$worlddir" && echo 'Save saved' || echo 'Save save failed'
		}
		echo 'Endding world...'
		resetworlddata
		[ "$MCEDITOR_dbgl" -ge 1 ] && {
			echo 'Waiting...'
		}
		wait
		echo -n $'\e[?25h'
		[ "$createmode" == simple ] && {
			editorpage=exit
		}
	}
}
