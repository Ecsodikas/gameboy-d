module instructions;

import registers;
import cpu;


// BYTE REGISTERS
// GETTERS
ubyte getA(Cpu cpu) { return cpu.registers.a; }
ubyte getF(Cpu cpu) { return cpu.registers.f; }
ubyte getB(Cpu cpu) { return cpu.registers.b; }
ubyte getC(Cpu cpu) { return cpu.registers.c; }
ubyte getD(Cpu cpu) { return cpu.registers.d; }
ubyte getE(Cpu cpu) { return cpu.registers.e; }
ubyte getH(Cpu cpu) { return cpu.registers.h; }
ubyte getL(Cpu cpu) { return cpu.registers.l; }

// SETTERS

Cpu setA(Cpu cpu, ubyte val) {
    cpu.registers.a = val;
    return cpu;
}

Cpu setF(Cpu cpu, ubyte val) {
    cpu.registers.f = val & 0xF0;
    return cpu;
}

Cpu setB(Cpu cpu, ubyte val) {
    cpu.registers.b = val;
    return cpu;
}

Cpu setC(Cpu cpu, ubyte val) {
    cpu.registers.c = val;
    return cpu;
}

Cpu setD(Cpu cpu, ubyte val) {
    cpu.registers.d = val;
    return cpu;
}

Cpu setE(Cpu cpu, ubyte val) {
    cpu.registers.e = val;
    return cpu;
}

Cpu setH(Cpu cpu, ubyte val) {
    cpu.registers.h = val;
    return cpu;
}

Cpu setL(Cpu cpu, ubyte val) {
    cpu.registers.l = val;
    return cpu;
}



// 16 BIT REGISTERS
// GETTERS

ushort getSP(Cpu cpu) { return cpu.sp; }

ushort getAF(Cpu cpu) {
    return (cast(ushort)cpu.registers.a << 8) | cpu.registers.f;
}

ushort getBC(Cpu cpu) {
    return (cast(ushort)cpu.registers.b << 8) | cpu.registers.c;
}

ushort getDE(Cpu cpu) {
    return (cast(ushort)cpu.registers.d << 8) | cpu.registers.e;
}

ushort getHL(Cpu cpu) {
    return (cast(ushort)cpu.registers.h << 8) | cpu.registers.l;
}

// SETTERS
Cpu setAF(Cpu cpu, ushort val) {
    cpu.registers.a = cast(ubyte)(val >> 8);
    cpu.registers.f = cast(ubyte)(val & 0xF0);
    return cpu;
}

Cpu setBC(Cpu cpu, ushort val) {
    cpu.registers.b = cast(ubyte)(val >> 8);
    cpu.registers.c = cast(ubyte)(val & 0xFF);
    return cpu;
}

Cpu setDE(Cpu cpu, ushort val) {
    cpu.registers.d = cast(ubyte)(val >> 8);
    cpu.registers.e = cast(ubyte)(val & 0xFF);
    return cpu;
}

Cpu setHL(Cpu cpu, ushort val) {
    cpu.registers.h = cast(ubyte)(val >> 8);
    cpu.registers.l = cast(ubyte)(val & 0xFF);
    return cpu;
}

Cpu setSP(Cpu cpu, ushort value) {
    cpu.sp = value;
    return cpu;
}

// FLAG
bool getFlag(Cpu cpu, FlagMask mask) {
    return (cpu.registers.f & mask) != 0;
}

Cpu setFlag(Cpu cpu, FlagMask mask, bool value) {
    if (value)
        cpu.registers.f |= mask;
    else
        cpu.registers.f &= ~mask;
    return cpu;
}

// MEMORY
// READ
ubyte read8(Cpu cpu, ushort address) {
    return cpu.memory.memory[address];
}

ushort read16(Cpu cpu, ushort address) {
    ubyte lo = read8(cpu, address);
    ubyte hi = read8(cpu, cast(ushort)(address + 1));
    return cast(ushort)((hi << 8) | lo);
}

//WRITE
Cpu write8(Cpu cpu, ushort address, ubyte value) {
    cpu.memory.memory[address] = value;
    return cpu;
}

Cpu write16(Cpu cpu, ushort address, ushort value) {
    cpu = write8(cpu, address, cast(ubyte)(value & 0xFF));
    cpu = write8(cpu, cast(ushort)(address + 1), cast(ubyte)(value >> 8));
    return cpu;
}
