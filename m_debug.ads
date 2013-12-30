--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Calendar;
with Chat_Messages;
with Debug;
with Insta;
with Lower_Layer_UDP;
with Pantalla;
with Zeug;

package M_Debug is

	package ASU renames Ada.Strings.Unbounded;
	package CM renames Chat_Messages;
	use type CM.Message_Type;
	use type CM.Seq_N_T;
	package LLU renames Lower_Layer_UDP;
	use type LLU.End_Point_Type;
	

	procedure Send (EP: LLU.End_Point_Type);
	procedure New_Neighbour(EP: LLU.End_Point_Type);
	procedure New_Message (EP: LLU.End_Point_Type; Seqi: CM.Seq_N_T);
	procedure Receive (Bett: CM.Message_Type; EP_H_Creat:LLU.End_Point_Type; Seq_N: CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String);
	procedure Delete_Message(EP_H_Creat: LLU.End_Point_Type);
	procedure Delete_Neighbors(EP_H_Creat: LLU.End_Point_Type);
	procedure Send_Reject (EP_H: LLU.End_Point_Type; Nick: ASU.Unbounded_String);

end M_Debug;