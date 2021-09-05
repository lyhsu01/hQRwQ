#  A high capacity QRD-based blind color image watermarking algorithm with incorporated AI technologies

The watermarking were implemented in Matlab 2020a, and SRCNN was implemented in Python 3.6 with Keras 2.3.1. The hardware is equipped with Intel (R) Core(TM) i9-9900K CPU @ 3.60GHz, 32GB RAM, and RTX 2080 graphics card.


## Watermark embedding (embedding.m)
Description: Embed the watermark image file (logoSMC4.bmp) into the watermark image file (lenaC512.jpg), with the parameters, Key1=0.369, Key2=33, Theta=[2,3,1,4], Lambda=1206.668, Delta=(556.291)/100000, and outputs a watermarked image file (Watermarked.png).

#### Run in Matlab:

    >> embeding
    
#### Result:
>Elapsed time is 4.809258 seconds.<br>
>The watermarked image is generated in the file "Watermarked.png", PSNR: 39.2286dB, MSSIM: 0.99644


## Gaussian lowpass filter image attack (ImageAttack_GaussianLowpassFilter.m)
Description: Use a Gaussian lowpass filter to attack the watermarked image file (Watermarked.png), and outputs a watermarked image file (Watermarked.png).

#### Run in Matlab:

    >> ImageAttack_GaussianLowpassFilter
    
#### Result:
>The attacked image is generated in the file "Watermarked.png"



## Watermark extraction (extraction.m)
Description: Extract the watermark from the watermarked image file (Watermarked.png), with the parameters, Key1=0.369, Key2=33, Theta=[2,3,1,4], Lambda=1206.668, Delta=(556.291)/100000, and outputs a extracted watermark image file (WImgE.png)

#### Run in Matlab:

    >> extraction
    
#### Result:
>Elapsed time is 0.710039 seconds.<br>
>The extracted watermark image is generated in the file "WImgE.png", Error rate: 4.6102%



## Watermark denoised (SRCNNdenoise.py)
Description: Denoise the watermark from the extracted watermark image file (WImgE.png) with the trained model (model.hdf5), and outputs denoised watermark image file (WImgD.png)

#### Run in Spyder (python):

    In [1]: runfile('SRCNNdenoise.py')
    
#### Result:
>Elapsed time is 0.454231 seconds.<br>
>The denoised watermark image is generated in the file "WImgD.png"<br>
>Extracted MSSIM: 0.586, Denoised  MSSIM: 0.991
