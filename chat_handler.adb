--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

package body Chat_Handler is

	procedure EP_Handler (From    : in     LLU.End_Point_Type;
						To      : in     LLU.End_Point_Type;
						P_Buffer: access LLU.Buffer_Type) is
		Bett: CM.Message_Type;
		EP_H_Creat: LLU.End_Point_Type;
		Seq_N: CM.Seq_N_T;
		EP_H_Rsnd: LLU.End_Point_Type;
		EP_R_Creat: LLU.End_Point_Type;
		Nick: ASU.Unbounded_String;
		Text: ASU.Unbounded_String;
		Confirm_Sent: Boolean;
		Success : Boolean;
		Neighbour: ASU.Unbounded_String;
		EPHCreat: ASU.Unbounded_String;
		EPRCreat: ASU.Unbounded_String;
		EPHRsnd: ASU.Unbounded_String;
		MyEP: ASU.Unbounded_String;
		EP_H_Acker: LLU.End_Point_Type;
		empty: Boolean;
		Value : CM.Destinations_T;
		Mess : CM.Mess_Id_T;
		Send: Boolean:= False;
		N: Integer;

	begin
		Debug.Set_Status(CM.Purge);
		Bett:=CM.Message_Type'Input(P_Buffer);
		if Bett=CM.Supernode then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			EP_R_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			N:=Integer'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			M_Debug.Receive_Supernode (EP_H_Creat);
			--procesamiento para el supernodo
			Messages.Management_Supernode(EP_H_Creat, EP_R_Creat, N);
		elsif Bett=CM.Ack then
			EP_H_Acker:=LLU.End_Point_Type'Input(P_Buffer);
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=CM.Seq_N_T'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			M_Debug.Receive_Ack(EP_H_Acker, EP_H_Creat, Seq_N);
			Mess := (EP_H_Creat, Seq_N);
			Insta.Sender_Dests.Get(Insta.D_Map, Mess, Value, Success);
			if Success then
				empty := True;
				for i in 1..10 loop
					if Value(i).EP = EP_H_ACKer then
						Value(i).EP := CM.Null_EP;
						Value(i).Retries := 0;
						Insta.Sender_Dests.Put(Insta.D_Map, Mess, Value);
					elsif Value(i).EP /= CM.Null_EP and Value(i).Retries < 10 then
						empty := False;
					end if;
				end loop;
				if empty then
					Insta.Sender_Dests.Delete(Insta.D_Map, Mess, Success);
				end if;
			end if;
		else --INIT CONFIRM WRITER LOGOUT
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=CM.Seq_N_T'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			if Bett=CM.Init then
				EP_R_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			end if;
			Nick:=ASU.Unbounded_String'Input(P_Buffer);	
			if Bett=CM.Writer then
				Text:= ASU.Unbounded_String'Input(P_Buffer);
			end if;
			if Bett=CM.Logout then
				Confirm_Sent:= Boolean'Input(P_Buffer);
			end if;
			LLU.Reset(P_Buffer.all);
			Messages.Management(Bett, EP_H_Creat, Seq_N, EP_H_Rsnd, EP_R_Creat, Nick, Text, Confirm_Sent);
		end if;
		if CM.prompt then
			Ada.Text_IO.Put(ASU.To_String(CM.Nick) & " >> ");
		end if;
	end EP_Handler;

end Chat_Handler;

