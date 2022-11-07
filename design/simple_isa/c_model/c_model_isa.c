// ---------------------------------------------------------------------
// HSCD assignent-1: Q1
// Author: Anand S
// BITS ID: 2021HT80003
// ---------------------------------------------------------------------
// vim: set sw=4: ts=4: set num: set expandtab:
// Online C compiler to run C program online
// C model for simple ISA
// Resources required to simulated:
// An instruction memory - say 128 half-words deep
#include <stdio.h>
#include <stdint.h>

// Typedefs -------------------------------------------------------------
typedef uint8_t  pc_t; // PC has address space of 256B
typedef uint16_t instruction_mem_t [256]; // PC has address space of 256B
typedef uint8_t  reg_file_t [16]; // R0-R15 registers, each 1B
typedef uint8_t  dmem_t [256]; // Data Mem is also addressed using 8bits
typedef uint8_t  opcode_t;
typedef uint8_t  op1_t;
typedef int16_t  op2_t; // This has to be signed for relative jumps

// Hardware resources (Global variables) --------------------------------
instruction_mem_t INSTR = {
    /* 0: MOV R0, 0xa */ 0x300a  // Setup
,   /* 1: MOV R1, 0x0 */ 0x3100  // Setup
,   /* 2: MOV R2, 0x1 */ 0x3201  // Setup
,   /* 3: MOV R3, 0x0 */ 0x3300  // Setup
,   /* 4: ADD R3, R1  */ 0x4031  // R3 = R3 + R1        -- R3 accumulates the sum
,   /* 5: ADD R1, R2  */ 0x4012  // R1 = R1 + 1; INC R1 -- New num created by incr of R1
,   /* 6: SUB R0, R2  */ 0x5002  // R0 = R0 - 1; DEC R1
,   /* 7: JNZ R0, -3  */ 0x90fd  // PC = PC + (-3) if R0 != 0
//    0x0010 // MOV Rn, direct; |0x0|Rn||dir|ect|; R0 = M(0x10)
//,   0x1100 // MOV direct, Rn; |0x1|Rn||dir|ect|; M(0x0) = R1
//,   0x2012 // MOV @Rn,Rm    ; |0x2|  ||Rn |Rm |; M(R1)  = R2
//,   0x33ff // MOV Rn, #immed; |0x3|Rn||Imm|edt|; R3 = 0xff
//,   0x4043 // ADD Rn, Rm    ; |0x4|  ||Rn |Rm |; R4 = R4 + R3
//,   0x5043 // SUB Rn, Rm    ; |0x5|  ||Rn |Rm |; R4 = R4 - R3
//,   0x84ff // JZ  Rn, reltiv; |0x8|R4||rel|tiv|; PC = PC + 4 (Only if R4 is 0)
//,   0x950f // JNZ Rn, reltiv; |0x8|R4||rel|tiv|; PC = PC + 4 (Only if R4 is != 0)
};
pc_t 	   PC;
reg_file_t R;
dmem_t	   M;

// Hardware functions ---------------------------------------------------
pc_t pc_update (pc_t PC, pc_t pc_incr, int st) {
    int orig_PC = PC;
    if (st == 0) {
        PC = PC + pc_incr;
    }
    printf("--> PC = PC + 0x%x = 0x%x + 0x%x = 0x%x\n", pc_incr, orig_PC, pc_incr, PC);
    return PC;
}

// Instruction parse operations - direct means 2nd byte is fully op2
opcode_t instr_opcode (int instr_addr) {
    return INSTR[instr_addr] >> 12;
}

op1_t instr_op1 (int instr_addr, int direct) {
    if (direct) {
        return (INSTR[instr_addr] >> 8) & 0x0f;
    } else {
        return ((INSTR[instr_addr] & 0xf0) >> 4);
    }
}

op2_t instr_op2 (int instr_addr, int direct) {
    if (direct) {
        return (INSTR[instr_addr] & 0xff);
    } else {
        return (INSTR[instr_addr] & 0x0f);
    }
}

int instr_decode (int instr_addr) {
    int st = 0;
    int orig_R_lhs;
    op1_t op1;
    op2_t op2;
    pc_t  pc_incr = 1; // Next instruction - points to next half-word
    opcode_t opcode = instr_opcode(instr_addr);
    printf ("--> PC: %d \n", PC);
    switch (opcode) {
        case 0x0:
            // MOV Rn, direct; |0x0|Rn||dir|ect|; Rn = M(direct)
            op1 = instr_op1(instr_addr, 1);
            op2 = instr_op2(instr_addr, 1);
            R[op1] = M[op2];
            printf("---> MOV R%d, 0x%x\n", op1, op2);
            printf("-------> R%d = M(0x%x) -> 0x%x = 0x%x\n", op1, op2, R[op1], M[op2]);
            break;
        case 0x1:
            // MOV direct, Rn; |0x1|Rn||dir|ect|; M(direct) = Rn
            op1 = instr_op1(instr_addr, 1);
            op2 = instr_op2(instr_addr, 1);
            M[op2] = R[op1];
            printf("---> MOV 0x%x, R%d\n", op2, op1);
            printf("-------> M(0x%x) = R%d -> 0x%x = 0x%x\n", op2, op1, M[op2], R[op1]);
            break;
        case 0x2:
            // MOV @Rn,Rm    ; |0x2|  ||Rn |Rm |; M(Rn) = Rm
            op1 = instr_op1(instr_addr,0);
            op2 = instr_op2(instr_addr,0);
            M[R[op1]] = R[op2];
            printf("---> MOV @R%d, R%d\n", op1, op2);
            printf("-------> M($R%d) = M(0x%x) = R%d -> 0x%x = 0x%x\n", op1, R[op1], op2, M[R[op1]], R[op2]);
            break;
        case 0x3:
            // MOV Rn, #immed; |0x3|Rn||Imm|edt|; Rn = #immed
            op1 = instr_op1(instr_addr,1);
            op2 = instr_op2(instr_addr,1);
            R[op1] = op2;
            printf("---> MOV R%d, 0x%x\n", op1, op2);
            printf("-------> R%d = 0x%x -> 0x%x = 0x%x\n", op1, op2, R[op1], op2);
            break;
        case 0x4:
            // ADD Rn, Rm    ; |0x4|  ||Rn |Rm |; Rn = Rn + Rm
            op1 = instr_op1(instr_addr,0);
            op2 = instr_op2(instr_addr,0);
            orig_R_lhs = R[op1];
            R[op1] = R[op1] + R[op2];
            printf("---> ADD R%d, R%d\n", op1, op2);
            printf("-------> R%d = R%d + R%d -> 0x%x = 0x%x + 0x%x\n", op1, op1, op2, R[op1], orig_R_lhs, R[op2]);
            break;
        case 0x5:
            // SUB Rn, Rm    ; |0x5|  ||Rn |Rm |; Rn = Rn - Rm
            op1 = instr_op1(instr_addr,0);
            op2 = instr_op2(instr_addr,0);
            orig_R_lhs = R[op1];
            R[op1] = R[op1] - R[op2];
            printf("---> SUB R%d, R%d\n", op1, op2);
            printf("-------> R%d = R%d - R%d -> 0x%x = 0x%x - 0x%x\n", op1, op1, op2, R[op1], orig_R_lhs, R[op2]);
            break;
        case 0x6:
            break;
        case 0x8:
            // JZ  Rn, reltiv; |0x8|R4||rel|tiv|; PC = PC + relative
            op1 = instr_op1(instr_addr, 1);
            op2 = instr_op2(instr_addr, 1);
            if (R[op1] == 0) {
                pc_incr = op2;
                printf("------> JUMP succeeded\n");
            } else {
                printf("------> JUMP failed\n");
            }
            printf("---> JZ R%d, 0x%x\n", op1, op2);
            break;
        case 0x9:
            // JZ  Rn, reltiv; |0x8|R4||rel|tiv|; PC = PC + relative
            op1 = instr_op1(instr_addr, 1);
            op2 = instr_op2(instr_addr, 1);
            printf("---> JNZ R%d, 0x%x\n", op1, op2);
            if (R[op1] != 0) {
                pc_incr = op2;
                printf("------> JUMP succeeded\n");
            } else {
                printf("------> JUMP failed\n");
            }
            break;
        default:
            st = 1;
            printf("ERROR: Unsupported opcode %x\n", opcode);
            break;
    }
    PC = pc_update(PC, pc_incr, st);
    return st;
}

int main() {
    // Write C code here
    int er;
    printf("Hello world\n");
    printf("2nd element in instr mem is 0x%x \n", INSTR[1]);
    while (PC < 8) {
        er += instr_decode(PC);
    }
    return er;
}
