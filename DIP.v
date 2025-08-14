`timescale 1ns / 1ps

module DIP(
    output reg [7:0] Rout, Gout, Bout,
    output reg OKout,
    input [7:0] Rin, Gin, Bin, value,
    input [2:0] operation,
    input clka, reset, OKin
);

    // 9-bit registers for calculations to handle overflow
    reg [8:0] Rtemp, Gtemp, Btemp;
    reg [7:0] gray_value;
    
    // Operation codes
    parameter BRIGHTNESS_UP = 3'b000;
    parameter BRIGHTNESS_DOWN = 3'b001;
    parameter GRAYSCALE = 3'b010;
    parameter RED_ONLY = 3'b011;
    parameter GREEN_ONLY = 3'b100;
    parameter BLUE_ONLY = 3'b101;
    parameter THRESHOLD = 3'b110;
    parameter INVERT = 3'b111;
    
    // Grayscale calculation based on luminance formula
    // Approximated using bit shifts: Y ≈ (R>>2) + (R>>5) + (R>>6) + (G>>1) + (G>>4) + (G>>6) + (B>>4) + (B>>5) + (B>>6)
    always @(*) begin
        gray_value = (Rin >> 2) + (Rin >> 5) + (Rin >> 6) + 
                     (Gin >> 1) + (Gin >> 4) + (Gin >> 6) + 
                     (Bin >> 4) + (Bin >> 5) + (Bin >> 6);
    end

    always @(posedge clka) begin
        if (reset) begin
            // Reset all outputs
            Rout <= 8'd0;
            Gout <= 8'd0;
            Bout <= 8'd0;
            OKout <= 1'b0;
        end
        else if (OKin) begin
            case (operation)
                BRIGHTNESS_UP: begin
                    // Increase brightness with saturation protection
                    Rtemp = Rin + value;
                    Gtemp = Gin + value;
                    Btemp = Bin + value;
                    
                    Rout <= (Rtemp > 255) ? 8'd255 : Rtemp[7:0];
                    Gout <= (Gtemp > 255) ? 8'd255 : Gtemp[7:0];
                    Bout <= (Btemp > 255) ? 8'd255 : Btemp[7:0];
                    OKout <= 1'b1;
                end
                
                BRIGHTNESS_DOWN: begin
                    // Decrease brightness with underflow protection
                    Rout <= (Rin > value) ? (Rin - value) : 8'd0;
                    Gout <= (Gin > value) ? (Gin - value) : 8'd0;
                    Bout <= (Bin > value) ? (Bin - value) : 8'd0;
                    OKout <= 1'b1;
                end
                
                GRAYSCALE: begin
                    // Apply grayscale to all channels
                    Rout <= gray_value;
                    Gout <= gray_value;
                    Bout <= gray_value;
                    OKout <= 1'b1;
                end
                
                RED_ONLY: begin
                    // Isolate red channel
                    Rout <= Rin;
                    Gout <= 8'd0;
                    Bout <= 8'd0;
                    OKout <= 1'b1;
                end
                
                GREEN_ONLY: begin
                    // Isolate green channel
                    Rout <= 8'd0;
                    Gout <= Gin;
                    Bout <= 8'd0;
                    OKout <= 1'b1;
                end
                
                BLUE_ONLY: begin
                    // Isolate blue channel
                    Rout <= 8'd0;
                    Gout <= 8'd0;
                    Bout <= Bin;
                    OKout <= 1'b1;
                end
                
                THRESHOLD: begin
                    // Apply binary threshold based on grayscale value
                    if (gray_value > value) begin
                        Rout <= 8'd255;
                        Gout <= 8'd255;
                        Bout <= 8'd255;
                    end
                    else begin
                        Rout <= 8'd0;
                        Gout <= 8'd0;
                        Bout <= 8'd0;
                    end
                    OKout <= 1'b1;
                end
                
                INVERT: begin
                    // Invert all color channels
                    Rout <= 8'd255 - Rin;
                    Gout <= 8'd255 - Gin;
                    Bout <= 8'd255 - Bin;
                    OKout <= 1'b1;
                end
                
                default: begin
                    // Pass through original values
                    Rout <= Rin;
                    Gout <= Gin;
                    Bout <= Bin;
                    OKout <= 1'b1;
                end
            endcase
        end
        else begin
            // When input not valid, clear outputs
            Rout <= 8'd0;
            Gout <= 8'd0;
            Bout <= 8'd0;
            OKout <= 1'b0;
        end
    end

endmodule
