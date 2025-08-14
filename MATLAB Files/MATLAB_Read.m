clc; close all;

file = 'C:\Users\tushi\Verilog HDL based Image Processing Core\rgbimage.jpeg';
image = imread(file);

[height, width, ~] = size(image);

coeFileName = 'C:\Users\tushi\Verilog HDL based Image Processing Core\rgbimage.coe';
coeFile = fopen(coeFileName, 'w');

fprintf(coeFile, 'MEMORY_INITIALIZATION_RADIX=2;\n');
fprintf(coeFile, 'MEMORY_INITIALIZATION_VECTOR=\n');

for h = 1:height
    for w = 1:width
        pixel = image(h, w, :);
        Rb = dec2bin(pixel(1), 8);
        Gb = dec2bin(pixel(2), 8);
        Bb = dec2bin(pixel(3), 8);
        pixelBinary = strcat(Rb, Gb, Bb);

        if h == height && w == width
            fprintf(coeFile, '%s;', pixelBinary);  % Last pixel ends with ;
        else
            fprintf(coeFile, '%s,\n', pixelBinary);
        end
    end
end

fclose(coeFile);
disp('COE file created successfully!');
