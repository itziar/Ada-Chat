--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Lower_Layer_UDP;
with maps_g;
with maps_protector_g;
with Ada.Strings.Unbounded;
with Ada.Calendar;
with Zeug;
with Chat_Messages;
with Ordered_Maps_G;
with Ordered_Maps_Protector_G;
with Gnat.Calendar.Time_IO;
with Ada.Strings.Fixed;
with Retrans;

package Insta is

	package ASU renames Ada.Strings.Unbounded;
	use type ASU.Unbounded_String;
	package LLU renames Lower_Layer_UDP;
	use Lower_Layer_UDP;
	package CM renames Chat_Messages;
	use type ASU.Unbounded_String;
	use type Ada.Calendar.Time;
	use type CM.Message_Type;
	use type CM.Seq_N_T;
	use Ada.Strings.Fixed;


	package NP_Neighbors is new Maps_G (Key_Type => LLU.End_Point_Type,
														Value_Type => Ada.Calendar.Time,
														Null_Key => null,
														Null_Value => 0,
														Max_Length => 10,
														"="        => LLU."=",
														Key_To_String  => Zeug.SchneidenString,
														Value_To_String  => Zeug.Time_Image_One);
	package Neighbors is new Maps_Protector_G (NP_Neighbors);
	
	package NP_Latest_Msgs is new Maps_G (Key_Type   => LLU.End_Point_Type,
														Value_Type => CM.Seq_N_T, 
														Null_Key => null,
														Null_Value => 0,
														Max_Length => 50,
														"="        => LLU."=",
														Key_To_String  => Zeug.SchneidenString,
														Value_To_String  => CM.Seq_N_T'Image);
	package Latest_Msgs is new Maps_Protector_G (NP_Latest_Msgs);

	package NP_Sender_Dests is new Ordered_Maps_G (Key_Type => CM.Mess_Id_T,
														Value_Type		  => CM.Destinations_T,
														"="				  => Retrans.Mess_Iguales,
														"<" 				  => Retrans.Mess_Menor,
														">"  				  => Retrans.Mess_Mayor,
														Key_To_String	  => Retrans.Image_Mess,
														Value_To_String  => Retrans.Image_Destinations);
	package Sender_Dests is new Ordered_Maps_Protector_G (NP_Sender_Dests);

	package NP_Sender_Buffering is new Ordered_Maps_G (Key_Type => Ada.Calendar.Time,
														Value_Type		   => CM.Value_T,
														"="				   => Ada.Calendar."=",
														"<" 				   => Ada.Calendar."<",
														">"  				   =>	Ada.Calendar.">",
														Key_To_String	   => Retrans.Image_Time,
														Value_To_String   => Retrans.Image_Value);	
	package Sender_Buffering is new Ordered_Maps_Protector_G (NP_Sender_Buffering);

	N_Map : Neighbors.Prot_Map;  
	M_Map : Latest_Msgs.Prot_Map;
	D_Map: Sender_Dests.Prot_Map;
	B_Map: Sender_Buffering.Prot_Map;
	EP_Arry : Neighbors.Keys_Array_Type;

end Insta;