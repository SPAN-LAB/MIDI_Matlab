clc;clear

%%
% audiodevice_details
% mididevice_details
subname = 'NIke';

%% Create folders


if ~exist(subname, 'dir')
    mkdir(subname)
end
%% start audio and midi recording 


mididevice_idx =2;      % Index of midi input device
audiodevice_idx = 3;    % Index of audio input    
fs = 48000;           % Sampling rate for recording audio
bit_resolution = 16;    % Bit resolution for the audio recording
record_time = input('Enter the number of seconds to record = ');   % recording duration in seconds
cond_name = input('Enter the condition name  = ', 's');


[recorder, device, audioinfo] = fun_midiaudio_start(mididevice_idx, audiodevice_idx, fs, bit_resolution, record_time);
pause(record_time)
[aud, msgs,onset_stamps,notenum, device, recorder] = fun_midiaudio_end(device, recorder);
clear device
%% plotting
t = (1:length(aud))*(1/fs);
figure('Units', 'inches', 'Color', 'w');
hold on
plot(t,aud)
for i= 1:length(onset_stamps)
        line([onset_stamps(i) onset_stamps(i)], [-1 1], 'Color', 'k', 'LineWidth', 2, 'LineStyle', ':')
        text(onset_stamps(i), 1, num2str(notenum(i)))
end

xlabel('time in seconds')
ylabel('Amplitude a.u')


audiowrite('audio.wav', aud,fs)
%% plotting segmented info


tmpaud = []; 
notelength = 1; % length of note in seconds
notelength_idx = notelength*fs;
for i =1:length(onset_stamps)
    [~,idx] = min(abs(t-onset_stamps(i)));
    if idx+notelength_idx>length(aud)
        continue
    end
    tmpaud(:,i) = aud(idx:idx+notelength_idx-1);
end

time_epoch = (1:notelength_idx)*(1/fs);

tmpaud = zscore(tmpaud, [],1);

figure;plot(time_epoch*1000, tmpaud)

xlabel('time in ms')


%% Save variables to workspace
save(fullfile(subname, cond_name))
%%

