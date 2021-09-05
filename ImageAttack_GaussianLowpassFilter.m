Yb=double(imread('Watermarked.png'));
H = fspecial('gaussian',3); 
Yout = imfilter(Yb,H,'replicate');
imwrite(uint8(Yout),'Watermarked.png');
disp('The attacked image is generated in the file "Watermarked.png"'); 
