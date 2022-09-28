function [cell_stat,redcell_idx]= convert_to_isCell(Fall,redcell_idx)

% convert stat and redcell_vect to be in isCell==1 coordinates 

stat=Fall.stat;

iscell=Fall.iscell;

cell_stat=stat(iscell(:,1)==1); % reduce stat to only iscells  


redcell_idx=redcell_idx(iscell(:,1)==1);


