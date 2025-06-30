module alu;

import cpu;
import registers;
import instructions;

/// Update A and Z flag
private Cpu updateA(Cpu cpu, ubyte result) {
    cpu = setA(cpu, result);
    cpu = setFlag(cpu, FlagMask.Z, result == 0);
    return cpu;
}

/// ADD A, value
Cpu addA(Cpu cpu, ubyte value) {
    ubyte a = getA(cpu.registers);
    ushort sum = cast(ushort)a + value;
    ubyte result = cast(ubyte)sum;

    cpu = updateA(cpu, result);
    cpu = setFlag(cpu, FlagMask.N, false);
    cpu = setFlag(cpu, FlagMask.H, ((a & 0xF) + (value & 0xF)) > 0xF);
    cpu = setFlag(cpu, FlagMask.C, sum > 0xFF);

    return cpu;
}

/// ADC A, value
Cpu adcA(Cpu cpu, ubyte value) {
    ubyte a = getA(cpu.registers);
    ubyte c = getFlag(cpu.registers, FlagMask.C) ? 1 : 0;
    ushort sum = cast(ushort)a + value + c;
    ubyte result = cast(ubyte)sum;

    cpu = updateA(cpu, result);
    cpu = setFlag(cpu, FlagMask.N, false);
    cpu = setFlag(cpu, FlagMask.H, ((a & 0xF) + (value & 0xF) + c) > 0xF);
    cpu = setFlag(cpu, FlagMask.C, sum > 0xFF);

    return cpu;
}

/// SUB A, value
Cpu subA(Cpu cpu, ubyte value) {
    ubyte a = getA(cpu.registers);
    ubyte result = cast(ubyte)(a - value);

    cpu = updateA(cpu, result);
    cpu = setFlag(cpu, FlagMask.N, true);
    cpu = setFlag(cpu, FlagMask.H, (a & 0xF) < (value & 0xF));
    cpu = setFlag(cpu, FlagMask.C, a < value);

    return cpu;
}

/// SBC A, value
Cpu sbcA(Cpu cpu, ubyte value) {
    ubyte a = getA(cpu.registers);
    ubyte c = getFlag(cpu.registers, FlagMask.C) ? 1 : 0;
    short diff = cast(short)a - value - c;
    ubyte result = cast(ubyte)diff;

    cpu = updateA(cpu, result);
    cpu = setFlag(cpu, FlagMask.N, true);
    cpu = setFlag(cpu, FlagMask.H, (a & 0xF) < ((value & 0xF) + c));
    cpu = setFlag(cpu, FlagMask.C, diff < 0);

    return cpu;
}

/// AND A, value
Cpu andA(Cpu cpu, ubyte value) {
    ubyte result = getA(cpu.registers) & value;

    cpu = updateA(cpu, result);
    cpu = setFlag(cpu, FlagMask.N, false);
    cpu = setFlag(cpu, FlagMask.H, true);
    cpu = setFlag(cpu, FlagMask.C, false);

    return cpu;
}

/// OR A, value
Cpu orA(Cpu cpu, ubyte value) {
    ubyte result = getA(cpu.registers) | value;

    cpu = updateA(cpu, result);
    cpu = setFlag(cpu, FlagMask.N, false);
    cpu = setFlag(cpu, FlagMask.H, false);
    cpu = setFlag(cpu, FlagMask.C, false);

    return cpu;
}

/// XOR A, value
Cpu xorA(Cpu cpu, ubyte value) {
    ubyte result = getA(cpu.registers) ^ value;

    cpu = updateA(cpu, result);
    cpu = setFlag(cpu, FlagMask.N, false);
    cpu = setFlag(cpu, FlagMask.H, false);
    cpu = setFlag(cpu, FlagMask.C, false);

    return cpu;
}

/// CP A, value
Cpu cpA(Cpu cpu, ubyte value) {
    ubyte a = getA(cpu.registers);
    short diff = cast(short)a - value;
    ubyte result = cast(ubyte)diff;

    cpu = setFlag(cpu, FlagMask.Z, result == 0);
    cpu = setFlag(cpu, FlagMask.N, true);
    cpu = setFlag(cpu, FlagMask.H, (a & 0xF) < (value & 0xF));
    cpu = setFlag(cpu, FlagMask.C, diff < 0);

    return cpu;
}

/// INC 8-bit value
Cpu inc(Cpu cpu, ubyte val, out ubyte result) {
    result = cast(ubyte)(val + 1);
    cpu = setFlag(cpu, FlagMask.Z, result == 0);
    cpu = setFlag(cpu, FlagMask.N, false);
    cpu = setFlag(cpu, FlagMask.H, (val & 0xF) + 1 > 0xF);
    return cpu;
}

/// DEC 8-bit value
Cpu dec(Cpu cpu, ubyte val, out ubyte result) {
    result = cast(ubyte)(val - 1);
    cpu = setFlag(cpu, FlagMask.Z, result == 0);
    cpu = setFlag(cpu, FlagMask.N, true);
    cpu = setFlag(cpu, FlagMask.H, (val & 0xF) == 0);
    return cpu;
}

/// INC (HL)
Cpu incAtHL(Cpu cpu) {
    ushort addr = getHL(cpu.registers);
    ubyte val = read8(cpu, addr);
    ubyte result;
    cpu = inc(cpu, val, result);
    return write8(cpu, addr, result);
}

/// DEC (HL)
Cpu decAtHL(Cpu cpu) {
    ushort addr = getHL(cpu.registers);
    ubyte val = read8(cpu, addr);
    ubyte result;
    cpu = dec(cpu, val, result);
    return write8(cpu, addr, result);
}

/// ADD HL, rr
Cpu addHl(Cpu cpu, ushort value) {
    ushort hl = getHL(cpu.registers);
    uint sum = cast(uint)hl + value;
    cpu = setHL(cpu, cast(ushort)sum);
    cpu = setFlag(cpu, FlagMask.N, false);
    cpu = setFlag(cpu, FlagMask.H, ((hl & 0xFFF) + (value & 0xFFF)) > 0xFFF);
    cpu = setFlag(cpu, FlagMask.C, sum > 0xFFFF);
    return cpu;
}

/// ADD SP, offset (signed byte)
Cpu addSp(Cpu cpu, byte offset) {
    ushort sp = getSP(cpu);
    int result = cast(int)sp + offset;

    cpu = setSP(cpu, cast(ushort)result);
    cpu = setFlag(cpu, FlagMask.Z, false);
    cpu = setFlag(cpu, FlagMask.N, false);
    cpu = setFlag(cpu, FlagMask.H, ((sp & 0xF) + (offset & 0xF)) > 0xF);
    cpu = setFlag(cpu, FlagMask.C, ((sp & 0xFF) + (offset & 0xFF)) > 0xFF);

    return cpu;
}

/// DAA — Decimal Adjust Accumulator
Cpu daa(Cpu cpu) {
    ubyte a = getA(cpu.registers);
    ubyte correction = 0;
    bool c = getFlag(cpu.registers, FlagMask.C);
    bool h = getFlag(cpu.registers, FlagMask.H);
    bool n = getFlag(cpu.registers, FlagMask.N);

    if (!n) {
        if (c || a > 0x99) {
            correction |= 0x60;
            c = true;
        }
        if (h || (a & 0xF) > 9) {
            correction |= 0x06;
        }
        a += correction;
    } else {
        if (c) correction |= 0x60;
        if (h) correction |= 0x06;
        a -= correction;
    }

    cpu = updateA(cpu, a);
    cpu = setFlag(cpu, FlagMask.H, false);
    cpu = setFlag(cpu, FlagMask.C, c);
    return cpu;
}

/// CPL — Complement A
Cpu cpl(Cpu cpu) {
    cpu = setA(cpu, cast(ubyte)~getA(cpu.registers));
    cpu = setFlag(cpu, FlagMask.N, true);
    cpu = setFlag(cpu, FlagMask.H, true);
    return cpu;
}

/// CCF — Complement Carry Flag
Cpu ccf(Cpu cpu) {
    bool c = getFlag(cpu.registers, FlagMask.C);
    cpu = setFlag(cpu, FlagMask.N, false);
    cpu = setFlag(cpu, FlagMask.H, false);
    cpu = setFlag(cpu, FlagMask.C, !c);
    return cpu;
}

/// SCF — Set Carry Flag
Cpu scf(Cpu cpu) {
    cpu = setFlag(cpu, FlagMask.N, false);
    cpu = setFlag(cpu, FlagMask.H, false);
    cpu = setFlag(cpu, FlagMask.C, true);
    return cpu;
}
