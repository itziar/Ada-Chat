--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Lower_Layer_UDP;
with maps_g;
with maps_protector_g;
with Ada.Strings.Unbounded;
with Ada.Calendar;
with Seq_N_T;
with Zeug;

package Chat_Handler is
	package ASU renames Ada.Strings.Unbounded;
	use type ASU.Unbounded_String;
   package LLU renames Lower_Layer_UDP;
   use Lower_Layer_UDP;
 
  
   
   package NP_Neighbors is new Maps_G (Key_Type   => LLU.End_Point_Type,
                               Value_Type => Ada.Calendar.Time,
                               Null_Key => null,
                               Null_Value => 0,
                               Max_Length => 10,
                               "="        => LLU."=",
                               Key_To_String  => Zeug.SchneidenString,
                               Value_To_String  => Zeug.Time_Image_One);
	package Neighbors is new Maps_Protector_G (NP_Neighbors);
	
	package NP_Latest_Msgs is new Maps_G (Key_Type   => LLU.End_Point_Type,
										 Value_Type => Seq_N_T.Seq_N_Type, 
                               Null_Key => null,
                               Null_Value => 0,
                               Max_Length => 50,
                               "="        => LLU."=",
                               Key_To_String  => Zeug.SchneidenString,
                               Value_To_String  => Seq_N_T.Seq_N_Type'Image);
	package Latest_Msgs is new Maps_Protector_G (NP_Latest_Msgs);
	N_Map : Neighbors.Prot_Map;  
	M_Map : Latest_Msgs.Prot_Map;
	EP_Arry : Neighbors.Keys_Array_Type;
   Purge: Boolean:=True;
   Prompt: Boolean:=False;
   -- This procedure must NOT be called. It's called from LLU
   procedure EP_Handler (From     : in     LLU.End_Point_Type;
                           To       : in     LLU.End_Point_Type;
                           P_Buffer : access LLU.Buffer_Type);


end Chat_Handler;
