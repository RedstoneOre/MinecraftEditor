
#! /bin/bash
[ -v MCEDITOR_INC_fifo ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Fifos loaded'
	MCEDITOR_INC_fifo=
	unset tmpfifo
	tmpfifo="$dirtmp"/$$.fifo
	# newfifo <id>
	function newfifo {
		mkfifo "$tmpfifo"
		eval exec "$1<>" '"$tmpfifo"'
		rm "$tmpfifo"
	}
	newfifo 11	# block/progress	ProgressBar
	newfifo 12	# input			InputThread
	# newfifo 13	# input			MixedStdin
	newfifo 14	# world			sha1sum
	exec 30<&0		# -			FixedStdin
	exec 31>&1		# -			FixedStdout
	exec 32>&2		# -			FixedStderr
}
