package edu.pw.shoppingm8.base.push;

public interface PushNotificationService {
    void sendPushNotification(PushNotificationDto message, String to);
}
