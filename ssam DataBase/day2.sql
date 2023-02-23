-- SELECT 조회 
SELECT *    -- * <-- 전체를 의미함 
FROM employees;
-- 이름, 고용일자, 봉급 조회 
SELECT emp_name   /*직원 이름*/
     , hire_date  /*고용일자*/
     , salary     /*봉급*/
FROM employees;  -- 직원테이블 
-- alias (별칭, 가명) as
SELECT emp_name    nm 
     , hire_date  as 고용_일자 -- 띄어쓰기를 쓰려면 "" <-
     , salary     AS 봉급    
FROM employees;  
-- WHERE 검색 조건  (조건이 더 있을때 AND, OR)
-- 봉급이 12000 이상 
SELECT emp_name   
     , hire_date  
     , salary     
     , department_id
FROM employees
WHERE salary >= 12000;  
-- 봉급이 12000 이상이면서 90번 부서 
SELECT emp_name   
     , hire_date  
     , salary     
     , department_id
FROM employees
WHERE salary >= 12000
AND   department_id = 90;  
-- 봉급 오름차순 
SELECT emp_name   
     , hire_date  
     , salary     
     , department_id
FROM employees
WHERE salary >= 12000
AND   department_id = 90
ORDER BY salary ASC, emp_name ; -- 정렬 조건 ASC:오름차순(디폴트) DESC:내림차순 


SELECT emp_name   as nm
     , hire_date  
     , salary     
     , department_id
FROM employees
WHERE salary >= 12000
AND   department_id = 90
ORDER BY nm desc, 3 asc ;



SELECT emp_name   as nm
     , hire_date  
     , salary     
     , department_id
FROM employees
WHERE department_id = 10  
OR   department_id = 90 ; --10 또는 90

-- INSERT 삽입 
-- 방법(1) 기본형태 
INSERT INTO ex1_1(col1, col2)
VALUES ('1','팽수');
INSERT INTO ex1_1 (col1)
VALUES ('3');
-- 방법(2) 전체 삽입할때 
INSERT INTO ex1_1 
VALUES ('2','길동');

CREATE TABLE ex2_1(
   nm VARCHAR2(100)
  ,email VARCHAR2(100)
);
-- 방법(3) select  ~ insert 조회결과를 그대로 삽입 
INSERT INTO ex2_1(nm, email)
SELECT emp_name
      ,email
FROM employees;

SELECT *
FROM ex2_1;

/* UPDATE 수정 */
UPDATE ex1_1
SET col2 = '홍길동' -- 수정내용 
WHERE col1 = '3';  -- 수정 대상 

UPDATE ex1_1
SET col2 = '홍길동';

SELECT *
FROM ex1_1;

COMMIT;   -- 반영 
ROLLBACK; -- 되돌아가기 

/* DELETE 삭제 */
DELETE ex1_1;  -- 테이블 전체 

DELETE ex1_1
WHERE col1 = '1'; -- 삭제 대상 

SELECT *
FROM ex1_1;

desc ex1_1; -- 속성 정보조회 
INSERT INTO ex1_1 
VALUES ('abc', 'abc');
SELECT col1, LENGTH(col1), LENGTHB(col1)
     , col2, LENGTH(col2), LENGTHB(col2)
FROM ex1_1;
INSERT INTO ex1_1 
VALUES ('a', '이');
INSERT INTO ex1_1 
VALUES ('a', '오라클이다');

CREATE TABLE ex2_2(
    col1 VARCHAR2(3)     -- 디폴트 byte
   ,col2 VARCHAR2(3 byte)
   ,col3 VARCHAR2(3 char)
);
INSERT INTO ex2_2(col1, col2)
VALUES ('오라클','오라클') ;  -- 오류 
INSERT INTO ex2_2(col3)
VALUES ('오라클') ;      

SELECT *
FROM ex1_1
WHERE col1 = 'a'; -- 값자체는 대소문자 구별 

-- number(p, s) p:최대 유효숫자, s:소수점 기준 자릿수(디폴트0)
CREATE TABLE ex2_3(
     col1 NUMBER
    ,col2 NUMBER(3,2)
    ,col3 NUMBER(5,-2)
);
INSERT INTO ex2_3 (col1) VALUES(0.7898); -- 반올림
INSERT INTO ex2_3 (col1) VALUES(99.5);   -- 반올림 
INSERT INTO ex2_3 (col1) VALUES(1004);   -- 오류 
SELECT * 
FROM ex2_3;
INSERT INTO ex2_3 (col2) VALUES(0.7898); -- 소수점 3째자리에서 반올림
INSERT INTO ex2_3 (col2) VALUES(1.2345); -- 소수점 3째자리에서 반올림 
INSERT INTO ex2_3 (col2) VALUES(32);  -- 오류(정수부분은1자리)

INSERT INTO ex2_3 (col3) VALUES(12345.2346); 
INSERT INTO ex2_3 (col3) VALUES(123467.350); 
INSERT INTO ex2_3 (col3) VALUES(1234679.350); 
INSERT INTO ex2_3 (col3) VALUES(12346798.350);  -- 오류 
SELECT * FROM ex2_3;
--number 타입 컬럼이지만 문자열이 숫자형태면 받아드림.
INSERT INTO ex2_3 (col3) VALUES('1'); 

-- 제약조건 
-- not null <-- 널안됨.
CREATE TABLE ex2_5(
    col1 VARCHAR2(20)   -- 디폴트 널허용 
   ,col2 VARCHAR2(20) NOT NULL
);
INSERT INTO ex2_5 (col2) VALUES ('abc');
INSERT INTO ex2_5 (col1) VALUES ('abc'); -- 오류
SELECT *
FROM ex2_5;
-- unique 중복 X
CREATE TABLE ex2_6(
     col1 VARCHAR2(20)
    ,col2 VARCHAR2(20) UNIQUE
);
INSERT INTO ex2_6(col1, col2) VALUES ('abc','abc');
INSERT INTO ex2_6(col1, col2) VALUES ('ABC','ABC');
INSERT INTO ex2_6(col1) VALUES ('ABC');
INSERT INTO ex2_6(col2) VALUES ('ABC'); -- 중복값 오류 
INSERT INTO ex2_6(col2) VALUES (null);  -- null 과 unique 다름 
SELECT * FROM ex2_6;
-- default 
CREATE TABLE ex2_7(
     col1 DATE default SYSDATE
   , col2 DATE default SYSDATE + 1
   , col3 VARCHAR2(10)
);
INSERT INTO ex2_7 (col3) VALUES('hi');
SELECT * FROM ex2_7;

-- PK primary key 기본키 
-- 테이블 당 1개 설정가능(여러 컬럼을 결합 할 수 있음)
-- PK는 not null이며 unique 함. 
CREATE TABLE ex2_8(
    col1 VARCHAR2(10) PRIMARY KEY
   ,col2 DATE DEFAULT SYSDATE
);
INSERT INTO ex2_8(col1) VALUES('0001');
INSERT INTO ex2_8(col1) VALUES(null);  -- 오류

SELECT *
FROM user_constraints
WHERE OWNER = 'JAVA'
AND TABLE_NAME ='EX2_9';

CREATE TABLE ex2_9(
    col1 VARCHAR2(20)
   ,col2 VARCHAR2(20)
   ,CONSTRAINT ex2_9_pk PRIMARY KEY(col1)
   -- 제약조건 이름 부여
);

-- CHECK 
CREATE TABLE ex2_10(
    nm VARCHAR2(20) not null
   ,age NUMBER
   ,gender CHAR(1)
   ,CONSTRAINTS chk_age CHECK(age BETWEEN 1 AND 200) -- 1 ~ 200
   ,CONSTRAINTS chk_gender CHECK(gender IN ('F','M')) --F or M
);
INSERT INTO ex2_10 VALUES ('팽수',10,'M'); --정상 
INSERT INTO ex2_10 VALUES ('팽수',1000,'M'); -- 오류 age check
INSERT INTO ex2_10 VALUES ('팽수',10,'A');   -- 오류 gender check

-- 테이블 삭제 DROP 
DROP TABLE ex1_1 ;-- 일반 테이블 삭제 
DROP TABLE ex1_1 CASCADE CONSTRAINTS; -- 제약조건까지 삭제 
-- 테이블 수정 ALTER 
SELECT *
FROM ex2_1;
-- 컬럼명 수정 
ALTER TABLE ex2_1 RENAME COLUMN NM TO EMP_NAME;
-- 컬럼 타입 수정 
ALTER TABLE ex2_1 MODIFY EMP_NAME VARCHAR2(1000);
-- 컬럼 추가 
ALTER TABLE ex2_1 ADD COL3 NUMBER;
-- 제약조건 추가 
ALTER TABLE ex2_1 ADD CONSTRAINT pk_ex2_1 PRIMARY KEY(col3);

ALTER TABLE ex2_1 ADD CONSTRAINT pk_ex2_2 NOT NULL(col3);



-- DATE 년월일시분초, TIMESTAMP 밀리초포함 
CREATE TABLE ex2_4(
     col1 DATE
    ,col2 TIMESTAMP
);
INSERT INTO ex2_4 
VALUES (SYSDATE, SYSTIMESTAMP); -- sysdate now time
SELECT TO_CHAR(col1,'YYYY') as y
     , TO_CHAR(col1,'MM')   as m
     , TO_CHAR(col1,'DD')   as d
     , TO_CHAR(col1,'YYYY-MM-DD HH24:MI:SS')   as day
     , TO_CHAR(col1,'YYYY/MM/DD HH12:MI:SS')   as day2
FROM ex2_4;




CREATE TABLE TB_INFO(
      INFO_NO NUMBER(3) PRIMARY KEY
    , PC_NO VARCHAR2(10) NOT NULL
    , NM VARCHAR2(20)
    , EMAIL VARCHAR2(100)
    , HOBBY VARCHAR2(1000)
);
















