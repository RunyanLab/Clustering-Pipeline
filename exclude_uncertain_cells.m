function exclude_uncertain_cells(info,clustering_info)
excluded_cells = union(clustering_info.excluded,clustering_info.uncertain);

cd(strcat(info.servernum,info.savepathstr,info.mouse,'\',info.date));
disp('Select the folder where dff/z_dff are saved...');
dff_directory = uigetdir;
cd(dff_directory)

load('dff.mat'); load('z_dff.mat')
%save original variables
save('dff_no_excluded.mat','dff');
save('z_dff_no_excluded.mat','z_dff');
% exclude uncertain/bad cells
dff(excluded_cells,:) = [];
z_dff(excluded_cells,:) = [];
save('dff','dff'); save('z_dff','z_dff');

disp('Select the folder where deconvolved data is saved...');
deconv_directory = uigetdir;
cd(deconv_directory)

load('deconv.mat'); 
%save original variables
save('deconv_no_excluded.mat','deconv');
% exclude uncertain/bad cells
deconv(excluded_cells,:) = [];
save('deconv','deconv');