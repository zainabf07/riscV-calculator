# Running the RISC-V Calculator

## Prerequisites

You need one of the following simulators:

### MARS 4.5 (easiest — Windows/Mac/Linux)
- Download: http://courses.missouristate.edu/kenvollmar/mars/
- Requires Java 8+
- Run: `java -jar Mars4_5.jar`

### RARS (MARS successor, actively maintained)
- Download: https://github.com/TheThirdOne/rars/releases
- Requires Java 11+
- Run: `java -jar rars.jar`

### Spike (Linux native)
```bash
# Install toolchain (Ubuntu/Debian)
sudo apt install gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf

# Assemble & link
riscv64-unknown-elf-as -march=rv32im -mabi=ilp32 -o calculator.o src/calculator.s
riscv64-unknown-elf-ld -m elf32lriscv -o calculator calculator.o

# Run with Spike
spike --isa=RV32IM pk calculator
```

---

## How the Program Works

```
main
 └─► loop  (print menu, read choice)
      ├─► add / sub / mul / div / mod
      │     └─► get_inputs
      │           ├─► use_previous  (if choice == 1, load s0)
      │           └─► normal input  (read two integers)
      │         [operation executes]
      └─► print_result  (ecall 1, save to s0, jump back to loop)
           └─► div_error  (on division/modulus by zero)
```

## Syscall Table (MARS/RARS)

| a7 | Service | Description |
|---|---|---|
| 1 | print_int | Print integer in a0 |
| 4 | print_string | Print null-terminated string at a0 |
| 5 | read_int | Read integer → a0 |
| 10 | exit | Terminate program |

## Register Usage

| Register | Role |
|---|---|
| `s0` | Saved result (persists across operations) |
| `t0` | Holds menu choice |
| `t1` | First operand |
| `t2` | Second operand |
| `t3` | Result |
| `t4/t5` | Reuse-check temporaries |
| `a0` | Syscall argument / return |
| `a7` | Syscall number |
| `ra` | Return address for `get_inputs` |

## Known Limitations

- Operates on **integers only** (no floating point)
- Overflow is not checked (wraps silently on 32-bit)
- Input validation limited to division-by-zero check
