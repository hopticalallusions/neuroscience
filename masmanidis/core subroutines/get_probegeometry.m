%updated 10/30/12 to include new UCLA probes.

if strcmp(probetype,'probe_64A')
    probe_64A
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_64B')
    probe_64B
     depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_64C')
    probe_64C
    depthzones=[0:40:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_64D')
    probe_64D
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_64E')
    probe_64E
    depthzones=[0:40:4000 10000];      %default=depthzones=[0:40:4000 10000]; units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_64F')
    probe_64F
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_64G')
    probe_64G    
     depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                     %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_128A')
    probe_128A
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.    
elseif strcmp(probetype,'probe_128B')
    probe_128B
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_128C')   %breakable shafts
    probe_128C
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_128D')
    probe_128D
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strfind(probetype,'128E')   %breakable shafts
    probe_128E                         %must specify which 4 of the 8 shafts were used. e.g. probe_128E_3456
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'Chandelier_A')   %breakable shafts
    Chandelier_A
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_128F')
    probe_128F
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_128G')
    probe_128G
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_256A')
    probe_256A
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_256BL')
    probe_256BL
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_256BR')
    probe_256BR
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_256CL')
    probe_256CL
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'probe_256CR')
    probe_256CR
    depthzones=[0:50:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'Gemini_I')
    Gemini_I
    depthzones=[0:40:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'Gemini_II')
    Gemini_II
    depthzones=[0:40:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.
elseif strcmp(probetype,'Titan_I')
    Titan_I
    depthzones=[0:40:4000 10000];      %units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
    zoneoverlap=10;                    %re-use some channels in more than one set to account for overlap of spike EC fields.      
elseif strcmp(probetype,'Titan_I_kB_left_hem')
    Titan_I_kB_left_hem
    depthzones = [0:40:400 10000];
    zoneoverlap = 10;
elseif strcmp(probetype,'Titan_I_kB_right_hem')
    Titan_I_kB_right_hem
    depthzones = [0:40:400 10000];
    zoneoverlap = 10;
elseif strcmp(probetype,'Bacchus_I')    %historical note: developed Mar 5 2014, first 512 ch probe.
    Bacchus_I
    depthzones=[0:50:4000 10000];      
    zoneoverlap=10;                    
end

tipelectrode=s.tipelectrode;
numberofchannels=length(s.channels);
backgroundchans=backgroundchans1;

if strcmp(backgroundchans,'all')==1
    backgroundchans=s.channels;
end

origbackgroundchans=backgroundchans;
