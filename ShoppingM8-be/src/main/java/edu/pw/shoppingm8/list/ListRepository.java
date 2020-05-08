package edu.pw.shoppingm8.list;

import edu.pw.shoppingm8.user.db.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Collection;

public interface ListRepository extends JpaRepository<List, Long> {

    @Query("select l from LIST l where l.owner = :user or :user in elements(l.members)")
    Collection<List> findUsersLists(@Param("user") User user);
}