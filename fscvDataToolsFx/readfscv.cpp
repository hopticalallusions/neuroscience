#include <math.h>
#include <stdio.h>
#include <assert.h>
#include <sys/time.h>

#define DATA_SIZE 255000


int main() {

    float fscv[DATA_SIZE];  // input
	int elementsRetrieved = 1;


    FILE * efscv;
    if (!(efscv = fopen("tarheelSample.fscv", "rb"))) 
    {
        printf("File can not be open for read.\n");
        return -1;
    }
	elementsRetrieved = fread( fscv, 2, DATA_SIZE, efscv );

	printf("%d\n" , elementsRetrieved);

	for ( int i=5000; i<5010; i++) { printf("%f\t" , fscv[i]); }
	
}
