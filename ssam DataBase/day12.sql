/* 계층형 쿼리 응용 (샘플 데이터 생성)*/
SELECT TO_CHAR(SYSDATE,'YYYY')||LPAD(LEVEL,2,'0') as months
FROM dual 
CONNECT BY LEVEL <=12;


SELECT distinct to_char(hire_date,'day')
FROM employees;


SELECT '2012'||LPAD(LEVEL,2,'0') as PERIOD
FROM dual 
CONNECT BY LEVEL <=12;

SELECT PERIOD
      ,SUM(LOAN_JAN_AMT) as amt
FROM KOR_LOAN_STATUS
WHERE PERIOD LIKE '2012%'
GROUP BY PERIOD;

SELECT a.period
     , NVL(b.amt,0) as AMT
FROM (SELECT '2012'||LPAD(LEVEL,2,'0') as PERIOD
        FROM dual 
      CONNECT BY LEVEL <=12
    )a 
   , (SELECT PERIOD
            ,SUM(LOAN_JAN_AMT) as amt
      FROM KOR_LOAN_STATUS
      WHERE PERIOD LIKE '2012%'
      GROUP BY PERIOD
    )b
WHERE a.period = b.period(+)
ORDER BY 1;


/* (년월을 입력받아서 )1~마지막날 까지 행을 만들어 
    출력하시오 2023-02-01 ~ 28 형식으로 
    ex)  입력값 :202302 or 202303 ....
*/
SELECT  TO_CHAR(LAST_DAY(TO_DATE(:a,'YYYYMM')),'DD')
FROM dual;

SELECT  TO_CHAR(TO_DATE(:a||LPAD(LEVEL,2,'0'),'YYYYMMDD'),'YYYY-MM-DD') as days
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:a,'YYYYMM')),'DD');
/*  WITH 절 
    별칭으로 사용한 SELECT문을 다른곳에서 참조가능함. 
    반복되는 쿼리가 있다면 별칭으로 만들어 변수처럼 사용가능 
    통계쿼리나, 테이블 탐색시 많이 사용 
    - temp라는 임시 테이블을 사용해 쿼리결과를 저장해놓고 사용 
      반복되는 쿼리가 건수가 많은 쿼리라면 
      변수처럼 만들어 사용시 성능이 더 좋을 수 있음 
    - 가독성이 좋음 
*/
WITH a as ( SELECT 학생.이름
                 , 학생.학번 
                 , 학생.학기 
                 , 수강내역.교시
                 , 수강내역.수강내역번호 
                 , 수강내역.과목번호 
           FROM 학생, 수강내역 
           WHERE 학생.학번 = 수강내역.학번(+)
)
,  b as (SELECT a.학번 
                ,a.이름 
                ,COUNT(a.수강내역번호) as 수강건수 
          FROM a
          GROUP BY a.학번, a.이름 
)
--, c as  (SELECT MAX(b.수강건수)
--          FROM b 
--)
SELECT *
FROM a, b;

--kor_loan_status 테이블에서 '연도별' '최종월(마지막월)'
--기준 가장 대출이 많은 도시와 잔액을 구하시오 



SELECT b2.*
FROM ( SELECT period, region, sum(loan_jan_amt) jan_amt
         FROM kor_loan_status 
         GROUP BY period, region
      ) b2,      
      ( SELECT b.period,  MAX(b.jan_amt) max_jan_amt
         FROM ( SELECT period, region, sum(loan_jan_amt) jan_amt
                  FROM kor_loan_status 
                 GROUP BY period, region
              ) b,
              ( SELECT MAX(PERIOD) max_month
                  FROM kor_loan_status
                 GROUP BY SUBSTR(PERIOD, 1, 4)
              ) a
         WHERE b.period = a.max_month
         GROUP BY b.period
      ) c   
 WHERE b2.period = c.period
   AND b2.jan_amt = c.max_jan_amt
 ORDER BY 1;




WITH b2 AS ( SELECT period, region, sum(loan_jan_amt) jan_amt
               FROM kor_loan_status 
              GROUP BY period, region
           ),
     c AS ( SELECT b.period,  MAX(b.jan_amt) max_jan_amt
              FROM ( SELECT period, region, sum(loan_jan_amt) jan_amt
                      FROM kor_loan_status 
                     GROUP BY period, region
                   ) b,
                   ( SELECT MAX(PERIOD) max_month
                       FROM kor_loan_status
                      GROUP BY SUBSTR(PERIOD, 1, 4)
                   ) a
             WHERE b.period = a.max_month
             GROUP BY b.period
           )
SELECT b2.*
  FROM b2, c
 WHERE b2.period = c.period
   AND b2.jan_amt = c.max_jan_amt
 ORDER BY 1;       
 
 
WITH a as(SELECT '팽수' as nm, 100 as num FROM dual  
          UNION 
          SELECT '홍길동', 1 FROM dual  
          UNION 
          SELECT '길동' , 10 FROM dual  
)
SELECT *
FROM a
WHERE nm like '홍%';
 
 
SELECT count(*) over() as all_count
     , a.*
FROM employees a;
 
 
SELECT department_id
     , emp_name
     , ROWNUM AS rnum
     , ROW_NUMBER() OVER(PARTITION BY department_id 
                         ORDER BY emp_name) as dep_rnum
     , ROW_NUMBER() OVER(PARTITION BY department_id, job_id
                         ORDER BY emp_name) as dep_job_rnum
FROM employees;


-- 학생중 '전공별' 이름이 가장 빠른(ㄱ ~ ) '1명'씩 출력하시오 



SELECT 이름, 전공 
FROM (
    SELECT 이름, 전공 
         , ROW_NUMBER() OVER(PARTITION BY 전공 ORDER BY 이름) as rnum
    FROM 학생 
     )
WHERE rnum = 1;
/*  rank() 건너뜀 , dense_rank() 동일 순위 있을시 번호 건너뛰지 않음*/ 
SELECT department_id
      ,emp_name
      ,salary
      ,RANK() OVER(PARTITION BY department_id 
                   ORDER BY salary desc) as rnk
      ,RANK() OVER(ORDER BY salary desc) as rnk2
      ,DENSE_RANK() OVER(PARTITION BY department_id 
                   ORDER BY salary desc) as den_rnk
FROM employees;



-- 학생의 전공별 평점 1등만 출력하시오 ;





-- CART, PROD 테이블을 활용하여 
-- 물품별 판매금액합계의 순위를 출력하시오 (상위 10개만) prod_sale 활용 



SELECT *
FROM (
        SELECT t1.*
             , RANK() OVER(ORDER BY t1.sale_amt DESC) as rnk
        FROM (
                SELECT b.prod_id
                     , b.prod_name
                     , SUM(a.cart_qty * b.prod_sale) as sale_amt
                FROM cart a
                   , prod b
                WHERE a.cart_prod = b.prod_id
                GROUP BY b.prod_id
                       , b.prod_name
            ) t1
    )
    WHERE rnk <=10;


SELECT 이름, 전공, 평점 
FROM (
        SELECT 이름 
             , 전공 
             , 평점 
             , RANK() OVER(PARTITION BY 전공 ORDER BY 평점 desc) as rnk
        FROM 학생 
     )
WHERE rnk = 1
;





