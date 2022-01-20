package com.timeout.blog.services;

import com.timeout.blog.entities.Articolo;
import com.timeout.blog.entities.Rubrica;
import com.timeout.blog.entities.Utente;
import com.timeout.blog.exceptions.ArticoloNotFoundException;
import com.timeout.blog.exceptions.RubricaNotFoundException;
import com.timeout.blog.exceptions.UserNotFoundException;
import com.timeout.blog.repositories.ArticoloRepository;
import com.timeout.blog.repositories.RubricaRepository;
import com.timeout.blog.repositories.UtenteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;


@Service
public class ArticoloService {
    @Autowired
    private ArticoloRepository articoloRepository;
    @Autowired
    private UtenteRepository utenteRepository;
    @Autowired
    private RubricaRepository rubricaRepository;

    @Transactional
    public boolean removeArticolo(Articolo a, Utente u){
        if (a==null || u==null )
            return false;
        Set<Articolo> salvati=u.getSalvati();
        boolean removed = salvati.remove(a);
        if(!removed)
            return false;
        u.setSalvati(salvati);
        utenteRepository.save(u); //user è l'owner della relazione -> propago le modifiche all'altro lato
        return true;
    }

    @Transactional
    public boolean saveArticolo(Articolo a, Utente u){
        if (a==null || u==null )
            return false;
        Set<Articolo> salvati=u.getSalvati();
        boolean added = salvati.add(a);
        if(!added)
            return false;
        u.setSalvati(salvati);
        utenteRepository.save(u); //user è l'owner della relazione -> propago le modifiche all'altro lato
        return true;
    }

    @Transactional
    public Articolo addArticolo(Articolo a) {
        if(a==null)
            return null;
        Rubrica r=a.getRubrica();
        Optional<Rubrica> optR=rubricaRepository.findById(r.getId());
        //non c'è bisogno di controllare con if(optR.isPresent()) perché so già che non è null
        Rubrica rubrica=optR.get();
        List<Articolo> posts=rubrica.getArticoli();
        posts.add(a);
        rubrica.setArticoli(posts);
        Articolo ret=articoloRepository.save(a);
        return ret;
    }

    @Transactional(readOnly = true)
    public List<Articolo> advancedSearch(String topic, List<String> tags, Date startDate, Date endDate, Rubrica r){
        List<Articolo> partialResult;
        if(topic!=null)
            partialResult=articoloRepository.findByTopicIgnoreCaseContainingOrderByIdDesc(topic);
        else if (r!=null)
            partialResult=articoloRepository.findByRubricaOrderByIdDesc(r);
        else
            partialResult=articoloRepository.findAllByOrderByIdDesc();
        Iterator<Articolo> it=partialResult.listIterator();
        while(it.hasNext()){
            Articolo a=it.next();
            //con topic non c'è bisogno, se topic!=null l'ho già usato per la query
            if(r!=null && !a.getRubrica().equals(r)) {
                it.remove();
                continue;
            }
            if(startDate!=null && startDate.after(a.getData())) {
                it.remove();
                continue;
            }
            if(endDate!=null && endDate.before(a.getData())){
                it.remove();
                continue;
            }
            if(tags!=null) {
                List<String> currentTags = a.getTags();
                for (String t : tags) {
                    if (!currentTags.contains(t.toLowerCase())) {
                        it.remove();
                        break;
                    }
                }
            }
        }
        partialResult.sort(new Comparator<Articolo>(){
            public int compare(Articolo a1, Articolo a2){
                Date d1=a1.getData();
                Date d2=a2.getData();
                if(d1.before(d2))
                    return 1;
                if(d1.equals(d2))
                    return 0;
                return -1;
            }
        });
        return partialResult;
    }

    @Transactional(readOnly = true)
    public Articolo getArticoloById(Integer id) throws ArticoloNotFoundException {
        Optional<Articolo> ret=articoloRepository.findById(id);
        if(! ret.isPresent())
            throw new ArticoloNotFoundException();
        return ret.get();
    }

    @Transactional(readOnly = true)
    public List<Articolo> getArticoloByData(int pageNumber, int pageSize, Date date){
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by("data").descending());
        Page<Articolo> pagedResult= articoloRepository.findByData(date,paging);
        if ( pagedResult.hasContent() )
            return pagedResult.getContent();
        else
            return new ArrayList<>();
    }

    @Transactional(readOnly = true)
    public List<Articolo> getArticoloByRubrica(int pageNumber, int pageSize, Rubrica r) throws RubricaNotFoundException {
        if( !rubricaRepository.existsByNomeIgnoreCase(r.getNome()))
            throw new RubricaNotFoundException();
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by("data").descending());
        Page<Articolo> pagedResult= articoloRepository.findByRubrica(r,paging);
        if ( pagedResult.hasContent() )
            return pagedResult.getContent();
        else
            return new ArrayList<>();
    }

    @Transactional(readOnly = true)
    public List<Articolo> getArticoloByUtente(int pageNumber, int pageSize, Utente utente) throws UserNotFoundException {
        if ( !utenteRepository.existsById(utente.getId()) ) {
            throw new UserNotFoundException();
        }
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by("data").descending());
        Page<Articolo> pagedResult= articoloRepository.findByUtenti(utente, paging);
        if ( pagedResult.hasContent() )
            return pagedResult.getContent();
        else
            return new ArrayList<>();
    }

    @Transactional(readOnly = true)
    public List<Articolo> getAllPosts(int pageNumber, int pageSize){
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by("data").descending());
        Page<Articolo> pagedResult= articoloRepository.findAll(paging);
        if ( pagedResult.hasContent() ) {
            return pagedResult.getContent();
        }
        else
            return new ArrayList<>();
    }

}
