import argparse


class Processor:
    def __init__(self, program):
        if not 1 <= len(program) <= 16 or any(not 0 <= word <= 255 for word in program):
            raise ValueError("program must contain 1-16 byte instructions")
        self.program = list(program) + [0xF0] * (16 - len(program))
        self.pc = 0
        self.acc = 0
        self.output = []
        self.halted = False
        self.cycles = 0

    def step(self):
        if self.halted:
            return
        word = self.program[self.pc]
        opcode, n = word >> 4, word & 15
        self.pc = (self.pc + 1) & 15
        if opcode == 0: pass
        elif opcode == 1: self.acc = n
        elif opcode == 2: self.acc = (self.acc + n) & 255
        elif opcode == 3: self.acc = (self.acc - n) & 255
        elif opcode == 4: self.acc &= n
        elif opcode == 5: self.acc |= n
        elif opcode == 6: self.acc ^= n
        elif opcode == 7: self.pc = n
        elif opcode == 8:
            if self.acc == 0: self.pc = n
        elif opcode == 9: self.output.append(self.acc)
        elif opcode == 15: self.halted = True
        else: raise ValueError(f"invalid opcode {opcode:X}")
        self.cycles += 1

    def run(self, max_steps=1000):
        for _ in range(max_steps):
            if self.halted:
                return self.output
            self.step()
        raise TimeoutError("program did not halt within step limit")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("words", nargs="+", help="hexadecimal instruction bytes")
    args = parser.parse_args()
    cpu = Processor([int(word, 16) for word in args.words])
    print("Output:", cpu.run(), "A:", cpu.acc, "PC:", cpu.pc, "Steps:", cpu.cycles)


if __name__ == "__main__":
    main()

