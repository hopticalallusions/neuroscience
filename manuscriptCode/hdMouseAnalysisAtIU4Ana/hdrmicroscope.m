
microscopeFiles = [ ...
%'~/data/histology/da2_export/slide2/view1/20xSliceC1.2o1.tif-0.png        '; ...
%'~/data/histology/da2_export/slide2/view1/20xSliceC1o1.2.tif-0.png        '; ...
'~/data/histology/da2_export/slide2/view1/20xSliceC1o1.7.tif-0.png        '; ...
'~/data/histology/da2_export/slide2/view1/20xSliceC1o12.tif-0.png         '; ...
'~/data/histology/da2_export/slide2/view1/20xSliceC1o2.3.tif-0.png        '; ...
'~/data/histology/da2_export/slide2/view1/20xSliceC1o20.tif-0.png         '; ...
'~/data/histology/da2_export/slide2/view1/20xSliceC1o3.tif-0.png          '; ...
'~/data/histology/da2_export/slide2/view1/20xSliceC1o30.tif-0.png         '; ...
'~/data/histology/da2_export/slide2/view1/20xSliceC1o4.tif-0.png          '; ...
'~/data/histology/da2_export/slide2/view1/20xSliceC1o6.tif-0.png          '];%...

% '~/data/histology/da2_export/slide2/view1/20xSliceCDAPIBlue1o10.tif-0.png '; ...
% '~/data/histology/da2_export/slide2/view1/20xSliceCDAPIBlue1o15.tif-0.png '; ...
% '~/data/histology/da2_export/slide2/view1/20xSliceCDAPIBlue1o25.tif-0.png '; ...
% '~/data/histology/da2_export/slide2/view1/20xSliceCDAPIBlue1o7.5.tif-0.png'; ...
% '~/data/histology/da2_export/slide2/view1/20xSliceCTHRed1o10.tif-0.png    '; ...
% '~/data/histology/da2_export/slide2/view1/20xSliceCTHRed1o15.tif-0.png    '; ...
% '~/data/histology/da2_export/slide2/view1/20xSliceCTHRed1o25.tif-0.png    '; ...
% '~/data/histology/da2_export/slide2/view1/20xSliceCTHRed1o35.tif-0.png    '; ...
% '~/data/histology/da2_export/slide2/view1/20xSliceCTHRed1o5.tif-0.png     '; ...
% '~/data/histology/da2_export/slide2/view1/20xSliceCTHRed1o7.5.tif-0.png   ' ];


microscopeFiles=cellstr(microscopeFiles);
%exposures=[ 1.2/1 1/1.2 1/1.7 1/12 1/2.3 1/20 1/3 1/30 1/4 1/6 1/10 1/15 1/25 1/7.5 1/10 1/15 1/25 1/35 1/5 1/7.5  ];
exposures=[  1/1.7 1/12 1/2.3 1/20 1/3 1/30 1/4 1/6  ];
%exposures=[   1/12 1/20   1/10 1/15   1/10 1/5 1/7.5 ];
hdr = makehdr( microscopeFiles , 'ExposureValues', exposures );
rgb = tonemap(hdr,'AdjustLightness', [0.001 1]);
figure; imshow(rgb)
