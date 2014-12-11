#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>

#include "PCIE.h"

//MAX BUFFER FOR DMA
#define MAXDMA 20

//BASE ADDRESS FOR CONTROL REGISTER
#define CRA 0x00000000

//BASE ADDRESS TO SDRAM
#define SDRAM 0x08000000

// data to write
#define DATA_SIZE 26 

#define RWSIZE (32 / 8)
PCIE_BAR pcie_bars[] = { PCIE_BAR0, PCIE_BAR1 , PCIE_BAR2 , PCIE_BAR3 , PCIE_BAR4 , PCIE_BAR5 };

// void test32( PCIE_HANDLE hPCIe, DWORD addr );
void writeDMA( PCIE_HANDLE hPCIe, DWORD addr, DWORD * blocks);

int main(void)
{
        void *lib_handle;
        PCIE_HANDLE hPCIe;
        DWORD bitcoin_blocks[DATA_SIZE];

        lib_handle = PCIE_Load();
        if (!lib_handle)
        {
                printf("PCIE_Load failed\n");
                return 0;
        }
        hPCIe = PCIE_Open(0,0,0);

        if (!hPCIe)
        {
                printf("PCIE_Open failed\n");
                return 0;
        }

        FILE * inFile = fopen("block1.txt","r");
        if(inFile == NULL) exit(0);

        int i = 0;
        unsigned long int val = 0;
        bitcoin_blocks[0] = 0xAAAA0000;
        bitcoin_blocks[1] = 0x0;

        for (i = 0; i < DATA_SIZE - 2; i++) {
                printf("%d : ", i);
                fscanf(inFile,"%lu\n",&val);
                bitcoin_blocks[i+2] = val;
                printf("%x\n",bitcoin_blocks[i+2]);
                printf("%x\n",val);
        }

        // write header to SDRAM
        writeDMA(hPCIe, SDRAM, bitcoin_blocks);
        return 0;
}

//tests DMA write of buffer to address
void writeDMA( PCIE_HANDLE hPCIe, DWORD addr, DWORD * bitcoin_blocks)
{
        BOOL bPass1, bPass2;
        DWORD addr1 = SDRAM;
        DWORD addr2 = SDRAM + 2 * DATA_SIZE; // 56 bytes later
        size_t amt_to_write = DATA_SIZE / 2 * RWSIZE;

        // write first half of bitcoin data array
        bPass1 = PCIE_DmaWrite(hPCIe, addr1, bitcoin_blocks, amt_to_write);
        if (!bPass1)
        {
                printf("1st half bitcoin block array write failed");
                return;
        }

        // write second half of bitcoin data array, account for last word
        bPass2 = PCIE_DmaWrite(hPCIe, addr2, bitcoin_blocks + 12, amt_to_write + 4);
        if (!bPass2)
        {
                printf("2nd half bitcoin block array write failed");
                return;
        }

        return;
}

