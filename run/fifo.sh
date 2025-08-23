
#! /bin/bash
[ -v MCEDITOR_INC_fifo ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Fifos loaded'
	MCEDITOR_INC_fifo=
	tmpfifo="$dirtmp"/$$.fifo
	mkfifo "$tmpfifo"
	exec 11<> "$tmpfifo" # block/progress	ProgressBar
	exec 12<> "$tmpfifo" # input		InputThread
	# exec 13<> "$tmpfifo" # input		MixedStdin
	rm "$tmpfifo"
}
