function loop_C3vsF3_allsessions(datadir, outputdir, num_subjects, num_trials, iterations)

if ~exist('datadir','var')
    datadir = 'C:\path_to_data_dir\';
end

if ~exist('outputdir','var')
    outputdir = 'C:\path_to_output_dir\';
end

if ~exist('num_subjects','var')
    num_subjects = 2;
end

if ~exist('num_trials','var')
    num_trials = 150;
end

if ~exist('iterations','var')
    iterations = 100;
end

datafile = [datadir, 'datatable.mat'];
load(datafile)

find_bad_C3 = strcmp(C3_table.subject,'S4');
C3_table(find_bad_C3,:) = [];

find_bad_F3 = strcmp(F3_table.subject,'S4');
F3_table(find_bad_F3,:) = [];

C3_subjects = C3_table.subject;
C3_session = C3_table.session;
for i = 1:length(C3_subjects)
    C3splitsubs{i} = strsplit(C3_subjects{i},'S');
    C3allsubs(i) = cell2mat(C3splitsubs{i}(2));
    C3splitsession{i} = strsplit(C3_session{i},'V');
    C3allsessions(i) = cell2mat(C3splitsession{i}(2));
end

clear i

C3allsubs = str2num(C3allsubs');
C3allsessions = str2num(C3allsessions');
unique_subs = unique(C3allsubs);
unique_sessions = unique(C3allsessions);


F3_subjects = F3_table.subject;
unique_F3_subject = unique(F3_subjects);

sanity_check = strcmp(unique_C3_subjects,unique_F3_subject);


F3_subjects = F3_table.subject;
F3_session = F3_table.session;
for i = 1:length(F3_subjects)
    F3splitsubs{i} = strsplit(F3_subjects{i},'S');
    F3allsubs(i) = cell2mat(F3splitsubs{i}(2));
    F3splitsession{i} = strsplit(F3_session{i},'V');
    F3allsessions(i) = cell2mat(F3splitsession{i}(2));
end

clear i

F3allsubs = str2num(F3allsubs');
F3allsessions = str2num(F3allsessions');
unique_subs = unique(F3allsubs);
unique_sessions = unique(F3allsessions);
num_sessions = length(unique_sessions);

C3_trials = C3_table.trial;
unique_C3_trials = unique(C3_trials);

F3_trials = F3_table.trial;
unique_F3_trials = unique(F3_trials);

%%

for i = 1:iterations
    print_string = ['outer loop number ', num2str(i)];
    disp(print_string)
    for j = 1:num_subjects
        random_subjects(i,:) = randsample(unique_subs,num_subjects);
        for q = 1:num_sessions
            session(i,j,q) = q;
            for k = 1:num_trials
                random_trials(i,j,q, :) = randsample(1:150,num_trials);
                for l = 1:length(C3_trials)
                    if random_trials(i,j,q, k) == C3_trials(l)
                    if session(i,j,q) == C3allsessions(l)
                        if random_subjects(i,j) == C3allsubs(l)
                            random_TEP_C3(i,j,q, k) = C3_table.peaktopeak(l);
                        end
                    end
                end
            end
            for m = 1:length(F3_trials)
                if random_trials(i,j,q, k) == F3_trials(m)
                    if session(i,j, q) == F3allsessions(m)
                        if random_subjects(i,j) == F3allsubs(m)
                            random_TEP_F3(i,j,q, k) = F3_table.peaktopeak(m);
                        end
                    end
                end
            end
            
            end
        mean_within_C3_allsession(i,j,q) = mean(random_TEP_C3(i,j,q,:));
        mean_within_F3_allsession(i,j,q) = mean(random_TEP_F3(i,j,q,:));
        end
    mean_within_C3(i,j) = mean(mean_within_C3_allsession(i,j,:));
    mean_within_F3(i,j) = mean(mean_within_F3_allsession(i,j,:));
    end
end


clear i
clear j
clear k
clear l
clear m
clear q

      

%%
%now reshape the files so they can write to a spreadsheet
reshape_random_subjects = reshape(random_subjects', ...
    [iterations*num_subjects,1]);

reshape_TEP_C3_allsessions = reshape(mean_within_C3_allsession, [iterations*num_subjects*num_sessions,1]);

reshape_TEP_F3_allsessions = reshape(mean_within_F3_allsession, [iterations*num_subjects*num_sessions,1]);



if length(reshape_TEP_C3) ~= length(reshape_TEP_F3)
    disp('number of observations per category inconsistent!')
end

if length(reshape_TEP_C3) ~= length(reshape_random_subjects)
    disp('# subjects and # observations inconsistent!')
end

num_observations = iterations*num_subjects*2;

index1 = 1:2:num_observations;
index2 = 2:2:num_observations;

for q = 1:length(index1)
    subjects(index1(q)) = reshape_random_subjects(q);
    subjects(index2(q)) = reshape_random_subjects(q);
    TEP_C3vsF3(index1(q)) = reshape_TEP_C3(q);
    TEP_C3vsF3(index2(q)) = reshape_TEP_F3(q);
    condition(index1(q)) = 1;
    condition(index2(q)) = 2;
end

subjects = subjects';
TEP_C3vsF3 = TEP_C3vsF3';
condition = condition';

within_results_dir = [outputdir, 'C3vsF3\'];
mkdir(within_results_dir)

iterations_string = num2str(iterations);
trials_string = num2str(num_trials);
if num_trials < 100
    trials_string = ['0', trials_string];
end
subjects_string = num2str(num_subjects);
if num_subjects < 10
    subjects_string = ['0', subjects_string];
end
if num_subjects < 10
    subjects_string = ['0', subjects_string];
end

C3vsF3_table = table(subjects,TEP_C3vsF3,condition,'VariableNames', ...
    {'subjectID','TEP','condition'}); %condition 1 is C3, condition 2 is F3
C3vsF3_filename = [within_results_dir, subjects_string, '_subjects_', ...
    trials_string, '_trials_', 'C3vsF3_', iterations_string, ...
    '_iterations_3sessions.csv'];

writetable(C3vsF3_table, C3vsF3_filename);
