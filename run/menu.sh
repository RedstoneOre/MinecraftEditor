#! /bin/bash
[ -v MCEDITOR_INC_menu ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Menu loaded'
	MCEDITOR_INC_menu=
	. "$dirp"/print/window.sh
	function menumain {
		getWindowSize
		local iconsize=20
		[ "$((winX/6))" -gt "$winY" ] && {
			iconsize=$winY
			true
		} || {
			iconsize=$((winX/6))
		}
		[ "$iconsize" -lt 1 ] && iconsize=1
		local icon="`"$dirlib"/ascii-image-converter/ascii-image-converter -C -H $iconsize "$dirassets"/mcide/MinecraftIDE.png`"
		local stline=$(((winY-iconsize)/2))
		echo -n $'\ec\e'"[${stline}H$icon"
		echo $'\e'"[$((stline+3));$((iconsize*2+6))H"'Minecraft IDE'
		echo $'\e'"[$((stline+4));$((iconsize*2+10))H"$'-- A simple and \e[9mannoy\e[0;4minterest\e[0ming editor'
		read -r -N 1
		echo -n $'\ec'
	}
}
