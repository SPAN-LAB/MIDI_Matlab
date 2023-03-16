% mididevice_details

midi_device = mididevinfo;
input_len = length(midi_device.input);
output_len = length(midi_device.output);
tbl_input =table();
for i =1:input_len
    x = midi_device.input(i);

    fieldnames = fields(x);
    fieldnums = length(fieldnames);
    tbl_input.mididevice_idx{i} = i;
    for field_ind = 1:fieldnums
        eval(['tbl_input.',fieldnames{field_ind}, '{',num2str(i), '}' '=', 'x.', fieldnames{field_ind},';'] );
    end
end

%
tbl_output =table();
for i =1:output_len
%     midi_device.output(i);

    x = midi_device.output(i);

    tbl_output.mididevice_idx{i} = i;

    fieldnames = fields(x);
    fieldnums = length(fieldnames);
    for field_ind = 1:fieldnums
        eval(['tbl_output.',fieldnames{field_ind}, '{',num2str(i), '}' '=', 'x.', fieldnames{field_ind},';']);
    end
end

clc

tbl_input
tbl_output

