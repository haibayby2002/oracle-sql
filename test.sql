drop table 

drop table "SYSTEM"."FIRSTTABLE"

--DROP ALL TABLE in test (dont use if dont need)
BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                   FROM user_objects
                   WHERE object_type IN
                             ('TABLE',
                              'VIEW',
                              'MATERIALIZED VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'SYNONYM',
                              'PACKAGE BODY'
                             ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE'
         THEN
            EXECUTE IMMEDIATE 'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE 'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line ('FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
   FOR cur_rec IN (SELECT * 
                   FROM all_synonyms 
                   WHERE table_owner IN (SELECT USER FROM dual))
   LOOP
      BEGIN
         EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || cur_rec.synonym_name;
      END;
   END LOOP;
END;
-- -------------------------------------------------------------------------------
--Create table class
CREATE TABLE CLASS 
(
  CLASS_ID NUMBER NOT NULL 
, CLASS_NAME VARCHAR2(50) 
, CONSTRAINT CLASS_PK PRIMARY KEY 
  (
    CLASS_ID 
  )
  ENABLE 
);

--Create student
CREATE TABLE STUDENT 
(
  STU_ID NUMBER NOT NULL 
, NAME VARCHAR2(50) NOT NULL 
, AVG_MARK NUMBER 
, CLASS_ID NUMBER 
, CONSTRAINT STUDENT_PK PRIMARY KEY 
  (
    STU_ID 
  )
, CONSTRAINT FK_CLASS
    FOREIGN KEY (CLASS_ID)
    REFERENCES CLASS(CLASS_ID)
  ENABLE 
);

--INSERT CLASS
INSERT INTO "SYSTEM"."CLASS" (CLASS_ID, CLASS_NAME) VALUES ('1', 'DBS')
INSERT INTO "SYSTEM"."CLASS" (CLASS_ID, CLASS_NAME) VALUES ('2', 'DSA')
INSERT INTO "SYSTEM"."CLASS" (CLASS_ID, CLASS_NAME) VALUES ('3', 'PPL')

--INSERT STUDENT
INSERT INTO "SYSTEM"."STUDENT" (STU_ID, NAME, AVG_MARK, CLASS_ID) VALUES ('1', 'Nguy?n Quý H?i', '5', '1')
INSERT INTO "SYSTEM"."STUDENT" (STU_ID, NAME, AVG_MARK, CLASS_ID) VALUES ('2', 'Tr?n Xuân ??c', '7', '3')
INSERT INTO "SYSTEM"."STUDENT" (STU_ID, NAME, AVG_MARK, CLASS_ID) VALUES ('3', '??ng Th?nh', '7.5', '2')
INSERT INTO "SYSTEM"."STUDENT" (STU_ID, NAME, AVG_MARK, CLASS_ID) VALUES ('4', 'Nguy?n Duy Thu?n', '8', '2')
INSERT INTO "SYSTEM"."STUDENT" (STU_ID, NAME, AVG_MARK, CLASS_ID) VALUES ('5', '?? ??c Trung', '6.7', '3')


