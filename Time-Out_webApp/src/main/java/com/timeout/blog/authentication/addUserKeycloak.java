package com.timeout.blog.authentication;

import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.CreatedResponseUtil;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UserResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.UserRepresentation;

import javax.ws.rs.core.Response;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

public class addUserKeycloak {

    public static void aggiungiUser(String username, String email){
        String username_admin = "davideiac";
        String password_admin = "admin";
        String ruolo = "Lettore";
        String serverUrl = "http://localhost:8090/auth";
        String realm = "TimeOut";
        String clientId = "myclient";
        String clientSecret = "2ed0c4bc-a5f0-491d-8316-da36b9c66128";

        Keycloak keycloak = KeycloakBuilder.builder()
                .serverUrl(serverUrl)
                .realm(realm)
                .grantType(OAuth2Constants.PASSWORD)
                .clientId(clientId)
                .clientSecret(clientSecret)
                .username(username_admin)
                .password(password_admin)
                .build();

            UserRepresentation user = new UserRepresentation();
            user.setEnabled(true);

            user.setUsername(username);
            user.setEmail(email);
            user.setRealmRoles(Arrays.asList(ruolo));

            // Get realm
            RealmResource realmResource = keycloak.realm(realm);
            UsersResource usersResource = realmResource.users();

            // Create user
            Response response = usersResource.create(user);
        System.out.println("dopo create");

        System.out.printf("Response: %s %s%n", response.getStatus(), response.getStatusInfo());
            System.out.println(response.getLocation());
            String userId = CreatedResponseUtil.getCreatedId(response);

            System.out.printf("User created with userId: %s%n", userId);

            // Define password credential
            CredentialRepresentation passwordCred = new CredentialRepresentation();

            UserResource userResource = usersResource.get(userId);

            // Send password reset E-Mail
            // VERIFY_EMAIL, UPDATE_PROFILE, CONFIGURE_TOTP, UPDATE_PASSWORD, TERMS_AND_CONDITIONS
        List actions = new LinkedList<>();
        actions.add("UPDATE_PASSWORD");
      userResource.executeActionsEmail(actions);

    }
}