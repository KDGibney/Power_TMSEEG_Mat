function inventory_TMSEEG(datadir)

if ~exist('datadir','var')
    datadir = 'C:\path_to_data_dir\';
end

master_file = [datadir, 'datatable.mat'];
load(master_file);

C3_subjects = C3_table.subject;
F3_subjects = F3_table.subject;
P3_subjects = P3_table.subject;

unique_C3_subjects = unique(C3_subjects);
unique_F3_subjects = unique(F3_subjects);
unique_P3_subjects = unique(P3_subjects);

C3_session = C3_table.session;
unique_C3_session = unique(C3_session);

F3_session = F3_table.session;
unique_F3_session = unique(F3_session);

P3_session = P3_table.session;
unique_P3_session = unique(P3_session);

C3_trials = C3_table.trial;
unique_C3_trials = unique(C3_trials);

F3_trials = F3_table.trial;
unique_F3_trials = unique(F3_trials);

P3_trials = P3_table.trial;
unique_P3_trials = unique(P3_trials);

%we have at least 150 trials for each site