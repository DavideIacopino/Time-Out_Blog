import 'dart:async';
import 'dart:convert';

import 'package:timeoutflutter/model/Constant.dart';
import 'package:timeoutflutter/model/ErrorListener.dart';
import 'package:timeoutflutter/model/RestManager.dart';
import 'package:timeoutflutter/model/StateManager.dart';
import 'package:timeoutflutter/model/objects/Articolo_Create.dart';
import 'package:timeoutflutter/model/objects/Articolo_Home.dart';
import 'package:timeoutflutter/model/objects/AuthenticationData.dart';
import 'package:timeoutflutter/model/objects/List_Articolo.dart';
import 'package:timeoutflutter/model/objects/List_Rubrica.dart';
import 'package:timeoutflutter/model/objects/LogInResult.dart';
import 'package:timeoutflutter/model/objects/Rubrica.dart';
import 'package:timeoutflutter/model/objects/User.dart';

class ModelFacade implements ErrorListener {
  static ModelFacade sharedInstance = ModelFacade();
  ErrorListener? delegate;
  StateManager appState = StateManager();

  RestManager _restManager = RestManager();
  AuthenticationData? _authenticationData;

  ModelFacade() {
    _restManager.delegate = this;
  }

  //*********RICERCA AVANZATA**********
  Future<List<Articolo_Home>> advancedSearch(Map<String, dynamic> params) async{
    String risposta=await _restManager.makeGetRequest(Constants.HOSTNAME, "/timeout/search/", TypeHeader.json, params);
    if(risposta!="NO_RESULTS") {
      List<dynamic> jsonResponse = json.decode(risposta);
      List_Articolo art = List_Articolo.fromJson(jsonResponse);
      if (sharedInstance.appState.existsValue(Constants.STATE_SEARCH_RESULT)) {
        sharedInstance.appState.getAndDestroyValue(
            Constants.STATE_SEARCH_RESULT);
      }
      sharedInstance.appState.addValue(
          Constants.STATE_SEARCH_RESULT, art.articoli);
      return art.articoli;
    }
    return List.empty();
  }


  //*********GESTIONE SALVATI**********
  Future<int> loadNumArticoliSalvati(String nome) async{
    Map<String, String> params=new Map();
    params["username"]=nome;
    String risposta1=await _restManager.makeGetRequest(Constants.HOSTNAME, "/timeout/numSalvati", TypeHeader.json, params);
    return int.parse(risposta1);
  }

  Future<List<Articolo_Home>> loadSalvati(String username, { int page=0}) async{
    Map<String, String> params=new Map();
    params["pageNumber"] = page.toString();
    params["username"]=username;
    String risposta=await _restManager.makeGetRequest(Constants.HOSTNAME, "/timeout/user_saved", TypeHeader.json, params );
    if(risposta!="NO_RESULTS") {
      List<dynamic> jsonResponse = json.decode(risposta);
      List_Articolo art = List_Articolo.fromJson(jsonResponse);
      if (!sharedInstance.appState.existsValue(Constants.SALVATI))
        sharedInstance.appState.addValue(Constants.SALVATI, art.articoli);
      else
        sharedInstance.appState.updateValue(Constants.SALVATI, art.articoli);
      return art.articoli;
    }
    return List.empty();
  }

  Future<bool> isSaved(Articolo_Home articoloHome) async{
    if(!sharedInstance.appState.existsValue(Constants.STATE_USER))
      return false;
    List<Articolo_Home> arts=List.empty(growable: true);
    User user=sharedInstance.appState.getValue(Constants.STATE_USER);
    if(user==null) return false;
    if(sharedInstance.appState.existsValue(Constants.SALVATI)){
      arts=sharedInstance.appState.getValue(Constants.SALVATI);
    }
    else {
      await loadSalvati(user.userName).then((articoli) => () {
        arts = articoli;
        if (sharedInstance.appState.existsValue(Constants.SALVATI))
          sharedInstance.appState.updateValue(Constants.SALVATI, articoli);
        else
          sharedInstance.appState.addValue(Constants.SALVATI, articoli);
      });
    }
    if (arts.contains(articoloHome))
      return true;
    return false;
  }

  Future<void> salvaArticolo(String username, int articoloId) async{
    String risposta=await _restManager.makePutRequest(Constants.HOSTNAME, "/timeout/"+username+"/"+articoloId.toString(), TypeHeader.json);
  }

  Future<void> removeArticolo(String username, int articoloId) async{
    String risposta=await _restManager.makePutRequest(Constants.HOSTNAME, "/timeout/del/"+username+"/"+articoloId.toString(), TypeHeader.json);
  }

  //********CARICAMENTO DATI HOME E GENERALI*********
  //load insieme della lista di articoli e di rubriche, metodo void perchè salva i dati in sharedInstance.appState
  Future<void> loadHome() async {
    String risposta1=await _restManager.makeGetRequest(Constants.HOSTNAME, "/timeout/rubriche/", TypeHeader.json);
    List<dynamic> jsonResponse = json.decode(risposta1);
    List_Rubrica r =List_Rubrica.fromJson(jsonResponse);
    if(!sharedInstance.appState.existsValue(Constants.STATE_RUBRICHE_HOME)) {
      sharedInstance.appState.addValue(Constants.STATE_RUBRICHE_HOME, r.rubriche);
    }
    else
      sharedInstance.appState.updateValue(Constants.STATE_RUBRICHE_HOME,r.rubriche);

    String risposta2=await _restManager.makeGetRequest(Constants.HOSTNAME, "/timeout/posts/", TypeHeader.json);
    List<dynamic> response = json.decode(risposta2);
    List_Articolo art =List_Articolo.fromJson(response);
    if(!sharedInstance.appState.existsValue(Constants.STATE_POSTS_HOME))
      sharedInstance.appState.addValue(Constants.STATE_POSTS_HOME,art.articoli);
    else
      sharedInstance.appState.updateValue(Constants.STATE_POSTS_HOME,art.articoli);
  }

  Future<List<Rubrica>> loadRubriche() async{
    String risposta1=await _restManager.makeGetRequest(Constants.HOSTNAME, "/timeout/rubriche/", TypeHeader.json);
    List<dynamic> jsonResponse = json.decode(risposta1);
    List_Rubrica r =List_Rubrica.fromJson(jsonResponse);
    if(!sharedInstance.appState.existsValue(Constants.STATE_RUBRICHE_HOME)) {
      sharedInstance.appState.addValue(Constants.STATE_RUBRICHE_HOME, r.rubriche);
    }
    else
      sharedInstance.appState.updateValue(Constants.STATE_RUBRICHE_HOME,r.rubriche);
    return r.rubriche;
  }

  Future<int> loadNumArticoliByRubrica(String nome) async{
    String risposta1=await _restManager.makeGetRequest(Constants.HOSTNAME, "/timeout/size_rubrica/"+nome, TypeHeader.json);
    return int.parse(risposta1);
  }

  Future<List<Articolo_Home>> loadArticoliByRubrica(String nome, {bool fromSearch=false, int page=0}) async{
    Map<String,dynamic> params=new Map();
    params["pageNumber"]=page.toString();
    String risposta1=await _restManager.makeGetRequest(Constants.HOSTNAME, "/timeout/rubrica/"+nome, TypeHeader.json,params);
    if(risposta1!="NO_RESULTS") {
      List<dynamic> jsonResponse = json.decode(risposta1);
      List_Articolo art = List_Articolo.fromJson(jsonResponse);
      if (!sharedInstance.appState.existsValue(Constants.STATE_POSTS_HOME + "_" + nome)) {
        sharedInstance.appState.addValue(Constants.STATE_POSTS_HOME + "_" + nome, art.articoli);
        for (Articolo_Home a in art.articoli)
          sharedInstance.appState.addValue(Constants.STATE_POSTS_DETAILS + a.id.toString(), a);
      } else {
        sharedInstance.appState.updateValue(Constants.STATE_POSTS_HOME + "_" + nome, art.articoli);
        for (Articolo_Home a in art.articoli) {
          if (sharedInstance.appState.existsValue(Constants.STATE_POSTS_DETAILS + a.id.toString()))
            sharedInstance.appState.updateValue(Constants.STATE_POSTS_DETAILS + a.id.toString(), a);
          else
            sharedInstance.appState.addValue(Constants.STATE_POSTS_DETAILS + a.id.toString(), a);
        }
      }
      if (fromSearch) {
        if (sharedInstance.appState.existsValue(Constants.STATE_SEARCH_RESULT)) {
          sharedInstance.appState.getAndDestroyValue(Constants.STATE_SEARCH_RESULT);
        }
        sharedInstance.appState.addValue(Constants.STATE_SEARCH_RESULT, art.articoli);
        for (Articolo_Home a in art.articoli)
          sharedInstance.appState.addValue(Constants.STATE_POSTS_DETAILS + a.id.toString(), a);
      }
      return art.articoli;
    }
    return List.empty();
  }

  Future<List<Articolo_Home>> loadArticoli({bool fromSearch=false}) async{
    String risposta1=await _restManager.makeGetRequest(Constants.HOSTNAME, "/timeout/posts/", TypeHeader.json);
    if(risposta1!="NO_RESULTS") {
      List<dynamic> jsonResponse = json.decode(risposta1);
      List_Articolo art = List_Articolo.fromJson(jsonResponse);
      if (!sharedInstance.appState.existsValue(Constants.STATE_POSTS_HOME))
        sharedInstance.appState.addValue(
            Constants.STATE_POSTS_HOME, art.articoli);
      else
        sharedInstance.appState.updateValue(
            Constants.STATE_POSTS_HOME, art.articoli);
      if (fromSearch) {
        if (sharedInstance.appState.existsValue(
            Constants.STATE_SEARCH_RESULT)) {
          sharedInstance.appState.getAndDestroyValue(
              Constants.STATE_SEARCH_RESULT);
        }
        sharedInstance.appState.addValue(
            Constants.STATE_SEARCH_RESULT, art.articoli);
        for (Articolo_Home a in art.articoli)
          sharedInstance.appState.addValue(
              Constants.STATE_POSTS_DETAILS + a.id.toString(), a);
      }
      return art.articoli;
    }
    return List.empty();
  }

  //**********COMMENTI***************
  Future<bool> commenta(String testo, int articoloId, String username) async{
    String result=await _restManager.makePostRequest(Constants.HOSTNAME, "/timeout/"+username+"/"+articoloId.toString(), testo);
    if(result!="POST_NOT_FOUND" && result!="USER_NOT_FOUND")
      return true;
    return false;
  }

  //**********EDITOR*****************
  Future<String> nuovoArticolo(Rubrica rubrica, String topic, String testo, List<String> tags, DateTime data, String img) async{
    Articolo_Create nuovo=new Articolo_Create(topic: topic, rubrica: rubrica, testo: testo, data: data, tags: tags, immagine: img);
    String result = await _restManager.makePostRequest(Constants.HOSTNAME, "/timeout/new/", nuovo);
    return result;
  }


  //***********GESTIONE ERRORI************
  @override
  void errorNetworkGone() {
    if (delegate != null) {
      delegate!.errorNetworkGone();
    }
  }

  @override
  void errorNetworkOccurred(String message) {
    if (delegate != null) {
      delegate!.errorNetworkOccurred(message);
    }
  }

  //***********AUTENTICAZIONE************
  Future<LogInResult> logIn(String username, String password) async {
    //try{
      Map<String, String> params = Map();
      params["grant_type"] = "password";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["username"] = username;
      params["password"] = password;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData!.hasError() ) {
        if ( _authenticationData!.error == "Invalid user credentials" ) {
          return LogInResult.error_wrong_credentials;
        }
        else if ( _authenticationData!.error == "Account is not fully set up" ) {
          return LogInResult.error_not_fully_setupped;
        }
        else {
          return LogInResult.error_unknown;
        }
      }
      _restManager.token = _authenticationData!.accessToken;
      User user;
      Map<String,String> m=new Map();
      m["username"]=username;
      String risposta1=await _restManager.makeGetRequest(Constants.HOSTNAME, "/timeout/users/username", TypeHeader.json, m);
      if(risposta1!="NO_RESULTS") {
        user=User.fromJson(json.decode(risposta1));
        if(sharedInstance.appState.existsValue(Constants.STATE_USER))
          sharedInstance.appState.updateValue(Constants.STATE_USER, user);
        else
          sharedInstance.appState.addValue(Constants.STATE_USER, user);
      }
      Timer.periodic(Duration(seconds: (_authenticationData!.expiresIn - 50)), (Timer t) {
        _refreshToken();
      });
      return LogInResult.logged;
  }

    Future<String> registrazione(String username,String email) async {
    List<String> ruoli=List.empty(growable: true);
    ruoli.add("Lettore");
    User user=new User(userName: username, email: email, role: "Lettore");
    String result= await _restManager.makePostRequest(Constants.HOSTNAME, "/timeout/users",user);
    return result;
  }


    Future<bool> _refreshToken() async {
    try {
      Map<String, String> params = Map();
      params["grant_type"] = "refresh_token";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData!.refreshToken;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData!.hasError() ) {
        return false;
      }
      _restManager.token = _authenticationData!.accessToken;
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> logOut() async {
    try{
      Map<String, String> params = Map();
      _restManager.token = null;
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData!.refreshToken;
      await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGOUT, params, type: TypeHeader.urlencoded);
      appState.removeValue(Constants.STATE_USER);
      appState.removeValue(Constants.SALVATI);
      return true;
    }
    catch (e) {
      return false;
    }
  }

}
