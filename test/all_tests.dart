import 'package:barrier/dsl.dart';
import 'package:flagger/flagger.dart';

class SimpleClass extends Object with Flaggable<String> {}

class NestableClass extends Object with NestedFlaggable<String> {
  NestableClass parent;

  NestableClass([this.parent]) {}
}

void main() {
  run(() {
    describe("Flaggable", () {
      describe("#getFlag", () {
        it("returns null if the flag is not set", () {
          Flaggable obj = new SimpleClass();
          expect(obj.getFlag(#name)) == null;
        });

        it("returns the default value if that's is passed", () {
          Flaggable obj = new SimpleClass();
          expect(obj.getFlag(#name, "Unknow")) == "Unknow";
        });
      });

      describe("#setFlag", () {
        it("set's a flag to recover later", () {
          Flaggable obj = new SimpleClass();
          obj.setFlag(#name, "Mr White");
          expect(obj.getFlag(#name)) == "Mr White";
        });

        it("returns null instead of default if key is set as null", () {
          SimpleClass obj = new SimpleClass();
          expect(obj.getFlag(#name, "unknow")) == null;
        });
      });
    });

    describe("NestedFlaggable", () {
      describe("#getFlag", () {
        it("returns the flag if it has it", () {
          NestedFlaggable obj = new NestableClass();
          obj.setFlag(#name, "Hi");
          expect(obj.getFlag(#name)) == "Hi";
        });

        it("recursive fetchs the flag on parents", () {
          NestedFlaggable root = new NestableClass();
          NestedFlaggable child1 = new NestableClass(root);
          NestedFlaggable child2 = new NestableClass(child1);

          root.setFlag(#onRoot, "root");
          child1.setFlag(#parentMe, "parent");
          child2.setFlag(#self, "me");

          expect(child2.getFlag(#self)) == "me";
          expect(child2.getFlag(#parentMe)) == "parent";
          expect(child2.getFlag(#onRoot)) == "root";
          expect(child2.getFlag(#notdef)) == null;
        });
      });
    });
  });
}