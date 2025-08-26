#! /bin/bash
[ -v MCEDITOR_INC_world_list ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'World list loaded'
	MCEDITOR_INC_world_list=
	. "$dirp"/options.sh
	function worldlistmain {
		echo $'\e'"[3;6H"'Minecraft IDE -- Worlds'
		init_option_list worlds
		local optionsel=()
    for i in "$dirgame"/saves/*; do
      [ -d "$i" ] && add_option worlds "${#optionsel[@]}" fixed "${i##*/}" "$((5+${#optionsel[@]}))" button
      optionsel[${#optionsel[@]}]="${i##*/}"
    done
		show_all_options worlds
    opcnt=${#optionsel[@]}
    local op= opsel=0
    while :;do
      change_option_focus worlds "$opsel"
      read -r -N 1 op
      case "$op" in
        [qQ])
          editorpage=menu
          break;;
        [wW]) ((opsel=opsel-1<0?opcnt-1:opsel-1)) ;;
        [sS]) ((opsel=opsel+1>=opcnt?0:opsel+1)) ;;
        $'\n') 
          editorpage=load_world
          ArgResult['world name']="${optionsel[opsel]}"
          break;;
      esac
    done
		echo -n $'\ec'
	}
}
