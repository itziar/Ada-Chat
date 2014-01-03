--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--


package body Messages is

	
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
		Debug.Set_Status(Zeug.Purge);
		LLU.Reset(Buffer);
		LLU.Receive (EP_R, Buffer'Access, 2.0, Expired);
		if not Expired then
			Bett:=CM.Message_Type'Input(Buffer'Access);
			EP_H_A:=LLU.End_Point_Type'Input(Buffer'Access); 
			Nick:= ASU.Unbounded_String'Input(Buffer'Access);
			acept:=False;
			Debug.Put ("RCV Reject", Pantalla.Amarillo);
			Zeug.Schneiden(EP_H_A, EPHA);
			Debug.Put_Line(ASU.To_String(EPHA) & ASU.To_String(Nick));
			Ada.Text_IO.Put_Line("Usuario rechazado porque " & ASU.To_String(EPHA) & " está usando el mismo nick");
		else
			acept:= True;
		end if;	
	end Receive_Reject;

	procedure Send_Reject (EP_H: LLU.End_Point_Type; Nick: ASU.Unbounded_String; EP_R_Creat: LLU.End_Point_Type) is
		P_Buffer: aliased LLU.Buffer_Type(1024);
	begin
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
		LLU.Reset(Buffer);
		CM.Message_Type'Output(Buffer'Access, CM.Ack);
		LLU.End_Point_Type'Output(Buffer'Access,EP_H_Acker);
		LLU.End_Point_Type'Output(Buffer'Access,EP_H_Creat);
		CM.Seq_N_T'Output(Buffer'Access,Seq_N);
		LLU.Send(EP_Dest, Buffer'Access);
	end Send_Ack;
---------------------------------------------------------------------------------------------------------------
procedure Management (Bett: CM.Message_Type; EP_H_Creat: LLU.End_Point_Type; Seq_N: in out CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String; Text: ASU.Unbounded_String) is
	Seq: CM.Seq_N_T;
	Success: Boolean;
begin
	M_Debug.Receive (Bett, EP_H_Creat, Seq_N, EP_H_Rsnd, Nick);
	Insta.Latest_Msgs.Get(Insta.M_Map, EP_H_Creat, Seq, Success);
	Ada.Text_IO.Put_Line(CM.Seq_N_T'Image(Seq) & CM.Seq_N_T'Image(Seq_N) & " Seq y Seq_N");
	if not success or Seq_N=Seq+1 then --PRESENTE PROCESAMIENTO ESPECIFICO
		M_Debug.New_Message (EP_H_Creat, Seq_N);
		Ada.Text_IO.Put("PRESENTE");
		M_Debug.Receive (Bett, EP_H_Creat, Seq_N, EP_H_Rsnd, Nick);
		Ada.Text_IO.Put_Line(ASU.To_String(Nick) & ": " & ASU.To_String(Text));
	--	Send_Writer(EP_H_Creat, Seq_N, Zeug.EP_H, Nick, Text);
		Send_Ack(Zeug.EP_H, EP_H_Creat, Seq_N, EP_H_Rsnd);
	elsif Seq_N > Seq+1 then --FUTURO SOLO REENVIAR
	--	Send_Writer(EP_H_Creat, Seq_N, Zeug.EP_H, Nick, Text);
		Ada.Text_IO.Put("FUTURO");
	elsif Seq >= Seq_N then --PASADO SOLO ACK
		Send_Ack(Zeug.EP_H, EP_H_Creat, Seq_N, EP_H_Rsnd);
		Ada.Text_IO.Put("PASADO");
	end if;
end Management;

procedure Send(Bett: CM.Message_Type; EP_H_Creat: LLU.End_Point_Type; Seq_N_In: CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; EP_R_Creat: LLU.End_Point_Type; Nick : ASU.Unbounded_String; Text: ASU.Unbounded_String; Confirm_Sent: Boolean; EP_H_Receive: LLU.End_Point_Type) is
	EP_Array	: Insta.Neighbors.Keys_Array_Type;
   	Mess		: CM.Mess_Id_T;
   	ValD		: CM.Destinations_T;
   	Envio		: Boolean := False;
   	ValB  : CM.Value_T;
   	Hora_Rtx	: Ada.Calendar.Time;
begin
	CM.P_Buffer := new LLU.Buffer_Type(1024);
   	CM.Message_Type'Output(CM.P_Buffer, Bett);
   	LLU.End_Point_Type'Output(CM.P_Buffer, EP_H_Creat);
   	CM.Seq_N_T'Output(CM.P_Buffer, Seq_N_In);
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
   	EP_Array := Insta.Neighbors.Get_Keys(Insta.N_Map);
   	for I in 1..Insta.Neighbors.Map_Length(Insta.N_Map) loop
   		if EP_Array(I) /= EP_H_Creat and EP_Array(I) /= EP_H_Receive then
			LLU.Send(EP_Array(I), CM.P_Buffer);
			Hora_Rtx := Ada.Calendar.Clock + 2*Duration(CM.Max_Delay)/1000;
			Envio := True;
			Debug.Put_Line("        send to: " & Zeug.Image_EP(EP_Array(I)));
   			ValD(I) := (EP_Array(I), 0);
			ValB := (EP_H_Creat, Seq_N_In, CM.P_Buffer);
			Insta.Sender_Buffering.Put(Insta.B_Map, Hora_Rtx, ValB);
			Timed_Handlers.Set_Timed_Handler(Hora_Rtx, Relay'Access);
		end if;
   	end loop;
   	if Envio then
			Mess := (EP_H_Creat, Seq_N_In);
			Insta.Sender_Dests.Put(Insta.D_Map, Mess, ValD);
		end if;
 --  	T_IO.New_Line(1);
end Send;

procedure Free is new Ada.Unchecked_Deallocation(LLU.Buffer_Type, CM.Buffer_A_T);
	
	procedure Relay(Timer: Ada.Calendar.Time) is
		ValB: CM.Value_T;
		Mess: CM.Mess_Id_T;
		ValD: CM.Destinations_T;
		Success: Boolean;
		New_Timer: Ada.Calendar.Time;
		find: Boolean:= False;
		--Bett: CM.Message_Type;
	begin
		Insta.Sender_Buffering.Get(Insta.B_Map, Timer, ValB, Success);
		Ada.Text_IO.Put_Line(Boolean'Image(Success));
		Mess := (ValB.EP_H_Creat, ValB.Seq_N);
		Insta.Sender_Dests.Get(Insta.D_Map, Mess, ValD, Success);
		if Success then
			for i in 1..10 loop
				if ValD(i).EP/=Zeug.Null_EP and ValD(i).Retries <10 then
					LLU.Send(ValD(i).EP,ValB.P_Buffer);
					Ada.Text_IO.Put_Line("Reenvio"& Zeug.SchneidenString(ValD(i).EP));
					New_Timer:= Ada.Calendar.Clock+2*Duration(Zeug.Max_Delay)/1000;
					Insta.Sender_Buffering.Delete(Insta.B_Map, Timer, Success);
					Insta.Sender_Buffering.Put(Insta.B_Map,New_Timer,ValB);
					Timed_Handlers.Set_Timed_Handler(New_Timer, Relay'Access);
					ValD(i).Retries:=ValD(i).Retries+1;
					find:=True;
				end if;
			end loop;
			Ada.Text_IO.Put_Line("find"&Boolean'Image(find));
			if find then
				Insta.Sender_Dests.Put(Insta.D_Map, Mess, ValD);
			else 
				Free(ValB.P_Buffer);
				Insta.Sender_Buffering.Delete(Insta.B_Map, Timer, Success);
				Insta.Sender_Dests.Delete(Insta.D_Map, Mess, Success);
			end if;
		end if;
	end Relay;


end Messages;
