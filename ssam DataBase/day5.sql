
--UNION 합집합(중복제거)  UNION ALL 전체합  MINUS 차집합  INTERSECT 교집합

SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION   -- 중복제거 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'; 

SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION ALL -- 중복허용 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
 UNION ALL
 SELECT '컴퓨터'
 FROM dual;
     
------------------------------------- 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
INTERSECT -- 교집합 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'; 
 
 
 
------------------------------------- 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
MINUS -- 차집합 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';  
 

SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'   
MINUS
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국';   
------------------------------------- 
- 컬럼의 수와 타입이 맞아야함. 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION 
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '일본'; 
 
 
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '한국'
INTERSECT  -- 교집합 
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '일본';  


 -----------정렬은 마지막에만 가능 
 SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
  ORDER BY goods;  
  
  
  --- 행별 컬럼의 수와 타입은 같아야 함. 
 SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION
SELECT  seq, goods
  FROM exp_goods_asia
 WHERE country = '일본'
 UNION 
 SELECT 100, 'hi'
 FROM dual
  ORDER BY goods;  

/*
  집계함수 
  대상 데이터를 특정 그룹으로 묶은 다음 그룹에 대한 
  총합, 평균, 최댓값, 최솟값, 건수 등을 구하는 함수.
*/
SELECT COUNT(*)                      -- * 전체 null포함 
     , COUNT(department_id)          --  ALL default 
     , COUNT(ALL department_id)      -- 중복포함 
     , COUNT(DISTINCT department_id) --중복자료는 제거 
FROM employees;

SELECT SUM(salary)            -- 전체합 
     , ROUND(AVG(salary),2)   -- 평균 
     , MIN(salary)            -- 최소 
     , MAX(salary)            -- 최대 
FROM employees;

-- employees 전체 직원의 수와 salary의 최고값, 최소값을 출력하시오
-- 60부서와 110번 부서의 직원수, 최소급여, 최대급여를 출력하시오 
 

SELECT COUNT(*)    as 직원수  
      ,MIN(salary) as 최소급여
      ,MAX(salary) as 최대급여 
FROM employees
WHERE department_id = 60
UNION
SELECT COUNT(*)    as 직원수  
      ,MIN(salary) as 최소급여
      ,MAX(salary) as 최대급여 
FROM employees
WHERE department_id = 110
UNION
SELECT COUNT(*)    as 직원수  
      ,MIN(salary) as 최소급여
      ,MAX(salary) as 최대급여 
FROM employees
WHERE department_id = 10
UNION
SELECT COUNT(*)    as 직원수  
      ,MIN(salary) as 최소급여
      ,MAX(salary) as 최대급여 
FROM employees
WHERE department_id = 10
;
/* GROUP BY 와 HAVING 절 
   GROUP BY 는 특정 그룹으로 묶어 데이터를 집계 할 수 있다. 
   그룹 쿼리는 사용하면 SELECT 리스트에 있는 컬럼명이나 
   표현식 중 '집계 함수'를 '제외'하고 '모두' GROUP BY 절에 명시해야함. 
*/
-- 부서별 총 급여 
SELECT department_id
     , SUM(salary) as 부서별합계 
FROM employees 
WHERE department_id is not null
GROUP BY department_id
HAVING SUM(salary) >= 20000
ORDER BY 1;

-- 부서별 직군별 salary의 평균 
SELECT department_id 
     , job_id 
     , COUNT(employee_id) as 직원수 
     , AVG(salary) as 부서직군별평균급여
FROM employees
GROUP BY department_id 
       , job_id 
ORDER BY 1 ;

/* member 회원의 직업별 회원수와 마일리지 
   평균, 합계를 출력하시오(평균은 소수점 둘째자리까지, 정렬은 회원수 내림차순)
*/
SELECT mem_job
     , COUNT(*)                  as 회원수 
     , ROUND(AVG(mem_mileage),2) as 평균마일리지 
     , SUM(mem_mileage)          as 마일리지합계 
FROM member
GROUP BY mem_job
HAVING COUNT(*) >=2
ORDER BY 2 DESC;

-- KOR_LOAN_STATUS 테이블을 활용하여 
-- '2013'년도 <<--검색조건 
-- '기간별', '지역별' <--그룹 
-- '총대출잔액'을 <-- 집계대상  출력하시오



SELECT substr(period,1,4) as 기간 
     , region as 지역 
     , SUM(loan_jan_amt) as 합계 
FROM kor_loan_status
WHERE period like '2013%'
GROUP BY substr(period,1,4)
    , region 
ORDER BY 1;

/* member 회원의 생일 요일별 회원수를 출력하시오 */

SELECT DISTINCT department_id -- 중복제거 
FROM employees;

SELECT prod_category
      ,prod_subcategory
FROM products
GROUP BY prod_category
        ,prod_subcategory
ORDER BY 1;



SELECT TO_CHAR(mem_bir,'day') as 요일 
     , COUNT(mem_bir) as 회원수 
FROM member
GROUP BY TO_CHAR(mem_bir,'day')
ORDER BY 2 ;




SELECT TO_CHAR(mem_bir,'d') as 요일 
     , COUNT(mem_bir) as 회원수 
FROM member
GROUP BY TO_CHAR(mem_bir,'d') ;





SELECT department_id
     , job_id
     , COUNT(*)
     , SUM(salary)
FROM employees
WHERE department_id is not null
GROUP BY ROLLUP(department_id, job_id) ;

/* 서브쿼리 SUB QUERY
   SQL문장 안에 보조로 사용되는 또 다른 SELECT문 
   1.일반 서브쿼리(스칼라서브쿼리) : select절 
   2.인라인 뷰 : from 절 
   3.중첩쿼리  : where절 
*/
SELECT a.emp_name
     , (SELECT department_name 
        FROM departments 
        WHERE department_id = a.department_id ) as 부서명 
     -- job_id를 사용하여 jobs 테이블에서 job_title을 출력하시오 
     , (SELECT job_title
        FROM jobs
        WHERE job_id = a.job_id ) as 직업명 
FROM employees a;   -- table 별칭
-- 2.from절 인라인 뷰 

SELECT  DECODE(요일, '1','일요일','2','월요일','3','화요일'
                    ,'4','수요일','5','목요일','6','금요일'
                    , '토요일') as day
      , 회원수 
FROM ( SELECT TO_CHAR(mem_bir,'d') as 요일 
             , COUNT(mem_bir) as 회원수 
        FROM member
        GROUP BY TO_CHAR(mem_bir,'d')
     ) a
ORDER BY 요일 ;

-- 의사컬럼: 테이블에는 없지만 있는것 처럼 사용 
SELECT  rownum as rnum
      , a.*
FROM ( SELECT mem_name
            , mem_mileage
       FROM member
       ORDER BY mem_name
      ) a ;

/*kor_loan_status 테이블을 사용하여 
  년도별, 기타대출, 주택담보대출의 합계화 총계를 구하시오 출력하시오 
  tip 1. 필요한 행을 만든다.
      2. 집계를 한다.      
      (인라인 뷰를 쓰면 편함.), 안써도 가능(group by 규칙만 지키면)
     substr, decode, group by, rollup, sum 사용함.      
*/














