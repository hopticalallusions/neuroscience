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
	
	bool processTimestamps = true;
	bool processTtls = false;
	bool processHeader = true;
	bool processChannels = true;
	bool displayHelp = false;
	bool verboseOutput = false;
	bool obeyErrorLimit = true;
	bool extractChannels = true;
	char * strWhere;

	unsigned int errorLimit = 1000;
	unsigned int argvIdxToFile = 1;
	int arrayOfChannelsToExtract[MAX_CHANNELS];
	int numberOfChannelsToExtract = 0;
	char *ptrToEnd; // this value will be NULL if strtol not a number
	long argChannel; // but it will still return whatever numerical parts are available here

	
	// flags will subtract functionality, because on the first run, you probably want all these outputs
	for ( unsigned int idx=0; idx < argc; idx++ ) {
//		printf("%lu chars ;; %s/n", strlen(argv[idx]), argv[idx]);
		strWhere = strstr (argv[idx],".nrd"); if ( strWhere != NULL ) { argvIdxToFile = idx; printf("INFO : argument %u detected as the data file\n", idx); }
		strWhere = strstr (argv[idx],"-t");	  if ( ( strlen(argv[idx]) < 3 ) && strWhere != NULL ) { processTimestamps = false; printf("INFO : NO timestamp output\n"); }
		strWhere = strstr (argv[idx],"+T");	  if ( ( strlen(argv[idx]) < 3 ) && strWhere != NULL ) { processTtls = false; printf("INFO : TTLs will be output\n"); }
		strWhere = strstr (argv[idx],"-H");	  if ( ( strlen(argv[idx]) < 3 ) && strWhere != NULL ) { processHeader = false; printf("INFO : NO header output\n"); }
		strWhere = strstr (argv[idx],"-h");	  if ( ( strlen(argv[idx]) < 3 ) && strWhere != NULL ) { displayHelp = true; }
		strWhere = strstr (argv[idx],"-v");	  if ( ( strlen(argv[idx]) < 3 ) && strWhere != NULL ) { verboseOutput = true; }
		strWhere = strstr (argv[idx],"-e");	  if ( ( strlen(argv[idx]) < 3 ) && strWhere != NULL ) { obeyErrorLimit = false; }
		//strWhere = strstr (argv[idx],"-c ");	  if ( strWhere != NULL ) { extractChennels = false; printf("INFO : NO channel data output\n"); }
		// I want to make a mode where it doesn't process everything, but that gets complicated in case you want timestamps or TTLs b/c you must process the packets to get those...
		argChannel = strtol( argv[idx], &ptrToEnd, 10 ); // try converting the argument string to a long base 10 number
		if ( !*ptrToEnd ) { 
				// check whether the channels are rational later.
				arrayOfChannelsToExtract[numberOfChannelsToExtract] = (int)argChannel;
				numberOfChannelsToExtract++;
		} // else { printf( "%s is not a number \n", ptrToEnd); }
	}

	/* TODO
	fix channels
		duplicate channels
		out of range channels
	*/

	if ( displayHelp ) {
	
		printf("+--------------------------------------------------------------+\n");
		printf("|                       nrdExtract help                        |\n");
		printf("+--------------------------------------------------------------+\n");
		printf("|                                                              |\n");
		printf("| USAGE   : nrdExtract (-<[]>)... <file>.nrd <ch#> ... <ch#>   |\n");
		printf("|                                                              |\n");
		printf("| OUTPUTS : to current directory; 1 file per channel, header   |\n");
		printf("|           file, timestamp file, TTL state file, *overwrites* |\n");
		printf("|           existing files                                     |\n");
		printf("|                                                              |\n");
		printf("| FLAGS   : each flag must be preceded by a -; e.g. -t -h ...  |\n");
		printf("|           -t  -- do not output timestamp file                |\n");
		printf("|           +T  -- output TTL file                             |\n");
		printf("|           -h  -- do not output header file                   |\n");
		printf("|           -H  -- display this help & quit                    |\n");
		printf("|           -v  -- verbose output                              |\n");
		printf("|           -e  -- ignore error limit                          |\n");
		printf("|                                                              |\n");
		printf("+--------------------------------------------------------------+\n");
		return 100;
		
	}


	if ( verboseOutput ) {
		printf("INFO : argument %u, '%s', detected as the data file\n", argvIdxToFile, argv[argvIdxToFile]);
		if ( !processTimestamps ) { printf("INFO : NO timestamp output\n"); }
		if ( !processTtls       ) { printf("INFO : NO TTLs output\n"); }
		if ( !processHeader     ) { printf("INFO : NO header output\n"); }
	}
	


	/********************************
	 * open file and evaluate size  *
	 ****************************** */
	
	if ( verboseOutput ) { printf("STEP : opening file\n"); };
	
    long lSize;

	// open the data file to process
	FILE * nrdFile;
	if (!(nrdFile = fopen( argv[argvIdxToFile], "rb" ) )) {
    	printf( "ERROR : File %s can not be open for read. \n Quitting... \n", argv[1] );
       	return -1;
   	}

	//find end of data file
    fseek( nrdFile , 0 , SEEK_END );
    lSize = ftell( nrdFile );
	rewind( nrdFile );


	/**********************
	 * process the header *
	 ******************** */

	if ( verboseOutput ) { printf("STEP : extracting header\n"); }

	char header[HEADER_SIZE];
	int elementsRetrieved;
	
	// EXTRACT THE HEADER
	char * headerStart = header;
	elementsRetrieved = fread( header, 1, HEADER_SIZE, nrdFile );
	if ( elementsRetrieved != HEADER_SIZE ) {
		printf("ERROR : incorrect number of header elements retrieved.\n Quitting...\n");
		return -1;
	}
	
	if ( verboseOutput ) { printf("INFO : header elements retrieved %d \n",elementsRetrieved); }


	/************************************************
	 * use regular expressions to munge header info *
	 ********************************************** */

	if ( verboseOutput ) { printf("STEP : parsing header\n"); };

	/* 
	TODO
	this section is ugly.
	it would benefit from creating some helper functions so it isn't all copy and paste grossness.
	*/


    //
	// set up regular expression section to check number of AD channels
	//
    char channelCountStr[MAX_CHANNEL_COUNT_CHARS]; // TODO not completely safe?
    int NumADChannels=0;
	const char * regexString = "NumADChannels +([0-9]+)";
	regex_t regexCompiled;
	int maxMatches = 2;
	regmatch_t regexMatches[maxMatches];
	//
	int regexCompResult = regcomp( &regexCompiled, regexString, REG_EXTENDED);
	if ( regexCompResult != 0 ) {
		printf("ERROR : regular expression compilation failed w/ code %i. \n Quitting...\n",regexCompResult); // this should never happen.
		return 10;
    };
    int regexResult = regexec( &regexCompiled, header, maxMatches, regexMatches, 0 );
	// pull the first group out
	int idxStart = regexMatches[1].rm_so;
	int idxEnd = regexMatches[1].rm_eo;
	int groupMatchSize = (int)(regexMatches[1].rm_eo - regexMatches[1].rm_so);
	for ( int ii=0; ii<MAX_CHANNEL_COUNT_CHARS; ii++) {
		channelCountStr[ii]=header[(int)(regexMatches[1].rm_so+ii)];
	}
	NumADChannels = atoi(channelCountStr);
	
	
	if ( verboseOutput ) { printf("INFO : %i A-to-D channels detected\n", NumADChannels); };
	
	
	
	// 
	// attempt to confirm the file is RAW by reading the header
	// 
	strWhere = strstr ( header, "-FileType Raw");	
	if ( strWhere != NULL ) { 
		if ( verboseOutput ) { printf("INFO : Filetype confirmed RAW by header\n"); }
	} else { 
		printf("WARNING : Filetype NOT confirmed to be Nlx RAW file by header!  Proceeding...\n");
	}

	
	// 
	// check the calculations of the record size
	// e.g.    -RecordSize 584 
	regexString = "RecordSize +([0-9]+)";
	regexCompResult = regcomp( &regexCompiled, regexString, REG_EXTENDED);
	if ( regexCompResult != 0 ) {
		printf("regular expression compilation failed w/ code %i.\n  Quitting...\n",regexCompResult); // this should never happen.
		return 10;
    };
    regexResult = regexec( &regexCompiled, header, maxMatches, regexMatches, 0 );
	// pull the group out
	idxStart = regexMatches[1].rm_so;
	idxEnd = regexMatches[1].rm_eo;
	groupMatchSize = (int)(regexMatches[1].rm_eo - regexMatches[1].rm_so);
	for ( int ii=0; ii<MAX_CHANNEL_COUNT_CHARS; ii++) {
		channelCountStr[ii]=header[(int)(regexMatches[1].rm_so+ii)];
	}
	int headerRecordSize = 0;
	headerRecordSize = atoi(channelCountStr);
	if ( verboseOutput ) { printf("INFO : %i record size detected\n", headerRecordSize); }
	
	
/*
	// 
	// TODO -- extract the date;; goal here is to be able to append the date onto the file names, but lazy-quick version not working :(
	// 
	char dateStr[11];
	regexString = "Time Opened (m/d/y): ([0-9]+/[0-9]+/[0-9]+)";
	regexCompResult = regcomp( &regexCompiled, regexString, REG_EXTENDED);
	if ( regexCompResult != 0 ) {
		printf("regular expression compilation failed w/ code %i.\n  Quitting...\n",regexCompResult); // this should never happen.
		return 10;
    };
    regexResult = regexec( &regexCompiled, header, maxMatches, regexMatches, 0 );
	// pull the group out
	idxStart = regexMatches[1].rm_so;
	idxEnd = regexMatches[1].rm_eo;
	groupMatchSize = (int)(regexMatches[1].rm_eo - regexMatches[1].rm_so);
	for ( int ii=0; ii<11; ii++) {
		dateStr[ii]=header[(int)(regexMatches[1].rm_so+ii)];
	}
	printf("INFO : date %s", dateStr);
*/	
	
	
	
	
	
	
	//
	// double check for NumChannels
	// NumChannels != NumADChannels would be weird?
	// e.g. -NumChannels 128
	regexString = "NumChannels +([0-9]+)";
	regexCompResult = regcomp( &regexCompiled, regexString, REG_EXTENDED);
	if ( regexCompResult != 0 ) {
		printf("regular expression compilation failed w/ code %i.\n  Quitting...\n",regexCompResult); // this should never happen.
		return 10;
    };
    regexResult = regexec( &regexCompiled, header, maxMatches, regexMatches, 0 );
	// pull the first group
	idxStart = regexMatches[1].rm_so;
	idxEnd = regexMatches[1].rm_eo;
	groupMatchSize = (int)(regexMatches[1].rm_eo - regexMatches[1].rm_so);
	for ( int ii=0; ii<MAX_CHANNEL_COUNT_CHARS; ii++) {
		channelCountStr[ii]=header[(int)(regexMatches[1].rm_so+ii)];
	}
	int numberOfChannels = 0;
	numberOfChannels = atoi(channelCountStr);
	if ( numberOfChannels == NumADChannels) { 
		if ( verboseOutput ) { printf("INFO : equal number of channels & A-to-D channels found\n"); }
	} else { 
		printf("WARNING : unequal number of channels found.\n");
	}
	

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
	
	if ( verboseOutput ) { printf("STEP : preparing to process data file\n"); };
	
	int bytesPerRecord=((18+NumADChannels)*32 )/ 8;

	// error checking
	if ( bytesPerRecord == headerRecordSize ) { 
			if ( verboseOutput ) { printf("INFO : header bytes per record consistent with calculated value \n"); }
	} else { 
		printf("WARNING : header bytes per record and calculated do not match! Proceeding...\n"); 
	}
	
	float num_recs=(lSize-HEADER_SIZE)/bytesPerRecord;
	int packatsExpected = (lSize-HEADER_SIZE)/bytesPerRecord;
	if ( verboseOutput ) { 
		printf( "STEP : preparing to process data file\n"); 
		printf( "INFO : estimated number of records %f\n", num_recs );
		printf( "INFO : estimated fractional records %ld\n", (lSize-HEADER_SIZE) % bytesPerRecord);
		printf( "INFO : found %ld bytes; %ld data bytes; %i bytes per record \n", lSize, lSize-HEADER_SIZE, bytesPerRecord);
	};

	// position ourselves at the start of the data, which is at the end of the header
    fseek (nrdFile , HEADER_SIZE , SEEK_SET);   // why. why set and not START, when the end is _END?

	//////////
	// set up various output files
	//////////

	if ( processHeader ) {
		FILE * headerOutputFile = NULL;
		if (!(headerOutputFile = fopen("headerOutputFile.txt", "w")))  {
			printf("Error opening header output file!\n  Quitting...\n");
			exit(1);
		}
		// this way produces a compact header file
		fprintf( headerOutputFile, "%s\n", header);
		//fwrite( header, 1, HEADER_SIZE, headerOutputFile );
		fclose( headerOutputFile );
	}
	
	FILE * timestampsOutputFile = NULL;
	if ( processTimestamps ) {
		// timestamps go into 1 file to save space
		if (!(timestampsOutputFile = fopen("timestamps.dat", "w")))  {
		    printf("Error opening timestamps output file!\n  Quitting...\n");
		    exit(1);
		}
	}

	FILE * ttlOutputFile = NULL; // these have to be outside the if or else errors occur.
	if ( processTtls ) {
		if (!(ttlOutputFile = fopen("ttlOutputFile.dat", "w")))  {
		    printf("Error opening TTL output data file!\n  Quitting...\n");
		    exit(1);
		}
	}
	
	// TODO this part is kinda sketchy
	FILE * tmpPtr = NULL;
	FILE * channelOutputFileArray[MAX_CHANNELS];
	// TODO -- this char array is not entirely safe...
	char tmpFilename[100]; 
	for ( unsigned int idx = 0; idx < numberOfChannelsToExtract; idx++ ) {
	    snprintf(tmpFilename, sizeof(char) * 32, "rawChannel_%i.dat", arrayOfChannelsToExtract[idx]);
		if (!(channelOutputFileArray[idx] = fopen(tmpFilename, "w")))  {
			 printf("Error opening channel output data file!\n  Quitting...\n");
		    exit(1);
		}
	}

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

 	if ( verboseOutput ) { printf("INFO : Entering the main processing loop.\n"); };
	
	float progress = 0;
	
	//
	// loop through all the data
	//
    fseek( nrdFile, HEADER_SIZE, SEEK_SET);
	while ( 1 ) {
	
		if (obeyErrorLimit) {
			if ( dataElementsSkipped > errorLimit ) { 
				printf("ERROR : quitting processing loop because error limit reached, and obeyErrorLimit enabled.\n");
				break;
			}
		}
		
		// TODO -- estimate progress completeness   ;; various versions of this don't work smoothly.
//		progress = (100*goodRecordsRead)/num_recs;
//		if ( ( fmod( progress, 10.0f ) < 0.0001f ) ) { printf("INFO : %i pct complete\n", (int)progress); }
	
		if ( feof( nrdFile ) ) { break; }	  // quit if we are at the end of the file.
	
		currentPosition = ftell ( nrdFile );  // if the CRC check fails, we want to advance 4 bytes from here
		
		// TODO -- feof doesn't really catch the end of the file, since we're reading packets; need to test if currentPosition + packet size will be too much

		if ( currentPosition+bytesPerRecord > lSize ) { 
			if ( verboseOutput ) { printf("INFO : Stopping loop @ %f %% ...\n", (100.0f*goodRecordsRead)/num_recs); } 
			if ( ((100.0f*goodRecordsRead)/num_recs) < 99.7f ) { printf("WARNING : only processed %f of records",(100.0f*goodRecordsRead)/num_recs); }
			break; 
		}

		if ( fread( currentPacket, bytesPerRecord,  1, nrdFile ) != 1 ) { printf("ERROR : an error occurred while reading the current packet in the data extraction loop! \n Stopping loop @ %f %% ...\n", (100*goodRecordsRead)/num_recs); break; };
		 
			if ( currentPacket[0] == (uint32_t)2048 ) {
		
				if ( currentPacket[1] == (uint32_t)1 ) {

					if ( currentPacket[2] == (uint32_t)(10 + NumADChannels) ) { 

						// read the whole record and XOR everything together to check integrity
						currentCrc = (unsigned int)currentPacket[0];
						for ( unsigned int idx = 1; idx<bytesPerRecord/4; idx++ ) {
							currentCrc ^= (unsigned int)currentPacket[idx];                      // NOTE : The Neuralynx documentation says this is an OR but that is incorrect, it is an XOR
						}
					
						if ( currentCrc == (unsigned int)0 ) {
							
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
							
							if (processTimestamps ) {
								timestamp = (uint64_t)currentPacket[3];
								timestamp <<= 32;
								timestamp += (uint64_t)currentPacket[4];
								fwrite( &timestamp, 1, sizeof(uint64_t), timestampsOutputFile );  // write as raw string of 64bit timestamps
							}
	
							if ( processTtls ) {
								fwrite( &currentPacket[6], 1, sizeof(uint32_t), ttlOutputFile );
							}
												
							// output channel data
							for ( unsigned int idx = 0; idx < numberOfChannelsToExtract; idx++ ) {
								// TODO double check that it should be 17 and not 18
								datum = (int32_t)currentPacket[17+arrayOfChannelsToExtract[idx]];   
								fwrite( &datum, 1, sizeof(int32_t), channelOutputFileArray[idx] );
							}
						
							goodRecordsRead++;

							// TODO -- make this output 3 byte (24 bit) integers to save space.
							// misc 24 bit output advice :
							// https://bytes.com/topic/c/answers/510278-24-bit-words
							// http://forums.codeguru.com/showthread.php?287735-24-bit-integer
							// http://pubs.opengroup.org/onlinepubs/009695399/basedefs/stdint.h.html
						
						} else {
						
							// the packet failed, so advance the position of the file 4 bytes and try again
							fseek (nrdFile , currentPosition+4 , SEEK_SET);
							dataElementsSkipped++;

						};				
				} else { 
					if ( verboseOutput ) { printf("WARNING : packetSize failed. Proceeding...\n"); } 
					fseek (nrdFile , currentPosition+4 , SEEK_SET);
					dataElementsSkipped++;
				}
			} else { 
				if ( verboseOutput ) { printf("WARNING : packetId failed. Proceeding...\n"); }
				fseek (nrdFile , currentPosition+4 , SEEK_SET);
				dataElementsSkipped++;
			}
		} else { 
			if ( verboseOutput ) { printf("WARNING : startTransmission failed. Proceeding...\n"); } 
			fseek (nrdFile , currentPosition+4 , SEEK_SET);
			dataElementsSkipped++;
		}
	}
	
	if ( verboseOutput ) { 
		printf( "STEP : Completed the main processing loop.\n" ); 
		printf("\n");
		printf( "INFO : %f total packets *expected*\n", num_recs ); 
		printf( "INFO : %i total packets processed\n", goodRecordsRead ); 
		printf("\n");
		printf( "INFO : %li skipped elements *expected*\n", ( (lSize-HEADER_SIZE) % bytesPerRecord )/4 ); // TODO this might be incorrect?
		printf( "INFO : %i data elements skipped\n", dataElementsSkipped );
		printf("\n");
	};
	
	
	//
	// clean up
	//
	if ( verboseOutput ) { printf( "STEP : Cleaning up...\n" ); }
	free( currentPacket );
	fclose( nrdFile );
	if ( processTimestamps ) { fclose(timestampsOutputFile); }	
	if ( processTtls ) { fclose(ttlOutputFile); } 
	for ( unsigned int idx = 0; idx < numberOfChannelsToExtract; idx++ ) {
		fclose( channelOutputFileArray[idx] );
	}

/*
	//
	// summarize the results of the run
	//
	FILE * summaryFile = NULL;
	if (!(summaryFile = fopen( "executionSummary.log", "a" ) )) {
		printf( summaryFile, "nrdExtractor processed file %s\n", argv[argvIdxToFile])
		if ( bytesPerRecord == headerRecordSize ) { 
			printf( summaryFile, "%i record size detected; consistent with header\n", headerRecordSize); }
		} else { 
			printf( summaryFile, "%i record size detected; *inconsistent* with header\n", headerRecordSize); }
		}
		printf( summaryFile, "number of channels %i & number of A-to-D channels %i found\n", numberOfChannels, NumADChannels );
		printf( summaryFile, "estimated number of records %f\n", num_recs );
		printf( summaryFile, "estimated fractional records %ld\n", (lSize-HEADER_SIZE) % bytesPerRecord);
		printf( summaryFile, "found %ld bytes; %ld data bytes; %i bytes per record \n", lSize, lSize-HEADER_SIZE, bytesPerRecord);
		printf( summaryFile, "processed %f of records",(100.0f*goodRecordsRead)/num_recs);
		printf( summaryFile, "%f packets *expected* ; %i packets processed\n", num_recs, goodRecordsRead ); 
		printf( summaryFile, "%li skipped elements *expected* ;  %i data elements skipped\n", ( (lSize-HEADER_SIZE) % bytesPerRecord )/4, dataElementsSkipped ); // TODO this might be incorrect?
		printf( summaryFile, "\n\n\n");
	} else {	printf( "ERROR : File executionSummary.log can not be opened.\n" ); }
*/

	if ( verboseOutput ) { printf( "STEP : Terminating successfully.\n" ); }
	return 0;
}
