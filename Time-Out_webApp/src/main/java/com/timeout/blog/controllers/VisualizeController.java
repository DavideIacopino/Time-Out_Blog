package com.timeout.blog.controllers;

import com.timeout.blog.entities.Articolo;
import com.timeout.blog.entities.Commento;
import com.timeout.blog.entities.Utente;
import com.timeout.blog.exceptions.ArticoloNotFoundException;
import com.timeout.blog.exceptions.UserNotFoundException;
import com.timeout.blog.services.AccountingService;
import com.timeout.blog.services.ArticoloService;
import com.timeout.blog.services.CommentoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.security.RolesAllowed;

@RestController
public class VisualizeController {
    @Autowired
    private AccountingService accountingService;
    @Autowired
    ArticoloService articoloService;
    @Autowired
    CommentoService commentoService;

    @GetMapping("/{id}")
    public ResponseEntity showPost(@PathVariable Integer id){
        Articolo post= null;
        try {
            post = articoloService.getArticoloById(id);
            return new ResponseEntity(post,HttpStatus.OK);
        } catch (ArticoloNotFoundException e) {
            return new ResponseEntity<>("POST_NOT_FOUND", HttpStatus.BAD_REQUEST);
        }
    }

    @RolesAllowed({"Lettore","Editor"})
    @PostMapping("/{username}/{id}")
    public ResponseEntity commenta(@PathVariable String username, @PathVariable String id, @RequestBody String testo){
        Commento commento=new Commento();
        commento.setTesto(testo);
        Articolo art;
        commento.setUtente(accountingService.getUserByUsername(username));
        try {
            art= articoloService.getArticoloById(Integer.parseInt(id));
            commento.setArticolo(art);
        } catch (ArticoloNotFoundException e) {
            return new ResponseEntity<>("POST_NOT_FOUND", HttpStatus.BAD_REQUEST);
        }
        try {
            Articolo articoloNew=commentoService.addCommento(commento, art);
            return new ResponseEntity(articoloNew,HttpStatus.OK);
        } catch (ArticoloNotFoundException e) {
            return new ResponseEntity<>("POST_NOT_FOUND",HttpStatus.BAD_REQUEST);
        } catch (UserNotFoundException e) {
            return new ResponseEntity<>("USER_NOT_FOUND",HttpStatus.BAD_REQUEST);
        }
    }

    //per aggiungere un articolo ai salvati
    @RolesAllowed({"Lettore", "Editor"})
    @PutMapping("/{username}/{id}")
    public ResponseEntity saveArticolo (@PathVariable String username, @PathVariable Integer id){
        Utente utente;
        Articolo art;
        try {
            utente=accountingService.getUserByUsername(username);
            art= articoloService.getArticoloById(id);
        } catch (ArticoloNotFoundException e) {
            return new ResponseEntity<>("POST_NOT_FOUND", HttpStatus.BAD_REQUEST);
        }
        boolean riuscito=articoloService.saveArticolo(art, utente);
        if(riuscito)
            return new ResponseEntity("Salvataggio effettuato",HttpStatus.OK);
        return new ResponseEntity("Salvataggio non effettuato", HttpStatus.OK);
    }

    //per rimuovere un articolo dai salvati
    @RolesAllowed({"Lettore", "Editor"})
    @PutMapping("/del/{username}/{id}")
    public ResponseEntity removeArticolo (@PathVariable String username, @PathVariable Integer id){
        Utente utente;
        Articolo art;
        try {
            utente=accountingService.getUserByUsername(username);
            art= articoloService.getArticoloById(id);
        } catch (ArticoloNotFoundException e) {
            return new ResponseEntity<>("POST_NOT_FOUND", HttpStatus.BAD_REQUEST);
        }
        boolean riuscito=articoloService.removeArticolo(art, utente);
        if(riuscito)
            return new ResponseEntity("Rimozione effettuata",HttpStatus.OK);
        return new ResponseEntity("Rimozione non effettuata", HttpStatus.OK);
    }
}
