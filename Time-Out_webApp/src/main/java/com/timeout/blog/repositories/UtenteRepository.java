package com.timeout.blog.repositories;

import com.timeout.blog.entities.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UtenteRepository extends JpaRepository<Utente, Integer> {

    //restituiscono un solo user perchè c'è vincolo unique su email e su username
    Utente findByEmailIgnoreCase(String email);
    Utente findByUsernameIgnoreCase(String username);
    boolean existsByEmailIgnoreCase(String email);
    boolean existsByUsernameIgnoreCase(String email);

}
