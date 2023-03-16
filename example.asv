clc;clear

%%
audiodevice_details
mididevice_details

%% start audio and midi recording 
mididevice_idx =2;
audiodevice_idx = 2;
fs = 48000;
bit_resolution = 16;
record_time = 5; 



 [recorder, device, audioinfo] = fun_midiaudio_start(mididevice_idx, audiodevice_idx, fs, bit_resolution, record_time);
pause(record_time)
[aud, msgs,onset_stamps,notenum, device, recorder] = fun_midiaudio_end(device, recorder)
clear device
%%
t = (1:length(aud))*(1/fs);
figure;
hold on
plot(t,aud)
for i= 1:length(onset_stamps)

        line([onset_stamps(i) onset_stamps(i)], [-1 1], 'Color', 'k', 'LineWidth', 2, 'LineStyle', ':')

end

title('time in seconds')
