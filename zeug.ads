--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--
with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Lower_Layer_UDP;
with Debug;
with Chat_Messages;

with Pantalla;
with Ada.Calendar;
with Ada.Strings.Fixed;
with Ada.Text_IO;
with Ada.Unchecked_Conversion;
with Ada.Text_IO;
with Gnat.Calendar.Time_IO;

package Zeug is 
	package LLU renames Lower_Layer_UDP;
	package ASU renames Ada.Strings.Unbounded;
	package CM renames Chat_Messages;	
	package C_IO renames Gnat.Calendar.Time_IO;
	use Ada.Strings.Fixed;
	  
	procedure Spitzname(nick: in out ASU.Unbounded_String);
	procedure Hafen (EP_H: in out LLU.End_Point_Type);
	procedure Schneiden (EP_N: in LLU.End_Point_Type; Neighbour: out ASU.Unbounded_String);	
	procedure Information (Purge: in out Boolean);
   procedure Name (prompt: in out Boolean);
   function SchneidenString (EP_N: in LLU.End_Point_Type) return String;
   function Time_Image_One (T: Ada.Calendar.Time) return String;
   min_delay:=Integer'Value(Ada.Command_Line.Argument(3));	
		max_delay:=Integer'Value(Ada.Command_Line.Argument(4));
		fault_pct:=Integer'Value(Ada.Command_Line.Argument(5));
   
end Zeug;
