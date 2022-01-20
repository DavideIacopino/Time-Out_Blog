package com.timeout.blog.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;
import java.io.Serializable;
import java.util.*;

@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
public class Articolo implements Serializable {
    private static final int MAXLENGTH=65535;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id", nullable = false)
    private Integer id;

    @ManyToOne(cascade = CascadeType.MERGE)
    @JoinColumn(name="rubrica", referencedColumnName = "id", nullable= false)
    private Rubrica rubrica;

    @Column(name="data", nullable= false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date data;

    @Column(name="topic", nullable= false)
    private String topic;

    @Column(name="tags")
    @ElementCollection
    private List<String> tags;

    @Column(name="testo", nullable= false, length = MAXLENGTH)
    private String testo;

    @Column(name="img")
    private String img;

    @OneToMany(mappedBy = "articolo", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Commento> commenti=new ArrayList<>();

    @ManyToMany(mappedBy = "salvati")
    @JsonIgnore
    @ToString.Exclude
    private Set<Utente> utenti=new HashSet<>(); //utenti che hanno salvato questo articolo
}

