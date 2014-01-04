--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--
with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Calendar;
with Ada.Strings.Fixed;
with Ada.Unchecked_Conversion;
with Debug;
with Gnat.Calendar.Time_IO;
with Lower_Layer_UDP;  
with Maps_G;
with Maps_Protector_G;
with Ordered_Maps_G;
with Ordered_Maps_Protector_G;
with Pantalla;

package Chat_Messages is

	package C_IO renames Gnat.Calendar.Time_IO;
	package ASU renames Ada.Strings.Unbounded;
	package C_L renames Ada.Command_Line;
	package LLU renames Lower_Layer_UDP;
	use LLU;
	use type ASU.Unbounded_String;

	type Message_Type is (Init, Reject, Confirm, Writer, Logout, Ack);

	type Seq_N_T is mod Integer'Last;

	Null_EP : constant LLU.End_Point_Type := LLU.Build("0.0.0.0", 0);
	Null_Hour : constant Ada.Calendar.Time := Ada.Calendar.Time_Of(1970, 1, 1);
	Null_Seq : constant Seq_N_T := 0;
	Maquina : constant ASU.Unbounded_String := ASU.To_Unbounded_String(LLU.Get_Host_Name);
	IP_Nodo : constant ASU.Unbounded_String := ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Maquina)));
	EP_H : LLU.End_Point_Type;
	Nick : ASU.Unbounded_String;   
	Min_Delay : Integer;
	Max_Delay : Integer;
	Fault_Pct : Integer;
	Purge : Boolean:=True;
	Prompt : Boolean:=False;

	type Mess_Id_T is record
		EP : LLU.End_Point_Type;
		Seq : Seq_N_T;
	end record;

	type Destination_T is record
		EP : LLU.End_Point_Type := Null_EP;
		Retries : Natural := 0;
	end record;

	type Destinations_T is array (1..10) of Destination_T;

	type Buffer_A_T is access LLU.Buffer_Type;

	type Value_T is record
		EP_H_Creat : LLU.End_Point_Type;
		Seq_N : Seq_N_T;
		P_Buffer : Buffer_A_T;
	end record;

	P_Buffer : Buffer_A_T;

	----------------------------

	procedure Information (Purge : in out Boolean);
   	procedure Name (prompt : in out Boolean);
	function SchneidenString (EP_N : in LLU.End_Point_Type) return String;
	function Time_Image_One (T : Ada.Calendar.Time) return String;
	function Mess_Equal (Mess_1 : Mess_Id_T; Mess_2 : Mess_Id_T) return Boolean;
	function Mess_Less (Mess_1 : Mess_Id_T; Mess_2 : Mess_Id_T) return Boolean;
	function Mess_More (Mess_1 : Mess_Id_T; Mess_2 : Mess_Id_T) return Boolean;
	function Mess_Image (Mess : Mess_Id_T) return String;
	function Dest_Image (Dest : Destinations_T) return String;
	function Val_Image (Value : Value_T) return String;
	
end Chat_Messages;
