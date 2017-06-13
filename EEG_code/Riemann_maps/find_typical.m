function [ label, index ] = find_typical( directory )
%According to the directory, finds out what pesron and stimulation it is,
%and returns the index of matrix we are comparing to in the distance
%vector. In addition, returns label.
str_split = strsplit(directory,'\');
label     = [str_split{end-2},' Stim',str_split{end-1}];

%% now find the index in the cases: (will have to update)
switch label
    case 'C04 Stim1'
        index = 1;
    case 'C04 Stim2'
        index = 2;
    case 'C04 Stim3'
        index = 3;
    case 'C04 Stim11'
        index = 4;
    case 'C04 Stim12'
        index = 5;
    case 'C04 Stim13'
        index = 6;
    case 'C04 Stim14'
        index = 7;
    case 'C04 Stim15'
        index = 8;
    case 'C04 Stim16'
        index = 9;
    
    case 'C06 Stim1'
        index = 10;
    case 'C06 Stim2'
        index = 11;
    case 'C06 Stim3'
        index = 12;
    case 'C06 Stim11'
        index = 13;
    case 'C06 Stim12'
        index = 14;
    case 'C06 Stim13'
        index = 15;
    case 'C06 Stim14'
        index = 16;
    case 'C06 Stim15'
        index = 17;
    case 'C06 Stim16'
        index = 18;
    
    case 'C08 Stim1'
        index = 19;
    case 'C08 Stim2'
        index = 20;
    case 'C08 Stim3'
        index = 21;
    case 'C08 Stim11'
        index = 22;
    case 'C08 Stim12'
        index = 23;
    case 'C08 Stim13'
        index = 24;
    case 'C08 Stim14'
        index = 25;
    case 'C08 Stim15'
        index = 26;
    case 'C08 Stim16'
        index = 27;
    otherwise
        index = [];
end
end

