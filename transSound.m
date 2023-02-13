function [F_peaks,A_peaks] = transSound(x_frm,ENGINE,Fs,F,SIL_THRESH,PEAK_THRESH,varargin)

[M,N] = size(x_frm); %dimensiuni matrice x_frm -> MxN, fiecare linie este un cadru -> M cadre a cate N esantioane
F_peaks = zeros(1,M); %initializare vectori cu M zerouri, fiecare element din vectori reprezentand frecventa, respectiv amplitudinea cadrului
A_peaks = zeros(1,M);

if nargin == 6
        if strcmp(ENGINE, 'autoCorr')
            for i = 1:M
                currentPow = getPow(x_frm(i,:)); %calcul putere
                if currentPow > SIL_THRESH
                    autoCorr=xcorr(x_frm(i,:)); %calcul autocorelatie
                    %autocorelatie -> 2N-1 esantioane
                    %simetrica fata de N
                    PKS_MAX = autoCorr(N); %maximul autocorelatiei este atunci cand ssemnalul intarziat si cel original se suprapun
                    [PKS,LOCS] = findpeaks(autoCorr(N-1:2*N-1),'MinPeakHeight', 0.3*PKS_MAX,'MinPeakDistance', 14); % vector cu varfuri si indexul la care este fiecare varf( amplitudine >= 0.3*PKS_MAX si index >= 14)
                    if (PKS(2)>PEAK_THRESH) %PKS(1) este autocorelatia maxima
                        F_peaks(i) = Fs/(LOCS(2)-2);
                        A_peaks(i) = PKS(2);
                    end                  
                end
             end
            F_peaks = rounder(F_peaks , F);
         end
        if strcmp(ENGINE, 'PSD')
                for i = 1:M
                    currentPow = getPow(x_frm(i,:)); %calcul putere
                    if currentPow > SIL_THRESH
                        Sxx = (abs(fft(x_frm(i,:))).^2)/N;  %calcul periodgrama
                        Sxx = Sxx(1:end/2); %doar prima jumatate
                        resolution=Fs/N; %rezolutia
                        F_initial=F(1); %prima frecventa care ne intereseaza este prima frecventa din vectorul F; 
                        F_final=F(end); %ultima frecventa care ne intereseaza este ultima frecventa din vectorul F;
                                        %[F_initial, F_final] = ambitusul
                        initial_index=floor(F_initial/resolution); % primul index care ne intereseaza, corespunzator frecventei F_initial
                        final_index=floor(F_final/resolution); % ultimul index care ne intereseaza, corespunzator frecventei F_final
                        Sxx_=Sxx(initial_index+1:final_index+1); %doar partea din periodgrama care ne intereseaza (un zoom la inceput)
                        PKS_MAX = max(Sxx_); %maximul periodgramei
                        [PKS,LOCS] = findpeaks(Sxx_,'MINPEAKHEIGHT', 0.99*PKS_MAX); %folosit doar pentru a afla indexul la care este maximul
                        real_index=LOCS+initial_index;
    
                        real_freq=(real_index-1)*Fs/N; %transformare din index in frecventa
    
                        if PKS(end) > PEAK_THRESH %verificare conditie de prag si adaugare in vectorii F_peaks si A_peaks
                           F_peaks(i) = real_freq(end);
                           A_peaks(i) = PKS(end);
                        end    
                    end
                end
            F_peaks = rounder(F_peaks , F);
        end
elseif nargin == 7
        if strcmp(ENGINE, 'crossCorrSbank') || strcmp(ENGINE, 'crossCorrWbank')
            xBank = varargin{1};
            M_xBank = size(xBank,1);
            for i = 1:M
                currentPow = getPow(x_frm(i,:)); %calcul putere
                if currentPow > SIL_THRESH
                    for j = 1:M_xBank
                        xcorrMax(j) = max(xcorr(x_frm(i,:),xBank(j,:))); %calculul maximelor intercorelatiei intre cadrul curent si xBank
                    end
                    [A_max, F_max] = max(xcorrMax); %maximul vectorului in care sunt stocate valorile maxime ale intercorelatiei
                    if (A_max>PEAK_THRESH)
                        F_peaks(i) = F(F_max);
                        A_peaks(i) = A_max;
                    end
                end
            end
        end
        
else
    frintf("Wrong number of arguments");
end
end