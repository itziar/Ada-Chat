--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Lower_Layer_UDP;
with maps_g;
with maps_protector_g;
with Ada.Strings.Unbounded;
with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;
with Ada.Calendar;
with Zeug;
with Chat_Messages;
with Ordered_Maps_G;
with Ordered_Maps_Protector_G;
with Gnat.Calendar.Time_IO;
with Ada.Strings.Fixed;
with Insta;
with Timed_Handlers;

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
	
	procedure Relay(Timer: Ada.Calendar.Time);
end Retrans;