function M=Arnoldplus(Image,Frequency,crypt,key) 
    if nargin<3 
        disp('error!!!'); 
        return; 
    end 

    if crypt~=0 & crypt~=1 
        disp('encrypt must be 0 or 1!');
    end 

    % modification
    if ~exist('key','var'), key=0.93; end % for skew tent map
    Q=Image; 
    if crypt==0, 
        [kr kc]=size(Image);kno=kr*kc;
        if ~exist('va','var'), va=0.66; end
        if ~exist('vb','var'), vb=0.5; end
        x(1)=key;
        for k=2:kno            
            if x(k-1)<va
                x(k)=x(k-1)/va;
            else
                x(k)=(1-x(k-1))/(1-va);
            end
        end
        Xskm=reshape(x>=vb,kr,kc);
        Q= xor(Image,Xskm);
    end

    M = Q ;
    Size_Q   = size(Q); 

    if (length(Size_Q) == 2)  
       if Size_Q(1) ~= Size_Q(2)  
          disp('It cannot perform Arnold Transform!'); 
          return 
       end 
    else 
       disp('It cannot perform Arnold Transform!'); 
       return  
    end 


    n = 0; 
    K = Size_Q(1); 

    M1_t = Q; 
    M2_t = Q; 

    if crypt==1  
       Frequency=ArnoldPeriod( Size_Q(1) )-Frequency; 
    end 

    for s = 1:Frequency 
       n = n + 1; 
       if mod(n,2) == 0 
            for i = 1:K 
               for j = 1:K 
                  c = M2_t(i,j); 
                  M1_t(mod(i+j-2,K)+1,mod(i+2*j-3,K)+1) = c; 
               end 
            end 
       else 
            for i = 1:K 
               for j = 1:K 
                   c = M1_t(i,j); 
                   M2_t(mod(i+j-2,K)+1,mod(i+2*j-3,K)+1) = c; 
               end 
            end 
       end 
    end 

    if mod(Frequency,2) == 0 
      M = M1_t; 
    else 
      M = M2_t; 
    end 
    if crypt==1, 
        [kr kc]=size(M);kno=kr*kc;
        if ~exist('va','var'), va=0.66; end
        if ~exist('vb','var'), vb=0.5; end
        x(1)=key;
        for k=2:kno
            if x(k-1)<va
                x(k)=x(k-1)/va;
            else
                x(k)=(1-x(k-1))/(1-va);
            end
        end
        Xskm=reshape(x>=vb,kr,kc);
        M= xor(M,Xskm);
    end %modification
end  
   
function Period=ArnoldPeriod(N) 
    if ( N<2 ) 
        Period=0; 
        return; 
    end 

    n=1; 
    x=1; 
    y=1; 
    while n~=0 
        xn=x+y; 
        yn=x+2*y; 
        if ( mod(xn,N)==1 && mod(yn,N)==1 ) 
            Period=n; 
            return; 
        end 
        x=mod(xn,N); 
        y=mod(yn,N); 
        n=n+1; 
    end
end

