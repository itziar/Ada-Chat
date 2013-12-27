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
with Maps_G;
with Maps_Protector_G;
with M_Debug;


package Menus is
	package CM renames Chat_Messages;
	use type CM.Message_Type;
	package LLU renames Lower_Layer_UDP;
	use type LLU.End_Point_Type;
	package ASU renames Ada.Strings.Unbounded;
	use type Seq_N_T.Seq_N_Type;
	package Handlers renames Chat_Handler;

	procedure Neighbors;
	procedure Messages;
	procedure Nickname;
	procedure Help;
end Menus;