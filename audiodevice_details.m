% mididevice_details


audiodevice = audiodevinfo;

input_len = length(audiodevice.input);
output_len = length(audiodevice.output);
tbl_input =table();
for i =1:input_len
    x = audiodevice.input(i);

    fieldnames = fields(x);
    fieldnums = length(fieldnames);
    tbl_input.audiodevice_idx{i} = i;
    for field_ind = 1:fieldnums
        eval(['tbl_input.',fieldnames{field_ind}, '{',num2str(i), '}' '=', 'x.', fieldnames{field_ind},';'] );
    end
end

%
tbl_output =table();
for i =1:output_len
%     midi_device.output(i);

    x = audiodevice.output(i);

    tbl_output.audiodevice_idx{i} = i;

    fieldnames = fields(x);
    fieldnums = length(fieldnames);
    for field_ind = 1:fieldnums
        eval(['tbl_output.',fieldnames{field_ind}, '{',num2str(i), '}' '=', 'x.', fieldnames{field_ind},';']);
    end
end

clc

tbl_input
tbl_output

