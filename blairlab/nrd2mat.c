// copyright Andrew G. Howe 2017

#include <math.h>
#include <stdio.h>
#include <assert.h>
#include <sys/time.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include <stdint.h>
#include <stdbool.h>

#define HEADER_SIZE 16384           // 'twas ordained as such
#define MAX_CHANNEL_COUNT_CHARS 3   // we know we can't have more than 3 characters to describe channels
#define MAX_CHANNELS 128			// maximum supported channel count in OUR LABORATORY'S Nlx RAW believed as of September 2017

	//    $  gcc -lc++ program.c   # OS X trick?


int main( int argc, char *argv[] ) {

	/**********************
	 * parse arguments    *
	 ******************** */

	if ( argc != 2 ) {// argc should be 2 for correct execution
    	// We print argv[0] assuming it is the program name
    	printf("usage : %s <filename> <channel(s)>\n", argv[0]);
	};

	char * strWhere;
	strWhere = strstr (argv[1],".nrd");
	if ( strWhere == NULL ) { printf("WARNING : program might fail! first argument assumed to be input file, and its extension is not .nrd "); }
	

	
	bool processTimestamps = true;
	bool processTtls = true;
	bool processHeader = true;
	bool processChannels = true;
	unsigned int argvIdxToFile = 1;
	int arrayOfChannelsToExtract[MAX_CHANNELS];
	int numberOfChannelsToExtract = 0;
	char *ptrToEnd; // this value will be NULL if strtol not a number
	long argChannel; // but it will still return whatever numerical parts are available here
	int temp = 0;
	
	// default behavior here will be to subtract functionality, because on the first run, you probably want all these things
	for ( unsigned int idx=0; idx < argc; idx++ ) {
		strWhere = strstr (argv[idx],".nrd");	if ( strWhere != NULL ) { argvIdxToFile = idx; printf("argument %u detected as the data file\n", idx); }
		strWhere = strstr (argv[idx],"-t");	if ( strWhere != NULL ) { processTimestamps = false; printf("not processing timestamps\n"); }
		strWhere = strstr (argv[idx],"-T");	if ( strWhere != NULL ) { processTtls = false; printf("not processing TTLs\n"); }
		strWhere = strstr (argv[idx],"-H");	if ( strWhere != NULL ) { processHeader = false; printf("not outputting header\n"); }
		argChannel = strtol( argv[idx], &ptrToEnd, 10 ); 
		if ( !*ptrToEnd ) { 
				// check whether the channels are rational later.
				arrayOfChannelsToExtract[numberOfChannelsToExtract] = (int)argChannel;
				numberOfChannelsToExtract++;
		} else { printf( "%s is not a number \n", ptrToEnd); }
	}


	/********************************
	 * open file and evaluate size  *
	 ****************************** */
	
    long lSize;
    long dataElements;

	// open the data file to process
	FILE * nrdFile;
	if (!(nrdFile = fopen(argv[argvIdxToFile], "rb"))) {
    	printf("File %s can not be open for read.\n", argv[1]);
       	return -1;
   	}

	//find end of data file
    fseek (nrdFile , 0 , SEEK_END);
    lSize = ftell (nrdFile);
	rewind(nrdFile);
	// printf("\nfile size : %ld",lSize);



	/**********************
	 * process the header *
	 ******************** */

	char header[HEADER_SIZE];
	int elementsRetrieved;
    char channelCountStr[MAX_CHANNEL_COUNT_CHARS];
    int NumADChannels=0;
	
	// EXTRACT THE HEADER
	char * headerStart = header;
	elementsRetrieved = fread( header, 1, HEADER_SIZE, nrdFile );
	if ( elementsRetrieved != HEADER_SIZE ) {
		printf("Error! incorrect number of header elements retrieved.");
		return -1;
	}
	if ( processHeader ) { printf("\nheader elements retrieved %d \n",elementsRetrieved); }



	/************************************************
	 * use regular expressions to munge header info *
	 ********************************************** */

	/* 
	TODO
	this section is ugly.
	it would benefit from creating some nice functions so it isn't all copy and paste grossness.
	*/


    //
	// set up regular expression section to check number of AD channels
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
	// pull the whole match out
	int idxStart = regexMatches[0].rm_so;
	int idxEnd = regexMatches[0].rm_eo;
	//printf("Line: <<%.*s>>\n", (int)(idxEnd - idxStart), headerStart + regexMatches[0].rm_so);
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
	// check the file is RAW by reading the header
	// e.g. :    -FileType Raw
	strWhere = strstr ( header, "-FileType Raw");	if ( strWhere != NULL ) { printf("INFO : Filetype confirmed RAW by header\n"); } else { printf("WARNING : Filetype NOT confirmed RAW by header!\n"); }

	
	// 
	// check the calculations of the record size
	// e.g.    -RecordSize 584 
	regexString = "RecordSize +([0-9]+)";
	regexCompResult = regcomp( &regexCompiled, regexString, REG_EXTENDED);
	if ( regexCompResult != 0 ) {
		printf("regular expression compilation failed w/ code %i.\n",regexCompResult); // this should never happen.
		return 10;
    };
    regexResult = regexec( &regexCompiled, header, maxMatches, regexMatches, 0 );
	// pull the whole match out
	idxStart = regexMatches[0].rm_so;
	idxEnd = regexMatches[0].rm_eo;
	printf("Line: <<%.*s>>\n", (int)(idxEnd - idxStart), headerStart + regexMatches[0].rm_so);
	idxStart = regexMatches[1].rm_so;
	idxEnd = regexMatches[1].rm_eo;
	printf("group: <<%.*s>>\n", (int)(idxEnd - idxStart), headerStart + idxStart);
	// pull the first group out
	groupMatchSize = (int)(regexMatches[1].rm_eo - regexMatches[1].rm_so);
	for ( int ii=0; ii<MAX_CHANNEL_COUNT_CHARS; ii++) {
		channelCountStr[ii]=header[(int)(regexMatches[1].rm_so+ii)];
	}
	int headerRecordSize = 0;
	headerRecordSize = atoi(channelCountStr);
	printf("%i record size detected\n", headerRecordSize);
	
	
	
	//
	// double check for NumChannels
	// NumChannels != NumADChannels would be weird?
	// e.g. -NumChannels 128
		regexString = "NumChannels +([0-9]+)";
	regexCompResult = regcomp( &regexCompiled, regexString, REG_EXTENDED);
	if ( regexCompResult != 0 ) {
		printf("regular expression compilation failed w/ code %i.\n",regexCompResult); // this should never happen.
		return 10;
    };
    regexResult = regexec( &regexCompiled, header, maxMatches, regexMatches, 0 );
	// pull the whole match out
	idxStart = regexMatches[0].rm_so;
	idxEnd = regexMatches[0].rm_eo;
	printf("Line: <<%.*s>>\n", (int)(idxEnd - idxStart), headerStart + regexMatches[0].rm_so);
	idxStart = regexMatches[1].rm_so;
	idxEnd = regexMatches[1].rm_eo;
	printf("group: <<%.*s>>\n", (int)(idxEnd - idxStart), headerStart + idxStart);
	// pull the first group out
	groupMatchSize = (int)(regexMatches[1].rm_eo - regexMatches[1].rm_so);
	for ( int ii=0; ii<MAX_CHANNEL_COUNT_CHARS; ii++) {
		channelCountStr[ii]=header[(int)(regexMatches[1].rm_so+ii)];
	}
	int numberOfChannels = 0;
	numberOfChannels = atoi(channelCountStr);
	printf("%i number of channels detected\n", numberOfChannels);
	if ( numberOfChannels == NumADChannels) { printf("INFO : equal number of channels found\n");	} else { printf("WARNING : unequal number of channels found.\n"); }
	

	// ensure that the requested channels actually make sense.
	//
	// this is a lazy way to do this, but it will work for now.
	// a cool way would automatically eject invalid values
	// potential solution would be to malloc and copy to the malloc'd memory array only acceptable values
	for (int ii=0; ii<numberOfChannelsToExtract;ii++) { 
		if ( arrayOfChannelsToExtract[ii] > numberOfChannels) { 
			printf("ERROR! : channel %i is too big. Aborting....\n", arrayOfChannelsToExtract[ii]); 
			return -20;
		} 
	}

	
	
	/************************************************
	 * prepare to process data file                 *
	 ********************************************** */
	 printf("prepare to process the data file\n");
	
	int bytesPerRecord=((18+NumADChannels)*32 )/ 8;
	if ( bytesPerRecord == headerRecordSize ) { printf("INFO : header bytes per record consistent with calculated value \n"); } else { printf("WARNING : header bytes per record and calculated do not match!\n"); } ;
	
	float num_recs=(lSize-HEADER_SIZE)/bytesPerRecord;
	printf( "number records %f\n", num_recs );
	printf( "fractional records %ld\n", (lSize-HEADER_SIZE) % bytesPerRecord);
	printf( "found %ld bytes; %ld data bytes; %i bytes per record \n", lSize, lSize-HEADER_SIZE, bytesPerRecord);



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
	
	FILE * timestampsOutputFile = NULL;
	if ( processTimestamps ) {
		// timestamps go into 1 file to save space
		if (!(timestampsOutputFile = fopen("timestamps.dat", "w")))  {
		    printf("Error opening timestamps output file!\n");
		    exit(1);
		}
	}

	FILE * ttlOutputFile = NULL; // these have to be outside the if or else errors occur.
	if ( processTtls ) {
		if (!(ttlOutputFile = fopen("ttlOutputFile.dat", "w")))  {
		    printf("Error opening TTL output data file!\n");
		    exit(1);
		}
	}
	
	// TODO generalize this so it handles n channels
	FILE * channelOutputFile = NULL;
	if (!(channelOutputFile = fopen("channelOutputFile.dat", "w")))  {
	    printf("Error opening channelOutputFile data file!\n");
	    exit(1);
	}

/*	FILE * tmpPtr = NULL;
	FILE * channelOutputFile = malloc( numberChannelsRequested * sizeof( tmpPtr ) );
	char * tmpFilename[100];
	for ( unsigned int idx = 0; idx < numberChannelsRequested; idx++ ) {
		if (!(channelOutputFile[idx] = fopen("channelOutputFile.dat", "w")))  {
			 printf("Error opening channel output data file!\n");
		    exit(1);
		}
	}
*/	

	// set up some acounting
	int goodRecordsRead = 0;
	int dataElementsSkipped = 0;
	// remember, the number of records is stored here num_recs
	
	// set up variables we will reuse
	// TODO find out if it actually matters that these are supposedly forced to 32 bit integers
	long currentPosition = 0;
	unsigned int currentCrc = 0;		// Nlx specifies this type as DWORD (32bit unsigned ambiguous data), but DWORD is apparently MS Windows-only
	uint32_t * currentPacket = malloc(bytesPerRecord); // allocate a block of memory to pull a whole record out at once; for the time being this will be inefficient
	uint64_t timestamp = 0;		
	int32_t datum=0;


	/************************************************
	 * process the data file                        *
	 ********************************************** */
	 printf("start processing data file\n");
	
	currentPosition = ftell (nrdFile);                
//    fseek( nrdFile, HEADER_SIZE, SEEK_SET);
	fread( currentPacket, bytesPerRecord,  1, nrdFile );
	printf( "startTransmission value : %i ;  packetId value : %i ;  packetSize value : %i \n", currentPacket[0], currentPacket[1], currentPacket[2]);
	
	if ( processTimestamps ) {
		timestamp = (uint64_t)currentPacket[3];
		timestamp <<= 32;
		timestamp += (uint64_t)currentPacket[4];
		printf( "first timestamp (unsigned int) %llu    (unsigned long) %lu \n", timestamp, (unsigned long)timestamp);
	}


	while ( 1 ) {
	
		if ( feof(nrdFile) ) { break; }		// quit if we are at the end of the file.
	
		currentPosition = ftell (nrdFile);  // if the CRC check fails, we want to advance 4 bytes from here
	
		if ( fread( currentPacket, bytesPerRecord,  1, nrdFile ) != 1 ) { printf("an error occurred while reading the current packet in the data extraction loop! quiting..."); break; };
		 
			if ( currentPacket[0] == (uint32_t)2048 ) {
		
				if ( currentPacket[1] == (uint32_t)1 ) {

					if ( currentPacket[2] == (uint32_t)(10 + NumADChannels) ) { 

						// I. read the whole record and XOR everything together to check integrity

						// 3. read every entry and bitwise XOR 
						//printf("\n\n");
						currentCrc = (unsigned int)currentPacket[0];
						//printf("%u\n", currentCrc);
						for ( unsigned int idx = 1; idx<bytesPerRecord/4; idx++ ) {
							currentCrc ^= (unsigned int)currentPacket[idx];                      // NOTE : The Neuralynx documentation says this is an OR but that is incorrect, it is an XOR
						}
						//printf("crc output %i\n", currentCrc);
						//printf("bytes per record %i  ; to read %i \n", bytesPerRecord, bytesPerRecord/4);
					
						if ( currentCrc == (unsigned int)0 ) {
							// process the packet
						
							if (processTimestamps ) {
								// output timestamp
								timestamp = (uint64_t)currentPacket[3];
								timestamp <<= 32;
								timestamp += (uint64_t)currentPacket[4];
								fwrite( &timestamp, 1, sizeof(uint64_t), timestampsOutputFile );  // write as raw string of 64bit timestamps
							}
	
							if ( processTtls ) {
								// output TTL status 
								fwrite( &currentPacket[6], 1, sizeof(uint32_t), ttlOutputFile );
							}
												
							// output channel data
							datum = (int32_t)currentPacket[17+30];  // TODO figure out how to output signed 24 bit integers later; reduce file size by n_samples * 8 bits!
							fwrite( &datum, 1, sizeof(int32_t), channelOutputFile );
						
							goodRecordsRead++;
							// 24 bit output advice
							// https://bytes.com/topic/c/answers/510278-24-bit-words
							// http://forums.codeguru.com/showthread.php?287735-24-bit-integer
							// http://pubs.opengroup.org/onlinepubs/009695399/basedefs/stdint.h.html
						
							// should have naturally moved the position of the file sizeof(packet) bytes with read
						} else {
							// the packet failed, so advance the position of the file 4 bytes and try again
							fseek (nrdFile , currentPosition+4 , SEEK_SET);
							dataElementsSkipped++;
						};
			  
				  /*
				  == data packet map ==

					startTransmission -> [0]				' int32' |  1 | always 2048
					packetId          -> [1]				' int32' |  1 | always 1
					packetSize        -> [2]				' int32' |  1 | always  10 + n_chan
					timestampHighbits -> [3]			 	'uint32' |  1 | half of a 64 bit number
					timestampLowbits  -> [4] 			 	'uint32' |  1 | half of a 64 bit number
					status            -> [5]  			 	' int32' |  1 | almost useless? "reserved" whatever that means
					TTLState          -> [6]       			'uint32' |  1 | parallel port input, 2^32 states, but only 32 signals
					extras            -> [7-16]          	' int32' | 10 | magical hardware codes, ignore
					dataframe         -> [17-(17+n_chan)]	' int32' |  n | read the whole frame
					crc               -> [n_chan-1]         ' int32' |  1 | check sum value
				  */
			  
				
				} else { printf("packetSize failed\n"); } 
			} else { printf("packetId failed\n"); }
		} else { printf("startTransmission failed\n"); }
	}
	
	printf("finished processing data\n");
	printf("%i packets processed ;; %i bad data elements\n", goodRecordsRead, dataElementsSkipped);
	
	// clean up
	free(currentPacket);
	fclose(nrdFile);
	if ( processTimestamps ) { fclose(timestampsOutputFile); }	
	if ( processTtls ) { fclose(ttlOutputFile); } 

	fclose(channelOutputFile);
	
	return 0;

}

