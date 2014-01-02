--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Ada.Calendar;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Chat_Messages;
with Debug;
with Insta;
with Lower_Layer_UDP;
with M_Debug;
with Pantalla;
with Zeug;
with Timed_Handlers;
with Retrans;
with Lower_Layer;

package Messages is
	use type Lower_Layer.Address_CA;
--	use Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package CM renames Chat_Messages;
	use type CM.Message_Type;
	use type CM.Seq_N_T;
	package LLU renames Lower_Layer_UDP;
	use type LLU.End_Point_Type;
	use type Ada.Calendar.Time;

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