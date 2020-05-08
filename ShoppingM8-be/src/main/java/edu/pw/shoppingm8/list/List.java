package edu.pw.shoppingm8.list;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

import edu.pw.shoppingm8.user.db.User;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.util.HashSet;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity(name = "LIST")
public class List {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;

    @ManyToOne
    @JoinColumn(name = "OWNER_ID", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User owner;

    @OneToMany(fetch = FetchType.EAGER)
    @JoinTable(joinColumns = @JoinColumn(name = "LIST_ID", referencedColumnName = "ID"),
            inverseJoinColumns = @JoinColumn(name = "USER_ID", referencedColumnName = "ID"),
            name = "LIST_MEMBERS")
    @Builder.Default
    private Set<User> members = new HashSet<>();
}