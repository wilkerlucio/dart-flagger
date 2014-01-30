part of flagger;

class Flaggable<T> implements Flagish<T> {
  Map<Symbol, T> __flags = {};

  T getFlag(Symbol key, [defaultValue = null]) {
    return __flags.containsKey(key) ? __flags[key] : defaultValue;
  }

  Map<Symbol, T> getFlags() {
    return __flags;
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
}