`timescale 1ns / 1ps

module reflector (
    input  [4:0]  char_in,
    output [4:0]  char_out
);

    // UKW-B
    localparam [25:0][4:0] MAP = '{
        5'd19, // Z->T
        5'd0,  // Y->A
        5'd9,  // X->J
        5'd21, // W->V
        5'd22, // V->W
        5'd2,  // U->C
        5'd25, // T->Z
        5'd5,  // S->F
        5'd1,  // R->B
        5'd4,  // Q->E
        5'd8,  // P->I
        5'd12, // O->M
        5'd10, // N->K
        5'd14, // M->O
        5'd6,  // L->G
        5'd13, // K->N
        5'd23, // J->X
        5'd15, // I->P
        5'd3,  // H->D
        5'd11, // G->L
        5'd18, // F->S
        5'd16, // E->Q
        5'd7,  // D->H
        5'd20, // C->U
        5'd17, // B->R
        5'd24  // A->Y
    };

    assign char_out = MAP[char_in];

endmodule
