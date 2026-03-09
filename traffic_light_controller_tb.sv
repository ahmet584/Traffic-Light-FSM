`timescale 1ns/1ps

module traffic_light_tb();

    logic clk;
    logic reset;
    logic TAORB;
    logic [1:0] LA, LB;

    // Device Under Test
    traffic_light_controller dut (
        .clk(clk),
        .reset(reset),
        .TAORB(TAORB),
        .LA(LA),
        .LB(LB)
    );

    //  10ns Period clk
    always #5 clk = ~clk;

    // Test Scenario
    initial begin
        // initial conditions
        clk = 0;
        reset = 1;
        TAORB = 1; // Street A is busy
        
        #20 reset = 0; // Start the system after 20 ns
        
        // If traffic ends at A (S0 -> S1)
        #50 TAORB = 0; 
        
        // Waiting for 5 clock pulse at yellow light (S1)
        #100; 
        
        // S2 -> S3 
        #50 TAORB = 1;
        
        #200 $stop; // Simülasyonu bitir
    end

endmodule