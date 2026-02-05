/*
 Copyright: Copyright (c) 2026 Veevx Inc. All rights reserved.
 Author: Vijayvithal <jvs@veevx.com>
 Created on: 2026-02-04
 Description: A brief description of the file's purpose.
*/
module i2c_apb(
    input  wire        clk,
    input  wire        arst_n,


    /*
     * Host interface
     */
    input wire s_apb_psel,
    input wire s_apb_penable,
    input wire s_apb_pwrite,
    input wire [2:0] s_apb_pprot,
    input wire [5:0] s_apb_paddr,
    input wire [31:0] s_apb_pwdata,
    input wire [3:0] s_apb_pstrb,
    output logic s_apb_pready,
    output logic [31:0] s_apb_prdata,
    output logic s_apb_pslverr,
    /*
     * I2C interface
     */
    input  wire        i2c_scl_i,
    output wire        i2c_scl_o,
    output wire        i2c_scl_t,
    input  wire        i2c_sda_i,
    output wire        i2c_sda_o,
    output wire        i2c_sda_t
);


 I2C_Reg_pkg::I2C_Reg__in_t hwif_in;
 I2C_Reg_pkg::I2C_Reg__out_t hwif_out;

I2C_Reg i2c_reg (
.clk(clk),
.arst_n(arst_n),

.s_apb_psel(s_apb_psel),
.s_apb_penable(s_apb_penable),
.s_apb_pwrite(s_apb_pwrite),
.s_apb_pprot(s_apb_pprot),
.s_apb_paddr(s_apb_paddr),
.s_apb_pwdata(s_apb_pwdata),
.s_apb_pstrb(s_apb_pstrb),
.s_apb_pready(s_apb_pready),
.s_apb_prdata(s_apb_prdata),
.s_apb_pslverr(s_apb_pslverr),
.hwif_in(hwif_in),
.hwif_out(hwif_out)
);

i2c_master i2c_master (
    .clk(clk),
    .rst(!arst_n),

    /*
     * Host interface
     */
    .s_axis_cmd_address(hwif_out.Commands.address.value),
    .s_axis_cmd_start(hwif_out.Commands.start.value),
    .s_axis_cmd_read(hwif_out.Commands.read.value),
    .s_axis_cmd_write(hwif_out.Commands.write.value),
    .s_axis_cmd_write_multiple(hwif_out.Commands.write_multiple.value),
    .s_axis_cmd_stop(hwif_out.Commands.stop.value),
    .s_axis_cmd_valid(), // TODO
    .s_axis_cmd_ready(), // TODO

    .s_axis_data_tdata(hwif_out.Wdata.wdata.value),
    .s_axis_data_tvalid(),
    .s_axis_data_tready(),
    .s_axis_data_tlast(),

    .m_axis_data_tdata(hwif_in.Rdata.rdata.next),
    .m_axis_data_tvalid(),
    .m_axis_data_tready(),
    .m_axis_data_tlast(),

    /*
     * I2C interface
     */
    .scl_i(i2c_scl_i),
    .scl_o(i2c_scl_o),
    .scl_t(i2c_scl_t),
    .sda_i(i2c_sda_i),
    .sda_o(i2c_sda_o),
    .sda_t(i2c_sda_t),

    /*
     * Status
     */
   .busy(hwif_in.Status.busy.next),
   .bus_control(hwif_in.Status.bus_control.next),
   .bus_active(hwif_in.Status.bus_active.next),
   .missed_ack(hwif_in.Status.missed_ack.next),

    /*
     * Configuration
     */
    .prescale(hwif_out.Cfg.prescale.value),
    .stop_on_idle(hwif_out.Cfg.stop_on_idle.value)  
);
endmodule
