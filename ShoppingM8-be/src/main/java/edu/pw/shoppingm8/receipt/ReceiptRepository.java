package edu.pw.shoppingm8.receipt;

import edu.pw.shoppingm8.list.List;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.Set;

public interface ReceiptRepository extends JpaRepository<Receipt, Long> {
    Set<Receipt> findByList(List list);

    Optional<Receipt> findByListAndId(List list, Long id);
}
