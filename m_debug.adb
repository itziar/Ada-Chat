--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

package body M_Debug is
	
	procedure New_Neighbour(EP: LLU.End_Point_Type) is
		Neighbour	  : ASU.Unbounded_String;
		Zeit			  : Ada.Calendar.Time;
		Success		  : Boolean;
	begin
		Zeug.Schneiden(EP, Neighbour);
		Debug.Put_Line("Añadimos a neighbors " & ASU.To_String(Neighbour));
		Ada.Text_IO.Put_Line(" ");
		Zeit:= Ada.Calendar.Clock;
		Insta.Neighbors.Put(Insta.N_Map, EP, Zeit, Success);
	end New_Neighbour;
	
	procedure New_Message (EP: LLU.End_Point_Type; Seq_N: Seq_N_T.Seq_N_Type) is
		Neighbour	  : ASU.Unbounded_String;
		Success		  : Boolean;
	begin
		Zeug.Schneiden(EP, Neighbour);
		Debug.Put_Line("Añadimos a latest_messages " & ASU.To_String(Neighbour) & Seq_N_T.Seq_N_Type'Image(Seq_N));
		Insta.Latest_Msgs.Put(Insta.M_Map, EP, Seq_N, Success);
	end New_Message;

	procedure Send (EP: LLU.End_Point_Type) is
		Neighbour	  : ASU.Unbounded_String;
	begin
		Zeug.Schneiden(EP, Neighbour);
		Debug.Put_Line("      send to: " & ASU.To_String(Neighbour));		
	end Send;

end M_Debug;
