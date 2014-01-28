part of flagger;

abstract class NestedFlaggable<T> implements Flagish<T> {
  Map<Symbol, T> __flags = {};

  NestedFlaggable<T> get parent;

  T getFlag(Symbol key, [defaultValue = null]) {
    if (__flags.containsKey(key))
      return __flags[key];
    else
      if (parent == null)
        return defaultValue;

      return parent.getFlag(key, defaultValue);
  }

  void setFlag(Symbol key, T value) {
    __flags[key] = value;
  }

  void updateFlags(Map<Symbol, T> map) {
    map.forEach((Symbol key, T value) {
      setFlag(key, value);
    });
  }
}