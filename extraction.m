Key1=0.369;
Key2=33; 
Theta=[2,3,1,4];
Lambda=1206.668; Delta=(556.291)/100000;

tic;
Ytest=double(imread('Watermarked.png')); %'Watermarked.png .jp2 .jpg
ws=128;  
MBrn=4; MBcn=4;
WMb=zeros(ws,ws,6);
for c=1:3
    for kr=1:ws
        for kc=1:ws            
            MBtmp=Ytest((kr-1)*MBrn+(1:MBrn),(kc-1)*MBcn+(1:MBcn),c);
            mm=mean(MBtmp(:));    
            [q,r]=qr(MBtmp-mm+Lambda);
            gb=q(Theta(1),1)-q(Theta(2),1);
            lo=1.5*Delta;
            eta=2*Delta;
            if gb>lo
                WMb(kr,kc,2*c-1)=mod(floor((gb-eta)/Delta+0.5),2);
            elseif gb<-lo
                WMb(kr,kc,2*c-1)=mod(ceil((gb+eta)/Delta-0.5)-1,2);
            else
                WMb(kr,kc,2*c-1)=(gb>=0);
            end
            gb=q(Theta(3),1)-q(Theta(4),1);
            lo=1.5*Delta;
            eta=2*Delta;
            if gb>lo
                WMb(kr,kc,2*c)=mod(floor((gb-eta)/Delta+0.5),2);
            elseif gb<-lo
                WMb(kr,kc,2*c)=mod(ceil((gb+eta)/Delta-0.5)-1,2);
            else
                WMb(kr,kc,2*c)=(gb>=0);
            end
        end
    end
end

for c=1:3
    for i=1:2
        WM(:,:,i)=Arnoldplus(WMb(:,:,2*c-2+i),Key2,1,Key1);
    end
    wc=reshape(WM,64*64,8);        
    WMc(:,:,c)=reshape(bi2de(wc),64,64);
end 
imwrite(uint8(WMc),'WImgE.png');
toc


wm1 = imread('logoSMC4.bmp');
WM1=zeros(128,128,6);
wm2 = imread('WImgE.png');
WM2=zeros(128,128,6);

for c=1:3
    w1=de2bi(wm1(:,:,c),8);
    WM1(:,:,2*c-1:2*c)=reshape(w1,128,128,2);
    w2=de2bi(wm2(:,:,c),8);
    WM2(:,:,2*c-1:2*c)=reshape(w2,128,128,2);
end    

err=WM2~=WM1;
error_rate=sum(err(:))/numel(WM2);

disp(['The extracted watermark image is generated in the file "WImgE.png", Error rate: ', num2str(error_rate*100), '%'] ); 


% system('C:\Users\lyhsu\anaconda3\Scripts\activate tsf')
% system('C:\Users\lyhsu\anaconda3\envs\tsf\python.exe SRCNNrefined.py') 