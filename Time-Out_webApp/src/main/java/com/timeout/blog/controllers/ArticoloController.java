package com.timeout.blog.controllers;

import com.timeout.blog.entities.Articolo;
import com.timeout.blog.services.ArticoloService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.security.RolesAllowed;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/new")
public class ArticoloController {
    @Autowired
    private ArticoloService articoloService;

    @RolesAllowed("Editor")
    @PostMapping
    public ResponseEntity create(@RequestBody  Articolo a){
        //modifico i tag per salvarli tutti in minuscolo
        if (a.getTags()!=null) {
            List<String> tags = new ArrayList<>();
            for (String t : a.getTags())
                tags.add(t.toLowerCase());
            a.setTags(tags);
        }
        Articolo added=articoloService.addArticolo(a);
        if (added==null)
            return new ResponseEntity<>("INSERIMENTO_NON_RIUSCITO", HttpStatus.OK);
        return new ResponseEntity<>(added, HttpStatus.OK);
    }
}
