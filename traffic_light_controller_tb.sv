`timescale 1ns/1ps

module traffic_light_tb();

    // 1. Sinyal Tanımlamaları
    logic clk;
    logic reset;
    logic TAORB;
    logic [1:0] LA, LB;

    // 2. Modülü Test Düzeneğine Bağla (Device Under Test)
    traffic_light_controller dut (
        .clk(clk),
        .reset(reset),
        .TAORB(TAORB),
        .LA(LA),
        .LB(LB)
    );

    // 3. Saat Sinyali (10ns Periyotlu clk)
    always #5 clk = ~clk;

    // 4. Test Senaryosu
    initial begin
        // Başlangıç Ayarları
        clk = 0;
        reset = 1;
        TAORB = 1; // A sokağı yoğun başlasın
        
        #20 reset = 0; // 20ns sonra sistemi çalıştır
        
        // DURUM 1: A'da trafik biterse (S0 -> S1 geçişi beklenir)
        #50 TAORB = 0; 
        
        // DURUM 2: Sarı ışıkta (S1) 5 saat darbesi beklemeyi izle
        #100; 
        
        // DURUM 3: B'de trafik varken A'ya araç gelirse (S2 -> S3 geçişi)
        #50 TAORB = 1;
        
        #200 $stop; // Simülasyonu bitir
    end

endmodule