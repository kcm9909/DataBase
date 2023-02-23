-----------1번 문제 ---------------------------------------------------
--1988년 이후 출생자의 직업이 의사,자영업 고객을 출력하시오 (어린 고객부터 출력)
---------------------------------------------------------------------
DESC CUSTOMER;
SELECT *
FROM CUSTOMER
WHERE JOB IN ('의사', '자영업')  
AND TO_NUMBER(SUBSTR(BIRTH, 1, 4)) >= 1988
ORDER BY BIRTH DESC;
-----------2번 문제 ---------------------------------------------------
--'강남구'에 사는 고객의 이름, 전화번호를 출력하시오 
---------------------------------------------------------------------
SELECT a.customer_name
     , a.phone_number
FROM CUSTOMER a
   , ADDRESS b
WHERE a.zip_code = b.zip_code
AND b.address_detail = '강남구';
----------3번 문제 ---------------------------------------------------
--CUSTOMER에 있는 회원의 직업별 회원의 수를 출력하시오 (직업 NULL은 제외)
---------------------------------------------------------------------
SELECT job
     , count(*) cnt 
FROM customer
WHERE job IS NOT NULL
GROUP BY job
ORDER BY 2 desc;
----------4-1번 문제 ---------------------------------------------------
-- 가장 많이 가입(처음등록)한 요일과 건수를 출력하시오 
---------------------------------------------------------------------
SELECT *
FROM (
        SELECT TO_CHAR(first_reg_date, 'DAY') as 요일 
             , COUNT(*) as  cnt 
        FROM customer 
        GROUP BY TO_CHAR(first_reg_date, 'DAY')
        ORDER BY 2 desc
    ) 
WHERE rownum <= 1;
----------4-2번 문제 ---------------------------------------------------
-- 남녀 인원수를 출력하시오 
---------------------------------------------------------------------
SELECT DECODE(gender, 'F','여자','M','남자','N','미등록','합계') as gender
      ,cnt
FROM (
        SELECT gender 
             , COUNT(*) as cnt 
        FROM (
                SELECT  DECODE(sex_code,NULL, 'N', sex_code) as gender
                FROM customer
              )
        GROUP BY ROLLUP(gender)
     );

-- GROUPING_ID 그룹에 대한 정보 출력 
SELECT CASE WHEN sex_code = 'F' THEN '여자'
            WHEN sex_code = 'M' THEN '남자'
            WHEN sex_code IS NULL and GROUPID = 0 THEN '미등록'
            WHEN GROUPID = 1 THEN '합계'
        END as gender
       , cnt
FROM (
        SELECT sex_code
             , GROUPING_ID(sex_code) groupid
             , COUNT(*) as cnt
        FROM customer
        GROUP BY ROLLUP(sex_code)
     );

SELECT sex_code
     , job
     , GROUPING_ID(sex_code, job)
     , count(*)
FROM customer
WHERE sex_code IS NOT NULL
AND   job IS NOT NULL
GROUP BY ROLLUP(sex_code, job)
;


----------5번 문제 ---------------------------------------------------
--월별 예약 취소 건수를 출력하시오 (많은 달 부터 출력)
SELECT TO_CHAR(TO_DATE(RESERV_DATE),'MM') AS 월
     , COUNT(*) AS 취소건수
FROM reservation
WHERE cancel = 'Y'
GROUP BY TO_CHAR(TO_DATE(RESERV_DATE),'MM') 
ORDER BY 2 desc;

SELECT LPAD(LEVEL, 2, '0') as 월 
FROM dual 
CONNECT BY LEVEL <= 12;

SELECT a.월 
      ,NVL(b.취소건수 ,0) AS 취소건수 
FROM (SELECT LPAD(LEVEL, 2, '0') as 월 
        FROM dual 
        CONNECT BY LEVEL <= 12) a
    ,(SELECT TO_CHAR(TO_DATE(RESERV_DATE),'MM') AS 월
             , COUNT(*) AS 취소건수
        FROM reservation
        WHERE cancel = 'Y'
        GROUP BY TO_CHAR(TO_DATE(RESERV_DATE),'MM') 
     ) b
WHERE a.월 = b.월(+)
ORDER BY 1
;

---------------------------------------------------------------------
----------6번 문제 ---------------------------------------------------
 -- 전체 상품별 '상품이름', '상품매출' 을 내림차순으로 구하시오 
-----------------------------------------------------------------------------
SELECT b.product_name as 상품이름 
     , SUM(a.sales)   as 상품매출 
FROM order_info a
   , item b
WHERE a.item_id = b.item_id
GROUP BY a.item_id, b.product_name
ORDER BY 2 desc; 
---------- 7번 문제 ---------------------------------------------------
-- 모든상품의 월별 매출액을 구하시오 
-- 매출월, SPECIAL_SET, PASTA, PIZZA, SEA_FOOD, STEAK, SALAD_BAR, SALAD, SANDWICH, WINE, JUICE
----------------------------------------------------------------------------
SELECT SUBSTR(a.reserv_date,1,6) as 매출월 
     , SUM(DECODE(b.item_id,'M0001',b.sales, 0)) as  SPECIAL_SET
    , SUM(DECODE(b.item_id,'M0002',b.sales, 0)) as  PASTA
    , SUM(DECODE(b.item_id,'M0003',b.sales, 0)) as  PIZZA
    , SUM(DECODE(b.item_id,'M0004',b.sales, 0)) as  SEA_FOOD
    , SUM(DECODE(b.item_id,'M0005',b.sales, 0)) as  STEAK
    , SUM(DECODE(b.item_id,'M0006',b.sales, 0)) as  SALAD_BAR
    , SUM(DECODE(b.item_id,'M0007',b.sales, 0)) as  SALAD
    , SUM(DECODE(b.item_id,'M0008',b.sales, 0)) as  SANDWICH
    , SUM(DECODE(b.item_id,'M0009',b.sales, 0)) as  WINE
    , SUM(DECODE(b.item_id,'M0010',b.sales, 0)) as  JUICE
FROM reservation a
    ,order_info b
WHERE a.reserv_no = b.reserv_no
GROUP BY SUBSTR(a.reserv_date,1,6);
    
---------- 8번 문제 ---------------------------------------------------
-- 월별 온라인_전용 상품 매출액을 일요일부터 월요일까지 구분해 출력하시오 
-- 날짜, 상품명, 일요일, 월요일, 화요일, 수요일, 목요일, 금요일, 토요일의 매출을 구하시오 
----------------------------------------------------------------------------
SELECT 월 
      ,상품명 
      ,SUM(DECODE(week,'1', sales, 0)) as 일요일
      ,SUM(DECODE(week,'2', sales, 0)) as 월요일
      ,SUM(DECODE(week,'3', sales, 0)) as 화요일
      ,SUM(DECODE(week,'4', sales, 0)) as 수요일
      ,SUM(DECODE(week,'5', sales, 0)) as 목요일
      ,SUM(DECODE(week,'6', sales, 0)) as 금요일
      ,SUM(DECODE(week,'7', sales, 0)) as 토요일
FROM (
        SELECT SUBSTR(a.reserv_date,1,6) as 월, c.product_name as 상품명, b.sales 
             , TO_CHAR(TO_DATE(a.reserv_date),'d') as week
        FROM reservation a
            ,order_info b
            ,item c 
        WHERE a.reserv_no = b.reserv_no
        AND   b.item_id = c.item_id 
        AND c.product_desc = '온라인_전용상품'
     )
GROUP BY  월 
         ,상품명 
ORDER BY 1;

---------- 9번 문제 ----------------------------------------------------
-- 고객수, 남자인원수, 여자인원수, 평균나이, 평균거래기간(월기준)을 구하시오 
-- (성별 NULL 제외, 생일 NULL  제외, MONTHS_BETWEEN, AVG, ROUND 사용(소수점 1자리 까지) 나이계산 
----------------------------------------------------------------------------
SELECT count(customer_id) as 고객수 
     , SUM(DECODE(sex_code,'M',1,0)) as 남자 
     , SUM(DECODE(sex_code,'F',1,0)) as 여자
     , ROUND(AVG(MONTHS_BETWEEN(SYSDATE, TO_DATE(birth)) / 12),1) as 평균나이
     , ROUND(AVG(MONTHS_BETWEEN(SYSDATE,first_reg_date)/12),1) as 거래기간_년 
FROM customer
WHERE sex_code IS NOT NULL
AND   birth IS NOT NULL;
---------- 10번 문제 ----------------------------------------------------
--매출이력이 있는 고객의 주소, 우편번호, 해당지역 고객수를 출력하시오
----------------------------------------------------------------------------
SELECT t2.address_detail
     , COUNT(T1.customer_id)  as cnt 
FROM (SELECT DISTINCT a.customer_id
         , a.zip_code 
    FROM customer a 
        ,reservation b
        ,order_info c 
    WHERE a.customer_id = b.customer_id
    AND   b.reserv_no = c.reserv_no ) T1
    ,address T2 
WHERE T1.zip_code = T2.zip_code
GROUP BY t2.zip_code, t2.address_detail
ORDER BY 2 desc;

