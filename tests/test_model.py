import unittest
from model import Processor


class ProcessorTests(unittest.TestCase):
    def test_arithmetic_and_output(self):
        cpu = Processor([0x12, 0x22, 0x90, 0xF0])
        self.assertEqual(cpu.run(), [4])
        self.assertEqual(cpu.cycles, 4)

    def test_wraparound_and_branch(self):
        cpu = Processor([0x10, 0x31, 0x21, 0x84, 0x90, 0xF0])
        self.assertEqual(cpu.run(), [0])
        self.assertEqual(cpu.acc, 0)

    def test_jump_and_step_limit(self):
        cpu = Processor([0x72, 0xFF, 0x14, 0x90, 0xF0])
        self.assertEqual(cpu.run(), [4])
        with self.assertRaises(TimeoutError): Processor([0x70]).run(10)

    def test_invalid_opcode(self):
        with self.assertRaises(ValueError): Processor([0xA0]).step()


if __name__ == "__main__":
    unittest.main()

