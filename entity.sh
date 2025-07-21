#! /bin/bash
[ -v MCEDITOR_INC_entity ] || {
	[ "$debug" -ge 1 ] && echo 'Entities header loaded'
	MCEDITOR_INC_entity=
	. "$dirp"/inventory.sh
	entname=()
	ENTITY_ITEM=0 entname[0]='Item'
	ENTITY_BATTARY=1 entname[1]='Battary'

	entitycnt=0
	unset entities entdatas entpos entopos
	declare -A entities entdatas entpos entopos
	# CreateEntity <Type> <Data> <x> <y> <Dimension>
	#  return newEntityId as he entity ID
	function CreateEntity {
		entities["$entitycnt"]="$1"
		entdatas["$entitycnt"]="$2"
		entoposl="${entopos["$5.$3.$4.c"]:-0}"
		entopos["$5.$3.$4.$entoposl"]="$entitycnt"
		entpos["$entitycnt"]="$5.$3.$4#$entoposl"
		entopos["$5.$3.$4.c"]="$[entoposl+1]"
		newEntityId="$entitycnt"
		entitycnt="$[entitycnt+1]"
	}
	# DeleteEntity <ID>
	#  Return if the entoty is exist, or won't delete any
	function DeleteEntity {
		[ "${entities[$1]}" == '' ] && return 1
		unset entities["$1"] entdatas["$1"]
		{
			read -r -d '#' dentpos
			read -r dentindex
		} < <(echo -n "${entpos[$1]}")
		unset entpos[$1]
		dentend="$[${entopos["$dentpos.c"]}-1]"
		entopos["$dentpos.$dentindex"]=entopos["$dentpos.$dentend"]
		unset entopos["$dentpos.$dentend"]
		entopos["$dentpos.c"]="$dentend"
		return 0
	}
	# MoveEntity <ID> <x> <y> <Dimension>
	function MoveEntity {
		[ "${entities[$1]}" == '' ] && return 1
		{
			read -r -d '#' mentpos
			read -r mentindex
		} < <(echo -n "${entpos[$1]}")
		mentend="$[${entopos["$mentpos.c"]}-1]"
		entopos["$mentpos.$mentindex"]="${entopos["$mentpos.$mentend"]}"
		entpos["${entopos["$mentpos.$mentindex"]}"]="$mentpos#$mentindex"
		unset entopos["$mentpos.$mentend"]
		[ "$mentend" -gt 0 ] && {
			entopos["$mentpos.c"]="$mentend"
			true
		} || unset entopos["$mentpos.c"]
		entoposl="${entopos["$4.$2.$3.c"]:-0}"
		entopos["$4.$2.$3.$entoposl"]="$1"
		entpos["$1"]="$4.$2.$3#$entoposl"
		entopos["$4.$2.$3.c"]="$[entoposl+1]"
		return 0
	}
	function ShowAllEntities {
		for ShowAllEntityI in "${!entities[@]}";do
			echo 'Entity '"$ShowAllEntityI"
			echo $'\tType: '"${entname[${entities[$ShowAllEntityI]}]}"
			echo $'\tData: '"${entdatas[$ShowAllEntityI]}"
			echo $'\tPos: '"${entpos[$ShowAllEntityI]}"
		done
		for ShowAllEntityI in "${!entopos[@]}";do
			echo 'Pos '"$ShowAllEntityI"': '"${entopos[$ShowAllEntityI]}"
		done
	}
	
	# GetItemEntityData <ItemType> <ItemNum>
	#  Output the data string
	function GetItemEntityData {
		echo -n "$2#$1"
	}
	# ParseItemEntityData <Data>
	#  Return entityitemcnt, entityitemtype
	function ParseItemEntityData {
		{
			read -r -d '#' entityitemcnt
			read -r entityitemtype
		} < <(echo -n "$1")
	}

	# DiscribeEntity <ID>
	function DiscribeEntity {
		case "${entities["$1"]}" in
			0)
				echo -n 'Item '
				ParseItemEntityData "${entdatas["$1"]}"
				DescribeItem "$entityitemtype" '' "$entityitemcnt"
		esac
	}
}
