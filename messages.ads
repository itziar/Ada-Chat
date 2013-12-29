--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Lower_Layer_UDP;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Debug;
with Pantalla;
with Chat_Messages;
with Zeug;
with Ada.Calendar;
with Insta;
with Maps_G;
with Maps_Protector_G;
with M_Debug;


package Messages is
	package CM renames Chat_Messages;
	use type CM.Message_Type;
	package LLU renames Lower_Layer_UDP;
	use type LLU.End_Point_Type;
	package ASU renames Ada.Strings.Unbounded;
	use type CM.Seq_N_T;

	--MENSAJE INIT--
	procedure Send_Init (EP_H_Creat: in LLU.End_Point_Type; Seq_N: in out CM.Seq_N_T; EP_H_Rsnd: in LLU.End_Point_Type; EP_R_Creat: in LLU.End_Point_Type; nick: in out ASU.Unbounded_String);
---------------------------------------------------------------------------------------------------------------	
	
	--MENSAJE REJECT--
	procedure Receive_Reject (EP_R: LLU.End_Point_Type; acept: out Boolean);
	procedure Send_Reject (EP_H: LLU.End_Point_Type; Nick: ASU.Unbounded_String; EP_R_Creat: LLU.End_Point_Type);
---------------------------------------------------------------------------------------------------------------

	--MENSAJE CONFIRM--
	procedure Send_Confirm (EP_H_Creat: LLU.End_Point_Type; Seq_N: in out CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String);
---------------------------------------------------------------------------------------------------------------

	--MENSAJE WRITER--	
	procedure Send_Writer(EP_H_Creat: LLU.End_Point_Type; Seq_N: in out CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String; Text: ASU.Unbounded_String);
---------------------------------------------------------------------------------------------------------------

	--MENSAJE LOGOUT--
	procedure Send_Logout (EP_H_Creat: LLU.End_Point_Type; Seq_N: in out CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String; Confirm_Sent: in out Boolean);	
---------------------------------------------------------------------------------------------------------------
	
	--MENSAJE ACK--
	procedure Send_Ack(EP_H_Acker: LLU.End_Point_Type; EP_H_Creat: LLU.End_Point_Type; Seq_N: CM.Seq_N_T; EP_Dest: LLU.End_Point_Type);

procedure Management (Bett: CM.Message_Type; EP_H_Creat: LLU.End_Point_Type; Seq_N: in out CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String; Text: ASU.Unbounded_String);

end Messages;