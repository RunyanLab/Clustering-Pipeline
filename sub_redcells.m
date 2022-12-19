function[final_redcells]=sub_redcells(redcell_vect,toadd)

for i =1:length(toadd)
    redcell_vect(toadd(i))=0;
end


final_redcells=redcell_vect; 

end