#!/bin/bash
# path to this directory
WS=/home/ctwang/gem5-testing
# path to gem5 / se.py 
G5=/home/ctwang/workspace/plct-gem5/build/RISCV
SE=/home/ctwang/workspace/plct-gem5/configs/example
# path to gnu toolchain
RISCV=/home/ctwang/workspace/riscv_toolchain/bin

RUN_ALL () {
    RUN "I"
    RUN "M"
    RUN "F"
    RUN "D"
    RUN "C"
}


RUN () {
    local EXT="$1"
    base_dir="$WS/gem5_test/$EXT"
    test_dir="$WS/riscv-arch-test/riscv-test-suite/rv64i_m/$EXT/src"
    mkdir -p $base_dir
    testcases=()
    while IFS= read -r -d $'\0' file; do
    # echo "read ${file} into testcases"
    testcases+=("$file")
    done < <(find riscv-arch-test/riscv-test-suite/rv64i_m/$EXT/src/ -mindepth 1 -maxdepth 1 -type f -name "*.S" -print0)

    testname_array=()
    while IFS= read -r -d $'\0' entry; do
    # echo "read $(basename "${entry}") into testname_array"
    testname_array+=($(basename "${entry}"))
    done < <(find riscv-arch-test/riscv-test-suite/rv64i_m/$EXT/src/ -mindepth 1 -maxdepth 1 -type f -name "*.S" -print0)


    for testname in "${testname_array[@]}"
    do
        dir_path="${base_dir}/${testname}"
        # echo "making dir at ${dir_path}"
        mkdir -p "${dir_path}"
    done

    directories=()
    while IFS= read -r -d $'\0' dir; do
    directories+=("$dir")
    done < <(find ${base_dir} -mindepth 1 -maxdepth 1 -type d -print0)

    index=0
    for dir in "${directories[@]}"; do
    cd "$dir"
    if [ $index -lt ${#testcases[@]} ]; then
        file="/home/ctwang/gem5-testing/${testcases[$index]}"
        echo "$file"
        COMPILE="$RISCV/riscv64-unknown-elf-gcc -w -march=rv64gc -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -g -T $WS/env/link.ld -I $WS/env/  $file -o my.elf -DTEST_CASE_1=True -DXLEN=64 -mabi=lp64"
        if [ "$EXT" == "F" ]; then
            $COMPILE -DFLEN=32
        elif [ "$EXT" == "D" ]; then
            $COMPILE -DFLEN=64
        else 
            $COMPILE 
        fi
    fi
    $G5/gem5.opt --debug-flags=Exec $SE/se.py -I 20000 -c my.elf &>debug.txt

    index=$((index + 1))
    done
    cd $WS
}

if [ "${#1}" -eq 1 ]; then
    RUN "$1"
else
    RUN_ALL
fi