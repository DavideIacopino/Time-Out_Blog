package com.timeout.blog.repositories;

import com.timeout.blog.entities.Rubrica;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RubricaRepository extends JpaRepository<Rubrica, Integer> {
    Rubrica findByNomeIgnoreCase(String nome);
    boolean existsByNomeIgnoreCase(String nome);
}
