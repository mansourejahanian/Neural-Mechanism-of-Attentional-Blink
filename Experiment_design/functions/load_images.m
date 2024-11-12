function [im] = load_images(filetype, directory,rgb)

files = dir(directory);

im = [];

if rgb
    for i = 3:length(files)
        if strfind(files(i).name,filetype)
            rgb_image = imread(fullfile(directory, files(i).name));
            im{end+1} = rgb2gray(rgb_image); 
        end
    end
    
else
    for i = 3:length(files)
        if strfind(files(i).name,filetype)
            im{end+1} = imread(fullfile(directory, files(i).name));
        end
    end
end


end