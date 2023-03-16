%% This MIDI script works for recording and MIDI and audio simultaneously
% We aere using two presonus audioboxes for this. One audiobox receives
% MIDI inputs while the other recieves audio inputs. 
% This script has to be integrated with the LSL biosemi acuisition to
% record cortical potentials to Musical stimuli


%% Record audio and MIDI simultaneously
record_time = 15;
availableDevices = mididevinfo;
info = audiodevinfo;
tic 

recorder = audiorecorder(44100, 16, 1, info.input(2).ID);
record(recorder, record_time)
device = mididevice(availableDevices.input(1).ID);
pause(record_time)
aud_offset = toc;
msgs = midireceive(device)
midi_offset = toc;

clear device
play(recorder)
%%
aud = getaudiodata(recorder);
aud = aud/(max(abs(aud)));
t =(1:length(aud))*(1/44100);
figure;plot(t, aud)

timestamp = []; onset_stamps = [];n =1;
hold on
for i= 1:length(msgs)
    timestamp(i) = msgs(i).Timestamp;
    if strcmp(msgs(i).Type, 'NoteOn')
        line([timestamp(i) timestamp(i)], [-1 1], 'Color', 'k', 'LineWidth', 2, 'LineStyle', ':')
        onset_stamps(n) = timestamp(i);
        n=n+1;
    end
end
% plot(timestamp, zeros(length(timestamp),1), 'rx', 'MarkerSize', 20)

% plot(aud_offset+timestamp, zeros(length(timestamp),1), 'rx', 'MarkerSize', 20)
% xlim([0 2.5])
%% Segment audio using MIDI timestamps

tmpaud = []; 
notelength = 0.3; % length of note in seconds
notelength_idx = notelength*44100;
for i =1:length(onset_stamps)
    [~,idx] = min(abs(t-onset_stamps(i)));
    tmpaud(:,i) = aud(idx:idx+notelength_idx-1);
end

time_epoch = (1:notelength_idx)*(1/44100);

tmpaud = zscore(tmpaud, [],1);

figure;plot(time_epoch, tmpaud)

