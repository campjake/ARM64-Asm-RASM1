// Style Sheet
// Programmer   : Jacob Campbell
// Assign #     : RASM-1
// Purpose      : Input, Processing, Output
// Date         : 2/6/2023

        .EQU SIZE, 21

        .data

                szHeadingA:     .asciz  " Name: Jacob Campbell" // Programmer Name                      22
                szHeadingB:     .asciz  "Class: CS 3B"          // Class Title                          13
                szHeadingC:     .asciz  "  Lab: RASM1"          // Assignment Name                      13
                szHeadingD:     .asciz  " Date: 2/7/2023"       // Date of Demo                         16

                szPrompt:      .asciz  "Enter a whole number: " // Input int from user                  23

                szA:            .skip   21              // char A[21]                                   21
                szB:            .skip   21              // char B[21]                                   21
                szC:            .skip   21              // char C[21]                                   21
                szD:            .skip   21              // char D[21]                                   21
                szResult:       .skip   21              // char Result[21]                              21
                dbA:            .quad   0               // double value converted from szA              8
                dbB:            .quad   0               // double value converted from szB              8
                dbC:            .quad   0               // double value converted from szC              8
                dbD:            .quad   0               // double value converted from szD              8
                dbSum:          .quad   0               // double sum = 0                               8

                szSumMsg:       .asciz  "Sum in hex: 0x"                // Msg preceding dbsum          15
                szAddrMsg:      .asciz  "The addresses of the 4 ints:"  // Msg preceding address in hex 29
                szAAddrMsg:     .asciz  "Int 1: 0x"                     // Msg preceding *dbA in hex    10
                szBAddrMsg:     .asciz  "Int 2: 0x"                     // Msg preceding *dbB in hex    10
                szCAddrMsg:     .asciz  "Int 3: 0x"                     // Msg preceding *dbC in hex    10
                szDAddrMsg:     .asciz  "Int 4: 0x"                     // Msg preceding *dbD in hex    10

                szOpParen:      .asciz  "("                                                     //      2
                szClsParen:     .asciz  ")"                                                     //      2
                szPlus:         .asciz  " + "                                                   //      4
                szMinus:        .asciz  " - "                                                   //      4
                szEqual:        .asciz  "  = "                                                  //      5

                chLF:           .byte   0xa             // Line Feed                            //      1
                                                                                        // BYTES IN DATA SEG = 334
        .global _start
        .text
_start:

// 1) Prompt for A
        LDR     X0,=szPrompt   // *X0 = szPromptA
        BL      putstring       // Print "Enter A: "

// 2) Get A from user
        LDR     X0,=szA         //*X0 = char A[21]
        MOV     X1,#SIZE        // X1 = 21, size of max signed string

        BL      getstring       // cin >> A

// 3) Convert X0 from ASCII -> int, then store at X11
        LDR     X0,=szA         // ascint64 requires null-terminated string
        BL      ascint64        // returns 64 bit int in X0

        LDR     X11,=dbA        // Load dbA garbage value to be overwritten soon
        MOV     X11, X0         // Loads contents of X0 (int A) into X11

// 4) Prompt for B
        LDR     X0,=szPrompt   // *X0 = szPromptB
        BL      putstring       // Print "Enter B: "

// 5) Get B from user
        LDR     X0,=szB         //*X0 = char B[21]
        MOV     X1,#SIZE        // X1 = 21, size of max signed string

        BL      getstring       // cin >> B

// 6) Convert X0 from ASCII -> int, then store at X12
        LDR     X0,=szB        // ascint64 requires null-terminated string
        BL      ascint64       // returns 64 bit int in X0

        LDR     X12,=dbB
        MOV     X12, X0        // Loads int B into X12

// 7) Prompt for C
        LDR     X0,=szPrompt  // *X0 = szPromptC
        BL      putstring      // Print "Enter C: "

// 8) Get C from user
        LDR     X0,=szC        //*X0 = char C[21]
        MOV     X1,#SIZE       // X1 = 21, size of max signed string

        BL      getstring      // cin >> C

// 9) Convert X0 from ASCII -> int, then store at X13
        LDR     X0,=szC        // ascint64 requires null-terminated string
        BL      ascint64       // returns 64 bit int in X0

        LDR     X13,=dbC
        MOV     X13, X0        // Loads int C into X13

// 10) Prompt for D
        LDR     X0,=szPrompt  // *X0 = szPromptD
        BL      putstring      // Print "Enter D: "

// 11) Get D from user
        LDR     X0,=szD        //*X0 = char D[21]
        MOV     X1,#SIZE       // X1 = 21, size of max signed string

        BL      getstring      // cin >> D

// 12) Convert X0 from ASCII -> int, then store at X14
        LDR     X0,=szD        // ascint64 requires null-terminated string
        BL      ascint64       // returns 64 bit int in X0
		
        LDR     X14,=dbD
        MOV     X14, X0         // Loads int B into X14

// OPTIONAL - COMPUTE VALUE TO DISPLAY IN HEXADECIMAL
        // 1) Set X0 = X11 + X12
                LDR     X0,=dbSum       // *X0 = dbSum = 0
                ADD     X0, X11, X12    // X0 = X11 + X12

        // 2) Set X2 = X13 + X14
                ADD     X2, X13, X14     // X2 = X12 + X13

        // 3) Set X0 = X0 - X2, store at X15
                SUB     X0, X0, X2     // X0 = (X11 + X12) - (X13 + X14)
                MOV     X15, X0         // Please hold the hex value of the sum

// 13) Set X0 = X11 + X12     Convert Sum from int -> ASCII, then store in memory
        LDR     X0,=dbSum
        ADD     X0, X11, X12    // X0 = X11 + X12

// 14) Set X2 = X13 + X14
        ADD     X2, X13, X14    // X2 = X12 + X13

// 15) Set X0 = X0 - X2
        SUB     X0, X0, X2     // X0 = (X11 + X12) - (X13 + X14)

        LDR     X1,=szResult    // *X1 = szResult
        BL      int64asc        // X1 points to result stored in memory

// OUTPUT - Print Heading
        LDR     X0,=szHeadingA  // X0 points to name
        BL      putstring       // Print name

        LDR     X0,=chLF        // Line Feed
        BL      putch

        LDR     X0,=szHeadingB  //X0 points to Class
        BL      putstring       // Print class

        LDR     X0,=chLF        // Line Feed
        BL      putch

        LDR     X0,=szHeadingC  // X0 points to assignment
        BL      putstring       // Print assignment

        LDR     X0,=chLF        // Line Feed
        BL      putch

        LDR     X0,=szHeadingD  // X0 points to date
        BL      putstring       // Print date

        LDR     X0,=chLF        // Line Feed
        BL      putch

// 17) Print the operation and result
        LDR     X0,=szOpParen   // *X0 = "("
		BL      putstring       // print "("

        LDR     X0,=szA         // *X0 = A string
        BL      putstring       // print A

        LDR     X0,=szPlus     // *X0  = +
        BL      putstring       // print " + "

        LDR     X0,=szB         // *X0 = B String
        BL      putstring       // Print B

        LDR     X0,=szClsParen  // *X0 = ")"
        BL      putstring       // print ")"

        LDR     X0,=szMinus      // *X0 = -
        BL      putstring       // Print " - "

        LDR     X0,=szOpParen   // *X0 = "("
        BL      putstring       // print "("

        LDR     X0,=szC         // *X0 = C String
        BL      putstring       // Print C

        LDR     X0,=szPlus     // *X0 = +
        BL      putstring       // Print " + "

        LDR     X0,=szD         // *X0 = D String
        BL      putstring       // Print D

        LDR     X0,=szClsParen  // *X0 = ")"
        BL      putstring       // print ")"

        LDR     X0,=szEqual     // *X0 = =
        BL      putstring       // Print "  = "

        LDR     X0,=szResult    // *X0 = Sum
        BL      putstring       // Prints Sum

        LDR     X0,=chLF        // Line Feed
        BL      putch

// 18) Print Addresses of key labels to terminal

        LDR     X0,=szSumMsg    // *X0 points to pretext
        BL      putstring       // Print pretext for sum in hex to terminal

        MOV     X0, X15         // Copy contents of X15 to X0

        MOV     X2, #17         // Leading zeroes WILL be displayed
        BL      hex64asc        // fcn call: convert hex addr to asciz?

        LDR     X0,=chLF        // Line Feed
        BL      putch
        BL      putch
		
		LDR     X0,=szAddrMsg   // Load msg into X0
        BL      putstring       // Print "The addresses of the 4 ints:"

        LDR     X0,=chLF        // Line Feed
        BL      putch
        BL      putch

        LDR     X0,=szAAddrMsg  // *X0 points to address pretext
        BL      putstring       // Print szAAddrMsg to terminal

        LDR     X0,=dbA         // Load address of dbA
        MOV     X2, #17         // Leading zeros will not be displayed
        BL      hex64asc        // fcn call: convert hex addr to asciz

        LDR     X0,=chLF        // Line Feed
        BL      putch

        LDR     X0,=szBAddrMsg  // *X0 points to address pretext
        BL      putstring       // Print szBAddrMsg to terminal

        LDR     X0,=dbB         // Load address
        MOV     X2, #17         // Leading zeros will not be displayed
        BL      hex64asc        // fcn call: convert hex addr to asciz

        LDR     X0,=chLF        // Line Feed
        BL      putch

        LDR     X0,=szCAddrMsg  // *X0 points to address pretext
        BL      putstring       // Print szCAddrMsg to terminal

        LDR     X0,=dbC         // Load address
        MOV     X2, #17         // Leading zeros will not be displayed
        BL      hex64asc        // fcn call: convert hex addr to asciz

        LDR     X0,=chLF        // Line Feed
        BL      putch

        LDR     X0,=szDAddrMsg  // *X0 points to address pretext
        BL      putstring       // Print szDAddrMsg to terminal

        LDR     X0,=dbD         // Load address
        MOV     X2, #17         // Leading zeros will not be displayed
        BL      hex64asc        // fcn call: convert hex addr to asciz

        LDR     X0,=chLF        // Line Feed
        BL      putch

// Setup parameters to exit program and call Linux to do it
        MOV     X0, #0          // Use return code 0
        MOV     X8, #93         // Service command code 93
        SVC     0               // Goodbye