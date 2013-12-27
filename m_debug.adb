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

	procedure Receive (Bett: CM.Message_Type; EP_H_Creat:LLU.End_Point_Type; Seq_N: Seq_N_T.Seq_N_Type; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String) is
		EPHCreat: ASU.Unbounded_String;
		EPHRsnd: ASU.Unbounded_String;
	begin
		Zeug.Schneiden(EP_H_Creat, EPHCreat);
		Zeug.Schneiden(EP_H_Rsnd, EPHRsnd);
		if Bett=CM.Init then
			Debug.Put("RCV Init ", Pantalla.Amarillo);
		elsif Bett=CM.Confirm then
			Debug.Put("RCV Confirm ", Pantalla.Amarillo);
		elsif Bett=CM.Writer then
			Debug.Put("RCV Writer ", Pantalla.Amarillo);
		elsif Bett=CM.Logout then
			Debug.Put("RCV Logout ", Pantalla.Amarillo);
		elsif Bett=CM.Ack then		
			Debug.Put("RCV Ack ", Pantalla.Amarillo);
		end if;
		Debug.Put_Line(ASU.To_String(EPHCreat) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N) & " " & ASU.To_String(EPHRsnd) & " " & ASU.To_String(Nick));

	end Receive;

end M_Debug;
