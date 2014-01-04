--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Ada.Calendar;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;
with Chat_Messages;
with Debug;
with Insta;
with Lower_Layer_UDP;
with M_Debug;
with Pantalla;
with Timed_Handlers;
with Lower_Layer;

package Messages is
	use type Lower_Layer.Address_CA;
--	use Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	use type ASU.Unbounded_String;
	
	package CM renames Chat_Messages;
	use type CM.Message_Type;
	use type CM.Seq_N_T;
	package LLU renames Lower_Layer_UDP;
	use type LLU.End_Point_Type;
	use type Ada.Calendar.Time;

	
	procedure Send_Supernode(EP_H: LLU.End_Point_Type; EP_R: LLU.End_Point_Type; EP_H_S: LLU.End_Point_Type; N: Integer);
	procedure Management_Supernode (EP_H: LLU.End_Point_Type; EP_R: LLU.End_Point_Type; N: in out Integer);
	procedure Receive_Supernode (EP_R: LLU.End_Point_Type);

	--MENSAJE REJECT--
	procedure Receive_Reject (EP_R: LLU.End_Point_Type; acept: out Boolean);
	procedure Send_Reject (EP_H: LLU.End_Point_Type; Nick: ASU.Unbounded_String; EP_R_Creat: LLU.End_Point_Type);
---------------------------------------------------------------------------------------------------------------

	
	--MENSAJE ACK--
procedure Send_Ack(EP_H_Acker: LLU.End_Point_Type; EP_H_Creat: LLU.End_Point_Type; Seq_N: CM.Seq_N_T; EP_Dest: LLU.End_Point_Type);

procedure Management (Bett: CM.Message_Type; EP_H_Creat: LLU.End_Point_Type; Seqi: in out CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; EP_R_Creat: LLU.End_Point_Type; Nick: ASU.Unbounded_String; Text: ASU.Unbounded_String; Confirm_Sent: Boolean);

procedure Send(Bett: CM.Message_Type; EP_H_Creat: LLU.End_Point_Type; Seqi: CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; EP_R_Creat: LLU.End_Point_Type; Nick : ASU.Unbounded_String; Text: ASU.Unbounded_String; Confirm_Sent: Boolean; EP_H_Receive: LLU.End_Point_Type);

procedure Relay(Timer: Ada.Calendar.Time);

procedure Manejador;

end Messages;