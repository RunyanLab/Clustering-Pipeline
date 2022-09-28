function [all_cellocs,cell_stat,redcell_idx]= get_stat(Fall,redcell_idx)

% objective: get 512x512xnumcells matrix with each of the soma-masks for
% the cells 

stat=Fall.stat;

iscell=Fall.iscell;

cell_stat=stat(iscell(:,1)==1); % reduce stat to only iscells  


redcell_idx=redcell_idx(iscell(:,1)==1);

%%

numcells=sum(iscell(:,1)==1);

all_cellocs=nan(512,512,numcells);

for i = 1 : numcells
    
    mask=zeros(512,512);
    curstat=cell_stat{i};
    xpix=curstat.xpix(curstat.soma_crop==1);
    ypix=curstat.ypix(curstat.soma_crop==1);
    
    xpix=xpix+xshift;
    ypix=ypix+yshift;

      for k=1:length(xpix)
             curxpix=xpix(k);
             curypix=ypix(k);
             mask(curypix+1,curxpix+1)=1;%(curypix,curxpix) to get correct location; add +1 bc python to MATLAB
             
      end
    all_cellocs(:,:,i)=mask;

end


red_cellocs=all_cellocs(:,:,redcell_idx);


