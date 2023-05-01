function [aud, msgs,onset_stamps,notenum, device, recorder] = fun_midiaudio_end(device, recorder)
%% Inputs
% device -> MIDI device from mididevice(availableDevices.input(1).ID);
% recorder -> audio recorder from audiorecorder(fs, bit_resolution, 1, audioinfo.input(2).ID);


%%
msgs = midireceive(device);
% midi_offset = toc;

% clear device
% play(recorder)
stop(recorder)
%%
fs = recorder.SampleRate;
aud = getaudiodata(recorder);
aud = aud/(max(abs(aud)));
t =(1:length(aud))*(1/fs);
% figure;plot(t, aud)

timestamp = []; onset_stamps = [];n =1; notenum =[];
% hold on
for i= 1:length(msgs)
    timestamp(i) = msgs(i).Timestamp;
    if strcmp(msgs(i).Type, 'NoteOn')
%         line([timestamp(i) timestamp(i)], [-1 1], 'Color', 'k', 'LineWidth', 2, 'LineStyle', ':')
        onset_stamps(n) = timestamp(i);
        notenum(n) = msgs(i).Note;
        n=n+1;
    end
end

device = device;
recorder = recorder;