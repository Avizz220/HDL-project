module testbench;

    logic clk;
    logic reset;
    logic coin_2;
    logic coin_5;
    logic coin_10;
    logic dispense;
    logic [5:0] balance;
    logic [5:0] change;

    vending_machine dut (
        .clk(clk),
        .reset(reset),
        .coin_2(coin_2),
        .coin_5(coin_5),
        .coin_10(coin_10),
        .dispense(dispense),
        .balance(balance),
        .change(change)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        coin_2 = 0;
        coin_5 = 0;
        coin_10 = 0;

        #20;
        reset = 0;
        #10;
        $display("\n========== VENDING MACHINE SIMULATION ==========");
        $display("Product Price: Rs. 15");
        $display("Coins: Rs. 2, Rs. 5, Rs. 10");
        $display("===============================================\n");

        $display("--- Test 1: Insert Rs.5 + Rs.10 (Exact Rs.15) ---");
        #20 coin_5 = 1;
        #20 coin_5 = 0;
        $display("Time=%0t | Inserted Rs.5 | Balance=%0d", $time, balance);
        
        #40 coin_10 = 1;
        #20 coin_10 = 0;
        $display("Time=%0t | Inserted Rs.10 | Balance=%0d", $time, balance);
        
        #40;
        if (dispense) 
            $display("Time=%0t | Product Dispensed | Change=%0d\n", $time, change);

        #50;

        $display("--- Test 2: Insert Rs.10 + Rs.10 (Rs.20 - Excess Rs.5) ---");
        #20 coin_10 = 1;
        #20 coin_10 = 0;
        $display("Time=%0t | Inserted Rs.10 | Balance=%0d", $time, balance);
        
        #40 coin_10 = 1;
        #20 coin_10 = 0;
        $display("Time=%0t | Inserted Rs.10 | Balance=%0d", $time, balance);
        
        #40;
        if (dispense) 
            $display("Time=%0t | Product Dispensed | Change=%0d\n", $time, change);

        #50;

        $display("--- Test 3: Insert only Rs.5 (Insufficient) ---");
        #20 coin_5 = 1;
        #20 coin_5 = 0;
        $display("Time=%0t | Inserted Rs.5 | Balance=%0d", $time, balance);
        
        #40;
        if (!dispense) 
            $display("Time=%0t | Insufficient Amount - No Product\n", $time);

        #50;

        $display("--- Test 4: Insert Rs.5 three times (Rs.15) ---");
        #20 coin_5 = 1;
        #20 coin_5 = 0;
        $display("Time=%0t | Inserted Rs.5 | Balance=%0d", $time, balance);
        
        #40 coin_5 = 1;
        #20 coin_5 = 0;
        $display("Time=%0t | Inserted Rs.5 | Balance=%0d", $time, balance);
        
        #40 coin_5 = 1;
        #20 coin_5 = 0;
        $display("Time=%0t | Inserted Rs.5 | Balance=%0d", $time, balance);
        
        #40;
        if (dispense) 
            $display("Time=%0t | Product Dispensed | Change=%0d\n", $time, change);

        #100;
        $display("===============================================");
        $display("         SIMULATION COMPLETED");
        $display("===============================================\n");
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench);
    end
    
    initial begin
        $monitor("Time=%0t | Balance=Rs.%0d | Dispense=%b | Change=Rs.%0d", 
                 $time, balance, dispense, change);
    end

endmodule

