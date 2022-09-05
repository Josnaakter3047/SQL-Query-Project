		

/*
	Project	Name  : Hotel Management And Reservation System
	Trainee Name  : Josna Akter Allo
	Trainee ID	  : 1266163
	Batch ID	  : ESAD-CS/PNTL-A/49/01
	DML file: Insert data And Execution file.

*/
Use HotelManagementSystem
Go

Select * From Customers
Go

				       /* (Insert Data Into Customers Table) */


Insert Into Customers Values
('James','Hoog','08300074321','Berlin','12209','Obere Str. 57','Germany','Christian','030-0076545','james@gmail.com',221500654),
('Paul','Adam','07401544329','Mannheim','','Forsterstr. 57','Germany','Islam','','paul@gmail.com',335214487),
('Brad','Davis','05458045346','Madrid','28023','C/ Araquil, 67','Spain','Christian','0621-08924','bred@gmail.com',871506354),
('Nail','Knite','07770749335','Marseille','13008','12, rue des Bouchers','France','Buddhist','','nail@gmail.com',95185239),
('Julian','Green','06664574351','London','','35 King George','UK','Buddhist','(604) 555-3745','julian@gmail.com',458745632),
('Adam','Smith','01935840031','Sao Paulo','05432-043','Av. dos Lusiadas, 23','Brazil','Christian','','adam@gmail.com',915555593),
('Philip','Cramer','01735840045','Brandenburg','14776','Maubelstr. 90','Germany','Buddhist','','philip@gmail.com',855509876)

Go

						   /* (Insert into Rooms) */

Insert Into Rooms(RoomType,RentOfRoom,ServiceCharge,ReservationID) 
Values('Single Room',1500.00,2000.00,NULL),
('Double Room',1500.00,2000.00,Null),
('Triple Room',2000.00,2000.00,Null),
('Twin Room',1500.00,2000.00,Null),
('Hollywood Twin Room',2000.00,2000.00,Null),
('Queen Room',3000.00,2000.00,Null),
('King Room',3000.00,2000.00,Null),
('Duplex Room',4000.00,2000.00,Null),
('Cabana Room',5000.00,2000.00,Null)
Go

Insert Into Rooms(RoomType,RentOfRoom,ServiceCharge,ReservationID) 
Values('Double Door Room',5000.00,2000.00,NULL),
('Double double Room',6000.00,2000.00,Null),
('Baby Room',7000.00,2000.00,Null),
('Single Twin Room',8000.00,2000.00,Null)

Select * from Rooms
Go


                        /* (Insert Into Reservation) */


Select * From Reservation

Insert Into Reservation(RoomNo,CustomerID,NumberOfGuest,ReservationDate,CheckInDate,CheckOutDate)
Values(110,1001,4,'2021-05-01','2021-05-02','2021-05-03'),
	(111,1002,2,'2021-05-02','2021-05-03','2021-05-04'),
	(112,1003,3,'2021-06-03','2021-06-04','2021-01-05'),
	(113,1003,3,'2021-06-04','2021-06-05','2021-06-06')
Go


Select * From Reservation
Go

									
					    /* (Insert into Employee Table) */

Insert Into Employee
Values('Jahid','Iqbal','Sales Representative','Mr.','1988-12-08','2000-05-01','Mirpur,10','Mirpur','1000','Bangladesh','01952416314'),
('Rafiq','Hossain','Sales Manager','Mr.','1978-12-08','2000-05-01','Mowchak,12 road','Mowchak','1206','Bangladesh','01766644314'),
('Imran','Khan','Vice President, Sales','Dr.','1977-12-08','2000-05-01','2 road,malibag','Malibag','1103','Bangladesh','01655566654'),
('Rifat','Hasan','Inside Sales Coordinator','Mr.','1969-12-08','2003-05-01','sactor 5,uttara','Uttara','1012','Bangladesh','01555516328'),
('Mahmud','Hasan','Sales Representative','Mr.','1982-12-08','2001-05-01','middle badda,road 3','Rampura','1001','Bangladesh','01399944415'),
('Sikandar','Boss','Sales Representative','Mr.','1983-12-08','2000-05-01','road 10,dhanmondi','Dhanmondi','1200','Bangladesh','01488899945'),
('Naeem','Hossain','Sales Representative','Mr.','1984-12-08','2005-05-01','komolapur area, road 10','Motijhil','1100','Bangladesh','01755599948')
Go
Select * from Employee
Go


					    /* (Insert Into Billing) */


Insert Into Billing
Values(1001,1500.00,2000.00,1000.00,.05,221500654,'2021-01-03',1),
(1002,1500.00,2000.00,1000.00,.05,335214487,'2021-01-03',2),
(1003,2000.00,2000.00,1000.00,.01,871506354,'2021-01-07',3),
(1004,1500.00,2000.00,1000.00,.02,95185239,'2021-01-08',4),
(1005,2000.00,2000.00,1000.00,.02,458745632,'2021-01-09',5)
Go
Select * From Billing
Go
					  ---**  insert into CustomersEmployee  ***--

Insert into CustomersEmployee Values
(1001,201,101,1),
(1002,202,102,2),
(1003,203,103,3),
(1004,204,104,4),
(1005,205,105,5),
(1006,201,106,9)
Go
Select * From CustomersEmployee
Go
	
									---Test View Table--

Select * From vCustomerTotalcharge
Go


						/* Join Query with Group by and RollUP */

Select m.RoomNo,m.RoomType,ce.customerId,SUM(b.TotalCharge) From Reservation r
Join CustomersEmployee ce ON r. CustomerID=ce.customerId
Join Rooms m ON ce.roomId=m.RoomNo
Join Billing b On r.ReservationNo=b.ReservationNo
Group BY  m.RoomNo, m.RoomType,ce.customerId With RollUP
Go

					/* Insert Data Into Customer Table
								   With Store Procedure          */


EXEC spInsertInCustomers 'Steel','John','34155555938','Portland','97219','89 Chiaroscuro Rd.','USA','Christian','','john@gmail.com',220056451
EXEC spInsertInCustomers 'Wilson','Fran','34155641937','Leipzig','04179','Heerstr. 22','Germany','Christian','(907) 555-2880','fran@gmail.com',440056474
EXEC spInsertInCustomers 'Bertrand','Marie','45155585936','Albuquerque','87110','2817 Milton Dr.','USA','Christian','','john@gmail.com',520056435
Go
Select * From Customers
Go

--Insert into billing--

Insert Into Billing Values(1006,5000.00,2000.00,5000.00,.05,915555593,'2021-01-09',9),
(1007,8000.00,2000.00,5000.00,.05,855509876,'2021-02-10',10),
(1008,7000.00,2000.00,5000.00,.05,220056451,'2021-06-09',11),
(1009,6000.00,2000.00,5000.00,.05,440056474,'2021-06-06',12)
Go



					      /* (Sub Query) ==--
					         (Which customer Not Reserve Any Room For This year) */

Select c.CustomerID,c.CusAccountNo,c.CusFirstName,c.CusLastName
From Reservation r
Right Join Customers c On r.CustomerID=c.CustomerID
Where c.CustomerID Not IN(Select CustomerID From Reservation)
Go


							/* (Sub Query)
							(Which Customer Reserve Room More Then ONE this year)*/


Select r.CustomerID,Count(c.CustomerID)'No of customer'
From Reservation r
Join Customers c ON r.CustomerID=c.CustomerID
Where c.CustomerID IN (Select CustomerID From Reservation)
Group By R.CustomerID
Having Count(c.CustomerID)>=2
Go

				
									/* Test ViewTable */


Select * From vCustomerTotalcharge
Go

						/** Test For InsertUpdateDelete Store Procedure  **/

EXEC spInsertUpdateDeleteEmployee @id=212, @fname=N'Immam',@lname= N'Hossain',@title=N'Sales Representative',
@titleofcourtesy= N'Mr.',@birth= N'1980-01-01',@hiredate= N'2010-01-01',@address= 'Dhanmondi 12',
@city=N'Dhaka',@postcode=N'1206',@country=N'Bangladesh',
@phone= '01966655548',@Query= N'insert'
Go


									/* Test Output Store Procedure */

Declare @reservationId Int
exec spGetReservation 108,1006,4,'2021-06-07','2021-06-08','2021-06-09',
@reservationId OUTPUT
Select @reservationId 'New id'
Go

									/* Store Procedure 
									   With input parameter */

EXEC spCustomerInput '1001'
Go
 
							


					/* Test Scalar function For RoomsTotalRent */

Select dbo.fnCalTotalRent (101)'Total Charge'
Go

						/* TEST Table Valued function */

Select * From fnTotalBillingOfMonth (2021,1)
Go

									/*  Test After Trigger 
									with rollback */

Update Billing
Set ReservationNo=5
Where BillingNo=1
Go


								/*  Test Insert Trigger */
Insert into Reservation(RoomNo,CustomerID,NumberOfGuest,ReservationDate,CheckInDate,CheckOutDate)
Values(105,1005,3,'2021-01-06','2021-01-07','2021-01-08')
Go
Insert into Reservation(RoomNo,CustomerID,NumberOfGuest,ReservationDate,CheckInDate,CheckOutDate)
Values(106,1006,3,'2021-01-07','2021-01-08','2021-01-09')
Go
Insert into Reservation(RoomNo,CustomerID,NumberOfGuest,ReservationDate,CheckInDate,CheckOutDate)
Values(107,1007,4,'2021-02-09','2021-02-09','2021-02-10')
Go

								/*test Instead of trigger 
										On View */

Insert Into vReservation Values(109,1007,2,'2021-06-04','2021-06-05','2021-06-06')
Go

								/*	Test Delete Trigger */

DELETE Reservation WHERE ReservationNo=12
GO


								/* CTE Creation */

With CTE_CustomersTotalBill
(CustomerID,CustomerFullName,EmployeeID,CusAccountNumber,TotalCharge)
AS
(
	Select b.CustomerId,(c.CusFirstName+' '+c.CusLastName),e.employeeId,b.CusAccountNo,b.TotalCharge From Customers c
	Join CustomersEmployee e ON c.CustomerID=e.CustomerID
	Join Billing b ON e.reservationId=b.ReservationNo

)
Select * From CTE_CustomersTotalBill
Go

							/* Case */
Select * From Rooms
Go

Select RoomType,
Case
	WHEN RoomType ='Cabana Room' THEN 'This room adjacent with swiming pool'
	WHEN RoomType ='Quad Room' THEN 'This room with four bed'
	WHEN RoomType ='Triple Room' THEN 'This room with three bed'
	WHEN RoomType ='Duplex Room' Then 'This room with 2 floor and luxurious room'
Else 'Simple Room'
End 'Room Type Defination'
From Rooms
Go
								---Update Rooms Table--
Update Rooms
Set ReservationID=4
Where RoomNo=104

						-- Test RaisError Trigger ---

Select * From Rooms
Insert Into Rooms Values('single room',5000.00,1500.00,Null)





 




