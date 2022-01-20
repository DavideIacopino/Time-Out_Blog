package com.timeout.blog.services;

import com.timeout.blog.entities.Articolo;
import com.timeout.blog.entities.Commento;
import com.timeout.blog.entities.Utente;
import com.timeout.blog.exceptions.ArticoloNotFoundException;
import com.timeout.blog.exceptions.UserNotFoundException;
import com.timeout.blog.repositories.ArticoloRepository;
import com.timeout.blog.repositories.CommentoRepository;
import com.timeout.blog.repositories.UtenteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class CommentoService {
    @Autowired
    private CommentoRepository commentoRepository;
    @Autowired
    private ArticoloRepository articoloRepository;
    @Autowired
    private UtenteRepository utenteRepository;

    @Transactional
    public Articolo addCommento(Commento commento, Articolo articolo) throws ArticoloNotFoundException, UserNotFoundException {
        if (articolo == null || !articoloRepository.existsById(articolo.getId()))
            throw new ArticoloNotFoundException();
        if (commento.getUtente() ==null || !utenteRepository.existsById(commento.getUtente().getId()))
            throw new UserNotFoundException();
        List<Commento> commenti=articolo.getCommenti();
        commenti.add(commento);
        articolo.setCommenti(commenti);
        return articoloRepository.saveAndFlush(articolo);
    }

    @Transactional(readOnly = true)
    public List<Commento> getByArticolo(int pageNumber, int pageSize, Articolo articolo){
        Pageable paging = PageRequest.of(pageNumber, pageSize);
        Page<Commento> pagedResult=commentoRepository.findByArticolo(articolo,paging);
        if ( pagedResult.hasContent() )
            return pagedResult.getContent();
        else
            return new ArrayList<>();
    }

    @Transactional(readOnly = true)
    public List<Commento> getByUtente(int pageNumber, int pageSize, Utente utente){
        Pageable paging = PageRequest.of(pageNumber, pageSize);
        Page<Commento> pagedResult=commentoRepository.findByUtente(utente,paging);
        if ( pagedResult.hasContent() )
            return pagedResult.getContent();
        else
            return new ArrayList<>();
    }

    @Transactional(readOnly = true)
    public List<Commento> getByArticoloAndUtente(int pageNumber, int pageSize, Utente u, Articolo articolo){
        Pageable paging = PageRequest.of(pageNumber, pageSize);
        Page<Commento> pagedResult=commentoRepository.findByArticoloAndUtente(articolo, u, paging);
        if ( pagedResult.hasContent() )
            return pagedResult.getContent();
        else
            return new ArrayList<>();
    }
}
