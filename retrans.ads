--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Lower_Layer_UDP;
with maps_g;
with maps_protector_g;
with Ada.Strings.Unbounded;
with Ada.Calendar;
with Zeug;
with Chat_Messages;
with Ordered_Maps_G;
with Ordered_Maps_Protector_G;
with Gnat.Calendar.Time_IO;
with Ada.Strings.Fixed;

package Retrans is

	package ASU renames Ada.Strings.Unbounded;
	use type ASU.Unbounded_String;
	package LLU renames Lower_Layer_UDP;
	use Lower_Layer_UDP;
	package CM renames Chat_Messages;
	use type ASU.Unbounded_String;
	use type Ada.Calendar.Time;
	use type CM.Message_Type;
	use type CM.Seq_N_T;
	use Ada.Strings.Fixed;
		package C_IO renames Gnat.Calendar.Time_IO;
	
	Null_EP 	: constant LLU.End_Point_Type := LLU.Build("0.0.0.0", 0);
	Null_Hour: constant Ada.Calendar.Time := Ada.Calendar.Time_Of(1970, 1, 1);
	Null_Seq	: constant CM.Seq_N_T := 0;
	

   
   function Image_Time (T : Ada.Calendar.Time) return String;   
   
	function Image_EP (EP_N : LLU.End_Point_Type) return String;
	
	function Mess_Iguales (Mess_1, Mess_2 : CM.Mess_Id_T) return Boolean;
	
	function Mess_Menor (Mess_1, Mess_2 : CM.Mess_Id_T) return Boolean;
	
	function Mess_Mayor (Mess_1, Mess_2 : CM.Mess_Id_T) return Boolean;
	
	function Image_Mess (Mess : CM.Mess_Id_T) return String;
	
	function Image_Destinations (Dest : CM.Destinations_T) return String;
	
	function Image_Value (Value : CM.Value_T) return String;
end Retrans;