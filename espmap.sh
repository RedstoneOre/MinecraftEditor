#! /bin/bash
[ -v "$MCEDITOR_INC_espmap" ] || {
	[ "$debug" -ge 2 ] && echo 'Espace map header loaded'
	MCEDITOR_INC_espmap=
	unset ctrlesp braesp
	declare -A ctrlesp braesp
	ctrlesp['cNUL']='@'
	ctrlesp[$'c\001']='A'
	ctrlesp[$'c\002']='B'
	ctrlesp[$'c\003']='C'
	ctrlesp[$'c\004']='D'
	ctrlesp[$'c\005']='E'
	ctrlesp[$'c\006']='F'
	ctrlesp[$'c\007']='G'
	ctrlesp[$'c\010']='H'
	ctrlesp[$'c\013']='K'
	ctrlesp[$'c\014']='L'
	ctrlesp[$'c\015']='M'
	ctrlesp[$'c\016']='N'
	ctrlesp[$'c\017']='O'
	ctrlesp[$'c\020']='P'
	ctrlesp[$'c\021']='Q'
	ctrlesp[$'c\022']='R'
	ctrlesp[$'c\023']='S'
	ctrlesp[$'c\024']='T'
	ctrlesp[$'c\025']='U'
	ctrlesp[$'c\026']='V'
	ctrlesp[$'c\027']='W'
	ctrlesp[$'c\030']='X'
	ctrlesp[$'c\031']='Y'
	ctrlesp[$'c\032']='Z'
	ctrlesp[$'c\033']='['
	ctrlesp[$'c\034']='\'
	ctrlesp[$'c\035']=']'
	ctrlesp[$'c\036']='^'
	ctrlesp[$'c\037']='_'
	ctrlesp[$'c\177']='?'
	braesp[$'c\200']='80'
	braesp[$'c\201']='81'
	braesp[$'c\202']='82'
	braesp[$'c\203']='83'
	braesp[$'c\204']='84'
	braesp[$'c\205']='85'
	braesp[$'c\206']='86'
	braesp[$'c\207']='87'
	braesp[$'c\210']='88'
	braesp[$'c\211']='89'
	braesp[$'c\212']='8a'
	braesp[$'c\213']='8b'
	braesp[$'c\214']='8c'
	braesp[$'c\215']='8d'
	braesp[$'c\216']='8e'
	braesp[$'c\217']='8f'
	braesp[$'c\220']='90'
	braesp[$'c\221']='91'
	braesp[$'c\222']='92'
	braesp[$'c\223']='93'
	braesp[$'c\224']='94'
	braesp[$'c\225']='95'
	braesp[$'c\226']='96'
	braesp[$'c\227']='97'
	braesp[$'c\230']='98'
	braesp[$'c\231']='99'
	braesp[$'c\232']='9a'
	braesp[$'c\233']='9b'
	braesp[$'c\234']='9c'
	braesp[$'c\235']='9d'
	braesp[$'c\236']='9e'
	braesp[$'c\237']='9f'
	# mcespace <Char>
	#  set tfcres as the espaced char list
	function mceespace {
		mceec="${1:-NUL}"
		[ "${ctrlesp["c$mceec"]}" != '' ] && {
			tfcres=( ESP "${ctrlesp["c$mceec"]}" )
			return
		}
		[ "${braesp["c$mceec"]}" != '' ] && {
			tfcbraesps="${braesp["c$mceec"]}"
			tfcres=( ELB "${tfcbraesps:0:1}" "${tfcbraesps:1}" ERB )
			return
		}
		case "$mceec" in
			$'\t') tfcres=( SOT POT POT POT POT POT POT EOT ) ;;
			*) tfcres=( "$mceec" ) ;;
		esac
	}
}
