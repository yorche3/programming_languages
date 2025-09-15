
# Unit Test projects with alire, gprbuild and Ada with AUnit
How were build unit test projects.

## Requisites
- Install
  - [Ada](https://ada-lang.io)
  - [Alire](https://alire.ada.dev/)
  - [Grpbuild](https://github.com/AdaCore/grb)
  - AUnit is part of AdaCore

## Build project
```
alr build --bin demo
```

## Structure
```text
demo
|-- src
|   |-- numbers.adb
|-- test
|   |-- run_tests.adb
|-- alire.toml
|-- numbers.gpr
|-- test.gpr
```

## Modify project
Go to `demo` directory and

- modify the `demo.gpr` file similar to the following:
```gpr
project Demo is

   for Source_Dirs use ("src/");
   for Object_Dir use "obj/";
   for Create_Missing_Dirs use "True";
   for Exec_Dir use "bin";
   for Main use ("demo.adb");

   package Compiler is
      for Default_Switches ("ada") use
        ("-g", "-gnatQ", "-O1", "-gnatf", "-gnato",
         "-gnatwa.Xe", "-gnaty", "-gnat05");
   end Compiler;

   package Binder is
      for Switches ("Ada") use ("-Es"); --  Symbolic traceback
   end Binder;

   package Install is
      for Artifacts (".") use ("share");
   end Install;

end Demo;
```

- create a `test.gpr` file and adecuate it similar to the following:
 ```gpr
with "aunit.gpr";

project Test is
    for Languages use ("Ada");
   for Main use ("run_tests.adb");
   for Source_Dirs use ("test", "test/interfaces", "test/implementations", "src/interfaces", "src/implementations");
   for Exec_Dir use ".";
   for Object_Dir use "obj";

   package Linker is
      for Default_Switches ("ada") use ("-g");
   end Linker;

   package Binder is
      for Default_Switches ("ada") use ("-E", "-static");
   end Binder;

   package Compiler is
      for Default_Switches ("ada") use
        ("-g", "-gnatQ", "-O1", "-gnatf", "-gnato",
         "-gnatwa.Xe", "-gnaty", "-gnat05");
   end Compiler;

end Test;
```

- create a directory `test`
- create a file `run_tests.adb` in the `test/` directory with the following content:
```ada
with AUnit.Run;
with AUnit.Reporter.Text;
with Example_Suite1; use Example_Suite1;
with Example_Suite1; use Example_Suite1;

procedure Run_Tests is
   procedure Runner1 is new AUnit.Run.Test_Runner (Suite1);
   procedure Runner2 is new AUnit.Run.Test_Runner (Suite2);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Runner1 (Reporter);
end Run_Tests;
```
**NOTA**: the `test/interfaces` and `test/implementations` directories are optional, they are used to separate the interfaces and implementations of the tests.

- each test suite should be in a separate file, for example `example_suite1.ads`:
```ada
with AUnit.Test_Suites; use AUnit.Test_Suites;

package Example_Suite1 is
   function Suite1 return Access_Test_Suite;
end Example_Suite1;
```
-its implementation in a file `example_suite1.adb`:
```ada
with AUnit.Test_Caller;
with Example_Tests; use Example_Tests;

package body Example_Suite1 is
   package Caller is new AUnit.Test_Caller (Example_Tests.Test);
   function Suite1 return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
         (Caller.Create
            ("Function1", Test_Funtion1'Access));
      Ret.Add_Test
         (Caller.Create
            ("Function2", Test_Function2'Access));
      return Ret;
   end Suite1;
end Example_Suite1;
```

- create a file `example_tests.ads`:
```ada
with AUnit;
with AUnit.Test_Fixtures;

package Example_Tests is
   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

   procedure Test_Function1 (Self : in out Test);
   procedure Test_Function2 (Self : in out Test);
end Example_Tests;
```

- its implementation in a file `example_tests.adb`:
```ada
with AUnit.Assertions; use AUnit.Assertions;
with Example; use Example;

package body Example_Tests is
   procedure Test_Function1 (Self : in out Test) is
   begin
      Assert (Function1 (X) = Expected, "Function1 result should be equals as Expected");
   end Test_Function1;

   procedure Test_Function2 (Self : in out Test) is
   begin
      Assert (Function2 (X) = Expected, "Function2 result should be equals as Expected");
   end Test_Function2;
end Example_Tests;
```

## Compile and run tests
### Compile
```bash
gprbuild -p -P test.gpr
```
or
```bash
gprbuild -p -P demo.gpr
```
### Run
```bash
./run_tests
```
or
```bash
./demo
```