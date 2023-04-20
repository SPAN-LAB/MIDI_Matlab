
%% Script to record and save audio files from MIDI file onl;y single notes supported



%% input note param
clear; clc
input_note = {{'C4','G4'}, {'C4', 'B4'}, {'C4', 'F#4'}};

tbl = readtable('MIDI note value.xlsx');
clc

outdir = 'MIDI_audio/';
if ~exist('outdir', 'dir'), mkdir(outdir), end

for i =1:length(input_note)
x = generate_MIDI_notes(input_note{i}, tbl, outdir);
    
end

%% Function



% 
function x = generate_MIDI_notes(input_note,tbl, outdir)


%%
% settting up MIDI and parameters
mididevice_idx =4;      % Index of midi input device
audiodevice_idx = 3;    % Index of audio input    
fs = 48000;           % Sampling rate for recording audio
bit_resolution = 16;    % Bit resolution for the audio recording
record_time = 1;   % recording duration in seconds


audioinfo = audiodevinfo;
 
recorder = audiorecorder(fs, bit_resolution, 1, audioinfo.input(audiodevice_idx).ID);

midi_device = mididevinfo;


midi_device = mididevinfo;

device = mididevice(midi_device.output(mididevice_idx).ID);
% Loading a template midi message

load sample_midimsg.mat
orig_msgs = msgs;

%
%% getting the notenumber from the note name

notenames = tbl.Note;

sel_note_idx = find(ismember(notenames, input_note));
sel_note_num = tbl.MIDIValue(sel_note_idx);

%% Editing the template MIDI message -Extremely hard coded for two notes
tmp_msgs = msgs;

tmp_msgs(1).Note  = sel_note_num(1);
tmp_msgs(2).Note  = sel_note_num(1);

tmp_msgs(1).Timestamp  = 0.;
tmp_msgs(2).Timestamp  = record_time;


tmp_msgs(3) = tmp_msgs(1);
tmp_msgs(4) = tmp_msgs(2);
tmp_msgs(3).Note  = sel_note_num(2);
tmp_msgs(4).Note  = sel_note_num(2);




tmp_msgs(3).Timestamp  = 1;
tmp_msgs(4).Timestamp  = 1+record_time;

%%
record(recorder, 4*record_time)
pause(1*record_time)

midisend(device, tmp_msgs)

pause(4*record_time)
stop(recorder)
disp('Played sound')


%%
aud = getaudiodata(recorder);

t = (1:length(aud))*(1/fs);
figure;plot(t,aud)
%% trim audio
aud_cut_st = 1;
aud_cut_en = 3.5;

[~,aud_cut_st_idx] = min(abs(t-aud_cut_st));
[~,aud_cut_en_idx] = min(abs(t-aud_cut_en));

aud = aud(aud_cut_st_idx:aud_cut_en_idx);
t = t(aud_cut_st_idx:aud_cut_en_idx) - aud_cut_st;
figure;plot(t,aud)

%% Write audio

output_note = strjoin(input_note, '_');
output_note = strrep(output_note, '#', 'sharp');
outname = fullfile(outdir, [output_note, 'consecutive.wav']);

audiowrite(outname, aud, fs)
x = 'done';
end


