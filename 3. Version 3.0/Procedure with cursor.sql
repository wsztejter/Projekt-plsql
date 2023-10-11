--------------------------------------------------------
--  File created - œroda-paŸdziernika-11-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure EMPLOC_CURSOR_FORALL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "HR"."EMPLOC_CURSOR_FORALL" as

  -- Kursor do przerzucania danych z jednej kolekcji do drugiej
  
  cursor emploc_cursor is
    select *
    from employees e, departments d, locations l
    where e.department_id = d.department_id
    and d.location_id = l.location_id;
    -- kolekcja do przerzucenia danych do tabeli
    TYPE emploc_at  is TABLE OF new_employees_location%rowtype;
    kolekcja_emploc emploc_at := emploc_at();

BEGIN

      -- usuwamy dane z tabeli (jeœli s¹)
    EXECUTE IMMEDIATE 'DELETE FROM HR.NEW_EMPLOYEES_LOCATION';
     COMMIT;

      -- za pomoca cursora wrzucam dane do kolekcji

      OPEN emploc_cursor;
      FETCH emploc_cursor BULK COLLECT INTO kolekcja_emploc;
      CLOSE emploc_cursor;

    -- sprawdzenie czy dane siê przenios³y
    --  for i in kolekcja_emploc.first..kolekcja_emploc.last loop
    --  dbms_output.put_line(kolekcja_emploc(i).employee_id);
    --    END LOOP;


    -- wrzucanie danych do nowej tabeli
       forall x in  kolekcja_emploc.first.. kolekcja_emploc.last 
             INSERT INTO new_employees_location VALUES kolekcja_emploc(x);

                     EXCEPTION
                             WHEN OTHERS THEN
                                 DBMS_OUTPUT.PUT_LINE('Dane NIE zostaly umieszczone w nowej tabeli: new_employees_location');
    COMMIT;       

    END;

/
