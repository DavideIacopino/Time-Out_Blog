package com.timeout.blog.repositories;

import com.timeout.blog.entities.Articolo;
import com.timeout.blog.entities.Rubrica;
import com.timeout.blog.entities.Utente;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface ArticoloRepository extends JpaRepository<Articolo, Integer>, JpaSpecificationExecutor<Articolo> {
    Page<Articolo> findAll(Pageable paging);
    Page<Articolo> findByUtenti(Utente u, Pageable pageable); //salvati
    Page<Articolo> findByRubrica(Rubrica r, Pageable pageable);
    Page<Articolo> findByData(Date date, Pageable pageable);
    List<Articolo> findByRubricaOrderByIdDesc(Rubrica r);
    List<Articolo> findAllByOrderByIdDesc();
    List<Articolo> findByTopicIgnoreCaseContainingOrderByIdDesc(String topic);
}