function call_loop_TMSEEG(datadir)

if ~exist('datadir','var')
    datadir = 'C:\path_to_data_dir\';
end

if ~exist('outputdir','var')
    outputdir = 'C:\path_to_output_dir\';
end

optsfile = [datadir, 'optstable.mat'];
load(optsfile);

opts_table(1:12,:) = [];

for i = 1:height(opts_table)
    num_subjects(i) = opts_table.subjects(i);
    num_trials(i) = opts_table.trials(i);
    iterations(i) = opts_table.iterations(i);
    loop_C3vsF3(datadir, outputdir, num_subjects(i),num_trials(i),iterations(i))
    loop_C3vsP3(datadir, outputdir, num_subjects(i),num_trials(i),iterations(i))
    loop_F3vsP3(datadir, outputdir, num_subjects(i),num_trials(i),iterations(i))
end