module tanh_tb;

    localparam DATA_WIDTH = 32;
    localparam FRAC_WIDTH = 16;

    // Testbench signals
    // logic clk;
    // logic rst;
    // logic start;
    logic signed [DATA_WIDTH-1:0] x_i;
    logic signed [DATA_WIDTH-1:0] tanh_o;
    // logic done;

    // Instantiate the DUT
    tanh #(
        .DATA_WIDTH(DATA_WIDTH),
        .FRAC_WIDTH(FRAC_WIDTH)
    ) dut (
        // .clk(clk),
        // .rst(rst),
        // .start(start),
        .x_i(x_i),
        .tanh_o(tanh_o)
        // .done(done)
    );

    // Clock generation
    // always #5 clk = ~clk;

    // Test sequence
    initial begin
        $monitor("x=%h , tanh=%h, actul tanh= %d", x_i,tanh_o,$tanh(x_i));
        // Initialize signals
        // clk = 0;
        // rst = 1;
        // start = 0;
        // x_i = 0;

        x_i = 32'h00020000;


        // x_i = 16'h0000;
        // #10;
        // x_i = 16'h0040;
        // #10;
        // x_i = 16'h0080; 
        // #10;
        // x_i = 16'h0180; 
        // #10;
        // x_i = 16'h0280;  
        // #10;
        // x_i = 16'h0080; 
        // #10;
        // x_i = 16'h0200;
        // #10;
        // x_i = 16'h0300;
        // #10;
        // x_i = 16'h0400;
        // #10;
        // x_i = 16'h0500;
        // #10;
        // x_i = 16'h0600;
        // #10;
        // x_i = 16'h0700;
        // #10;
        // x_i = 16'h0800;
        // #10;
        // x_i = 16'h0900;
        // #10;
        // x_i = 16'h0a00;   


        // // start = 1;

        // Wait for the done signal
        //@(posedge done);
        
        
    

        // Stop simulation
        #50;
        $finish;
    end
endmodule
















