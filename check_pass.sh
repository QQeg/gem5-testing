#!/bin/bash

# Get the directory name from the script arguments
dir_name=$1

if [ -f "./pass_${dir_name}.txt" ]; then
    rm "./pass_${dir_name}.txt"
fi
touch "./pass_${dir_name}.txt"


counter=0
counter_total=0
# Loop over all directories in the given directory
for dir in "log/$dir_name"/*/; do
    ((counter_total++))
    # If debug.txt exists in the directory and it contains "ecall"
    if grep -q "ecall" "$dir/debug.txt"; then
        # Append the directory name to pass_{$1}.txt in the current working directory
        echo "${dir%/}" >> "./pass_${dir_name}.txt"
        ((counter++))
    fi
done

# Print the result at the begin/end of pass_${dir_name}.txt
echo "Total files : $counter_total" | cat - "./pass_${dir_name}.txt" > temp && mv temp "./pass_${dir_name}.txt"
echo "Passed: $counter" | cat - "./pass_${dir_name}.txt" > temp && mv temp "./pass_${dir_name}.txt"
echo "Failed: $((counter_total - $counter))" | cat - "./pass_${dir_name}.txt" > temp && mv temp "./pass_${dir_name}.txt"
echo "-----------------------------" >> "./pass_${dir_name}.txt"
echo "Total files : $counter_total" >> "./pass_${dir_name}.txt"
echo "Passed: $counter" >> "./pass_${dir_name}.txt"
echo "Failed: $((counter_total - $counter))" >> "./pass_${dir_name}.txt"

cat "./pass_${dir_name}.txt"