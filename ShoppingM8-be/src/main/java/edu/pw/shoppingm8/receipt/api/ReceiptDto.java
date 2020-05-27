package edu.pw.shoppingm8.receipt.api;

import edu.pw.shoppingm8.receipt.Receipt;
import edu.pw.shoppingm8.user.api.dto.UserDto;
import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class ReceiptDto {
    Long id;
    String url;
    UserDto createdBy;

    public static ReceiptDto of(Receipt receipt) {
        return ReceiptDto.builder()
                .id(receipt.getId())
                .url(buildUrl(receipt.getList().getId(), receipt.getId()))
                .createdBy(UserDto.of(receipt.getCreatedBy()))
                .build();
    }

    private static String buildUrl(Long listId, Long id) {
        return String.format("/list/%d/receipt/%d", listId, id);
    }
}
