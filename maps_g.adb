--
--ITZIAR POLO MARTINEZ
--TECNOLOGIAS
--


with Ada.Text_IO;
with Ada.Unchecked_Deallocation;
with Lower_Layer_UDP;
with Debug;
with Pantalla;

package body Maps_G is
	 package LLU renames Lower_Layer_UDP;
   use Lower_Layer_UDP;
   procedure Free is new Ada.Unchecked_Deallocation (Cell, Cell_A);


   procedure Get (M       : Map;
                  Key     : in  Key_Type;
                  Value   : out Value_Type;
                  Success : out Boolean) is
      P_Aux : Cell_A;
   begin
      P_Aux := M.P_First;
      Success := False;
      while not Success and P_Aux /= null Loop
         if P_Aux.Key = Key then
            Value := P_Aux.Value;
            Success := True;
         end if;
         P_Aux := P_Aux.Next;
      end loop;
   end Get;


   procedure Put (M     : in out Map;
                  Key   : Key_Type;
                  Value : Value_Type;
                  Success: out Boolean) is
      P_Aux : Cell_A;
      Found : Boolean:= False;
      Neu : Cell_A := new Cell'(Key,Value,null,null);
   begin
      -- Si ya existe Key, cambiamos su Value
      P_Aux := M.P_First;
      Success := False;
      while not Found and P_Aux /= null loop
         if P_Aux.Key = Key then
            P_Aux.Value := Value;
            Found := True;
         end if;
         P_Aux := P_Aux.Next;
      end loop;
			
      -- Si no hemos encontrado Key añadimos al principio
      if not Found  and M.Length < Max_length then
 			P_Aux:= Neu;
         if M.P_First= null then 
  			   M.P_First:= P_Aux; 
  			   M.P_Last:= P_Aux;    			   
			else 
  				M.P_First.Prev:= P_Aux; 
  			   P_Aux.Next:= M.P_First;
            M.P_First:= P_Aux; 
			end if;
			M.Length := M.Length + 1;
         Success:= True;       
      end if;
   end Put;

   procedure Delete (M      : in out Map;
                     Key     : in  Key_Type;
                     Success : out Boolean) is
      P_Aux: Cell_A;
   begin
      Success := False;
      P_Aux  := M.P_First;
      if M.Length=1 then
         M.P_First:=null;
         M.P_Last:= M.P_First;
         Success:=True;
      elsif P_Aux.Key=Key then
         M.P_First:=M.P_First.Next;
         M.P_First.Prev:=null;
         Success:=True;
      else
         P_Aux:=P_Aux.Next;
         while P_Aux/= null and then P_Aux.Key/=Key  loop
            P_Aux:=P_Aux.Next;
         end loop;
         if P_Aux=M.P_Last then
            M.P_Last:=P_Aux.Prev;
            M.P_Last.Next:=null;
         else
            P_Aux.Prev.Next:=P_Aux.Next;
            P_Aux.Next.Prev:=P_Aux.Prev;
         end if;
         Success:=True;
      end if;
      if Success then
         Free(P_Aux);
         M.Length:=M.Length-1;
      end if;
   end Delete;
 
	function Get_Keys (M : Map) return Keys_Array_Type is
		P_Aux: Cell_A;
		i: integer := 1;
		Key_Array: Keys_Array_Type;
	begin
		P_Aux:=M.P_First;
		while P_Aux /= null loop 
			Key_Array(i):=P_Aux.Key;
			P_Aux:=P_Aux.Next;			
			i:=i+1;
		end loop;
		return Key_Array;
	end;
	
	function Get_Values (M : Map) return Values_Array_Type is
	P_Aux: Cell_A;
	i: integer:=1;
	Value_Array: Values_Array_Type;
	begin
		while P_Aux /= null loop
			Value_Array(i):=P_Aux.Value;
			P_Aux:=P_Aux.Next;
         i:=i+1;
		end loop;
		return Value_Array;
	end;

   function Map_Length (M : Map) return Natural is
   begin
      return M.Length;
   end Map_Length;

   procedure Print_Map (M : Map) is
      P_Aux : Cell_A;
   begin
      P_Aux := M.P_First;
      while P_Aux /= null loop
         Debug.Put_Line(Key_To_String(P_Aux.Key) & " " & Value_To_String(P_Aux.Value), Pantalla.Rojo);
         P_Aux := P_Aux.Next;
      end loop;
   end Print_Map;

end Maps_G;
