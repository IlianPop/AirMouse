import air_mouse
import math
import cv2
import mediapipe as mp
detectHand = mp.solutions.hands
hand = detectHand.Hands(
    static_image_mode = 0,
    max_num_hands = 1,
    min_detection_confidence = 0.5,
    min_tracking_confidence = 0.5,
)
clicked = False
cap = cv2.VideoCapture(0)
while cap.isOpened():
    ret, frame = cap.read()
    if ret:
        frame = cv2.resize(frame, (400, 400))
        frame = cv2.flip(frame, 1)
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        frame.flags.writeable = False
        res = hand.process(frame)
        if res.multi_hand_landmarks:
            air_mouse.set_cursor(res.multi_hand_landmarks[0].landmark[5].x, res.multi_hand_landmarks[0].landmark[5].y)
            big_x = res.multi_hand_landmarks[0].landmark[4].x
            big_y = res.multi_hand_landmarks[0].landmark[4].y
            main_x = res.multi_hand_landmarks[0].landmark[8].x
            main_y = res.multi_hand_landmarks[0].landmark[8].y
            d = math.sqrt((big_x - main_x) ** 2 + (big_y - main_y) ** 2)
            left_part_x = res.multi_hand_landmarks[0].landmark[5].x
            left_part_y = res.multi_hand_landmarks[0].landmark[5].y
            right_part_x = res.multi_hand_landmarks[0].landmark[17].x
            right_part_y = res.multi_hand_landmarks[0].landmark[17].y
            z = math.sqrt((left_part_x - right_part_x) ** 2 + (left_part_y - right_part_y) ** 2)
            if d / z < 1:
                if not clicked:
                    air_mouse.left_click()
                    clicked = True
            else:
                if clicked:
                    air_mouse.left_un_click()
                    clicked = False
        if cv2.waitKey(1) == ord('q'):
            break
    else:
        print('Проблеми з підключенням');
        break
cap.release()
cv2.destroyAllWindows()