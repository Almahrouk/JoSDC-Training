module part1(DIN, Resetn, Clock, Run, Done);
    input [15:0] DIN;
    input Resetn, Clock, Run;
    output Done;

   // TODO: declare variables
   ......
	
    assign III = IR[15:13];
    assign Imm = IR[12];
    assign rX = IR[11:9];
    assign rY = IR[2:0];
    dec3to8 decX (rX_in, rX, R_in); // produce r0 - r7 register enables

    parameter T0 = 3'b000, T1 = 3'b001, T2 = 3'b010, T3 = 3'b011;

    // Control FSM state table
    always @(Tstep_Q, Run, Done) begin
        case (Tstep_Q)
            T0: // data is loaded into IR in this time step
                if (~Run) Tstep_D = T0;
                else Tstep_D = T1;
            T1: //TODO: finish the FSM
				......
				
        endcase
    end

    /* OPCODE format: III M XXX DDDDDDDDD, where 
    *     III = instruction, M = Immediate, XXX = rX
    *     If M = 0, DDDDDDDDD = 000000YYY = rY
    *     If M = 1, DDDDDDDDD = #D is the immediate operand 
    *
    *  III M  Instruction   Description
    *  --- -  -----------   -----------
    *  000 0: mv   rX,rY    rX <- rY
    *  000 1: mv   rX,#D    rX <- D (sign extended)
    *  001 1: mvt  rX,#D    rX <- D << 8
    *  010 0: add  rX,rY    rX <- rX + rY
    *  010 1: add  rX,#D    rX <- rX + D
    *  011 0: sub  rX,rY    rX <- rX - rY
    *  011 1: sub  rX,#D    rX <- rX - D */
    parameter mv = 3'b000, mvt = 3'b001, add = 3'b010, sub = 3'b011;
    // selectors for the BusWires multiplexer
    parameter _R0 = 4'b0000, _R1 = 4'b0001, _R2 = 4'b0010, _R3 = 4'b0011, //TODO: finish this
	 _R7 = 4'b0111, _G = 4'b1000, 
        _IR8_IR8_0 /* signed-extended immediate data */ = 4'b1001, 
        _IR7_0_0   /* immediate data << 8 */ = 4'b1010;
    // Control FSM outputs
    always @(*) begin
        // default values for control signals
        rX_in = 1'b0; A_in = 1'b0; G_in = 1'b0; AddSub = 1'b0; IR_in = 1'b0; Select = 4'bxxxx;
        Done = 1'b0;
        case (Tstep_Q)
            T0: // store instruction on DIN in IR 
                IR_in = 1'b1;
            T1: // define signals in T1
                case (III)
                    mv: begin
                        if (!Imm) Select = rY;           // mv rX, rY
                        else Select = _IR8_IR8_0;        // mv rX, #D
                        rX_in = 1'b1;                    // enable rX register
                        Done = 1'b1;
                    end
                    mvt: // ToDO: finish   mvt rX, #D
						  ....
                endcase
            T2: // define signals T2
                case (III)
                    // TODO 
						  .....
                endcase
            T3: // define T3
                case (III)
                    //TODO 
						  .......
                endcase
            default: ;
        endcase
    end   
   
    // Control FSM flip-flops
    always @(posedge Clock)
        if (!Resetn)
            //TODO 
		       ............		
   
    regn reg_0 (BusWires, Resetn, R_in[0], Clock, r0);
    regn reg_1 (BusWires, Resetn, R_in[1], Clock, r1);
    //TODO
	 .............
    regn reg_7 (BusWires, Resetn, R_in[7], Clock, r7);

	 //TODO: instantiate other registers and the adder/subtracter unit
    .......

    // define the internal processor bus
    always @(*)
        case (Select)
            _R0: BusWires = r0;
            _R1: BusWires = r1;
            //TODO
				......
            _R7: BusWires = r7;
            _G:  BusWires = G;
            _IR8_IR8_0: BusWires = {{7{IR[8]}}, IR[8:0]};   // sign extended
            _IR7_0_0: BusWires = {IR[7:0], 8'b00000000};   // padded with 0's
            default: BusWires = 16'bxxxxxxxxxxxxxxxx;
        endcase
endmodule

module dec3to8(E, W, Y);
    input E; // enable
    input [2:0] W;
    output [0:7] Y;
    reg [0:7] Y;
   
    always @(*)
        if (E == 0)
            Y = 8'b00000000;
        else
            case (W)
                3'b000: Y = 8'b10000000;
                3'b001: Y = 8'b01000000;
                3'b010: Y = 8'b00100000;
                3'b011: Y = 8'b00010000;
                3'b100: Y = 8'b00001000;
                3'b101: Y = 8'b00000100;
                3'b110: Y = 8'b00000010;
                3'b111: Y = 8'b00000001;
            endcase
endmodule

module regn(R, Resetn, Rin, Clock, Q);
    parameter n = 16;
    input [n-1:0] R;
    input Resetn, Rin, Clock;
    output [n-1:0] Q;
    reg [n-1:0] Q;

    always @(posedge Clock)
        if (!Resetn)
            Q <= 0;
        else if (Rin)
            Q <= R;
endmodule
