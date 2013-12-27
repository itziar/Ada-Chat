--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Chat_Handler;
with Lower_Layer_UDP;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Debug;
with Pantalla;
with Chat_Messages;
with Zeug;
with Seq_N_T;
with Ada.Calendar;
with Insta;
with Maps_G;
with Maps_Protector_G;



package M_Debug is
	package CM renames Chat_Messages;
	use type CM.Message_Type;
   package LLU renames Lower_Layer_UDP;
   use type LLU.End_Point_Type;
   package ASU renames Ada.Strings.Unbounded;
	use type Seq_N_T.Seq_N_Type;
	package Handlers renames Chat_Handler;

	procedure Send (EP: LLU.End_Point_Type);
	procedure New_Neighbour(EP: LLU.End_Point_Type);
	procedure New_Message (EP: LLU.End_Point_Type; Seq_N: Seq_N_T.Seq_N_Type);
	procedure Receive (Bett: CM.Message_Type; EP_H_Creat:LLU.End_Point_Type; Seq_N: Seq_N_T.Seq_N_Type; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String);


end M_Debug;