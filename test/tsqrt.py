import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import random
import math


async def rst_n_dut(dut):
    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.start.value = 0
    dut.ui_in.value = 0
    for _ in range(5):
        await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)


async def run_sqrt(dut, value):
    dut.ui_in.value = value
    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    # Wait until uio_out is set to busy
    while dut.uio_out.value == 0:
        await RisingEdge(dut.clk)

    result = dut.uo_out.value.integer
    return result


@cocotb.test()
async def test_basic_values(dut):
    """Test some known values"""

    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    await rst_n_dut(dut)

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

    await rst_n_dut(dut)

    for _ in range(50):
        value = random.randint(0, 255)
        expected = int(math.isqrt(value))

        result = await run_sqrt(dut, value)

        assert result == expected, \
            f"sqrt({value}) = {result}, expected {expected}"