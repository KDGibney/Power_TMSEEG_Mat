function opts_table = write_opts_file_TMSEEG(datadir)

if ~exist('datadir','var')
    datadir = 'C:\path_to_data_dir\';
end

trials_min = 50;
trials_steps = 50;
trials_max = 150;
trials = trials_min:trials_steps:trials_max;
trials_opts  = trials';
length_trials = length(trials_opts);

subjects_min = 1;
subjects_steps = 1;
subjects_max = 5;
subjects = subjects_min:subjects_steps:subjects_max;
subjects_opts = subjects';
length_subjects = length(subjects_opts);

contrast_site_opts = {'C3vsF3' 'C3vsP3' 'F3 vs P3'};
contrast_site_opts = contrast_site_opts';
length_contrast = length(contrast_site_opts);

num_rows = length_trials*length_subjects; %15 experiments total
trials_iters = num_rows/length_trials;
subjects_iters = num_rows/length_subjects;
contrast_iters = num_rows/length_contrast;


index1 = 1:length_trials:num_rows;
index2 = length_trials:length_trials:num_rows;
for i = 1:trials_iters
    subjectsvec(index1(i):index2(i)) = repmat(subjects(i),[3,1]);
end
subjectsvec = subjectsvec';
trialsvec = repmat(trials',[5,1]);
iterations = 1000;

iterations_vec = repmat(iterations,[num_rows, 1]);
opts_table = table(subjectsvec,trialsvec,iterations_vec,'VariableNames',{'subjects' 'trials' 'iterations'});

save('optstable.mat')

