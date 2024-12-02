input=$(tr -s ' ' <"$1")
left=$(cut -d' ' -f1 <<<"$input")
right=$(cut -d' ' -f2 <<<"$input")

# solution using grep -c
# real    0m1.390s
# user    0m0.389s
# sys     0m0.674s
 
# count=$(
# 	while IFS= read -r line; do
# 		grep -c "$line" <<<"$right"
# 	done <<<"$left"
# )

# paste -d* <(printf "%s" "$left") <(printf "%s" "$count") |
# 	bc |
# 	paste -sd+ |
# 	bc

# solution without grep
# real    0m0.990s
# user    0m0.301s
# sys     0m0.481s

declare -A right_counts
while IFS= read -r r; do
	((right_counts[$r]++))
done <<<"$right"

left_counts=$(
	while IFS= read -r l; do
		cat <<<"${right_counts[$l]-0}"
	done <<<"$left"
)

paste -d* <(printf "%s" "$left") <(printf "%s" "$left_counts") |
	bc |
	paste -sd+ |
	bc
