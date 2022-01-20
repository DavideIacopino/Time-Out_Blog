package com.timeout.blog.services;

import com.timeout.blog.entities.Utente;
import com.timeout.blog.exceptions.MailUserAlreadyExistsException;
import com.timeout.blog.exceptions.UsernameAlreadyExistsException;
import com.timeout.blog.repositories.UtenteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AccountingService {
    @Autowired
    private UtenteRepository utenteRepository;

    @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
    public Utente registerUser(Utente utente) throws MailUserAlreadyExistsException, UsernameAlreadyExistsException {
        if ( utenteRepository.existsByEmailIgnoreCase(utente.getEmail()) ) {
            throw new MailUserAlreadyExistsException();
        }
        if ( utenteRepository.existsByUsernameIgnoreCase(utente.getUsername()) ) {
            throw new UsernameAlreadyExistsException();
        }
        return utenteRepository.save(utente);
    }

    @Transactional(readOnly = true)
    public Utente getUserByEmail(String email){
        if(!utenteRepository.existsByEmailIgnoreCase(email))
            return null;
        return utenteRepository.findByEmailIgnoreCase(email);
    }

    @Transactional(readOnly = true)
    public Utente getUserByUsername(String username){
        if(!utenteRepository.existsByUsernameIgnoreCase(username))
            return null;
        return utenteRepository.findByUsernameIgnoreCase(username);
    }

    @Transactional(readOnly = true)
    public List<Utente> getAllUsers() {
        return utenteRepository.findAll();
    }
}
