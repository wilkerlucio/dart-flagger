part of flagger;

abstract class Flagish<T> {
  T getFlag(Symbol key, [defaultValue = null]);
  void setFlag(Symbol key, T value);
  void updateFlags(Map<Symbol, T> map);
}