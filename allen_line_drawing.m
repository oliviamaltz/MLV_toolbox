% Line-drawing Transformation Script using the MLV Toolbox

% Setup: 
% (A) Make sure all necessary packages and addons are downloaded: 
% (1) Matlab Computer Vision Toolbox
% (2) Matlab Image Processing Toolbox
% (3) Matlab Statistics and Machine Learning Toolbox
% (4) Matlab Image Processing Toolbox for Segment Anything Model
% (5) Matlab Deep Learning Toolbox

% (B) In order to run this script you will need to ensure the
% input (original images) folder and output folder is set up properly.
% First delete all images in the images subfolder within the MLV toolbox
% (C:\matlab_repo\MLV_toolbox\images). Once it is empty, create two folders
% "original" and "line_drawing". Within the original subfolder add all of
% the image folders containing the desired images to be transformed. Once
% the image folders and subfolders have been created the script can be run
% from the terminal or via matlab directly in editor mode.


% Clear the Workspace

clear
 
% Add path to the directory via setup.m

setup

%% Main Image Path

images = 'C:\matlab_repo\MLV_toolbox\images\original'; % Add the folder containing all the image class subfolders

line_drawing_folder ='C:\matlab_repo\MLV_toolbox\images\line_drawing';

output_suffix = 'LD';

%% Compile a list of all image class folders (e.g., cat, cow, airplane)

img_classes = dir(images);

img_classes = img_classes([img_classes.isdir]);

img_classes = img_classes(~ismember({img_classes.name}, {'.','..'})); % Remove '.' and '..'


%% Filter out '.' and '..' and any files, keeping only directories

for i = 1:length(img_classes)
    current_img_class = img_classes(i).name;
    current_img_class_path = fullfile(images,current_img_class);

%Define the output path
    linedrawing_img = [current_img_class, output_suffix]; %Output folder
    linedrawing_img_path = fullfile(line_drawing_folder, linedrawing_img);

%Create output directory if it does not exist
    if ~ exist(linedrawing_img_path,"dir")
        mkdir(linedrawing_img_path);
        fprintf('Output Folder (line_drawing) has been created: %s\n', linedrawing_img_path);
    else 
        fprintf('Output Folder (line_drawing) already exists: %s\n', linedrawing_img_path);
    end

%% Gather list of all image files
% Process images in the current class folder
img_class_files = dir(fullfile(current_img_class_path, '*.JPEG')); % Adjust extension as needed

img_class_files = [img_class_files; dir(fullfile(current_img_class_path, '*.png'))];

    if isempty(img_class_files)
        fprintf('No images found in %s. Skipping.\n', current_img_class_path);
        continue; % Go to the next subfolder
    end

fprintf('Processing images in: %s\n', current_img_class_path);

    for j = 1:length(img_class_files)
        image_file_name = img_class_files(j).name;
        img_file_path = fullfile(current_img_class_path, img_class_files(j).name);


%% MLV Toolbox (line-drawing)

% Convert photograph into line drawing
        vecLD = traceLineDrawingFromRGB(image_file_name);

% View 'vecLD'
        figure;
        drawLinedrawing(vecLD);
        hold on;
        axis off;

% Assign the figure to a handle
        line_drawing_fig = gcf; % Get the handle of the current figure

        line_drawing_fig.Color = [1 1 1]; % Change background to white


%% Define the output file path for the transformed image
        [~, name, ext] = fileparts(image_file_name);
        line_drawing_file_name = [name, output_suffix, ext]; % Keep original filename and add _LD to the filename before the extension
        line_drawing_image_full_path = fullfile(linedrawing_img, line_drawing_file_name);

%% Save the generated figure as a JPEG
% Use exportgraphics for modern MATLAB (R2020a+)
        exportgraphics(line_drawing_fig, line_drawing_image_full_path, 'Resolution', 300); % Adjust DPI as needed 
        fprintf('  Saved transformed figure to: %s\n', line_drawing_image_full_path);
        close(line_drawing_fig);
        fprintf('  Closed figure for %s.\n', image_file_name);

    end % End for inner j loop (image files in one folder)
    fprintf('Finished processing all images in %s.\n\n', current_img_class_path);

end % End for outer i loop (subfolders)
disp('All image transformations complete!');