# gem5-testing

1. Change WS/G5/SE/RISCV variable in test.sh/test_v.sh

2.
   1. Clone __riscv-arch-test__
    ```bash
    git clone https://github.com/riscv-non-isa/riscv-arch-test
    ```
   2. Download __imperas-riscv-tests__, and replace imperas-riscv-tests/riscv-target/riscvOVPsimPlus/model_test.h with modify/model_test.h
<br>

3.
   1. Use __test.sh__
    ```bash
    # input I/M/F/D/C to run specific extension tests, input nothing to run all the test
    ./test.sh I
    ```
   2. Use __test_v.sh__ for imperas V testsuite
    ```bash
    ./test.sh Vi
    ```

4. The log of each tests is debug.txt which will be found in log/ after running test.sh/test_v.sh

5.
    1. Run __check_pass.sh__ will generate text file which list all the testcases that passed (executed ecall)
    ```bash
    # after running ./test_v.sh Vi once
    ./check_pass.sh Vi
    ```
    2. Run __check_fail.sh__ will generate text file which list all the testcases that failed due to incorrect value 
    ```bash
    # after running ./test_v.sh Vi once
    ./check_fail.sh Vi
    ```
<br>
update_answer_*.py: A script that will update correct answers to input test file (currently only available for fcvt.l.s)
```bash
update_answer_fcvt.l.s.py ./riscv-arch-test/riscv-test-suite/rv64i_m/F/src/fcvt.l.s_b1-01.S
```
