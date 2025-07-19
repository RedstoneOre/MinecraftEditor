#! /bin/bash

declare -A lines
declare -A fc

function getCharOnPos {
	echo -n "${fc["$dim.$2.$1"]:-OOT}"
}
