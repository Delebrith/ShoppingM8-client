package edu.pw.shoppingm8.list;

import edu.pw.shoppingm8.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;

public interface ListRepository extends JpaRepository<List, Long> {

    Collection<List> findByOwner(User user);
}