with AUnit.Assertions; use AUnit.Assertions;

with Training; use Training;

package body Training_Test is

   procedure Test_Hello (T : in out Test) is
   begin
      Assert (Hello = "Hello from a submodule!", "Unexpected greeting");
   end Test_Hello;

end Training_Test;