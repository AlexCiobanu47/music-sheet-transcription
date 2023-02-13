function xBank = buildBank(Tw,Fs,varargin)

switch nargin
    case 3
        %metoda III - se construiesc semnalele sinusoidale cu frecventa F
        F = varargin{1};
        t = 0:1/Fs:Tw;      %se face semnalul cat un cadru Tw
        for i = 1:length(F)
           xBank(i,:) = sin(2*pi*t*F(i));
           %adaugam elemente in matricea xBank, linie cu linie
        end
    case 5
        %metoda II - se construieste baza de date cu inregistrari din
        %folderul soundbank

        Tseg = varargin{1};
        SIL_THRESH = varargin{2};

        file_list = ls('./soundbank');
        
        switch varargin{3}      %xBank = buildBank(Tw, Fs, Tseg, [SIL_THRESH_11, SIL_THRESH_12], crt_file(6));
            case '1'
                %chitara acustica
                files = file_list(3:27,:);
            case '2'
                %flautul drept
                files = file_list(28:52,:);  
            case '3'
                %vioara
                files = file_list(103:127,:);       
            case '4'
                %pian
                files = file_list(53:77,:);  
            case '5'
                %vibrafon
                files = file_list(78:102,:);  
            otherwise
                disp("Invalid value for Y.");
        end
        
        for i = 1:length(files)
            current_file_name = strcat('./soundbank/',files(i,:));
            [y,Fs_] = audioread(current_file_name);
            %pre procesarea fiecarui fisier
            y = preProc(y,Fs_,Fs,Tseg,SIL_THRESH); 
            L = Tw * Fs; %esantioane intr-un cadru
            y = y(1:L);%cadru de semnal
            
            xBank(i,:) = y;
        end
        
    otherwise
        disp("The number of input arguments is incorrect.");
end


end