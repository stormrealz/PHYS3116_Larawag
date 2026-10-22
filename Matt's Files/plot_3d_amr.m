%% 3D Age–Metallicity–Galactocentric Distance Plot
% Milky Way Globular Clusters: VandenBerg (2013) vs. Krause (2021)
%
% Axes:
%   X-axis: Metallicity [Fe/H] (dex)
%   Y-axis: Galactocentric Distance R_gc (kpc)
%   Z-axis: Age (Gyr)
%
% Markers:
%   VandenBerg et al. (2013): Circles ('o')
%   Krause et al. (2021):     Squares ('s')
%
% Interactive Features:
%   - Left-click and drag to rotate in 3D (rotate3d enabled by default)
%   - Scroll wheel to zoom
%   - On-figure UI checkboxes to toggle datasets ON / OFF
%   - Click legend items directly to toggle visibility

clear; clc; close all;

%% 1. Locate and Load master_catalogue.csv
csvFile = fullfile('data', 'master_catalogue.csv');
if ~exist(csvFile, 'file')
    csvFile = fullfile('..', 'data', 'master_catalogue.csv');
end
if ~exist(csvFile, 'file')
    csvFile = 'master_catalogue.csv';
end
if ~exist(csvFile, 'file')
    error('Could not find master_catalogue.csv. Please verify the file path.');
end

fprintf('Reading %s ...\n', csvFile);

% Read raw cell data with DatetimeType and DurationType set to 'text'
% (This prevents MATLAB from crashing on coordinates like DEC '+79:34:51.8')
raw = readcell(csvFile, 'FileType', 'text', 'DatetimeType', 'text', 'DurationType', 'text');

% Row 1 = sources ('meta', 'h1', 'h3', 'k', 'vb')
% Row 2 = quantities ('FeH', 'Age', 'R_gc', etc.)
sources = string(raw(1, :));
quantities = string(raw(2, :));
colNames = lower(strtrim(sources) + "_" + strtrim(quantities));

data = raw(4:end, :);
nRows = size(data, 1);

%% 2. Robust Numeric Extraction Function
% Handles numeric values, strings, characters, and missing/empty cells cleanly
extractNum = @(colName) cell2mat(cellfun(@parseNumeric, ...
    data(:, find(colNames == lower(colName), 1)), 'UniformOutput', false));

% Extract cluster names
nameColIdx = find(colNames == "meta_preferred_name", 1);
if isempty(nameColIdx), nameColIdx = 3; end

names = string(data(:, nameColIdx));
idColIdx = find(colNames == "meta_cluster_id", 1);
if isempty(idColIdx), idColIdx = 2; end
for i = 1:nRows
    if ismissing(names(i)) || strlength(strtrim(names(i))) == 0
        names(i) = string(data{i, idColIdx});
    end
end

% -------------------------------------------------------------
% Extract VandenBerg et al. (2013) data (Circles)
% -------------------------------------------------------------
vb_feh = extractNum('vb_FeH');
vb_age = extractNum('vb_Age');
vb_rg  = extractNum('vb_R_G');
h1_rg  = extractNum('h1_R_gc');

% Fallback to Harris R_gc if vb_R_G is missing
vb_rg(isnan(vb_rg)) = h1_rg(isnan(vb_rg));

vb_valid = ~isnan(vb_feh) & ~isnan(vb_age) & ~isnan(vb_rg);
vb_feh = vb_feh(vb_valid);
vb_age = vb_age(vb_valid);
vb_rg  = vb_rg(vb_valid);
vb_names = names(vb_valid);

% -------------------------------------------------------------
% Extract Krause et al. (2021) data (Squares)
% -------------------------------------------------------------
k_feh = extractNum('k_FeH');
k_age = extractNum('k_Age');
k_rg  = h1_rg; % Krause table uses Harris Part I for spatial positions

k_valid = ~isnan(k_feh) & ~isnan(k_age) & ~isnan(k_rg);
k_feh = k_feh(k_valid);
k_age = k_age(k_valid);
k_rg  = k_rg(k_valid);
k_names = names(k_valid);

fprintf('Loaded %d VandenBerg clusters and %d Krause clusters.\n', ...
    length(vb_feh), length(k_feh));

%% 3. Create 3D Interactive Figure
fig = figure('Name', '3D Age–Metallicity–Distance Space', ...
             'NumberTitle', 'off', ...
             'Color', [0.97 0.98 0.99], ...
             'Position', [100, 100, 950, 680]);

ax = axes('Parent', fig);
hold(ax, 'on');

% Trace 1: VandenBerg (Blue Circles)
hVB = scatter3(ax, vb_feh, vb_rg, vb_age, 65, ...
    'Marker', 'o', ...
    'MarkerFaceColor', [0.15 0.45 0.92], ...
    'MarkerEdgeColor', [0.05 0.15 0.45], ...
    'LineWidth', 0.8, ...
    'DisplayName', sprintf('VandenBerg et al. (2013) [N=%d]', length(vb_feh)));

% Trace 2: Krause (Red/Coral Squares)
hK = scatter3(ax, k_feh, k_rg, k_age, 65, ...
    'Marker', 's', ...
    'MarkerFaceColor', [0.92 0.25 0.20], ...
    'MarkerEdgeColor', [0.50 0.08 0.08], ...
    'LineWidth', 0.8, ...
    'DisplayName', sprintf('Krause et al. (2021) [N=%d]', length(k_feh)));

% Set Custom Data Tips (Click a point to see its info)
try
    hVB.DataTipTemplate.DataTipRows(1) = dataTipTextRow('Cluster', vb_names);
    hVB.DataTipTemplate.DataTipRows(2) = dataTipTextRow('[Fe/H]', vb_feh, '%.2f dex');
    hVB.DataTipTemplate.DataTipRows(3) = dataTipTextRow('R_gc', vb_rg, '%.1f kpc');
    hVB.DataTipTemplate.DataTipRows(4) = dataTipTextRow('Age', vb_age, '%.2f Gyr');

    hK.DataTipTemplate.DataTipRows(1) = dataTipTextRow('Cluster', k_names);
    hK.DataTipTemplate.DataTipRows(2) = dataTipTextRow('[Fe/H]', k_feh, '%.2f dex');
    hK.DataTipTemplate.DataTipRows(3) = dataTipTextRow('R_gc', k_rg, '%.1f kpc');
    hK.DataTipTemplate.DataTipRows(4) = dataTipTextRow('Age', k_age, '%.2f Gyr');
catch
end

%% 4. Styling & Axes Configuration
xlabel(ax, 'Metallicity [Fe/H] (dex)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel(ax, 'Galactocentric Distance R_{GC} (kpc)', 'FontSize', 12, 'FontWeight', 'bold');
zlabel(ax, 'Age (Gyr)', 'FontSize', 12, 'FontWeight', 'bold');

title(ax, 'Milky Way Globular Clusters: 3D Age–Metallicity–Distance Space', ...
    'FontSize', 14, 'FontWeight', 'bold');

grid(ax, 'on');
box(ax, 'on');
ax.GridAlpha = 0.25;
ax.LineWidth = 1.0;
ax.FontSize = 10;

% Set 3D viewpoint and bounds
view(ax, 45, 25);
xlim(ax, [-2.6, 0.1]);
ylim(ax, [0, 40]);
zlim(ax, [6.5, 15.0]);

%% 5. Interactive Legend & Visibility Toggles
lgd = legend(ax, [hVB, hK], 'Location', 'northeast', 'FontSize', 10);
lgd.Box = 'on';
lgd.Color = [1 1 1];
lgd.EdgeColor = [0.8 0.8 0.8];

% Clicking legend items toggles visibility
try
    lgd.ItemHitCallback = @toggleLegendItem;
catch
end

% On-Figure Checkbox UI Panel
panel = uipanel('Parent', fig, ...
    'Title', ' Toggle Datasets ', ...
    'FontWeight', 'bold', ...
    'FontSize', 9, ...
    'BackgroundColor', [1 1 1], ...
    'Position', [0.03, 0.84, 0.28, 0.12]);

cbVB = uicontrol('Parent', panel, ...
    'Style', 'checkbox', ...
    'String', ' VandenBerg (Circles)', ...
    'Value', 1, ...
    'ForegroundColor', [0.10 0.35 0.85], ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [1 1 1], ...
    'Units', 'normalized', ...
    'Position', [0.05, 0.52, 0.90, 0.40], ...
    'Callback', @(src, ~) set(hVB, 'Visible', ifelse(src.Value, 'on', 'off')));

cbK = uicontrol('Parent', panel, ...
    'Style', 'checkbox', ...
    'String', ' Krause (Squares)', ...
    'Value', 1, ...
    'ForegroundColor', [0.85 0.20 0.15], ...
    'FontWeight', 'bold', ...
    'BackgroundColor', [1 1 1], ...
    'Units', 'normalized', ...
    'Position', [0.05, 0.10, 0.90, 0.40], ...
    'Callback', @(src, ~) set(hK, 'Visible', ifelse(src.Value, 'on', 'off')));

% Enable 3D rotation by default
rotate3d(ax, 'on');

%% Local Helper Functions
function num = parseNumeric(val)
    if isnumeric(val)
        num = double(val);
    elseif ischar(val) || isstring(val)
        num = str2double(val);
    else
        num = NaN;
    end
end

function val = ifelse(condition, trueVal, falseVal)
    if condition
        val = trueVal;
    else
        val = falseVal;
    end
end

function toggleLegendItem(~, event)
    if strcmp(event.Peer.Visible, 'on')
        event.Peer.Visible = 'off';
    else
        event.Peer.Visible = 'on';
    end
end
