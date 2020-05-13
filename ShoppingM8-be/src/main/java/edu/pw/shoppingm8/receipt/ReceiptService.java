package edu.pw.shoppingm8.receipt;

import edu.pw.shoppingm8.list.List;
import org.springframework.data.domain.Page;

import java.util.Collection;

public interface ReceiptService {
    Collection<Receipt> getReceiptsByList(List list);

    Receipt getReceipt(List list, Long id);

    Receipt createReceipt(byte[] receiptPicture, List list);
}
