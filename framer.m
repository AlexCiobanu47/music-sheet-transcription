function x_frm = framer(x,Tw,Fs)

%lungimea unui cadru (in esantioane)
L = Tw * Fs;

R = mod(length(x), L);
Q = floor(length(x)./L);

if R ~= 0
    % daca nu se poate imparti exact in N esantioane, se adauga zerouri la semnalul de intrare si se imparte in N+1 esantioane
    N = Q + 1; 
    x = [x,zeros(1,L-R)];                
else
    N = Q;
end

x_frm = reshape(x,L,N); %Fiecare coloana reprezinta un cadru disjunct

x_frm = x_frm'; %transpusa matricei; fiecare linie reprezinta un cadru disjunct

end