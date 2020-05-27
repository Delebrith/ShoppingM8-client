package edu.pw.shoppingm8.receipt.event;

import edu.pw.shoppingm8.receipt.Receipt;
import lombok.Value;

@Value
public class ReceiptCreatedEvent {
    Receipt receipt;
}
