/****************************************************************************/
/*                                                                          */
/*                                  LST2TEST                                */
/*                     Generate Test Vectors from .LST File                 */
/*                                                                          */
/****************************************************************************/

/*
   Description:      This program generates the contents for arrays of test
                     values for testing the AVR CPU based on a listing file
                     from AVR Studio.  The listing file to use is input on
                     stdin and the output array contents are output to stdout.

   Input:            The .LST file (from AVR Studio) to be converted to test
                     vectors is input on stdin.  The comments in the file
                     control what is output for test vectors and must follow
                     a very fixed format.  For memory accesses the comments
                     must start with 'R' or 'W'. This is followed by white
                     space then the data (2 hex digits), white space, and
                     address (4 hex digits).  The rest of the line is ignored.
                     If the comment starts with 'S' it is assumed the
                     instruction is being skipped and no extra cycles will be
                     generated for a read or write.  If the comment starts
                     'J' it is assumed a jump is being taken and thus the
                     instruction will take 2 clocks.  The program does not
                     check the validity of the hex digits.

   Output:           Initial values for VHDL arrays of std_logic_vector are
                     output to stdout.  This output can be pasted into a
                     testbench for testing the CPU.  Before outputting the
                     arrays, the number of lines and vectors processed is
                     output to stderr.

   Return Code:      The program always returns 0.

   Error Handling:   Error messages are output if there is memory allocation
                     error.

   Algorithms:       None.
   Data Structures:  None.


   Revision History:
      17 Feb 15  Glen George    Initial revision (from 5/11/00 version of
                                   mem2vec.c).
      19 Feb 19  Glen George    Modified to output vectors for the data bus
                                   and to handle multi-clock instructions.
       3 Mar 19  Glen George    Fixed a couple minor bugs in the vector
                                   output.
       5 Feb 21  Glen George    Added some constants.
       5 Feb 21  Glen George    Changed to not require a space to start the
                                   comment (in fact disallow space now).
       5 Feb 21  Glen George    Changed to treat LDS and STS as 3 clock
                                   instructions with the read/write on the 2nd
                                   clock.
       5 Feb 21  Glen George    Added 'S' comment to indicate the instruction
                                   is being skipped.
      27 Feb 21  Glen George    Added 'J' comment to indicate the instruction
                                   is a jump that is being taken.
      27 Feb 21  Glen George    Completely rewrote code to handle 3 and 4
                                   cycle instructions.
      10 Mar 21  Glen George    Fixed a bug in the getCycleCount() function,
                                   some instructions were being incorrectly
                                   identified as 4 cycle instruction due to a
                                   typo in the length argument to strncmp().
      10 Mar 21  Glen George    Fixed a bug in the ASCII address increment
                                   code, forgot to handle that '9' + 1 is not
                                   'A'.
      15 Mar 21  Glen George    Fixed another missed strncmp() typo in the
                                   getCycleCount() function,
      20 Mar 21  Eric Chen      hack in strpur; output vectors in table
*/




/* library include files */
#include  <ctype.h>
#include  <string.h>
#include  <stdio.h>
#include  <stdlib.h>

/* local include files */
  /* none */


/* definitions */
#define  MAX_LINE_LEN   300     /* maximum length of an input line */

#define  ALLOC_SIZE     200     /* size of array to allocate at a time */
#define  VEC_PER_LINE   5       /* vectors per line */

#define  ADDR_SIZE      4       /* number of characters in hex address */
#define  INST_SIZE      4       /* number of characters in hex instruction */
#define  ASM_SIZE       80      /* The assembly code line length */
#define  DATA_SIZE      2       /* number of characters in hex r/w data */



/* function declarations */
int  getCycleCount(const char *, char);


/* nonstandard string function.
 * converts string to uppercase. */
void strupr(char *str) {
    for (int i = 0; str[i] != '\0'; i ++) {
        str[i] += (str[i] >= 'a' && str[i] <= 'z') ? 'A' - 'a' : 0;
    }
}

typedef struct {
    char progDB[INST_SIZE+1];
    char dataDBr[DATA_SIZE+1];

    char progAB[ADDR_SIZE+1];
    char dataAB[ADDR_SIZE+1];
    char dataDBw[DATA_SIZE+1];
    int read, write;
    char asmCodeDebug[ASM_SIZE+1];
} vector_t;

void setProgDB(
        vector_t *vecs,
        char *progaddr,
        char *inst, char *inst2,
        char *data,
        char *rdwrsj,
        char *addr) {
        /* get number of cycles for this instruction */
        int cycle_cnt = getCycleCount(inst, rdwrsj[0]);

        strncpy(vecs[0].progDB, inst, INST_SIZE+1);
        /* output any additional words of the instruction */
        for (int cycle = 1; cycle < cycle_cnt; cycle ++) {

            /* keep the instruction bus constant on additional cycles */
            if (strcmp(inst2, "    ") == 0)
                /* no second word, keep first word there */
                strncpy(vecs[cycle].progDB, inst, INST_SIZE+1);
            else
                /* have second word, hold it constant */
                strncpy(vecs[cycle].progDB, inst2, INST_SIZE+1);
        }
}

void setProgAB(
        vector_t *vecs,
        char *progaddr,
        char *inst, char *inst2,
        char *data,
        char *rdwrsj,
        char *addr) {
    /* get number of cycles for this instruction */
    int cycle_cnt = getCycleCount(inst, rdwrsj[0]);

    /* output the address */
    strncpy(vecs[0].progAB, progaddr, ADDR_SIZE+1);
    int cycle = 1;

    /* check if this is a multi-word instruction */
    if (strcmp(inst2, "    ") != 0)  {

        /* have a multi-word instruction, output 2nd address */
        /* need to increment the 4-digit address (do it in ASCII) */
        /* always increment low digit */
        progaddr[3]++;

        /* propagate any carries */
        for (int j = 3; j >= 0; j--)  {

            /* check if the digit went from a digit (9) to a letter (A) */
            if (progaddr[j] == ('9' + 1))
                /* need to adjust to a letter */
                progaddr[j] = 'A';

            /* check if carry out of this digit */
            if (progaddr[j] == 'G')  {
                /* carry out of this digit, reset it */
                progaddr[j] = '0';
                /* carry into next digit if there is one */
                if (j > 0)
                    progaddr[j - 1]++;
            }
        }


        /* now output the address */
        strncpy(vecs[1].progAB, progaddr, ADDR_SIZE+1);

        /* have taken care of another cycle */
        cycle ++;

    }


    /* output any additional cycles of the instruction */
    for (; cycle < cycle_cnt; cycle ++) {

        /* don't care what the address is for the other cycles */
        strncpy(vecs[cycle].progAB, "XXXX", ADDR_SIZE+1);
    }

}

void setRead(
    vector_t *vecs,
    char *progaddr,
    char *inst, char *inst2,
    char *data,
    char *rdwrsj,
    char *addr) {
    /* get number of cycles for this instruction */
    int cycle_cnt = getCycleCount(inst, rdwrsj[0]);
    for (int cycle = 0; cycle < cycle_cnt; cycle ++) {
        if (cycle_cnt >= 2 && cycle == 1 && rdwrsj[0] == 'r') {
            vecs[cycle].read = 0;
        } else {
            vecs[cycle].read = 1;
        }
    }
}
void setWrite(
    vector_t *vecs,
    char *progaddr,
    char *inst, char *inst2,
    char *data,
    char *rdwrsj,
    char *addr) {
    /* get number of cycles for this instruction */
    int cycle_cnt = getCycleCount(inst, rdwrsj[0]);
    for (int cycle = 0; cycle < cycle_cnt; cycle ++) {
        if (cycle_cnt >= 2 && cycle == 1 && rdwrsj[0] == 'w') {
            vecs[cycle].write = 0;
        } else {
            vecs[cycle].write = 1;
        }
    }
}

void setDataDBr(
    vector_t *vecs,
    char *progaddr,
    char *inst, char *inst2,
    char *data,
    char *rdwrsj,
    char *addr) {
    /* get number of cycles for this instruction */
    int cycle_cnt = getCycleCount(inst, rdwrsj[0]);

    /* output read data for each cycle */
    for (int j = 1; j <= cycle_cnt; j++)  {

        /* if one cycle instruction or on second cycle or 2 or more */
        /*    cycle instruction, give the data to be read if reading */
        if (((cycle_cnt == 1) || (j == 2)) && (rdwrsj[0] == 'r')) {
            /* need to output data to be read */
            strncpy(vecs[j-1].dataDBr, data, DATA_SIZE+1);
        } else {
            /* not reading - high-Z */
            strncpy(vecs[j-1].dataDBr, "ZZ", DATA_SIZE+1);
        }
    }
}

void setDataDBw(
    vector_t *vecs,
    char *progaddr,
    char *inst, char *inst2,
    char *data,
    char *rdwrsj,
    char *addr) {
    /* get number of cycles for this instruction */
    int cycle_cnt = getCycleCount(inst, rdwrsj[0]);

    /* output read data for each cycle */
    for (int j = 1; j <= cycle_cnt; j++)  {

        /* if one cycle instruction or on second cycle or 2 or more */
        /*    cycle instruction, give the value to compare if writing */
        if (((cycle_cnt == 1) || (j == 2)) && (rdwrsj[0] == 'w')) {
            /* data being written - output compare vector */
            strncpy(vecs[j-1].dataDBw, data, DATA_SIZE+1);
        } else {
            /* not writing - don't do a compare */
            strncpy(vecs[j-1].dataDBw, "XX", DATA_SIZE+1);
        }
    }
}

void setDataAB(
    vector_t *vecs,
    char *progaddr,
    char *inst, char *inst2,
    char *data,
    char *rdwrsj,
    char *addr) {
    /* get number of cycles for this instruction */
    int cycle_cnt = getCycleCount(inst, rdwrsj[0]);

    /* output read data for each cycle */
    for (int j = 1; j <= cycle_cnt; j++)  {

        /* if one cycle instruction or on second cycle or 2 or more cycle */
        /*    instruction, give the value to compare if reading or writing */
        if (((cycle_cnt == 1) || (j == 2)) &&
            ((rdwrsj[0] == 'r') || (rdwrsj[0] == 'w'))) {
            /* data being read or written - output address compare vector */
            strncpy(vecs[j-1].dataAB, addr, ADDR_SIZE+1);
        } else {
            /* not reading or writing - don't do a compare */
            strncpy(vecs[j-1].dataAB, "XXXX", ADDR_SIZE+1);
        }
    }
}

void setASMCode(
    vector_t *vecs,
    char *progaddr,
    char *inst, char *inst2,
    char *data,
    char *rdwrsj,
    char *addr,
    char *asm_code) {
    /* get number of cycles for this instruction */
    int cycle_cnt = getCycleCount(inst, rdwrsj[0]);

    
    /* output the assembly line associated with test vector */
    for (int cycle = 0; cycle < cycle_cnt; cycle ++) {
        strncpy(vecs[cycle].asmCodeDebug, asm_code, ASM_SIZE+1);
    }

}

int  main()
{
    /* variables */
    char  (*progaddr)[ADDR_SIZE + 1] = NULL; /* test vector program address */
    char  (*inst)[INST_SIZE + 1] = NULL;/* test vector instruction */
    char  (*inst2)[INST_SIZE + 1] = NULL;    /* test vector instruction word 2 */
    char  (*asm_code)[ASM_SIZE + 1] = NULL;
    char  (*data)[DATA_SIZE + 1] = NULL;/* test vector data */
    char  (*rdwrsj)[2] = NULL;          /* test vector read/write/skip/jump */
    char  (*addr)[ADDR_SIZE + 1] = NULL;/* test vector data address */

    char    line[MAX_LINE_LEN];         /* a line of input */

    int     no_lines = 0;               /* number of lines processed */

    int     no_vectors = 0;             /* number of vectors stored */
    int     alloc_vectors = 0;          /* number of vectors allocated */

    int     vec_on_line;                /* number of vectors on a line */

    int     cycle_cnt;                  /* cycle count for an instruction */

    int     error = 0;                  /* error flag */

    int     i;                          /* loop indices */
    int     j;



    /* read lines until done or error */
    while (!error & (fgets(line, MAX_LINE_LEN, stdin) != NULL))  {

        /* have a line, count it */
        no_lines++;

        /* check if the line is an instruction line */
        if (line[0] == '0')  {

            /* it is a valid line, do we have room for it */
            if (no_vectors >= alloc_vectors)  {

                /* need to allocate more memory */
                alloc_vectors += ALLOC_SIZE;
                progaddr = realloc(progaddr, alloc_vectors * sizeof(*progaddr));
                inst = realloc(inst, alloc_vectors * sizeof(*inst));
                inst2 = realloc(inst2, alloc_vectors * sizeof(*inst2));
                asm_code = realloc(asm_code, alloc_vectors * sizeof(*asm_code));
                data = realloc(data, alloc_vectors * sizeof(*data));
                rdwrsj = realloc(rdwrsj, alloc_vectors * sizeof(*rdwrsj));
                addr = realloc(addr, alloc_vectors * sizeof(*addr));

                /* if anything went wrong set the error flag */
                error = ((progaddr == NULL) || (inst == NULL) || (inst2 == NULL) ||
                         (data == NULL) || (rdwrsj == NULL) || (addr == NULL));
            }

            
            /* if no error, parse the line */
            if (!error)  {

                /* program address is first thing on the line */
                /* but skip the first two 0's */
                strncpy(progaddr[no_vectors], &(line[2]), ADDR_SIZE);
                progaddr[no_vectors][ADDR_SIZE] = '\0';
                /* make sure in uppercase */
                strupr(progaddr[no_vectors]);

                /* instruction follows the first space */
                for (i = 0; ((line[i] != '\0') && !isspace(line[i])); i++);
                /* skip all whitespace */
                while ((line[i] != '\0') && isspace(line[i]))
                    i++;

                /* get the first word */
                strncpy(inst[no_vectors], &(line[i]), INST_SIZE);
                inst[no_vectors][INST_SIZE] = '\0';
                /* make sure in uppercase */
                strupr(inst[no_vectors]);
                /* now the second word */
                strncpy(inst2[no_vectors], &(line[i + INST_SIZE + 1]), INST_SIZE);
                inst2[no_vectors][INST_SIZE] = '\0';
                /* make sure in uppercase */
                strupr(inst2[no_vectors]);

                /* Copy remainder of line for debug output assembly in test vector file */
                strncpy(
                    asm_code[no_vectors],
                    strtok(&line[i + 2*INST_SIZE + 1], "\n"),
                    ASM_SIZE);

                /* read/write and skip and jump follows the semi-colon */
                while ((line[i] != '\0') && (line[i] != ';'))
                    i++;
                /* need to get past the semi-colon too */
                if (line[i] == ';')
                    i++;

                /* now need to see "R" or "W" or "S" or "J" */
                if (strncmp(&(line[i]), "R", 1) == 0)
                    /* have a read cycle */
                    strcpy(rdwrsj[no_vectors], "r");
                else if (strncmp(&(line[i]), "W", 1) == 0)
                    /* have a write cycle */
                    strcpy(rdwrsj[no_vectors], "w");
                else if (strncmp(&(line[i]), "S", 1) == 0)
                    /* have a skipped instruction */
                    strcpy(rdwrsj[no_vectors], "s");
                else if (strncmp(&(line[i]), "J", 1) == 0)
                    /* have a jump instruction where take the jump */
                    strcpy(rdwrsj[no_vectors], "j");
                else
                    /* neither read nor write nor skip nor jump */
                    strcpy(rdwrsj[no_vectors], " ");

                /* if have a read or write cycle, need to get data and address */
                if ((rdwrsj[no_vectors][0] == 'r') || (rdwrsj[no_vectors][0] == 'w'))  {

                    /* data follows the next space */
                    while ((line[i] != '\0') && !isspace(line[i]))
                        i++;
                    /* skip all whitespace */
                    while ((line[i] != '\0') && isspace(line[i]))
                        i++;
                    strncpy(data[no_vectors], &(line[i]), DATA_SIZE);
                    data[no_vectors][DATA_SIZE] = '\0';

                    /* address follows the next space */
                    while ((line[i] != '\0') && !isspace(line[i]))
                        i++;
                    /* skip all whitespace */
                    while ((line[i] != '\0') && isspace(line[i]))
                        i++;
                    strncpy(addr[no_vectors], &(line[i]), ADDR_SIZE);
                    addr[no_vectors][ADDR_SIZE] = '\0';
                }

                /* have another vector */
                no_vectors++;
            }
        }
    }


    /* check if there was an error */
    if (error)
        /* have an error - output a message */
        fprintf(stderr, "Out of memory\n");

    /* output summary results */
    fprintf(stderr, "Lines processed: %d\n", no_lines);
    fprintf(stderr, "Vectors parsed: %d\n", no_vectors);


    /* do the instruction vectors */
    vector_t vectors[4];

    printf("# ProgAB ProgDB dataDBr read write DataAB DataDBw        AssemblyCode\n");
    /* output the vectors */
    for (i = 0; i < no_vectors; i++)  {
        setProgDB(vectors, progaddr[i], inst[i], inst2[i], data[i], rdwrsj[i], addr[i]);
        setDataDBr(vectors, progaddr[i], inst[i], inst2[i], data[i], rdwrsj[i], addr[i]);

        setProgAB(vectors, progaddr[i], inst[i], inst2[i], data[i], rdwrsj[i], addr[i]);
        setDataAB(vectors, progaddr[i], inst[i], inst2[i], data[i], rdwrsj[i], addr[i]);
        setDataDBw(vectors, progaddr[i], inst[i], inst2[i], data[i], rdwrsj[i], addr[i]);
        setRead(vectors, progaddr[i], inst[i], inst2[i], data[i], rdwrsj[i], addr[i]);
        setWrite(vectors, progaddr[i], inst[i], inst2[i], data[i], rdwrsj[i], addr[i]);
        setASMCode(vectors, progaddr[i], inst[i], inst2[i], data[i], rdwrsj[i], addr[i], asm_code[i]);

        int cycle_cnt = getCycleCount(inst[i], rdwrsj[i][0]);
        for (j = 0; j < cycle_cnt; j ++) {
            printf(
                "%s %s %s %d %d %s %s        %s\n",
                vectors[j].progAB,
                vectors[j].progDB,
                vectors[j].dataDBr,
                vectors[j].read,
                vectors[j].write,
                vectors[j].dataAB,
                vectors[j].dataDBw,
                vectors[j].asmCodeDebug
            );
        }
    }

    free(progaddr);
    free(inst);
    free(inst2);
    free(data);
    free(rdwrsj);
    free(addr);
    /* done with everything - exit */
    return  0;

}




/*
   getCycleCount(const char *, char)

   Description:      This function returns the number of cycles needed for
                     the passed instruction.

   Operation:        First the instruction is checked to see if it is being
                     skipped.  If so and there is a second word of the
                     instruction (LDS, STS, JMP, CALL), 2 is returned,
                     otherwise 1 is returned.  If the instruction is not
                     being skipped then if it is a two cycle instruction or
                     it is reading or writing (must be two cycles if not LDS
                     or STS) or it is a jump being taken, 2 is returned.  If 
                     it is a 3 cycle instruction that isn't skipped, 3 is
                     returned.  And finally if it is a 4 cycle instruction
                     that isn't being skipped, 4 is returned.

   Arguments:        inst (const char *) - pointer to the string containing
                                           the hex code for the first word of
                                           an instruction.
                     rwsj_flag (char)    - character indicating this is an
                                           instruction that does a memory read
                                           or write or is skipped or is a jump
                                           that is taken.
   Return Value:     (int) - the number of cycles used by this instruction,
                        zero (0) if the passed instruction point is NULL.

   Input:            None.
   Output:           None.

   Error Handling:   If the passed pointer is NULL, 0 is returned.

   Algorithms:       None.
   Data Structures:  None.

   Last Modified:    15 March 21
*/

int  getCycleCount(const char *inst, char rwsj_flag)
{
    /* variables */
    int  cycle_cnt;     /* number of cycles used by this instruction */



    /* make sure the passed pointer is non-NULL */
    if (inst == NULL)
        /* have a NULL pointer - return 0 */
        return  0;


    /* check if the instruction is being skipped */
    if (rwsj_flag == 's')  {

        /* skipping the instruction */
        /* takes 1 clock unless it is a 2 word instruction (LDS, STS, JMP, CALL) */
        if ((strncmp(inst, "940C", 4) == 0) ||  /* JMP */
            (strncmp(inst, "940E", 4) == 0) ||  /* CALL */
            ((inst[3] == '0') &&
             ((strncmp(inst, "90", 2) == 0) ||  /* LDS */
              (strncmp(inst, "91", 2) == 0) ||  /* LDS */
              (strncmp(inst, "92", 2) == 0) ||  /* STS */
              (strncmp(inst, "93", 2) == 0))))  /* STS */

            /* two word instruction -> two cycles */
            cycle_cnt = 2;

        else

            /* one word instruction -> one cycle */
            cycle_cnt = 1;
    }
    else  {

        /* not skipping the instruction, figure out number of cycles */

        /* assume 1 cycle by default */
        cycle_cnt = 1;

        /* if reading, writing, or jumping, must be two cycles */
        if ((rwsj_flag == 'r') || (rwsj_flag == 'w') || (rwsj_flag == 'j'))
            cycle_cnt = 2;

        /* LDS and STS instruction are read/write and take an extra cycle */
        if ((inst[3] == '0') &&
            ((strncmp(inst, "90", 2) == 0) ||   /* LDS */
             (strncmp(inst, "91", 2) == 0) ||   /* LDS */
             (strncmp(inst, "92", 2) == 0) ||   /* STS */
             (strncmp(inst, "93", 2) == 0)))    /* STS */
            cycle_cnt++;

        /* check if it is a two cycle instruction */
        if ((strncmp(inst, "96", 2) == 0) ||    /* ADIW */
            (strncmp(inst, "97", 2) == 0) ||    /* SBIW */
            (strncmp(inst, "9C", 2) == 0) ||    /* MUL */
            (strncmp(inst, "9D", 2) == 0) ||    /* MUL */
            (strncmp(inst, "9E", 2) == 0) ||    /* MUL */
            (strncmp(inst, "9F", 2) == 0) ||    /* MUL */
            (strncmp(inst, "C", 1) == 0) ||     /* RJMP */
            ((inst[3] == '9') && (strncmp(inst, "94", 2) == 0)))    /* IJMP */
            cycle_cnt = 2;

        /* check if it is a three cycle instruction */
        if ((strncmp(inst, "940C", 4) == 0) ||  /* JMP */
            (strncmp(inst, "D", 1) == 0) ||     /* RCALL */
            ((inst[3] == '9') && (strncmp(inst, "95", 2) == 0)))    /* ICALL */
            cycle_cnt = 3;

        /* check if it is a four cycle instruction */
        if ((strncmp(inst, "940E", 4) == 0) ||  /* CALL */
            (strncmp(inst, "9508", 4) == 0) ||  /* RET */
            (strncmp(inst, "9518", 4) == 0))    /* RETI */
            cycle_cnt = 4;
    }


    /* have the cycle count, return it */
    return  cycle_cnt;

}
