cat "$1"
printf "\n"

check_within_range() {
	sed <<<"$1" -e 's/-//' -e 's/\(^.*$\)/1<=\1\&\&\1<=3/' | bc
}

while IFS= read -r report; do
	report_lines=$(tr ' ' '\n' <<<"$report")
	diffs=$(paste -d- <(head -n-1 <<<"$report_lines") <(tail -n+2 <<<"$report_lines") |
		bc)
	printf "%s\n" "$diffs"
	minus_counts=$(grep -c '-' <<<"$diffs")
	if [[ "$minus_counts" -ne 0 && "$minus_counts" -ne 4 || $(check_within_range "$diffs") =~ 0 ]]; then
		cat <<<no
	fi
	# echo "$minus_counts"
	printf "\n"
done <"$1"
