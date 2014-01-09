--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--


package body Messages is

	procedure Send_Supernode(EP_H: LLU.End_Point_Type; EP_R: LLU.End_Point_Type; EP_H_S: LLU.End_Point_Type; N: Integer) is
		Buffer: aliased LLU.Buffer_Type(1024);
	begin
		M_Debug.Send_Supernode (EP_H_S);
		LLU.Reset(Buffer);
		CM.Message_Type'Output(Buffer'Access, CM.Supernode);
		LLU.End_Point_Type'Output(Buffer'Access, EP_H);
		LLU.End_Point_Type'Output(Buffer'Access, EP_R);
		Integer'Output(Buffer'Access, N);
		LLU.Send(EP_H_S, Buffer'Access);
	end Send_Supernode;

	procedure Management_Supernode (EP_H: LLU.End_Point_Type; EP_R: LLU.End_Point_Type; N: in out Integer) is
		Buffer: aliased LLU.Buffer_Type(1024);
		EP_Arry	: Insta.Neighbors.Keys_Array_Type;
	begin
		M_Debug.New_Neighbour(EP_H);
		LLU.Reset(Buffer);
		CM.Message_Type'Output(Buffer'Access, CM.Supernode);
		if Insta.Neighbors.Map_Length(Insta.N_Map)<N then
			N:=Insta.Neighbors.Map_Length(Insta.N_Map);
		end if;
		Integer'Output(Buffer'Access, N);
		EP_Arry := Insta.Neighbors.Get_Keys(Insta.N_Map);
		for i in 1..N loop
			if EP_Arry(i) /= EP_H then
				LLU.End_Point_Type'Output(Buffer'Access, EP_Arry(i)); 
			end if;
		end loop;
		LLU.Send(EP_R, Buffer'Access);
	end;

	procedure Receive_Supernode (EP_R: LLU.End_Point_Type) is
		Buffer: aliased LLU.Buffer_Type(1024);
		Bett: CM.Message_Type;
		N: Integer;
		Vecino: LLU.End_Point_Type;
		Expired: Boolean:=False;
	begin
		LLU.Reset(Buffer);
		LLU.Receive (EP_R, Buffer'Access, 2.0, Expired);
		if not Expired then
			Bett:=CM.Message_Type'Input(Buffer'Access);
			N:=Integer'Input(Buffer'Access);
			for i in 1..N-1 loop
				Vecino:= LLU.End_Point_Type'Input(Buffer'Access);
				M_Debug.New_Neighbour(Vecino);
			end loop;
		end if;	
	end Receive_Supernode;
---------------------------------------------------------------------------------------------------------------	
--MENSAJE REJECT--
	procedure Receive_Reject (EP_R: LLU.End_Point_Type; acept: out Boolean) is
		EP_H_A: LLU.End_Point_Type;
		Bett: CM.Message_Type;
		Buffer: aliased LLU.Buffer_Type(1024);
		Expired: Boolean := False;
		Nick: ASU.Unbounded_String;
		EPHA: ASU.Unbounded_String;
	begin
		Debug.Set_Status(CM.Purge);
		LLU.Reset(Buffer);
		LLU.Receive (EP_R, Buffer'Access, 2.0, Expired);
		if not Expired then
			Bett:=CM.Message_Type'Input(Buffer'Access);
			EP_H_A:=LLU.End_Point_Type'Input(Buffer'Access); 
			Nick:= ASU.Unbounded_String'Input(Buffer'Access);
			acept:=False;
			M_Debug.Receive_Reject(EP_H_A, Nick);
		else
			acept:= True;
		end if;	
	end Receive_Reject;

	procedure Send_Reject (EP_H: LLU.End_Point_Type; Nick: ASU.Unbounded_String; EP_R_Creat: LLU.End_Point_Type) is
		P_Buffer: aliased LLU.Buffer_Type(1024);
	begin
		M_Debug.Send_Reject(EP_H, Nick);
		LLU.Reset(P_Buffer);
		CM.Message_Type'Output(P_Buffer'Access, CM.Reject);
		LLU.End_Point_Type'Output(P_Buffer'Access, EP_H);
		ASU.Unbounded_String'Output(P_Buffer'Access, Nick);
		LLU.Send(EP_R_Creat, P_Buffer'Access);
	end Send_Reject;
---------------------------------------------------------------------------------------------------------------
	
---------------------------------------------------------------------------------------------------------------			
	procedure Send_Ack(EP_H_Acker: LLU.End_Point_Type; EP_H_Creat: LLU.End_Point_Type; Seq_N: CM.Seq_N_T; EP_Dest: LLU.End_Point_Type) is
		Buffer : aliased LLU.Buffer_Type(1024);
	begin
		M_Debug.Send_Ack(EP_H_Acker, EP_H_Creat, Seq_N);
		LLU.Reset(Buffer);
		CM.Message_Type'Output(Buffer'Access, CM.Ack);
		LLU.End_Point_Type'Output(Buffer'Access,EP_H_Acker);
		LLU.End_Point_Type'Output(Buffer'Access,EP_H_Creat);
		CM.Seq_N_T'Output(Buffer'Access,Seq_N);
		LLU.Send(EP_Dest, Buffer'Access);
	end Send_Ack;
---------------------------------------------------------------------------------------------------------------
procedure Management (Bett: CM.Message_Type; EP_H_Creat: LLU.End_Point_Type; Seqi: in out CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; EP_R_Creat: LLU.End_Point_Type; Nick: ASU.Unbounded_String; Text: ASU.Unbounded_String; Confirm_Sent: Boolean) is
	Seq: CM.Seq_N_T;
	Success: Boolean;
	zeit: Ada.Calendar.Time;
begin
	M_Debug.Receive (Bett, EP_H_Creat, Seqi, EP_H_Rsnd, Nick);
	Insta.Latest_Msgs.Get(Insta.M_Map, EP_H_Creat, Seq, Success);
	if not success or Seqi=Seq+1 then --PRESENTE PROCESAMIENTO ESPECIFICO
		M_Debug.New_Message (EP_H_Creat, Seqi);
		Debug.Put_Line("mensaje del presente", Pantalla.Azul);		
		if Bett/=CM.Logout then
			Insta.Neighbors.Get(Insta.N_Map, EP_H_Creat, zeit, Success);	
			if EP_H_Creat=EP_H_Rsnd and not success then
				M_Debug.New_Neighbour(EP_H_Creat);
			end if;
		end if;
		if Bett=CM.Confirm then
			Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " ha entrado en el chat");
		end if;
		if Bett=CM.Init and nick = CM.Nick then
			Messages.Send_Reject (CM.EP_H, Nick, EP_R_Creat);
		end if;
		M_Debug.Receive (Bett, EP_H_Creat, Seqi, EP_H_Rsnd, Nick);
		if Bett = CM.Writer then
			Ada.Text_IO.Put_Line(ASU.To_String(Nick) & ": " & ASU.To_String(Text));
		end if;
		if Bett=CM.Logout then
			if Confirm_Sent then
				Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " ha salido del chat");
			end if;
			if EP_H_Creat = EP_H_Rsnd then
				M_Debug.Delete_Neighbors(EP_H_Creat);
			end if;
		end if;
		Send(Bett, EP_H_Creat, Seqi, CM.EP_H, EP_R_Creat, Nick, Text, Confirm_Sent, EP_H_Rsnd);
		Send_Ack(CM.EP_H, EP_H_Creat, Seqi, EP_H_Rsnd);
	elsif Seqi > Seq+1 then --FUTURO SOLO REENVIAR
		Debug.Put_Line("mensaje del futuro", Pantalla.Azul);
		Send(Bett, EP_H_Creat, Seqi, CM.EP_H, EP_R_Creat, Nick, Text, Confirm_Sent, EP_H_Rsnd);
	elsif Seq >= Seqi then --PASADO SOLO ACK
		Debug.Put_Line("mensaje del pasado", Pantalla.Azul);
		Send_Ack(CM.EP_H, EP_H_Creat, Seqi, EP_H_Rsnd);
	end if;
end Management;

procedure Send(Bett: CM.Message_Type; EP_H_Creat: LLU.End_Point_Type; Seqi: CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; EP_R_Creat: LLU.End_Point_Type; Nick : ASU.Unbounded_String; Text: ASU.Unbounded_String; Confirm_Sent: Boolean; EP_H_Receive: LLU.End_Point_Type) is
	EP_Arry	: Insta.Neighbors.Keys_Array_Type;
   	Mess: CM.Mess_Id_T;
   	ValD: CM.Destinations_T;
   	Envio: Boolean := False;
   	ValB : CM.Value_T;
   	Hora_Rtx: Ada.Calendar.Time;
begin
	CM.P_Buffer := new LLU.Buffer_Type(1024);
   	CM.Message_Type'Output(CM.P_Buffer, Bett);
   	LLU.End_Point_Type'Output(CM.P_Buffer, EP_H_Creat);
   	CM.Seq_N_T'Output(CM.P_Buffer, Seqi);
   	LLU.End_Point_Type'Output(CM.P_Buffer, EP_H_Rsnd);
   	if Bett = CM.Init then
   		LLU.End_Point_Type'Output(CM.P_Buffer, EP_R_Creat);
   	end if;
   	ASU.Unbounded_String'Output(CM.P_Buffer, Nick);
   	if Bett = CM.Writer then
   		ASU.Unbounded_String'Output(CM.P_Buffer, Text);
   	elsif Bett = CM.Logout then
   		Boolean'Output(CM.P_Buffer, Confirm_Sent);
   	end if;
	M_Debug.Flood (Bett, EP_H_Rsnd, EP_H_Creat, Seqi);
   	EP_Arry := Insta.Neighbors.Get_Keys(Insta.N_Map);
   	for I in 1..Insta.Neighbors.Map_Length(Insta.N_Map) loop
   		if EP_Arry(i) /= EP_H_Creat and EP_Arry(i) /= EP_H_Receive then
			LLU.Send(EP_Arry(i), CM.P_Buffer);
			Hora_Rtx := Ada.Calendar.Clock + 2*Duration(CM.Max_Delay)/1000;
			Envio := True;
			M_Debug.Send(EP_Arry(i));
   			ValD(i) := (EP_Arry(i), 0);
			ValB := (EP_H_Creat, Seqi, CM.P_Buffer);
			Insta.Sender_Buffering.Put(Insta.B_Map, Hora_Rtx, ValB);
			Timed_Handlers.Set_Timed_Handler(Hora_Rtx, Relay'Access);
		end if;
   	end loop;
   	if Envio then
		Mess := (EP_H_Creat, Seqi);
		Insta.Sender_Dests.Put(Insta.D_Map, Mess, ValD);
	end if;
end Send;

procedure Free is new Ada.Unchecked_Deallocation(LLU.Buffer_Type, CM.Buffer_A_T);
	
	procedure Relay(Timer: Ada.Calendar.Time) is
		ValB: CM.Value_T;
		Mess: CM.Mess_Id_T;
		ValD: CM.Destinations_T;
		Success: Boolean;
		New_Timer: Ada.Calendar.Time;
		find: Boolean:= False;
	begin
		Insta.Sender_Buffering.Get(Insta.B_Map, Timer, ValB, Success);
		Mess := (ValB.EP_H_Creat, ValB.Seq_N);
		Insta.Sender_Dests.Get(Insta.D_Map, Mess, ValD, Success);
		if Success then
			for i in 1..10 loop
				if ValD(i).EP/=CM.Null_EP and ValD(i).Retries <10 then
					LLU.Send(ValD(i).EP,ValB.P_Buffer);
					M_Debug.Retrans(ValD(i).EP, ValD(i).Retries+1);
					New_Timer:= Ada.Calendar.Clock+2*Duration(CM.Max_Delay)/1000;
					Insta.Sender_Buffering.Delete(Insta.B_Map, Timer, Success);
					Insta.Sender_Buffering.Put(Insta.B_Map,New_Timer,ValB);
					Timed_Handlers.Set_Timed_Handler(New_Timer, Relay'Access);
					ValD(i).Retries:=ValD(i).Retries+1;
					find:=True;
				end if;
			end loop;
			if find then
				Insta.Sender_Dests.Put(Insta.D_Map, Mess, ValD);
			else 
				Free(ValB.P_Buffer);
				Insta.Sender_Buffering.Delete(Insta.B_Map, Timer, Success);
				Insta.Sender_Dests.Delete(Insta.D_Map, Mess, Success);
			end if;
		end if;
	end Relay;

	procedure Manejador is
	begin
		Ada.Text_IO.Put_Line("Procederemos al cierre del chat, por favor espere");
		LLU.Finalize;
		Timed_Handlers.Finalize;
		raise Program_Error;
	end Manejador;

	procedure Send_Topology(EP_H_Creat: LLU.End_Point_Type; EP_H_Rsnd: LLU.End_Point_Type) is
		Buffer: aliased LLU.Buffer_Type(1024);
		EP_Arry	: Insta.Neighbors.Keys_Array_Type;
	begin
		LLU.Reset(Buffer);
		CM.Message_Type'Output(Buffer'Access, CM.Topology);
		LLU.End_Point_Type'Output(Buffer'Access,EP_H_Creat);
		LLU.End_Point_Type'Output(Buffer'Access,EP_H_Rsnd);
		EP_Arry := Insta.Neighbors.Get_Keys(Insta.N_Map);
   		for I in 1..Insta.Neighbors.Map_Length(Insta.N_Map) loop
   			if EP_Arry(i) /= EP_H_Creat and EP_Arry(i) /= EP_H_Rsnd then
				LLU.Send(EP_Arry(i), Buffer'Access);
			end if;
   		end loop;
	end Send_Topology;

	procedure Send_Topologia(EP_H_Creat: LLU.End_Point_Type; EP_H_Rsnd: LLU.End_Point_Type; My_EP: LLU.End_Point_Type) is
		Buffer: aliased LLU.Buffer_Type(1024);
		EP_Arry	: Insta.Neighbors.Keys_Array_Type;
	begin
		--saco todos los vecinos y se lo envio a EP_H_Creat
		LLU.Reset(Buffer);
		CM.Message_Type'Output(Buffer'Access, CM.Topologia);
		LLU.End_Point_Type'Output(Buffer'Access, My_EP);
		Integer'Output(Buffer'Access, Insta.Neighbors.Map_Length(Insta.N_Map));
		EP_Arry := Insta.Neighbors.Get_Keys(Insta.N_Map);
		for i in 1..Insta.Neighbors.Map_Length(Insta.N_Map) loop
			LLU.End_Point_Type'Output(Buffer'Access, EP_Arry(i)); 
		end loop;
		LLU.Send(EP_H_Creat, Buffer'Access);
	end Send_Topologia;

	procedure Management_Topology(EP_H_Creat: LLU.End_Point_Type; EP_H_Rsnd: LLU.End_Point_Type; My_EP: LLU.End_Point_Type) is
		Buffer: aliased LLU.Buffer_Type(1024);
		EP_Arry: Insta.Neighbors.Keys_Array_Type;
	begin
		LLU.Reset(Buffer);
		CM.Message_Type'Output(Buffer'Access, CM.Topology);
		LLU.End_Point_Type'Output(Buffer'Access, EP_H_Creat);
		LLU.End_Point_Type'Output(Buffer'Access, My_EP);
		EP_Arry := Insta.Neighbors.Get_Keys(Insta.N_Map);
		for i in 1..Insta.Neighbors.Map_Length(Insta.N_Map) loop
			if EP_Arry(i) /= EP_H_Creat and EP_Arry(i)/=EP_H_Rsnd then
				LLU.Send(EP_Arry(i), Buffer'Access);
			end if;
		end loop;
	end Management_Topology;

end Messages;
