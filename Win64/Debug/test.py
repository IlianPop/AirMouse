import air_mouse
import cv2
import mediapipe as mp
import numpy as np
if not hasattr(air_mouse, 'camera_index'):
    air_mouse.camera_index = 0
if not hasattr(air_mouse, 'stop_thread'):
    air_mouse.stop_thread = False
camera_index = air_mouse.camera_index
detectHand = mp.solutions.hands
frame_count = 0
hand = detectHand.Hands(
    static_image_mode = False,
    max_num_hands = 1,
    model_complexity = 0,
    min_detection_confidence = 0.5,
    min_tracking_confidence = 0.4,
)
cap = cv2.VideoCapture(camera_index)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 320)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 320)
cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)
while not air_mouse.stop_thread:
    if air_mouse.camera_index != camera_index:
        cap.release()
        camera_index = air_mouse.camera_index
        cap = cv2.VideoCapture(camera_index)
        cap.set(cv2.CAP_PROP_FRAME_WIDTH, 320)
        cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 320)
        cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)
        continue
    if not cap.isOpened():continue
    ret, frame = cap.read()
    if not(ret):continue
    frame = cv2.flip(frame, 1)
    #Перемикання режиму
    #cv2.imshow("frame", frame)
    #cv2.waitKey(1)
    frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    frame.flags.writeable = False
    res = hand.process(frame)
    if res.multi_hand_landmarks:
        finded_hand = res.multi_hand_landmarks[0].landmark
        coords = np.array(
            [val for lmk in finded_hand for val in (lmk.x, lmk.y)]
            , dtype=np.float64
        )
        air_mouse.set_coords(coords.ctypes.data)
if cap.isOpened():cap.release()
cv2.destroyAllWindows()