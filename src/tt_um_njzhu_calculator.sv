`default_nettype none

module tt_um_njzhu_calculator (
    input  logic [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output logic [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  logic [7:0] uio_in,   // IOs: Bidirectional Input path
    output logic [7:0] uio_out,  // IOs: Bidirectional Output path
    output logic [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  logic       ena,      // will go high when the design is enabled
    input  logic       clk,      // clock
    input  logic       rst_n     // reset_n - low to reset
);
    logic [3:0] inReg, outReg;
    logic [1:0] op;
    logic [3:0] a, b;
    assign a = ui_in[3:0];
    assign b = ui_in[7:4];
    assign op = uio_in[1:0];
    assign uio_oe = ~8'd3;
    assign uo_out = outReg;
    always_comb begin
        case (op)
          2'b00: inReg =  a + b;
          2'b01: inReg = a - b;
          2'b10: inReg = a | b;
          2'b11: inReg = (a == b) ? 4'd0 : 4'd1;        
        endcase
    end
    Register #(4) r1(.D(inReg), .en(1'b1), .clear(~rst_n), 
    .clock(clk), .Q(outReg));

endmodule : tt_um_njzhu_calculator

// A Register stores a multi-bit value.
// Async clear with greater priority over enable
module Register
    #(parameter WIDTH=8)
    (input logic [WIDTH-1:0] D,
     input logic en, clear, clock,
     output logic [WIDTH-1:0] Q);

    always_ff @(posedge clock, posedge clear)
        if (clear)
            Q <= 'b0;
        else if (en)
            Q <= D;

endmodule : Register