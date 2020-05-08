package edu.pw.shoppingm8.list.invitation;

import edu.pw.shoppingm8.list.List;
import edu.pw.shoppingm8.list.invitation.db.ListInvitation;
import edu.pw.shoppingm8.user.db.User;

import java.util.Collection;

public interface ListInvitationService {
    ListInvitation getInvitation(Long id);

    Collection<ListInvitation> getInvitationsByList(List list);

    Collection<ListInvitation> getInvitationsByInvited(User invited);

    Collection<ListInvitation> getInvitationsByInviting(User inviting);

    ListInvitation createInvitation(List list, User invited);

    void acceptInvitation(ListInvitation invitation);

    void rejectInvitation(ListInvitation invitation);

    void withdrawInvitation(ListInvitation invitation);
}
