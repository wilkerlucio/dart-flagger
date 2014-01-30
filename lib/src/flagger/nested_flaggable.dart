part of flagger;

abstract class NestedFlaggable<T> implements Flagish<T> {
  Map<Symbol, T> __flags = {};

  NestedFlaggable<T> get parent;

  T getFlag(Symbol key, [defaultValue = null]) {
    if (__flags.containsKey(key))
      return __flags[key];
    else if (parent == null)
      return defaultValue;

    return parent.getFlag(key, defaultValue);
  }

  Map<Symbol, T> getFlags() {
    Map<Symbol, T> flags = {};

    for (NestedFlaggable<T> obj in ancestorsChain.reversed) {
      obj.__flags.forEach((Symbol key, T value) {
        flags[key] = value;
      });
    }

    return flags;
  }

  void setFlag(Symbol key, T value) {
    __flags[key] = value;
  }

  void updateFlags(Map<Symbol, T> map) {
    if (map == null)
      return;

    map.forEach((Symbol key, T value) {
      setFlag(key, value);
    });
  }

  List<NestedFlaggable<T>> get ancestorsChain {
    List<NestedFlaggable<T>> chain = [];
    NestedFlaggable<T> current = this;

    do {
      chain.add(current);
      current = current.parent;
    } while (current != null);

    return chain;
  }
}