package com.timeout.blog.controllers;

import com.timeout.blog.authentication.addUserKeycloak;
import com.timeout.blog.entities.Utente;
import com.timeout.blog.exceptions.MailUserAlreadyExistsException;
import com.timeout.blog.exceptions.UsernameAlreadyExistsException;
import com.timeout.blog.services.AccountingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
public class AccountingController {
    @Autowired
    private AccountingService accountingService;

    @PostMapping
    public ResponseEntity create(@RequestBody Utente utente) {
        try {
            utente.setRole("Lettore");
            Utente added = accountingService.registerUser(utente);
            addUserKeycloak.aggiungiUser(utente.getUsername(),utente.getEmail());
            return new ResponseEntity(added, HttpStatus.OK);
        } catch (MailUserAlreadyExistsException e) {
            return new ResponseEntity<String>("ERROR_MAIL_USER_ALREADY_EXISTS", HttpStatus.BAD_REQUEST);
        } catch (UsernameAlreadyExistsException ue){
            return new ResponseEntity<String>("ERROR_USERNAME_ALREADY_EXISTS", HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/email/{email}")
    public ResponseEntity get(@PathVariable String email){
        Utente utente=accountingService.getUserByEmail(email);
        if(utente!=null)
            return new ResponseEntity(utente,HttpStatus.OK);
        return new ResponseEntity("User not found", HttpStatus.OK);
    }

    @GetMapping("/username")
    public ResponseEntity getByUsername(@RequestParam(value = "username") String username){
        Utente utente=accountingService.getUserByUsername(username);
        if(utente!=null)
            return new ResponseEntity(utente,HttpStatus.OK);
        return new ResponseEntity("User not found", HttpStatus.OK);
    }
}
