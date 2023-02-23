/* ABS(num) 절대값 리턴 */
SELECT ABS(10)
      ,ABS(-10)
      ,ABS(-10.1)
FROM dual;
/* CEIL(n) 매개변수 n과 '같거나' 가장 큰 정수 반환*/
SELECT CEIL(10.00)
     , CEIL(10.01)
     , CEIL(11.001)
FROM dual;
/* FLOOR(n) 매개변수 n 보다 작으면서 가장 큰 정수 반환 */
SELECT FLOOR(10.00)
     , FLOOR(10.01)
     , FLOOR(11.001)
FROM dual;
/* ROUND(n, i) 매개변수 n을 소수점 기준 (i+1) 번째에서 반올림
   디폴트는 0, i가 음수이면 소수점기준 왼쪽 i번째에서 반올림 
*/
SELECT ROUND(10.154)
     , ROUND(10.541)
     , ROUND(10.154, 1)
     , ROUND(10.154, 2)
     , ROUND(16, -1)
FROM DUAL;     
/* TRUNC 반올림을 하지 않고 버림 */     
SELECT TRUNC(10.154)
    ,  TRUNC(10.154, 1)
    ,  TRUNC(16, -1)
FROM DUAL;
/* MOD(m, n) m을 n으로 나누었을때 나머지 반환 */
SELECT MOD(10, 2)
     , MOD(19, 4)
FROM DUAL;

/* RTRIM, LTRIM, TRIM 공백제거 */
SELECT RTRIM(' abc ')
     , LTRIM(' abc ')
     , TRIM(' abc ')
FROM DUAL;
/* RPAD, LPAD(char, len, i) char를 len 길이만큼 i로 채움*/
SELECT LPAD(123, 5, '*')
     , LPAD(12, 5, '0')
     , LPAD(1, 5, '0')
     , RPAD(123, 5, '0')
     , RPAD(12, 5, '0')
     , RPAD(1, 5, '0')
     , RPAD(11111, 5, '0')
     , RPAD(111111, 5, '0')
FROM dual;
-- member 테이블에서 
-- MEM_REGNO1,MEM_REGNO2을 사용하여 
-- YYMMDD-숫자***** 
-- 김은대 760115-1******
SELECT mem_name ||' '|| mem_regno1
     ||'-'|| RPAD(substr(mem_regno2,1,1), 7, '*') as info
FROM member;
/* REPLACE(char,m,n) char에서 m을 찾아서 n으로 치환 */
/* TRANSLATE 한글자 단위로 변환 */
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?'
                ,'나는','너를')  as re
      ,TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?'
                ,'나는','너를')  as tr
FROM DUAL;
/*LENGTH 문자열길이, LENGTHB byte크기*/
SELECT LENGTH('대한민국')
     , LENGTHB('대한민국')
FROM DUAL;
/*날짜 함수 
  ADD_MONTHS 월을 더함 
*/
SELECT SYSDATE, ADD_MONTHS(SYSDATE, 1), ADD_MONTHS(SYSDATE, -1)
      ,SYSDATE + 1
FROM DUAL;
/* MONTH_BETWEEN 날짜 비교 (월 차이 계산)
*/
SELECT SYSDATE, MONTHS_BETWEEN(SYSDATE, ADD_MONTHS(SYSDATE, 1))
     , MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 1), SYSDATE)
FROM DUAL;
/* LAST_DAY 해당 날짜의 마지막날을 리턴*/
SELECT LAST_DAY(SYSDATE)
FROM dual;
/* NEXT_DAY(date, '요일') date를 기준으로 가장 가까운 요일날짜 반환*/
SELECT NEXT_DAY(SYSDATE, '금요일')
      ,NEXT_DAY(SYSDATE, '월요일')
FROM dual;


/* 이번달 마지막날과 남은 일짜를 출력하시오 
   23/02/28 은 d-day '' 남았습니다. (날짜끼리 연산하면 됨.)
*/


SELECT  LAST_DAY(SYSDATE) || '은 d-day '
     ||(LAST_DAY(SYSDATE)- SYSDATE) ||'일 남았습니다.'
as dday
FROM dual;

SELECT SYSDATE, ROUND(SYSDATE, 'year'), TRUNC(SYSDATE, 'month')
FROM DUAL;
/*변환함수 to_char 문자형으로 변환 
          to_date 날짜형으로 변환 
          to_number 숫자형으로 변환 
*/
SELECT TO_CHAR(123456789, '999,999,999')
     , TO_CHAR(SYSDATE, 'YYYY-MM-DD')
     , TO_CHAR(SYSDATE, 'YYMMDD HH:MI:SS')
FROM DUAL;
SELECT TO_DATE('20230213','YYYYMMDD')
     , TO_DATE('20230213')  
     , TO_DATE('2023/02/13', 'YYYY/MM/DD')  
     , TO_DATE('2023-02-13', 'YYYY-MM-DD')  
     , TO_DATE('23/02/13', 'YY/MM/DD')  
     , TRUNC(LAST_DAY(SYSDATE) - TO_DATE('20230213')  )
FROM DUAL;
SELECT '1234'
     ,  1234
FROM  dual;
CREATE TABLE ex4_1(
    col1 number
   ,col2 varchar2(1000)
);
INSERT INTO ex4_1 VALUES('1234','1234');
INSERT INTO ex4_1 VALUES('111','111');
INSERT INTO ex4_1 VALUES('99','99');
INSERT INTO ex4_1 VALUES('1111','1111');
INSERT INTO ex4_1 VALUES('1911','1911');
SELECT *
FROM ex4_1
ORDER BY TO_NUMBER(col1) desc;

SELECT *
FROM member;


SELECT emp_name
     , salary
     , commission_pct
     , salary * NVL(commission_pct,0) 
FROM employees;

/* DECODE */
SELECT cust_name
     , cust_gender
     , DECODE(cust_gender, 'F', '여자','M', '남자')
     , DECODE(cust_gender, 'F', '여자','남자')
FROM customers;

SELECT mem_name
     , mem_regno2
FROM member;

SELECT *
FROM member
WHERE substr(mem_regno2,1,1) = '3';
-- member 의 이름과 성별을 출력하시오


SELECT mem_name
     , DECODE(substr(mem_regno2,1,1),'1','남자','2','여자') as gender
FROM member;

SELECT emp_name
     , hire_date
     , to_char(hire_date,'d')
     , to_char(hire_date,'day')
FROM employees;


-- 2005년 이후 월요일에 입사한 직원만 출력하시오 
SELECT emp_name
     , hire_date
     , TO_CHAR(hire_date,'YYYY')
     , TO_CHAR(hire_date,'d')
FROM employees
WHERE TO_NUMBER(TO_CHAR(hire_date,'YYYY')) >= 2005
AND   TO_CHAR(hire_date,'d') = '2'
ORDER BY hire_date DESC;

/*customers 출생년도 컬럼을 활용하여 나이를 출력하시오  
  1937 -> 86세   110세 이상만 출력 
*/
SELECT cust_name
     , cust_year_of_birth
     , TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth
     , TO_DATE(cust_year_of_birth,'YYYY')
     , TRUNC((SYSDATE - TO_DATE(cust_year_of_birth,'YYYY'))/365) as age
     , TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(cust_year_of_birth,'YYYY')) / 12) as age2
FROM customers
WHERE TRUNC((SYSDATE - TO_DATE(cust_year_of_birth,'YYYY'))/365) >= 110;
/* 1.customers 의 출생년도를 활용하여 
   현재일자를 기준으로 30대, 40대, 50대 나머지는 '기타'로 출력하시오 정렬(젊은 고객부터 출력) 
   2.member 테이블의 regno01를 활용하여 
     나이를 출력하시오 (2074 와 같은 문제를 조심 -> 1974 )나이는 년도만 계산
*/





















