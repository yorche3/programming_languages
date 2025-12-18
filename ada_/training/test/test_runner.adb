with AUnit.Run;
with AUnit.Reporter.Text;

with Training_Suite; use Training_Suite;

procedure Test_Runner is
   procedure Runner is new AUnit.Run.Test_Runner (Suite);
   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   Runner (Reporter);
end Test_Runner;
