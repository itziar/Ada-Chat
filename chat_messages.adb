--
--ITZIAR POLO MARTINEZ
--

package body Chat_Messages is

	--TOGGLE PARA INFORMACION DE DEBUG--
	procedure Information (Purge: in out Boolean) is
	begin
		if Purge then
			Debug.Put_Line("Desactivado informacion debug", Pantalla.Rojo);
			Purge:=False;
		else
			Debug.Put_Line("Activado informacion debug", Pantalla.Rojo);
			Purge:= True;
		end if;
	end Information;

	procedure Name (prompt: in out Boolean) is
	begin
		if prompt then
			Debug.Put_Line("Desactivado el prompt", Pantalla.Rojo);
			prompt:=False;
		else
			Ada.Text_IO.Put_Line(" ");
			Debug.Put_Line("Activado el prompt", Pantalla.Rojo);
			prompt:=True;
		end if;
	end Name;


	--PARA LAS INSTANCIACIONES--
	
	function Time_Image_One (T: Ada.Calendar.Time) return String is
	begin
		return C_IO.Image(T, "%c"); 
	end Time_Image_One; 
	
	function SchneidenString (EP_N: in LLU.End_Point_Type) return String is
		N, M, o: Natural;
		ipg,portg: ASU.Unbounded_String;
		s, r, t: ASU.Unbounded_String;
	begin
		s:= ASU.To_Unbounded_String(LLU.Image(EP_N));
		--	Ada.Text_IO.Put_Line(ASU.To_String(s));
		N:=ASU.Index(s, ": ");
		R:= ASU.Tail(s, ASU.Length(s)-N-1); 
		--Ada.Text_IO.Put_Line(ASU.To_String(r));
		M:=ASU.Index(r, ",");
		ipg:= ASU.Head(r, M-1);
		--Ada.Text_IO.Put_Line(ASU.To_String(ipg));
		T:= ASU.Tail(r, ASU.Length(r)-M+1);
		--Ada.Text_IO.Put_Line(ASU.To_String(t));
		O:=ASU.Index(t, ": ");
		portg:= ASU.Tail(t, ASU.Length(t)-O+1);
		--Ada.Text_IO.Put_Line(ASU.To_String(portg));
		return (ASU.To_String(ipg) & ":" & ASU.To_String(portg));
	end;
	
	function Mess_Equal (Mess_1 : Mess_Id_T; Mess_2 : Mess_Id_T) return Boolean is
	begin
		return Mess_1.EP = Mess_2.EP and then Mess_1.Seq = Mess_2.Seq;
	end Mess_Equal;
	
	function Mess_Less (Mess_1 :Mess_Id_T; Mess_2 : Mess_Id_T) return Boolean is
	begin
		return LLU.Image(Mess_1.EP) < LLU.Image(Mess_2.EP) or Mess_1.Seq < Mess_2.Seq;
	end Mess_Less;
	
	function Mess_More (Mess_1 : Mess_Id_T; Mess_2 : Mess_Id_T) return Boolean is
	begin
		return LLU.Image(Mess_1.EP) > LLU.Image(Mess_2.EP) or Mess_1.Seq > Mess_2.Seq;
	end Mess_More;
	
	function Mess_Image (Mess : Mess_Id_T) return String is
	begin
		return "EP_H_Creat: " & SchneidenString(Mess.EP) & " Seq_N:" & Seq_N_T'Image(Mess.Seq);
	end Mess_Image;
	
	function Dest_Image (Dest : Destinations_T) return String is
		Dest_Tot : ASU.Unbounded_String;
	begin
		for I in 1..10 loop
			if Dest(I).EP /= Null_EP then
				Dest_Tot := Dest_Tot & ASU.To_Unbounded_String("EP: " & SchneidenString(Dest(I).EP) & " Retries:" & Natural'Image(Dest(I).Retries));
			end if;
		end loop;
		return ASU.To_String(Dest_Tot);	
	end Dest_Image;
	
	function Val_Image (Value : Value_T) return String is
	begin
		return SchneidenString(Value.EP_H_Creat) & Seq_N_T'Image(Value.Seq_N);
	end Val_Image;

end Chat_Messages;
