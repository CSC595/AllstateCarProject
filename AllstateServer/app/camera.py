import time
import threading
from picamera import PiCamera
from picamera.array import PiRGBArray
import cv2
import numpy as np
import io
import datetime


eyeClassifier = cv2.CascadeClassifier("haarcascade_eye_tree_eyeglasses.xml")
noseClassifier = cv2.CascadeClassifier("haarcascade_mcs_nose.xml")

h = 300
w = 400
minEyeSize = (w/18,h/18)
maxEyeSize = (w/10,h/10)
minNoseSize = (w/15,h/15)
maxNoseSize = (w/8,h/8)

class Camera(object):
    isLookingAround = ''
    isSavePic = False
    isWorking = False
    thread = None
    img = None
    lastFoundEyesTime = None
    lastFoundNoseTime = None
    loadings = [open('app/static/loading/' + name + '.jpg','rb').read() for name in['loading1', 'loading2', 'loading3']]
    
    nx = 0
    ny = 0
    nw = 0
    nh = 0
    
    def start(self):
        if Camera.thread is None:
            Camera.thread = threading.Thread(target=self._thread)
            Camera.isWorking = True
            Camera.isLookingAround = 'no'
            Camera.thread.start()

    def stop(self):
        Camera.isWorking = False
        lastFoundNoseTime = None
        lastFoundEyesTime = None
        Camera.thread = None
        Camera.img = None
        Camera.isLookingAround = ''

    def get_frame(self):
        self.start()
        if Camera.img is None:
            return self.loadings[int(time.time())%3]
        return Camera.img

    @classmethod
    def _thread(cls):
        camera = PiCamera()
        camera.resolution = (w,h)
        camera.framerate = 30
        time.sleep(1)
        
        i = 0
        stream = io.BytesIO()
        for pic in camera.capture_continuous(stream, format="jpeg",use_video_port=True):
            if cls.isWorking == False:
                camera.close()
            data = np.fromstring(stream.getvalue(), dtype=np.uint8) 
            frame = cv2.imdecode(data,1)

            if i >= 2:
               
                i = 0
                image = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                
                noseRects = noseClassifier.detectMultiScale(image,1.2,2,cv2.CASCADE_SCALE_IMAGE,minNoseSize,maxNoseSize)
                if len(noseRects) > 0:
                    cls.lastFoundNoseTime = None
                    cls.isLookingAround = 'no'
                    cls.isSavePic = False
                    for noseRect in noseRects:
                        cls.nx,cls.ny,cls.nw,cls.nh=noseRect
                        cv2.circle(frame,(cls.nx + cls.nw/2,cls.ny + cls.nh/2),min(cls.nw/2,cls.nh/2),(0,255,0))
                else:
                    cls.nx = 0
                    cls.ny = 0
                    cls.nw = 0
                    cls.nh = 0
                    if cls.lastFoundNoseTime == None:
                        cls.lastFoundNoseTime = time.time()
                    elif time.time() - cls.lastFoundNoseTime > 1.5:
                       # print(datetime.datetime.now().strftime('%Y/%m/%d %H:%m:%S.%f')[:-3] + '   NOT Found Nose!') 
                        cls.isLookingAround = 'yes'
                        if cls.isSavePic == False:
                            cls.isSavePic = True
                            cv2.imwrite('FaceDetection.png', frame)

                eyeRects = eyeClassifier.detectMultiScale(image,1.2,2,cv2.CASCADE_SCALE_IMAGE,minEyeSize,maxEyeSize)
                if len(eyeRects) > 0:
                    cls.isLookingAround = 'no'
                    cls.isSavePic = False
                    cls.lastFoundEyesTime = None
                    for eyeRect in eyeRects:
                        ex,ey,ew,eh = eyeRect
                        cv2.circle(frame,(ex + ew/2,ey + eh/2),min(ew/2,eh/2),(0,0,255))
                else: 
                    if cls.lastFoundEyesTime == None:
                        cls.lastFoundEyesTime = time.time()
                    elif time.time() - cls.lastFoundEyesTime > 1.5:
                       # print(datetime.datetime.now().strftime('%Y/%m/%d %H:%m:%S.%f')[:-3] + '   NOT Found Eyes!')
                        if cls.lastFoundNoseTime != None and time.time() - cls.lastFoundNoseTime > 1.5:
                            cls.isLookingAround = 'yes'
                            if cls.isSavePic == False:
                                cls.isSavePic = True
                                cv2.imwrite('FaceDetection.png', frame)
                
            else:
                i = i + 1
                cv2.circle(frame,(cls.nx + cls.nw/2,cls.ny + cls.nh/2),min(cls.nw/2,cls.nh/2),(0,255,0))
            cv2.imshow('RealTime', frame)
            cv2.waitKey(1) & 0xFF
            
            stream.seek(0)
            stream.truncate()




detector = Camera()
