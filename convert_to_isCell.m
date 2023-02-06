function [cell_stat,redcell_vect,Fall]= convert_to_isCell(Fall,redcell_vect)

% convert stat and redcell_vect to be in isCell==1 coordinates 

stat=Fall.stat;

iscell=Fall.iscell;



cell_stat=stat(iscell(:,1)==1); % reduce stat to only iscells  

redcell_vect=redcell_vect(iscell(:,1)==1);

Fall.redcell_vect=redcell_vect; 

end

