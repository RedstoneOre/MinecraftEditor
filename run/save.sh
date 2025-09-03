#! /bin/bash
[ -v MCEDITOR_INC_save ] || {
	[ "$MCEDITOR_dbgl" -ge 2 ] && echo 'Save loading & saving loaded'
	MCEDITOR_INC_save=
	. "$dirp"/dimension.sh
	. "$dirp"/heap.sh
	. "$dirp"/map.sh
	. "$dirp"/container.sh
	. "$dirp"/entity.sh
	# save_dimension_to_save <Dimension> > (output)
	#  Save a dimension to standard output in save format
	function save_dimension_to_save {
		local d=$1
		ldim=$dim
		dim=$d
		heap_copy fcm$dim fcmsave
		local csize=`heap_getsize fcmsave`
		local charp= char= 
		local tcsize=$csize progupdcd=0
		echo "$tcsize $progupdcd" >&2
		local efile="`realpath ${dimfile["$d"]}`"
		{
			echo "file ${dimfhash["$d"]} $efile" >&4
			while [ "$tcsize" -gt 0 ]; do
				charp=`heap_gettop fcmsave`
				char="`getChar ${charp//.*/} ${charp//*./}`"
				heap_pop fcmsave
				tcsize=`heap_getsize fcmsave`
				local cx="${charp/.*/}" cy="${charp/*./}"
				echo "$cx $cy $char" >&4
			done
		} 4> >(jq -RncaM '
			reduce inputs as $line (
				{file: "", fhash: "", map: {}}; 
				($line | split(" ")) as $parts
				| if $parts[0] == "file" then
					.fhash = $parts[1]
					| .file = ( $parts[2:] | join(" ") )
				else
					if ($parts | length) >= 3 then
						.map[$parts[0]] //= {}
						| .map[$parts[0]][$parts[1]] = ( $parts[2:] | join(" ") )
					end
				end
			)
		' )
		dim=$ldim
		return 0
	}
	# save_container_to_save <ContainerID> > (output)
	function save_container_to_save {
		local cid=$1
		declare -n _inv="$cid"
		declare -n _invc="${cid}c"
		declare -n _invdispcache="${cid}dispcache"
		declare -n _invsize="${cid}size"
		local i=
		for((i=0;i<_invsize;++i));do
			[ "${_inv[i]}" ] && {
				echo "$i ${_inv[i]} ${_invc[i]}" >&4
			}
		done 4> >(jq -RncaM '
			reduce inputs as $line (
				{size: '"$_invsize"',items: {}}; 
				($line | split(" ")) as $parts
				| if ($parts | length) < 3 then . 
					else 
						.items[$parts[0]] = {id: $parts[1], count: ($parts[2] | tonumber)}
					end
			)
		' )
		return 0
	}
	# save_save <worlddir>
	#  Save the current world to the directory
	function save_save {
		local dir=$1
		[ "$dir" ] || return 1
		mkdir -p "$dir" || return 2
		# Dimensions
		local i=
		for i in "${num2dim[@]}";do
			local did="${dim2num[d"$i"]}"
			mkdir -p "$dir"/dimensions/"$i" || return 2
			echo save_dimension_to_save "$did" '>' "$dir"/dimensions/"$i"/map.json >&2
			save_dimension_to_save "$did" > "$dir"/dimensions/"$i"/map.json || return 2
		done
		# Containers
		mkdir -p "$dir"/containers || return 2
		for i in inv;do
			echo save_container_to_save "$i" '>' "$dir"/containers/"$i".json >&2
			save_container_to_save "$i" > "$dir"/containers/"$i".json || return 2
		done
		# level data
		jq -cM --arg x "$px" --arg y "$py" --arg focx "$focx" --arg focy "$focy" '{"x": $x, "y": $y, "focx": $focx, "focy": $focy}' < <(echo 1) > "$dir"/level.json || return 2
		return 0
	}


	# load_dimension_from_save <Dimension> < map.json
	#  Load a dimension from standard input in save format
	function load_dimension_from_save {
		local d=$1
		ldim=$dim
		dim=$d
		heap_init fcm$dim
		local charp= char= 
		local progupdcd=0
		{
			local file= fhash=
			read -u 4 -r file
			read -u 4 -r fhash
			dimfile["$d"]="$file"
			dimfhash["$d"]="$fhash"
			while read -u 4 -r line; do
				{
					read -d ' ' -r cx
					read -d ' ' -r cy
					read -d $'\n' -r char
				} < <(echo "$line")
				setChar "$cx" "$cy" "$char"
			done
		} 4< <(jq -r '.file, .fhash, (.map | to_entries[] | .key as $outer | .value | to_entries[] | "\($outer) \(.key) \(.value)")' )
		echo end loading $dim >&2
		dim=$ldim
	}
	# load_container_from_save <ContainerID> < container.json
	function load_container_from_save {
		{
			local cid=$1
			local size=
			read -u 4 -r size
			IsNumber "$size" || size=9
			InvInit "$cid" "$size"
			declare -n _inv="$cid"
			declare -n _invc="${cid}c"
			declare -n _invdispcache="${cid}dispcache"
			declare -n _invsize="${cid}size"
			local i=
			while read -u 4 -r line; do
				{
					read -d ' ' -r slot
					read -d ' ' -r count
					IsNumber "$slot" || continue
					IsNumber "$count" || continue
					read -d $'\n' -r id
				} < <(echo "$line")
				_inv[slot]="$id"
				_invc[slot]="$count"
				_invdispcache[slot]=''
			done 
		} 4< <(jq -r '"\(.size)", (.items | to_entries[] | "\(.key) \(.value.count) \(.value.id)")')
	}
	# load_save <worlddir>
	#  Load a world from the directory
	function load_save {
		local dir=$1
		[ "$dir" ] || return 1
		# Dimensions
		local i=
		for i in "$dir"/dimensions/*;do
			[ -d "$i" ] || continue
			NewDimension "${i##*/}" ''
			local did=`GetDimensionID "${i##*/}"`
			echo load_dimension_from_save "$did" '<' "$i"/map.json >&2
			load_dimension_from_save "$did" < "$i"/map.json || return 2
		done
		# Containers
		mkdir -p "$dir"/containers || return 2
		for i in inv;do
			echo load_container_from_save "$i" < "$dir"/containers/"$i".json >&2
			load_container_from_save "$i" < "$dir"/containers/"$i".json || return 2
		done
		# level data
		{
			local x= y= _focx= _focy=
			read -d $'\n' -r x
			read -d $'\n' -r y
			read -d $'\n' -r _focx
			read -d $'\n' -r _focy
			IsNumber "$x" || x=0
			IsNumber "$y" || y=0
			IsNumber "$_focx" || _focx=0
			IsNumber "$_focy" || _focy=0
			px=$x py=$y focx=$_focx focy=$_focy
			echo "Level data: x=$x y=$y" >&2
		} < <(jq -r '.x, .y, .focx, .focy' < "$dir"/level.json) || return 2
		return 0
	}
}
