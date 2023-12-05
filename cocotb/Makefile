I2C_ROOT=$(shell git rev-parse --show-toplevel)

VERILOG_SOURCES +=$(I2C_ROOT)/rtl/i2c_slave_axil_master.v
VERILOG_SOURCES +=$(I2C_ROOT)/rtl/i2c_slave.v
VERILOG_SOURCES +=$(I2C_ROOT)/cocotb/tb_axil_slave.v
MODULE=slave_axil_tb
TOPLEVEL=tb
include $(shell cocotb-config --makefiles)/Makefile.sim
