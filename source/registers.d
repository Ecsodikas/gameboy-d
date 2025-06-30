module registers;

struct Registers {
  ubyte a;
  ubyte b;
  ubyte c;
  ubyte d;
  ubyte e;
  ubyte f;
  ubyte h;
  ubyte l;
}

enum FlagMask : ubyte {
    Z = 0b1000_0000, // Zero flag
    N = 0b0100_0000, // Subtract flag
    H = 0b0010_0000, // Half carry flag
    C = 0b0001_0000  // Carry flag
}

// BYTE REGISTERS
// GETTERS
ubyte getA(Registers reg) { return reg.a; }
ubyte getF(Registers reg) { return reg.f; }
ubyte getB(Registers reg) { return reg.b; }
ubyte getC(Registers reg) { return reg.c; }
ubyte getD(Registers reg) { return reg.d; }
ubyte getE(Registers reg) { return reg.e; }
ubyte getH(Registers reg) { return reg.h; }
ubyte getL(Registers reg) { return reg.l; }

// SETTERS
Registers setA(Registers reg, ubyte val) {
    reg.a = val;
    return reg;
}

Registers setF(Registers reg, ubyte val) {
    reg.f = val & 0xF0; // lower nibble always 0
    return reg;
}

Registers setB(Registers reg, ubyte val) {
    reg.b = val;
    return reg;
}

Registers setC(Registers reg, ubyte val) {
    reg.c = val;
    return reg;
}

Registers setD(Registers reg, ubyte val) {
    reg.d = val;
    return reg;
}

Registers setE(Registers reg, ubyte val) {
    reg.e = val;
    return reg;
}

Registers setH(Registers reg, ubyte val) {
    reg.h = val;
    return reg;
}

Registers setL(Registers reg, ubyte val) {
    reg.l = val;
    return reg;
}

// 16 BIT REGISTERS
// GETTERS

ushort getAF(Registers reg) {
    return (cast(ushort)reg.a << 8) | reg.f;
}

ushort getBC(Registers reg) {
    return (cast(ushort)reg.b << 8) | reg.c;
}

ushort getDE(Registers reg) {
    return (cast(ushort)reg.d << 8) | reg.e;
}

ushort getHL(Registers reg) {
    return (cast(ushort)reg.h << 8) | reg.l;
}

// SETTERS

Registers setAF(Registers reg, ushort val) {
    reg.a = cast(ubyte)(val >> 8);
    reg.f = cast(ubyte)(val & 0xF0); // F lower nibble is always zero
    return reg;
}

Registers setBC(Registers reg, ushort val) {
    reg.b = cast(ubyte)(val >> 8);
    reg.c = cast(ubyte)(val & 0xFF);
    return reg;
}

Registers setDE(Registers reg, ushort val) {
    reg.d = cast(ubyte)(val >> 8);
    reg.e = cast(ubyte)(val & 0xFF);
    return reg;
}

Registers setHL(Registers reg, ushort val) {
    reg.h = cast(ubyte)(val >> 8);
    reg.l = cast(ubyte)(val & 0xFF);
    return reg;
}

// FLAG
bool getFlag(Registers reg, FlagMask mask) { return (reg.f & mask) != 0; }

Registers setFlag(Registers reg, FlagMask mask, bool value) {
    if (value)
        reg.f |= mask;
    else
        reg.f &= ~mask;
    return reg;
}
