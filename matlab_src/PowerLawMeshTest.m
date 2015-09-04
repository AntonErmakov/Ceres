% ccc
matlab_config_filename   = '../config/ConfigurationMatlab.cfg';
config_template_filename = '../config/ConfigurationTemplate.cfg';
config_list_filename     = '../RunList.txt';
run_id                   = 'test_run';

Files.matlab_config_filename = matlab_config_filename;
Files.config_template_filename = config_template_filename;
Files.config_list_filename = config_list_filename;

Nmeshes   = 2; % number of meshes to be generated

% Ceres topography spectrum power law parameters
r_mean    = 470000;
beta      = -3.72;
intercept = 8.079;
GeneratePowerLawMesh(Files,r_mean,beta,intercept,Nmeshes,run_id);




