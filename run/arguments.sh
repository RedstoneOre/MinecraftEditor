#! /bin/bash
[ -v MCEDITOR_INC_arguments ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Argument parsing loaded'
	MCEDITOR_INC_arguments=
	# ReadArgument <args>...
	#  return map ArgResult as the parse result
	#  return false if the argument is illegal, set ArgResult[err] as the error message
	function IsNumber {
		[[ "$1" =~ ^-?[0-9]+$ ]]
	}
	function CheckShortOption {
		[ "$1" != generic ] && {
			ArgResult['err']='Multiple sub-args-required options in one short option: '"$2"
			return 1
		}
		return 0
	}
	function ReadArguments {
		local stat=generic statp= dims=()
		declare -gA 'ArgResult=()'
		ArgResult['task']=main
		ArgResult['page']=
		local i=
		for i; do
			case "$stat" in
				generic)
					[ "${i:0:1}" == '-' ] && { # new option
						[ "${i:1:1}" == '-' ] && { # is long option
							case "$i" in
								--overworld)
									stat=dim statp=0 ;;
								--dim)
									stat=dim_waitnum statp=;;
								--file)
									stat=dim statp= ;;
								--menu)
									ArgResult['page']=menu ;;
								--open-world|--load-world)
									ArgResult['page']=load_world
									stat=load_world statp=;;
								--dir)
									stat=set_ ;;
								*)
									ArgResult['err']='Illegal option: '"$i"
									return 1 ;;
							esac
							true
						} || { # is short option
							[[ "$i" =~ m ]] &&
								ArgResult['page']=menu
							[[ "$i" =~ w ]] && {
								CheckShortOption "$stat" "$i" w || return 1
								ArgResult['page']=world
								stat=load_world statp=
							}
							[[ "$i" =~ o ]] && {
								CheckShortOption "$stat" "$i" o || return 1
								stat=dim statp=0
							}
						}
					} ;;
				dim)	# read a dim
					[ -n "$statp" ] && { # not specific dim
						dims[${#dims[@]}]="$i"
						true
					} || { # specific dim
						ArgResult["dim$statp"]="$i"
					}
					stat=generic statp= ;;
				dim_waitnum)
					IsNumber "$i" && {
						stat=dim statp="$i"
						true
					} || {
						ArgResult['err']='Illegal dimension id: '"$i"
						return 1
					} ;;
			esac
		done
		[ "${ArgResult[task]}" == main ] && [ -z "${ArgResult[page]}" ] && {
			ArgResult[page]=create_world
			[ -v ArgResult[dim0] ] && ArgResult[page]=menu
		}
		[ "$stat" != generic ] && {
			ArgResult['err']="$stat"' sub-args required: '"$i"
			return 1
		}
		return 0
	}
}
