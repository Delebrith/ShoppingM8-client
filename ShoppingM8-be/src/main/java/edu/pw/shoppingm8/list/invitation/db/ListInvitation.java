package edu.pw.shoppingm8.list.invitation.db;

import edu.pw.shoppingm8.list.List;
import edu.pw.shoppingm8.user.db.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ListInvitation {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "list_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private List list;

    @ManyToOne
    @JoinColumn(name = "invited_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User invited;

    @ManyToOne
    @JoinColumn(name = "inviting_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User inviting;
}
