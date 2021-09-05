Key1=0.369;
Key2=33; 
Theta=[2,3,1,4];
Lambda=1206.668; Delta=(556.291)/100000;

tic;
Y=double(imread('lenaC512.jpg'));
wm1 = imread('logoSMC4.bmp'); 

WM1=zeros(128,128,6);

for c=1:3
    w1=de2bi(wm1(:,:,c),8);
    WMa=reshape(w1,128,128,2);
    for i=1:2
        WM1(:,:,2*c-2+i)=Arnoldplus(WMa(:,:,i),Key2,0,Key1);
    end
end     

ws=128;  
MBrn=4; MBcn=4;
sigma=0.5;
WMb=zeros(128,128,6);
for c=1:3
    for kr=1:ws
        for kc=1:ws
            Org=Y((kr-1)*MBrn+(1:MBrn),(kc-1)*MBcn+(1:MBcn),c);
            Org1=Org;
            count1=0;
            while 1                  
                mm=mean(Org(:));
                MBtmp=Org+Lambda-mm;   
                [q,r]=qr(MBtmp); 
                
                U1=q;
                a=U1(Theta(1)); b=U1(Theta(2));
                dthd=0.5*Delta;
                lo=1.5*Delta;
                lambda=1*Delta;
                eta=2*Delta;

                D2=Delta*2;
                g=a-b;

                if WM1(kr,kc,2*c-1) % ==1
                    g1=min([lambda max([g dthd])]);
                else
                    g1=max([-lambda min([g -dthd])]);
                end
                newg=g1; mtype=1;
                if g>lo
                    if WM1(kr,kc,2*c-1)==0
                        g2=floor((g-eta)/D2+0.5)*D2+eta;
                    else
                        g2=max([0 floor((g-eta)/D2)])*D2+Delta+eta;
                    end
                    if abs(g2-g)<abs(g1-g)
                        newg=g2; mtype=2;
                    end
                elseif g<-lo
                    if WM1(kr,kc,2*c-1)==1
                        g2=ceil((g+eta)/D2-0.5)*D2-eta;
                    else
                        g2=min([0 ceil((g+eta)/D2)])*D2-Delta-eta;
                    end
                    if abs(g2-g)<abs(g1-g)
                        newg=g2; mtype=2;
                    end
                end

                lambD=newg;
                if newg==g
                    q=U1;
                else 
                    dtmp1=0.5*(lambD+b-a);
                    cof=[2 (2*a+2*(a-lambD)) (a-lambD)^2-b^2];
                    p=roots(cof);
                    if imag(p(1))==0
                        if abs(p(1))<abs(p(2))
                            dtmp2=p(1);
                        else
                            dtmp2=p(2);
                        end
                    else
                        dtmp2=0.5*lambD-a;
                    end

                    if mtype==1
                        w1=0.25; 
                    else 
                        w1=0.5;
                    end
                    d=w1*dtmp1+(1-w1)*dtmp2;

                    q=U1;
                    newa=a+d;
                    newb=a+d-lambD;
                    q(Theta(1:2),1)=[newa newb];
                end
                                    
                U1=q;
                a=U1(Theta(3)); b=U1(Theta(4));
                dthd=0.5*Delta;
                lo=1.5*Delta;
                lambda=1*Delta;
                eta=2*Delta;

                D2=Delta*2;
                g=a-b;

                if WM1(kr,kc,2*c) % ==1
                    g1=min([lambda max([g dthd])]);
                else
                    g1=max([-lambda min([g -dthd])]);
                end
                newg=g1; mtype=1;
                if g>lo
                    if WM1(kr,kc,2*c)==0
                        g2=floor((g-eta)/D2+0.5)*D2+eta;
                    else
                        g2=max([0 floor((g-eta)/D2)])*D2+Delta+eta;
                    end
                    if abs(g2-g)<abs(g1-g)
                        newg=g2; mtype=2;
                    end
                elseif g<-lo
                    if WM1(kr,kc,2*c)==1
                        g2=ceil((g+eta)/D2-0.5)*D2-eta;
                    else
                        g2=min([0 ceil((g+eta)/D2)])*D2-Delta-eta;
                    end
                    if abs(g2-g)<abs(g1-g)
                        newg=g2; mtype=2;
                    end
                end

                lambD=newg;
                if newg==g
                    q=U1;
                else 
                    dtmp1=0.5*(lambD+b-a);
                    cof=[2 (2*a+2*(a-lambD)) (a-lambD)^2-b^2];
                    p=roots(cof);
                    if imag(p(1))==0
                        if abs(p(1))<abs(p(2))
                            dtmp2=p(1);
                        else
                            dtmp2=p(2);
                        end
                    else
                        dtmp2=0.5*lambD-a;
                    end

                    if mtype==1
                        w1=0.25; 
                    else 
                        w1=0.5;
                    end
                    d=w1*dtmp1+(1-w1)*dtmp2;

                    q=U1;
                    newa=a+d;
                    newb=a+d-lambD;
                    q(Theta(3:4),1)=[newa newb];
                end
                
                q=VGramSchmidt(q);
                
                rr=zeros(4);
                for i=1:4
                    for j=1:i
                        rr(j,i)=sum(MBtmp(:,i).*q(:,j));
                    end
                end
                MBtt=double(uint8(q*rr-Lambda+mm));
                mm=mean(MBtt(:));
                [q,r]=qr(MBtt+Lambda-mm);
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
                if WMb(kr,kc,2*c-1)==WM1(kr,kc,2*c-1) && WMb(kr,kc,2*c)==WM1(kr,kc,2*c)
                    break;
                else                    
                    if WM1(kr,kc,2*c-1)~=WMb(kr,kc,2*c-1) 
                        DD=Theta(1);EE=Theta(2);
                        if WM1(kr,kc,2*c-1)==1
                            BB=Org(DD,:)>=128;
                            Org(DD,BB)=Org(DD,BB)-sigma;
                            BB=Org(EE,:)<128;
                            Org(EE,BB)=Org(EE,BB)+sigma;
                        else
                            BB=Org(EE,:)>=128;
                            Org(EE,BB)=Org(EE,BB)-sigma;
                            BB=Org(DD,:)<128;
                            Org(DD,BB)=Org(DD,BB)+sigma;
                        end
                        
                    end
                    if WM1(kr,kc,2*c)~= WMb(kr,kc,2*c)
                        DD=Theta(3);EE=Theta(4);
                        if WM1(kr,kc,2*c)==1
                            BB=Org(DD,:)>=128;
                            Org(DD,BB)=Org(DD,BB)-sigma;
                            BB=Org(EE,:)<128;
                            Org(EE,BB)=Org(EE,BB)+sigma;
                        else
                            BB=Org(EE,:)>=128;
                            Org(EE,BB)=Org(EE,BB)-sigma;
                            BB=Org(DD,:)<128;
                            Org(DD,BB)=Org(DD,BB)+sigma;
                        end
                    end
                end
            end
            IMBtmp=MBtt;
            Yb((kr-1)*MBrn+(1:MBrn),(kc-1)*MBcn+(1:MBcn),c)=IMBtmp;
            
        end
    end
end
imwrite(uint8(Yb),'Watermarked.png');
toc

PSNRb = psnr(uint8(Y), uint8(Yb));
mSSIM = ssim(Y, Yb);
disp(['The watermarked image is generated in the file "Watermarked.png", PSNR: ', num2str(PSNRb),'dB, MSSIM: ', num2str(mSSIM)] ); 

function V=VGramSchmidt(V)
    V(:,1)=V(:,1)/norm(V(:,1));
    for ki=2:4
        for kj=1:ki-1
            V(:,ki)=V(:,ki)-sum(V(:,kj).*V(:,ki))*V(:,kj);
        end
        V(:,ki)=V(:,ki)/norm(V(:,ki));
    end
end