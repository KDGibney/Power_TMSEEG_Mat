function C3_cell = process_C3(C3_file, subject, session)
%I need to extract the subject number, the session number, the trial
%number, the site, and the N15-P30 from each site

C3_data = load(C3_file);


C3_EEG = C3_data.data_tobesaved.EEG;

C3_EEG_data = C3_EEG.data;
[dim1, dim2, dim3] = size(C3_EEG_data);
%62 channels, 751 samples, 182 trials


for i = 1:dim1
    C3_chanlocs = C3_EEG.chanlocs(i);
    C3_labels{i} = C3_chanlocs.labels;
end

clear i

badchannels = C3_EEG.badchs;

allchannels = 1:62;

allchannels(badchannels) = [];

for i = 1:length(allchannels)
    good_labels{i} = C3_labels{allchannels(i)};
end

clear i

C3_pool = {'FC5' 'FC3' 'FC1' 'C5' 'C3' 'C1' 'CP5' 'CP3' 'CP1'};
%9 channels

for i = 1:length(C3_pool)
    find_pool(i) = find(strcmp(C3_labels,C3_pool{i}) == 1);
end
clear i

bad_pool_index = [];

for i = 1:length(find_pool)
    for j = 1:length(badchannels)
        if find_pool(i) == badchannels(j)
            bad_pool_index = [bad_pool_index; i];
        end
    end
end

find_pool(bad_pool_index) = [];

clear i
clear j

pooled_C3_data = reshape(C3_EEG_data(find_pool,:,:),[length(find_pool) dim3 dim2]);

[~, ~, newdim3] = size(pooled_C3_data);

for i = 1:newdim3
    pool(:,:,i) = mean(pooled_C3_data(:,:,i));
end

clear i

[~, finaldim2, finaldim3] = size(pool);

pool = reshape(pool,[finaldim2 finaldim3]);

%convert samples to msec
%(1/625)*1000 = 1.6, data is sampled every 1.6 msec
x_values = -600:1.6:600;
%0 msec is at sample # 376
%15 msec is at sample # 386
%30 msec is at sample # 395

for i = 1:finaldim2
    N15_amp(i) = min(pool(i,385:387));
    P30_amp(i) = max(pool(i,394:396));
    peaktopeak(i) = abs(N15_amp(i) - P30_amp(i));
end

clear i

subject = cellstr(repmat(subject, [finaldim2 1]));
session = cellstr(repmat(session, [finaldim2 1]));
trial = 1:finaldim2;
trial = trial';
site = cellstr(repmat('C3', [finaldim2 1]));
peaktopeak = peaktopeak';

C3_table = table(subject, session, trial, site, peaktopeak);
C3_table = C3_table(1:150,:);
C3_cell = table2cell(C3_table);

end