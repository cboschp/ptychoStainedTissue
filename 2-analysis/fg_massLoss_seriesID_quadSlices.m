function P = fg_massLoss_seriesID_quadSlices(T, seriesID, r_nr, ttl, color, relative_mass, plotError, color_D, singlePlot, fgOpts)
szMarker = 5;
errAlpha = 0.25;
baselinelength = 10; % number of initial data points used to calculate mass baseline

% check input
if ~(size(seriesID,1)==1)
    error('ERROR: only one series ID can be provided.')
end

relative_mass_check = sum(strcmp(relative_mass,{'none','top','tomogram'}))==1;
if ~relative_mass_check
    error('ERROR: relative_mass only accepts "none", "top" and "tomogram" as values');
end

% generate vars
seriesT = T(T.tomoSeries == seriesID,:);
nRecons = height(seriesT);

% check plotting mode
if strcmp(r_nr,'rigid')
    mass_ng = seriesT.quad_mass_ng_slice_r_avg;
    errordata = seriesT.quad_mass_ng_slice_r_err;
    vxSize_nm = seriesT.vxSize_r;
elseif strcmp(r_nr,'nonrigid')
    mass_ng = seriesT.quad_mass_ng_slice_nr_avg;
    errordata = seriesT.quad_mass_ng_slice_nr_err;
    vxSize_nm = seriesT.vxSize_nr;
else
    error('ERROR: recon mode not stated. It must be either rigid or nonrigid.');
end

% generate vars II
x = cell(nRecons,1);
x_nm = cell(nRecons,1);
y = cell(nRecons,1);
err = cell(nRecons,1);

for i = 1:nRecons
    y_raw = mass_ng{i};
    nSlices = height(y_raw);
    x{i} = (-(nSlices-1)/2:1:(nSlices-1)/2)';
    x_nm{i} = x{i} .* vxSize_nm(i,1);

    if ~isempty(y_raw)
        if relative_mass=="top"
            y0 = y_raw(1:baselinelength);
            y{i} = y_raw ./ mean(y0);
            err{i} = errordata{i}./y_raw(1);
        elseif relative_mass=="tomogram"
            % check tomogram height
            h_yinit = height(mass_ng{1});
            h_y = height(y_raw);
            if h_yinit < h_y    
                % correction for few cases were later tomograms scanned larger fields of view
                idx_raw = (floor(1+h_y/2-h_yinit/2):floor(h_y/2 + h_yinit/2))';
                y_raw = mass_ng{i}(idx_raw); % restrict to vertical range of first tomogram
                h_y = height(y_raw); % overwrite value for updated height
                x_nm{i} = x_nm{i}(idx_raw); % apply selection to x vector
            end
            % test trace of this tomogram:
            y00 = y_raw(1:baselinelength); % this tomogram's baseline
            y01 = y_raw ./ mean(y00); % center y across its own baseline
            % data from first tomogram matching this tomogram's range:
            idx = (floor(1+h_yinit/2-h_y/2):floor(h_yinit/2 + h_y/2))';         
            yinit = mass_ng{1}(idx); % equivalent region of first tomogram
            yinit00 = mass_ng{1}(1:baselinelength); % first tomogram's baseline
            yinit01 = yinit ./ mean(yinit00); % center y across its own baseline
            % normalise baseline-centered y{i} to the first tomogram:
            y{i} = y01 ./ yinit01;
            if h_yinit < height(mass_ng{i})
                % same correction as above
                err{i} = errordata{i}(idx_raw)./yinit;
            else
                err{i} = errordata{i} ./ yinit;
            end
        elseif relative_mass=="none"
            y{i} = y_raw;
            err{i} = errordata{i};
        end
    end
end

% ylabel config
if relative_mass=="top"
     y_label = 'mass relative to top slices';
     y_lim = [0.5 1.25];
elseif relative_mass=="tomogram"
    y_label = 'norm mass / first tomogram';
    y_lim = [0.5 1.25];
elseif relative_mass=="none"
     y_label = 'mass (ng)';
     y_lim = [2e-4 8e-4];
end

% plot
if singlePlot
    F = figure();
    F.Position(3:4) = fgOpts.sz;
end

% color-code by accDoseSeries -- overwrites the color variable
ax = gca();
if color_D
    cmap_sz = 256;
    cmap = copper(cmap_sz);
    crange = [7 log10(1.2e10)]; % accDose range to be mapped (log units)
    colors = zeros(nRecons,3);
    for j = 1:nRecons
        this_D = seriesT.accDose_series(j);
        if this_D~=0
            this_D_log = log10(this_D);
            D_idx = interp1([min(crange) max(crange)], [1 256], this_D_log);
            D_idx = round(D_idx);
            colors(j,:) = cmap(D_idx,:);
        end
    end
    
else
    colors = repmat(color,nRecons,1);
end


for i = 1:nRecons
    if ~isempty(y{i}) && seriesT.trackAccDose_series(i)
        P = plot(x_nm{i},y{i},'-','color',colors(i,:),'LineWidth',fgOpts.lw);
        hold on;
        if plotError
            P_err = patch([x_nm{i}; flip(x_nm{i})], [y{i} - err{i}; flip(y{i} + err{i})], ...
                colors(i,:),'FaceAlpha',errAlpha,'EdgeColor','none');
        end
    end
    hold on;
end

if color_D
    % colorbar
    ax.Colormap = copper(size(ax.Colormap,1)); % lookup table
    c = colorbar;
    clim(crange); % temperature range of the colormap
    c.Limits = crange; % temperature range of the colorbar
    c.Label.String = 'log10(accDoseSeries) (Gy)';
    c.Label.FontSize = fgOpts.fsAx;
end

% edit

box off;
axis square;

xlabel('z (µm)');
ylabel(y_label);
ylim(y_lim);
xlim([-1.5e4 1.5e4]);
ax = gca();
ax.FontSize = fgOpts.fsAx;
% ax.YTick = [0.2 0.25 0.3];
% config xlabel in um
ax.XTick = [-1e4, 0, 1e4];
ax.XTickLabel = {'-10 µm', '0', '10 µm'};
title(ttl,'FontSize',fgOpts.fsT,'interpreter','none');

end