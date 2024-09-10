function colormap = GenColormap(map, n)
% GenColormap Generate a colormap with a specified number of colors.
%
% Inputs:
%   map - The original colormap as an m×3 matrix, where m is the number of colors
%         and 3 represents the RGB channels.
%   n   - The desired number of colors in the output colormap. Defaults to 256.
%
% Outputs:
%   colormap - An n×3 matrix representing the generated colormap, where each row
%              corresponds to an RGB color value.
%-------------------------------------------------------------------------------------

% Set default number of colors to 256 if not provided
if nargin < 2
    n = 256;
end

% Get the number of colors in the original colormap
m = size(map, 1);

% Return the original colormap if it has enough colors
if m >= n
    colormap = map;
    return;
end

% Create ranges for interpolation
originalRange = linspace(1, m, m);
targetRange = linspace(1, m, n);

% Initialize the output colormap
colormap = zeros(n, 3);

% Interpolate each color channel
for channel = 1:3
    colormap(:, channel) = interp1(originalRange, map(:, channel), targetRange);
end
end
