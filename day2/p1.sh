FILE="input.txt"

check_safety() {
	local prev_sign sign
	while IFS= read -r diff; do
		[[ $diff =~ - ]] && sign=- || sign=+
		if [[ $sign != "${prev_sign:=$sign}" ]]; then
			false
			return
		fi
		local abs_diff=${diff#-}
		if [[ $abs_diff -lt 1 || $abs_diff -gt 3 ]]; then
			false
			return
		fi
	done
}

while IFS= read -r report; do
	sed <<<"$report" \
		-e 's/ \([0-9]\+\)/-\1)(\1/g' \
		-e 's/^\(.*\)([0-9]\+/(\1/' |
		while IFS= read -r line; do
			bc <<<"${line//)(/)$'\n'(}"
		done |
		check_safety && ((safe++))
done <"$FILE"

printf '%s' "$safe"
