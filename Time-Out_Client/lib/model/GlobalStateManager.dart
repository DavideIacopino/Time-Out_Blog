class GlobalStateManager {
  List<Function> delegatedFunctions= <Function>[];

  void addStateListener(Function delegatedFunction) {
    delegatedFunctions.add(delegatedFunction);
  }

  void removeStateListener(Function delegatedFunction) {
    delegatedFunctions.remove(delegatedFunction);
  }

  void refreshStates() {
    for ( Function delegatedFunction in delegatedFunctions ) {
      delegatedFunction();
    }
  }
}