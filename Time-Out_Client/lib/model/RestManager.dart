import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:timeoutflutter/model/ErrorListener.dart';
import 'ErrorListener.dart';

enum TypeHeader {
  json,
  urlencoded
}

class RestManager {
  ErrorListener? delegate;
  String? token;


  Future _makeRequest(String serverAddress, String servicePath, String method, TypeHeader type, {Map<String, dynamic>? value, dynamic body}) async {
    Uri uri;
    if(value==null)
      uri = Uri.http(serverAddress, servicePath);
    else
      uri = Uri.http(serverAddress, servicePath,value);
    bool errorOccurred = false;
    while ( true ) {
          dynamic response;
          String contentType="";
          dynamic formattedBody;
          if ( type == TypeHeader.json ) {
            contentType = "application/json;charset=utf-8";
            formattedBody = json.encode(body);
          }
          else if ( type == TypeHeader.urlencoded ) {
            contentType = "application/x-www-form-urlencoded";
            formattedBody = body.keys.map((key) => "$key=${body[key]}").join("&");
          }
          Map<String, String> headers = Map();
          headers[HttpHeaders.contentTypeHeader] = contentType;
          if ( token != null ) {
            headers[HttpHeaders.authorizationHeader] = 'bearer $token';
          }
          switch ( method ) {
            case "post":
              response = await post(
                uri,
                headers: headers,
                body: formattedBody,
              );
              break;
            case "get":
              response = await get(
                uri,
                headers: headers, //get non ha il body
              );
              break;
            case "put":
              response = await put(
                uri,
                headers: headers,
              );
              break;
            case "delete":
              response = await put(
                uri,
                headers: headers,
              );
              break;
          }
          if ( delegate != null && errorOccurred ) {
            delegate!.errorNetworkGone();
            errorOccurred = false;
          }
          return response.body;
      }
    }


  Future makePostRequest(String serverAddress, String servicePath, dynamic value, {TypeHeader type = TypeHeader.json}) async {
    return ( _makeRequest(serverAddress, servicePath, "post", type, body: value));
  }

  Future makeGetRequest(String serverAddress, String servicePath, TypeHeader type, [Map<String,dynamic>? value]) async {
    return await (_makeRequest(serverAddress, servicePath, "get", type, value: value));
  }

  Future makePutRequest(String serverAddress, String servicePath, TypeHeader type, [Map<String, String>? value]) async {
    return _makeRequest(serverAddress, servicePath, "put", type, value: value);
  }

  Future makeDeleteRequest(String serverAddress, String servicePath, TypeHeader type, [Map<String, String>? value]) async {
    return _makeRequest(serverAddress, servicePath, "delete", type, value: value);
  }

}