function [ chewCrunchEnv, chewCrunchEnvTimes, envSampleRate ] = boxcarMaxFilter( avgChew, timestampSeconds )
%
% yet another half-baked function
%
% the goal here is to take a profile of a signal which is quiet, except for
% fairly large rhythmic bursts that occur. these bursts appear in xcorr but
% are not obvious in the envelope (possibly because the sample rate is too
% high, or the frequency mix is too wide). the function was concocted by
% looking at examples of the signal for detection and determining through
% experimentation a method and a set of parameters that works for the
% situation. the boxcar is smaller than the burst event. Further signal
% processing enables the user to identify episodes with rhythmic bursts
% using this psuedo-envelope.
%
%
% == "MAX FILTER" OF CHEWING-FILTERED AVERAGE LFP ==
% TODO could be a function
inputElements = length(avgChew);
sampleRate = 32000;
halfWindowSize = 250; % elements
overlapSize = 100;    % elements -- smoother when one does all the points (so like 499 overlap), but longer
jumpSize=(2*halfWindowSize+1) - overlapSize ;
outputPoints = ceil( ( inputElements - 2*halfWindowSize ) / ( (2*halfWindowSize+1) - overlapSize ) ) ;
chewCrunchEnv = zeros(1,outputPoints);
chewCrunchEnvTimes = zeros(1,outputPoints);
envSampleRate=sampleRate/jumpSize;
outputIdx = 1;
for ii=halfWindowSize+1:jumpSize:inputElements-250
    chewCrunchEnv(outputIdx)=max(abs(avgChew(ii-halfWindowSize:ii+halfWindowSize)));
    chewCrunchEnvTimes(outputIdx) = timestampSeconds(ii);
    outputIdx = outputIdx + 1;
end