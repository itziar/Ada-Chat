--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

package body Zeug is 


procedure Spitzname (nick: in out ASU.Unbounded_String) is
begin
	Nick:=ASU.To_Unbounded_String(Ada.Command_Line.Argument(2));
end Spitzname;

procedure Hafen (EP_H: in out LLU.End_Point_Type) is
	Port: ASU.Unbounded_String;
	IP: ASU.Unbounded_String;
	Host: ASU.Unbounded_String;
begin
	Host:= ASU.TO_Unbounded_String(LLU.Get_Host_Name);
	Port:=ASU.To_Unbounded_String(Ada.Command_Line.Argument(1));
	IP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Host)));
	EP_H := LLU.Build (ASU.To_String(IP), Integer'Value(ASU.To_String(Port)));
end Hafen;

procedure schneiden (EP_N: in LLU.End_Point_Type; neighbour: out ASU.Unbounded_String) is
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
	Neighbour:= ASU.To_Unbounded_String(ASU.To_String(ipg) & ":" & ASU.To_String(portg));
end schneiden;

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
   
	function Time_Image_One (T: Ada.Calendar.Time) return String is
   begin
      return C_IO.Image(T, "%c");
   end Time_Image_One;



--------------------
	function Image_Time (T: Ada.Calendar.Time) return String is
   begin
   
      return C_IO.Image(T, "%c");
      
   end Image_Time; 
	
	function Image_EP (EP_N : LLU.End_Point_Type) return String is
		
	begin
	
		return (ASU.To_String(ASU.To_Unbounded_String(LLU.Image(EP_N))));
	
	end Image_EP;
	
	function Mess_Iguales (Mess_1, Mess_2 : CM.Mess_Id_T) return Boolean is
	begin
	
		return (Mess_1.EP = Mess_2.EP) and then (Mess_1.Seq = Mess_2.Seq);
	
	end Mess_Iguales;
	
	function Mess_Menor (Mess_1, Mess_2 : CM.Mess_Id_T) return Boolean is
	begin
	
		return Image_EP(Mess_1.EP) < Image_EP(Mess_2.EP) 
				or Mess_1.Seq < Mess_2.Seq;
	
	end Mess_Menor;
	
	function Mess_Mayor (Mess_1, Mess_2 : CM.Mess_Id_T) return Boolean is
	begin
	
		return LLU.Image(Mess_1.EP) > LLU.Image(Mess_2.EP) 
				or Mess_1.Seq > Mess_2.Seq;
	
	end Mess_Mayor;
	
	function Image_Mess (Mess : CM.Mess_Id_T) return String is
	begin
	
		return "EP_H_Creat: " & Image_EP(Mess.EP) & " Seq_N:" 
					& CM.Seq_N_T'Image(Mess.Seq);
	
	end Image_Mess;
	
	function Image_Destinations (Dest : CM.Destinations_T) return String is
		Dest_Tot : ASU.Unbounded_String;
	begin
	
		for I in 1..10 loop
			if Dest(I).EP /= Null_EP then
				Dest_Tot := Dest_Tot & ASU.To_Unbounded_String("EP: " & Image_EP(Dest(I).EP) & " Retries:" & Natural'Image(Dest(I).Retries));
			end if;
		end loop;
		return ASU.To_String(Dest_Tot);
	
	end Image_Destinations;
	
	function Image_Value (Value : CM.Value_T) return String is
	begin
	
		return Image_EP(Value.EP_H_Creat) & CM.Seq_N_T'Image(Value.Seq_N);
	
	end Image_Value;
end Zeug;
