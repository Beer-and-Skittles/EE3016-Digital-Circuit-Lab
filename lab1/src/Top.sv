module Top (
	input        i_clk,				// clock
	input        i_rst_n,			// if true, reset all
	input        i_start,			// true if button is pressed
	output [3:0] o_random_out		// output random number, 0-15
);

// please check out the working example in lab1 README (or Top_exmaple.sv) first

// ===== States =====
parameter S_IDLE 	= 1'b0;
parameter S_PROC 	= 1'b1;
parameter A     	=     ;
parameter B      	=     ;
parameter M      	=     ;
parameter CYC_MAX	=     ;
parameter CYC_MIN   =     ;
parameter CYC_INDT  =     ;

// ===== Output Buffers =====
logic [3:0] o_random_out_r, o_random_out_w;

// ===== Registers & Wires =====
logic state_r, state_w;					// states
logic cyc_limit_r, cyc_limit_w;			// number of cycles to reach before changing new number
logic cyc_count_r, cyc_count_w;			// counts number of cycles
logic gen_num							// true: new number; false: remain same

// ===== Combinational Circuits =====
always_comb begin					

	state_w = state_r;
	if(i_start) begin
		state_w = S_PROC;
		cyc_limit	= ;
		cyc_count	= ;
		gen_num		= 1;
	end

	o_random_w = o_random_r;
	gen_random_num(
		.i_gen(gen_num),
		.i_a(A),
		.i_b(B),
		.i_m(M),
		.o_random_num(o_random_num_w)
	)

end

// ===== Sequential Circuits =====
always_ff @(posedge i_clk or negedge i_rst_n) begin

	if (!i_rst_n || cyc_limit_r == CYC_MAX) begin
		o_random_out_r	<= 4'd0;
		state_r			<= S_IDLE;
		cyc_count_r		<= 0;
		cyc_limit_r		<= MIN_CYC;
	end

	else begin

		o_random_out_r	<= o_random_out_w;
		state_r			<= state_w;
		cyc_count_r		<= cyc_count_w;
		cyc_limit_r		<= cyc_limit_w;

		if(cyc_limit_r == cyc_count_r) begin
			cyc_limit_w <= cyc_limit_r + 1;
			cyc_count_w <= 0;
			gen_num		<= 1;
		end

		else begin
			cyc_limit_w <= cyc_limit_r;
			cyc_count_w <= cyc_count_r + CYC_INDT;
			gen_num		<= 0;
		end

	end

end

endmodule


module gen_random_num (
	input 			i_gen;
	input			i_a;
	input			i_b;
	input			i_m;
	output			o_random_num;
);
	reg 			o_random_num_r, o_random_num_w;
	assign			o_random_num = o_random_num_r;

	always_comb begin
		if(i_gen)	o_random_num_w = (i_a * o_random_num_r) + (i_b % i_m);
		else		o_random_num_w = o_random_num_r;
	end

endmodule