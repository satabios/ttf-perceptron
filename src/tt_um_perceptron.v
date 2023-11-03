`default_nettype none

module tt_um_perceptron #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  

reg [7:0] X [1:0][2:0]; // [dimnension of data][no. of samples]
reg signed [7:0] W [1:0];
reg signed [7:0] Y[2:0];
reg [7:0] z1;
reg [7:0] activation_out;
reg signed [7:0] delta;

wire [7:0] partial_mac_out;
wire [7:0] mac_out;
wire [7:0] y_current;

genvar i;
genvar j;

integer k,l;



initial begin

    W[0]= {4'd0,4'd4};
    W[1]= {4'd0,4'd9};



    X[0][0] = {4'd0,4'd2};
    X[1][0]= {4'd0,4'd3};
    X[0][1] = {4'd0,4'd4};
    X[1][1]= {4'd0,4'd5};
    X[0][2] = {4'd0,4'd4};
    X[1][2]= {4'd0,4'd5};

    Y[0]= 8'd0;
    Y[1]= 8'd1;
    Y[2]= 8'd1;


    z1 = 8'd0;
    activation_out = 8'd0;
    delta = 8'd0;
   


end

for (i=0; i<3; i=i+1) begin
    for (j=0; j<3; j=j+1) begin
        mac my_mac_inst (
            .x(X[i][j][3:0]),
            .w(W[i][3:0]),
            .previous_out(partial_mac_out),
            .clk(clk),
            .rst_n(rst_n),
            .out(mac_out)
        );
    end
    assign partial_mac_out = mac_out;
    assign y_current = Y[i];

    end

always @(posedge clk)begin

     activation_out <= mac_out > 8'd0 ? 8'd1 : 8'd0;    // stick to perceptron for now
     delta <= y_current - activation_out;

    for(k =0 ;k <2;k=k+1) begin
        for(l=0;l<2;l=l+1) begin
            W[k][l] <= W[k][l] + delta * X[k][l];
        end
    end

     $display("%b %b %b",activation_out, y_current, delta);
end 

assign  uo_out = activation_out;


endmodule
