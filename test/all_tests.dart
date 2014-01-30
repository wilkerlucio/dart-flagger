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

      describe("#getFlags", () {
        it("returns empty map when not flags are set", () {
          Flaggable obj = new SimpleClass();
          expect(obj.getFlags().isEmpty) == true;
        });

        it("returns the flags that are current set", () {
          Flaggable obj = new SimpleClass()
            ..setFlag(#name, "hello")
            ..setFlag(#other, "value");

          Map<Symbol, String> flags = obj.getFlags();

          expect(flags[#name]) == "hello";
          expect(flags[#other]) == "value";
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
          obj.setFlag(#name, null);
          expect(obj.getFlag(#name, "unknow")) == null;
        });
      });

      describe("#updateFlags", () {
        it("updates flags from a Map", () {
          SimpleClass obj = new SimpleClass();
          obj.updateFlags({#name: "Mr White", #job: "Alchemist"});

          expect(obj.getFlag(#name)) == "Mr White";
          expect(obj.getFlag(#job)) == "Alchemist";
        });

        it("silent does nothing when null is passed", () {
          SimpleClass obj = new SimpleClass();
          obj.updateFlags(null);
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
          expect(child2.getFlag(#notdef, "default")) == "default";
        });
      });

      describe("#getFlags", () {
        it("recursive get flags combined with all parents", () {

          Flagish root = new NestableClass();
          Flagish child1 = new NestableClass(root);

          root.setFlag(#first, "root");
          root.setFlag(#second, "onRoot");
          child1.setFlag(#first, "child");

          Map<Symbol, String> flags = child1.getFlags();

          expect(flags[#first]) == "child";
          expect(flags[#second]) == "onRoot";
        });
      });

      describe("#updateFlags", () {
        it("updates flags from a Map", () {
          NestedFlaggable obj = new NestableClass();
          obj.updateFlags({#name: "Mr White", #job: "Alchemist"});

          expect(obj.getFlag(#name)) == "Mr White";
          expect(obj.getFlag(#job)) == "Alchemist";
        });

        it("silent does nothing when null is passed", () {
          NestedFlaggable obj = new NestableClass();
          obj.updateFlags(null);
        });
      });
    });
  });
}