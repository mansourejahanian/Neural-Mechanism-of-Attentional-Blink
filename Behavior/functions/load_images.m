function [im] = load_images(filetype, directory)

files = dir(directory);

%im_unshuffled = [];
im = [];
for i = 3:length(files)
    if strfind(files(i).name,filetype)
        im{end+1} = imread(fullfile(directory, files(i).name));
    end
end

% shuffle the targets
% im = im_unshuffled;
% rand_targets = [nimage+randperm(10); nimage+10+randperm(10); nimage+20+randperm(10); nimage+30+randperm(10)] ;
% 
% for i=1:10
% im{nimage+i} = im_unshuffled{rand_targets(1,i)};
% im{nimage+10+i} = im_unshuffled{rand_targets(2,i)};
% im{nimage+20+i} = im_unshuffled{rand_targets(3,i)};
% im{nimage+30+i} = im_unshuffled{rand_targets(4,i)};
% end


% for i=1:10
%     figure
%     imshow(im{220+i})
% end

end