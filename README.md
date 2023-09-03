# gem5-testing

1. Change WS/G5/SE/RISCV variable in test.sh
2. Clone riscv-arch-test
```bash
git clone https://github.com/riscv-non-isa/riscv-arch-test
```
3. Use test.sh
```bash
# input I/M/F/D/C to run specific extension tests, input nothing to run all the test
./test.sh I
```

4. The log of each tests is debug.txt which will be found in gem5_test/
<br>
update_answer_*.py: A script that will update correct answers to input test file (currently only available for fcvt.l.s)

```bash
update_answer_fcvt.l.s.py ./riscv-arch-test/riscv-test-suite/rv64i_m/F/src/fcvt.l.s_b1-01.S
```