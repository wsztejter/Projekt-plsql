--------------------------------------------------------
--  File created - sobota-paüdziernika-07-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package CON_EMP
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HR"."CON_EMP" as

    idx pls_integer := 1;

    TYPE emplo_at IS TABLE OF employees%ROWTYPE;
    kolekcja_emplo emplo_at;

    TYPE local_at IS TABLE OF locations%ROWTYPE;
    kolekcja_local local_at;

    TYPE depart_at IS TABLE OF departments%ROWTYPE;
    kolekcja_depart depart_at;

    type t_merged is record ( employee employees%ROWTYPE
                            , department departments%ROWTYPE
                            , location locations%ROWTYPE
                             );

    TYPE merged_at  is TABLE OF t_merged INDEX BY pls_integer;
    kolekcja_merged merged_at;

     PROCEDURE create_emplo_dep;
     END CON_EMP;

/
