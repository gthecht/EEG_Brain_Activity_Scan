function [ labels ] = diff_maps_title( directories )
%According to the directories, finds out what person and stimulation it is,
%and returns the appropriate title for the diffusion map
len    = length(directories);
labels = cell(1,len);
for ii = 1:len
    str_split  = strsplit(directories{ii},'\');
    labels{ii} = ['Sbj',str_split{end-2},' Stim',str_split{end-1},', '];
end
end

