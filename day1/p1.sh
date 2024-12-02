input=$(tr -s ' ' <"$1")
left=$(cut -d' ' -f1 <<<"$input" | sort)
right=$(cut -d' ' -f2 <<<"$input" | sort)
paste -d- <(printf "%s" "$left") <(printf "%s" "$right") |
	bc |
	sed "s/-//" |
	paste -sd+ |
	bc
