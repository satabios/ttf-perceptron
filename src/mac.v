`default_nettype none

module mac 
( 
    input wire [3:0] x,
    input wire [3:0] w,
    input wire [7:0] previous_out,
    input wire       clk,
    input wire       rst_n, // reset_n - low to reset
    output reg [7:0] out
);
    reg [7:0] multiplier_output;
    reg [7:0] accumulation_out;

    always @(posedge clk) begin
        if (!rst_n) begin
            out <= 0;
        end else begin
            multiplier_output <= x * w;
            accumulation_out <= multiplier_output + previous_out;
            out <= accumulation_out;
        end
   

    
   
     end

endmodule
