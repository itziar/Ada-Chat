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

package Retrans is
	
	package LLU renames Lower_Layer_UDP;
	use Lower_Layer_UDP;
	package CM renames Chat_Messages;
	use type CM.Message_Type;
	use type CM.Seq_N_T;
	use type Ada.Calendar.Time;
	
	procedure Relay(Timer: Ada.Calendar.Time);

end Retrans;