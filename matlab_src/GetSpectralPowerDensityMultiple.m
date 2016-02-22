ccc

runname = 'run115';
runlist_filename = '/Users/antonermakov/Dawn/FE/run115_runlist';
in_runlist = fopen(runlist_filename,'r');
output_general_folder = '../output/';

L = 80;

config_filename = fgetl(in_runlist)

all_spectra_folder = [output_general_folder runname '/spectra'];
mkdir(all_spectra_folder);

while (config_filename ~= -1)
    
    % read config file
    Files.config_template_filename = ['../' config_filename];
    cfg = ReadConfig(Files);
    
    %     filename_surf = getAllFiles(folder_path,'_surface');
    %     filename_mesh = getAllFiles(folder_path,'_mesh');
    %
    %     data = load([folder_path '/physical_times.txt']);
    %     t = data(:,2);
    
    %% Hydrostatic equilibrium computation
    [fh,fval]=HydrostaticStateExact2l(...
        cfg.r_mean,...
        cfg.r_mean-cfg.depths_rho,...
        cfg.T,...
        cfg.rho(1),...
        cfg.rho(2),0.1, 0.1);
    
    [a1,c1]=f2axes(cfg.r_mean,fh(1));
    
    fi = (-90:1:90);
    lambda = (-180:1:180);
    [fii,lambdai] = meshgrid(fi,lambda);
    r_ell = TriEllRadVec(fii/180*pi,lambdai/180*pi,a1,a1,c1,'rad');
    
    lmcosi_hydrostatic1 = xyz2plm(r_ell',6);
    
    C20_1 = lmcosi_hydrostatic1(4,3);
    C40_1 = lmcosi_hydrostatic1(11,3);
    C60_1 = lmcosi_hydrostatic1(22,3);
    
    
    %% read time data
    
    phys_times_data = load(['../' cfg.output_folder 'physical_times.txt']);
    t = phys_times_data(:,2);
    
    %% Compute and write spectral power density
    
    spectra_folder = [all_spectra_folder cfg.output_folder(end-9:end)];
    mkdir(spectra_folder);
    
    filename_surf = getAllFiles(['../' cfg.output_folder],'_surface');
    
    try
        for i=1:numel(filename_surf)
            
            [path,name,ext] = fileparts(filename_surf{i});
            
            output_spectrum_filename = ['../' cfg.output_folder strrep(name,...
                'surface', 'spectrum.txt')]
            
            lmcosi_limb = quad2plm(filename_surf{i},L);
            
            % subtract hydrostatic signal
            lmcosi_limb(4,3) = lmcosi_limb(4,3) - C20_1;
            lmcosi_limb(11,3) = lmcosi_limb(11,3) - C40_1;
            lmcosi_limb(22,3) = lmcosi_limb(22,3) - C60_1;
            
            if(i==1)
                initial_lmcosi = lmcosi_limb;
            end
            
            [sdl_limb,l_limb] = plm2spec(lmcosi_limb);
            
            % record spectra in output default folder
            in_spec = fopen(output_spectrum_filename, 'w');
            
            fprintf(in_spec, '%2.8E\n', t(i));
            fprintf(in_spec, '%4i %2.8E\n', [l_limb sdl_limb/1e6]');
            
            fclose(in_spec);
            
             % record spectra in special folder
            output_spectrum_filename_2 = [spectra_folder strrep(name,...
                'surface', 'spectrum.txt')];
            
            in_spec = fopen(output_spectrum_filename_2, 'w');
            
            fprintf(in_spec, '%2.8E\n', t(i));
            fprintf(in_spec, '%4i %2.8E\n', [l_limb sdl_limb/1e6]');
            
            fclose(in_spec);

        end
    end
    
    config_filename = fgetl(in_runlist)
    
end

fclose(in_runlist);
close all


