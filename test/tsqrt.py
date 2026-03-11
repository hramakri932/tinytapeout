import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import random
import math


async def reset_dut(dut):
    dut.ena.value = 0
    dut.reset.value = 1
    dut.start.value = 0
    dut.radicand.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)


async def run_sqrt(dut, value):
    dut.radicand.value = value
    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    # Wait until done goes high
    while dut.done.value == 0:
        await RisingEdge(dut.clk)

    result = dut.root.value.integer
    return result


@cocotb.test()
async def test_basic_values(dut):
    """Test some known values"""

    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    await reset_dut(dut)

    test_vectors = {
        0: 0,
        1: 1,
        4: 2,
        9: 3,
        15: 3,
        16: 4,
        63: 7,
        64: 8,
        255: 15,
    }

    for value, expected in test_vectors.items():
        result = await run_sqrt(dut, value)
        assert result == expected, \
            f"sqrt({value}) = {result}, expected {expected}"


@cocotb.test()
async def test_random_values(dut):
    """Randomized testing"""

    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    await reset_dut(dut)

    for _ in range(50):
        value = random.randint(0, 255)
        expected = int(math.isqrt(value))

        result = await run_sqrt(dut, value)

        assert result == expected, \
            f"sqrt({value}) = {result}, expected {expected}"