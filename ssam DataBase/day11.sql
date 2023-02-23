/*
 시노님 Synonym '동의어'란 뜻으로 객체 각자의 고유한 이름에 
 대한 동의어를 만드는 것 
 PUBLIC Synonym 모든 사용자 접근 
 PRIVATE 특정 사용자 
 디폴트 private 
 */
 -- dba계정에서 권한부여 
 GRANT CREATE SYNONYM to java;
 -- java 계정에서 생성 
 CREATE OR REPLACE SYNONYM sys_channel
 FOR channels;
  SELECT *
 FROM sys_channel;
 -- 동의어로 조회 할 수 있는 권한을 study에게 부여 
 GRANT SELECT ON sys_channel TO study;
 -- study 계정에서 조회 
 SELECT *
 FROM java.sys_channel;
 
 -- public synonym 은 DBA권한이 있어야함. 
 CREATE OR REPLACE PUBLIC SYNONYM emp 
 FOR java.employees;
 -- public synonym emp를 조회할 수 있는 권한부여 
 GRANT SELECT ON emp to study;
 
 SELECT *
 FROM emp;
 
 -- 그냥 시노님 삭제 
 DROP SYNONYM sys_channel;
 -- public synonym 삭제 (DBA권한이 있어야함)
 DROP PUBLIC SYNONYM emp;
 
/*  시퀀스 Sequence 자동 순번을 반환하는 객체 
*/
CREATE SEQUENCE my_seq1
INCREMENT BY 1  --증강숫자 
START WITH 1    --시작숫자 
MINVALUE   1    --최소값 
MAXVALUE   10   --최대값
NOCYCLE         -- 디폴트 (최대 or 최소 도달시 중지)
NOCACHE;        -- 디폴트 (메모리에 값을 미리 할당하지 않음)

SELECT my_seq1.NEXTVAL -- 다음순번 
FROM dual;
SELECT my_seq1.CURRVAL -- 현재 시퀀스값 
FROM dual;
CREATE TABLE ex11 (
 col number
);
DROP SEQUENCE my_seq1;
INSERT INTO ex11 VALUES(my_seq1.NEXTVAL);
select *
from ex11;
--- 최소 1, 최대 99999999, 시작 1000, 2씩 증가 
CREATE SEQUENCE my_seq2
INCREMENT BY 2
START WITH 1000
MINVALUE 1
MAXVALUE 99999999;
delete ex11;
SELECT NVL(MAX(col),0) + 1
FROM ex11;
INSERT INTO ex11 VALUES((SELECT NVL(MAX(col),0) + 1
                         FROM ex11));

SELECT *
FROM ex11;

/* MERGE 
   특정 조건에 따라 어떤 떄는 INSERT 
   다른 조건일때는 UPDATE, DELETE문을 수행할 떄 사용 
*/
-- '과목' 테이블에 머신러닝 과목이 있으면 학점을 6으로 업데이트 
--                             없으면 번호생성, 머신러닝, 학점 3 인서트 
MERGE INTO 과목 s           -- 작업 대상테이블 
 USING dual                 -- 비교 대상테이블 
 ON (s.과목이름 = :1 ) -- 비교 조건 
WHEN MATCHED THEN
  UPDATE SET s.학점 = :2
WHEN NOT MATCHED THEN 
  INSERT (s.과목번호, s.과목이름, s.학점) 
  VALUES ((SELECT NVL(MAX(과목번호),0)+1
            FROM 과목),:1,:3 );

SELECT *
FROM 과목;


/* 계층형 쿼리 
*/
SELECT department_id as 부서번호 
     , LPAD(' ', 3 * (LEVEL - 1)) || department_name as 부서명
     , LEVEL
     , parent_id
FROM departments
START WITH parent_id IS NULL  -- 이 조건에 맞는 행부터 시작 
--계층이 어떤 식으로 연결되는지 조건 (prior) 위치가 중요  
CONNECT BY PRIOR department_id = parent_id; 
-- LEVEL은 오라클에서 실행되는 모든 쿼리 내에서 사용가능한 가상-열 
-- 트리 내에서 어떤 단계에 있는지 나타냄 (connect by절과 사용)
SELECT *
FROM departments
WHERE department_id = 230;

-- IT_헬프데스크 팀 하위 팀으로 IT_시각화 팀이 생겼습니다. 
-- 데이터를 departments 테이블에 삽입하고 계층형 쿼리로 조회해 주세요 
 
 
 
INSERT INTO departments 
VALUES (310, 'IT_시각화', 230, null, sysdate, sysdate);
commit;

SELECT *
FROM employees;
-- employees 테이블의 employee_id, manager_id 두 컬럼을 활용하여 
-- 계층형쿼리로 직원 관계를 출력하시오 


SELECT LPAD(' ', 3 * (LEVEL - 1)) || a.emp_name as emp_name
     , LEVEL
     , a.manager_id
     , CONNECT_BY_ROOT a.emp_name   as emp_root  -- 최상위 행접근 
     , CONNECT_BY_ISLEAF            as node -- 마지막노드면 1, 자식이 있으면 0
     , SYS_CONNECT_BY_PATH(a.emp_name,'|' ) as emp_path  -- 연결정보 
FROM employees a
START WITH manager_id IS NULL  
CONNECT BY PRIOR employee_id = manager_id
ORDER SIBLINGS BY a.emp_name;  -- 계층형쿼리 정렬조건시 siblings 


/* 다음과 같이 출력되도록 테이블생성 및 데이터삽입 후 출력하시오 
   이사장    사장      1
   김부장     부장     2
   서차장      차장    3
   장과장       과장   4
   이대리        대리  5
   최사원         사원 6
   박과장       과장   4
   김대리        대리  5
   강사원         사원 6
*/
CREATE TABLE 팀(
    사번 number
   ,이름 varchar2(30)
   ,직책 varchar2(30)
   ,상위사번 number
);

INSERT INTO 팀 VALUES(1, '이사장','사장',null);
INSERT INTO 팀 VALUES(2, '김부장','부장',1);
INSERT INTO 팀 VALUES(3, '서차장','차장',2);

INSERT INTO 팀 VALUES(4, '장과장','과장',3);
INSERT INTO 팀 VALUES(5, '박과장','과장',3);

INSERT INTO 팀 VALUES(6, '이대리','대리',4);
INSERT INTO 팀 VALUES(7, '김대리','대리',5);
INSERT INTO 팀 VALUES(8, '최사원','사원',6);
INSERT INTO 팀 VALUES(9, '강사원','사원',7);
COMMIT;
UPDATE 팀 
SET "상위사번" = 6
WHERE 사번 = 4;
commit;
SELECT *
FROM 팀;

select 이름 
     , LPAD(' ', 3 * (level-1)) || 직책 as 직책 
     , level
     , CONNECT_BY_ISCYCLE as Isloop
from 팀 
start with 상위사번 is null
connect by nocycle prior 사번 = 상위사번;

UPDATE departments
SET parent_id = 170
WHERE department_id = 30;


SELECT department_id as 부서번호 
     , LPAD(' ', 3 * (LEVEL - 1)) || department_name as 부서명
     , LEVEL
     , parent_id
FROM departments
START WITH parent_id IS NULL  -- 이 조건에 맞는 행부터 시작 
--계층이 어떤 식으로 연결되는지 조건 (prior) 위치가 중요  
CONNECT BY PRIOR department_id = parent_id; 
 
 