clc; close all;

coe_file = 'C:\Users\tushi\Verilog HDL based Image Processing Core\Digital Image Processing.sim\sim_1\behav\xsim\processed_image.coe';

% Get original image info to set width and height correctly
info = imfinfo('C:\Users\tushi\Verilog HDL based Image Processing Core\Images\Original Image.jpeg');
width = info.Width;
height = info.Height;

fileID = fopen(coe_file, 'r');
if fileID == -1
    error('Could not open the COE file. Check the path.');
end

filelines = textscan(fileID, '%s', 'Delimiter', '\n');
filelines = filelines{1};
fclose(fileID);

pixel_array = zeros(height, width, 3, 'uint8');

for i = 3:numel(filelines)  % Skip 2 header lines
    line = filelines{i};
    % Remove trailing comma or semicolon if present
    line = regexprep(line, '[,;]$', '');

    r = bin2dec(line(1:8));
    g = bin2dec(line(9:16));
    b = bin2dec(line(17:24));

    idx = i - 3; % zero-based index of pixel
    row = floor(idx / width) + 1;
    col = mod(idx, width) + 1;

    pixel_array(row, col, :) = [r, g, b];
end

newImage = uint8(pixel_array);

imwrite(newImage, 'C:\Users\tushi\Verilog HDL based Image Processing Core\outputimg.jpeg');
fprintf('Width: %d pixels\n', width);
fprintf('Height: %d pixels\n', height);
disp('Image reconstruction complete!');
