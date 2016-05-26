Select Extract(Month From Pickup_Datetime) As Mnth
	 , ct.type
	 , Count(*) From Trips 
Left Join Cab_Types Ct On Trips.Cab_Type_Id = Ct.Id
group by 1,2
order by 1,2