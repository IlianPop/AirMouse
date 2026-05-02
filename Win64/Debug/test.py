import air_mouse
import cv2
import mediapipe as mp
detectHand = mp.solutions.hands
hand = detectHand.Hands(
    static_image_mode = 0,
    max_num_hands = 1,
    min_detection_confidence = 0.7,
    min_tracking_confidence = 0.4,
)
cap = cv2.VideoCapture(0)
while cap.isOpened():
    ret, frame = cap.read()
    if ret:
        frame = cv2.resize(frame, (320, 320))
        frame = cv2.flip(frame, 1)
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        frame.flags.writeable = False
        res = hand.process(frame)
        if res.multi_hand_landmarks:
            finded_hand = res.multi_hand_landmarks[0].landmark
            coords = []
            coords.append(finded_hand[1].x)
            coords.append(finded_hand[1].y)
            coords.append(finded_hand[4].x)
            coords.append(finded_hand[4].y)
            coords.append(finded_hand[5].x)
            coords.append(finded_hand[5].y)
            coords.append(finded_hand[8].x)
            coords.append(finded_hand[8].y)
            coords.append(finded_hand[9].x)
            coords.append(finded_hand[9].y)
            coords.append(finded_hand[12].x)
            coords.append(finded_hand[12].y)
            coords.append(finded_hand[13].x)
            coords.append(finded_hand[13].y)
            coords.append(finded_hand[16].x)
            coords.append(finded_hand[16].y)
            coords.append(finded_hand[17].x)
            coords.append(finded_hand[17].y)
            coords.append(finded_hand[20].x)
            coords.append(finded_hand[20].y)
            air_mouse.set_coords(coords)
        cv2.waitKey(1) & 0xFF
    else:
        break
cap.release()
cv2.destroyAllWindows()