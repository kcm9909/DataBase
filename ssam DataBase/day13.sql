

-- 사번, 사원명, 급여, 해당부서의 총급여 평균급여 출력
SELECT employee_id, emp_name, salary, department_id
     , SUM(salary) OVER(PARTITION BY department_id) as 부서총급여 
     , AVG(salary) OVER(PARTITION BY department_id) as 부서평균급여 
     , ROUND(AVG(salary) OVER(),2) as 전체평균급여 
     , COUNT(*) OVER() as 전체인원 
FROM employees;
-- CUME_DIST() 누적 분포도 주어진 x값에 대한 누적 확률을 계산 
SELECT department_id 
     , emp_name
     , salary
     , ROUND(CUME_DIST() OVER(PARTITION BY department_id 
                        ORDER BY salary),3) as cume
FROM employees;
-- PERCENT_RANK() 백분위 순위 반환 0이상 1이하의 값 
-- RANK와 사용법은 값으나 특정값(수치)가 전체에서 몇퍼센트인지 계산 
SELECT department_id 
     , emp_name
     , salary
     , PERCENT_RANK() OVER(PARTITION BY department_id 
                        ORDER BY salary desc) as perank
FROM employees;
-- NTILE() 파티션별로 매개변수 값 만큼 분할한 결과를 반환 
-- NTILE(3) 1 ~ 3 사이 수를 반환 (buket 수라고 함) 
-- 3 이면 3개로 나눠담음. (로우수보다 큰 수를 명시하면 반환되는 수는 무시됨) 
SELECT department_id
     , emp_name
     , salary
     , NTILE(3) OVER(PARTITION BY department_id
                     ORDER BY salary) as buket
     , WIDTH_BUCKET(salary, 1000, 10000, 4) as buket2
FROM employees 
WHERE department_id in (30,60);
-- WIDTH_BUCKET(expr, min, max, bukets)
-- 분할결과를 반환하는데 다른점은 expr값에 따라 
-- min, max 값을 주어 bukets 만큼 분할 

/*  주어진 그룹과 순서에 따라 로우에 있는 값을 참조할때 사용 
    LAG(expr, offset, default) 선행 로우값 
    LEAD(expr, offset, default) 후행 로우값 offset :디폴트 1
*/
SELECT emp_name
      ,salary
      , department_id 
      , LAG(emp_name, 1, '가장높음') OVER(PARTITION BY department_id 
                                        ORDER BY salary desc) as ap_nm
      , LEAD(emp_name, 1, '가장낮음') OVER(PARTITION BY department_id 
                                        ORDER BY salary desc) as back_nm
FROM employees;

-- 전공별로 각 학생의 평점보다 한 단계 높은 학생과의 평점 차이를 출력하시오




SELECT 이름 
 , 전공 
 , ROUND(평점,2) as 내평점
 , LAG(이름,1,'없음') OVER(PARTITION BY 전공 ORDER BY 평점 DESC) as 나보다위
 , ROUND(LAG(평점,1,0) OVER(PARTITION BY 전공 ORDER BY 평점 DESC),2)as 나보다위평점 
 , ROUND(LAG(평점,1,평점) OVER(PARTITION BY 전공 ORDER BY 평점 DESC) - 평점,2) as 차이 
FROM 학생 ; 
/* RATIO_TO_REPORT 전체 합계 대비 비율(백분율)  */
SELECT department_id , emp_name, salary
      ,ROUND(RATIO_TO_REPORT(salary) 
           OVER(PARTITION BY department_id),2) * 100 ||'%' as raio
FROM employees
WHERE department_id IN (30,60);                          
-- 부서별 직원의 salary 합계를 구하고 (department_id null 제외)
-- 각 부서의 salary로 나가는 백분율을 구하시오 
-- ex 80 부서 44.49%  304500
--    50 부서 22.85%  156400
-- ...


    SELECT (SELECT department_name 
            FROM departments WHERE  department_id = a.department_id) as dep_nm
          , ROUND(RATIO_TO_REPORT(a.amt) OVER() * 100 ,2)   as ratio
          , a.amt
    FROM (
        SELECT department_id 
             , SUM(salary) as amt
        FROM employees
        WHERE department_id is not null
        GROUP BY department_id 
      ) a
    ORDER BY 3 desc;


SELECT (SELECT department_name 
        FROM departments WHERE  department_id = a.department_id) as dep_nm
      , SUM(a.salary) as amt
      , ROUND(RATIO_TO_REPORT(SUM(a.salary)) OVER() * 100 ,2) as ratio
FROM employees a
WHERE a.department_id IS NOT NULL
GROUP BY a.department_id 
ORDER BY 2 desc;

/*  window 절  ROWS or RANGE 
    UNBOUND PRECEDING : 파티션으로 구분된 첫 번째 행이 시작 
    UNBOUND FOLLOWING : 파티션으로 구분된 마지막 행이 끝지점 
    CURRENT ROW : 현재 행 
    BETWEEN ~ AND  시작과 끝 지점을 명시 
*/
SELECT department_id, emp_name, salary, hire_date
       ,SUM(salary) OVER(PARTITION BY department_id 
                         ORDER BY hire_date
                         ROWS BETWEEN UNBOUNDED PRECEDING
                         AND UNBOUNDED FOLLOWING )  as st_end 
       ,SUM(salary) OVER(PARTITION BY department_id 
                         ORDER BY hire_date
                         ROWS BETWEEN UNBOUNDED PRECEDING
                         AND CURRENT ROW )          as st_cur 
       ,SUM(salary) OVER(PARTITION BY department_id 
                         ORDER BY hire_date
                         ROWS BETWEEN CURRENT ROW
                         AND UNBOUNDED FOLLOWING )  as cur_end
FROM employees


--(study)계정에서 reservation, order_info 테이블 활용 
--2017년 월별 누적 매출을 출력하시오 
-- 
;
SELECT t1.*
     , SUM(t1.sale_amt) OVER(ORDER BY months
                          ROWS BETWEEN UNBOUNDED PRECEDING 
                          AND CURRENT ROW) as 누적합계 
FROM(
        SELECT SUBSTR(a.reserv_date, 1, 6) as months
             , SUM(b.sales) as sale_amt
        FROM reservation a
           , order_info b
        WHERE a.reserv_no = b.reserv_no
        AND a.reserv_date LIKE '2017%'
        GROUP BY SUBSTR(a.reserv_date, 1, 6)
    )t1;





SELECT '2017'||LPAD(LEVEL ,2,'0') as months
FROM dual
CONNECT BY LEVEL <=12;

SELECT a.months
     , NVL(b.sale_amt,0) as 월합계 
     , NVL(b.누적합계,0)  as 누적합계 
FROM (SELECT '2017'||LPAD(LEVEL ,2,'0') as months
        FROM dual
        CONNECT BY LEVEL <=12) a
   , (SELECT t1.*
             , SUM(t1.sale_amt) OVER(ORDER BY months
                                  ROWS BETWEEN UNBOUNDED PRECEDING 
                                  AND CURRENT ROW) as 누적합계 
        FROM(
                SELECT SUBSTR(a.reserv_date, 1, 6) as months
                     , SUM(b.sales) as sale_amt
                FROM reservation a
                   , order_info b
                WHERE a.reserv_no = b.reserv_no
                AND a.reserv_date LIKE '2017%'
                GROUP BY SUBSTR(a.reserv_date, 1, 6)
            )t1 ) b
WHERE a.months = b.months(+)
ORDER BY 1;
