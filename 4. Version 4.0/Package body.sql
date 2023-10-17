--------------------------------------------------------
--  File created - wtorek-paüdziernika-17-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body P_COURSOR_EXCEPTION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HR"."P_COURSOR_EXCEPTION" as

    PROCEDURE record_error
                    AS
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


        -- tworzymy tabele od exception
       BEGIN
           EXECUTE IMMEDIATE  'CREATE TABLE error_log
                (
                  ERROR_CODE      INTEGER
                ,  error_message   VARCHAR2 (4000)
                ,  backtrace       CLOB
                ,  callstack       CLOB
                ,  created_on      DATE
                ,  created_by      VARCHAR2 (30)
                    )';
        -- tabela do  exception


END P_COURSOR_EXCEPTION;

/
