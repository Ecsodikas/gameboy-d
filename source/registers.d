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

