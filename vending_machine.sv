module vending_machine (
    input  logic clk,
    input  logic reset,
    input  logic coin_2,
    input  logic coin_5,
    input  logic coin_10,
    output logic dispense,
    output logic [5:0] balance,
    output logic [5:0] change
);

    typedef enum logic [2:0] {
        IDLE         = 3'b000,
        ADD_COIN     = 3'b001,
        CHECK_AMOUNT = 3'b010,
        DISPENSE     = 3'b011,
        RETURN_CHANGE = 3'b100
    } state_t;

    state_t current_state, next_state;
    logic [5:0] amount;
    logic [5:0] next_amount;
    
    parameter PRODUCT_PRICE = 15;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            amount <= 6'd0;
        end else begin
            current_state <= next_state;
            amount <= next_amount;
        end
    end

    always_comb begin
        next_state = current_state;
        next_amount = amount;
        dispense = 1'b0;
        balance = amount;
        change = 6'd0;

        case (current_state)
            IDLE: begin
                next_amount = 6'd0;
                balance = 6'd0;
                if (coin_2 || coin_5 || coin_10) begin
                    next_state = ADD_COIN;
                end
            end

            ADD_COIN: begin
                if (coin_2) begin
                    next_amount = amount + 6'd2;
                end else if (coin_5) begin
                    next_amount = amount + 6'd5;
                end else if (coin_10) begin
                    next_amount = amount + 6'd10;
                end
                next_state = CHECK_AMOUNT;
            end

            CHECK_AMOUNT: begin
                if (amount >= PRODUCT_PRICE) begin
                    next_state = DISPENSE;
                end else begin
                    next_state = IDLE;
                end
            end

            DISPENSE: begin
                dispense = 1'b1;
                if (amount > PRODUCT_PRICE) begin
                    next_state = RETURN_CHANGE;
                end else begin
                    next_state = IDLE;
                end
            end

            RETURN_CHANGE: begin
                change = amount - PRODUCT_PRICE;
                next_amount = 6'd0;
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
                next_amount = 6'd0;
            end
        endcase
    end

endmodule

