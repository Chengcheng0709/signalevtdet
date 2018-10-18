multiple_events_type = 'M3C';
source_dir = '/Users/ccli/Dropbox/EventDetection/DL/Datasets/Signal_Files/';
files = dir(fullfile(source_dir, multiple_events_type, '*.mat'));
num_bus = 5;
Hz = 10;
data_len = 1505;
target_dir = '/Users/ccli/Dropbox/EventDetection/DL/Datasets/ReshapeDataNAnnotation/';
data_dir = fullfile(target_dir, multiple_events_type);
annotation_dir = fullfile(target_dir, [multiple_events_type, 'Annotation']);
events = {'gt', 'lt', 'ls'};
for i = 1:length(files)
    foldername = files(i).folder;
    filename = files(i).name;
    data = importdata(fullfile(foldername, filename));
    filename = filename(1:strfind(filename, '.xlsx')-1);
    ind_list = regexp(filename, 'gt|ls|lt');    
    splits = strsplit(filename, '_');
    trigger_times = [];
    event_types = {};
    for j = 1:length(ind_list)
        trigger_times = [trigger_times str2num(splits{2*j})];
        event_types = [event_types splits{2*j-1}];
    end 
    event_len = data_len/num_bus;
    data_reshape = reshape(data, [event_len, num_bus]);
    data_annotation = zeros([4, event_len]);
    
    for k = 1:length(trigger_times)
        if event_types{k} == 'gt'
            data_annotation(1,trigger_times(k)*Hz+1) =1;
        end
        if event_types{k} == 'lt'
            data_annotation(2,trigger_times(k)*Hz+1) =1;
        end
        if event_types{k} == 'ls'
            data_annotation(3,trigger_times(k)*Hz+1) =1;
        end    
    end
    save(fullfile(data_dir, [filename, '.mat']), 'data_reshape');
    save(fullfile(annotation_dir, [filename, '.mat']), 'data_annotation');
end