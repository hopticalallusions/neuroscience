%***Set parameters*****************

minstopduration=0.25;    %s
minrunduration=0.25;  %s
maxrestvel=0.005;  %m/s
minrunvel=0.005;   %m/s
%***********************************



velocityinds=(minstopduration*velocitysamplingrate+1):1:(length(vy)-(minstopduration*velocitysamplingrate));
run_starttimes=[]; run_stoptimes=[]; previous='r';
for velind=velocityinds;
    t0=velind;
    ti=t0-minstopduration*velocitysamplingrate;
    tf=t0+minrunduration*velocitysamplingrate;
    if max(abs(vy(ti:(t0-1))))<maxrestvel & min(vy(t0:tf))>minrunvel & previous=='s'
        run_starttimes=[run_starttimes velind/velocitysamplingrate];
        previous='r';
    elseif max(abs(vy(ti:(t0-1))))<maxrestvel & previous=='r'
        run_stoptimes=[run_stoptimes velind/velocitysamplingrate];
        previous='s';
    end
end
if min(run_stoptimes)<min(run_starttimes)
run_stoptimes(1)=[];
end
if max(run_stoptimes)<max(run_starttimes);
    run_starttimes(length(run_starttimes))=[];
end






