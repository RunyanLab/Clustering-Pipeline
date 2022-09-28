function[final_redcells]=add_redcells(redcell_vect,toadd)

for i =1:length(toadd)
    redcell_vect(toadd(i))=1;
end


final_redcells=redcell_vect; 

