

#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("limma")

#install.packages("ggpubr")
#install.packages("ggExtra")


#���ð�
library(limma)
library(reshape2)
library(ggpubr)
library(ggExtra)

gene="TBCCD1"                    #��������
expFile="symbol.txt"      #��������ļ�
geneFile="gene.txt"            #�����б��ļ�
setwd("C://Users//����//Desktop//3. TBCCD1����ϸ��//7. checkpoint")     #���ù���Ŀ¼

#��ȡ���������ļ�,�������ݽ�������
rt=read.table(expFile, header=T, sep="\t", check.names=F)
rt=as.matrix(rt)
rownames(rt)=rt[,1]
exp=rt[,2:ncol(rt)]
dimnames=list(rownames(exp), colnames(exp))
data=matrix(as.numeric(as.matrix(exp)), nrow=nrow(exp), dimnames=dimnames)
data=avereps(data)

#ɾ��������Ʒ
#group=sapply(strsplit(colnames(data),"\\-"), "[", 4)
#group=sapply(strsplit(group,""), "[", 1)
#group=gsub("2", "1", group)
#data=data[,group==0]

#��ȡ�����б��ļ�
geneRT=read.table(geneFile, header=T, sep="\t", check.names=F)

#����Լ���
outTab=data.frame()
for(k in 1:nrow(geneRT)){
	i=geneRT[k,2]      #��ȡ����ϸ����marker����
	if(i %in% row.names(data)){
		if(sd(data[i,])>0.01){
			#����Է���
			x=as.numeric(data[gene,])
			y=as.numeric(data[i,])
			corT=cor.test(x, y, method="spearma")
			cor=corT$estimate
			pvalue=corT$p.value
			outTab=rbind(outTab,cbind(immuneCell=geneRT[k,1], gene=i, cor, pvalue))
				
			#���������ɢ��ͼ
			df1=as.data.frame(cbind(x,y))
			p1=ggplot(df1, aes(x, y)) + 
					  xlab(paste0(gene, " expression")) + 
					  ylab(paste0(i, " expression")) +
					  geom_point() + geom_smooth(method="lm",formula = y ~ x) + theme_bw()+
					  stat_cor(method = 'spearman', aes(x =x, y =y))
			p2=ggMarginal(p1, type="density", xparams=list(fill = "orange"), yparams=list(fill = "blue"))
			
			#���������ͼ��
			pdf(file=paste0("cor.",gene,"_",i,".pdf"), width=5.2, height=5)
			print(p2)
			dev.off()
		}
	}
}

#�������Խ��
write.table(file="geneCor.result.txt",outTab,sep="\t",quote=F,row.names=F)

