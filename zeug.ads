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


with Lower_Layer_UDP;

with Debug;

with Chat_Messages;

with Pantalla;



with Gnat.Calendar.Time_IO;

	  
with Lower_Layer_UDP;
with maps_g;
with maps_protector_g;


with Ordered_Maps_G;
with Ordered_Maps_Protector_G;



package Zeug is 
	package LLU renames Lower_Layer_UDP;
		use Lower_Layer_UDP;

	package ASU renames Ada.Strings.Unbounded;
		use type ASU.Unbounded_String;

	package CM renames Chat_Messages;	
	package C_IO renames Gnat.Calendar.Time_IO;
	use Ada.Strings.Fixed;

	use type Ada.Calendar.Time;
	use type CM.Message_Type;
	use type CM.Seq_N_T;

	procedure Spitzname(nick: in out ASU.Unbounded_String);
	procedure Hafen (EP_H: in out LLU.End_Point_Type);
	procedure Schneiden (EP_N: in LLU.End_Point_Type; Neighbour: out ASU.Unbounded_String);	
	procedure Information (Purge: in out Boolean);
   	procedure Name (prompt: in out Boolean);
   function SchneidenString (EP_N: in LLU.End_Point_Type) return String;
   function Time_Image_One (T: Ada.Calendar.Time) return String;
   min_delay:Integer:=Integer'Value(Ada.Command_Line.Argument(3));	
		max_delay:Integer:=Integer'Value(Ada.Command_Line.Argument(4));
		fault_pct:Integer:=Integer'Value(Ada.Command_Line.Argument(5));
		port: Integer:= Integer'Value(Ada.Command_Line.Argument(1));
		Host:ASU.Unbounded_String:= ASU.To_Unbounded_String(LLU.Get_Host_Name);
		IP:ASU.Unbounded_String:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Host)));
		Nick:ASU.Unbounded_String:=ASU.To_Unbounded_String(Ada.Command_Line.Argument(2));
	EP_H: LLU.End_Point_Type:=LLU.Build (ASU.To_String(IP), Port);
   Purge: Boolean:=True;
	Prompt: Boolean:=False;
	----------------------------
		Null_EP 	: constant LLU.End_Point_Type := LLU.Build("0.0.0.0", 0);
	Null_Hour: constant Ada.Calendar.Time := Ada.Calendar.Time_Of(1970, 1, 1);
	Null_Seq	: constant CM.Seq_N_T := 0;
	

   
   function Image_Time (T : Ada.Calendar.Time) return String;   
   
	function Image_EP (EP_N : LLU.End_Point_Type) return String;
	
	function Mess_Iguales (Mess_1, Mess_2 : CM.Mess_Id_T) return Boolean;
	
	function Mess_Menor (Mess_1, Mess_2 : CM.Mess_Id_T) return Boolean;
	
	function Mess_Mayor (Mess_1, Mess_2 : CM.Mess_Id_T) return Boolean;
	
	function Image_Mess (Mess : CM.Mess_Id_T) return String;
	
	function Image_Destinations (Dest : CM.Destinations_T) return String;
	
	function Image_Value (Value : CM.Value_T) return String;
end Zeug;
