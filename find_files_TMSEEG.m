function [C3_file, F3_file, P3_file, subject, session] =  find_files_TMSEEG(current_dir)

cd(current_dir)

split_dir = strsplit(current_dir,'\');
if contains(split_dir{11},'V')
    split_sub = strsplit(split_dir{11},'V');
end

subject = split_sub{1};
session = ['V', split_sub{2}];

allfiles = dir(current_dir);
allfilescell = struct2cell(allfiles);
[~, dim2] = size(allfilescell);

good_index = []; 
for i = 1:dim2
    allfilenames{i} = allfilescell{1,i};
    if contains(allfilenames{i},'.mat')
        good_index = [good_index; i];
    end
end

clear i

for i = 1:length(good_index)
    real_files{i} = allfilenames{good_index(i)};
end

clear i

for i = 1:length(real_files)
    if contains(real_files{i},'C3')
        C3_file = real_files{i};
    end
    if contains(real_files{i},'F3')
        F3_file = real_files{i};
    end
    if contains(real_files{i},'P3')
        P3_file = real_files{i};
    end
end

end