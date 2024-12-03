FILE="input.txt"

check_within_range() {
	while IFS= read -r diff; do
		abs_diff=${diff//-/}
		if [[ $abs_diff -lt 1 || $abs_diff -gt 3 ]]; then
			local res=0
			break
		fi
	done <<<"$1"
	printf "%s" "${res:=1}"

	# works, but slower by 1sec
	# sed <<<"$1" -e 's/-//' -e 's/\(^.*$\)/1<=\1\&\&\1<=3/' |
	# 	paste -sd'~' |
	# 	sed 's/~/\&\&/g' |
	# 	bc
}

while IFS= read -r report; do
	report_lines=$(tr ' ' '\n' <<<"$report")
	heads=$(head -n-1 <<<"$report_lines")
	diffs=$(paste -d- \
		<(printf '%s' "$heads") \
		<(tail -n+2 <<<"$report_lines") |
		bc)
	minus_counts=$(grep -c '-' <<<"$diffs")
	[[ "$minus_counts" -eq 0 || "$minus_counts" -eq $(wc -l <<<"$heads") ]] &&
		[[ $(check_within_range "$diffs") -eq 1 ]] &&
		cat <<<h
done <"$FILE" |
	wc -l
