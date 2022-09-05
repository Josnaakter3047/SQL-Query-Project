			
			--SQL PROJECT--

/*
	Project	Name  : Hotel Management And Reservation System
	Trainee Name  : Josna Akter Allo
	Trainee ID	  : 1266163
	Batch ID	  : ESAD-CS/PNTL-A/49/01
	DDL file      : All Table Creation

*/
                          
						  
						  /*  Create Database For
                              Hotel Management system  */

Create Database HotelManagementSystem
ON
(
	Name='Hotel_Data_1',
	Filename='F:\Practice LOG And DATAFile\Hotel_Data_1.mdf',
	Size=25mb,
	Maxsize=100mb,
	Filegrowth=5%
)
Log On
(
	Name='Hotel_Log_1',
	Filename='F:\Practice LOG And DATAFile\Hotel_Log_1.ldf',
	Size=10mb,
	Maxsize=50mb,
	Filegrowth=2%
)
Go

Use HotelManagementSystem
Go

					   /* Customer Table */


Create Table Customers
(
	CustomerID INT Identity(1001,1) Primary key,
	CusFirstName Varchar(50) Not Null,
	CusLastName Varchar(50) Not Null,
	PhonNo NChar(11) Null,
	City varchar(50) Null,
	PostalCode varchar(50) Null,
	[Address] varchar(50) Null,
	Country varchar(50) Not null,
	Religion varchar(50) Null,
	Fax varchar(50) Null,
	Email varchar(50) Not Null,
	CusAccountNo INT Unique Not Null
)
Go

Select * From Customers

						--- NONCLUSTERED Index Creation--- 

Create NONCLUSTERED Index IX_City ON Customers (City)
Go
Create NONCLUSTERED Index IX_CusLastName ON Customers(CusLastName)
Go
Create NONCLUSTERED Index IX_Country ON Customers(Country)
Go
		


Select * From Customers
Go


							/* Create Room Table */

Create Table Rooms
(	
	RoomNo INT Identity (101,1) Primary Key,
	RoomType varchar(50) Not Null,
	RentOfRoom Money Not Null,
	ServiceCharge MONEY Not null,
	ReservationID Int
		
)
Go
					--Add Constraint--
Alter Table Rooms
Add constraint DF_RoomService Default 2000.00 For ServiceCharge
Go

					-- Reservation Table--

Create Table Reservation
(
	ReservationNo Int Identity Primary Key,
	RoomNo INT References Rooms(RoomNo),
	CustomerID Int References Customers(CustomerID),
	NumberOfGuest INT Not Null,
	ReservationDate DateTime Default GETDATE(),
	CheckInDate DateTime,
	CheckOutDate DateTime
	
)
Go

						--Create Table Employee--

Create Table Employee
(
	EmpId Int Identity(201,1) Primary Key,
	EmpFirstName varchar(50) Not Null,
	EmpLastName varchar(50) Not Null,
	Title varchar(50) Not Null,
	TitleOfCourtesy varchar(50),
	DateOfBirth date,
	HireDate date,
	[address] varchar(50) Not Null,
	City varchar(50) not null,
	PostalCode Int Null,
	Country varchar(50) null,
	HomePhone varchar(50)
)
Go

									/*Billing Table */

Create Table Billing
(
	BillingNo Int Identity (1,1) Primary Key,
	CustomerId Int References Customers(CustomerID),
	RentCharge Money Not Null,
	ServiceCharge Money Not Null,
	OtherCharge Money Not null,
	DiscountCharge Float,
	CusAccountNo INT Not Null,
	paymentDate DateTime Not Null,
	ReservationNo Int References Reservation(ReservationNo),
	TotalCharge As (RentCharge+ServiceCharge+OtherCharge)+(RentCharge*DiscountCharge)

)
Go
Select * From Reservation
Go
select * From Rooms
Go
Select * From Customers
Go

					--nonclustered index in billing table--

Create NONCLUSTERED Index Ix_CusAccountNo ON Billing(CusAccountNo)
Go

Select * From Reservation
Go
							--- CustomersEmployee Table --
Create Table CustomersEmployee
(
	id int identity primary key,
	customerId int references Customers(CustomerID),
	employeeId int references Employee(EmpId),
	roomId int references Rooms(RoomNo),
	reservationId int references Reservation(ReservationNo)
)
Go

								/*Create View Table
								Find out Customers With TotalCharge */


Create View vCustomerTotalcharge
AS
Select Distinct r.CustomerID,c.CusFirstName,c.CusLastName,b.TotalCharge From Reservation r
Join Billing b On r.CustomerID=b.CustomerId
Join Customers c ON c.CusAccountNo=b.CusAccountNo
Go
Select * From Customers
Go

								---Create View on Reservation--

Create View vReservation
AS
Select RoomNo,CustomerID,NumberOfGuest,ReservationDate,CheckInDate,CheckOutDate From Reservation
Go


					---/** Create UpdateInsertDelete Store Procedure **/---

Create Procedure spInsertUpdateDeleteEmployee
--Optional parameter

@id Int=0,@fname varchar(50)=Null,@lname varchar(50)=Null,@title varchar(50)=Null,
@titleofcourtesy varchar(50)=Null,@birth Date=Null,@hiredate Date=Null,
@address varchar(50)=Null,@city Varchar(50)=Null,@postcode varchar(50)=Null,@country varchar(50)=Null,
@phone varchar(50)=Null,
@Query varchar(50)= N''
AS

Begin
	--insert query
	If (@Query= N'Insert')
	Begin
		Insert Into dbo.Employee
		(
			
			EmpFirstName,
			EmpLastName,
			Title, TitleOfCourtesy,
			DateOfBirth,HireDate,
			[address],City,PostalCode,
			Country,HomePhone
			
		)
		Values
		(
			@fname,
			@lname,
			@title,@titleofcourtesy,
			@birth,@hiredate,
			@address,@city,
			@postcode,@country,
			@phone
		)
	End
	--Update query
	if (@Query= N'Update')
		Begin
			Update dbo.Employee
			Set EmpFirstName=@fname, EmpLastName=@lname,
			Title=@title,TitleOfCourtesy=@titleofcourtesy,
			DateOfBirth=@birth,HireDate=@hiredate,
			[address]=@address,
			City=@city,PostalCode=@postcode,
			Country=@country,HomePhone=@phone
			Where EmpId=@id
		End
	--Delete query

If(@Query= N'Delete')
	Begin
		Delete From dbo.Employee
		Where EmpId=@id
	End
End
Go
-----Test
Select * From Employee
Go


					---  Create Store Procedure in Customer Table  ---

Create Proc spInsertInCustomers
								@CusFName varchar(50),
								@CusLName varchar(50),
								@phn nchar(11),
								@city varchar(50),
								@postalCode varchar(50),
								@address varchar(50),
								@country varchar(50),
								@religion varchar(50),
								@fax varchar(50),
								@email varchar(50),
								@accounNo Int
AS
Insert Into Customers(CusLastName,CusFirstName,PhonNo,City,PostalCode,Address,Country,Religion,Fax,Email,CusAccountNo)
Values(@CusLName,@CusFName,@phn,@city,@postalCode,@address,@country,@religion,@fax,@email,@accounNo)
Go

								/*
									 Store Procedure with input parameter
										For Customers Table	
								*/

Create Proc spCustomerInput
	@cusId int
	
	
AS
Begin
		Select CustomerID,Country,Email,CusAccountNo From Customers
		Where CustomerID=@cusId
End
Go

							/*
								Create Store Procedure 
								with Output parameter
								For Reservation Table	
							*/

Create Proc spGetReservation
								@roomNo INT,
								@cusId Int,
								@numofgest int,
								@resDate dateTime,
								@checkIndate DateTime,
								@outdate DateTime,
								@resID INT OUTPUT
AS
Insert Into Reservation(RoomNo,CustomerID,NumberOfGuest,ReservationDate,CheckInDate,CheckOutDate)
Values(@roomNo,@cusId,@numofgest,@resDate,@checkIndate,@outdate)
Select @resID=IDENT_CURRENT('Reservation')
Go


Select * From Reservation
Go
								/* Create scalar Function */

CREATE FUNCTION fnCalTotalRent
(@roomNo INT)
RETURNS Money
AS
BEGIN 
		DECLARE @TotalRent MONEY
		SELECT @TotalRent= RentOfRoom+ServiceCharge 
		FROM Rooms
		WHERE RoomNo=@roomNo
		RETURN @TotalRent
END
Go


									/* Multiple Table valued Function */

CREATE FUNCTION fnTotalBillingOfMonth
(@year INT, @month INT)
RETURNS TABLE
AS
RETURN
(
	Select SUM(RentCharge+ServiceCharge)'Total Rent Charge',
			Sum((RentCharge+ServiceCharge+OtherCharge)+(RentCharge*DiscountCharge))'Payable Charge'
			From Reservation r
			Join Billing b ON r.ReservationNo=b.ReservationNo
			Where Year(b.paymentDate)=@year And Month(b.paymentDate)=@month
)
Go

								
								/* Create Instead of trigger on view */


Create Trigger trVReservation
On vReservation
Instead of Insert
AS
Begin
	Insert Into Reservation(RoomNo,CustomerID,NumberOfGuest,ReservationDate,CheckInDate,CheckOutDate)
	Select RoomNo,CustomerID,NumberOfGuest,ReservationDate,CheckInDate,CheckOutDate From inserted
End
Go



									/*Create For Insert Trigger*/

Create Trigger trReservationInsert
ON Reservation
For Insert
AS
Begin
		Declare @resi Int,
				 @rid Int,
				@cusId Int,
				@numofgest varchar(50),
				@chkinDate DateTime,
				@chkOutDate DateTime
		Select @resi=ReservationNo,@rid=RoomNo,@cusId=CustomerID,@numofgest=NumberOfGuest,@chkinDate=CheckInDate,@chkOutDate=CheckOutDate From inserted
		
		Update Rooms
		Set ReservationID=@resi
		Where RoomNo=@rid
End
Go


					/* CREATE For After TRIGGER for UPDATE,DELETE 
						With Rollback transaction */

CREATE TRIGGER trUpdateDelete
ON Billing
AFTER UPDATE,DELETE
AS
BEGIN
		PRINT 'Trigger fired!!'
		ROLLBACK TRANSACTION
END
GO

									/** Create Delete Trigger **/

Create Trigger trReservationDelete
ON Reservation
For Insert
AS
Begin
		Declare @resi Int,
				 @rid Int,
				@cusId Int,
				@numofgest varchar(50),
				@chkinDate DateTime,
				@chkOutDate DateTime
		Select @resi=ReservationNo,@rid=RoomNo,@cusId=CustomerID,@numofgest=NumberOfGuest,@chkinDate=CheckInDate,@chkOutDate=CheckOutDate From inserted
		
		Update Rooms
		Set ReservationID=@resi
		Where RoomNo=@rid
End
Go

					/* Trigger with Raiserror */




Create Trigger trCheckRooms
On Rooms
Instead OF Insert
AS
BEGIN
	Declare 
			@rtype varchar(50),
			@rentRoom Money,
			@serviceCharge money,
			@resId Int
		
			Select @rtype=RoomType,@rentRoom=RentofRoom,@serviceCharge=ServiceCharge From inserted
			IF @serviceCharge>=2000
				Begin
					Insert Into Rooms
					Select RoomType,RentOfRoom,ServiceCharge,ReservationID From inserted
				End
			Else
				Begin
					Raiserror('Serivice Charge must be 2000',10,1)
				End

End
Go





























