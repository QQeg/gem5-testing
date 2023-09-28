#!/bin/bash
#check_fail.sh will find the fail testcase based on ebreak
# Get the directory name from the script arguments
dir_name=$1

if [ -f "./fail_${dir_name}.txt" ]; then
    rm "./fail_${dir_name}.txt"
fi
touch "./fail_${dir_name}.txt"

counter=0
counter_total=0
# Loop over all directories in the given directory
for dir in "log/$dir_name"/*/; do
    ((counter_total++))
    # If debug.txt exists in the directory and it contains "ebreak"
    if grep -q "ebreak" "$dir/debug.txt"; then
        # Append the directory name to fail_{$1}.txt in the current working directory
        echo "${dir%/}" >> "./fail_${dir_name}.txt"
        ((counter++))
    fi
done

echo "Total files : $counter_total" | cat - "./fail_${dir_name}.txt" > temp && mv temp "./fail_${dir_name}.txt"
# echo "Passed: $counter" | cat - "./result_${dir_name}.txt" > temp && mv temp "./result_${dir_name}.txt"
echo "Failed: $((counter_total - $counter))" | cat - "./fail_${dir_name}.txt" > temp && mv temp "./fail_${dir_name}.txt"
echo "-----------------------------" >> "./fail_${dir_name}.txt"
echo "Total files : $counter_total" >> "./fail_${dir_name}.txt"
# echo "Passed: $counter" >> "./fail_${dir_name}.txt"
echo "Failed: $counter" >> "./fail_${dir_name}.txt"

cat "./fail_${dir_name}.txt"