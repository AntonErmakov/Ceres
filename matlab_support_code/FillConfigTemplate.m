function new_name = FillConfigTemplate(config_template_filename,mesh_filename,append)

[path,name,ext] = fileparts(config_template_filename);

in_old = fopen(config_template_filename,'r');
new_name = [path '/' name '_' append ext];
in_new = fopen(new_name,'w');

str = fgetl(in_old);
fprintf(in_new,'%s',str);

while (str~=-1)
    str = fgetl(in_old); 
    key_mesh = 'mesh_filename';
    key_out  = 'output_folder';
    if strncmpi(str,key_mesh,numel(key_mesh))    
        fprintf(in_new,[key_mesh ' = "' mesh_filename(4:end) '";\n']);
    elseif strncmpi(str,key_out,numel(key_out))
            fprintf(in_new,[key_out ' = "output/output_' append '/";\n']);
            folder_name = ['../output/output_' append];
            if (exist(folder_name,'dir') == 7)
                rmdir(folder_name);
                mkdir(folder_name);
            else
                mkdir(folder_name);
            end
    else
        fprintf(in_new,'%s\n',str);     
    end   
end


fclose(in_old);
fclose(in_new);