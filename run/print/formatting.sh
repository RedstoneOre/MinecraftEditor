#! /bin/bash
[ -v MCEDITOR_INC_print_formatting ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Formatting loaded'
	MCEDITOR_INC_print_formatting=
	# FormattedOutput STRING OPTIONS
	#  the options:
	#   from=...		from column
	#   to=...		to column
	#   align=l|r		text align
	#   firstalign=l|r	specific the align of the first line
	function FormattedOutput {
		local i= st=0
		local str= from= to= align=
		for i;do
			[ "$st" == 0 ] && {
				st=1 str="$I"
				continue
			}
			declare "$i"
		done
		{
			local char=
			while read -N 1 -u 3 char;do
				case "$char" in
					$'\n')
						echo
						[ "$from" ] && echo $'\e['"$from"'G'
						;;
					*)
				esac
			done
		} 3< <(echo -n "$str")
	}
}
