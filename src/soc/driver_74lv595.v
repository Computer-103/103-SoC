module driver_74lv595 (
    input  clk,
    input  resetn,

    input  [15:0] data_0,
    input  [15:0] data_1,
    input  [15:0] data_2,
    input  [15:0] data_3,

    output RCLK,            // storage register clock
    output SRCLK,           // shift register clock
    output SER_0,           // serial input
    output SER_1,           // serial input
    output SER_2,           // serial input
    output SER_3            // serial input
);

reg shift_clk;
reg store_clk;

reg [ 3:0] cnt;

reg [15:0] data_0_r;
reg [15:0] data_1_r;
reg [15:0] data_2_r;
reg [15:0] data_3_r;

always @(posedge clk) begin
    if (~resetn) begin
        shift_clk <= 1'b0;
    end else begin
        shift_clk <= ~shift_clk;
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        cnt <= 4'd0;
    end else if (!shift_clk) begin
        if (cnt == 4'd15) begin
            cnt <= 4'd0;
        end else begin
            cnt <= cnt + 4'd1;
        end
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        store_clk <= 1'b0;
    end else if (shift_clk) begin
        store_clk <= 1'b0;
    end else if (!shift_clk) begin
        if (cnt == 4'd15) begin
            store_clk <= 1'b1;
        end else begin
            store_clk <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (~resetn) begin
        data_0_r <= 16'd0;
        data_1_r <= 16'd0;
        data_2_r <= 16'd0;
        data_3_r <= 16'd0;
    end else if (!shift_clk) begin
        if (cnt == 4'd15) begin
            data_0_r <= data_0;
            data_1_r <= data_1;
            data_2_r <= data_2;
            data_3_r <= data_3;
        end else begin
            data_0_r <= {data_0_r[14:0], 1'b0};
            data_1_r <= {data_1_r[14:0], 1'b0};
            data_2_r <= {data_2_r[14:0], 1'b0};
            data_3_r <= {data_3_r[14:0], 1'b0};
        end
    end
end

assign RCLK = store_clk;
assign SRCLK = shift_clk;
assign SER_0 = data_0_r[15];
assign SER_1 = data_1_r[15];
assign SER_2 = data_2_r[15];
assign SER_3 = data_3_r[15];

endmodule