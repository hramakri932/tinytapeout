import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
import random
import math


async def start_sqrt(dut, value):
    """Start a sqrt computation using rst_n rising edge."""
    cocotb.log.info(f"a"
    f"clk:{dut.clk.value} "
    f"ena:{dut.ena.value} "
    f"rst_n:{dut.rst_n.value} "
    f"ui_in:{dut.ui_in.value} "
    f"uo_out:{dut.uo_out.value} "
    )
    dut.ui_in.value = value

    # force reset low
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    cocotb.log.info(f"b"
    f"clk:{dut.clk.value} "
    f"ena:{dut.ena.value} "
    f"rst_n:{dut.rst_n.value} "
    f"ui_in:{dut.ui_in.value} "
    f"uo_out:{dut.uo_out.value} "
    )
    await RisingEdge(dut.clk)
    cocotb.log.info(f"b1"
    f"clk:{dut.clk.value} "
    f"ena:{dut.ena.value} "
    f"rst_n:{dut.rst_n.value} "
    f"ui_in:{dut.ui_in.value} "
    f"uo_out:{dut.uo_out.value} "
    )
    # release reset -> computation starts
    dut.rst_n.value = 1

    # wait long enough for computation
    for _ in range(5):
        cocotb.log.info(f"c"
            f"clk:{dut.clk.value} "
            f"ena:{dut.ena.value} "
            f"rst_n:{dut.rst_n.value} "
            f"ui_in:{dut.ui_in.value} "
            f"uo_out:{dut.uo_out.value} "
            )
        await RisingEdge(dut.clk)
    cocotb.log.info(f"d"
    f"clk:{dut.clk.value} "
    f"ena:{dut.ena.value} "
    f"rst_n:{dut.rst_n.value} "
    f"ui_in:{dut.ui_in.value} "
    f"uo_out:{dut.uo_out.value} "
    )


@cocotb.test()
async def test_known_values(dut):
    """Test predetermined inputs."""

    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    dut.ena.value = 1
    dut.rst_n.value = 1
    dut.ui_in.value = 0

    # await Timer(20, units="ns")

    test_values = [
        0, 1, 2, 3,
        4, 8, 9, 15,
        16, 24, 25,
        63, 64, 65,
        100,
        254, 255
    ]

    for val in test_values:

        await start_sqrt(dut, val)

        result = dut.uo_out.value.integer
        expected = int(math.isqrt(val))

        assert result == expected, \
            f"sqrt({val}) expected {expected} got {result}"


@cocotb.test()
async def test_random_values(dut):
    """Test random inputs."""

    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    dut.ena.value = 1
    dut.rst_n.value = 1
    dut.ui_in.value = 0

    await Timer(20, units="ns")

    for _ in range(200):

        val = random.randint(0, 255)

        await start_sqrt(dut, val)

        result = dut.uo_out.value.integer
        expected = int(math.isqrt(val))

        assert result == expected, \
            f"sqrt({val}) expected {expected} got {result}"