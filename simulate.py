# Initial register values (Decimal)
AC = 255      # Accumulator
E = 1         # Extension bit
PC = 100      # Program Counter
AR = 0        # Address Register
IR = 0        # Instruction Register

def fetch_and_execute(hex_instr, name):
    global AC, E, PC, AR, IR
    
    # Phase 1: Fetch/Decode simulation
    AR = PC
    IR = int(hex_instr, 16)
    PC += 1
    
    # Phase 2: Execute
    if name == "CLA":
        AC = 0
    elif name == "CMA":
        AC = ~AC & 0xFFFF  # 16-bit complement
    elif name == "CME":
        E = 1 - E          # Flip bit
    elif name == "HLT":
        print("--- System Halted ---")
    
    print(f"After {name}: AC={AC}, E={E}, PC={PC}, AR={AR}, IR={IR}")

# Simulated Sequence
fetch_and_execute("7800", "CLA")
fetch_and_execute("7200", "CMA")
fetch_and_execute("7100", "CME")
fetch_and_execute("7001", "HLT")