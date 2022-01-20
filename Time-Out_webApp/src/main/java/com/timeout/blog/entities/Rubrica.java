package com.timeout.blog.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
public class Rubrica implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name="nome", nullable= false, unique = true)
    private String nome;

    @OneToMany(mappedBy = "rubrica", cascade = CascadeType.MERGE)
    @JsonIgnore
    @ToString.Exclude
    @OrderBy(value = "data desc")
    private List<Articolo> articoli=new ArrayList<Articolo>();
}