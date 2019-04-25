function vidTime(timesec)
    minutes = floor(timesec/60);
    hours   = floor(minutes/60);
    minutes = mod(minutes,60);
    seconds = mod(timesec,60);
    disp( [ num2str(hours) ':' num2str(minutes) ':' num2str(seconds) ]);
end