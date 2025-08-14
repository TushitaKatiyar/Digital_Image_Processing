`timescale 1ns / 1ps

module DIP_TB;

    integer file;
    
    // Inputs
    reg [7:0] Rin, Gin, Bin, value;
    reg [2:0] operation;
    reg clka, reset, OKin;
    
    reg ena, wea;
    reg [17:0] addra;
    reg [23:0] dina;
    
    // Outputs
    wire [7:0] Rout, Gout, Bout;
    wire OKout;
    
    wire [23:0] douta;
    
    // State machine definition
    reg [2:0] state;
    parameter IDLE = 3'd0, READ_DATA = 3'd1, PROCESS = 3'd2, WRITE_DATA = 3'd3, DONE = 3'd4;
    
    // Operation codes (for reference)
    parameter BRIGHTNESS_UP = 3'b000;
    parameter BRIGHTNESS_DOWN = 3'b001;
    parameter GRAYSCALE = 3'b010;
    parameter RED_ONLY = 3'b011;
    parameter GREEN_ONLY = 3'b100;
    parameter BLUE_ONLY = 3'b101;
    parameter THRESHOLD = 3'b110;
    parameter INVERT = 3'b111;
    
    // Instantiate the memory module
    bram_new uut (
        .clka(clka),
        .ena(ena), 
        .wea(wea), 
        .addra(addra), 
        .dina(dina), 
        .douta(douta)
    );
    
    // Instantiate the image processing module
    DIP uut2 (
        .Rin(Rin),
        .Gin(Gin),
        .Bin(Bin),
        .value(value),
        .operation(operation),
        .clka(clka),
        .reset(reset),
        .OKin(OKin),
        .Rout(Rout),
        .Gout(Gout),
        .Bout(Bout),
        .OKout(OKout)
    );
    
    // Maximum number of pixels to process in the image
    parameter MAX_PIXELS = 18'd200000;
    
    initial begin
        // Initialize all signals
        clka = 1'b0;
        Rin = 8'd0;
        Gin = 8'd0;
        Bin = 8'd0;
        operation = INVERT;  // Select operation here
        value = 8'd10;       // Value for brightness adjustment or threshold
        reset = 1'b1;        // Start with reset active
        OKin = 1'b0;
        
        wea = 1'b0;
        addra = 18'd0;
        dina = 24'd0;
        ena = 1'b1;
        state = IDLE;
        
        // Release reset after a few cycles
        #10 reset = 1'b0;
        
        // Open the output file for writing processed image data
        file = $fopen("C:/Users/tushi/Verilog HDL based Image Processing Core/Digital Image Processing.sim/sim_1/behav/xsim/processed_image.coe","wb");
        if (file == 0) begin
            $display("Error: Could not open output file");
            $finish;
        end
        
        // Write COE file header for memory initialization
        $fwrite(file,"memory_initialization_radix=2;\n");
        $fwrite(file,"memory_initialization_vector=\n");
        
        $display("Starting image processing...");
    end
    
    // Clock generation - 100MHz clock (10ns period)
    initial begin
        clka = 1'b0;
        forever #5 clka = ~clka;
    end
    
    // Main processing state machine
    always @(posedge clka) begin
        if (reset) begin
            // Reset state
            addra <= 18'd0;
            state <= IDLE;
            OKin <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    // Check if we have more pixels to process
                    if (addra < MAX_PIXELS) begin
                        state <= READ_DATA;
                        OKin <= 1'b0;
                    end
                    else begin
                        state <= DONE;
                    end
                end
                
                READ_DATA: begin
                    // Extract RGB components from memory data
                    {Rin, Gin, Bin} <= douta;
                    OKin <= 1'b1;
                    state <= PROCESS;
                end
                
                PROCESS: begin
                    // Wait for processing to complete (signaled by OKout)
                    if (OKout) begin
                        state <= WRITE_DATA;
                        OKin <= 1'b0;
                    end
                end
                
                WRITE_DATA: begin
                    // Write processed pixel data to output file in binary format
                    if (addra == MAX_PIXELS - 1) begin
                        $fwrite(file,"%08b%08b%08b;", Rout, Gout, Bout);
                    end
                    else begin
                        $fwrite(file,"%08b%08b%08b,\n", Rout, Gout, Bout);
                    end
                    
                    addra <= addra + 1;
                    state <= IDLE;
                    
                    // Display progress every 1000 pixels
                    if (addra % 1000 == 0) begin
                        $display("Processed %d pixels", addra);
                    end
                end
                
                DONE: begin
                    // Processing complete - close file and end simulation
                    $fclose(file);
                    $display("Processing complete! %d pixels processed.", addra);
                    $display("Output written to processed_image.coe");
                    $finish;
                end
                
                default: state <= IDLE;
            endcase
        end
    end
    
    // Timeout protection to prevent infinite simulation
    initial begin
        #50000000; // 50ms timeout
        $display("Simulation timeout reached");
        if (file != 0) $fclose(file);
        $finish;
    end
    
endmodule