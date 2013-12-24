--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--
with Lower_Layer_UDP;

with Seq_N_T;
with Ada.Strings.Unbounded;
with Ada.Calendar;
with Gnat.Calendar.Time_IO;
with Ada.Strings.Fixed;

package Chat_Messages is
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package C_IO renames Gnat.Calendar.Time_IO;
	use type Seq_N_T.Seq_N_Type;
	use Lower_Layer_UDP;
	use Ada.Strings.Fixed;
	use Ada.Strings.Unbounded;

	type Message_Type is (Init, Reject, Confirm, Writer, Logout);

	type Mess_Id_T is record
		EP: LLU.End_Point_Type;
		Seq: Seq_N_T.Seq_N_Type;
	end record;
	
	type Destination_T is record
		Ep: Llu.End_Point_Type := null;
		Retries : Natural := 0;
	end record;
	
	type Destinations_T is array (1..10) of Destination_T;

	type Buffer_A_T is access LLU.Buffer_Type;
	
	type Value_T is record
		EP_H_Creat: LLU.End_Point_Type;
		Seq_N: Seq_N_T.Seq_N_Type;
		P_Buffer: Buffer_A_T;
	end record;

	P_Buffer_Main: Buffer_A_T;
	P_Buffer_Handler: Buffer_A_T;
 Null_EP 	: constant LLU.End_Point_Type := LLU.Build("0.0.0.0", 0);
	Null_Hour: constant Ada.Calendar.Time := Ada.Calendar.Time_Of(1970, 1, 1);
   Null_Seq	: constant Seq_N_T.Seq_N_Type := 0;
	Maquina 	: constant ASU.Unbounded_String := ASU.To_Unbounded_String(LLU.Get_Host_Name);
	IP_Nodo  : constant ASU.Unbounded_String := ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Maquina)));
	EP_H 		: LLU.End_Point_Type;
   Nick		: ASU.Unbounded_String;   
	Min_Delay: Natural;
	Max_Delay: Natural;
	Fault_Pct: Natural;
   P_Buffer : Buffer_A_T;
   
   function Image_Time (T : Ada.Calendar.Time) return String;   
   
	function Image_EP (EP_N : LLU.End_Point_Type) return String;
	
	function Mess_Iguales (Mess_1, Mess_2 : Mess_Id_T) return Boolean;
	
	function Mess_Menor (Mess_1, Mess_2 : Mess_Id_T) return Boolean;
	
	function Mess_Mayor (Mess_1, Mess_2 : Mess_Id_T) return Boolean;
	
	function Image_Mess (Mess : Mess_Id_T) return String;
	
	function Image_Destinations (Dest : Destinations_T) return String;
	
	function Image_Value (Value : Value_T) return String;

end Chat_Messages;
