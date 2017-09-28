cell_struct.placeAccepted = [];
cell_struct.brainArea = [];
cell_struct().placeCandidate = [];
cell_struct().placeAccepted = [];
cell_struct().brainArea = [];
cell_struct = rmfield(cell_struct, 'isCandidate');
cell_struct().thetaClocks = [{}];
cell_struct().maxRate = [];
cell_struct().meanRate = [];
cell_struct().medianRate = [];
cell_struct().stdRate = [];
cell_struct().madamRate = [];
cell_struct_placetest
[~,index] = sortrows({cell_struct.rat}.'); cell_struct = cell_struct(index(end:-1:1)); clear index
[~,index] = sortrows({cell_struct.rat}.'); cell_struct = cell_struct(index); clear index
cell_struct(5).placeCandidate = b;
[~,index] = sortrows([cell_struct.cid].'); cell_struct = cell_struct(index(end:-1:1)); clear index
[~,index] = sortrows([cell_struct.spinfo].'); cell_struct = cell_struct(index(end:-1:1)); clear index
cell_struct = rmfield(cell_struct, 'date');
cell_struct(1) = [];
for rcd=1:length(cell_struct)
temp = regexp(cell_struct(rcd).name,'tt[0-9]+_c[0-9]+_[0-9]+_(?<brainRegion>[a-zA-Z0-9]+).mat','names');
cell_struct(rcd).brainRegion = temp.brainRegion;
end
repeats=[];
for qcd=1:length(cell_struct)-1
for rcd=2:length(cell_struct)
if (cell_struct(qcd).cid == cell_struct(rcd).cid ) && ( cell_struct(qcd).spinfo == cell_struct(rcd).spinfo )
repeats=[repeats rcd];
end
end
end
size(repeats)
size(unique(repeats))
repeats=[];
for qcd=1:length(cell_struct)-1
for rcd=qcd+1:length(cell_struct)
if (cell_struct(qcd).cid == cell_struct(rcd).cid ) && ( cell_struct(qcd).spinfo == cell_struct(rcd).spinfo )
repeats=[repeats rcd];
end
end
end
size(repeats)
repeats'
repeats
cell_struct(19) = [];
cell_struct(54) = [];
cell_struct(101) = [];
cell_struct(1352) = [];
cell_struct(1200) = [];
repeats=[];
for qcd=1:length(cell_struct)-1
for rcd=qcd+1:length(cell_struct)
if (cell_struct(qcd).cid == cell_struct(rcd).cid ) && ( cell_struct(qcd).spinfo == cell_struct(rcd).spinfo )
repeats=[repeats rcd];
end
end
end
repeats
cell_struct(1493) = [];
cell_struct(1482) = [];
cell_struct(1481).brainRegion = 'MS/LSI';
cell_struct(1465) = [];
cell_struct(1464).brainRegion = 'MS/LS';
cell_struct(1420) = [];
cell_struct(1420).brainRegion = 'LS/Ld';
cell_struct(1367) = [];
cell_struct(1367).brainRegion = 'DG/Ld';
cell_struct(1356) = [];
cell_struct(1356).brainRegion = 'LSI/Ld';
cell_struct(1333) = [];
cell_struct(1332).brainRegion = 'MS/Ld';
cell_struct(1326) = [];
cell_struct(1326).brainRegion = 'MS/SHi';
cell_struct(1293) = [];
cell_struct(1292).brainRegion = 'MS/IG';
cell_struct(1293) = [];
cell_struct(1104) = [];
cell_struct(1104).brainRegion = 'DG/Ld';
cell_struct(1063) = [];
cell_struct(1063).brainRegion = 'DG/SHi';
repeats=[];
for qcd=1:length(cell_struct)-1
for rcd=qcd+1:length(cell_struct)
if (cell_struct(qcd).cid == cell_struct(rcd).cid ) && ( cell_struct(qcd).spinfo == cell_struct(rcd).spinfo )
repeats=[repeats rcd];
end
end
end
for ii=1:length(repeats)
cell_struct(repeats(ii)-1).brainRegion = [cell_struct(repeats(ii)-1).brainRegion '/' cell_struct(repeats(ii)).brainRegion];
cell_struct(repeats(ii)) = [];
end
cell_struct = rmfield(cell_struct, 'brainArea');
strsplit(cell_struct(1).sess,'_')
temp=strsplit(cell_struct(1).sess, '_');
temp
temp(1)
temp=strsplit(cell_struct(2).sess, '_');
temp
for rcd=1:length(cell_struct)
temp = regexp(cell_struct(rcd).rat,'[a-zA-Z]+(?<ratNum>[0-9]+)','names');
cell_struct(rcd).ratNumber = temp.ratNum;
temp = strsplit( cell_struct(rcd).sess, '_' )
if ( length(temp) > 1 )
cell_struct(rcd).recordingDay = temp(2);
end
if ( length(temp) > 2 )
cell_struct(rcd).recordingCondition = temp(3);
end
end
[~,index] = sortrows([cell_struct.placeCandidate].'); cell_struct = cell_struct(index(end:-1:1)); clear index
op=ttempp{1}.daynum
ttempp{1}.daynum
size(op)
for rcd=1:length(cell_struct)
temp = regexp(cell_struct(rcd).rat,'[a-zA-Z]+(?<ratNum>[0-9]+)','names');
cell_struct(rcd).ratNumber = str2num(temp.ratNum);
temp = strsplit( cell_struct(rcd).sess, '_' );
if ( length(temp) > 1 )
ttempp = regexp( temp(2), '[A-Za-z]+(?<daynum>[0-9]+)','names');
op = ttempp{1}.daynum;
cell_struct(rcd).recordingDay = str2num(op);
end
if ( length(temp) > 2 )
cell_struct(rcd).recordingCondition = temp(3);
end
end
header