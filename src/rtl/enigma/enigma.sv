`timescale 1ns / 1ps

module enigma(
   input        clk,
   input        reset_n,
   input  [4:0] char_in,
   input [14:0] key,
   input  [1:0] rA_cfg,
   input  [1:0] rB_cfg,
   input  [1:0] rC_cfg,
   input        load_key_cfg,
   input        new_char_pulse,
   output [4:0] char_out
   
    );

logic      [25:0][4:0] ROTOR_A_MAP;
logic      [25:0][4:0] ROTOR_B_MAP;
logic      [25:0][4:0] ROTOR_C_MAP;
logic [2:0][25:0][4:0] ROTORS_MAP;
logic            [4:0] ROTOR_A_NOTCH;
logic            [4:0] ROTOR_B_NOTCH;
logic            [4:0] ROTOR_C_NOTCH;
logic       [2:0][4:0] ROTORS_NOTCH;
logic                  rA_notch_out;
logic                  rB_notch_out;

logic [4:0] rA_char_out_fwd;
logic [4:0] rB_char_out_fwd;
logic [4:0] rC_char_out_fwd;
logic [4:0] rA_char_out_rev;
logic [4:0] rB_char_out_rev;
logic [4:0] rC_char_out_rev;
logic [4:0] pbg_char_out_fwd;
logic [4:0] refl_char_out;

localparam [25:0][4:0] ROTOR1_MAP = '{
    5'd9,  5'd2,  5'd17, 5'd1,  5'd8,  5'd0,  5'd15, 5'd18, 5'd20, 5'd23,
    5'd7,  5'd24, 5'd22, 5'd14, 5'd19, 5'd13, 5'd25, 5'd21, 5'd16, 5'd3,
    5'd6,  5'd11, 5'd5,  5'd12, 5'd10, 5'd4
};

localparam [4:0] ROTOR1_NOTCH = 5'd16; // Q

localparam [25:0][4:0] ROTOR2_MAP = '{
    5'd4,  5'd14, 5'd21, 5'd5,  5'd24, 5'd15, 5'd13, 5'd25, 5'd6,  5'd16,
    5'd2,  5'd12, 5'd19, 5'd22, 5'd7,  5'd11, 5'd1,  5'd23, 5'd20, 5'd17,
    5'd8,  5'd18, 5'd10, 5'd3,  5'd9,  5'd0
};

localparam [4:0] ROTOR2_NOTCH = 5'd4; // E

localparam [25:0][4:0] ROTOR3_MAP = '{
    5'd14, 5'd16, 5'd18, 5'd20, 5'd12, 5'd10, 5'd0,  5'd6,  5'd22, 5'd8,
    5'd4,  5'd24, 5'd13, 5'd25, 5'd21, 5'd23, 5'd19, 5'd17, 5'd15, 5'd2,
    5'd11, 5'd9,  5'd7,  5'd5,  5'd3,  5'd1
};

localparam [4:0] ROTOR3_NOTCH = 5'd21; // V

// ROTORS VALUES SELECTION
assign ROTORS_MAP = {ROTOR3_MAP, ROTOR2_MAP, ROTOR1_MAP};
assign ROTOR_A_MAP = ROTORS_MAP[rA_cfg];
assign ROTOR_B_MAP = ROTORS_MAP[rB_cfg];
assign ROTOR_C_MAP = ROTORS_MAP[rC_cfg];

// NOTCH SELECTION
assign ROTORS_NOTCH = {ROTOR3_NOTCH, ROTOR2_NOTCH, ROTOR1_NOTCH};
assign ROTOR_A_NOTCH = ROTORS_NOTCH[rA_cfg];
assign ROTOR_B_NOTCH = ROTORS_NOTCH[rB_cfg];
assign ROTOR_C_NOTCH = ROTORS_NOTCH[rC_cfg];


plugboard pbg(
    .char_in_fw(char_in),
    .char_out_fw(pbg_char_out_fwd),
    .char_in_rev(rA_char_out_rev),
    .char_out_rev(char_out)
    );

rotor rA ( // right
    .MAP_FWD(ROTOR_A_MAP),
    .NOTCH(ROTOR_A_NOTCH),
    .notch_in(1'b0),   // semnal notch de la rotorul anterior
    .new_char(new_char_pulse),     // o noua tasta a fost apasata
    .load_key(load_key_cfg),     // incarca valoarea de start (comanda data de user)
    .char_in_fwd(pbg_char_out_fwd),      // litera de intrare 0-25
    .char_in_rev(rB_char_out_rev),  // litera de intrare 0-25
    .key(key[4:0]),          // pozitia initiala a rotorului
    .char_out_fwd(rA_char_out_fwd), // iesire catre urmatorul rotor/reflector
    .char_out_rev(rA_char_out_rev), // iesire reverse
    .notch_out(rA_notch_out),     // semnal notch pentru urmatorul rotor
    .*
);


rotor rB ( // middle
    .MAP_FWD(ROTOR_B_MAP),
    .NOTCH(ROTOR_B_NOTCH),
    .notch_in(rA_notch_out),   // semnal notch de la rotorul anterior
    .new_char(1'b0),     // o noua tasta a fost apasata
    .load_key(load_key_cfg),     // incarca valoarea de start (comanda data de user)
    .char_in_fwd(rA_char_out_fwd),      // litera de intrare 0-25
    .char_in_rev(rC_char_out_rev),  // litera de intrare 0-25
    .key(key[9:5]),          // pozitia initiala a rotorului
    .char_out_fwd(rB_char_out_fwd), // iesire catre urmatorul rotor/reflector
    .char_out_rev(rB_char_out_rev), // iesire reverse
    .notch_out(rB_notch_out),     // semnal notch pentru urmatorul rotor
    .*
);

rotor rC ( // left
    .MAP_FWD(ROTOR_C_MAP),
    .NOTCH(ROTOR_C_NOTCH),
    .notch_in(rB_notch_out),   // semnal notch de la rotorul anterior
    .new_char(1'b0),     // o noua tasta a fost apasata
    .load_key(load_key_cfg),     // incarca valoarea de start (comanda data de user)
    .char_in_fwd(rB_char_out_fwd),      // litera de intrare 0-25
    .char_in_rev(refl_char_out),  // litera de intrare 0-25
    .key(key[14:10]),          // pozitia initiala a rotorului
    .char_out_fwd(rC_char_out_fwd), // iesire catre urmatorul rotor/reflector
    .char_out_rev(rC_char_out_rev), // iesire reverse
    .notch_out(),     // semnal notch pentru urmatorul rotor
    .*
);

reflector refl (
    .char_in(rC_char_out_fwd),
    .char_out(refl_char_out)
);

endmodule
