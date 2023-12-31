--------------------------------------------------------
--  File created - �roda-pa�dziernika-18-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body ELSE_EXCEPTION
--------------------------------------------------------


CREATE TABLE new_employees_location (
        EMPLOYEE_ID         NUMBER(6, 0), 
        FIRST_NAME          VARCHAR2(20), 
        LAST_NAME           VARCHAR2(25),  
        EMAIL               VARCHAR2(25), 
        PHONE_NUMBER        VARCHAR2(20), 
        HIRE_DATE           DATE,  
        JOB_ID              VARCHAR2(10), 
        SALARY              NUMBER(8, 2), 
        COMMISSION_PCT      NUMBER(2, 2), 
        EMPLO_MANAGER_ID    NUMBER(6, 0), 
        EMPLO_DEPARTMENT_ID NUMBER(4, 0),
        DEP_DEPARTMENT_ID   NUMBER(4, 0), 
        DEPARTMENT_NAME     VARCHAR2(30), 
        MANAGER_ID          NUMBER(6, 0), 
        LOCATION_ID         NUMBER(4, 0), 
        LOC_LOCATION_ID     NUMBER(4, 0), 
        STREET_ADDRESS      VARCHAR2(40), 
        POSTAL_CODE         VARCHAR2(12), 
        CITY                VARCHAR2(30), 
        STATE_PROVINCE      VARCHAR2(25), 
        COUNTRY_ID          CHAR(2) 
    );
/

        CREATE TABLE error_log
                (
                  ERROR_CODE      INTEGER
                ,  error_message   VARCHAR2 (4000)
                ,  backtrace       CLOB
                ,  callstack       CLOB
                ,  created_on      DATE
                ,  created_by      VARCHAR2 (30)
                    );
/



  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HR"."ELSE_EXCEPTION" as


         PROCEDURE record_error
            IS
               l_code   PLS_INTEGER := SQLCODE;
               l_mesg VARCHAR2(32767) := SQLERRM;
            BEGIN
           INSERT INTO error_log (error_code
                        ,  error_message
                        ,  backtrace
                        ,  callstack
                        ,  created_on
                        ,  created_by)
              VALUES (l_code
              ,  l_mesg 
              ,  sys.DBMS_UTILITY.format_error_backtrace
              ,  sys.DBMS_UTILITY.format_call_stack
              ,  SYSDATE
              ,  USER);
                COMMIT;
            END record_error;




      PROCEDURE EMPLOC_CURSOR_FORALL as      
                 -- kursor wrzuca dane do  tablicy
  cursor emploc_cursor is
        select *
        from employees e, departments d, locations l
        where e.department_id = d.department_id
        and d.location_id = l.location_id;

    -- kolekcja do przerzucania danych do tabeli
     TYPE emploc_at is TABLE OF new_employees_location%rowtype;
        kolekcja_emploc emploc_at := emploc_at();


          BEGIN

      -- usuwamy dane z tabeli (je?li s?)
     EXECUTE IMMEDIATE 'DELETE FROM HR.NEW_EMPLOYEES_LOCATION';
     COMMIT;

      -- za pomoca cursora wrzucam dane do kolekcji

      OPEN emploc_cursor;
      FETCH emploc_cursor BULK COLLECT INTO  kolekcja_emploc;
      CLOSE emploc_cursor;

    -- sprawdzenie czy dane si? przenios?y
    --  for i in kolekcja_emploc.first..kolekcja_emploc.last loop
    --  dbms_output.put_line(kolekcja_emploc(i).employee_id);
    --    END LOOP;


    -- wrzucanie danych do nowej tabeli
       forall x in  kolekcja_emploc.first.. kolekcja_emploc.last 
             INSERT INTO new_employees_location VALUES kolekcja_emploc(x);

                     EXCEPTION
                             WHEN OTHERS THEN
                                   record_error();
                                   RAISE;
                                        COMMIT;       

        END EMPLOC_CURSOR_FORALL;  

END ELSE_EXCEPTION;

/
