package com.timeout.blog.services;

import com.timeout.blog.entities.Rubrica;
import com.timeout.blog.exceptions.RubricaAlreadyExistsException;
import com.timeout.blog.repositories.RubricaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RubricaService {
    @Autowired
    private RubricaRepository rubricaRepository;

    @Transactional(readOnly = true)
    public Rubrica getRubricaByNome(String nome){
        return rubricaRepository.findByNomeIgnoreCase(nome);
    }

    @Transactional(readOnly = true)
    public List<Rubrica> getAllRubrica() {
        return rubricaRepository.findAll();
    }

    @Transactional
    public void addRubrica(Rubrica rubrica) throws RubricaAlreadyExistsException {
        if(rubricaRepository.existsByNomeIgnoreCase(rubrica.getNome()))
            throw new RubricaAlreadyExistsException();
        rubricaRepository.save(rubrica);
    }

}
