--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Ada.Calendar;
with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;
with Chat_Messages;
with Insta;
with Lower_Layer_UDP;
with Maps_G;
with Maps_Protector_G;
with Ordered_Maps_G;
with Ordered_Maps_Protector_G;
with Timed_Handlers;
with Zeug;
with Ada.Text_IO;
with Lower_Layer;

package Retrans is
	
	package LLU renames Lower_Layer_UDP;
	use type Lower_Layer.Address_CA;
	use type Lower_Layer_UDP.End_Point_Type;
	package CM renames Chat_Messages;
	use type CM.Message_Type;
	use type CM.Seq_N_T;
	use type Ada.Calendar.Time;
	
	procedure Relay(Timer: Ada.Calendar.Time);

end Retrans;