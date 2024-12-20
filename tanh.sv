module tanh #(
    parameter DATA_WIDTH = 32,   // Fixed-point data width
    parameter FRAC_WIDTH = 16   // Number of fractional bits
)(
    input  logic signed [DATA_WIDTH-1:0] x_i,  // Input value in fixed-point
    output logic signed [DATA_WIDTH-1:0] tanh_o // tanh(x) output
);

    // Internal signals
    logic signed [DATA_WIDTH-1:0] x2, x3;       // x^2 and x^3
    logic signed [DATA_WIDTH-1:0] exp_pos, exp_neg; // e^x and e^(-x)
    logic signed [DATA_WIDTH-1:0] numerator, denominator;
    logic signed [DATA_WIDTH-1:0] result;

    logic signed [(2*DATA_WIDTH)-1:0] x2_before_shift_reg, x3_before_shift_reg;

    logic signed [2*DATA_WIDTH-1:0] exp_neg_numerator_high_precision;

    logic signed [(2*DATA_WIDTH)-1:0] numerator_scaled;

    // Compute x^2 and x^3 (with fractional shift)
    assign x2_before_shift_reg = x_i * x_i; 
    assign x3_before_shift_reg = x2_before_shift_reg[47:16] * x_i;

    assign x2 = x2_before_shift_reg >>> FRAC_WIDTH; // Compute x^2
    assign x3 = x3_before_shift_reg >>> FRAC_WIDTH; // Compute x^3

    // Compute exp_pos = e^x
    assign exp_pos = (1 <<< FRAC_WIDTH) + x_i + (x2 >>> 1) + (x3 / 6); // Compute e^x

    // Compute exp_neg = e^(-x)
    // assign exp_neg = (1 * (1 <<< (FRAC_WIDTH * 2))) / exp_pos; // Compute e^(-x)

    assign exp_neg_numerator_high_precision = (1 <<< (FRAC_WIDTH * 2)); // Wider numerator
    assign exp_neg = exp_neg_numerator_high_precision / exp_pos;       // Compute e^(-x) with more precision    

    // Compute numerator and denominator for tanh
    assign numerator = exp_pos - exp_neg;
    assign denominator = exp_pos + exp_neg;


    assign numerator_scaled   = numerator * (1 <<< FRAC_WIDTH);
    // Compute result for tanh(x)
    assign result = numerator_scaled / denominator; // Numerator is scaled before division

    // Saturate the result to fit within the specified data width (to avoid overflow)
    assign tanh_o = (result > (1 <<< FRAC_WIDTH)) ? (1 <<< FRAC_WIDTH) : result;

endmodule

































// module tanh #(
//     parameter DATA_WIDTH = 16,   // Fixed-point data width
//     parameter FRAC_WIDTH = 8    // Number of fractional bits
// )(
//     input  logic signed [DATA_WIDTH-1:0] x_i, // Input value in fixed-point
//     output logic signed [DATA_WIDTH-1:0] tanh_o // tanh(x) output
// );

//     // Internal signals
//     logic signed [DATA_WIDTH-1:0] x2, x3;       // x^2 and x^3
//     logic signed [DATA_WIDTH-1:0] exp_pos, exp_neg; // e^x and e^(-x)
//     logic signed [DATA_WIDTH-1:0] numerator, denominator;
//     logic signed [DATA_WIDTH-1:0] result;

//     logic signed [(2*DATA_WIDTH)-1:0] x2_before_shift_reg, x3_before_shift_reg;

//     // Compute x^2 and x^3 (with fractional shift)
//     assign x2_before_shift_reg = 32'( x_i * x_i ); 
//     assign x3_before_shift_reg = 32'( x2_before_shift_reg[23:8] * x_i );

//     assign x2 = 16'(x2_before_shift_reg >>> FRAC_WIDTH); // Compute x^2
//     assign x3 = 16'(x3_before_shift_reg >>> FRAC_WIDTH); // Compute x^3


//     // Compute exp_pos = e^x
//     assign exp_pos = (1 <<< FRAC_WIDTH) + x_i + 16'(x2 >>> 1) + 16'(x3 / 6); // Compute e^x


//     // Compute exp_neg = e^(-x)
//      assign exp_neg = (1 * (1<<< (FRAC_WIDTH*2))) / exp_pos; // Compute e^(-x)
//     //    assign exp_neg = (1 <<<(FRAC_WIDTH)) / exp_pos; // Compute e^(-x)


//     // Compute numerator and denominator for tanh
//     assign numerator = exp_pos - exp_neg;
//     assign denominator = exp_pos + exp_neg;


//     // Compute result for tanh(x)
//     assign result = (numerator * (1 <<< FRAC_WIDTH)) / denominator; // Numerator is scaled before division


//     // Saturate the result to fit within the specified data width (to avoid overflow)
//     assign tanh_o = (result > (1 <<< FRAC_WIDTH)) ? (1 <<< FRAC_WIDTH) : result;


// endmodule




















// module tanh #(
//     parameter DATA_WIDTH = 16,   // Fixed-point data width
//     parameter FRAC_WIDTH = 8    // Number of fractional bits
// )(
//     input  logic clk,                // Clock signal
//     input  logic rst,                // Reset signal
//     input  logic start,              // Start computation
//     input  logic signed [DATA_WIDTH-1:0] x_i, // Input value in fixed-point
//     output logic signed [DATA_WIDTH-1:0] tanh_o, // tanh(x) output
//     output logic done                 // Computation complete
// );

//     // FSM states
//     typedef enum logic [3:0] {
//         IDLE,
//         CALC_X2,
//         CALC_X3,
//         CALC_EXP_POS,
//         CALC_EXP_NEG,
//         CALC_NUM_DEN,
//         CALC_RESULT,
//         CALC_TANH_OUT,
//         DONE
//     } state_t;

//     state_t state, next_state;

//     // Internal signals
//     logic signed [DATA_WIDTH-1:0] x2, x3;       // x^2 and x^3
//     logic signed [DATA_WIDTH-1:0] exp_pos, exp_neg; // e^x and e^(-x)
//     logic signed [DATA_WIDTH-1:0] numerator, denominator;
//     logic signed [DATA_WIDTH-1:0] result;

//     logic signed [(2*DATA_WIDTH)-1:0] x2_before_sfift_reg, x3_before_sfift_reg;


//     assign x2_before_sfift_reg = 16'( x_i * x_i ) ; 

//     assign x3_before_sfift_reg = 16'( x2_before_sfift_reg[23:8] * x_i );

//     // State transition logic
//     always_comb begin
//         case (state)
//             IDLE:         next_state = start ? CALC_X2 : IDLE;
//             CALC_X2:      next_state = CALC_X3;
//             CALC_X3:      next_state = CALC_EXP_POS;
//             CALC_EXP_POS: next_state = CALC_EXP_NEG;
//             CALC_EXP_NEG: next_state = CALC_NUM_DEN;
//             CALC_NUM_DEN: next_state = CALC_RESULT;
//             CALC_RESULT:  next_state = CALC_TANH_OUT;
//             CALC_TANH_OUT: next_state = DONE;
//             DONE:         next_state = IDLE;
//             default:      next_state = IDLE;
//         endcase
//     end

//     // FSM sequential logic
//     always_ff @(posedge clk or posedge rst) begin
//         if (rst) begin
//             state <= IDLE;
//             x2 <= 0; x3 <= 0; exp_pos <= 0; exp_neg <= 0;
//             numerator <= 0; denominator <= 0; result <= 0;
//             tanh_o <= 0; done <= 0;
//         end else begin
//             state <= next_state;
//             case (state)
//                 IDLE: begin
//                     done <= 0;
//                 end

//                 CALC_X2: begin
//                     x2 <= 16'(x2_before_sfift_reg  >>> FRAC_WIDTH); // Compute x^2
//                     $monitor("DEBUG: x2 <= %h",x2);
//                 end

//                 CALC_X3: begin
//                     x3 <= 16'(x3_before_sfift_reg >>> FRAC_WIDTH); // Compute x^3
//                     $monitor("DEBUG: x3 <= %h",x3);
//                 end

//                 CALC_EXP_POS: begin
//                     exp_pos <= (1 <<< FRAC_WIDTH) + x_i + 16'(x2 >>> 1) + 16'(x3 / 6); // Compute e^x
//                     $monitor("DEBUG: exp_pos <= %h",exp_pos);
//                 end

//                 CALC_EXP_NEG: begin
//                      exp_neg <= (1 <<< (FRAC_WIDTH)) / exp_pos; // Compute e^(-x)
//                     //exp_neg <= ((1 <<< (FRAC_WIDTH * 2)) / exp_pos); // Scale numerator to retain precision

//                     $monitor("DEBUG: exp_neg <= %h",exp_neg);
//                 end

//                 CALC_NUM_DEN: begin
//                     numerator   <= exp_pos - exp_neg;
//                     denominator <= exp_pos + exp_neg;
//                     $display("DEBUG: numerator <= %h",numerator);
//                     $monitor("DEBUG: denominator <= %h",denominator);                    
//                 end

//                 CALC_RESULT: begin
//                     //result <= (numerator << FRAC_WIDTH) / denominator; // Compute tanh(x)
//                     result = (numerator * (1 <<< FRAC_WIDTH)) / denominator; // Numerator is scaled before division
//                     $display("DEBUG: result <= %h",result);
//                 end

//                 CALC_TANH_OUT: begin
//                     tanh_o <= (result > (1 <<< FRAC_WIDTH)) ? (1 <<< FRAC_WIDTH) : result; // Saturate
//                     $display("DEBUG: tanh_o <= %h",tanh_o);
//                 end

//                 DONE: begin
//                     done <= 1; // Signal that computation is complete
//                 end
//             endcase
//         end
//     end
// endmodule


