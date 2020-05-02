package edu.pw.shoppingm8.list.invitation.db;

import edu.pw.shoppingm8.list.List;
import edu.pw.shoppingm8.user.db.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;

public interface ListInvitationRepository extends JpaRepository<ListInvitation, Long> {
    Collection<ListInvitation> findByList(List list);

    Collection<ListInvitation> findByInvited(User invited);

    Collection<ListInvitation> findByInviting(User inviting);
}
