# Automatic music sheet transcription in MATLAB

The program consists of 3 methods of signal processing(autocorrelation. intercorrelation and power spectral distribution). The intercorrelation is calculated with a wave bank built in MATLAB and a sound bank of instrument recordings.

Functions:
- getPow(): 
  - calculates the power of the input signal

- preProc()
  - converts the signal from stereo to mono
  - resamples the signal
  - normalizes the amplitude in [-1, 1] range
  - removes the silence sections in the beggining and the end
  
- framer():
  - divides the input signal in disjunct frames
  
- buildBank():
  - builds the wave bank and the sound bank for the intercorrelation method
  
- rounder():
  - roundes the input frequencies to the reference fundamental frequency of the music notes
  
- transSound():
  - checks if the current frame is a pause
   - calculates the autocorrelation/intercorrelation of the current frame with the reference database/power spectral distribution of the current frame
   - finds the maximum value of the autocorrelation/finds the maximum value of the intercorrelation for each combination of signals and then finds the maximum of these maximums/finds the first spectral peak
   - checks if the current frame is a pause
    - converts the fundamental frequencies with the rounder function
  
- inferMus():
  - checks for repeated or sustained music notes 
