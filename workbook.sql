/*Select queries*/
/*2.1 Select*/
select * from Employee;
select * from Employee where lastname='King';
select * from Employee where firstname='Andrew' and reportsto=NULL;

/*2.2 Order by */
select * from album order by title desc;
select firstname from customer order by city asc;

/* 2.3 Insert into */
insert into genre (genreid, name) values (26, 'Broadway');
insert into genre (genreid, name) values (27, 'Kitchen Music');

insert into employee (employeeid, firstname, lastname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
values (9, 'Daniel', 'Ocano', 'Junior Software Engineer', null, '02-FEB-1996', '01-JAN-2018', '5238 Paducah Road', 'College Park', 'MD', 'USA', '20740',
'+1 (786)-261-1843', '(786)-261-1843', 'dgcocano@gmail.com');

/* 2.4 Update */
update employee set firstname='Robert', lastname='Walter' where firstname='Aaron' and lastname='Mitchell';
update artist set name='CCR' where name='Creedence Clearwater Revival';

/* 2.5 Like */
select * from invoice where billingaddress like 'T%';

/* 2.6 Between */
select * from invoice where total between 15 and 50;
select * from employee where hiredate between '01-JUN-03' and '01-MAR-04';

/* 2.7 Delete */
alter table invoice drop constraint fk_invoicecustomerid;
alter table invoice add constraint fk_invoicecustomerid foreign key (customerid) references customer(customerid) on delete cascade;
alter table invoiceline drop constraint fk_invoicelineinvoiceid;
alter table invoiceline add constraint fk_invoicelineinvoiceid foreign key (invoiceid) references invoice(invoiceid) on delete cascade;
delete from customer where firstname='Aaron' and lastname='Mitchell';

/* 3.0 SQL functions */

/* 3.1 functions */
select length(name) from mediatype where mediatypeid=1;

/* 3.2 system defined aggregate functions */
CREATE OR REPLACE FUNCTION
AVG_INVOICE_TOTAL
RETURN NUMBER AS Z NUMBER;
BEGIN
SELECT AVG(TOTAL) INTO Z FROM INVOICE;
RETURN Z;
END;
/
DECLARE 
OU NUMBER;
BEGIN
OU:=AVG_INVOICE_TOTAL;
DBMS_OUTPUT.PUT_LINE('OUTPUT'||OU);
END;
/

select * from track where unitprice = (
select max(unitprice) from track);

/* 3.3 User Defined Functions */
CREATE OR REPLACE FUNCTION
AVG_UNITPRICE_INVOICELINE
RETURN NUMBER AS Z NUMBER;
BEGIN
select avg(unitprice) INTO Z from invoiceline;
RETURN Z;
END;
/
DECLARE 
OU NUMBER;
BEGIN
OU:=AVG_UNITPRICE_INVOICELINE;
DBMS_OUTPUT.PUT_LINE('OUTPUT'||OU);
END;
/

/* 4.1 Basic Stored Procedure */
CREATE OR REPLACE PROCEDURE 
GET_FIRST_AND_LAST_NAMES(S OUT SYS_REFCURSOR) AS
BEGIN
OPEN S FOR
SELECT FIRSTNAME, LASTNAME from employee;
END;
/

DECLARE 
S SYS_REFCURSOR;
FIRST_NAME EMPLOYEE.FIRSTNAME%TYPE;
LAST_NAME EMPLOYEE.LASTNAME%TYPE;
BEGIN
GET_FIRST_AND_LAST_NAMES(S);
LOOP
FETCH S INTO FIRST_NAME, LAST_NAME;
EXIT WHEN S%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(FIRST_NAME||'FIRST NAME'||LAST_NAME||'LAST_NAME');
END LOOP;
END;
/

/* 4.2 Stored Procedure Input Parameters */
CREATE OR REPLACE PROCEDURE 
SET_FIRST_AND_LAST_NAMES(targetname IN employee.firstname%TYPE, destname IN employee.firstname%TYPE) IS
BEGIN
UPDATE EMPLOYEE SET FIRSTNAME=destname WHERE FIRSTNAME=targetname;
END;
/

BEGIN
SET_FIRST_AND_LAST_NAMES('Andrew', 'Drew');
END;
/

/* 4.3 Stored procedure that returns the name and company of a customer */
CREATE OR REPLACE PROCEDURE
GET_MANAGER(targetname IN employee.EMPLOYEEID%TYPE, managername OUT employee.FIRSTNAME%TYPE) 
AS
BEGIN
SELECT EMPLOYEE.FIRSTNAME INTO MANAGERNAME FROM EMPLOYEE WHERE EMPLOYEE.EMPLOYEEID = (
SELECT EMPLOYEE.REPORTSTO FROM EMPLOYEE WHERE EMPLOYEE.EMPLOYEEID = TARGETNAME);
END;
/

DECLARE 
MANAGERNAME EMPLOYEE.FIRSTNAME%TYPE;
BEGIN
GET_MANAGER(8, MANAGERNAME);
DBMS_OUTPUT.PUT_LINE(MANAGERNAME);
END;
/

/* 5.0  Transactions */
CREATE OR REPLACE PROCEDURE
DELETE_INVOICE(TARGETINVOICEID IN invoice.invoiceid%TYPE) IS
BEGIN
DELETE FROM INVOICE WHERE INVOICE.INVOICEID = TARGETINVOICEID;
END;
/

CREATE OR REPLACE PROCEDURE 
INSERT_NEW_CUSTOMER(


/* 7.0 Joins */

/* 7.1 Inner */
Select firstname, lastname, invoiceid from customer inner join invoice on customer.customerid = invoice.customerid;
Select * from customer inner join invoice on customer.customerid = invoice.customerid;

/* 7.2 Outer joins */
Select customer.customerid, firstname, lastname, invoiceid, total from customer full outer join invoice on customer.customerid = invoice.customerid;
Select * from customer full outer join invoice on customer.customerid = invoice.customerid;

/* 7.3 Right join */
select artist.artistid, title from album right join artist on artist.artistid = album.artistid;
select *from album right join artist on artist.artistid = album.artistid;

/* 7.4 Cross join */
select * from album cross join artist order by artist.NAME;

/* 7.6 Massive join */
select * from customer c inner join invoice i 
on c.customerid = i.customerid
inner join employee e
on c.supportrepid = e.employeeid
inner join invoiceline il
on i.invoiceid = il.invoiceid
inner join track t
on il.trackid = t.trackid
inner join album a
on t.albumid = a.albumid
inner join artist ar
on a.artistid = ar.artistid
inner join mediatype mt
on t.mediatypeid = mt.mediatypeid
inner join genre g
on t.genreid = g.genreid
inner join playlisttrack plt
on t.trackid = plt.trackid
inner join playlist pl
on plt.playlistid = pl.playlistid;