function[weighted_intensities]= weight_intensities(all_intensities,combos)

wave_tally= zeros(size(all_intensities,2),1);

for i =1:length(combos)
    cur_waves=combos{i};

    for j=1:length(cur_waves)
        wave_tally(j)=wave_tally(j)+1;
    end
end


delete_vect=nan(size(all_intensities,2)); 

for i =1:length(delete_vect)
    if wave_tally(i)==0
        delete_vect(i)=1;
    end
end

all_intensities(:,delete_vect==1)=[];

wave_tally(delete_vect==1)=[];

wave_tally= wave_tally/min(wave_tally); 

wave_tally=wave_tally/max(wave_tally);

wave_tally=wave_tally+1;

for i = 1:length(wave_tally)
    all_intensities(:,i)=all_intensities(:,i)*wave_tally(i);
end

weighted_intensities=all_intensities;
end
