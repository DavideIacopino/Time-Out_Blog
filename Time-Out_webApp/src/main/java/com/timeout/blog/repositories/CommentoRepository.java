package com.timeout.blog.repositories;

import com.timeout.blog.entities.Articolo;
import com.timeout.blog.entities.Commento;
import com.timeout.blog.entities.Utente;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CommentoRepository extends JpaRepository<Commento,Integer>{
    //trovare tutti i commenti fatti da un utente
    Page<Commento> findByUtente(Utente u, Pageable pageable);

    //trovare tutti i commenti presenti sotto un articolo
    Page<Commento> findByArticolo(Articolo a, Pageable pageable);

    //trovare tutti i commenti fatti da un utente su un articolo
    Page<Commento> findByArticoloAndUtente(Articolo a, Utente u, Pageable pageable);
}
