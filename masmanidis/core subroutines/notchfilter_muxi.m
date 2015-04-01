Fs = samplingrate; % sampling freq [Hz] 
Fn = Fs/2; % Nyquist freq [Hz] 

W0 = 60; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 3; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,datach); 

W0 = 120; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 3; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,y); 

W0 = 148; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 20; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,y); 

W0 = 180; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 3; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,y); 

W0 = 190; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 3; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,y); 

W0 = 240; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 3; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,y); 

W0 = 297; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 25; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,y); 

W0 = 440; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 10; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,y); 

W0 = 610; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 3; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,y); 

W0 = 1220; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 3; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,y); 

W0 = 1829; % notch frequency [Hz] 
w0 = W0*pi/Fn; % notch frequency normalized 
BandWidth = 3; % -3dB BandWidth [Hz] 
B = BandWidth*pi/Fn; % normalized bandwidth 
k1 = -cos(w0); k2 = (1 - tan(B/2))/(1 + tan(B/2)); 
b = [1+k2 2*k1*(1+k2) 1+k2]; 
a = [2 2*k1*(1+k2) 2*k2];  
y=filter(b,a,y); 

datach=y;