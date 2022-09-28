function[final_ids]=make_final_ids(final_red_vect,final_ident)
% function to make sure that mcherry==1 and tdtomato==2


final_ids=nan(length(final_red_vect),1);
count=1;
for i =1:length(final_ids)

    if final_red_vect(i)==0
        final_ids(i)=0;
    elseif final_red_vect(i)==1
        if final_ident(count)==1
            final_ids(i)=1;
        elseif final_ident(count)==2
            final_ids(i)=2;
        end
        count=count+1;
    end
end

