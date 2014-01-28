part of flagger;

class Flaggable<T> implements Flagish<T> {
  Map<Symbol, T> __flags = {};

  T getFlag(Symbol key, [defaultValue = null]) {
    return __flags.containsKey(key) ? __flags[key] : defaultValue;
  }

  void setFlag(Symbol key, T value) {
    __flags[key] = value;
  }
}