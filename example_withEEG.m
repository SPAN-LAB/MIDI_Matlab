%% Clear everything
clear;clc
%%

mididevice_idx =2;      % Index of midi input device
audiodevice_idx = 3;    % Index of audio input    
fs = 48000;           % Sampling rate for recording audio
bit_resolution = 16;    % Bit resolution for the audio recording
record_time = 10;   % recording duration in seconds
EEG_sr = 4096; % for speedmode 5
recordlen = record_time*EEG_sr;
%% instantiate the library
disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
%     result = lsl_resolve_byprop(lib,'type','EEG'); end
    result = lsl_resolve_bypred(lib,'name=''BioSemi'''); end

% create a new inlet
disp('Opening an inlet...');
tic
inlet = lsl_inlet(result{1});
[chunk,stamps] = inlet.pull_chunk();
disp('Now receiving data...');
[recorder, device, audioinfo] = fun_midiaudio_start(mididevice_idx, audiodevice_idx, fs, bit_resolution, record_time);
t1 = toc;

  [chunk,stamps] = inlet.pull_chunk();

 pause(record_time)
tic
[aud, msgs,onset_stamps,notenum, device, recorder] = fun_midiaudio_end(device, recorder);
t2 = toc;
clear device

  [chunk,stamps] = inlet.pull_chunk();

%% extracting audio from EEG
tmp_chunk = aud;
tmp_chunk = (tmp_chunk)/max(abs(tmp_chunk));
time_epoch =(1:length(tmp_chunk))*(1/fs);
figure;
hold on
plot(time_epoch,tmp_chunk)

onset_stamps_tmp = onset_stamps;
for i= 1:length(onset_stamps_tmp)
        line([onset_stamps_tmp(i) onset_stamps_tmp(i)], [-1 1]*1, 'Color', 'k', 'LineWidth', 2, 'LineStyle', ':')
        text(onset_stamps_tmp(i), 1, num2str(notenum(i)))
end

%% extracting audio from EEG

del = finddelay(resample(aud, 4096,fs),tmp_chunk);
  x = stamps-stamps(1)%+t1;%+t2;
%x = stamps-stamps(1)-(del/4096)-t1;

tmp_chunk = chunk(142,:)';
figure;
hold on
plot(x,tmp_chunk)

onset_stamps_tmp = onset_stamps;
for i= 1:length(onset_stamps_tmp)
        line([onset_stamps_tmp(i) onset_stamps_tmp(i)], [-1 1]*1e5, 'Color', 'k', 'LineWidth', 2, 'LineStyle', ':')
        text(onset_stamps_tmp(i), 1, num2str(notenum(i)))
end
title('EEG-audio')
%% segmented audio

tmpaud = []; 
notelength = 0.5; % length of note in seconds
notelength_idx = notelength*EEG_sr;
for i =1:length(onset_stamps)
    [~,idx] = min(abs(x-onset_stamps(i)));
    if idx+notelength_idx>length(aud)
        continue
    end
    tmpaud(:,i) = tmp_chunk(idx:idx+notelength_idx-1);
end

time_epoch = (1:notelength_idx)*(1/EEG_sr);

tmpaud = zscore(tmpaud, [],1);

figure;plot(time_epoch*1000, tmpaud)

xlabel('time in ms')
