# RISC-V Calculator

A calculator implemented in **RISC-V assembly (RV32IM)** with a matching retro-terminal **HTML/CSS/JS frontend** that visualizes each operation as real RISC-V instructions.


## Project Structure

```
riscv-calculator/
├── src/
│   ├── calculator.s       # RISC-V assembly source (RV32IM)
│   └── calculator.html    # Browser-based frontend / visualizer
├── docs/
│   └── INSTRUCTIONS.md    # How to run the assembly in MARS/RARS/Spike
├── .gitignore
├── LICENSE
└── README.md
```

---

## ✨ Features

| Feature | Assembly | Frontend |
|---|---|---|
| Add, Subtract, Multiply | ✅ | ✅ |
| Divide, Modulus | ✅ | ✅ |
| Division by zero error | ✅ | ✅ |
| Reuse previous result | ✅ (`s0` register) | ✅ (toggle) |
| Live ASM trace log | — | ✅ |
| Register viewer (t0, t1, t3) | — | ✅ (hex) |
| Cycle counter | — | ✅ |

---

## 🔧 Running the Assembly

### Option 1 — MARS (recommended for beginners)
1. Download [MARS](http://courses.missouristate.edu/kenvollmar/mars/)
2. Open `src/calculator.s`
3. Click **Assemble** then **Run**

### Option 2 — RARS
1. Download [RARS](https://github.com/TheThirdOne/rars)
2. Open `src/calculator.s` and run

### Option 3 — Spike + pk (Linux)
```bash
riscv32-unknown-elf-as -o calculator.o src/calculator.s
riscv32-unknown-elf-ld -o calculator calculator.o
spike --isa=RV32IM pk calculator
```

---

## Running the Frontend

Just open `src/calculator.html` in any modern browser — no server needed.

- Press keys **1–5** to select an operation
- Press **Enter** to execute
- Press **Escape** to clear / reset

---

## ISA Reference

| Operation | Instruction | Cycles |
|---|---|---|
| Add | `add t3, t1, t2` | 1 |
| Subtract | `sub t3, t1, t2` | 1 |
| Multiply | `mul t3, t1, t2` | 4 |
| Divide | `div t3, t1, t2` | 20 |
| Modulus | `rem t3, t1, t2` | 20 |

Registers used: `t0–t3` (temporaries), `s0` (saved result), `a0/a7` (syscall args).

---

## Author

Zainab Fatima — RISC-V Assembly Project

---

## License

MIT License — see [LICENSE](LICENSE)
