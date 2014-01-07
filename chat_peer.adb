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
with Ada.Calendar;
with Insta;
with Messages;
with M_Debug;
with Timed_Handlers;
with Gnat.Ctrl_C;

procedure Chat_Peer is
	package CM renames Chat_Messages;
	use type CM.Message_Type;
	package LLU renames Lower_Layer_UDP;
	use type LLU.End_Point_Type;
	package ASU renames Ada.Strings.Unbounded;
	use type ASU.Unbounded_String;
	use type CM.Seq_N_T;
	package Handlers renames Chat_Handler;

	Usage_Error : exception;
	Host : ASU.Unbounded_String;
	Port : Integer;
	IP : ASU.Unbounded_String;
	EP_R : LLU.End_Point_Type;
	Seq_N : CM.Seq_N_T:=0;
	Nb1Host : ASU.Unbounded_String;
	Nb1Port : ASU.Unbounded_String;
	Nb1IP : ASU.Unbounded_String;
	EP_Nb1 : LLU.End_Point_Type;
	Nb2Host : ASU.Unbounded_String;
	Nb2Port : ASU.Unbounded_String;
	Nb2IP : ASU.Unbounded_String;
	EP_Nb2 : LLU.End_Point_Type;
	SHost : ASU.Unbounded_String;
	SPort : ASU.Unbounded_String;
	SIP : ASU.Unbounded_String;
	EP_S : LLU.End_Point_Type;
	Text : ASU.Unbounded_String;
	Expired : Boolean := False;
	Acept : Boolean:= False;
	Confirm_Sent : Boolean:= False;
	EP_N : ASU.Unbounded_String;
	Neighbour : ASU.Unbounded_String;
	MyEP : ASU.Unbounded_String;
	EPHA : ASU.Unbounded_String;
	REP : ASU.Unbounded_String;
	More_Error : exception;
	Fault_Error : exception;
	Bad_Port : exception;
	Argument : Integer;
	Bett: CM.Message_Type;
	supernode: Boolean :=False;
	Supernode_Error : exception;
	N: Integer;

	--PARA LOS MENUS
	--NEIGHBORS 
	procedure Neighbors is
	begin
		Debug.Put_Line("                      Neighbors", Pantalla.Rojo);
		Debug.Put_Line("                      --------------------", Pantalla.Rojo);
		Debug.Put("                     [", Pantalla.Rojo);
		Insta.Neighbors.Print_Map(Insta.N_Map);
		Debug.Put_Line(" ]", Pantalla.Rojo);
	end Neighbors;

	--LATEST MESSAGES--
	procedure L_Messages is
	begin
		Debug.Put_Line("                      Latest_Msgs", Pantalla.Rojo);
		Debug.Put_Line("                      --------------------", Pantalla.Rojo);
		Debug.Put("                     [", Pantalla.Rojo);
		Insta.Latest_Msgs.Print_Map(Insta.M_Map);
		Debug.Put_Line(" ]", Pantalla.Rojo);
	end L_Messages;

	--SENDER BUFFERING--
	procedure SB is
	begin
		Debug.Put_Line("                      Sender_Buffering", Pantalla.Rojo);
		Debug.Put_Line("                      --------------------", Pantalla.Rojo);
		Debug.Put("                     [", Pantalla.Rojo);
		Insta.Sender_Buffering.Print_Map(Insta.B_Map);
		Debug.Put_Line(" ]", Pantalla.Rojo);
	end SB;

	--SENDER DESTS--
	procedure SD is
	begin
		Debug.Put_Line("                      Sender_Dests", Pantalla.Rojo);
		Debug.Put_Line("                      --------------------", Pantalla.Rojo);
		Debug.Put("                     [", Pantalla.Rojo);
		Insta.Sender_Dests.Print_Map(Insta.D_Map);
		Debug.Put_Line(" ]", Pantalla.Rojo);
	end SD;

	--SHOW NICKNAME | EP_H |EP_R --
	procedure Nickname is
	MyEP			  : ASU.Unbounded_String;
	REP			  : ASU.Unbounded_String;
	begin
		Ada.Text_IO.Put_Line("muestra en pantalla nick | EP_H | EP_R");
		--CM.Schneiden(CM.EP_H, MyEP);
		--CM.Schneiden(EP_R, REP);
	--	Debug.Put_Line("Nick: " & ASU.To_String(CM.Nick) & " | EP_H: " & ASU.To_String(MyEP) & " | EP_R: " & ASU.To_String(REP), Pantalla.Rojo);
	end Nickname;
	
	

	--HELP--
	procedure Help is
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
	end Help; 
	--

	procedure Loop_Writer(Seq_N: in out CM.Seq_N_T) is
	begin
		loop
			Debug.Set_Status(True);
			if CM.prompt then
				Ada.Text_IO.Put(ASU.To_String(CM.Nick) & " >> ");
			end if;
			Text:= ASU.To_Unbounded_String(Ada.Text_IO.Get_Line);
			if ASU.To_String(Text) /= ".salir" then
				if ASU.To_String(Text)=".nb" or ASU.To_String(Text)=".neighbors" then
					Neighbors;
				elsif ASU.To_String(Text)=".lm" or ASU.To_String(Text)=".latest_msgs" then
					L_Messages;
				elsif ASU.To_String(Text)=".sb" or ASU.To_String(Text)=".sender_buffering" then
					SB;
				elsif ASU.To_String(Text)=".sd" or ASU.To_String(Text)=".sender_dests" then
					SD;
				elsif ASU.To_String(Text)=".debug" then
					CM.Information(CM.Purge);
				elsif ASU.To_String(Text)=".wai" or ASU.To_String(Text)=".whoami" then
					Nickname;
				elsif ASU.To_String(Text)=".prompt" then
					CM.Name(CM.Prompt);
				elsif ASU.To_String(Text)=".h" or ASU.To_String(Text)=".help" then
					Help;
				elsif ASU.To_String(Text)=".t" or ASU.To_String(Text)=".topology" then
					Ada.Text_IO.Put_Line("Calculando la topologia, espere por favor");
					M_Debug.Topology(CM.EP_H);
					Messages.Send_Topology(CM.EP_H, CM.EP_H);
				else
					Seq_N:=Seq_N+1;
					M_Debug.New_Message(CM.EP_H, Seq_N);
					Bett:=CM.Writer;
					Messages.Send(Bett, CM.EP_H, Seq_N, CM.EP_H, EP_R, CM.Nick, Text, Confirm_Sent, CM.EP_H);
				end if;
			end if;
		exit when ASU.To_String(Text)=".salir";
		end loop;
	end Loop_Writer;

--CUERPO DEL PROGRAMA PRINCIPAL
begin
	Debug.Set_Status(CM.Purge);
	Argument:= Ada.Command_Line.Argument_Count;
	if Argument<5 then
		raise Usage_Error;
	end if;
	if (Argument /= 5  and Argument /= 7 and Argument/=8 and Argument /= 9 and Argument/=10 and Argument/=12) then
		raise Usage_Error;   
	end if;	
	Gnat.Ctrl_C.Install_Handler(Messages.Manejador'Access);
	Port:= Integer'Value(Ada.Command_Line.Argument(1));
	CM.Min_Delay:=Integer'Value(Ada.Command_Line.Argument(3));
	CM.Max_Delay:=Integer'Value(Ada.Command_Line.Argument(4));
	CM.Fault_Pct:=Integer'Value(Ada.Command_Line.Argument(5));
	if CM.Min_Delay>CM.Max_Delay then
		raise More_Error;
	end if;
	if (CM.Fault_Pct>100) or (CM.Fault_Pct<0) then
		raise Fault_Error;
	end if;   
	if Port < 1024 or Port > 1_000_000 then
		raise Bad_Port;
	end if;
	
	Host:= ASU.To_Unbounded_String(LLU.Get_Host_Name);
	IP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Host)));
	CM.Nick:=ASU.To_Unbounded_String(Ada.Command_Line.Argument(2));
	CM.EP_H:=LLU.Build (ASU.To_String(IP), Port);
	LLU.Bind(CM.EP_H, Handlers.EP_Handler'Access);
	LLU.Bind_Any(EP_R);
	--Para la simulacion de perdidas de paquetes
	--LLU.Set_Random_Propagation_Delay(CM.Min_Delay, CM.Max_Delay);
	--LLU.Set_Faults_Percent(CM.Fault_Pct);
		
	if Argument = 5 then
		Debug.Put_Line("NO hacemos protocolo de admisión pues no tenemos contactos iniciales ...");
		acept:=True;
	end if;
	if Argument = 7 or Argument=10  then
		Nb1Host:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(6));
		Nb1Port:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(7));
		Nb1IP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Nb1Host)));
		EP_Nb1:= LLU.Build(ASU.To_String(Nb1IP), Integer'Value(ASU.To_String(Nb1Port)));	
		M_Debug.New_Neighbour(EP_Nb1);			

	end if;
	if Argument = 9 or Argument=12 then		
		Nb1Host:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(6));
		Nb1Port:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(7));
		Nb1IP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Nb1Host)));
		EP_Nb1:= LLU.Build(ASU.To_String(Nb1IP), Integer'Value(ASU.To_String(Nb1Port)));			
		Nb2Host:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(8));
		Nb2Port:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(9));
		Nb2IP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Nb2Host)));
		EP_Nb2:= LLU.Build(ASU.To_String(Nb2IP), Integer'Value(ASU.To_String(Nb2Port)));
		M_Debug.New_Neighbour(EP_Nb1);
		M_Debug.New_Neighbour(EP_Nb2);			
	end if;
	--SUPERNODO
	if Argument=8 then --puede ser supernodo
		if Ada.Command_Line.Argument(6)="-s" or Ada.Command_Line.Argument(6)="-S" then --es supernodo
			supernode:=True;
			SHost:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(7));
			SPort:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(8));
			SIP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(SHost)));
			EP_S:= LLU.Build(ASU.To_String(SIP), Integer'Value(ASU.To_String(SPort)));
		else
			raise Supernode_Error;
		end if;
	elsif Argument=10 then --puede ser supernodo
		if Ada.Command_Line.Argument(8)="-s" or Ada.Command_Line.Argument(8)="-S" then --es supernodo
			supernode:=True;
			SHost:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(9));
			SPort:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(10));
			SIP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(SHost)));
			EP_S:= LLU.Build(ASU.To_String(SIP), Integer'Value(ASU.To_String(SPort)));
		else
			raise Supernode_Error;
		end if;
	elsif Argument=12 then --puede ser supernodo
		if Ada.Command_Line.Argument(10)="-s" or Ada.Command_Line.Argument(10)="-S" then --es supernodo
			supernode:=True;
			SHost:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(11));
			SPort:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(12));
			SIP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(SHost)));
			EP_S:= LLU.Build(ASU.To_String(SIP), Integer'Value(ASU.To_String(SPort)));
		else
			raise Supernode_Error;
		end if;
	end if;

	if supernode then
		Ada.Text_IO.Put_Line("Numero de vecinos?");
		N:= Integer'Value(Ada.Text_IO.Get_Line);
		Messages.Send_Supernode(CM.EP_H, EP_R, EP_S, N);
		Messages.Receive_Supernode(EP_R);
		M_Debug.New_Neighbour(EP_S);
	end if;
	--	
	if Argument=7 or Argument=8 or Argument=9 or Argument=10 or Argument=12 then
		Debug.Put_Line("Iniciando Protocolo de Admision ... ");		
		Seq_N:=1;
		M_Debug.New_Message(CM.EP_H, Seq_N);
		Bett:=CM.Init;
		Messages.Send(Bett, CM.EP_H, Seq_N, CM.EP_H, EP_R, CM.Nick, Text, Confirm_Sent, CM.EP_H);
		Ada.Text_IO.Put_Line(" ");
		Messages.Receive_Reject(EP_R, acept);
		if acept then
			Seq_N:=Seq_N+1;
			M_Debug.New_Message(CM.EP_H, Seq_N);
			Bett:=CM.Confirm;
			Messages.Send(Bett, CM.EP_H, Seq_N, CM.EP_H, EP_R, CM.Nick, Text, Confirm_Sent, CM.EP_H);
			Debug.Put_Line("Fin del Protocolo de Admisión.");
		else
			Confirm_Sent:=False;
			Seq_N:=Seq_N+1;
			Bett:=CM.Logout;
			Messages.Send(Bett, CM.EP_H, Seq_N, CM.EP_H, EP_R, CM.Nick, Text, Confirm_Sent, CM.EP_H);
		end if;
	end if;
	
	if acept then
		M_Debug.Initial;
		Loop_Writer(Seq_N);
		Confirm_Sent:=True;
		Seq_N:= Seq_N+1;
		Bett:=CM.Logout;
		Messages.Send(Bett, CM.EP_H, Seq_N, CM.EP_H, EP_R, CM.Nick, Text, Confirm_Sent, CM.EP_H);
	end if; 
	delay Duration(10*CM.Max_Delay/1000);
	LLU.Finalize;
	Timed_Handlers.Finalize;

exception
	when Usage_Error =>
		Debug.Put_Line ("Uso: ./chat_peer port nick min_delay max_delay fault_pct [[host port] [host port]]", Pantalla.Rojo);
		LLU.Finalize;
		Timed_Handlers.Finalize;
	when Supernode_Error =>
		Debug.Put_Line ("Uso: ./chat_peer port nick min_delay max_delay fault_pct [-s host port] [host port] [-s host port] [host port] [-s host port]", Pantalla.Rojo);
		LLU.Finalize;
		Timed_Handlers.Finalize;
	when Fault_Error=>
		Debug.Put_Line("fault_pct debe ser entre 0 y 100", Pantalla.Rojo);
		LLU.Finalize;
		Timed_Handlers.Finalize;
	when More_Error=>
		Debug.Put_Line("min_delay debe ser menor que max_delay", Pantalla.Rojo);
		LLU.Finalize;
		Timed_Handlers.Finalize;
	when Bad_Port =>
		Debug.Put_Line ("Puerto incorrecto: el rango comprendido es 1024-1.000.000", Pantalla.Rojo);
		LLU.Finalize;
		Timed_Handlers.Finalize;
	when Program_Error=>
		Confirm_Sent:=True;
		Bett:=Cm.Logout;
		Seq_N:=Seq_N+1;
		Messages.Send(Bett, CM.EP_H, Seq_N, CM.EP_H, EP_R, CM.Nick, Text, Confirm_Sent, CM.EP_H);
		delay Duration((10*CM.Max_Delay)/1000);
		LLU.Finalize;
		Timed_Handlers.Finalize;
	when Ex:others =>
		Debug.Put_Line ("Excepción imprevista: " &
						Ada.Exceptions.Exception_Name(Ex) & " en: " &
						Ada.Exceptions.Exception_Message(Ex), Pantalla.Rojo);
		LLU.Finalize;
		Timed_Handlers.Finalize;

end Chat_Peer;

