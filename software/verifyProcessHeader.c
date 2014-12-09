#include <stdio.h>
#include <stdlib.h>



void main(){

  FILE * inFile = fopen("block1.txt","r");
  if(inFile == NULL) exit(0);
  int i = 0;
  unsigned val = 0;
  for(i = 0; i < 24; i++){
    printf("%d : ", i);
    fscanf(inFile,"%d\n",&val);
    printf("%x\n",val);
  }
}
