chdata=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/201-08-22/rawChannel_88.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/201-08-22/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;
figure; subplot(3,1,1); plot(diff(tsdata)); subplot(3,1,2); plot((tsdata)); subplot(3,1,3); plot(tt,chdata);
disp(['missing data elements  ' num2str((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata)) ])
disp(['missing data length (s)  ' num2str(((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata))/32000) ])



chdata=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-01-27/rawChannel_88.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-01-27/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;
figure; subplot(3,1,1); plot(diff(tsdata)); subplot(3,1,2); plot((tsdata)); subplot(3,1,3); plot(tt,chdata);
disp(['missing data elements  ' num2str(round(((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata)) ])
disp(['missing data length (s)  ' num2str(round(((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata))/32000)) ])


chdata=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-08-21/rawChannel_88.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-08-21/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;
figure; subplot(3,1,1); plot(diff(tsdata)); subplot(3,1,2); plot((tsdata)); subplot(3,1,3); plot(tt,chdata);
disp(['missing data elements  ' num2str(round(((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata)) ])
disp(['missing data length (s)  ' num2str(round(((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata))/32000)) ])





chdata=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-01-27/rawChannel_88.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da10/2017-01-27/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;
figure; subplot(3,1,1); plot(diff(tsdata)); subplot(3,1,2); plot((tsdata)); subplot(3,1,3); plot(tt,chdata);
disp(['missing data elements  ' num2str(round(((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata)) ])
disp(['missing data length (s)  ' num2str(round(((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata))/32000)) ])




chdata=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da3/2015-10-29/rawChannel_24.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da3/2015-10-29/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;
figure; subplot(3,1,1); plot(diff(tsdata)); subplot(3,1,2); plot((tsdata)); subplot(3,1,3); plot(tt,chdata);
disp(['missing data elements  ' num2str(round(((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata)) ])
disp(['missing data length (s)  ' num2str(round(((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata))/32000)) ])


chdata=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da3/2015-12-02/rawChannel_24.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da3/2015-12-02/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;
figure; subplot(3,1,1); plot(diff(tsdata)); subplot(3,1,2); plot((tsdata)); subplot(3,1,3); plot(tt,chdata);
disp(['missing data elements  ' num2str(round(((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata)) ])
disp(['missing data length (s)  ' num2str(round(((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata))/32000)) ])



chdata=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da3/2016-01-20/rawChannel_24.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da3/2016-01-20/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;
figure; subplot(3,1,1); plot(diff(tsdata)); subplot(3,1,2); plot((tsdata)); subplot(3,1,3); plot(tt,chdata);
disp(['missing data elements  ' num2str(round(((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata)) ])
disp(['missing data length (s)  ' num2str(round(((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata))/32000)) ])




chdata=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da5/2016-08-12/rawChannel_24.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da5/2016-08-12/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;
figure; subplot(3,1,1); plot(diff(tsdata)); subplot(3,1,2); plot((tsdata)); subplot(3,1,3); plot(tt,chdata);
disp(['missing data elements  ' num2str(round(((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata)) ])
disp(['missing data length (s)  ' num2str(round(((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata))/32000)) ])


chdata=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da5/2016-12-13/rawChannel_24.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da5/2016-12-13/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;
figure; subplot(3,1,1); plot(diff(tsdata)); subplot(3,1,2); plot((tsdata)); subplot(3,1,3); plot(tt,chdata);
disp(['missing data elements  ' num2str(round(((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata)) ])
disp(['missing data length (s)  ' num2str(round(((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata))/32000)) ])


chdata=loadCExtractedNrdChannelData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da5/2016-12-15/rawChannel_24.dat');
tsdata=loadCExtractedNrdTimestampData('/Users/andrewhowe/data/sampleData/sampleRawNlxNrd/da5/2016-12-15/timestamps.dat');
tt=(tsdata-tsdata(1))/1e6;
figure; subplot(3,1,1); plot(diff(tsdata)); subplot(3,1,2); plot((tsdata)); subplot(3,1,3); plot(tt,chdata);
disp(['missing data elements  ' num2str(round(((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata)) ])
disp(['missing data length (s)  ' num2str(round(((((tsdata(end)-tsdata(1))/1e6)*32000)-length(chdata))/32000)) ])
