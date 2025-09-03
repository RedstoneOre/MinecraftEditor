#! /bin/bash
[ -v MCEDITOR_INC_option_list ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Option list loaded'
	MCEDITOR_INC_option_list=
	. "$dirp"/options.sh
	init_option_list clioptl
	add_option clioptl leave_world_behavior choice 'On Leave World: ' '2;4' button
	add_option clioptl quit_server_behavior choice 'On Disconnect From Servers: ' '2;30' button
	add_option clioptl trushed_paths choice 'Trushed Paths...' '4;4' button

	cliopts=( leave_world_behavior quit_server_behavior trushed_paths  trushed_paths )
	clioptsz="${#cliopts[@]}"
	function option_list_main {
		echo -n $'\ec'
		show_all_options clioptl
		read
	}
}
