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
            air_mouse.set_coords([coord for point in finded_hand for coord in (point.x, point.y)])
        cv2.waitKey(1) & 0xFF
    else:
        break
cap.release()
cv2.destroyAllWindows()