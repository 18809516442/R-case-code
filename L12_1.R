
####################���ӻ�ģ������1
Data<-read.table(file="ģʽ���ģ������1.txt",header=TRUE,sep=",")
head(Data)
plot(Data[,1:2],main="�����۲��ķֲ�",xlab="x1",ylab="x2",pch=Data[,3]+1,cex=0.8)  #���ӻ��۲��ֲ�����
####################���ӻ�ģ������2
Data<-read.table(file="ģʽ���ģ������2.txt",header=TRUE,sep=",")
head(Data)
plot(Data[,1:2],main="�����۲��ķֲ�",xlab="x1",ylab="x2",pch=Data[,3]+1,cex=0.8)  #���ӻ��۲��ֲ�����


############ģ�������쳣�����EM����(�޼ල)
Data<-read.table(file="ģʽ���ģ������1.txt",header=TRUE,sep=",")
library("mclust") 
EMfit<-Mclust(data=Data[,-3])  
par(mfrow=c(2,2))
Data$ker.scores<-EMfit$uncertainty  
Data.Sort<-Data[order(x=Data$ker.scores,decreasing=TRUE),]
P<-0.1                     
N<-length(Data[,1])         
NoiseP<-head(Data.Sort,trunc(N*P))
colP<-ifelse(1:N %in% rownames(NoiseP),2,1)
plot(Data[,1:2],main="EM�����ģʽ��Ͻ��(10%)",xlab="x1",ylab="x2",pch=Data[,3]+1,cex=0.8,col=colP)
library("ROCR")
pd<-prediction(Data$ker.scores,Data$y)
pf1<-performance(pd,measure="rec",x.measure="rpp") 
pf2<-performance(pd,measure="prec",x.measure="rec")   
plot(pf1,main="ģʽ�����ۼƻ��ݾ�������")
plot(pf2,main="ģʽ���ľ��߾��Ⱥͻ��ݾ�������")
P<-0.25
NoiseP<-head(Data.Sort,trunc(N*P))
colP<-ifelse(1:N %in% rownames(NoiseP),2,1)
plot(Data[,1:2],main="EM�����ģʽ��Ͻ��(25%)",xlab="x1",ylab="x2",pch=Data[,3]+1,cex=0.8,col=colP)


################ģ�������쳣�����DB��(�޼ල)
Data<-read.table(file="ģʽ���ģ������1.txt",header=TRUE,sep=",")
N<-length(Data[,1])
DistM<-as.matrix(dist(Data[,1:2]))
par(mfrow=c(2,2)) 
(D<-quantile(x=DistM[upper.tri(DistM,diag=FALSE)],prob=0.75))  #�������ķ�λ����Ϊ��ֵD
for(i in 1:N){
 x<-as.vector(DistM[i,])
 Data$DB.scores[i]<-length(which(x>D))/N    #����۲�x�������۲��ľ��������ֵD�ĸ���ռ��
}
Data.Sort<-Data[order(x=Data$DB.score,decreasing=TRUE),]
P<-0.1
NoiseP<-head(Data.Sort,trunc(N*P))
colP<-ifelse(1:N %in% rownames(NoiseP),2,1)
plot(Data[,1:2],main=paste("DB��ģʽ��Ͻ��:p=",P,sep=""),xlab="x1",ylab="x2",pch=Data[,3]+1,cex=0.8,col=colP)
library("ROCR")
pd<-prediction(Data$DB.scores,Data$y)
pf1<-performance(pd,measure="rec",x.measure="rpp") #y��Ϊ���ݾ��ȣ�X��ΪԤ���ģʽռ�������ı���
pf2<-performance(pd,measure="prec",x.measure="rec")   #y��Ϊ���߾��ȣ�X��Ϊ���ݾ���
plot(pf1,main="ģʽ�����ۼƻ��ݾ�������")
plot(pf2,main="ģʽ���ľ��߾��Ⱥͻ��ݾ�������")
P<-0.25
NoiseP<-head(Data.Sort,trunc(N*P))
colP<-ifelse(1:N %in% rownames(NoiseP),2,1)
plot(Data[,1:2],main=paste("DB��ģʽ��Ͻ��:p=",P,sep=""),xlab="x1",ylab="x2",pch=Data[,3]+1,cex=0.8,col=colP)


#############ģ�������쳣�����LOF��(�޼ල)
Data<-read.table(file="ģʽ���ģ������1.txt",header=TRUE,sep=",")
library("DMwR")
lof.scores<-lofactor(data=Data[,-3],k=20)
par(mfrow=c(2,2)) 
Data$lof.scores<-lof.scores
Data.Sort<-Data[order(x=Data$lof.scores,decreasing=TRUE),]
P<-0.1
N<-length(Data[,1])
NoiseP<-head(Data.Sort,trunc(N*P))
colP<-ifelse(1:N %in% rownames(NoiseP),2,1)
plot(Data[,1:2],main="LOF��ģʽ��Ͻ��",xlab="",ylab="",pch=Data[,3]+1,cex=0.8,col=colP)
library("ROCR")
pd<-prediction(Data$lof.scores,Data$y)
pf1<-performance(pd,measure="rec",x.measure="rpp") #y��Ϊ���ݾ��ȣ�X��ΪԤ���ģʽռ�������ı���
pf2<-performance(pd,measure="prec",x.measure="rec")   #y��Ϊ���߾��ȣ�X��Ϊ���ݾ���
plot(pf1,main="ģʽ�����ۼƻ��ݾ�������")
plot(pf2,main="ģʽ���ľ��߾��Ⱥͻ��ݾ�������")

#################ģ�������쳣��������ر�Ҷ˹(�мල)
Data<-read.table(file="ģʽ���ģ������2.txt",header=TRUE,sep=",")
library("klaR")
BayesModel<-NaiveBayes(x=Data[,1:2],grouping=factor(Data[,3]))  #�������ӦΪ����
BayesModel$apriori   #��ʾ�������
BayesModel$tables    #��ʾ���ֲ��Ĳ�������ֵ
plot(BayesModel)    #���ӻ������ֲ�
BayesFit<-predict(object=BayesModel,newdata=Data[,1:2])    #Ԥ��
head(BayesFit$class)  #��ʾԤ�����
head(BayesFit$posterior)     #��ʾ�������
par(mfrow=c(2,2))
plot(Data[,1:2],main="���ر�Ҷ˹�����ģʽ�����",xlab="x1",ylab="x2",
    pch=Data[,3]+1,col=as.integer(as.vector(BayesFit$class))+1,cex=0.8)  #���ӻ��۲��ֲ�����
library("ROCR")
pd<-prediction(BayesFit$posterior[,2],Data$y)
pf1<-performance(pd,measure="rec",x.measure="rpp") #y��Ϊ���ݾ��ȣ�X��ΪԤ���ģʽռ�������ı���
pf2<-performance(pd,measure="prec",x.measure="rec")   #y��Ϊ���߾��ȣ�X��Ϊ���ݾ���
plot(pf1,main="ģʽ�����ۼƻ��ݾ�������")
plot(pf2,main="ģʽ���ľ��߾��Ⱥͻ��ݾ�������")

#################ģ�������쳣�����Logistic�ع�(�мල)
Data<-read.table(file="ģʽ���ģ������2.txt",header=TRUE,sep=",")
(LogModel<-glm(factor(y)~.,data=Data,family=binomial(link="logit")))  
LogFit<-predict(object=LogModel,newdata=Data,type="response")
Data$Log.scores<-LogFit
library("ROCR")
par(mfrow=c(2,2))
pd<-prediction(Data$Log.scores,Data$y)
pf1<-performance(pd,measure="rec",x.measure="rpp") #y��Ϊ���ݾ��ȣ�X��ΪԤ���ģʽռ�������ı���
pf2<-performance(pd,measure="prec",x.measure="rec")   #y��Ϊ���߾��ȣ�X��Ϊ���ݾ���
plot(pf1,main="ģʽ�����ۼƻ��ݾ�������",print.cutoffs.at=c(0.15,0.1))
plot(pf2,main="ģʽ���ľ��߾��Ⱥͻ��ݾ�������")
Data.Sort<-Data[order(x=Data$Log.scores,decreasing=TRUE),]
P<-0.20
N<-length(Data[,1])
NoiseP<-head(Data.Sort,trunc(N*P))
colP<-ifelse(1:N %in% rownames(NoiseP),2,1)
plot(Data[,1:2],main="Logistic�ع��ģʽ�����(20%)",xlab="x1",ylab="x2",pch=Data[,3]+1,cex=0.8,col=colP)
P<-0.30
NoiseP<-head(Data.Sort,trunc(N*P))
colP<-ifelse(1:N %in% rownames(NoiseP),2,1)
plot(Data[,1:2],main="Logistic�ع��ģʽ�����(30%)",xlab="x1",ylab="x2",pch=Data[,3]+1,cex=0.8,col=colP)

#################ģ�������쳣����𣺷�ƽ��������ƽ�⻯����
Data<-read.table(file="ģʽ���ģ������2.txt",header=TRUE,sep=",")
library("DMwR")
Data$y<-factor(Data$y)
set.seed(12345)
newData<-SMOTE(y~.,data=Data,k=5,perc.over=1000,perc.under=200)  
plot(newData[,1:2],main="SMOTE������Ĺ۲��ֲ�",xlab="x1",ylab="x2",pch=as.integer(as.vector(Data[,3]))+1,cex=0.8)
#############SMOTE����ǰ������Ч���Ա�
LogModel<-glm(y~.,data=newData,family=binomial(link="logit"))  
LogFit<-predict(object=LogModel,newdata=Data,type="response")  
Data$Log.scores<-LogFit
library("ROCR")
par(mfrow=c(2,2))
pd<-prediction(Data$Log.scores,Data$y)
pf1<-performance(pd,measure="rec",x.measure="rpp") 
pf2<-performance(pd,measure="prec",x.measure="rec")   
plot(pf1,main="ģʽ�����ۼƻ��ݾ�������")
plot(pf2,main="ģʽ���ľ��߾��Ⱥͻ��ݾ�������")
Data.Sort<-Data[order(x=Data$Log.scores,decreasing=TRUE),]
P<-0.30
N<-length(Data[,1])
NoiseP<-head(Data.Sort,trunc(N*P))
colP<-ifelse(1:N %in% rownames(NoiseP),2,1)
plot(Data[,1:2],main="SMOTE�������ģʽ�����(30%)",xlab="x1",ylab="x2",pch=as.integer(as.vector(Data[,3]))+1,cex=0.8,col=colP)
LogModel<-glm(y~.,data=Data,family=binomial(link="logit"))   
LogFit<-predict(object=LogModel,newdata=Data,type="response")
Data$Log.scores<-LogFit
Data.Sort<-Data[order(x=Data$Log.scores,decreasing=TRUE),]
NoiseP<-head(Data.Sort,trunc(N*P))
colP<-ifelse(1:N %in% rownames(NoiseP),2,1)
plot(Data[,1:2],main="ƽ�⻯����ǰ��ģʽ�����(30%)",xlab="x1",ylab="x2",pch=as.integer(as.vector(Data[,3]))+1,cex=0.8,col=colP)

###########ģ�������쳣����𣺰�ල
Data<-read.table(file="ģʽ���ģ������3.txt",header=TRUE,sep=",")
par(mfrow=c(2,2))
plot(Data[,1:2],main="�����۲��ķֲ�",xlab="x1",ylab="x2",pch=Data[,3]+1,cex=0.8)
library("DMwR")
Data[which(Data[,3]==3),3]<-NA
Data$y<-factor(Data$y)
mySelfT<-function(ModelName,TestD)
{
 Yheat<-predict(object=ModelName,newdata=TestD,type="response") 
 return(data.frame(cl=ifelse(Yheat>=0.1,1,0),pheat=Yheat))
}
SemiT<-SelfTrain(y~.,data=Data,
 learner("glm",list(family=binomial(link="logit"))),
 predFunc="mySelfT",thrConf=0.02,maxIts=100,percFull=1)   
SemiP<-predict(object=SemiT,newdata=Data,type="response")   
Data$SemiP<-SemiP
Data.Sort<-Data[order(x=Data$SemiP,decreasing=TRUE),]
P<-0.30
N<-length(Data[,1])
NoiseP<-head(Data.Sort,trunc(N*P))
colP<-ifelse(1:N %in% rownames(NoiseP),2,1)
a<-as.integer(as.vector(Data[,3]))
plot(Data[,1:2],main="��ѵ��ģʽ�����(30%)",xlab="x1",ylab="x2",pch=ifelse(is.na(a),3,a)+1,cex=0.8,col=colP)

