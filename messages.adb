--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--


package body Messages is

	procedure Send_Init (EP_H_Creat: in LLU.End_Point_Type; Seq_N: in out CM.Seq_N_T; EP_H_Rsnd: in LLU.End_Point_Type; EP_R_Creat: in LLU.End_Point_Type; nick: in out ASU.Unbounded_String) is
		Time_Rtx : Ada.Calendar.Time;
		Mess : CM.Mess_Id_T;
		ValD: CM.Destinations_T;
		ValB: CM.Value_T;
	begin
		CM.P_Buffer:=new LLU.Buffer_Type(1024);
		CM.Message_Type'Output (CM.P_Buffer, CM.Init);
		LLU.End_Point_Type'Output (CM.P_Buffer, EP_H_Creat);
		CM.Seq_N_T'Output(CM.P_Buffer, Seq_N);
		LLU.End_Point_Type'Output (CM.P_Buffer, EP_H_Rsnd);
		LLU.End_Point_Type'Output (CM.P_Buffer, EP_R_Creat);
		ASU.Unbounded_String'Output(CM.P_Buffer, Nick);
		Debug.Set_Status(Zeug.Purge);
		--Almacenar en sender_dests
		Mess := (EP_H_Creat, Seq_N);
		Insta.EP_Arry:=Insta.Neighbors.Get_Keys(Insta.N_Map);
		for i in 1..Insta.Neighbors.Map_Length(Insta.N_Map) loop
			if Insta.EP_Arry(i) /= EP_H_Creat and Insta.EP_Arry(i) /= EP_H_Rsnd then
				M_Debug.Send(Insta.EP_Arry(i));				
				LLU.Send(Insta.EP_Arry(i), CM.P_Buffer);
				--Programar Retransmision
				ValD(i) := (Insta.EP_Arry(i), 0);
				ValB := (EP_H_Creat, Seq_N, CM.P_Buffer);
				Time_Rtx := Ada.Calendar.Clock + 2*Duration(Zeug.Max_Delay)/1000;
				--almacenar en sender_buffering
				Insta.Sender_Buffering.Put(Insta.B_Map, Time_Rtx, ValB);
				Timed_Handlers.Set_Timed_Handler(Time_Rtx, Retrans.Relay'Access);	
			end if;
		end loop;		
		Insta.Sender_Dests.Put(Insta.D_Map, Mess, ValD);
	end Send_Init; 
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
	--MENDAJE CONFIRM--
	procedure Send_Confirm (EP_H_Creat: LLU.End_Point_Type; Seq_N: in out CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String) is
		MyEP: ASU.Unbounded_String;
		Time_Rtx : Ada.Calendar.Time;
		Mess : CM.Mess_Id_T;
		ValD: CM.Destinations_T;
		ValB: CM.Value_T;
	begin
		CM.P_Buffer:=new LLU.Buffer_Type(1024);
		CM.Message_Type'Output(CM.P_Buffer, CM.Confirm);
		LLU.End_Point_Type'Output(CM.P_Buffer, EP_H_Creat);
		CM.Seq_N_T'Output(CM.P_Buffer, Seq_N); 
		LLU.End_Point_Type'Output(CM.P_Buffer, EP_H_Rsnd);
		ASU.Unbounded_String'Output(CM.P_Buffer, Nick);
		Debug.Set_Status(Zeug.Purge);
		Debug.Put("FLOOD Confirm ", Pantalla.Amarillo);
		Zeug.Schneiden(EP_H_Creat, MyEP);
		Debug.Put_Line(ASU.To_String(MyEP) & " " & CM.Seq_N_T'Image(Seq_N) & " " & ASU.To_String(MyEP) & " " & ASU.To_String(Nick));
		--Almacenar en sender_dests
		Mess := (EP_H_Creat, Seq_N);
		Insta.EP_Arry:=Insta.Neighbors.Get_Keys(Insta.N_Map);
		for i in 1..Insta.Neighbors.Map_Length(Insta.N_Map) loop
			if Insta.EP_Arry(i) /= EP_H_Creat and Insta.EP_Arry(i) /= EP_H_Rsnd then
				M_Debug.Send(Insta.EP_Arry(i));				
				LLU.Send(Insta.EP_Arry(i), CM.P_Buffer);
				--Programar Retransmision
				ValD(i) := (Insta.EP_Arry(i), 0);
				ValB := (EP_H_Creat, Seq_N, CM.P_Buffer);
				Time_Rtx := Ada.Calendar.Clock + 2*Duration(Zeug.Max_Delay)/1000;
				--almacenar en sender_buffering
				Insta.Sender_Buffering.Put(Insta.B_Map, Time_Rtx, ValB);
				Timed_Handlers.Set_Timed_Handler(Time_Rtx, Retrans.Relay'Access);
			end if;
		end loop;
		Insta.Sender_Dests.Put(Insta.D_Map, Mess, ValD);
	end Send_Confirm;
---------------------------------------------------------------------------------------------------------------	
   --MENSAJE WRITER--
	procedure Send_Writer(EP_H_Creat: LLU.End_Point_Type; Seq_N: in out CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String; Text: ASU.Unbounded_String) is
		MyEP: ASU.Unbounded_String;
		Time_Rtx : Ada.Calendar.Time;
		Mess : CM.Mess_Id_T;
		ValD: CM.Destinations_T;
		ValB: CM.Value_T;
	begin
		CM.P_Buffer:=new LLU.Buffer_Type(1024);	
		CM.Message_Type'Output(CM.P_Buffer, CM.Writer);
		LLU.End_Point_Type'Output(CM.P_Buffer, EP_H_Creat);
		CM.Seq_N_T'Output(CM.P_Buffer, Seq_N); 
		LLU.End_Point_Type'Output(CM.P_Buffer, EP_H_Rsnd);
		ASU.Unbounded_String'Output(CM.P_Buffer, Nick);
		ASU.Unbounded_String'Output(CM.P_Buffer, Text);
		Zeug.Schneiden (EP_H_Creat, MyEP);
		Debug.Set_Status(Zeug.Purge);
		Debug.Put("FLOOD Writer ", Pantalla.Amarillo);
		Debug.Put_Line(ASU.To_String(MyEP) & " " & CM.Seq_N_T'Image(Seq_N) &" " & ASU.To_String(MyEP) & " " & ASU.To_String(Nick) & " " & ASU.To_String(Text));        			
		--Almacenar en sender_dests
		Mess := (EP_H_Creat, Seq_N);
		Insta.EP_Arry:=Insta.Neighbors.Get_Keys(Insta.N_Map);
		for i in 1..Insta.Neighbors.Map_Length(Insta.N_Map) loop
			if Insta.EP_Arry(i) /= EP_H_Creat and Insta.EP_Arry(i) /= EP_H_Rsnd then
				M_Debug.Send(Insta.EP_Arry(i));				
				LLU.Send(Insta.EP_Arry(i), CM.P_Buffer);
				--Programar Retransmision
				ValD(i) := (Insta.EP_Arry(i), 0);
				ValB := (EP_H_Creat, Seq_N, CM.P_Buffer);
				Time_Rtx := Ada.Calendar.Clock + 2*Duration(Zeug.Max_Delay)/1000;
				--almacenar en sender_buffering
				Insta.Sender_Buffering.Put(Insta.B_Map, Time_Rtx, ValB);
				Timed_Handlers.Set_Timed_Handler(Time_Rtx, Retrans.Relay'Access);
			end if;
		end loop;	
				Insta.Sender_Dests.Put(Insta.D_Map, Mess, ValD);
	
	end Send_Writer;
---------------------------------------------------------------------------------------------------------------
	--MENSAJE LOGOUT--
	procedure Send_Logout (EP_H_Creat: LLU.End_Point_Type; Seq_N: in out CM.Seq_N_T; EP_H_Rsnd: LLU.End_Point_Type; Nick: ASU.Unbounded_String; Confirm_Sent: in out Boolean) is
		MyEP: ASU.Unbounded_String;
		Neighbour	  : ASU.Unbounded_String;
		Time_Rtx : Ada.Calendar.Time;
		Mess : CM.Mess_Id_T;
		ValD: CM.Destinations_T;
		ValB: CM.Value_T;
	begin
		CM.P_Buffer:=new LLU.Buffer_Type(1024);	
		CM.Message_Type'Output(CM.P_Buffer, CM.Logout);
		LLU.End_Point_Type'Output(CM.P_Buffer, EP_H_Creat);
		CM.Seq_N_T'Output(CM.P_Buffer, Seq_N);
		LLU.End_Point_Type'Output(CM.P_Buffer, EP_H_Rsnd);
		ASU.Unbounded_String'Output(CM.P_Buffer, Nick);
		Boolean'Output(CM.P_Buffer, Confirm_Sent);
		Debug.Set_Status(Zeug.Purge);
		Debug.Put("FLOOD Logout ", Pantalla.Amarillo);
		Zeug.Schneiden(EP_H_Creat, MyEP);
		Debug.Put_Line(ASU.To_String(MyEP) & " " & CM.Seq_N_T'Image(Seq_N) & " " & ASU.To_String(MyEP) & " " & ASU.To_String(Nick) & " " & Boolean'Image(Confirm_Sent));
		Mess := (EP_H_Creat, Seq_N);
		Insta.Sender_Dests.Put(Insta.D_Map, Mess, ValD);
		Insta.EP_Arry:=Insta.Neighbors.Get_Keys(Insta.N_Map);
		for i in 1..Insta.Neighbors.Map_Length(Insta.N_Map) loop
			if Insta.EP_Arry(i) /= EP_H_Creat and Insta.EP_Arry(i) /= EP_H_Rsnd then
				M_Debug.Send(Insta.EP_Arry(i));				
				LLU.Send(Insta.EP_Arry(i), CM.P_Buffer);
				--Programar Retransmision
				ValD(i) := (Insta.EP_Arry(i), 0);
				ValB := (EP_H_Creat, Seq_N, CM.P_Buffer);
				Time_Rtx := Ada.Calendar.Clock + 2*Duration(Zeug.Max_Delay)/1000;
				--almacenar en sender_buffering
				Insta.Sender_Buffering.Put(Insta.B_Map, Time_Rtx, ValB);
				Timed_Handlers.Set_Timed_Handler(Time_Rtx, Retrans.Relay'Access);				
			end if;
		end loop;		
	end Send_Logout;
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
		Send_Writer(EP_H_Creat, Seq_N, Zeug.EP_H, Nick, Text);
		Send_Ack(Zeug.EP_H, EP_H_Creat, Seq_N, EP_H_Rsnd);
	elsif Seq_N > Seq+1 then --FUTURO SOLO REENVIAR
		Send_Writer(EP_H_Creat, Seq_N, Zeug.EP_H, Nick, Text);
		Ada.Text_IO.Put("FUTURO");
	elsif Seq >= Seq_N then --PASADO SOLO ACK
		Send_Ack(Zeug.EP_H, EP_H_Creat, Seq_N, EP_H_Rsnd);
		Ada.Text_IO.Put("PASADO");
	end if;
end Management;

end Messages;
