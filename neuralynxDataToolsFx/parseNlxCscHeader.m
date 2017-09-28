function header = parseNlxCscHeader( header )

%% Parse Header Information (incomplete! but functional)

tt=regexp(strcat(header),'RecordSize\s+(?<RecordSize>[0-9]+)','names')
header.RecordSize=str2num(tt.RecordSize);
tt=regexp(strcat(header),'SamplingFrequency\s+(?<SamplingFrequency>[0-9]+|[0-9]+.[0-9]+)','names')
header.SamplingFrequency=str2num(tt.SamplingFrequency);
tt=regexp(strcat(header),'ADBitVolts\s+(?<ADBitVolts>[0-9]+.[0-9]+)','names')
header.ADBitVolts=str2num(tt.ADBitVolts);
tt=regexp(strcat(header),'DSPLowCutFilterEnabled\s+(?<DSPLowCutFilterEnabled>[A-Za-z]+)','names')
header.DSPLowCutFilterEnabled=tt.DSPLowCutFilterEnabled;
tt=regexp(strcat(header),'DspLowCutFrequency\s+(?<DspLowCutFrequency>[0-9]+)','names')
header.DspLowCutFrequency=str2num(tt.DspLowCutFrequency);
tt=regexp(strcat(header),'DspLowCutNumTaps\s+(?<DspLowCutNumTaps>[0-9]+)','names')
header.DspLowCutNumTaps=str2num(tt.DspLowCutNumTaps);
tt=regexp(strcat(header),'DspLowCutFilterType\s+(?<DspLowCutFilterType>[A-Z]+)','names')
header.DspLowCutFilterType=tt.DspLowCutFilterType;
tt=regexp(strcat(header),'DSPHighCutFilterEnabled\s+(?<DSPHighCutFilterEnabled>[A-Za-z]+)','names')
header.DSPHighCutFilterEnabled=tt.DSPHighCutFilterEnabled;
tt=regexp(strcat(header),'DspHighCutFrequency\s+(?<DspHighCutFrequency>[0-9]+)','names')
header.DspHighCutFrequency=str2num(tt.DspHighCutFrequency);
tt=regexp(strcat(header),'DspHighCutNumTaps\s+(?<DspHighCutNumTaps>[0-9]+)','names')
header.DspHighCutNumTaps=str2num(tt.DspHighCutNumTaps);
tt=regexp(strcat(header),'DspHighCutFilterType\s+(?<DspHighCutFilterType>[A-Z]+)','names')
header.DspHighCutFilterType=tt.DspHighCutFilterType;

end