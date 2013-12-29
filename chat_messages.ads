--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Lower_Layer_UDP;


package Chat_Messages is

		package LLU renames Lower_Layer_UDP;

		 type Seq_N_T is mod Integer'Last; 
	
	type Message_Type is (Init, Reject, Confirm, Writer, Logout, Ack);

	type Mess_Id_T is record
		EP: LLU.End_Point_Type;
		Seq: Seq_N_T;
	end record;
	
	type Destination_T is record
		Ep: Llu.End_Point_Type := null;
		Retries : Natural := 0;
	end record;
	
	type Destinations_T is array (1..10) of Destination_T;

	type Buffer_A_T is access LLU.Buffer_Type;
	
	type Value_T is record
		EP_H_Creat: LLU.End_Point_Type;
		Seq_N: Seq_N_T;
		P_Buffer: Buffer_A_T;
	end record;

	P_Buffer_MH :Buffer_A_T;

end Chat_Messages;
