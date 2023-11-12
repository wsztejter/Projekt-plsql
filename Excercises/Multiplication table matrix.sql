DECLARE
  -- Declare a PL/SQL table type for storing strings with an index of PLS_INTEGER
  TYPE MyTab IS TABLE OF VARCHAR2(1000) INDEX BY PLS_INTEGER;
  
  -- Declare a variable of the MyTab type
  tab1 MyTab;
  
  -- Initialize variables
  num_1 NUMBER := 1;
  num_2 NUMBER := 1;
  num_3 NUMBER;
  num_4 NUMBER := 1;
BEGIN
  -- Nested loops to calculate and store multiplication results in the tab1 array
  FOR num_1 IN 1..10 LOOP
    FOR num_2 IN 1..10 LOOP
      -- Calculate the multiplication result
      num_3 := num_1 * num_2;
      
      -- Store the formatted multiplication result in the tab1 array
      tab1(num_4) := (num_1 || '*' || num_2 || '=' || num_3 || ' ');
      
      -- Increment the index for tab1
      num_4 := num_4 + 1;
    END LOOP;
  END LOOP;

  -- Display the contents of the tab1 array
  FOR i IN 1..10 LOOP
    FOR j IN 1..10 LOOP
      -- Output each element in the tab1 array
      DBMS_OUTPUT.PUT(tab1((j-1)*10 + i));
    END LOOP;
    -- Move to the next line after each row is displayed
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;     
END;
/
