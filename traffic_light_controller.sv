module traffic_light_controller (
    input  logic clk,
    input  logic reset,
    input  logic TAORB,      
    output logic [1:0] LA,   // Light A : 10=green, 01=yellow, 00=red
    output logic [1:0] LB    // Light B 
);

    typedef enum logic [1:0] {
        S0 = 2'b00, // LA: green,  LB: red
        S1 = 2'b01, // LA: yellow,   LB: red (5 clock cycle)
        S2 = 2'b10, // LA: red, LB: green
        S3 = 2'b11  // LA: red, LB: yellow (5 clock cycle)
    } state_t;

    state_t current_state, next_state;
    logic [3:0] timer; // count 5

    // State Recording and Timer (Sequential Logic)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            timer <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == S1 || current_state == S3)
                timer <= timer + 1;
            else
                timer <= 0;
        end
    end

    // Next State Determination (Combinational Logic)
    always_comb begin
        case (current_state)
            S0: next_state = (TAORB == 1'b0) ? S1 : S0; // If A is empty, switch to yellow
            S1: next_state = (timer >= 4) ? S2 : S1;    // Wait 5 periods, then B turns green
            S2: next_state = (TAORB == 1'b1) ? S3 : S2; // If B is empty, switch to yellow
            S3: next_state = (timer >= 4) ? S0 : S3;    // Wait 5 periods, then A turns green
            default: next_state = S0;
        endcase
    end

    // Output Logic (Combinational Logic)
    always_comb begin
        case (current_state)
            S0: {LA, LB} = {2'b10, 2'b00};
            S1: {LA, LB} = {2'b01, 2'b00};
            S2: {LA, LB} = {2'b00, 2'b10};
            S3: {LA, LB} = {2'b00, 2'b01};
            default: {LA, LB} = {2'b00, 2'b00};
        endcase
    end

endmodule