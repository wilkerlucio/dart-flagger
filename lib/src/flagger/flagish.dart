part of flagger;

abstract class Flagish<T> {
  T getFlag(Symbol key, [defaultValue = null]);
  Map<Symbol, T> getFlags();
  void setFlag(Symbol key, T value);
  void updateFlags(Map<Symbol, T> map);
}