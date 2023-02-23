

/*학점합계 기준 상위 5명의 학생을 출력하시오 */

SELECT a.이름
     , COUNT(b.수강내역번호) as 수강내역건수
     , SUM(NVL(c.학점,0))as 학점합계
FROM 학생 a
   , 수강내역 b
   , 과목 c
WHERE a.학번 = b.학번(+)
AND   b.과목번호 = c.과목번호(+)
GROUP BY a.학번, a.이름
ORDER BY 3 DESC;




SELECT  rownum as ranks
      , t1.*
FROM (
        SELECT a.이름
             , COUNT(b.수강내역번호) as 수강내역건수
             , SUM(NVL(c.학점,0))as 학점합계
        FROM 학생 a
           , 수강내역 b
           , 과목 c
        WHERE a.학번 = b.학번(+)
        AND   b.과목번호 = c.과목번호(+)
        GROUP BY a.학번, a.이름
        ORDER BY 3 DESC
    ) T1
WHERE rownum <=5;

/*ANSI SQL 조인 FROM 절에 조인조건이 들어감 */
-- 일반 equi-join, inner join 
SELECT *
FROM 학생, 수강내역 
WHERE 학생.학번 = 수강내역.학번 ;
-- ANSI INNER JOIN
SELECT *
FROM 학생 
INNER JOIN 수강내역 
ON (학생.학번 = 수강내역.학번)
INNER JOIN 과목 
ON (수강내역.과목번호 = 과목.과목번호)
WHERE 이름 = '최숙경';
-- 일반 OUTER JOIN
SELECT *
FROM 학생, 수강내역 
WHERE 학생.학번 = 수강내역.학번(+) ;
-- ANSI OUTER JOIN 
SELECT *
FROM 학생
LEFT OUTER JOIN(수강내역)
ON(학생.학번 = 수강내역.학번);
SELECT *
FROM 수강내역
RIGHT OUTER JOIN(학생)
ON(학생.학번 = 수강내역.학번);


SELECT *
FROM(
     SELECT   rownum as rnum
            , a.*
     FROM (
            SELECT *
            FROM 학생 
            WHERE 전공 ='경영학'
            ORDER BY 이름 DESC
         ) a
     )
WHERE rnum BETWEEN 1 AND 10;
     













CREATE TABLE HOBBY(
 CODE VARCHAR2(20 BYTE) PRIMARY KEY, 
 CODE_NM VARCHAR2(100 BYTE)
);







SELECT a.학번 
     , a.이름
     , COUNT(b.수강내역번호) as 수강건수 
FROM 학생 a
   , 수강내역 b
WHERE a.학번 = b.학번(+)
GROUP BY a.학번 
       , a.이름
ORDER BY 3 DESC;

/* 모든 학생의 총 수강 학점의 합을 구하시오 
   (학점은 과목테이블에 있음) 
*/


/*
   동등 조인 두테이블의 데이터가 동등하게 있는 row 결합 
*/

SELECT *
FROM employees;

SELECT *
FROM departments;

SELECT *
FROM employees
   , departments
WHERE employees.department_id = departments.department_id;


SELECT a.department_id -- 두테이블에 컬럼명이 같으면 한쪽을 써줘야함
     , emp_name        -- 한쪽에만 있는 컬럼은 테이블명이 없어도됨.
FROM employees a
   , departments b
WHERE a.department_id = b.department_id;


SELECT emp_name
     , department_name
FROM employees a
   , departments b
WHERE a.department_id = b.department_id;


/*full outer join 양쪽널 포함*/
DROP TABLE addr CASCADE CONSTRAINTS;
DROP TABLE hobby CASCADE CONSTRAINTS;





SELECT *
FROM addr;

SELECT *
FROM hobby;


SELECT *
FROM addr a
FULL OUTER JOIN 
hobby b
ON(a.hobby_code = b.code);

SELECT *
FROM MEMBER;

--1. 고객중 '구매이력이 없는 고객'의 정보를 출력하시오(member,cart)활용  
     --탁원재 정보 
--2. 고객중 '가장돈을 많이 쓴' 고객 구매합산금액을 출력하시오 (prod_price 사용)
     --
SELECT *
FROM member a
WHERE NOT EXISTS (SELECT *
              FROM cart 
              WHERE cart.cart_member = a.mem_id);
SELECT *
FROM member;
SELECT *
FROM cart;
SELECT *
FROM prod;

SELECT *
FROM ( SELECT  a.mem_id
             , a.mem_name
             , SUM(b.cart_qty * c.prod_price) as sum_price
        FROM member a
            ,cart b
            ,prod c
        WHERE a.mem_id = b.cart_member
        AND   b.cart_prod = c.prod_id
        GROUP BY a.mem_id
             , a.mem_name
        ORDER BY 3 desc
    )
WHERE rownum <=1;

SELECT DISTINCT cart_no
FROM cart 
WHERE cart_member = 'c001';


/*  VIEW 목적 
    1. 자주사용하는 SQL
    2. 보안        
*/
-- system 계정(DBA)에서 권한 부여 
GRANT CREATE VIEW to java;
--계정생성 
CREATE USER study IDENTIFIED BY study;
--권한부여 
GRANT RESOURCE, CONNECT TO study;




CREATE OR REPLACE VIEW emp_dep AS 
SELECT  a.employee_id
      , a.emp_name
      , a.hire_date
      , b.department_name
FROM employees a
    ,departments b 
WHERE a.department_id = b.department_id;
-- 삭제 
DROP VIEW emp_dep;

-- java 계정에서 emp_dep view를 study에게 조회할 권한을 부여 
GRANT SELECT ON emp_dep TO study;

SELECT *
-- 다른계정에서 특정계정 table,view 를 조회하려면 스키마.table or view 
FROM java.emp_dep;

/*  단순 뷰 
    - 하나의 테이블로 생성 
    - 그룹 함수 사용 불가능 
    - distinct 사용 불가능 
    - insert/update/delete 사용가능 
    복합 뷰 
    - 여러 개의 테이블로 생성 
    - 그룹 함수 사용가능 
    - distinct 사용가능 
    - insert/upate/delete 안됨 
*/
/* customers, countries, sales사용 
   (sales_month, amount_sold, country_name참고)
   2000년 이탈리아 '연평균' 매출액 보다 
   '큰 월의평균' 매출액을 구하시오 (avg 는 round사용[소수점제거] )
   tip
   (1)연평균 a
   (2)월평균 b
   (3)a.평균 < b.평균 비교 하여 월평균 출력 
*/




 
 
SELECT *
FROM (
SELECT a.mem_id
      ,a.mem_name
      ,SUM(b.cart_qty * c.prod_price) as sum_price
FROM member a
    ,cart b
    ,prod c 
WHERE a.mem_id = b.cart_member
 AND  b.cart_prod = c.prod_id 
GROUP BY a.mem_id
        ,a.mem_name
 ORDER BY 3 DESC
 ) t1
 WHERE rownum <= 1;
 


