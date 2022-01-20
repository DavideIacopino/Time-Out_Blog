package com.timeout.blog.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
public class Commento implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "idUtente", referencedColumnName = "Id", nullable = false)
    private Utente utente;

    @ManyToOne
    @JsonIgnore
    @ToString.Exclude
    @JoinColumn(name = "idArticolo", referencedColumnName = "Id", nullable = false)
    private Articolo articolo;

    @Column(name="testo", nullable= false)
    private String testo;
}
