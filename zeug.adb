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

end Zeug;
