package body Retrans is

	procedure Free is new Ada.Unchecked_Deallocation(LLU.Buffer_Type, CM.Buffer_A_T);
	
	procedure Relay(Timer: Ada.Calendar.Time) is
		ValB: CM.Value_T;
		Mess: CM.Mess_Id_T;
		ValD: CM.Destinations_T;
		Success: Boolean;
		New_Timer: Ada.Calendar.Time;
		find: Boolean:= False;
	begin
		Insta.Sender_Buffering.Get(Insta.B_Map, Timer, ValB, Success);
		Mess := (ValB.EP_H_Creat, ValB.Seq_N);
		Insta.Sender_Dests.Get(Insta.D_Map, Mess, ValD, Success);
		if Success then
			for i in 1..10 loop
				if ValD(i).EP/=Zeug.Null_EP and ValD(i).Retries <10 then
					LLU.Send(ValD(i).EP,ValB.P_Buffer);
					New_Timer:= Ada.Calendar.Clock+2*Duration(Zeug.Max_Delay)/1000;
					Insta.Sender_Buffering.Delete(Insta.B_Map, Timer, Success);
					Timed_Handlers.Set_Timed_Handler(New_Timer, Relay'Access);
					ValD(i).Retries:=ValD(i).Retries+1;
					find:=True;
				end if;
			end loop;
			if find then
				Insta.Sender_Dests.Put(Insta.D_Map, Mess, ValD);
			else 
				Free(ValB.P_Buffer);
				Insta.Sender_Buffering.Delete(Insta.B_Map, Timer, Success);
				Insta.Sender_Dests.Delete(Insta.D_Map, Mess, Success);
			end if;
		end if;
	end Relay;

end Retrans;