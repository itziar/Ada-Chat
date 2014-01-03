

with Ada.Strings.Unbounded.Text_IO;
with Ada.Strings.Unbounded;
with Gnat.Calendar.Time_IO;
with Ada.Command_Line;
with Lower_Layer_UDP;
with Lower_Layer;
with Ada.Calendar;
with Ada.Text_IO;

package Chat_Messages is

	package C_IO renames Gnat.Calendar.Time_IO;
	package ASU renames Ada.Strings.Unbounded;
	package C_L renames Ada.Command_Line;
	package LLU renames Lower_Layer_UDP;
	use type Lower_Layer.Address_CA;
	use type ASU.Unbounded_String;
	
   Null_EP 	: constant LLU.End_Point_Type := LLU.Build("0.0.0.0", 0);
   
	type Message_Type is (Init, Reject, Confirm, Writer, Logout, Ack);
	
	type Seq_N_T is mod Integer'Last;
   
   type Mess_Id_T is record
   	EP : LLU.End_Point_Type;
   	Seq: Seq_N_T;
   end record;
   
   type Destination_T is record
   	EP 	  : LLU.End_Point_Type := Null_EP;
   	Retries : Natural := 0;
   end record;
   
   type Destinations_T is array (1..10) of Destination_T;
   
   type Buffer_A_T is access LLU.Buffer_Type;
   
   type Value_T is record
   	EP_H_Creat : LLU.End_Point_Type;
   	Seq_N		  : Seq_N_T;
   	P_Buffer	  : Buffer_A_T;
   end record;
   
   Null_Hour: constant Ada.Calendar.Time := Ada.Calendar.Time_Of(1970, 1, 1);
   Null_Seq	: constant Seq_N_T := 0;
	Maquina 	: constant ASU.Unbounded_String := ASU.To_Unbounded_String(LLU.Get_Host_Name);
	IP_Nodo  : constant ASU.Unbounded_String := ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Maquina)));
	EP_H 		: LLU.End_Point_Type;
   Nick		: ASU.Unbounded_String;   
	Min_Delay: Natural;
	Max_Delay: Natural;
	Fault_Pct: Natural;
   P_Buffer : Buffer_A_T;
   
   function Image_Time (T : Ada.Calendar.Time) return String;   
   
	function Image_EP (EP_Neigh : LLU.End_Point_Type) return String;
	
	function Mess_Iguales (Mess_1, Mess_2 : Mess_Id_T) return Boolean;
	
	function Mess_Menor (Mess_1, Mess_2 : Mess_Id_T) return Boolean;
	
	function Mess_Mayor (Mess_1, Mess_2 : Mess_Id_T) return Boolean;
	
	function Image_Mess (Mess : Mess_Id_T) return String;
	
	function Image_Destinations (Dest : Destinations_T) return String;
	
	function Image_Value (Value : Value_T) return String;
	
end Chat_Messages;
