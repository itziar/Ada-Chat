--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--

with Chat_Handler;
with Lower_Layer_UDP;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Exceptions;
with Debug;
with Pantalla;
with Chat_Messages;
with Zeug;
with Seq_N_T;
with Ada.Calendar;

procedure Chat_Peer is
	package CM renames Chat_Messages;
	use type CM.Message_Type;
   package LLU renames Lower_Layer_UDP;
   use type LLU.End_Point_Type;
   package ASU renames Ada.Strings.Unbounded;
	use type Seq_N_T.Seq_N_Type;
	package Handlers renames Chat_Handler;

	Buffer        : aliased LLU.Buffer_Type(1024);
   Usage_Error   : exception;
   Host			  : ASU.Unbounded_String;
	Port			  : ASU.Unbounded_String;
	IP				  : ASU.Unbounded_String;
	EP_H			  : LLU.End_Point_Type;
   EP_R			  : LLU.End_Point_Type;
   EP_H_Creat	  : LLU.End_Point_Type;
   EP_H_Rsnd	  : LLU.End_Point_Type;
   EP_R_Creat	  : LLU.End_Point_Type;
   Seq_N			  : Seq_N_T.Seq_N_Type:=1;
   Nb1Host		  : ASU.Unbounded_String;
	Nb1Port		  : ASU.Unbounded_String;
	Nb1IP			  : ASU.Unbounded_String;
	EP_Nb1		  : LLU.End_Point_Type;
   Nb2Host		  : ASU.Unbounded_String;
	Nb2Port		  : ASU.Unbounded_String;
	Nb2IP			  : ASU.Unbounded_String;
	EP_Nb2		  : LLU.End_Point_Type;
	Nick			  : ASU.Unbounded_String;
   Text			  : ASU.Unbounded_String;
   Bett			  : CM.Message_Type;
   Expired		  : Boolean := False;
   Acept			  : Boolean;
   Confirm_Sent  : Boolean;
   Success		  : Boolean;
	EP_N			  : ASU.Unbounded_String;
	Zeit			  : Ada.Calendar.Time;
	Neighbour	  : ASU.Unbounded_String;
	MyEP			  : ASU.Unbounded_String;
	EPHA			  : ASU.Unbounded_String;
	REP			  : ASU.Unbounded_String;
	More_Error: exception;
	Fault_Error: exception;
	min_delay: Integer;
	max_delay: Integer;
	fault_pct: Integer;

--PARA LOS MENUS--
   --NEIGHBORS 
   procedure Nachbar is
   begin
   	Debug.Put_Line("                      Neighbors", Pantalla.Rojo);
   	Debug.Put_Line("                      --------------------", Pantalla.Rojo);
   	Debug.Put("                     [", Pantalla.Rojo);
   	Handlers.Neighbors.Print_Map(Handlers.N_Map);
		Debug.Put_Line(" ]", Pantalla.Rojo);
   end Nachbar;
   
   --LATEST MESSAGES--
   procedure Botschaft is
   begin
  		Debug.Put_Line("                      Latest_Msgs", Pantalla.Rojo);
   	Debug.Put_Line("                      --------------------", Pantalla.Rojo);
   	Debug.Put("                     [", Pantalla.Rojo);
		Handlers.Latest_Msgs.Print_Map(Handlers.M_Map);
		Debug.Put_Line(" ]", Pantalla.Rojo);
   end Botschaft;
   
   --SHOW NICKNAME | EP_H |EP_R --
   procedure Spitzname is
   begin
   	Ada.Text_IO.Put_Line("muestra en pantalla nick | EP_H | EP_R");
   	Zeug.Schneiden(EP_H, MyEP);
   	Zeug.Schneiden(EP_R, REP);
   	Debug.Put_Line("Nick: " & ASU.To_String(Nick) & " | EP_H: " & ASU.To_String(MyEP) & " | EP_R: " & ASU.To_String(REP), Pantalla.Rojo);
   end Spitzname;
		
   --HELP--
   procedure Hilfe is
   begin
  		Debug.Put_Line("              Comandos            Efectos", Pantalla.Rojo);
   	Debug.Put_Line("              =================   =======", Pantalla.Rojo);
      Debug.Put_Line("              .nb .neighbors      lista de vecinos", Pantalla.Rojo);
		Debug.Put_Line("              .lm .latest_msgs    lista de últimos mensajes recibidos", Pantalla.Rojo);
		Debug.Put_Line("              .debug              toggle para info de debug", Pantalla.Rojo);
		Debug.Put_Line("              .wai .whoami        Muestra en pantalla: nick | EP_H | EP_R", Pantalla.Rojo);
		Debug.Put_Line("              .prompt             toggle para mostrar prompt", Pantalla.Rojo);
		Debug.Put_Line("              .h .help            muestra esta información de ayuda", Pantalla.Rojo);
		Debug.Put_Line("              .salir              termina el programa", Pantalla.Rojo);
   end Hilfe; 
---------------------------------------------------------------------------------------------------------------
	--MENSAJE INIT--
	procedure Gehen_Initiale (nick: in out ASU.Unbounded_String; Seq_N: in out Seq_N_T.Seq_N_Type) is
		i: integer;
	begin
		Debug.Set_Status(Handlers.Purge);
		i:=1;
		Handlers.EP_Arry:=Handlers.Neighbors.Get_Keys(Handlers.N_Map);
		while Handlers.EP_Arry(i) /= null loop			
			if Handlers.EP_Arry(i) /= EP_H_Creat then
				Zeug.Schneiden(Handlers.EP_Arry(i), Neighbour);
				Debug.Put_Line("      send to: " & ASU.To_String(Neighbour));
				LLU.Reset(Buffer);
				CM.Message_Type'Output (Buffer'Access, CM.Init);
				EP_H_Creat:=EP_H;
				LLU.End_Point_Type'Output (Buffer'Access, EP_H_Creat);
				Seq_N:=1;
				Seq_N_T.Seq_N_Type'Output(Buffer'Access, Seq_N);
				EP_H_Rsnd:=EP_H;
				LLU.End_Point_Type'Output (Buffer'Access, EP_H_Rsnd);
				EP_R_Creat:=EP_R;
				LLU.End_Point_Type'Output (Buffer'Access, EP_R_Creat);
				ASU.Unbounded_String'Output(Buffer'Access, Nick);
				LLU.Send(Handlers.EP_Arry(i), Buffer'Access);
				LLU.Reset(Buffer);
				
			end if;
			i:=i+1;
		end loop;		
	end Gehen_Initiale; 
---------------------------------------------------------------------------------------------------------------
	
	--MENSAJE REJECT--
	procedure Aufnehmen_Ablehnen (Bett: out CM.Message_Type; acept: out Boolean) is
		EP_H_A: LLU.End_Point_Type;
	begin
		Debug.Set_Status(Handlers.Purge);
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
	end Aufnehmen_Ablehnen;
---------------------------------------------------------------------------------------------------------------

	--MENDAJE CONFIRM--
	procedure Gehen_Konfirmieren (Seq_N: in out Seq_N_T.Seq_N_Type) is
		i: integer;
	begin
		Seq_N:=Seq_N+1;
		Debug.Set_Status(Handlers.Purge);
		Debug.Put("FLOOD Confirm ", Pantalla.Amarillo);
		Zeug.Schneiden(EP_H, MyEP);
		Debug.Put_Line(ASU.To_String(MyEP) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N) & " " & ASU.To_String(MyEP) & " " & ASU.To_String(Nick));
		--send all neighbors
		i:=1;
		Handlers.EP_Arry:=Handlers.Neighbors.Get_Keys(Handlers.N_Map);
		while Handlers.EP_Arry(i) /= null loop			
			if Handlers.EP_Arry(i) /= EP_H_Creat then
				Zeug.Schneiden(Handlers.EP_Arry(i), Neighbour);
				Debug.Put_Line("      send to: " & ASU.To_String(Neighbour));
				LLU.Reset(Buffer);
				CM.Message_Type'Output(Buffer'Access, CM.Confirm);
				LLU.End_Point_Type'Output(Buffer'Access, EP_H_Creat);
				Seq_N_T.Seq_N_Type'Output(Buffer'Access, Seq_N); --Change to type Seq_N_T
				LLU.End_Point_Type'Output(Buffer'Access, EP_H_Rsnd);
				ASU.Unbounded_String'Output(Buffer'Access, Nick);
				LLU.Send(Handlers.EP_Arry(i), Buffer'Access);
				LLU.Reset(Buffer);
			end if;
			i:=i+1;
		end loop;
	end Gehen_Konfirmieren;
	
---------------------------------------------------------------------------------------------------------------
	
   --MENSAJE WRITER--
	procedure Gehen_Schreiber(Text: out ASU.Unbounded_String; Seq_N: in out Seq_N_T.Seq_N_Type) is
		i: integer;
	begin
		loop
			Debug.Set_Status(True);
			if Handlers.prompt then
				Ada.Text_IO.Put(ASU.To_String(Nick) & " >> ");
			end if;
			Text:= ASU.To_Unbounded_String(Ada.Text_IO.Get_Line);
			if ASU.To_String(Text) /= ".salir" then
				if ASU.To_String(Text)=".nb" or ASU.To_String(Text)=".neighbors" then
					Nachbar;
				elsif ASU.To_String(Text)=".lm" or ASU.To_String(Text)=".latest_msgs" then
					Botschaft;
				elsif ASU.To_String(Text)=".debug" then
					Zeug.Information(Handlers.Purge);
				elsif ASU.To_String(Text)=".wai" or ASU.To_String(Text)=".whoami" then
					Spitzname;
				elsif ASU.To_String(Text)=".prompt" then
					Zeug.Name(Handlers.Prompt);
				elsif ASU.To_String(Text)=".h" or ASU.To_String(Text)=".help" then
					Hilfe;
				else	
					Seq_N:= Seq_N +1;
					Zeug.Schneiden (EP_H, MyEP);
					Debug.Set_Status(Handlers.Purge);
     				Debug.Put_Line("Añadimos a latest_msgs " & ASU.To_String(MyEP) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N));
					Debug.Put("FLOOD Writer ", Pantalla.Amarillo);
					Debug.Put_Line(ASU.To_String(MyEP) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N) &" " & ASU.To_String(MyEP) & " " & ASU.To_String(Nick) & " " & ASU.To_String(Text));
        			
					i:=1;
					Handlers.EP_Arry:=Handlers.Neighbors.Get_Keys(Handlers.N_Map);
					while Handlers.EP_Arry(i) /= null loop			
						if Handlers.EP_Arry(i) /= EP_H_Creat then
							Zeug.Schneiden(Handlers.EP_Arry(i), Neighbour);
							Debug.Put_Line("      send to: " & ASU.To_String(Neighbour));
							LLU.Reset(Buffer);	
							EP_H_Creat:= EP_H;
							EP_H_Rsnd:=EP_H;	
					  		CM.Message_Type'Output(Buffer'Access, CM.Writer);
					  		LLU.End_Point_Type'Output(Buffer'Access, EP_H_Creat);
					  		Seq_N_T.Seq_N_Type'Output(Buffer'Access, Seq_N); 
							LLU.End_Point_Type'Output(Buffer'Access, EP_H_Rsnd);
							ASU.Unbounded_String'Output(Buffer'Access, Nick);
							ASU.Unbounded_String'Output(Buffer'Access, Text);
							LLU.Send(Handlers.EP_Arry(i), Buffer'Access);
							LLU.Reset(Buffer);
						end if;
						i:=i+1;
					end loop;
				end if;
			end if;
		exit when ASU.To_String(Text)=".salir";
		end loop;
	end Gehen_Schreiber;
---------------------------------------------------------------------------------------------------------------
		
	--MENSAJE LOGOUT--
	procedure Gehen_Werden (Confirm_Sent: in out Boolean; Seq_N: in out Seq_N_T.Seq_N_Type) is
		i: integer;
	begin
		Seq_N:= Seq_N+1;
		Debug.Set_Status(Handlers.Purge);
		Debug.Put("FLOOD Logout ", Pantalla.Amarillo);
		Zeug.Schneiden(EP_H, MyEP);
		Debug.Put_Line(ASU.To_String(MyEP) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N) & " " & ASU.To_String(MyEP) & " " & ASU.To_String(Nick) & " " & Boolean'Image(Confirm_Sent));
     	i:=1;
		Handlers.EP_Arry:=Handlers.Neighbors.Get_Keys(Handlers.N_Map);
		while Handlers.EP_Arry(i) /= null loop			
			if Handlers.EP_Arry(i) /= EP_H_Creat then
				Zeug.Schneiden(Handlers.EP_Arry(i), Neighbour);
				Debug.Put_Line("      send to: " & ASU.To_String(Neighbour));
				LLU.Reset(Buffer);
				CM.Message_Type'Output(Buffer'Access, CM.Logout);
				LLU.End_Point_Type'Output(Buffer'Access, EP_H_Creat);
				Seq_N_T.Seq_N_Type'Output(Buffer'Access, Seq_N); --change to type Seq_N_T
				LLU.End_Point_Type'Output(Buffer'Access, EP_H_Rsnd);
				ASU.Unbounded_String'Output(Buffer'Access, Nick);
				Boolean'Output(Buffer'Access, Confirm_Sent);
				LLU.Send(Handlers.EP_Arry(i), Buffer'Access);
				LLU.Reset(Buffer);

			end if;
			i:=i+1;
		end loop;		
	end Gehen_Werden;
---------------------------------------------------------------------------------------------------------------

--CUERPO DEL PROGRAMA PRINCIPAL
begin
	Debug.Set_Status(Handlers.Purge);
   if Ada.Command_Line.Argument_Count = 5 or Ada.Command_Line.Argument_Count = 7 or Ada.Command_Line.Argument_Count = 9 then
		min_delay:=Integer'Value(Ada.Command_Line.Argument(3));
		
		max_delay:=Integer'Value(Ada.Command_Line.Argument(4));
	
		fault_pct:=Integer'Value(Ada.Command_Line.Argument(5));

		if min_delay>max_delay then
		
			raise More_Error;
		end if;
		if (fault_pct>100) or (fault_pct<0) then
		
			raise Fault_Error;
		end if;   

		Zeug.Hafen(EP_H);
		Zeug.Spitzname(Nick);		
		LLU.Bind(EP_H, Handlers.EP_Handler'Access);
		LLU.Bind_Any (EP_R);
		if Ada.Command_Line.Argument_Count = 5 then
			Debug.Put_Line("NO hacemos protocolo de admisión pues no tenemos contactos iniciales ...");
			acept:=True;
		elsif Ada.Command_Line.Argument_Count = 7 or Ada.Command_Line.Argument_Count = 9 then
			
			Nb1Host:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(6));
			Nb1Port:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(7));
			Nb1IP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Nb1Host)));
			EP_Nb1:= LLU.Build(ASU.To_String(Nb1IP), Integer'Value(ASU.To_String(Nb1Port)));	
			Debug.Put_Line("Añadimos a neighbors " & ASU.To_String(Nb1IP) & ":" & ASU.To_String(Nb1Port));
			Ada.Text_IO.Put_Line(" ");
			--Zeug.Schneiden(EP_Nb1,EP_N);
			Zeit:= Ada.Calendar.Clock;
			Handlers.Neighbors.Put(Handlers.N_Map, EP_Nb1, Zeit, Success);
			if Ada.Command_Line.Argument_Count = 9 then		
				Nb2Host:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(8));
				Nb2Port:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(9));
				
				Nb2IP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Nb2Host)));
				
				EP_Nb2:= LLU.Build(ASU.To_String(Nb2IP), Integer'Value(ASU.To_String(Nb2Port)));
				Debug.Put_Line("Añadimos a neighbors " & ASU.To_String(Nb2IP) & ":" & ASU.To_String(Nb2Port));
				Ada.Text_IO.Put_Line(" ");
				--Zeug.Schneiden(EP_Nb2,EP_N);
				Zeit:= Ada.Calendar.Clock;
				Handlers.Neighbors.Put(Handlers.N_Map, EP_Nb2, Zeit, Success);
			end if;
			Zeug.Spitzname(Nick);
			Zeug.Hafen(EP_H);
			Debug.Put_Line("Iniciando Protocolo de Admision ... ");		
			Seq_N:=1;
			Debug.Put_Line("Añadimos a latest_messages " & ASU.To_String(IP) & ":" & ASU.To_String(Port) & Seq_N_T.Seq_N_Type'Image(Seq_N));
			Handlers.Latest_Msgs.Put(Handlers.M_Map, EP_H, Seq_N, Success);
			Debug.Put("FLOOD Init ", Pantalla.Amarillo);
			Zeug.Schneiden(EP_H, MyEP);
			Debug.Put_Line(ASU.TO_String(MyEP) & " " & ASU.To_String(MyEP) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N));
			
			Gehen_Initiale (nick, Seq_N);
			Ada.Text_IO.Put_Line(" ");
			Aufnehmen_Ablehnen (Bett, acept);
			if acept then
				Zeug.Schneiden(EP_H, MyEP);
				Debug.Put_Line("Añadimos a latest_msgs" & ASU.To_String(MyEP) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N));
				Handlers.Latest_Msgs.Put(Handlers.M_Map,EP_H, Seq_N, Success);
				Gehen_Konfirmieren(Seq_N);
				Debug.Put_Line("Fin del Protocolo de Admisión.");
			else
				Confirm_Sent:=False;
				Gehen_Werden(Confirm_Sent, Seq_N);				
			end if;
		end if;
	else
   	raise Usage_Error;   
   end if;
  
	if acept then
		Ada.Text_IO.Put_Line("Peer-Chat v1.0");
		Ada.Text_IO.Put_Line("==============");
		Ada.Text_IO.Put_Line(" ");
		Ada.Text_IO.Put_Line("Entramos en el chat con Nick: " & ASU.To_String(Nick));
		Ada.Text_IO.Put_Line(".h para help");
		Gehen_Schreiber(Text, Seq_N);
		Confirm_Sent:=True;
		Gehen_Werden(Confirm_Sent, Seq_N);
	end if; 
	LLU.Finalize;

exception
   when Usage_Error =>
      Ada.Text_IO.Put_Line ("Uso: ./peer_chat port nick min_delay max_delay fault_pct [[host port] [host port]]");
      LLU.Finalize;
    when Fault_Error=>
    	Ada.Text_IO.Put_Line("fault_pct debe ser entre 0 y 100");
    when More_Error=>
    	Ada.Text_IO.Put_Line("min_delay debe ser menor que max_delay");
   when Ex:others =>
      Debug.Put_Line ("Excepción imprevista: " &
                            Ada.Exceptions.Exception_Name(Ex) & " en: " &
                            Ada.Exceptions.Exception_Message(Ex), pantalla.rojo);
      LLU.Finalize;
end Chat_Peer;

