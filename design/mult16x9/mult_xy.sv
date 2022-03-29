//------------------------------------------------------------
// MELZG642 VLSI Architecure Assignment #1
// Name: Anand S
// BITSID: 2021HT80003
//------------------------------------------------------------
module mult_xy #(
    parameter MD_WD     = 16, // Multiplicand width
    parameter MR_WD     =  9, // Multiplier width
    parameter MDMR_WD   = MD_WD+MR_WD
) (
    input  logic [MD_WD-1:0]    A,
    input  logic [MR_WD-1:0]    B,
    output logic [MDMR_WD-1:0]  O
);

//-------------------------------
// Local declarations
//-------------------------------
    localparam ARR_DPTH = MR_WD*2;
    logic [MDMR_WD-1:0]  PP [0:MR_WD-1];    // Partial product array
    logic [MDMR_WD-1:0]  arr[0:ARR_DPTH-1]; // csa addition array
    logic [MDMR_WD  :0]  cint;              // Final CPA carry

    // Step 1: Obtain Partial Product
    ppg #(MD_WD,MR_WD) u_ppg (.A, .B, .PP);

    // Step 2: Partial product then needs to be added with csa
    assign arr[0] = PP[0];
    assign arr[1] = PP[1];
    assign cint[0]= '0;
    genvar ii,jj;
    generate
        for(ii=0;ii<MR_WD-2;ii++) begin: stage_csa
            csa #(MD_WD,MR_WD) u_csa (.x(arr[2*ii]),.y(arr[2*ii+1]),.z(PP[ii+2]),.sum(arr[2*ii+2]),.carry(arr[2*ii+3]));
        end: stage_csa
    endgenerate

    // Step 3: Final output from csa goes to a CPA
    cpa #(MD_WD,MR_WD) u_cpa (.x(arr[(MR_WD-3)*2+2]),.y(arr[(MR_WD-3)*2+3]),.sum(O),.cout());

    // Checks
    always_comb begin: check
        ERR_MD_WD: assert(MD_WD>=3)
        else $error("\nERROR: MD_WD cannot be less than 3! MD_WD=%d\n", MD_WD);
        ERR_MR_WD: assert(MR_WD>=3)
        else $error("\nERROR: MR_WD cannot be less than 3! MD_WD=%d\n", MR_WD);
    end: check
endmodule: mult_xy
