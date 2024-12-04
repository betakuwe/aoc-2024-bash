FILE="input.txt"

is_safe() {
	local report_array prev_sign diff sign
	read -ra report_array <<<"$1"
	for i in "${!report_array[@]}"; do
		if [[ $i -gt 0 ]]; then
			((diff = report_array[i] - report_array[i - 1], sign = diff < 0))
			[[ $sign = "${prev_sign:=$sign}" ]] &&
				{
					local abs_diff=${diff#-}
					[[ $abs_diff -ge 1 && $abs_diff -le 3 ]]
				} || return
		fi
	done
}

while IFS= read -r report; do
	is_safe "$report" && ((safe++))
done <$FILE

printf '%s' "$safe"
