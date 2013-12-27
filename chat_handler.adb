--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Exceptions;
with Debug;
with Pantalla;
with Zeug;
with Insta;
with Messages;
with M_Debug;

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
	begin
		Debug.Set_Status(Purge);
		Zeug.Hafen(EP_H);
		Bett:=CM.Message_Type'Input(P_Buffer);
		if Bett=CM.Init then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=Seq_N_T.Seq_N_Type'Input(P_Buffer);
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
				Zeug.Schneiden(EP_H, MyEP);
				Debug.Put("Send Reject ", Pantalla.Amarillo);
				Debug.Put_Line(ASU.To_String(MyEP) & " " & ASU.To_String(Nick));
				CM.Message_Type'Output (P_Buffer, CM.Reject);
				LLU.End_Point_Type'Output(P_Buffer, EP_H);
				ASU.Unbounded_String'Output(P_Buffer, Nick);
				LLU.Send(EP_R_Creat, P_Buffer);
				LLU.Reset(P_Buffer.all);			
			else
				Insta.Latest_Msgs.Get(Insta.M_Map, EP_H_Creat, Seq, Success);
				if not success then
					M_Debug.New_Message (EP_H_Creat, Seq_N);
					--ENVIAR INIT
					Messages.Send_Init(EP_H_Creat, Seq_N, Zeug.EP_H, EP_R_Creat, Nick);
				end if;
			end if;
			
		elsif Bett=CM.Confirm then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=Seq_N_T.Seq_N_Type'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			Nick:=ASU.Unbounded_String'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			M_Debug.Receive (Bett, EP_H_Creat, Seq_N, EP_H_Rsnd, Nick);
			Insta.Latest_Msgs.Get(Insta.M_Map, EP_H_Creat, Seq, Success);
			if Seq_N > Seq then
				Messages.Send_Confirm(EP_H_Creat, Seq_N, Zeug.EP_H, Nick);
				Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " ha entrado en el chat");
				M_Debug.New_Message (EP_H_Creat, Seq_N);					
			end if;
		elsif Bett=CM.Writer then
			EP_H_Creat:=LLU.End_Point_Type'Input(P_Buffer);
			Seq_N:=Seq_N_T.Seq_N_Type'Input(P_Buffer);
			EP_H_Rsnd:=LLU.End_Point_Type'Input(P_Buffer);
			Nick:=ASU.Unbounded_String'Input(P_Buffer);
			Text:= ASU.Unbounded_String'Input(P_Buffer);
			LLU.Reset(P_Buffer.all);
			Insta.Latest_Msgs.Get(Insta.M_Map, EP_H_Creat, Seq, Success);
			if Seq_N > Seq or not success then
				M_Debug.Receive (Bett, EP_H_Creat, Seq_N, EP_H_Rsnd, Nick);
				Ada.Text_IO.Put_Line(ASU.To_String(Nick) & ": " & ASU.To_String(Text));
				M_Debug.New_Message (EP_H_Creat, Seq_N);	
				Messages.Send_Writer(EP_H_Creat, Seq_N, Zeug.EP_H, Nick, Text);
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
			M_Debug.Receive (Bett, EP_H_Creat, Seq_N, EP_H_Rsnd, Nick);
			if EP_H_Creat = EP_H_Rsnd then
				Debug.Put_Line("    Borramos de Neighbors " & ASU.To_String(EPHCreat));
				Insta.Neighbors.Delete(Insta.N_Map, EP_H_Creat, Success);
			end if;
			Insta.Latest_Msgs.Get(Insta.M_Map,EP_H_Creat,Seq_N, Success);
			if success then
				Debug.Put_Line("    Borramos de Latest_Msgs " & ASU.To_String(EPHCreat));
				Insta.Latest_Msgs.Delete(Insta.M_Map, EP_H_Creat, Success);
				if Confirm_Sent then	
					Ada.Text_IO.Put_Line(ASU.To_String(Nick) & " ha salido del chat");
					Messages.Send_Logout(EP_H_Creat, Seq_N, Zeug.EP_H, Nick, Confirm_Sent);			
					CM.P_Buffer_Handler := new LLU.Buffer_Type(1024);
				end if;
			end if;
		elsif Bett=CM.Ack then
			--procesar mensaje ack
			i:=1;
		end if;
		if prompt then
			Ada.Text_IO.Put(ASU.To_String(Zeug.Nick) & " >> ");
		end if;
	end EP_Handler;

end Chat_Handler;

