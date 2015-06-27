function [ fMAG,i ] = numberofpeaks( MAG,rate)


    [pks,locs] = findpeaks(mdnflter(double(MAG)));

    
    i=0;
    fMAG=[];
    while i< locs(length(locs))
    % while i<= length(T)
        fMAG=[fMAG length(locs(locs>=i & locs<=i+rate))];
        i=i+rate;

    end
    


end

