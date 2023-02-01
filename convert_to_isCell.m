function [cell_stat,red_cell_vect,Fall]= convert_to_isCell(Fall,red_cell_vect)

% convert stat and redcell_vect to be in isCell==1 coordinates 

stat=Fall.stat;

iscell=Fall.iscell;



cell_stat=stat(iscell(:,1)==1); % reduce stat to only iscells  

red_cell_vect=red_cell_vect(iscell(:,1)==1);

Fall.red_cell_vect=red_cell_vect; 

end

