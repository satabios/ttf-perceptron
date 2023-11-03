`default_nettype none

module tt_um_perceptron #( parameter inp_n_samples = 3,
                           parameter inp_dim = 2,
                           parameter out_dim = 1 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  
assign uio_oe = 8'b11111111;
assign uio_out = 8'b00000000;
reg [7:0] X [inp_dim-1:0][inp_n_samples-1:0]; // [dimnension of data][no. of samples]
reg signed [7:0] W [inp_dim-1:0];
reg signed [7:0] Y[inp_n_samples-1:0];
reg signed [7:0] z1;
reg signed [7:0] activation_out;
reg signed [7:0] delta;

wire [7:0] partial_mac_out;
reg [7:0] mac_out[inp_n_samples-1:0];
wire [7:0] y_current;


genvar i;
genvar j;

integer k,l;
integer mac_out_flag;


initial begin

    W[0]= {4'd0,4'd4};
    W[1]= {4'd0,4'd9};



    X[0][0] = {4'd0,4'd2};
    X[1][0]= {4'd0,4'd3};
    X[0][1] = {4'd0,4'd4};
    X[1][1]= {4'd0,4'd5};
    X[0][2] = {4'd0,4'd1};
    X[1][2]= {4'd0,4'd2};

    Y[0]= 8'd0;
    Y[1]= 8'd1;
    Y[2]= 8'd1;


    z1 = 8'd0;
    activation_out = 8'd0;
    delta = 8'd0;

     
    mac_out_flag = 0;
    mac_out[0]=0;

   


end

// for (i=0; i<inp_dim; i=i+1) begin
//     for (j=0; j<inp_n_samples; j=j+1) begin
//         mac my_mac_inst (
//             .x(X[i][j][3:0]),
//             .w(W[i][3:0]),
//             .previous_out(partial_mac_out),
//             .clk(clk),
//             .rst_n(rst_n),
//             .out(mac_out)
//         );
//         if(j==inp_n_samples-1)
//         assign mac_out_flag = 1;
//     end
//     assign partial_mac_out = mac_out;
//     assign y_current = Y[i];
   
//     end

always @(posedge clk)begin

 
    if(!rst_n)begin
        mac_out[0]=0;
        mac_out[1]=0;
        mac_out[2]=0;
        delta = 0;
    end
    else begin
    mac_out[0] = X[0][0][3:0] * W[0][3:0] + X[1][0][3:0] * W[1][3:0];
    activation_out[0] <= mac_out[0] > 8'd0 ? 8'd1 : 8'd0;    // stick to perceptron for now
    delta <= y_current - activation_out[0];
    W[0] <= W[0] + (delta * X[0][0]);
    W[1] <= W[1] + (delta * X[1][0]);


    mac_out[1] = X[0][1][3:0] * W[0][3:0] + X[1][1][3:0] * W[1][3:0];
    activation_out[1] <= mac_out[1] > 8'd0 ? 8'd1 : 8'd0;    // stick to perceptron for now
    delta <= y_current - activation_out[1];
    $display("Delta2:%d",delta);
    W[0] <= W[0] + (delta * X[0][1]);
    W[1] <= W[1] + (delta * X[1][1]);


    mac_out[2] = X[0][2][3:0] * W[0][3:0] + X[1][2][3:0] * W[1][3:0];
    activation_out[2] <= mac_out[2] > 8'd0 ? 8'd1 : 8'd0;    // stick to perceptron for now
    delta <= y_current - activation_out[2];
    $display("Delta3:%d",delta);
    W[0] <= W[0] + (delta * X[0][2]);
    W[1] <= W[1] + (delta * X[1][2]);


    $display("Out_1 X[0][0]:%d W[0]:%d X[1][0]:%d W[1]:%d M[0]%d",X[0][0][3:0] , W[0][3:0] , X[1][0][3:0] ,W[1][3:0], mac_out[0]);
    $display("Out_2 X[0][1]:%d W[0]:%d X[1][1]:%d W[1]:%d M[0]%d",X[0][1][3:0] , W[0][3:0] , X[1][1][3:0] ,W[1][3:0], mac_out[1]);
    $display("Out_3 X[0][2]:%d W[0]:%d X[1][2]:%d W[1]:%d M[0]%d",X[0][2][3:0] , W[0][3:0] , X[1][2][3:0] ,W[1][3:0], mac_out[2]);

    end
end


assign  uo_out = activation_out;


endmodule
