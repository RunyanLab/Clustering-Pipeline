function [manual_intensities, manual_intensities2,cellocs] = findintensities_s2pcentroids(red_wavelength_stack,centroids)
npocks=size(red_wavelength_stack,1);
nwaves=size(red_wavelength_stack,2);


manual_intensities=zeros(size(centroids,1),npocks*nwaves);% intensities is a w, p, idx matrix for avg brightness of each red cell
manual_intensities2=zeros(size(centroids,1),npocks*nwaves);% intensities2 is a P, w, idx matrix for avg brightness of each red cell

cellocs=nan(512,512,size(centroids,1));

temp=zeros(npocks,nwaves);
temp2=zeros(nwaves,npocks);

count=1;
for idx = 1:size(centroids)
    
    cellarea=zeros(512,512);
    
    cx=centroids(idx,1);
    cy=centroids(idx,2);
    

    
    cellarea([cx-1 cx cx+1],[cy-1 cy cy+1])=1;

    cellocs(:,:,idx)=cellarea;
    for p=1:npocks
        for w=1:nwaves
            curstack=squeeze(red_wavelength_stack(p,w,:,:));
            selectedvals=curstack(cellarea==1);
            temp(p,w)=mean(selectedvals);
            temp2(w,p) = mean(selectedvals);
            
            
            count = count+1;
        end
    end
    flat=temp(:);
    flat2=temp2(:);
    manual_intensities(idx,:) = flat; %organized by p x w
    manual_intensities2(idx,:)=flat2; %organized by w x p 
    count=1;
end

