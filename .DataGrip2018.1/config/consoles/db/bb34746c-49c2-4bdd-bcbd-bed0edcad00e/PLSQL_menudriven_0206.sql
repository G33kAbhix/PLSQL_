
-- MENU DRIVEN PROGRAM <ABHISHEK MONDAL> [12001018036] 31-05-2020-
SET SERVEROUTPUT ON
-- PROMPT TO PRINT INTERACTIVE DATA ON SQL CONSOLE
  PROMPT _______________________________________________________________
  PROMPT |- 1. List names of all employees who work for Indian bank
  PROMPT |- 2. List names of managers and with cities and the company names where they work
  PROMPT |- 3. List names of employees who earn more than every employee of united bank
  PROMPT |- 4. Find company name with largest payroll
  PROMPT |- 5. List names of all employees and their cities of residence who work in state bank
  PROMPT |- 6. Find employees of state bank of burdwan who earn more than Rs. 30000
  PROMPT |- 7. Find names of employees who live in the same city as the company in which they work
  PROMPT |- 8. Find names of employees who live in the same city as do their manager
  PROMPT _______________________________________________________________
  ACCEPT ch NUMBER PROMPT '|-    ENTER YOUR CHOICE: ';
-- ACCEPT TO GET USER INPUT FROM INTERACTIVE SQL CONSOLE
DECLARE
  choice NUMBER(1);
-- a) List the names of all employees who work for Indian bank.
  CURSOR cur_empname IS SELECT e_name EMPLOYEE_NAME
      FROM works
          WHERE cmp_name = 'Indian bank';

-- b) List the names of managers and with cities and the company names where they work.
  CURSOR cur_mgrname IS SELECT  manager.mng_name MANAGER_NAME , works.city CITY , works.cmp_name COMPANY_NAME
      FROM  manager, works
          WHERE works.e_name = manager.mng_name
      GROUP BY (manager.mng_name, works.city, works.cmp_name)
  ORDER BY (manager.mng_name);

-- c) List the names of employees who earn more than every employee of united bank.
  CURSOR cur_empsal IS SELECT e.e_name EMPLOYEE_NAME
      FROM employee1 e, works w
          WHERE e.e_name = w.e_name AND
              w.cmp_name <> 'united bank' AND
          e.salary> ( SELECT MAX(e.salary)
              FROM employee1 e, works w
                  WHERE e.e_name = w.e_name AND
              w.cmp_name='united bank');

-- d) Find the company name with largest payroll.
  CURSOR cur_maxpay IS SELECT w.cmp_name COMPANY_NAME
      FROM employee1 e, works w
          WHERE e.e_name=w.e_name AND
      e.salary = (SELECT MAX(salary) FROM employee1);

-- e) List the names of all employees and their cities of residence who work in state bank.
  CURSOR cur_emplist IS SELECT e.e_name EMPLOYEE_NAME ,  e.city CITY
      FROM employee1 e, works w
          WHERE e.e_name = w.e_name AND
      w.cmp_name = 'state bank';
-- f) Find the employees of state bank of burdwan who earn more than Rs. 30000/-.
  CURSOR cur_empsal30 IS SELECT e.e_name EMPLOYEE_NAME
      FROM employee1 e, works w
          WHERE e.e_name = w.e_name AND
        w.cmp_name='state bank' AND
    w.city = 'Burdwan' AND
          e.salary>30000;
-- g) Find the names of employees who live in the same city as the company in which they work.
  CURSOR cur_empcity IS SELECT e.e_name EMPLOYEE_NAME
      FROM employee1 e, works w, company c
    WHERE e.e_name = w.e_name AND
      e.city = w.city AND
        w.cmp_name = c.cmp_name;
-- h) Find the names of employees who live in the same city as do their manager.
  CURSOR cur_empmgrcity IS SELECT e1.e_name AS EMPLOYEE_NAME
      FROM employee1 e1, employee1 e2, manager m
          WHERE e1.e_name = m.e_name AND
              e2.e_name = m.mng_name AND
          e1.city = e2.city;
  BEGIN
  choice:=&ch;

  CASE
  WHEN choice=1 THEN
    FOR empname IN cur_empname
      LOOP
    DBMS_OUTPUT.PUT_LINE('_____________ ');
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME ');
    DBMS_OUTPUT.PUT_LINE('------------- ');
    DBMS_OUTPUT.PUT_LINE(empname.EMPLOYEE_NAME );
  END LOOP;

  WHEN choice=2 THEN
      FOR mgr IN cur_mgrname
        LOOP
	  DBMS_OUTPUT.PUT_LINE('________________  _______________  ___________________');
    DBMS_OUTPUT.PUT_LINE('MANAGER NAME        CITY              COMPANY NAME');
	  DBMS_OUTPUT.PUT_LINE('----------------  --------------- --------------------');
	  DBMS_OUTPUT.PUT_LINE(mgr.MANAGER_NAME||'      '||mgr.CITY||'      '||mgr.COMPANY_NAME);
        END LOOP;

  WHEN choice=3 THEN
      DBMS_OUTPUT.PUT_LINE('____________  ');
      DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME   ');
      DBMS_OUTPUT.PUT_LINE('____________  ');
        FOR empsal IN cur_empsal
          LOOP
            DBMS_OUTPUT.PUT_LINE(empsal.EMPLOYEE_NAME);
          END loop;

  WHEN choice=4 THEN
      DBMS_OUTPUT.PUT_LINE('______________');
      DBMS_OUTPUT.PUT_LINE('COMPANY NAME');
      DBMS_OUTPUT.PUT_LINE('______________');
      FOR cmpname IN cur_maxpay
        LOOP
        DBMS_OUTPUT.PUT_LINE(cmpname.COMPANY_NAME);
      END LOOP ;
  WHEN choice=5 THEN
      FOR emp IN cur_emplist
        LOOP
      DBMS_OUTPUT.PUT_LINE('______________    __________  ');
      DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME      CITY  ');
      DBMS_OUTPUT.PUT_LINE('--------------    ----------  ');
      DBMS_OUTPUT.PUT_LINE(emp.EMPLOYEE_NAME||'     '||emp.CITY);
      END LOOP;

  WHEN choice=6 THEN
      DBMS_OUTPUT.PUT_LINE('_____________ ');
      DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME ');
      DBMS_OUTPUT.PUT_LINE('------------- ');
        FOR emp IN cur_empsal30
        LOOP
            DBMS_OUTPUT.PUT_LINE(emp.EMPLOYEE_NAME);
        END LOOP;

  WHEN choice=7 THEN
      DBMS_OUTPUT.PUT_LINE('_____________ ');
      DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME ');
      DBMS_OUTPUT.PUT_LINE('------------- ');
        FOR empcity IN cur_empcity
        LOOP
            DBMS_OUTPUT.PUT_LINE(empcity.EMPLOYEE_NAME);
        END LOOP;

    WHEN choice=8 THEN
      DBMS_OUTPUT.PUT_LINE('__________________ ');
      DBMS_OUTPUT.PUT_LINE('EMPLOYEE NAME ');
      DBMS_OUTPUT.PUT_LINE('------------------ ');
    FOR empmgrcity IN cur_empmgrcity
      LOOP
        DBMS_OUTPUT.PUT_LINE(empmgrcity.EMPLOYEE_NAME);
    END LOOP;

    ELSE
          DBMS_OUTPUT.PUT_LINE('WRONG INPUT');
  END CASE;
END;
/



/** ---------------------------

CREATE TABLE company (
  cmp_name VARCHAR2(50),
  city     varchar2(20),
  PRIMARY KEY (cmp_name)
);
CREATE TABLE employee1 (
  e_no   NUMBER(6),
  e_name VARCHAR2(30) NOT NULL,
  street VARCHAR2(20),
  city   VARCHAR2(20),
  salary NUMBER(10, 2)
);
CREATE TABLE manager (
  e_name   VARCHAR2(30),
  mng_name VARCHAR2(30)
);
CREATE TABLE works (
  e_name   VARCHAR2(30),
  cmp_name VARCHAR2(50),
  street   VARCHAR2(20),
  city     VARCHAR2(20)
);

INSERT INTO company VALUES ('Indian bank', 'Kolkata');
INSERT INTO company VALUES ('united bank', 'Durgapur');
INSERT INTO company VALUES ('state bank', 'Burdwan');

INSERT INTO employee1 VALUES (10001, 'AAA', 'DM Road', 'Kolkata', 10000);
INSERT INTO employee1 VALUES (10002, 'BBB', 'PL Road', 'Kolkata', 11000);
INSERT INTO employee1 VALUES (10005, 'CCC', 'LK Road', 'Durgapur', 15000);
INSERT INTO employee1 VALUES (10006, 'GGGG', 'EM Road', 'Delhi', 9000);
INSERT INTO employee1 VALUES (10007, 'DDD', 'KL', 'Durgapur', 6000);
INSERT INTO employee1 VALUES (10009, 'FFF', 'LP', 'Delhi', 14000);
INSERT INTO employee1 VALUES (10010, 'HHH', 'JJP', 'Kolkata', 30500);
INSERT INTO employee1 VALUES (10011, 'IIII', 'JJP', 'Kolkata', 14200);

INSERT INTO manager VALUES ('AAA', 'BBB');
INSERT INTO manager VALUES ('GGGG', 'CCC');
INSERT INTO manager VALUES ('DDD', 'CCC');
INSERT INTO manager VALUES ('FFF', 'CCC');
INSERT INTO manager VALUES ('IIII', 'HHH');

INSERT INTO works VALUES ('AAA', 'Indian bank', 'Palo Alto', 'Kolkata');
INSERT INTO works VALUES ('BBB', 'Indian bank', 'Palo Alto', 'Kolkata');
INSERT INTO works VALUES ('CCC', 'united bank', 'City Palace', 'Durgapur');
INSERT INTO works VALUES ('GGGG', 'united bank', 'City Palace', 'Durgapur');
INSERT INTO works VALUES ('DDD', 'united bank', 'City Palace', 'Durgapur');
INSERT INTO works VALUES ('FFF', 'united bank', 'City Palace', 'Durgapur');
INSERT INTO works VALUES ('HHH', 'state bank', 'N Palace', 'Burdwan');
INSERT INTO works VALUES ('IIII', 'state bank', 'N Palace', 'Burdwan');

SELECT *
FROM company;
SELECT *
FROM employee1;
SELECT *
FROM manager;
SELECT *
FROM works;

SQL> @"H:\PL SQL PROGRAMS\03_06_menu.sql"
_______________________________________________________________
|- 1. List names of all employees who work for Indian bank
|- 2. List names of managers and with cities and  the company names where they work
|- 3. List names of employees who earn more than every employee of united bank
|- 4. Find company name with largest payroll
|- 5. List names of all employees and their cities of residence who work in state bank
|- 6. Find employees of state bank of burdwan who earn more than Rs. 30000
|- 7. Find names of employees who live in the same city as the company in which they work
|- 8. Find names of employees who live in the same city as do their manager
_______________________________________________________________
|-    ENTER YOUR CHOICE: 1
old  55:   choice:=&ch;
new  55:   choice:=         1;
_____________
EMPLOYEE NAME
-------------
AAA
_____________
EMPLOYEE NAME
-------------
BBB

PL/SQL procedure successfully completed.

SQL> @"H:\PL SQL PROGRAMS\03_06_menu.sql"
_______________________________________________________________
|- 1. List names of all employees who work for Indian bank
|- 2. List names of managers and with cities and  the company names where they work
|- 3. List names of employees who earn more than every employee of united bank
|- 4. Find company name with largest payroll
|- 5. List names of all employees and their cities of residence who work in state bank
|- 6. Find employees of state bank of burdwan who earn more than Rs. 30000
|- 7. Find names of employees who live in the same city as the company in which they work
|- 8. Find names of employees who live in the same city as do their manager
_______________________________________________________________
|-    ENTER YOUR CHOICE: 2
old  55:   choice:=&ch;
new  55:   choice:=         2;
________________  _______________  ___________________
MANAGER NAME        CITY              COMPANY NAME
----------------  --------------- --------------------
BBB      Kolkata      Indian bank
________________  _______________  ___________________
MANAGER NAME        CITY              COMPANY NAME
----------------  --------------- --------------------
CCC      Durgapur      united bank
________________  _______________  ___________________
MANAGER NAME        CITY              COMPANY NAME
----------------  --------------- --------------------
HHH      Burdwan      state bank

PL/SQL procedure successfully completed.

SQL> @"H:\PL SQL PROGRAMS\03_06_menu.sql"
_______________________________________________________________
|- 1. List names of all employees who work for Indian bank
|- 2. List names of managers and with cities and  the company names where they work
|- 3. List names of employees who earn more than every employee of united bank
|- 4. Find company name with largest payroll
|- 5. List names of all employees and their cities of residence who work in state bank
|- 6. Find employees of state bank of burdwan who earn more than Rs. 30000
|- 7. Find names of employees who live in the same city as the company in which they work
|- 8. Find names of employees who live in the same city as do their manager
_______________________________________________________________
|-    ENTER YOUR CHOICE: 3
old  55:   choice:=&ch;
new  55:   choice:=         3;
____________
EMPLOYEE NAME
____________
HHH

PL/SQL procedure successfully completed.

SQL> @"H:\PL SQL PROGRAMS\03_06_menu.sql"
_______________________________________________________________
|- 1. List names of all employees who work for Indian bank
|- 2. List names of managers and with cities and  the company names where they work
|- 3. List names of employees who earn more than every employee of united bank
|- 4. Find company name with largest payroll
|- 5. List names of all employees and their cities of residence who work in state bank
|- 6. Find employees of state bank of burdwan who earn more than Rs. 30000
|- 7. Find names of employees who live in the same city as the company in which they work
|- 8. Find names of employees who live in the same city as do their manager
_______________________________________________________________
|-    ENTER YOUR CHOICE: 4
old  55:   choice:=&ch;
new  55:   choice:=         4;
______________
COMPANY NAME
______________
state bank

PL/SQL procedure successfully completed.

SQL> @"H:\PL SQL PROGRAMS\03_06_menu.sql"
_______________________________________________________________
|- 1. List names of all employees who work for Indian bank
|- 2. List names of managers and with cities and  the company names where they work
|- 3. List names of employees who earn more than every employee of united bank
|- 4. Find company name with largest payroll
|- 5. List names of all employees and their cities of residence who work in state bank
|- 6. Find employees of state bank of burdwan who earn more than Rs. 30000
|- 7. Find names of employees who live in the same city as the company in which they work
|- 8. Find names of employees who live in the same city as do their manager
_______________________________________________________________
|-    ENTER YOUR CHOICE: 5
old  55:   choice:=&ch;
new  55:   choice:=         5;
______________    __________
EMPLOYEE NAME      CITY
--------------    ----------
HHH     Kolkata
______________    __________
EMPLOYEE NAME      CITY
--------------    ----------
IIII     Kolkata

PL/SQL procedure successfully completed.

SQL> @"H:\PL SQL PROGRAMS\03_06_menu.sql"
_______________________________________________________________
|- 1. List names of all employees who work for Indian bank
|- 2. List names of managers and with cities and  the company names where they work
|- 3. List names of employees who earn more than every employee of united bank
|- 4. Find company name with largest payroll
|- 5. List names of all employees and their cities of residence who work in state bank
|- 6. Find employees of state bank of burdwan who earn more than Rs. 30000
|- 7. Find names of employees who live in the same city as the company in which they work
|- 8. Find names of employees who live in the same city as do their manager
_______________________________________________________________
|-    ENTER YOUR CHOICE: 6
old  55:   choice:=&ch;
new  55:   choice:=         6;
_____________
EMPLOYEE NAME
-------------
HHH

PL/SQL procedure successfully completed.

SQL> @"H:\PL SQL PROGRAMS\03_06_menu.sql"
_______________________________________________________________
|- 1. List names of all employees who work for Indian bank
|- 2. List names of managers and with cities and  the company names where they work
|- 3. List names of employees who earn more than every employee of united bank
|- 4. Find company name with largest payroll
|- 5. List names of all employees and their cities of residence who work in state bank
|- 6. Find employees of state bank of burdwan who earn more than Rs. 30000
|- 7. Find names of employees who live in the same city as the company in which they work
|- 8. Find names of employees who live in the same city as do their manager
_______________________________________________________________
|-    ENTER YOUR CHOICE: 7
old  55:   choice:=&ch;
new  55:   choice:=         7;
_____________
EMPLOYEE NAME
-------------
AAA
BBB
CCC
DDD

PL/SQL procedure successfully completed.

SQL> @"H:\PL SQL PROGRAMS\03_06_menu.sql"
_______________________________________________________________
|- 1. List names of all employees who work for Indian bank
|- 2. List names of managers and with cities and  the company names where they work
|- 3. List names of employees who earn more than every employee of united bank
|- 4. Find company name with largest payroll
|- 5. List names of all employees and their cities of residence who work in state bank
|- 6. Find employees of state bank of burdwan who earn more than Rs. 30000
|- 7. Find names of employees who live in the same city as the company in which they work
|- 8. Find names of employees who live in the same city as do their manager
_______________________________________________________________
|-    ENTER YOUR CHOICE: 8
old  55:   choice:=&ch;
new  55:   choice:=         8;
__________________
EMPLOYEE NAME
------------------
AAA
DDD
IIII

PL/SQL procedure successfully completed.



--------------------------------------------- */