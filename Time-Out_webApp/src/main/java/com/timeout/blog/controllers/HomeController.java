package com.timeout.blog.controllers;

import com.timeout.blog.entities.Articolo;
import com.timeout.blog.entities.Rubrica;
import com.timeout.blog.entities.Utente;
import com.timeout.blog.exceptions.*;
import com.timeout.blog.services.AccountingService;
import com.timeout.blog.services.ArticoloService;
import com.timeout.blog.services.RubricaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.annotation.security.RolesAllowed;
import java.util.*;

@CrossOrigin
@RestController
@RequestMapping("/")
public class HomeController {
    @Autowired
    private AccountingService accountingService;
    @Autowired
    private RubricaService rubricaService;
    @Autowired
    private ArticoloService articoloService;
    static final int PAGE_SIZE=10;

    @GetMapping("/rubriche")
    public ResponseEntity getRubriche(){
        List<Rubrica> rubriche=rubricaService.getAllRubrica();
        return new ResponseEntity<List<Rubrica>>(rubriche, HttpStatus.OK);
    }

    @GetMapping("/posts")
    public ResponseEntity getPosts(){
        List<Articolo> ultimiArticoli=articoloService.getAllPosts(0,PAGE_SIZE); // cosi restituisce solo la prima pagina di articoli
        return new ResponseEntity<List<Articolo>>(ultimiArticoli, HttpStatus.OK);
    }

    @GetMapping
    public ResponseEntity getHome(){
        List<Rubrica> rubriche=rubricaService.getAllRubrica();
        List<Articolo> ultimiArticoli=articoloService.getAllPosts(0,PAGE_SIZE);
        HashMap<String, List> risposta=new HashMap<>();
        risposta.put("rubriche", rubriche);
        risposta.put("posts", ultimiArticoli);
        return new ResponseEntity<HashMap<String,List>>(risposta, HttpStatus.OK);
    }

    @GetMapping("/size_rubrica/{rubrica}")
    public ResponseEntity sizeOfRubrica(@PathVariable String rubrica){
        Rubrica r=rubricaService.getRubricaByNome(rubrica);
        int ret=r.getArticoli().size();
        return new ResponseEntity(ret,HttpStatus.OK);
    }

    @GetMapping("/rubrica/{rubrica}")
    public ResponseEntity searchByRubrica(@PathVariable String rubrica, @RequestParam(value = "pageNumber", defaultValue = "0") int pageNumber ){
        Rubrica r=rubricaService.getRubricaByNome(rubrica);
        try{
            List<Articolo> ret=articoloService.getArticoloByRubrica(pageNumber,PAGE_SIZE, r);
            if(ret.size()<=0)
                return new ResponseEntity("NO_RESULTS", HttpStatus.OK);
            return new ResponseEntity(ret,HttpStatus.OK);
        } catch (RubricaNotFoundException e){
            return new ResponseEntity<>("RUBRICA_NOT_FOUND", HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/search")
    public ResponseEntity searchArticolo(@RequestParam(value = "rubrica", required = false) String rubrica,
                                         @RequestParam(value = "d", required = false) String startDay,
                                         @RequestParam(value = "m", required = false)String startMonth,
                                         @RequestParam(value = "y", required = false)String startYear,
                                         @RequestParam(value = "ed", required = false)String endDay,
                                         @RequestParam(value = "em", required = false)String endMonth,
                                         @RequestParam(value = "ey", required = false)String endYear,
                                         @RequestParam(value = "topic", required = false) String topic,
                                         @RequestParam(value = "tags", required = false) List<String> tags){
        Date startDate = null;
        Date endDate = null;
        if(!(startDay==null || startMonth==null || startYear==null )) {
            try {
                startDate = new Date(Integer.parseInt(startYear), Integer.parseInt(startMonth) - 1, Integer.parseInt(startDay),0,0);
            } catch (NumberFormatException e) {
                return new ResponseEntity("Errore di formato dei parametri", HttpStatus.BAD_REQUEST);
            }
        }
        if(!(endDay==null || endMonth==null || endYear==null)) {
            try {
                endDate = new Date(Integer.parseInt(endYear), Integer.parseInt(endMonth) - 1, Integer.parseInt(endDay),23,59);
            } catch (NumberFormatException e) {
                return new ResponseEntity("Errore di formato dei parametri", HttpStatus.BAD_REQUEST);
            }
        }
        Rubrica r = rubricaService.getRubricaByNome(rubrica);
        List<Articolo> ret = articoloService.advancedSearch(topic, tags, startDate, endDate, r);
        if(ret.size()<=0)
            return new ResponseEntity("NO_RESULTS", HttpStatus.OK);
        return new ResponseEntity(ret,HttpStatus.OK);
    }

    @RolesAllowed({"Lettore", "Editor"}) //utente deve essere loggato
    @GetMapping("/user_saved")
    public ResponseEntity showPostSaved(@RequestParam String username, @RequestParam(value="pageNumber", defaultValue = "0") int pageNumber){
        try {
            Utente utente= accountingService.getUserByUsername(username);
            List<Articolo> ret = articoloService.getArticoloByUtente(pageNumber, PAGE_SIZE, utente);
            if(ret.size()<=0)
                return new ResponseEntity("NO_RESULTS", HttpStatus.OK);
            return new ResponseEntity(ret,HttpStatus.OK);
        } catch(UserNotFoundException ue){
            return new ResponseEntity("USER_NOT_FOUND", HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/numSalvati")
    public ResponseEntity numberSaved(@RequestParam String username){
            Utente utente= accountingService.getUserByUsername(username);
            int ret=utente.getSalvati().size();
            return new ResponseEntity(ret,HttpStatus.OK);
    }
}
