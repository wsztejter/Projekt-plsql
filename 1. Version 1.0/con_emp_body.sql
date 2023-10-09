--------------------------------------------------------
--  File created - sobota-paŸdziernika-07-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body CON_EMP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HR"."CON_EMP" as

PROCEDURE create_emplo_dep AS

BEGIN
  -- w tabelach nie ma create or replace trzeba najpierw sprawdzic czy istnieje usuwajac ja, a blad dac w exception null ingoruj
   BEGIN
     EXECUTE IMMEDIATE 'DROP TABLE new_employees_location';
    EXCEPTION
        WHEN OTHERS THEN
            NULL;
    -- daj tu output tabela nie istnieje mo¿e (null ka¿e ignorowaæ b³ad)
   dbms_output.put_line('tabela nie istnieje');
 END;
 commit;
    -- tworzenie tabeli
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE new_employees_location (
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
    )';
    
       EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wyst pi  b  d podczas tworzenia tabeli: ' || SQLERRM);
     COMMIT;

  END; 





-- Bulk collect employee data into collection
    SELECT *
    BULK COLLECT INTO  kolekcja_emplo
    FROM employees;

    SELECT *
    BULK COLLECT INTO kolekcja_depart
    from departments;

    SELECT *
    BULK COLLECT INTO kolekcja_local
    from locations;

    -- Insert data into the new table using FORALL

    FOR i IN kolekcja_emplo.FIRST..kolekcja_emplo.LAST 
    LOOP
    FOR j IN kolekcja_depart.FIRST..kolekcja_depart.LAST 
    LOOP
    FOR k IN kolekcja_local.FIRST..kolekcja_local.LAST 
    LOOP
        IF kolekcja_emplo(i).DEPARTMENT_ID = kolekcja_depart(j).DEPARTMENT_ID
                   AND kolekcja_depart(j).LOCATION_ID = kolekcja_local(k).LOCATION_ID 
                   THEN
                  -- merged_at.extend;
                kolekcja_merged(idx).employee := kolekcja_emplo(i);
                kolekcja_merged(idx).department := kolekcja_depart(j);
                kolekcja_merged(idx).location := kolekcja_local(k);
        idx := idx+1;
        END IF;
     END LOOP;
     END LOOP;
     END LOOP;
   BEGIN
   for x in kolekcja_merged.first..kolekcja_merged.last loop
       execute immediate 'INSERT INTO new_employees_location VALUES (
           	kolekcja_merged(x).employee.EMPLOYEE_ID,
            kolekcja_merged(x).employee.FIRST_NAME,
            kolekcja_merged(x).employee.LAST_NAME,
            kolekcja_merged(x).employee.EMAIL,
            kolekcja_merged(x).employee.PHONE_NUMBER,
            kolekcja_merged(x).employee.HIRE_DATE,
            kolekcja_merged(x).employee.JOB_ID,
            kolekcja_merged(x).employee.SALARY,
            kolekcja_merged(x).employee.COMMISSION_PCT,
            kolekcja_merged(x).employee.MANAGER_ID,
            kolekcja_merged(x).employee.DEPARTMENT_ID,
            kolekcja_merged(x).department.DEPARTMENT_ID,
            kolekcja_merged(x).department.DEPARTMENT_NAME,
            kolekcja_merged(x).department.MANAGER_ID,
            kolekcja_merged(x).department.LOCATION_ID,
            kolekcja_merged(x).location.LOCATION_ID,
            kolekcja_merged(x).location.STREET_ADDRESS,
            kolekcja_merged(x).location.POSTAL_CODE,
            kolekcja_merged(x).location.CITY,
            kolekcja_merged(x).location.STATE_PROVINCE,
            kolekcja_merged(x).location.COUNTRY_ID
        )';
        END LOOP;
       
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Dane zostaly umieszczone w nowej tabeli: new_employees_location');
    COMMIT;
END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystapil  blad: ' || SQLERRM);
   END;
END CON_EMP;

/
