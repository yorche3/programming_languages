with AUnit.Test_Caller;

with Training_Test; use Training_Test;

package body Training_Suite is

   package Caller is new AUnit.Test_Caller (Training_Test.Test);

   function Suite return Access_Test_Suite is
      Ret : constant Access_Test_Suite := new Test_Suite;
   begin
      Ret.Add_Test
         (Caller.Create
            ("Test Hello", Test_Hello'Access));
      return Ret;
   end Suite;
end Training_Suite;