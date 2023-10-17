--------------------------------------------------------
--  File created - wtorek-paüdziernika-17-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package P_COURSOR_EXCEPTION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HR"."P_COURSOR_EXCEPTION" as

    -- kursor wrzuca dane do  tablicy
  cursor emploc_cursor is
        select *
        from employees e, departments d, locations l
        where e.department_id = d.department_id
        and d.location_id = l.location_id;

    -- kolekcja do przerzucania danych do tabeli

  TYPE emploc_at  is TABLE OF new_employees_location%rowtype;
    kolekcja_emploc emploc_at := emploc_at();

  PROCEDURE EMPLOC_CURSOR_FORALL;

  -- procedura do lapania bledow
  PROCEDURE record_error;

END P_COURSOR_EXCEPTION;

/
