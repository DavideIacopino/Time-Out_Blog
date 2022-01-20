class Constants {
  static final String REQUEST_DEFAULT_PAGE_SIZE = "10";

  static final String REALM = "TimeOut";
  static final String CLIENT_ID = "myclient";
  static final String CLIENT_SECRET = "2ed0c4bc-a5f0-491d-8316-da36b9c66128";
  static final String LINK_REGISTRATION_NEW_USER="http://"+ADDRESS_AUTHENTICATION_SERVER+"/auth/realms/"+REALM+"/users";
  static final String REQUEST_REGISTRATION="/auth/admin/realms/"+REALM+"/users";
  static final String LINK_FIRST_SETUP_PASSWORD = "http://" + ADDRESS_AUTHENTICATION_SERVER + "/auth/realms/" + REALM + "/protocol/openid-connect/auth?response_type=code&client_id=" + CLIENT_ID + "&redirect_uri=https://" + ADDRESS_CLIENT;
  static final String LINK_RESET_PASSWORD = "http://" + ADDRESS_AUTHENTICATION_SERVER + "/auth/realms/" + REALM + "/login-actions/reset-credentials?client_id=account";
  static final String REQUEST_LOGIN = "/auth/realms/" + REALM + "/protocol/openid-connect/token";
  static final String REQUEST_LOGOUT = "/auth/realms/" + REALM + "/protocol/openid-connect/logout";

  //******ADDRESS**********//
  static final String HOSTNAME= "localhost:8080";
  static final String HOST= "localhost";
  static final String ADDRESS_CLIENT = "localhost:9500/#/";
  static final String ADDRESS_AUTHENTICATION_SERVER = "localhost:8090";

  //******STATE**********
  static final String STATE_HOME="home";
  static final String STATE_POSTS_HOME="POSTS";
  static final String STATE_RUBRICHE_HOME="RUBRICHE";
  static final String STATE_POSTS_DETAILS="POSTS_DETAILS";
  static final String SALVATI="salvati";
  static final String STATE_SEARCH_RESULT = "search_result";
  static final String STATE_USER="user";

}