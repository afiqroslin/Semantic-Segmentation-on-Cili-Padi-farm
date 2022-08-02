function cmap = chilliColorMap()
% Define the colormap used by chilli farm dataset.

cmap = [
    128 128 128   % Flat
    255 165 000   % Living Things
    128 000 128   % Plantation
    128 128 000   % Support
    144 238 144   % Vegetation
    255 218 185   % Miscellaneous
    199 021 133   % Construction
    034 139 034   % Nature
    188 143 143   % Vehicle
    135 206 250   % Sky
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end