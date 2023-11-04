`default_nettype none

module tt_um_perceptron #( parameter n_samples = 3,
                           parameter inp_dim = 2
                           ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  //This copy works
assign uio_oe = 8'b11111111;
assign uio_out = 8'b00000000;


reg [7:0] X [inp_dim-1:0][n_samples-1:0]; // [dimnension of data][no. of samples]
reg signed [7:0] W [inp_dim-1:0];
reg signed [7:0] Y [n_samples-1:0];
reg signed [7:0] activation_out[n_samples-1:0];
reg signed [7:0] delta;
reg [7:0] mac_out[n_samples-1:0];




integer i;



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

    activation_out[0] = 0;
    activation_out[1] = 0;
    activation_out[2] = 0;
    delta = 8'd0;
    

     
   
    mac_out[0]=0;

   


end


always @(posedge clk)begin

 
    if(!rst_n)begin
        for(i=0;i<n_samples;i=i+1)begin
            mac_out[i] <= 0;
            activation_out[i] <= 0;
        end
  
        delta <= 0;
    end
    else begin


   for(i=0;i<n_samples;i=i+1)begin
    mac_out[i] <= X[0][i][3:0] * W[0][3:0] + X[1][i][3:0] * W[1][3:0];
    activation_out[i] <= mac_out[i] > 8'b00000000 ? 8'b11111111 : 8'b00000000;    // stick to perceptron for now
    delta <= Y[i] - activation_out[i];
    W[0] <= W[0] + (delta * X[0][i]);
    W[1] <= W[1] + (delta * X[1][i]);

   end

    end
end


assign  uo_out = activation_out[n_samples-1];


endmodule
