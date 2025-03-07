# MIPS Processor

This project implements a **MIPS processor** in **VHDL** with **5 stages**:

1. **IF (Instruction Fetch)**: 
   - Fetches instructions from memory.
   - Uses the Program Counter (PC) to fetch the next instruction.
   
2. **ID (Instruction Decode)**:
   - Decodes the fetched instruction.
   - Reads the registers from the register file.
   
3. **EX (Execute)**:
   - Performs the necessary arithmetic or logical operation based on the instruction.
   - Computes addresses for load/store operations.
   
4. **MEM (Memory Access)**:
   - Loads or stores data to/from data memory based on the instruction type.
   
5. **WB (Write Back)**:
   - Writes the result of the computation or memory access back to the register file.

