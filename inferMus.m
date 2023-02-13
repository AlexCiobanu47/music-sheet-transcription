function [F_vect,D_vect] = inferMus(F_peaks, A_peaks,REP_THRESH)

F_vect=[];
D_vect=[];
note_duration=1;
for  i=2:length(F_peaks)
    last_ampl=A_peaks(i-1);
    last_freq=F_peaks(i-1);
    if  ((last_freq==F_peaks(i))&& (A_peaks(i)<=REP_THRESH*last_ampl))
        %nota cantata anterior se continua
        note_duration=note_duration+1;
    
    else
        %alta nota este cantata sau aceeasi este repetata
        F_vect=[F_vect, last_freq];
        D_vect=[D_vect, note_duration];
        note_duration=1;    
    end
end

F_vect=[F_vect, F_peaks(length(F_peaks))];
D_vect=[D_vect, note_duration];

end