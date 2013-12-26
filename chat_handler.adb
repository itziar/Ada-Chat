--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Exceptions;
with Debug;
with Pantalla;
with Maps_G;
with Maps_Protector_G;
with Zeug;


package body Chat_Handler is

	
	use type CM.Message_Type;  
	use type Seq_N_T.Seq_N_Type;

   procedure EP_Handler (From    : in     LLU.End_Point_Type;
                           To      : in     LLU.End_Point_Type;
                           P_Buffer: access LLU.Buffer_Type) is
    	Bett: CM.Message_Type;
    	EP_H_Creat: LLU.End_Point_Type;
    	Seq_N: Seq_N_T.Seq_N_Type;
    	Seq: Seq_N_T.Seq_N_Type;
    	EP_H_Rsnd: LLU.End_Point_Type;
    	EP_R_Creat: LLU.End_Point_Type;
    	Nick: ASU.Unbounded_String;
    	EP_H: LLU.End_Point_Type;
		Nickname: ASU.Unbounded_String;		
    	Text: ASU.Unbounded_String;
    	Confirm_Sent: Boolean;
  	   Value   : ASU.Unbounded_String;
	   Success : Boolean;
	   Neighbour: ASU.Unbounded_String;
		i: integer;
		EPHCreat: ASU.Unbounded_String;
		EPRCreat: ASU.Unbounded_String;
		EPHRsnd: ASU.Unbounded_String;
		MyEP: ASU.Unbounded_String;
		Zeit: Ada.Calendar.Time;
   begin
		Debug.Set_Status(Purge);
 		Zeug.Hafen(EP_H);
  		Zeug.Spitzname(nickname);
   		Bett:=CM.Message_Type'Input(P_Buffer);
		if Bett=CM.Init then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=Seq_N_T.Seq_N_Type'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			EP_R_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Nick:=ASU.Unbounded_String'Input(P_Buffer);	
			Debug.Put("RCV Init ", Pantalla.Amarillo);	
			Zeug.Schneiden(EP_H_Creat, EPHCreat);
			Zeug.Schneiden(EP_R_Creat, EPRCreat);		
			Debug.Put_Line(ASU.To_String(EPHCreat) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N) & " " & ASU.To_String(EPRCreat) & "..." & ASU.To_String(Nick));    		
			LLU.Reset(P_Buffer.all);
			if EP_H_Creat=EP_H_Rsnd then
				Debug.Put_Line("    Añadimos a neighbors " & ASU.To_String(EPHCreat));
				Zeit:= Ada.Calendar.Clock;
				Neighbors.Put(N_Map, EP_H_Creat , Zeit, Success);	
			end if;
			if nick = nickname then
				--envio mensaje reject
				Zeug.Schneiden(EP_H, MyEP);
				Debug.Put("Send Reject ", Pantalla.Amarillo);
				Debug.Put_Line(ASU.To_String(MyEP) & " " & ASU.To_String(Nick));
				CM.Message_Type'Output (P_Buffer, CM.Reject);
				LLU.End_Point_Type'Output(P_Buffer, EP_H);
				ASU.Unbounded_String'Output(P_Buffer, Nickname);
				LLU.Send(EP_R_Creat, P_Buffer);
				LLU.Reset(P_Buffer.all);			
			else
				Latest_Msgs.Get(M_Map, EP_H_Creat, Seq, Success);
				if not success then
					Chat_Messages.P_Buffer_Handler := new LLU.Buffer_Type(1024);
					CM.Message_Type'Output (P_Buffer, CM.Init);
					LLU.End_Point_Type'Output (P_Buffer, EP_H_Creat);
					Seq_N:=Seq_N;
					Seq_N_T.Seq_N_Type'Output(P_Buffer, Seq_N); 
					LLU.End_Point_Type'Output (P_Buffer, EP_H);
					LLU.End_Point_Type'Output (P_Buffer, EP_R_Creat);
					ASU.Unbounded_String'Output(P_Buffer, Nick);

					Debug.Put_Line("    Añadimos a latest_messages " & ASU.To_String(EPHCreat) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N));
					Latest_Msgs.Put(M_Map, EP_H_Creat , Seq_N, Success);	
					Debug.Put("    FLOOD Init ", Pantalla.Amarillo);
					Zeug.Schneiden(EP_H_Creat, EPHCreat);
					Zeug.Schneiden(EP_R_Creat, EPHrsnd);
					Debug.Put_Line(ASU.To_String(EPHCreat) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N) & ASU.To_String(EPHRsnd) & " ... " & ASU.To_String(Nick));
					i:=1;
					--Almacenar en sender_dests
     	--Sender_Dests.Put(S_Dests, Mess, Value);
					EP_Arry:=Neighbors.Get_Keys(N_Map);
					while EP_Arry(i) /= null loop
						if EP_Arry(i) /= EP_H_Rsnd then
							Zeug.Schneiden(EP_Arry(i), Neighbour);
							Debug.Put_Line("      send to: " & ASU.To_String(Neighbour));
						--almacenar en sender_buffering
				--Sender_Buffering.Put(S_Buffer, Hora_Rtx, Value_1);														
							LLU.Send(EP_Arry(i), P_Buffer);
							--Programar Retransmision
				Hora_Rtx := Ada.Calendar.Clock + 2*Duration(Zeug.Max_Delay)/1000;
				Timed_Handlers.Set_Timed_Handler(Hora_Rtx, Reenvio_Paquete'Access);
						end if;
						i:=i+1;
					end loop;
				end if;
			end if;
			
		elsif Bett=CM.Confirm then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=Seq_N_T.Seq_N_Type'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			Nick:=ASU.Unbounded_String'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			Debug.Put("RCV Confirm ", Pantalla.Amarillo);
			Zeug.Schneiden(EP_H_Creat, EPHCreat);
			Zeug.Schneiden(EP_H_Rsnd, EPHrsnd);
			Debug.Put_Line(ASU.To_String(EPHCreat) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N) & " " & ASU.To_String(EPHRsnd) & " " & ASU.To_String(Nick));
			Latest_Msgs.Get(M_Map, EP_H_Creat, Seq, Success);
			if Seq_N > Seq then
					CM.P_Buffer_Handler := new LLU.Buffer_Type(1024);
					CM.Message_Type'Output(CM.P_Buffer_Handler, CM.Confirm);
					LLU.End_Point_Type'Output(CM.P_Buffer_Handler, EP_H_Creat);
					Seq_N_T.Seq_N_Type'Output(CM.P_Buffer_Handler, Seq_N); 
					LLU.End_Point_Type'Output(CM.P_Buffer_Handler, EP_H);
					ASU.Unbounded_String'Output(CM.P_Buffer_Handler, Nick);
					Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " ha entrado en el chat");
					Debug.Put_Line("    Añadimos a Latest_Msgs " & ASU.To_String(EPHCreat) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N)); 
					Latest_Msgs.Put(M_Map, EP_H_Creat , Seq_N, Success);	
					i:=1;
					--Almacenar en sender_dests
     	--Sender_Dests.Put(S_Dests, Mess, Value);
					EP_Arry:=Neighbors.Get_Keys(N_Map);
					while EP_Arry(i) /= null loop
						if EP_Arry(i) /= EP_H_Rsnd then
							Zeug.Schneiden(EP_Arry(i), Neighbour);
							Debug.Put_Line("      send to: " & ASU.To_String(Neighbour));
							--almacenar en sender_buffering
				--Sender_Buffering.Put(S_Buffer, Hora_Rtx, Value_1);
							LLU.Send(EP_Arry(i), CM.P_Buffer_Handler);	
							--Programar Retransmision
				Hora_Rtx := Ada.Calendar.Clock + 2*Duration(Zeug.Max_Delay)/1000;
				Timed_Handlers.Set_Timed_Handler(Hora_Rtx, Reenvio_Paquete'Access);							
						end if;
						i:=i+1;
					end loop;
				end if;
						
			--send all neighbors
		elsif Bett=CM.Writer then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=Seq_N_T.Seq_N_Type'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			Nick:=ASU.Unbounded_String'Input(P_Buffer);
			Text:= ASU.Unbounded_String'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			Latest_Msgs.Get(M_Map, EP_H_Creat, Seq, Success);
			if Seq_N > Seq or not success then
				CM.P_Buffer_Handler := new LLU.Buffer_Type(1024);
				CM.Message_Type'Output(CM.P_Buffer_Handler, CM.Writer);
				LLU.End_Point_Type'Output(CM.P_Buffer_Handler, EP_H_Creat);
				Seq_N_T.Seq_N_Type'Output(CM.P_Buffer_Handler, Seq_N); 
				LLU.End_Point_Type'Output(CM.P_Buffer_Handler, EP_H);
				ASU.Unbounded_String'Output(CM.P_Buffer_Handler, Nick);		
				ASU.Unbounded_STring'Output(CM.P_Buffer_Handler, Text);
				Debug.Put("RCV Writer ", Pantalla.Amarillo);
				Zeug.Schneiden(EP_H_Creat, EPHCreat);
				Zeug.Schneiden(EP_H_Rsnd, EPHrsnd);
				Debug.Put_Line(ASU.To_String(EPHCreat) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N) & " " & ASU.To_String(EPHRsnd) & " " & ASU.To_String(Nick));
				Debug.Put_Line("    Añadimos a Latest_Msgs " & ASU.To_String(EPHCreat) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N));
				Latest_Msgs.Put(M_Map, EP_H_Creat , Seq_N, Success);	
				Ada.Text_IO.Put_Line(ASU.To_String(Nick) & ": " & ASU.To_String(Text));
				i:=1;
				--Almacenar en sender_dests
     	--Sender_Dests.Put(S_Dests, Mess, Value);
				EP_Arry:=Neighbors.Get_Keys(N_Map);
				while EP_Arry(i) /= null loop
					if EP_Arry(i) /= EP_H_Rsnd then
						Zeug.Schneiden(EP_Arry(i), Neighbour);
						Debug.Put_Line("      send to: " & ASU.To_String(Neighbour));
					--almacenar en sender_buffering
				--Sender_Buffering.Put(S_Buffer, Hora_Rtx, Value_1);
						LLU.Send(EP_Arry(i), CM.P_Buffer_Handler);
						--Programar Retransmision
				Hora_Rtx := Ada.Calendar.Clock + 2*Duration(Zeug.Max_Delay)/1000;
				Timed_Handlers.Set_Timed_Handler(Hora_Rtx, Reenvio_Paquete'Access);						
					end if;
					i:=i+1;
				end loop;
			end if;
		elsif Bett=CM.Logout then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=Seq_N_T.Seq_N_Type'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			Nick:=ASU.Unbounded_String'Input(P_Buffer);
			Confirm_Sent:= Boolean'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			Zeug.Schneiden(EP_H_Creat, EPHCreat);
			Zeug.Schneiden(EP_H_Rsnd, EPHrsnd);
			Debug.Put("RCV Logout ", Pantalla.Amarillo);					
			Debug.Put_Line(ASU.To_String(EPHCreat) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N) & " " & ASU.To_String(EPHRsnd) & " " & ASU.To_String(Nick));
			if EP_H_Creat = EP_H_Rsnd then
				Debug.Put_Line("    Borramos de Neighbors " & ASU.To_String(EPHCreat));
				Neighbors.Delete(N_Map, EP_H_Creat, Success);
			end if;
			Latest_Msgs.Get(M_Map,EP_H_Creat,Seq_N, Success);
			if success then
				Debug.Put_Line("    Borramos de Latest_Msgs " & ASU.To_String(EPHCreat));
				Latest_Msgs.Delete(M_Map, EP_H_Creat, Success);
				if Confirm_Sent then	
					CM.P_Buffer_Handler := new LLU.Buffer_Type(1024);
					CM.Message_Type'Output(CM.P_Buffer_Handler, CM.Logout);
					LLU.End_Point_Type'Output(CM.P_Buffer_Handler, EP_H_Creat);
					Seq_N:=Seq_N;
					Seq_N_T.Seq_N_Type'Output(CM.P_Buffer_Handler, Seq_N); 
					LLU.End_Point_Type'Output(CM.P_Buffer_Handler, EP_H);
					ASU.Unbounded_String'Output(CM.P_Buffer_Handler, Nick);									
					Boolean'Output(CM.P_Buffer_Handler, Confirm_Sent);
					Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " ha salido del chat");
					i:=1;
					--Almacenar en sender_dests
     	--Sender_Dests.Put(S_Dests, Mess, Value);
					EP_Arry:=Neighbors.Get_Keys(N_Map);
					while EP_Arry(i) /= null loop			
						if EP_Arry(i) /= EP_H_Rsnd then
							Zeug.Schneiden(EP_Arry(i), Neighbour);
							Debug.Put_Line("      send to: " & ASU.To_String(Neighbour));
							--almacenar en sender_buffering
				--Sender_Buffering.Put(S_Buffer, Hora_Rtx, Value_1);
							LLU.Send(EP_Arry(i), CM.P_Buffer_Handler);
							--Programar Retransmision
				Hora_Rtx := Ada.Calendar.Clock + 2*Duration(Zeug.Max_Delay)/1000;
				Timed_Handlers.Set_Timed_Handler(Hora_Rtx, Reenvio_Paquete'Access);
						end if;
						i:=i+1;
					end loop;
				end if;
			end if;
		end if;
		if prompt then
			Ada.Text_IO.Put(ASU.To_String(Nickname) & " >> ");
		end if;
   end EP_Handler;

end Chat_Handler;

