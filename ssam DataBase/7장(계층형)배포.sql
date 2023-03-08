

-- 계층형쿼리 
-- 1번 쿼리 
SELECT department_id, 
       department_name, 
       0 AS PARENT_ID,
       1 as levels,                                    -- 1 LEVELS 가장 상위 부서
        parent_id || department_id AS sort
FROM departments 
WHERE parent_id IS NULL
UNION ALL
SELECT t2.department_id, 
       LPAD(' ' , 3 * (2-1)) || t2.department_name AS department_name, 
       t2.parent_id,
       2 AS levels,                                   -- 2 LEVELS  가장 상위 부서를 10을 parent_id 로 가지고 있는 그룹
       t2.parent_id || t2.department_id AS sort
FROM departments t1,
     departments t2
WHERE t1.parent_id is null
  AND t2.parent_id = t1.department_id
UNION ALL
SELECT t3.department_id, 
       LPAD(' ' , 3 * (3-1)) || t3.department_name AS department_name, 
       t3.parent_id,
       3 as levels,                                  -- 3 LEVELS 두번째 쿼리 결과로 나온 부서 번호를 parent_id로 가집 부서
       t2.parent_id || t3.parent_id || t3.department_id as sort
FROM departments t1,
     departments t2,
     departments t3
WHERE t1.parent_id IS NULL
  AND t2.parent_id = t1.department_id
  AND t3.parent_id = t2.department_id
UNION ALL
SELECT t4.department_id, 
       LPAD(' ' , 3 * (4-1)) || t4.department_name as department_name, 
       t4.parent_id,
       4 as levels,
       t2.parent_id || t3.parent_id || t4.parent_id || t4.department_id AS sort
FROM departments t1,
     departments t2,
     departments t3,
     departments t4
WHERE t1.parent_id IS NULL
  AND t2.parent_id = t1.department_id
  AND t3.parent_id = t2.department_id
  and t4.parent_id = t3.department_id
ORDER BY sort;

/**
    위와 같은 쿼리의 문제점은 
    1. 현 부서의 계층 구조는 4레벨이지만 , 레벨이 더 많아지면 쿼리를 수정해서 작성해야한다. 
    2. 레벨 수 자체를 집접 코딩함(하드코딩)
    3. 쿼리가 복잡해 파악하는데 오래 걸림.
*/

----------------------------------계층형 쿼리 
-- LEVEL은 오라클의 모든 SQL에서 사용할 수 있는 것으로 해당 데이터가 몇 번째 단계이냐를 의미함.
-- 2번 쿼리 
SELECT department_id as 부서번호
     , LPAD(' ' , 3 * (LEVEL-1)) || department_name as 부서명
     , LEVEL
  FROM departments
  START WITH parent_id IS NULL                  --< 이조건에 맞는 로우부터 시작함.
  CONNECT BY PRIOR department_id  = parent_id;  --< 계층형 구조가 어떤 식으로 연결되는지 기술(조건). 
                                                 -- PRIOR 의 위치가 중요 
 -- 시작을 PARENT_ID 컬럼이 NULL인 걸로 하고 
 -- DEPARTMENT_ID의 이전 부서들의 PARENT_ID 를 찾으라는 뜻 

-- 3번 쿼리   
SELECT a.employee_id, LPAD(' ' , 3 * (LEVEL-1)) || a.emp_name
      , LEVEL
      , b.department_name
  FROM employees a,
       departments b
 WHERE a.department_id = b.department_id
 START WITH a.manager_id IS NULL
 CONNECT BY PRIOR a.employee_id = a.manager_id;
 
-- 4번 쿼리   30번 부서직원의 관리자 
SELECT a.employee_id, LPAD(' ' , 3 * (LEVEL-1)) || a.emp_name, 
       LEVEL,
       b.department_name, a.DEPARTMENT_ID
  FROM employees a,
       departments b
 WHERE a.department_id = b.department_id
   AND a.department_id = 30
 START WITH a.manager_id IS NULL
 CONNECT BY PRIOR a.employee_id = a.manager_id; 

-- 5번 쿼리 
SELECT a.employee_id, LPAD(' ' , 3 * (LEVEL-1)) || a.emp_name, 
       LEVEL,
       b.department_name, a.DEPARTMENT_ID
  FROM employees a,
       departments b
 WHERE a.department_id = b.department_id
 START WITH a.manager_id IS NULL
 CONNECT BY PRIOR a.employee_id = a.manager_id
     AND a.department_id = 30;
------------------------------------------------------
/*
 4, 5번 쿼리 모두 부서 번호가 30일 건을 조회하고 있지만
 5번 쿼리에는 CONNECT BY 절에 조건을 줌 
 4번 쿼리와 다르게 두 번째 쿼리에서는 부서번호가 90인 최상위 부서도 조회됨.

    조회 절차를 보면
    1. 조인이 있으면 조인 먼저 처리
    2. START WITH 절을 참조해 최상위 계층 로우를 선택
    3. CONNECT BY 절에 명시된 구문에 따라 계층형 관계 (부모-자식)관계를 파악해 자식 로우를 차례로 선택
      최상위 로우를 기준으로 자식로우를 선택하고, 이 자식 로우에 대한 또 다른 자식 로우가 있으면 선택
    4. 자식 로우 찾기가 끝나면 조인 조건을 제외한 WHERE 조건에 해당하는 로우를 걸러냄.   
*/
-------------------------------------------------------

SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id  = parent_id
ORDER BY department_name;   -- 계층형트리가 께짐 
   
SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id  = parent_id
ORDER SIBLINGS BY department_name ;      -- 정렬 가능 



SELECT department_id
     , LPAD(' ' , 3 * (LEVEL-1)) || department_name
     , LEVEL
     , CONNECT_BY_ROOT department_name AS root_name  --- 최상위
  FROM departments
  START WITH parent_id IS NULL
  CONNECT BY PRIOR department_id  = parent_id;

--------------------------------------------------------------------
  
SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name
     , LEVEL
     , CONNECT_BY_ISLEAF        -- 마지막 노드면 1, 자식이 있으면 0 
  FROM departments
  START WITH parent_id IS NULL
  CONNECT BY PRIOR department_id  = parent_id;  
  
SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL, 
       SYS_CONNECT_BY_PATH( department_name, '|')  -- 루트 노트에서 시작해 자신의 행까지 연결된 경로 정보를 반환
  FROM departments
  START WITH parent_id IS NULL
  CONNECT BY PRIOR department_id  = parent_id;   
  
  
SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL, 
       SYS_CONNECT_BY_PATH( department_name, '/')
  FROM departments
  START WITH parent_id IS NULL
  CONNECT BY PRIOR department_id  = parent_id;     

---------------------------------------------------------
 


SELECT 직책코드 as 부서번호
     , 이름
     , LPAD(' ' , 3 * (LEVEL-1)) || 직책 as 부서명
     , LEVEL
  FROM 팀
  START WITH 상위직책코드 IS NULL              --< 이조건에 맞는 로우부터 시작함.
  CONNECT BY PRIOR 직책코드  = 상위직책코드;      --< 계층형 구조가 어떤 식으로 연결되는지 기술(조건). 

------------------------------------------------------------------------------
-- 무한 루프 상황   
UPDATE departments
   SET parent_id = 170
 WHERE department_id = 30;
 
SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name, LEVEL, 
       parent_id
  FROM departments
  START WITH department_id = 30
CONNECT BY PRIOR department_id  = parent_id; 
--- 무한 루프 걸림

SELECT department_id, LPAD(' ' , 3 * (LEVEL-1)) || department_name AS depname, LEVEL, 
       CONNECT_BY_ISCYCLE IsLoop,      -- 무한루프 원인 찾음 ( 현재 로우가 자식을 갖고 있는데 동시에 그 자식 로우가 부모 로우면 1, 아니면 0
       parent_id
  FROM departments
  START WITH department_id = 30
CONNECT BY NOCYCLE PRIOR department_id  = parent_id; 

 /*
  CONNECT BY 절을 이용하여 계층 질의에서 상위계층(부모행)과 하위계층(자식행)의 관계를 규정 할 수 있다.
  PRIOR 연산자와 함께 사용하여 계층구조로 표현할 수 있다.
  CONNECT BY PRIOR 자식컬럼 = 부모컬럼 : 부모에서 자식으로 트리구성 (Top Down)
  CONNECT BY PRIOR 부모컬럼 = 자식컬럼 : 자식에서 부모로 트리 구성 (Bottom Up)
  CONNECT BY NOCYCLE PRIOR : NOCYCLE 파라미터를 이용하여 무한루프 방지
  서브쿼리를 사용할 수 없다.
*/


--------------------------------------------------------------------------------------------------

select department_id
     , lpad(' ', (level - 1) * 3) ||  department_name
     , parent_id 
     , level as lvl
  from departments
 start with department_id = 90
connect by  department_id = prior parent_id ;  -- bottom -> top 
-- connect by prior department_id = parent_id ;  --  top -> bottom
---------------------------------------------------------------------------------------------------

 


-- 계층형 쿼리 응용 
-- 샘플 데이터 생성  
SELECT level
FROM dual
CONNECT BY LEVEL <=12;


SELECT TO_CHAR(TO_DATE('20200801', 'YYYYMMDD')+LEVEL-1, 'YYYY-MM-DD')
  FROM DUAL
CONNECT BY LEVEL <= (TO_DATE('20200831', 'YYYYMMDD')-TO_DATE('20200801', 'YYYYMMDD')+1)


SELECT TO_CHAR(SYSDATE,'YYYY')||LPAD(LEVEL, 2, '0') AS YEAR 
FROM DUAL CONNECT BY LEVEL <= 12;


-- 201401 ~ 201412 까지 월 1000건의 데이터를 생성   
CREATE TABLE ex7_1 AS  
SELECT ROWNUM seq, 
       '2014' || LPAD(CEIL(ROWNUM/1000) , 2, '0' ) month,
        ROUND(DBMS_RANDOM.VALUE (100, 1000)) amt
FROM DUAL
CONNECT BY LEVEL <= 12000;



SELECT T1.YEAR
     , NVL(T2.일요일,0) AS SUN
     , NVL(T2.월요일,0) AS MON
     , NVL(T2.화요일,0) AS TUE
     , NVL(T2.수요일,0) AS WED
     , NVL(T2.목요일,0) AS THU
     , NVL(T2.금요일,0) AS FRI
     , NVL(T2.토요일,0) AS SAT
FROM (SELECT '2017'||LPAD(LEVEL, 2, '0') AS YEAR 
      FROM DUAL CONNECT BY LEVEL <= 12
      )T1 ,
      (SELECT  SUBSTR(reserv_date,1,6) 날짜,  
                  SUM(DECODE(A.WEEK,'1',A.sales,0)) 일요일,
                  SUM(DECODE(A.WEEK,'2',A.sales,0)) 월요일,
                  SUM(DECODE(A.WEEK,'3',A.sales,0)) 화요일,
                  SUM(DECODE(A.WEEK,'4',A.sales,0)) 수요일,
                  SUM(DECODE(A.WEEK,'5',A.sales,0)) 목요일,
                  SUM(DECODE(A.WEEK,'6',A.sales,0)) 금요일,
                  SUM(DECODE(A.WEEK,'7',A.sales,0)) 토요일   
        FROM
              (
                SELECT A.reserv_date,
                       C.product_name,
                       TO_CHAR(TO_DATE(A.reserv_date, 'YYYYMMDD'),'d') WEEK,
                       B.sales
                FROM reservation A, order_info B, item C
                WHERE A.reserv_no = B.reserv_no
                AND   B.item_id   = C.item_id
                AND   B.item_id = 'M0001'
              ) A 
        GROUP BY SUBSTR(reserv_date,1,6)
        ORDER BY SUBSTR(reserv_date,1,6)
       ) T2
WHERE T1.YEAR = T2.날짜(+)
ORDER BY 1 ;
