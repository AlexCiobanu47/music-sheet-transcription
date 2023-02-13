function Fr = rounder(Fx,F)

% F = [262, 277, 294, 311, 330, 349, 370, 392, 415, 440, 466, 494, 523, ...
%     554, 587, 622, 659, 698, 740, 784, 831, 880, 932, 988, 1047];

Fr = zeros(1,length(Fx)); % initializare vector cu 0

% cautam intervalul de frecvente in care se afla Fx

for i = 1 : length(Fx)
    
    if Fx(i) > 0 
        for j = 1 : length(F)
            if Fx(i) < F(j)
                break   
            end
        end
       % disp(j)
    
        if j == 1 
            Fr(i) = F(1);
        else 
            err_inf = abs(F(j-1) - Fx(i));  % se verifica ce valoare din interval e mai aproape de Fx(i)
            err_sup = abs(F(j) - Fx(i));
            if err_inf <= err_sup
                Fr(i) = F(j-1);
            else
                Fr(i) = F(j);
            end
        end
    else 
         Fr(i) = 0;
    end
    
end

end