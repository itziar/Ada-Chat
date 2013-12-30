--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Exceptions;
with Ada.Strings.Unbounded;
with Ada.Calendar;
with Chat_Messages;
with Debug;
with Insta;
with Lower_Layer_UDP;
with Messages;
with M_Debug;
with Maps_G;
with Maps_Protector_G;
with Ordered_Maps_G;
with Ordered_Maps_Protector_G;
with Pantalla;
with Retrans;
with Zeug;

package Chat_Handler is
	package ASU renames Ada.Strings.Unbounded;
	use type ASU.Unbounded_String;
	package LLU renames Lower_Layer_UDP;
	use Lower_Layer_UDP;
	package CM renames Chat_Messages;
	use type Ada.Calendar.Time;
	use type CM.Message_Type;
	use type CM.Seq_N_T;

	
	-- This procedure must NOT be called. It's called from LLU
	procedure EP_Handler (From : in LLU.End_Point_Type;
						To : in LLU.End_Point_Type;
						P_Buffer : access LLU.Buffer_Type);


end Chat_Handler;
