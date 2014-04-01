if probetype=='a'   %nano-A geometry, starting witht the channel at the tip and moving up:
channels=[22 43 21 44 23 20 45 42 19 46 24 18 47 41 17 48 25 16 49 40 15 50 26 14 51 39 13 52 27 12 53 38 11 54 28 10 55 37 9 56 29 8 57 36 7 58 30 6 59 35 5 60 31 4 61 34 3 62 32 2 63 33 1 64];  %channels to plot in the order shown here.

elseif probetype=='b'
channels=[17 16 18 15 19 14 20 13 21 12 22 11 23 10 24 9 25 8 26 7 27 6 28 5 29 4 30 3 31 2 32 1 48 49 47 50 46 51 45 52 44 53 43 54 42 55 41 56 40 57 39 58 38 59 37 60 36 61 35 62 34 63 33 64];

elseif probetype=='c'  %nano-C geometry: 
channels=[1 16 2 15 3 14 4 13 5 12 6 11 7 10 8 9  17 32 18 31 19 30 20 29 21 28 22 27 23 26 24 25  33 48 34 47 35 46 36 45 37 44 38 43 39 42 40 41  49 64 50 63 51 62 52 61 53 60 54 59 55 58 56 57]; 
elseif probetype=='n'  %no probe style; channels are numbered 1:64.
channels=[1:64];
end