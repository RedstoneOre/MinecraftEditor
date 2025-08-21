
#! /bin/bash
[ -v MCEDITOR_INC_options ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'options loaded'
	MCEDITOR_INC_options=
	. "$dirp"/base/check.sh

	# TextProvider Presets
	function TextProvider_fixed {
		echo -n "$1"
	}

	# init_option_list <name>
	#  Initialize an option list
	function init_option_list {
		local d=$1
		unset "${d}_text" "${d}_textp" "${d}_pos" "${d}_type" "${d}_stat" "${d}_data" "$d"
		declare -g -A "${d}_text=()"
		declare -g -A "${d}_textp=()"
		declare -g -A "${d}_pos=()"
		declare -g -A "${d}_type=()"
		declare -g -A "${d}_stat=()"
		declare -g -A "${d}_data=()"
		declare -g -A "$d=( focus '' )"
	}
	# add_option <listname> <id> [textprovider:fixed] <text> <pos> [type:button]
	function add_option {
		local d=$1 id=$2 textp=${3:-fixed} text=$4 pos=$5 type=${6:-button}
		declare -n "_o_text=${d}_text"
		declare -n "_o_textp=${d}_textp"
		declare -n "_o_pos=${d}_pos"
		declare -n "_o_type=${d}_type"
		declare -n "_o_stat=${d}_stat"
		declare -n "_o_data=${d}_data"
		IsIdName "$id" || return 1
		[ -v _o_type["$id"] ] && return 2
		_o_text["$id"]="$text"
		_o_textp["$id"]="$textp"
		_o_pos["$id"]="$pos"
		_o_type["$id"]="$type"
		_o_stat["$id"]=default
		_o_data["$id"]=
	}
	# uodate_option <listname> <id>
	function update_option {
		local d=$1 id=$2
		declare -n "_o_text=${d}_text"
		declare -n "_o_textp=${d}_textp"
		declare -n "_o_pos=${d}_pos"
		declare -n "_o_type=${d}_type"
		declare -n "_o_stat=${d}_stat"
		declare -n "_o_data=${d}_data"
		local text="`"TextProvider_${_o_textp["$id"]}" "${_o_text["$id"]}" "${_o_data["$id"]}" "${_o_stat["$id"]}"`"
		echo -n $'\e['"${_o_pos["$id"]}H"
		case "${_o_stat["$id"]}" in
			default)
				echo -n "$text" ;;
			focus)
				echo -n $'\e[7m'"$test"$'\e[0m' ;;
		esac
	}
	# uodate_option <listname>
	function show_all_options {
		local d=$1
		declare -n "_o_type=${d}_type"
		local i=
		for i in "${!_o_type[@]}"; do
			uodate_option "$d" "$i"
		done	
	}
	# change_option_focus <listname> <id>
	function change_option_focus {
		local d=$1 id=$2
		declare -n "_o=$d"
		declare -n "_o_stat=${d}_stat"
		local lfocus="${_o[focus]}"
		[ -n "$lfocus" ] && {
			_o_stat["$tfocus"]=default
			update_option "$lfocus"
		}
		_o[focus]="$id"
		local tfocus="$id"
		[ -n "$tfocus" ] && {
		echo focusing "$tfocus"
			_o_stat["$tfocus"]=focus
			update_option "$tfocus"
		}
	}
}
