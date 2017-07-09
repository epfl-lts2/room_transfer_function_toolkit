function [ u, t, duration, sampling_frequency, moment_stop_signal ] = ...
    get_test_signal(signal_number)

sampling_frequency = 44100;          % microphone (44.1 kHz)
sampling_period = 1/sampling_frequency;

% all signals are of type: 1s silence + 10s sound + 10s silence        
SILENCE1_DURATION = 1;               % [s]
SOUND_DURATION = 10;                 % [s]
SILENCE2_DURATION = 10;              % [s]
moment_stop_signal = SILENCE1_DURATION + SOUND_DURATION;
duration = SILENCE1_DURATION+SOUND_DURATION+SILENCE2_DURATION;

t = 0:sampling_period:SOUND_DURATION;
MIN_SIGNAL_NUMBER = 0;
MAX_SIGNAL_NUMBER = 2;

switch(signal_number)
    case 0  % combination of sine signals
        % resonant frequencies below 100 for the given room
        res_frequency = [20.8589, 41.7178, 43.5897, 48.3235, 50.7463, ...
            54.8660, 60.3361, 62.5767, 65.6929, 66.8973, 70.0738, ...
            76.2621, 78.8392, 80.5669, 87.1795, 89.6402, 91.6029, ...
            96.6470, 100.8734];
        A = [100 200 300 400];
        u = zeros(sampling_frequency*SOUND_DURATION+1,1);
        for i = 1:length(A)            
            [y,t] = gensig('sin',1/res_frequency(i),...
                SOUND_DURATION,sampling_period);
            u = u + A(i)*y;
        end
    case 1  % white noise 
        res_frequency = 21;
        [u,t] = gensig('sin',1/res_frequency,...
                SOUND_DURATION,sampling_period);
        SNR = -30; u = awgn(u, SNR);
    case 2  % freqsweep
        INPUT_SIGNAL_FREQUENCY = 50;            % will be the max frequency
        max_frequency = INPUT_SIGNAL_FREQUENCY; % Nyquist
        min_frequency = 0;      
        u = chirp(t, min_frequency, SOUND_DURATION, max_frequency); 
        u = u';
    case 3 % music
        [y, Fs] = audioread('music/test_song_2.flac');
        u = y(1:Fs*SOUND_DURATION,2);
    otherwise
        sprintf('Signal with the given number does not exist')
        msgID = 'MYFUN:incorrectSignalNumber';
        msg = sprintf('Return to config.m and readjust it to: %d-%d', ...
            MIN_SIGNAL_NUMBER, MAX_SIGNAL_NUMBER);
        wrongNumberException = MException(msgID,msg);
        throw(wrongNumberException);
end

u = u(2:length(u));
u = [zeros(SILENCE1_DURATION*sampling_frequency,1); u; ...
     zeros(SILENCE2_DURATION*sampling_frequency,1)];
t = 0:(t(2)-t(1)):(length(u)-1)*(t(2)-t(1));
end