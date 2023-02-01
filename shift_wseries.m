function [shift]=shift_wseries(img)



yr= nan(512,1023);% each row is the xcorr of the y from each image
ylag=nan(1023,1); % just a list of the lags that can be overriden every time in the for loop 
xr= nan(512,1023);% xcorr of the x 
xlag=nan(1023,1);


for x_or_y=1:512
    [xr(x_or_y,:),xlag(:)]=xcorr(img.wsRef(x_or_y,:),img.fRef(x_or_y,:));
    [yr(x_or_y,:),ylag(:)]=xcorr(img.wsRef(:,x_or_y),img.fRef(:,x_or_y));

end

xr=squeeze(mean(xr,1));
yr=squeeze(mean(yr,1));

xshift=find(xr==max(xr)); % find coordinate where the max xcorr is 
yshift=find(yr==max(yr));

xshift=xlag(xshift); %index into the lags to determine how much of a pixel shift that is 
yshift=ylag(yshift);

shift=[xshift, yshift]; 



end

