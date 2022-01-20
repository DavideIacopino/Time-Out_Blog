package com.timeout.blog.authentication;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.experimental.UtilityClass;
import lombok.extern.log4j.Log4j2;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;

    @UtilityClass
    @Log4j2
    public class Utils {
        public Jwt getPrincipal() {
            return (Jwt) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        }

        public String getAuthServerId() {
            return getTokenNode().get("subject").asText();
        }

        public String getName() {
            return getTokenNode().get("claims").get("name").asText();
        }

        public String getEmail() {
            return getTokenNode().get("claims").get("preferred_username").asText();
        }

        public String getRole(){ return getTokenNode().get("claims").get("realm_access").get("roles").asText();}

        private JsonNode getTokenNode() {
            Jwt jwt = getPrincipal();
            ObjectMapper objectMapper = new ObjectMapper();
            String jwtAsString;
            JsonNode jsonNode;
            try {
                jwtAsString = objectMapper.writeValueAsString(jwt);
                jsonNode = objectMapper.readTree(jwtAsString);
            } catch (JsonProcessingException e) {
                log.error(e.getMessage());
                throw new RuntimeException("Unable to retrieve user's info!");
            }
            return jsonNode;
        }
    }
