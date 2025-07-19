#! /bin/bash
function PrintChar {
	printentity=0 exreset=1
	[[ "$2" =~ E ]] && {
		printentity=1
	}
	[ "$printentity" == 1 ] && echo -n $'\e[107m'
	case "$1" in
		PLY) echo -n $'\e[34m@\e[0m';exreset=0 ;;
		BOL) echo -n $'\e[32m|\e[0m';exreset=0 ;;
		OOT) echo -n $'\e[33m#\e[0m';exreset=0 ;;
		SOT) echo -n $'\e[32m>';exreset=0 ;;
		POT) echo -n '.';exreset=0 ;;
		EOT) echo -n $'.\e[0m';exreset=0 ;;
		DIG) echo -n $'\e[34m#\e[0m';exreset=0 ;;
		*) [ "$printentity" == 1 ] && echo -n $'\e[30m'; echo -n "$1" ;;
	esac
	[ "$printentity" == 1 ] && [ "$exreset" == 1 ] && echo -n $'\e[0m'
}
function PrintIgnore {
	case "$1" in
		0) ;;
		1) echo -n $'\e[C';;
		*) echo -n $'\e['"$1"'C';;
	esac
}
declare -A screen
function SetScreenShow {
	[ "${screen["$1.$2"]}" != "$3" ] && {
		screen["$1.$2"]="$3"
		return 0
	}
	return 1
}
