function [ resized_images ] = order_images( images_cell )
%makes all images the same size

max_size = [0,0];
for ii = 1:length(images_cell(:))
    max_size = max([max_size; size(images_cell{ii})]);
end

resized_temp   = cell(size(images_cell));
resized_images = cell(size(images_cell));
for ii = 1:length(images_cell(:))
    curr_size          = size(images_cell{ii});
    resized_temp{ii}   = [zeros(curr_size(1),...
                         floor((max_size(2)-curr_size(2)) / 2)),...
                         images_cell{ii},zeros(curr_size(1),...
                         ceil((max_size(2)-curr_size(2)) / 2))];
    resized_images{ii} = [zeros(floor((max_size(1)-curr_size(1)) / 2), ...
                          max_size(2)); resized_temp{ii}; ...
                          zeros(ceil((max_size(1)-curr_size(1))/2), ...
                          max_size(2))];
end

end

