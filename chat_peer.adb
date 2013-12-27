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
with Insta;
with Messages;
with M_Debug;

procedure Chat_Peer is
	package CM renames Chat_Messages;
	use type CM.Message_Type;
   package LLU renames Lower_Layer_UDP;
   use type LLU.End_Point_Type;
   package ASU renames Ada.Strings.Unbounded;
	use type Seq_N_T.Seq_N_Type;
	package Handlers renames Chat_Handler;

   Usage_Error   : exception;
   Host			  : ASU.Unbounded_String;
	Port			  : ASU.Unbounded_String;
	IP				  : ASU.Unbounded_String;
	EP_H			  : LLU.End_Point_Type;
   EP_R			  : LLU.End_Point_Type;
   EP_H_Creat	  : LLU.End_Point_Type;
   EP_H_Rsnd	  : LLU.End_Point_Type;
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
   Expired		  : Boolean := False;
   Acept			  : Boolean:= True; --CAMBIARLO A FALSE CUANDO TERMINE DE ORGANIZAR
   Confirm_Sent  : Boolean;
	EP_N			  : ASU.Unbounded_String;
	Neighbour	  : ASU.Unbounded_String;
	MyEP			  : ASU.Unbounded_String;
	EPHA			  : ASU.Unbounded_String;
	REP			  : ASU.Unbounded_String;
	More_Error: exception;
	Fault_Error: exception;
	Bad_Port: exception;
	Argument: Integer;

--CUERPO DEL PROGRAMA PRINCIPAL
begin
	Debug.Set_Status(Handlers.Purge);
	Argument:= Ada.Command_Line.Argument_Count;
	if (Argument /= 5 and Argument /= 7 and Argument /= 9) then
		raise Usage_Error;   
	end if;	
	if Zeug.min_delay>Zeug.max_delay then
		raise More_Error;
	end if;
	if (Zeug.fault_pct>100) or (Zeug.fault_pct<0) then
		raise Fault_Error;
	end if;   
	if Zeug.Port < 1024 or Zeug.Port > 1_000_000 then
		raise Bad_Port;
	end if;
	Zeug.Hafen(EP_H);
	Zeug.Spitzname(Nick);		
	LLU.Bind(EP_H, Handlers.EP_Handler'Access);
	LLU.Bind_Any (EP_R);
	--Para la simulacion de perdidas de paquetes
	--LLU.Set_Faults_Percent(Zeug.Fault_Pct);
	--LLU.Set_Random_Propagation_Delay(Zeug.Min_Delay, Zeug.Max_Delay);
		
	if Argument = 5 then
		Debug.Put_Line("NO hacemos protocolo de admisión pues no tenemos contactos iniciales ...");
		acept:=True;
	end if;
	if Argument = 7 then
		Nb1Host:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(6));
		Nb1Port:= ASU.To_Unbounded_String(Ada.Command_Line.Argument(7));
		Nb1IP:= ASU.To_Unbounded_String(LLU.To_IP(ASU.To_String(Nb1Host)));
		EP_Nb1:= LLU.Build(ASU.To_String(Nb1IP), Integer'Value(ASU.To_String(Nb1Port)));	
		M_Debug.New_Neighbour(EP_Nb1);			

	end if;
	if Ada.Command_Line.Argument_Count = 9 then		
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
	if Argument=7 or Argument=9 then
		Debug.Put_Line("Iniciando Protocolo de Admision ... ");		
		Seq_N:=1;
		M_Debug.New_Message(EP_H, Seq_N);
		Debug.Put("FLOOD Init ", Pantalla.Amarillo);
		Zeug.Schneiden(EP_H, MyEP);
		Debug.Put_Line(ASU.TO_String(MyEP) & " " & ASU.To_String(MyEP) & " " & Seq_N_T.Seq_N_Type'Image(Seq_N));
		Messages.Send_Init (EP_H, Seq_N, EP_H, EP_R, Zeug.Nick);
		Ada.Text_IO.Put_Line(" ");
		Messages.Receive_Reject (EP_R, acept);
		if acept then
			M_Debug.New_Message(EP_H, Seq_N);
			Messages.Send_Confirm(EP_H,Seq_N,EP_H, Zeug.Nick);
			Debug.Put_Line("Fin del Protocolo de Admisión.");
		else
			Confirm_Sent:=False;
			Messages.Send_Logout(EP_H, Seq_N, EP_H, Zeug.Nick, Confirm_Sent);			
		end if;
	end if;

	if acept then
		Ada.Text_IO.Put_Line("Peer-Chat v1.0");
		Ada.Text_IO.Put_Line("==============");
		Ada.Text_IO.Put_Line(" ");
		Ada.Text_IO.Put_Line("Entramos en el chat con Nick: " & ASU.To_String(Nick));
		Ada.Text_IO.Put_Line(".h para help");
		Messages.Send_Writer(EP_H, Seq_N, EP_H, Zeug.Nick);
		Confirm_Sent:=True;
		Messages.Send_Logout(EP_H, Seq_N, EP_H, Zeug.Nick, Confirm_Sent);
	end if; 
	LLU.Finalize;

exception
	when Usage_Error =>
		Ada.Text_IO.Put_Line ("Uso: ./chat_peer port nick min_delay max_delay fault_pct [[host port] [host port]]");
		LLU.Finalize;
	when Fault_Error=>
		Ada.Text_IO.Put_Line("fault_pct debe ser entre 0 y 100");
		LLU.Finalize;
	when More_Error=>
		Ada.Text_IO.Put_Line("min_delay debe ser menor que max_delay");
		LLU.Finalize;
	when Bad_Port =>
		Ada.Text_IO.Put_Line ("Puerto incorrecto: el rango comprendido es 1024-1.000.000");
		LLU.Finalize;
	when Ex:others =>
		Debug.Put_Line ("Excepción imprevista: " &
						Ada.Exceptions.Exception_Name(Ex) & " en: " &
						Ada.Exceptions.Exception_Message(Ex), pantalla.rojo);
		LLU.Finalize;

end Chat_Peer;

