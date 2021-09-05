import cv2
import numpy as np
from tensorflow.keras.models import load_model
from skimage.metrics import structural_similarity as ssim
import time


def get_image(image):
    image = np.clip(image, 0, 255)
    return image.astype(dtype=np.uint8)

model=load_model('model.hdf5', compile=False)
time_1 = time.time()
image = cv2.imread('WImgE.png')
noise_image=image
pred = model.predict(np.expand_dims(noise_image, 0))

time_2 = time.time()
time_interval = time_2 - time_1
print('Elapsed time is %7.6f seconds.'%(time_interval))
DImg = get_image(pred[0])

OImg = cv2.imread('logoSMC4.bmp')
Omssim=ssim(OImg.astype(dtype=np.float), image.astype(dtype=np.float),multichannel=True)
mssim =ssim(OImg.astype(dtype=np.float), DImg.astype(dtype=np.float),multichannel=True)
cv2.imwrite("WImgD.png", DImg)
print('The denoised watermark image is generated in the file "WImgD.png"');
print('Extracted MSSIM: %5.3f, Denoised  MSSIM: %5.3f'%(Omssim, mssim))
