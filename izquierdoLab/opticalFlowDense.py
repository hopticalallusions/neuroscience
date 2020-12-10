import numpy as np
import cv2 as cv
#cap = cv.VideoCapture(cv.samples.findFile("RatTY4_Rev_CNO_092820.mp4"))
#
#cap = cv.VideoCapture(cv.samples.findFile("~/data/izquierdo/WyzeTest_JL14/raw/44.mp4"))
cap = cv.VideoCapture(cv.samples.findFile("44.mp4"))

backSub = cv.createBackgroundSubtractorMOG2()


ret, frame1 = cap.read()
prvs = cv.cvtColor(frame1,cv.COLOR_BGR2GRAY)
hsv = np.zeros_like(frame1)
hsv[...,1] = 255
while(1):
    ret, frame2 = cap.read()
    
    fgMask = backSub.apply(prvs)
#    notMask = cv.bitwise_not(fgMask)
#    videoPart=cv.bitwise_and(frame2, frame2, fgMask = notMask)
   
#    next = cv.cvtColor(frame2,cv.COLOR_BGR2GRAY)
    next = cv.cvtColor(frame2,cv.COLOR_BGR2GRAY)
    #cv.calcOpticalFlowFarneback( 8-bit input image , output pyramid , window size , max level, with derivatives, border mode for pyramid , border mode for gradients , ROI of input image )
    flow = cv.calcOpticalFlowFarneback(prvs,next, None, 0.9, 3, 15, 3, 5, 1.2, 0)
    mag, ang = cv.cartToPolar(flow[...,0], flow[...,1])
    hsv[...,0] = ang*180/np.pi/2
    hsv[...,2] = cv.normalize(mag,None,0,255,cv.NORM_MINMAX)
    bgr = cv.cvtColor(hsv,cv.COLOR_HSV2BGR)
    cv.imshow('frame2',bgr)
    k = cv.waitKey(30) & 0xff
    if k == 27:
        break
    elif k == ord('s'):
        cv.imwrite('opticalfb.png',frame2)
        cv.imwrite('opticalhsv.png',bgr)
    prvs = next