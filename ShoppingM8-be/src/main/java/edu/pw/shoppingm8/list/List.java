package edu.pw.shoppingm8.list;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

import edu.pw.shoppingm8.user.User;

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
    private User owner;
}