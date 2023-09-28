#!/bin/bash
# path to this directory
WS=/home/ctwang/gem5-testing
# path to gem5 / se.py 
G5=/home/ctwang/workspace/gem5/build/RISCV
SE=/home/ctwang/workspace/gem5/configs/deprecated/example
# path to gnu toolchain
RISCV=/home/ctwang/workspace/riscv_toolchain/bin


RUN () {
    local EXT="$1"
    base_dir="$WS/log/$EXT"
    test_dir="$WS/imperas-riscv-tests/riscv-test-suite/rv32i_m/$EXT/src"
    mkdir -p $base_dir
    testcases=()
    while IFS= read -r -d $'\0' file; do
    # echo "read ${file} into testcases"
    testcases+=("$file")
    done < <(find imperas-riscv-tests/riscv-test-suite/rv32i_m/$EXT/src/ -mindepth 1 -maxdepth 1 -type f -name "*.S" -print0)

    testname_array=()
    while IFS= read -r -d $'\0' entry; do
    # echo "read $(basename "${entry}") into testname_array"
    testname_array+=($(basename "${entry}"))
    done < <(find imperas-riscv-tests/riscv-test-suite/rv32i_m/$EXT/src/ -mindepth 1 -maxdepth 1 -type f -name "*.S" -print0)


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
        COMPILE="$RISCV/riscv64-unknown-elf-gcc -w -march=rv64gcv -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -g -T $WS/imperas-riscv-tests/riscv-target/riscvOVPsimPlus/link.ld -I $WS/imperas-riscv-tests/riscv-target/riscvOVPsimPlus/ -I $WS/imperas-riscv-tests/riscv-test-suite/env $file -o my.elf -DTEST_CASE_1=True -DXLEN=64 -DSLEN=256 -DVLEN=256 -DELEN=32 -mabi=lp64"
        if [ "${EXT:1:1}" == "F" ]; then
            $COMPILE -DFLEN=32
        else 
            $COMPILE 
        fi
    fi
    $G5/gem5.opt --debug-flags=Exec $SE/se.py -c my.elf &>debug.txt
    # spike --isa=rv64gcv -l --varch="vlen:256,elen:32" my.elf &>debug_spike.txt
    index=$((index + 1))
    done
    cd $WS
}

if [ "${#1}" -eq 2 ]; then
    RUN "$1"
else
    echo "example usage: ./test_v.sh Vi"
    echo "expected input: Vi, Vb, Vf, Vm, Vp, Vr, or Vx"
fi