#! /bin/bash
[ -v MCEDITOR_INC_editor ] || {
	MCEDITOR_INC_editor=
	# dirp as the .../run/ path required
	. "$dirp"/arguments.sh
	. "$dirp"/world.sh
	. "$dirp"/menu.sh
	function editorrecover {
		echo -n $'\e[0m'
		[ "$MCEDITOR_dbgl" -ge 1 ] && echo 'Main Thread Ended'
		echo -n $'\e[?25h'
		stty "$ltty"
	}
	function editormain {
		end=0
		IFS=''
		trap 'end=1' SIGINT
		ReadArguments "$@" || {
			echo "${ArgResult[err]}"
			editorrecover
			return 1
		}
		[ "${ArgResult[dir]}" ] &&
			dirgame="${ArgResult['dir']%/}" # remove trailing /
		case "${ArgResult[task]}" in
			main)
				ltty=`stty -g`
				stty -echo icanon
				lang="${ArgResult[lang]}"

				echo -n $'\e[0m\e[?25l'
				[ "$MCEDITOR_dbgl" -gt 1 ] && {
					set | grep -w '^ArgResult'
				}
				unset showlogonexit
				[ -v ArgResult['show log on exit'] ]; showlogonexit=$[1-$?]
				
				case "${ArgResult[page]}" in
					menu)
						menumain;;
					create_world)
						worldmain "${ArgResult[world name]}" create ;;
					load_world)
						worldmain "${ArgResult[world name]}" ;;
				esac
				editorrecover
				[ "$showlogonexit" == 1 ] && vim "$logfile" ;;
			help)
				lang="${ArgResult[lang]}"
				echo -e "`< "$dirassets"/mcide/help/"$lang".txt`" ;;
		esac
	}
}
