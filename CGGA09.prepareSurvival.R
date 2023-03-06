setwd("C://Users//����//Desktop//TBCCD1//1.TCGA���ݿ�//1.��������//09.prepareSurvival")                         #�޸Ĺ���Ŀ¼
expFile="rocSigExp.txt"                                                              #���������ļ�
clinicalFile="clinicalNum.txt"                                                       #�ٴ������ļ�
gene="TBCCD1"

exp=read.table(expFile,sep="\t",header=T,check.names=F,row.names=1)                #��ȡ���������ļ�
cli=read.table(clinicalFile,sep="\t",header=T,check.names=F,row.names=1)           #��ȡ�ٴ������ļ�
samSample=intersect(row.names(exp),row.names(cli))
exp=exp[samSample,]
cli=cli[samSample,]
selectCol=c("futime","fustat",gene)
outTab=cbind(exp[,selectCol],cli)
outTab=cbind(id=row.names(outTab),outTab)
write.table(outTab,file="singleGeneSurData.txt",sep="\t",row.names=F,quote=F)
