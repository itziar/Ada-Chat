--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

package body M_Debug is

	procedure Initial is
	begin
		Ada.Text_IO.Put_Line("Peer-Chat v2.0");
		Ada.Text_IO.Put_Line("==============");
		Ada.Text_IO.Put_Line(" ");
		Ada.Text_IO.Put_Line("Entramos en el chat con Nick: " & ASU.To_String(CM.Nick));
		Ada.Text_IO.Put_Line(".h para help");
	end;
	
	procedure Flood (Bett: CM.Message_Type; EP_H_Rsnd: LLU.End_Point_Type; EP_H_Creat: LLU.End_Point_Type; Seqi: CM.Seq_N_T) is
	begin
		Debug.Put("FLOOD " & CM.Message_Type'Image(Bett), Pantalla.Amarillo);
		Debug.Put_Line(" Creado por: " & CM.SchneidenString(EP_H_Creat) & " Reenviado por: " & CM.SchneidenString(EP_H_Rsnd) & " " & CM.Seq_N_T'Image(Seqi));
	end;

	procedure New_Neighbour(EP: LLU.End_Point_Type) is
		Zeit : Ada.Calendar.Time;
		Success	: Boolean;
	begin
		Debug.Put_Line("Añadimos a neighbors " & CM.SchneidenString(EP));
		Ada.Text_IO.Put_Line(" ");
		Zeit:= Ada.Calendar.Clock;
		Insta.Neighbors.Put(Insta.N_Map, EP, Zeit, Success);
	end New_Neighbour;
	
	procedure New_Message (EP: LLU.End_Point_Type; Seqi: CM.Seq_N_T) is
		Success : Boolean;
	begin
		Debug.Put_Line("Añadimos a latest_messages " & CM.SchneidenString(EP) & CM.Seq_N_T'Image(Seqi));
		Insta.Latest_Msgs.Put(Insta.M_Map, EP, Seqi, Success);
	end New_Message;

	procedure Send (EP: LLU.End_Point_Type) is
	begin
		Debug.Put_Line("      send to: " & CM.SchneidenString(EP));	
	end Send;
	
	procedure Delete_Neighbors(EP_H_Creat: LLU.End_Point_Type) is
		Success	 : Boolean;
	begin
		Debug.Put_Line("    Borramos de Neighbors " & CM.SchneidenString(EP_H_Creat));
		Insta.Neighbors.Delete(Insta.N_Map, EP_H_Creat, Success);
	end Delete_Neighbors;

	procedure Delete_Message(EP_H_Creat: LLU.End_Point_Type) is
		Success : Boolean;
	begin
		Debug.Put_Line("    Borramos de Latest_Msgs " & CM.SchneidenString(EP_H_Creat));
		Insta.Latest_Msgs.Delete(Insta.M_Map, EP_H_Creat, Success);
	end Delete_Message;

	procedure Receive (Bett: CM.Message_Type; EP_H_Creat:LLU.End_Point_Type; Seqy: CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String) is
	begin	
		Debug.Put("RCV " & CM.Message_Type'Image(Bett), Pantalla.Amarillo);
		Debug.Put_Line(" " & CM.SchneidenString(EP_H_Creat) & " " & CM.Seq_N_T'Image(Seqy) & " " & CM.SchneidenString(EP_H_Rsnd) & " " & ASU.To_String(Nick));
	end Receive;

	procedure Send_Reject (EP_H: LLU.End_Point_Type; Nick: ASU.Unbounded_String) is
	begin
		Debug.Put("Send Reject ", Pantalla.Amarillo);
		Debug.Put_Line(CM.SchneidenString(EP_H) & " " & ASU.To_String(Nick));
	end Send_Reject;

	procedure Receive_Reject (EP_H_A: LLU.End_Point_Type; Nick: ASU.Unbounded_String) is
	begin
		Debug.Put ("RCV Reject ", Pantalla.Amarillo);
		Debug.Put_Line(CM.SchneidenString(EP_H_A) & ASU.To_String(Nick));
		Ada.Text_IO.Put_Line("Usuario rechazado porque " & CM.SchneidenString(EP_H_A) & " está usando el mismo nick");
	end;

	procedure Send_Ack (EP_H_Acker: LLU.End_Point_Type; EP_H_Creat: LLU.End_Point_Type; Seqy: CM.Seq_N_T) is
	begin
		Debug.Put("Send Ack ", Pantalla.Amarillo);
		Debug.Put_Line(CM.SchneidenString(EP_H_Acker) & " " & CM.SchneidenString(EP_H_Creat) & " " & CM.Seq_N_T'Image(Seqy));
	end Send_Ack;

	procedure Receive_Ack (EP_H_Acker: LLU.End_Point_Type; EP_H_Creat: LLU.End_Point_Type; Seqy: CM.Seq_N_T) is
	begin
		Debug.Put("RCV ACK de: ", Pantalla.Amarillo);
		Debug.Put_Line(CM.SchneidenString(EP_H_Acker) & " para " & CM.SchneidenString(EP_H_Creat) & " con numero de secuencia " & CM.Seq_N_T'Image(Seqy));
	end Receive_Ack;

	procedure Retrans (EP: LLU.End_Point_Type; Retries: Natural) is
	begin
		Debug.Put_Line("Reenvio a " & CM.SchneidenString(EP) & " con retrie igual a " & Natural'Image(Retries), Pantalla.Amarillo);
	end Retrans;
end M_Debug;
