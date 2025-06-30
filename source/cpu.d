module cpu;

import registers;

struct MemoryBus {
  ubyte[65536] memory;
}


struct Cpu {
  Registers registers;
  MemoryBus memory;
  ushort pc;
  ushort sp;
}
