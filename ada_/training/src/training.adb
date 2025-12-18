with Training.Utils;

package body Training is
   function Hello return String is
   begin
      return Training.Utils.Get_Greeting;
   end Hello;
end Training;
