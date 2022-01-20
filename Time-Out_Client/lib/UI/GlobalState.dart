import 'package:flutter/material.dart';
import 'package:timeoutflutter/model/ErrorListener.dart';
import 'package:timeoutflutter/model/ModelFacade.dart';

abstract class GlobalState<T extends StatefulWidget> extends State<T> implements ErrorListener {
  SnackBar? errorSnackBar;

  GlobalState () {}

  @override
  void initState() {
    super.initState();
    ModelFacade.sharedInstance.appState.addStateListener(_setState);
    ModelFacade.sharedInstance.delegate = this;
  }

  @override
  void deactivate() {
    ModelFacade.sharedInstance.appState.removeStateListener(_setState);
    if ( ModelFacade.sharedInstance.delegate == this ) {
      ModelFacade.sharedInstance.delegate = null;
    }
    super.deactivate();
  }

  void _setState() {
    setState(() {
      refreshState();
    });
  }

  @override
  void errorNetworkGone() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    errorSnackBar = null;
  }

  @override
  void errorNetworkOccurred(String message) {
    if ( errorSnackBar != null ) {
      return;
    }
    errorSnackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar!);
  }

  void refreshState();
}