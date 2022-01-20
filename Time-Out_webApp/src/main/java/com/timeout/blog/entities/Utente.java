package com.timeout.blog.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@ToString
@EqualsAndHashCode
@Getter
@Setter
@Entity
public class Utente implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id", nullable = false)
    private Integer id;

    @Column(name="email", nullable = false, unique = true)
    private String email;

    @Column(name="username", nullable= false, unique = true)
    private String username;

    @Column(name="role", nullable = false)
    private String role;

    @ManyToMany (cascade = CascadeType.ALL)
    @JsonIgnore
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    @JoinTable(name = "SalvatiUtente",
            joinColumns = @JoinColumn(name = "idUtente"),
            inverseJoinColumns ={@JoinColumn(name = "idArticolo")})
    private Set<Articolo> salvati = new HashSet<>();
}
