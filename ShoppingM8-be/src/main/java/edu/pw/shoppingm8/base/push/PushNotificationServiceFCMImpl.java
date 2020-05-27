package edu.pw.shoppingm8.base.push;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableMap;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import edu.pw.shoppingm8.list.api.dto.ListDto;
import edu.pw.shoppingm8.list.invitation.event.InvitationCreatedEvent;
import edu.pw.shoppingm8.receipt.api.ReceiptDto;
import edu.pw.shoppingm8.receipt.event.ReceiptCreatedEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.event.TransactionalEventListener;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Stream;

@Service
@Slf4j
class PushNotificationServiceFCMImpl implements PushNotificationService {
    private static final Map<String, String> DEFAULT_DATA = ImmutableMap.of("click_action", "FLUTTER_NOTIFICATION_CLICK");

    @Override
    public void sendPushNotification(PushNotificationDto notificationDto, String to) {
        Message message = Message.builder()
                .setToken(to)
                .setNotification(Notification.builder()
                        .setTitle(notificationDto.getTitle())
                        .setBody(notificationDto.getMessage())
                        .build())
                .putAllData(notificationDto.getData())
                .build();
        try {
            log.info("Sending push notification {} to {}", notificationDto, to);
            FirebaseMessaging.getInstance().send(message);
        } catch (FirebaseMessagingException e) {
            log.error("Could not send message", e);
        }
    }

    @TransactionalEventListener
    private void handleInvitationCreated(InvitationCreatedEvent event) {
        Map<String, String> data = new HashMap<>(DEFAULT_DATA);
        data.put("screen", ScreenToGo.INVITATIONS.name());
        PushNotificationDto notificationDto = PushNotificationDto.builder()
                .title("You have new list invitation")
                .message("Tap to see invitations")
                .data(data)
                .build();
        this.sendPushNotification(notificationDto, event.getListInvitation().getInvited().getFmcToken());
    }

    @TransactionalEventListener
    private void handleReceiptCreated(ReceiptCreatedEvent event) {
        try {
            Map<String, String> data = new HashMap<>(DEFAULT_DATA);
            data.put("screen", ScreenToGo.RECEIPTS.name());
            data.put("list", listToJson(ListDto.of(event.getReceipt().getList())));

            PushNotificationDto notificationDto = PushNotificationDto.builder()
                    .title("New receipt was uploaded")
                    .message("Enter the application to see receipts in list " + event.getReceipt().getList().getName())
                    .data(data)
                    .build();

            Stream.concat(
                    Stream.of(event.getReceipt().getList().getOwner()),
                    event.getReceipt().getList().getMembers().stream())
                    .filter(user -> !user.equals(event.getReceipt().getCreatedBy()))
                    .forEach(user -> this.sendPushNotification(notificationDto, user.getFmcToken()));
        } catch (JsonProcessingException e) {
            log.error("Could not convert given object to json string", e);
        }
    }

    private String listToJson(ListDto listDto) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(listDto);
    }
}
