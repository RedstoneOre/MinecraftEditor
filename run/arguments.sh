#! /bin/bash
[ -v MCEDITOR_INC_arguments ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Argument parsing loaded'
	MCEDITOR_INC_arguments=
	unset ArgResult
	# ReadArgument <args>...
	#  return map ArgResult as the parse result
	#  return false if the argument is illegal, set ArgResult[err] as the error message
	function IsNumber {
		[[ "$1" =~ ^-?[0-9]+$ ]]
	}
	function IsIdName {
		[ -n "$1" ] && ! [[ "$1" =~ [^0-9a-zA-Z_/.:] ]]
	}
	function CheckShortOption {
		[ "$1" != generic ] && {
			ArgResult['err']='Multiple sub-args-required options in one short option: '"$2"
			return 1
		}
		return 0
	}
	function ArgConnect {
		local i=
		for i;do echo -n "$i ";done
	}
	function ReadArguments {
		local stat=generic statp= dims=() autodims=()
		declare -gA 'ArgResult=()'
		ArgResult['task']=main
		ArgResult['page']=
		ArgResult['lang']='en-US'
		local i=
		for i; do
			local stop=0
			while [ "$stop" != 1 ];do
				stop=1
				case "$stat" in
					generic)
						[ "${i:0:1}" == '-' ] && { # new option
							[ "${i:1:1}" == '-' ] && { # is long option
								case "$i" in
									--overworld)
										stat=dim statp='mcide:overworld' ;;
									--dim)
										stat=dim_id statp=;;
									--open-file|--dim-append)
										stat=dim statp= ;;
									--menu)
										ArgResult['page']=menu ;;
									--open-world|--load-world)
										ArgResult['page']=load_world
										stat=load_world statp=;;
									--dir)
										stat=set_editor_dir statp=;;
									--help)
										ArgResult['task']=help;;
									--language|--lang)
										stat=lang statp=;;
									*)
										ArgResult['err']='Illegal option: '"$i"
										return 1 ;;
								esac
								true
							} || { # is short option
								local aval=mwodhl
								[[ "${i:1}" =~ [^mwodhl] ]] && {
									ArgResult['err']='Illegal option: '"-${i//[-mwodhl]/} in $i"
									return 1
								}
								[[ "$i" =~ m ]] &&
									ArgResult['page']=menu
								[[ "$i" =~ w ]] && {
									CheckShortOption "$stat" "$i" w || return 1
									ArgResult['page']=world
									stat=load_world statp=
								}
								[[ "$i" =~ o ]] && {
									CheckShortOption "$stat" "$i" o || return 1
									stat=dim statp='mcide:overworld'
								}
								[[ "$i" =~ d ]] && {
									CheckShortOption "$stat" "$i" d || return 1
									stat=set_editor_dir statp=
								}
								[[ "$i" =~ h ]] && {
									ArgResult['task']=help
								}
								[[ "$i" =~ l ]] && {
									CheckShortOption "$stat" "$i" l || return 1
									stat=lang statp=
								}
							}
							true
						} || { # new string argument
							stat=dim statp= stop=0
						} ;;
					dim)	# read a dim
						[ -z "$statp" ] && { # not specific dim
							autodims[${#autodims[@]}]="$i"
							true
						} || { # specific dim
							[ -v ArgResult["dim$statp"] ] || dims["${#dims[@]}"]="$statp"
							ArgResult["dim$statp"]="$i"
						}
						stat=generic statp= ;;
					dim_id)
						IsIdName "$i" && {
							stat=dim statp="$i"
							true
						} || {
							ArgResult['err']='Illegal dimension id: '"$i"
							return 1
						} ;;
					set_editor_dir)
						ArgResult['dir']="$i"
						stat=generic statp= ;;
					lang)
						ArgResult['lang']="$i"
						stat=generic statp= ;;
				esac
			done
		done
		local dimcnt=0 dimname=
		for i in "${autodims[@]}";do
			while true;do
				dimname='mcide:custom/'"$((dimcnt-2))"
				[ $dimcnt -eq 0 ] && dimname='mcide:overworld'
				[ $dimcnt -eq 1 ] && dimname='mcide:the_nether'
				[ $dimcnt -eq 2 ] && dimname='mcide:the_end'
				((++dimcnt))
				[ -v ArgResult["dim$dimname"] ] && continue
				ArgResult["dim$dimname"]="$i"
				dims["${#dims[@]}"]="$dimname"
				break
			done
		done
		ArgResult["alldims"]=`ArgConnect "${dims[@]}"`
		[ "${ArgResult[task]}" == main ] && {
		       	[ -z "${ArgResult[page]}" ] && {
				ArgResult[page]=create_world
				[ -z "${ArgResult["alldims"]}" ] && ArgResult[page]=menu
			}
		}
		[ "$stat" != generic ] && {
			ArgResult['err']="$stat"' sub-args required: '"$i"
			return 1
		}
		return 0
	}
}
