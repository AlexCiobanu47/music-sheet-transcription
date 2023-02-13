function y = preProc(x,Fs_,Fs,Tseg,SIL_THRESH)

%conversie stereo-mono
x = mean(x');
%reesantionare
[P,Q] = rat(Fs/Fs_);
x = resample(x,P,Q);

%normare
x = x/max(abs(x));

%eliminare sectiuni de liniste
L = Tseg * Fs; %lungime cadru de analiza
power_dB = SIL_THRESH(1);
starting_index = 1; %index de start pentru partea utila din cadru
ending_index = length(x); %index de sfarsit pentru partea utila din cadru
%sectiunea de liniste de la inceput
while power_dB <= SIL_THRESH(1)
    power_dB = getPow(x(starting_index : starting_index + L));
    starting_index = starting_index + 1;
end

power_dB = SIL_THRESH(2);

%sectiunea de liniste de la sfarsit
while power_dB <= SIL_THRESH(2)
    power_dB = getPow(x(ending_index - L : ending_index));
    ending_index = ending_index - 1;
end

y = x(starting_index - 1 : ending_index + 1);

end