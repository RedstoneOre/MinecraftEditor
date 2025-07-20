#! /bin/bash
declare -A CharStyle CharPrc
CharStyle['PLY']='4'
CharPrc['PLY']='@'
CharStyle['BOL']='2'
CharPrc['BOL']='|'
CharStyle['OOT']='3'
CharPrc['OOT']='#'
CharStyle['SOT']='2'
CharPrc['SOT']='['
CharStyle['POT']='2'
CharPrc['POT']='.'
CharStyle['EOT']='2'
CharPrc['EOT']=']'
CharStyle['DIG']='4'
CharPrc['DIG']='#'
CharStyle['ESP']='2'
CharPrc['ESP']='^'
CharStyle['NDC']='9'
CharPrc['NDC']=''
CharStyle['default']='9'

# PrintChar <Code> <Tags> <LastCharStyle>
#  set PrintCharStyle as the char's style
function PrintChar {
	charbg='-'
	[[ "$2" =~ E ]] && {
		charbg=7
	}
	charstyle="${CharStyle[$1]:-${CharStyle[default]}}"
	[ "$charstyle.$charbg" == '9.7' ] && charstyle=0
	PrintCharStyle="$charstyle.$charbg"
	stylestr='' stylereset=0
	[ "${3//*./}" != "$charbg" ] && {
		stylestr="$stylestr""$(
				[ "$charbg" == '-' ] && {
					echo -n '0;'
					stylerreset=1
					true
				} || echo -n '10'"$charbg"';'
			)"
	}
	{ [ "$stylerreset" == 1 ] || [ "${3//.*/}" != "$charstyle" ]; } && {
		stylestr="${stylestr}3$charstyle"';'
	}
	[ "${#stylestr}" -gt 1 ] && echo -n $'\e['"${stylestr:0:-1}m"
	echo -n "${CharPrc["$1"]-"$1"}"
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
