--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Lower_Layer_UDP;
with maps_g;
with maps_protector_g;
with Ada.Strings.Unbounded;
with Ada.Calendar;
with Seq_N_T;
with Zeug;
with Chat_Messages;
with Ordered_Maps_G;
with Ordered_Maps_Protector_G;

package Chat_Handler is
	package ASU renames Ada.Strings.Unbounded;
	use type ASU.Unbounded_String;
	package LLU renames Lower_Layer_UDP;
	use Lower_Layer_UDP;
	package CM renames Chat_Messages;
	use type ASU.Unbounded_String;
   use type Ada.Calendar.Time;
   use type CM.Message_Type;
	use type Seq_N_T.Seq_N_Type;


	Purge: Boolean:=True;
	Prompt: Boolean:=False;
	-- This procedure must NOT be called. It's called from LLU
	procedure EP_Handler (From     : in     LLU.End_Point_Type;
													To       : in     LLU.End_Point_Type;
													P_Buffer : access LLU.Buffer_Type);


end Chat_Handler;
