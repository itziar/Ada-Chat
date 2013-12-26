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
with Chat_Messages;
with Ordered_Maps_G;
with Ordered_Maps_Protector_G;

package Chat_Handler is
	package ASU renames Ada.Strings.Unbounded;
	use type ASU.Unbounded_String;
	package LLU renames Lower_Layer_UDP;
	use Lower_Layer_UDP;
	package CM renames Chat_Messages;
	use type ASU.Unbounded_String;
   use type Ada.Calendar.Time;
   use type CM.Message_Type;
	use type Seq_N_T.Seq_N_Type;


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
package NP_Sender_Dests is new Ordered_Maps_G (Key_Type => CM.Mess_Id_T,
   													Value_Type		  => CM.Destinations_T,
   													"="				  => CM.Mess_Iguales,
   													"<" 				  => CM.Mess_Menor,
   													">"  				  => CM.Mess_Mayor,
   													Key_To_String	  => CM.Image_Mess,
   													Value_To_String  => CM.Image_Destinations);
   
   package NP_Sender_Buffering is new Ordered_Maps_G (Key_Type => Ada.Calendar.Time,
   														Value_Type		   => CM.Value_T,
   														"="				   => Ada.Calendar."=",
   														"<" 				   => Ada.Calendar."<",
   														">"  				   =>	Ada.Calendar.">",
   														Key_To_String	   => CM.Image_Time,
   														Value_To_String   => CM.Image_Value);
	package Sender_Dests is new Ordered_Maps_Protector_G (NP_Sender_Dests);
	package Sender_Buffering is new Ordered_Maps_Protector_G (NP_Sender_Buffering);

	package Latest_Msgs is new Maps_Protector_G (NP_Latest_Msgs);
	N_Map : Neighbors.Prot_Map;  
	M_Map : Latest_Msgs.Prot_Map;
	S_Dests: Sender_Dests.Prot_Map;
	S_Buffer: Sender_Buffering.Prot_Map;
	EP_Arry : Neighbors.Keys_Array_Type;
	Purge: Boolean:=True;
	Prompt: Boolean:=False;
	-- This procedure must NOT be called. It's called from LLU
	procedure EP_Handler (From     : in     LLU.End_Point_Type;
													To       : in     LLU.End_Point_Type;
													P_Buffer : access LLU.Buffer_Type);


end Chat_Handler;
