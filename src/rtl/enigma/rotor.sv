`timescale 1ns / 1ps

module rotor(
    input [25:0][4:0] MAP_FWD,
    input       [4:0] NOTCH,
    input             clk,          // clk
    input             reset_n,      // reset
    input             notch_in,     // semnal notch de la rotorul anterior
    input             new_char,     // o noua tasta a fost apasata
    input             load_key,     // incarca valoarea de start (comanda data de user)
    input       [4:0] char_in_fwd,  // litera de intrare 0-25
    input       [4:0] char_in_rev,  // litera de intrare 0-25
    input       [4:0] key,          // pozitia initiala a rotorului
    output      [4:0] char_out_fwd, // iesire catre urmatorul rotor/reflector
    output      [4:0] char_out_rev, // iesire reverse
    output            notch_out     // semnal notch pentru urmatorul rotor
);
    logic [4:0] crt_pos;            // pozitia curennta al rotorulul
    logic [4:0] idx_in_fwd;
    logic [4:0] idx_out_fwd;
    logic [4:0] idx_in_rev;
    logic [4:0] idx_out_rev;
    logic [4:0] MAP_REV [0:25];
    integer i;
      
    // Incrementare rotor
    always @(posedge clk)
        if (~reset_n)
            crt_pos <= '0;
        else if (load_key)
            crt_pos <= key;
        else if (notch_in || new_char)
            crt_pos <= (crt_pos + 1) % 26;
    
    // Forward
    assign idx_in_fwd = (char_in_fwd + crt_pos) % 26;
    assign idx_out_fwd = MAP_FWD[idx_in_fwd];
    assign char_out_fwd = (idx_out_fwd - crt_pos + 26) % 26;
    
    // Reverse
    always @(*)
        for (i = 0; i < 26; i = i + 1)
            MAP_REV[MAP_FWD[i]] = i;
    
    assign idx_in_rev = (char_in_rev + crt_pos) % 26;
    assign idx_out_rev = MAP_REV[idx_in_rev];
    assign char_out_rev = (idx_out_rev - crt_pos + 26) % 26;
    
    // Notch detect
    assign notch_out = (crt_pos == NOTCH);

endmodule