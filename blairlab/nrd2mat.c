#include <math.h>
#include <stdio.h>
#include <assert.h>
#include <sys/time.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include <stdint.h>


#define HEADER_SIZE 16384            // 'twas ordained as such
#define MAX_CHANNEL_COUNT_CHARS 3    // we know we can't have more than 3 channels




int main( int argc, char *argv[] ) {

	if ( argc != 2 ) {// argc should be 2 for correct execution
    	// We print argv[0] assuming it is the program name
    	printf("usage : %s <filename> <channel(s)>\n", argv[0]);
	};
	
    int i = 0;
	char header[HEADER_SIZE];
	int elementsRetrieved;
    long lSize;
    long dataElements;
    char channelCountStr[MAX_CHANNEL_COUNT_CHARS];
    int NumADChannels=0;

	// OPEN THE FILE
	FILE * nrdFile;
	if (!(nrdFile = fopen(argv[1], "rb"))) {
    	printf("File %s can not be open for read.\n", argv[1]);
       	return -1;
   	}

	//find end of data file
    fseek (nrdFile , 0 , SEEK_END);
    lSize = ftell (nrdFile);
	rewind(nrdFile);
	printf("\nfile size : %ld",lSize);
	
	// EXTRACT THE HEADER
	char * headerStart = header;
	elementsRetrieved = fread( header, 1, HEADER_SIZE, nrdFile );
	if ( elementsRetrieved != HEADER_SIZE ) {
		printf("Error! incorrect number of header elements retrieved.");
		return -1;
	}
	printf("\nheader elements retrieved %d",elementsRetrieved);
	printf("\n\n%s\n",header);


	// set up regular expression section to check expected record size
	//
	const char * regexString = "NumADChannels +([0-9]+)";
	regex_t regexCompiled;
	int maxMatches = 2;
	regmatch_t regexMatches[maxMatches];
	//
	int regexCompResult = regcomp( &regexCompiled, regexString, REG_EXTENDED);
	if ( regexCompResult != 0 ) {
		printf("regular expression compilation failed w/ code %i.\n",regexCompResult); // this should never happen.
		return 10;
    };
    int regexResult = regexec( &regexCompiled, header, maxMatches, regexMatches, 0 );
	int idxStart = regexMatches[0].rm_so;
	int idxEnd = regexMatches[0].rm_eo;
	// pull the whole match out
	printf("Line: <<%.*s>>\n", (int)(idxEnd - idxStart), headerStart + regexMatches[0].rm_so);
	 idxStart = regexMatches[1].rm_so;
	 idxEnd = regexMatches[1].rm_eo;
	printf("group: <<%.*s>>\n", (int)(idxEnd - idxStart), headerStart + idxStart);
	// pull the first group out
	int groupMatchSize = (int)(regexMatches[1].rm_eo - regexMatches[1].rm_so);
	for ( int ii=0; ii<MAX_CHANNEL_COUNT_CHARS; ii++) {
		channelCountStr[ii]=header[(int)(regexMatches[1].rm_so+ii)];
	}
	printf("%s channels detected\n", channelCountStr);
	NumADChannels = atoi(channelCountStr);
	
	
	// TODO
	// print header to text file
	
	// TODO
	// check the file is RAW by reading the header
	// e.g. :    -FileType Raw
	
	// TODO
	// check the calculations of the record size
	// e.g.    -RecordSize 584 
	
	// TODO maybe?
	// double check for NumChannels
	// NumChannels != NumADChannels would be weird?
	// e.g. -NumChannels 128
	
	
//	if (!( groupMatchSize > MAX_CHANNEL_COUNT_CHARS)) {
//		strcopy( channelCount, ("%.*s", groupMatchSize, headerStart + regexMatches[1].rm_so) );
//		printf("Line: <<%.*s>> channels\n", groupMatchSize, headerStart + regexMatches[1].rm_so);
//	} else {
//		printf("regex channel count extraction failed.");
//		return 23;
//	};


	
	int bytesPerRecord=((18+NumADChannels)*32 )/ 8;
//	fseek(fid, 0, 1);
//	pos=ftell(fid);
	float num_recs=(lSize-HEADER_SIZE)/bytesPerRecord;
	printf( "number records %f\n", num_recs );
	printf( "fractional records %ld\n", (lSize-HEADER_SIZE) % bytesPerRecord);
	printf( "found %ld bytes; %ld data bytes; %i bytes per record \n", lSize, lSize-HEADER_SIZE, bytesPerRecord);
//	if mod(num_recs,1)>0
//	   warning('Fractional number of records detected! Expect more errors.')
//	elseif recordStart >= floor(num_recs)
//	   warning('record start cannot be greater than or equal to the number of records in the file.');
//	   return;
//	end
//	*/




	FILE * headerOutputFile = NULL;
	if (!(headerOutputFile = fopen("headerOutputFile.txt", "w")))  {
	    printf("Error opening header output file!\n");
	    exit(1);
	}
	fprintf( headerOutputFile, "%s\n", header);
	fclose( headerOutputFile );



	// position ourselves at the start of the data, which is at the end of the header
    fseek (nrdFile , HEADER_SIZE , SEEK_SET);   // why. why set and not START, when the end is _END?

	//////////
	// set up various output files
	//////////
	
	// timestamps go into 1 file to save space
	FILE * timestampsOutputFile = NULL;
	if (!(timestampsOutputFile = fopen("timestamps.dat", "w")))  {
	    printf("Error opening timestamps output file!\n");
	    exit(1);
	}
	
	
	// TODO generalize this so it handles n channels
	FILE * channelOutputFile = NULL;
	if (!(channelOutputFile = fopen("channelOutputFile.dat", "w")))  {
	    printf("Error opening channel output data file!\n");
	    exit(1);
	}
	

	// set up some acounting
	int goodRecordsRead = 0;
	int dataWordsSkipped = 0;
	// remember, the number of records is stored here num_recs
	
	// set up variables we will reuse
	// TODO find out if it actually matters that these are supposedly forced to 32 bit integers
	int32_t startTransmission = 0;
	int32_t packetId = 0;
	int32_t packetSize = 0;
	long currentPosition = 0;
	unsigned int currentCrc = 0;		// Nlx specifies this type as DWORD (32bit unsigned ambiguous data), but DWORD is apparently MS Windows-only
	uint32_t * currentPacket = malloc(bytesPerRecord); // allocate a block of memory to pull a whole record out at once; for the time being this will be inefficient
	uint64_t timestamp = 0;
	unsigned int tmpCrc = 0;
		
//		elementsRetrieved = fread( header, 1, HEADER_SIZE, nrdFile );
	fread( &startTransmission,        4,  1, nrdFile );  // ptr to destination, size in bytes to read, number of elements to read, ptr to file to read from
	fread( &packetId,        4,  1, nrdFile );
	fread( &packetSize,        4,  1, nrdFile );
	printf( "startTransmission value : %i ;  packetId value : %i ;  packetSize value : %i \n", startTransmission, packetId, packetSize);
	
	currentPosition = ftell (nrdFile);                
    fseek( nrdFile, currentPosition-(3*4), SEEK_SET);
	fread( currentPacket, bytesPerRecord,  1, nrdFile );
	printf( "startTransmission value : %i ;  packetId value : %i ;  packetSize value : %i \n", currentPacket[0], currentPacket[1], currentPacket[2]);
	
	timestamp = (uint64_t)currentPacket[3];
	timestamp <<= 32;
	timestamp += (uint64_t)currentPacket[4];
	printf( "first timestamp (unsigned int) %llu    (unsigned long) %lu \n", timestamp, (unsigned long)timestamp);

while ( 1 ) {
	
	if ( feof(nrdFile) ) { break; }		// quit if we are at the end of the file.
    
	currentPosition = ftell (nrdFile);  // if the CRC check fails, we want to advance 4 bytes from here
    
    if ( fread( currentPacket, bytesPerRecord,  1, nrdFile ) != 1 ) { printf("an error occurred while reading the current packet in the data extraction loop! quiting..."); break; };
	
	/*
    if ( currentPacket[0] == 2048 ) {   // check for start of record;  should always equal 2048

        if ( currentPacket[1] == 1 ) {
        
            if ( currentPacket[2] == 10 + NumADChannels ) {  // by definition, this should always be true
      */      
                // I. read the whole record and XOR everything together to check integrity

                // 3. read every entry and bitwise XOR 
                printf("\n\n");
                currentCrc = (unsigned int)currentPacket[0];
                printf("%u\n", currentCrc);
                for ( unsigned int idx = 1; idx<bytesPerRecord/4; idx++ ) {
                    currentCrc ^= (unsigned int)currentPacket[idx];                      // NOTE : The Neuralynx documentation says this is an OR but that is incorrect, it is an XOR
	                printf("%u\n", (unsigned int)currentPacket[idx]);
                }
				printf("crc output %i\n", currentCrc);
				printf("bytes per record %i  ; to read %i \n", bytesPerRecord, bytesPerRecord/4);
			

                printf("\n------------\n");				
			    fseek (nrdFile , HEADER_SIZE , SEEK_SET);

	          	fread( &currentCrc,        4,  1, nrdFile );
                printf("%u\n", currentCrc);

                for ( unsigned int idx = 1; idx < 18+NumADChannels; idx++ ) {
                	fread( &tmpCrc,        4,  1, nrdFile );
                    currentCrc ^= tmpCrc;                  // NOTE : The Neuralynx documentation says this is an OR but that is incorrect, it is an XOR
		             printf("%u\n", tmpCrc);
                }
				printf("crc output %i  ;  total read %i\n", currentCrc, 18+NumADChannels);
			    
				
              break;
                
		/*	}
		}
	}*/
}
            /*    
                // 4. check the result
                if ( tempCrc ~= 0 ) {
                
                    // go back to 1 entry after the bogus record start and
                    // keep trying
                    currentPosition = ftell( nrdFile );
                    fseek( nrdFile, currentPosition-(4*(17+NumADChannels)), SEEK_SET);
                    dataWordsSkipped = dataWordsSkipped+1;
                    
                } else {
                
                    // II. extract the record

                    // 1. rewind
                    currentPosition = ftell( nrdFile ); // yes, it's redundant with the one in the if statement, but this is clear.
                    fseek( nrdFile, currentPosition-(4*(18-3+NumADChannels)), SEEK_SET); // we already read the first three
                    goodRecordsRead = goodRecordsRead + 1;
                    timestampHighbits          = fread( nrdFile,        1, 'uint32' ); // half of a 64 bit number
                    timestampLowbits           = fread( nrdFile,        1, 'uint32' ); // half of a 64 bit number
                    status                     = fread( nrdFile,        1,  'int32' ); // almost useless? "reserved" whatever that means
                    TTLState                   = fread( nrdFile,        1, 'uint32' ); // parallel port input, 2^32 states, but only 32 signals
                    extras                     = fread( nrdFile,       10,  'int32' ); // magical hardware codes
                    dataframe                  = fread( nrdFile, NumADChannels,  'int32' ); // read the whole frame
                    data(:,goodRecordsRead)    = dataframe( channelsRequested ); // select the requested channels
                    crc                        = fread( nrdFile,        1,  'int32' ); // check sum value
                    // combine the timestamps into a 64 bit integer
                    //
                    // TODO (?) can't this simply be read as a 64 bit uint
                    // directly?
                    // TODO -- there's no checking or correction provided
                    // for out of order records here. fix this at some
                    // point.
                    timestamps(goodRecordsRead) = bitshift( uint64(timestampHighbits),32)+uint64(timestampLowbits);
                    // try to read the timestamps and guess where the
                    // appropriate one will be and then gradient descent or
                    // birthday guess to it.
                }
            }
        }
    }
	*/
	
	
	



	printf("\n");
	
	// clean up
	free(currentPacket);
	fclose(nrdFile);
	fclose(timestampsOutputFile);
	fclose(channelOutputFile);
	
	return 0;

}

