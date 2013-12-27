--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--


package body Menus is

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
	procedure Messages is
	begin
		Debug.Put_Line("                      Latest_Msgs", Pantalla.Rojo);
		Debug.Put_Line("                      --------------------", Pantalla.Rojo);
		Debug.Put("                     [", Pantalla.Rojo);
		Insta.Latest_Msgs.Print_Map(Insta.M_Map);
		Debug.Put_Line(" ]", Pantalla.Rojo);
	end Messages;

	--SHOW NICKNAME | EP_H |EP_R --
	procedure Nickname is
	MyEP			  : ASU.Unbounded_String;
	REP			  : ASU.Unbounded_String;
	begin
		Ada.Text_IO.Put_Line("muestra en pantalla nick | EP_H | EP_R");
		Zeug.Schneiden(Zeug.EP_H, MyEP);
		Zeug.Schneiden(Zeug.EP_H, REP);
		Debug.Put_Line("Nick: " & ASU.To_String(Zeug.Nick) & " | EP_H: " & ASU.To_String(MyEP) & " | EP_R: " & ASU.To_String(REP), Pantalla.Rojo);
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

end Menus;