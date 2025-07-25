#! /bin/bash
[ -v MCEDITOR_INC_block_proportions ] || {
	[ "$debug" -ge 2 ] && echo 'Block proportions header loaded'
	MCEDITOR_INC_block_proportions=
	unset hardness
	declare -A hardness
	hardness['0']=0
	hardness['1']=1
	hardness['2']=2
	hardness['3']=4
	hardness['4']=8
	hardness['5']=16
	hardness['6']=32
	hardness['7']=64
	hardness['8']=8
	hardness['9']=9
	hardness['#']=5
	hardness['$']=50
	hardness["'"]=5
	hardness['"']=10
	hardness[OOT]=100
	hardness[BOL]=200
	defaulthardness=2
	function getHardness {
		echo -n "${hardness["$1"]:-$defaulthardness}"
	}
}
