FILE="input.txt"

check_within_range() {
	while IFS= read -r diff; do
		local abs_diff=${diff//-/}
		if [[ $abs_diff -lt 1 || $abs_diff -gt 3 ]]; then
			false
			return
		fi
	done <<<"$1"
}

while IFS= read -r report; do
	report_lines=$(tr ' ' '\n' <<<"$report")
	heads=$(head -n-1 <<<"$report_lines")
	diffs=$(paste -d- \
		<(printf '%s' "$heads") \
		<(tail -n+2 <<<"$report_lines") |
		bc)
	minus_counts=$(tr -cd '-' <<<"$diffs" | wc -c)
	# minus_counts=$(grep -c '-' <<<"$diffs") # works but a little slower
	[[ "$minus_counts" -eq 0 || "$minus_counts" -eq $(wc -l <<<"$heads") ]] &&
		check_within_range "$diffs" &&
		((safe++))
done <"$FILE"

printf '%s' "$safe"
