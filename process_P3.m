function P3_cell = process_P3(P3_file, subject, session)
%I need to extract the subject number, the session number, the trial
%number, the site, and the N15-P30 from each site

P3_data = load(P3_file);


P3_EEG = P3_data.data_tobesaved.EEG;

P3_EEG_data = P3_EEG.data;
[dim1, dim2, dim3] = size(P3_EEG_data);
%62 channels, 751 samples, 182 trials


for i = 1:dim1
    P3_chanlocs = P3_EEG.chanlocs(i);
    P3_labels{i} = P3_chanlocs.labels;
end

clear i

badchannels = P3_EEG.badchs;

allchannels = 1:62;

allchannels(badchannels) = [];

for i = 1:length(allchannels)
    good_labels{i} = P3_labels{allchannels(i)};
end

clear i

P3_pool = {'CP5' 'CP3' 'CP1' 'P5' 'P3' 'P1' 'PO7' 'PO3' 'POz'};
%9 channels

for i = 1:length(P3_pool)
    find_pool(i) = find(strcmp(P3_labels,P3_pool{i}) == 1);
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

pooled_P3_data = reshape(P3_EEG_data(find_pool,:,:),[length(find_pool) dim3 dim2]);

[~, ~, newdim3] = size(pooled_P3_data);

for i = 1:newdim3
    pool(:,:,i) = mean(pooled_P3_data(:,:,i));
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
site = cellstr(repmat('P3', [finaldim2 1]));
peaktopeak = peaktopeak';

P3_table = table(subject, session, trial, site, peaktopeak);
P3_table = P3_table(1:150,:);
P3_cell = table2cell(P3_table);

end