with AUnit;
with AUnit.Test_Fixtures;

package Training_Test is
   type Test is new AUnit.Test_Fixtures.Test_Fixture with null record;

   procedure Test_Hello (T : in out Test);
end Training_Test;