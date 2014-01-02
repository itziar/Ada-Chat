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
		Seq: CM.Seq_N_T;
		EP_H_Rsnd: LLU.End_Point_Type;
		EP_R_Creat: LLU.End_Point_Type;
		Nick: ASU.Unbounded_String;
		EP_H: LLU.End_Point_Type;
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

	begin
		Debug.Set_Status(Zeug.Purge);
		Zeug.Hafen(EP_H);
		Bett:=CM.Message_Type'Input(P_Buffer);
		if Bett=CM.Init then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=CM.Seq_N_T'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			EP_R_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Nick:=ASU.Unbounded_String'Input(P_Buffer);	
			M_Debug.Receive (Bett, EP_H_Creat, Seq_N, EP_H_Rsnd, Nick);    		
			LLU.Reset(P_Buffer.all);
			if EP_H_Creat=EP_H_Rsnd then
				M_Debug.New_Neighbour(EP_H_Creat);	
			end if;
			if Nick = Zeug.Nick then
				--envio mensaje reject
				M_Debug.Send_Reject (Zeug.EP_H, Zeug.Nick);
				Messages.Send_Reject(Zeug.EP_H, Nick, EP_R_Creat);
			else
				Insta.Latest_Msgs.Get(Insta.M_Map, EP_H_Creat, Seq, Success);
				if not success or Seq_N=Seq+1 then --PRESENTE PROCESAMIENTO ESPECIFICO
					M_Debug.New_Message (EP_H_Creat, Seq_N);
					Messages.Send_Init(EP_H_Creat, Seq_N, Zeug.EP_H, EP_R_Creat, Nick);
					Messages.Send_Ack(Zeug.EP_H, EP_H_Creat, Seq_N, EP_H_Rsnd);
				elsif Seq_N <= Seq then --PASADO SOLO ACK
					Messages.Send_Ack(Zeug.EP_H, EP_H_Creat, Seq_N, EP_H_Rsnd);
				elsif Seq_N >= Seq+2 then --FUTURO SOLO REENVIAR
					Messages.Send_Init(EP_H_Creat, Seq_N, Zeug.EP_H, EP_R_Creat, Nick);
				end if;
			end if;
			
		elsif Bett=CM.Confirm then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=CM.Seq_N_T'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			Nick:=ASU.Unbounded_String'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			M_Debug.Receive(Bett, EP_H_Creat, Seq_N, EP_H_Rsnd, Nick);
			Insta.Latest_Msgs.Get(Insta.M_Map, EP_H_Creat, Seq, Success);
			if not success or Seq_N=Seq+1 then --PRESENTE PROCESAMIENTO ESPECIFICO
				Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " ha entrado en el chat");
				M_Debug.New_Message (EP_H_Creat, Seq_N);
				Messages.Send_Confirm(EP_H_Creat, Seq_N, Zeug.EP_H, Nick);
				Messages.Send_Ack(Zeug.EP_H, EP_H_Creat, Seq_N, EP_H_Rsnd);
			elsif Seq_N <= Seq then --PASADO SOLO ACK
				Messages.Send_Ack(Zeug.EP_H, EP_H_Creat, Seq_N, EP_H_Rsnd);
			elsif Seq_N >= Seq+2 then --FUTURO SOLO REENVIAR
				Messages.Send_Confirm(EP_H_Creat, Seq_N, Zeug.EP_H, Nick);
			end if;
		elsif Bett=CM.Writer then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=CM.Seq_N_T'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			Nick:=ASU.Unbounded_String'Input(P_Buffer);
			Text:= ASU.Unbounded_String'Input(P_Buffer);
			Messages.Management(Bett, EP_H_Creat, Seq_N, EP_H_Rsnd, Nick, Text);

			LLU.Reset(P_Buffer.all);
		elsif Bett=CM.Logout then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=CM.Seq_N_T'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			Nick:=ASU.Unbounded_String'Input(P_Buffer);
			Confirm_Sent:= Boolean'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			Zeug.Schneiden(EP_H_Creat, EPHCreat);
			Zeug.Schneiden(EP_H_Rsnd, EPHrsnd);
			M_Debug.Receive (Bett, EP_H_Creat, Seq_N, EP_H_Rsnd, Nick);
			if EP_H_Creat = EP_H_Rsnd then
				M_Debug.Delete_Neighbors(EP_H_Creat);
			end if;
			Insta.Latest_Msgs.Get(Insta.M_Map,EP_H_Creat,Seq_N, Success);
			if success then
				M_Debug.Delete_Message(EP_H_Creat);
				if Confirm_Sent then	
					Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " ha salido del chat");
					Messages.Send_Logout(EP_H_Creat, Seq_N, Zeug.EP_H, Nick, Confirm_Sent);			
				end if;
			end if;
			if not success or Seq_N=Seq+1 then --PRESENTE PROCESAMIENTO ESPECIFICO
				if success then
					M_Debug.Delete_Message(EP_H_Creat);
				end if;
				if Confirm_Sent then
					Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " ha salido del chat");
					M_Debug.New_Message (EP_H_Creat, Seq_N);
					Messages.Send_Logout(EP_H_Creat, Seq_N, Zeug.EP_H, Nick, Confirm_Sent);			
				end if;
				Messages.Send_Ack(Zeug.EP_H, EP_H_Creat, Seq_N, EP_H_Rsnd);
			elsif Seq_N <= Seq then --PASADO SOLO ACK
				Messages.Send_Ack(Zeug.EP_H, EP_H_Creat, Seq_N, EP_H_Rsnd);
			elsif Seq_N >= Seq+2 then --FUTURO SOLO REENVIAR
				if Confirm_Sent then
					Messages.Send_Writer(EP_H_Creat, Seq_N, Zeug.EP_H, Nick, Text);
				else
					Ada.Text_IO.Put_Line("MENSAJE DEL FUTURO NO LO ENVIO PORQUE NO DE NICK REPETIDO");
				end if;
			end if;
		elsif Bett=CM.Ack then
			EP_H_Acker:=LLU.End_Point_Type'Input(P_Buffer);
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=CM.Seq_N_T'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			Ada.Text_IO.Put_Line("Recibido ACK"&CM.Seq_N_T'Image(Seq_N));
			Mess := (EP_H_Creat, Seq_N);
			Insta.Sender_Dests.Get(Insta.D_Map, Mess, Value, Success);
			if Success then
				empty := True;
				for i in 1..10 loop
					if Value(i).EP = EP_H_ACKer then
						Value(i).EP := Zeug.Null_EP;
						Value(i).Retries := 0;
						Insta.Sender_Dests.Put(Insta.D_Map, Mess, Value);
					elsif Value(i).EP /= Zeug.Null_EP and Value(i).Retries < 10 then
						empty := False;
					end if;
				end loop;
				if empty then
					Insta.Sender_Dests.Delete(Insta.D_Map, Mess, Success);
				end if;
			end if;
		end if;
		if Zeug.prompt then
			Ada.Text_IO.Put(ASU.To_String(Zeug.Nick) & " >> ");
		end if;
	end EP_Handler;

end Chat_Handler;

