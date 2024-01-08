function plot_cluster_performance (silhouettes,info)

mouse=info.mouse;
date=info.date;


if ismember('xtrafolder',fieldnames(info))
    titlestr=[mouse,' ',date,' ',xtrafolder];
else
    titlestr=[mouse,' ',date];
end

fullstring={titlestr};
%% statistics on silhouette scores

stdev=std(silhouettes);
average=mean(silhouettes);
above1=sum(silhouettes>.1);
above2=sum(silhouettes>.2);
above3=sum(silhouettes>.3);

[sorted_sil,~]=sort(silhouettes,"ascend");

params=fit_silhouettes(silhouettes);

%%
figure()
sgtitle(fullstring)




subplot(2,1,1)
barg=bar(silhouettes);
xlabel('Cell Number')
ylabel('Silhouette Score')

numcells=length(silhouettes);

yline(average,'LineWidth',2,'Color','r')
yline(average-stdev,'LineWidth',1,'color','k')

subplot (2,1,2)
histg=histogram(silhouettes,length(silhouettes));
xlabel('Silhouette Score')
ylabel('Frequency')
% text(min(histg.BinEdges),max(histg.Values)*.9,[num2str(above1),'/',num2str(numcells),' cells above .1 threshold'],'Color','r')
% text(min(histg.BinEdges),max(histg.Values)*.8,[num2str(above2),'/',num2str(numcells),' cells above .2'],'Color','r')
% text(min(histg.BinEdges),max(histg.Values)*.7,[num2str(above3),'/',num2str(numcells),' cells above .3'],'Color','r')

text(min(histg.BinEdges),max(histg.Values)*.9,['average score: ',num2str(round(average,2))],'Color','r')
text(min(histg.BinEdges),max(histg.Values)*.8,['standard dev: ',num2str(round(stdev,2))],'Color','r')
text(min(histg.BinEdges),max(histg.Values)*.6,['alpha ',num2str(round(params(1),2))],'Color','r')
text(min(histg.BinEdges),max(histg.Values)*.5,['beta: ',num2str(round(params(2),2))],'Color','r')
text(min(histg.BinEdges),max(histg.Values)*.4,['loglikihood: ',num2str(round(params(3),2))],'Color','r')


xline(average,"LineWidth",2,'Color','r')
xline(average+stdev)
xline(average-stdev)

