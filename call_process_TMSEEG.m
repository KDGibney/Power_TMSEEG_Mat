function [C3_cell, F3_cell, P3_cell] = call_process_TMSEEG(datadir)

if ~exist('datadir','var')
    datadir = 'C:\path_to_data_dir';
end



wildcard = [datadir, '\S*\S*V*\'];

finddirs = dir(wildcard);
find_dirs = struct2cell(finddirs);

[dim1 dim2] = size(find_dirs);

for i = 1:dim2
    all_dirs{i} = find_dirs{2,i};
    all_files{i} = find_dirs{1,i};
end
clear i

unique_dirs = unique(all_dirs);

num_dirs = length(unique_dirs);

num_expected_dirs = 3*5; 

if num_dirs ~= num_expected_dirs
    disp('somethings not right')
end


for i = 1:num_dirs
    current_dir = unique_dirs{i};
    disp(current_dir)
    [C3_file{i}, F3_file{i}, P3_file{i}, subject{i}, session{i}] =  ...
        find_files_TMSEEG(current_dir);
    C3_cell{i} = process_C3(C3_file{i}, subject(i), session(i));
    F3_cell{i} = process_F3(F3_file{i}, subject(i), session(i));
    P3_cell{i} = process_P3(P3_file{i}, subject(i), session(i));
end

clear i

cellname = [datadir, 'datacell.mat'];
save(cellname,'C3_cell','F3_cell','P3_cell','-mat')

C3_table = [];
F3_table = [];
P3_table = [];


for i = 1:15
    F3_table = [F3_table; cell2table(F3_cell{i}(1:150,:))];
    P3_table = [P3_table; cell2table(P3_cell{i}(1:150,:))];
    C3_table = [C3_table; cell2table(C3_cell{i}(1:150,:))];
end

clear i



C3_table.Properties.VariableNames = {'subject','session','trial','site','peaktopeak'};
F3_table.Properties.VariableNames = {'subject','session','trial','site','peaktopeak'};
P3_table.Properties.VariableNames = {'subject','session','trial','site','peaktopeak'};

tablename = [datadir, 'datatable.mat'];
save(tablename,'C3_table','F3_table','P3_table','-mat')