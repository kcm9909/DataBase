SELECT *
FROM tb_info;

/* Description 설명 글 
   COMMENT ON TABLE 테이블명 IS '설명'
   COMMENT ON COLUMN 테이블.컬럼명 IS '설명'
*/
COMMENT ON TABLE TB_INFO IS '2023.01반';
COMMENT ON COLUMN TB_INFO.INFO_NO IS '번호';
COMMENT ON COLUMN TB_INFO.PC_NO IS 'PC번호';
COMMENT ON COLUMN TB_INFO.NM IS '이름';
COMMENT ON COLUMN TB_INFO.EMAIL IS '이메일주소';
COMMENT ON COLUMN TB_INFO.HOBBY IS '취미';
SELECT *
FROM all_tab_comments
WHERE owner ='JAVA';

/*  제약조건 외래키 FOREIGN KEY 는 
    참조하는 테이블의 컬럼이 PK이 여야함 
    만약 참조하는 PK가 2개의 컬럼으로 되어있다면 2개다 참조해야함.
*/
CREATE TABLE dep(
      deptno   NUMBER(3) PRIMARY KEY
     ,deptname VARCHAR2(100)
     ,floor    NUMBER(5)
);
CREATE TABLE emp(
      empno NUMBER(5) PRIMARY KEY
     ,empname VARCHAR2(100)
     ,title VARCHAR2(20)
     ,dno NUMBER(3) CONSTRAINT emp_fk REFERENCES dep(deptno)
);
INSERT INTO DEP VALUES(1, '영업', 8);
INSERT INTO DEP VALUES(2, '기획', 10);
INSERT INTO DEP VALUES(3, '개발', 1);
INSERT INTO EMP VALUES(2016, '김창섭', '대리', 2);
INSERT INTO EMP VALUES(2017, '이수민', '과장', 1);
INSERT INTO EMP VALUES(2018, '조민희', '부장', 3);
INSERT INTO EMP VALUES(2019, '조민희', '사원', 4); -- 제약조건 오류 

SELECT deptname 
     , floor
     , deptno
FROM dep;
SELECT empname
     , title   
     , dno
FROM emp;

SELECT emp.empname
     , emp.title
     , dep.deptname
     , dep.floor
     , emp.dno
     , dep.deptno
FROM emp
    ,dep
WHERE emp.dno = dep.deptno
AND   emp.empname = '이수민';


/*문자 연산자 */
SELECT employee_id
     , emp_name
     , employee_id || ':' || emp_name as emp_info
FROM employees;
/*수식 연산자 +, *, -, / */
SELECT employee_id
     , emp_name
     , round(salary / 30,2)   as 일당 
     , salary                 as 월급
     , salary - salary * 0.1  as 실수령액 
     , salary * 12            as 연봉 
FROM employees;
/*논리 연산자 > < >= <= = <> != ^=*/
SELECT * FROM employees WHERE salary = 2600 ;  -- 같다 
SELECT * FROM employees WHERE salary <> 2600 ; -- 같지 않음 
SELECT * FROM employees WHERE salary != 2600 ; -- 같지 않음  
SELECT * FROM employees WHERE salary ^= 2600 ; -- 같지 않음  
SELECT * FROM employees WHERE salary < 2600 ;  -- 미만
SELECT * FROM employees WHERE salary > 2600 ;  -- 초과 
SELECT * FROM employees WHERE salary <= 2600 ; -- 이하 
SELECT * FROM employees WHERE salary >= 2600 ; -- 이상 
-- 부서가 30, 60 이 아닌 직원을 조회하시오 
SELECT emp_name
     , department_id
FROM employees
WHERE department_id != 30
AND   department_id ^= 60
ORDER BY 2 asc;


-- products 테이블에서 (정렬 조건 상품최저금액 내림차순)
-- 상품최저금액 35원 이상 50원 미만의 상품명을 조회하시오 

SELECT prod_name
     , prod_min_price
FROM products
WHERE prod_min_price >= 35
AND   prod_min_price < 50
ORDER BY 2 DESC;

/* salary가 
   5000 이하 C등급 
   5000 초과 15000 이하 B등급 
   그이상은 A등급 
*/
SELECT emp_name
     , salary
     , CASE WHEN salary <= 5000 THEN 'C등급'
            WHEN salary > 5000  AND salary <= 15000 THEN 'B등급'
            ELSE 'A등급' 
       END as salary_grade
FROM employees
ORDER BY 2 DESC;

/* CUSTOMERS 테이블에서 
   성별 컬럼의 F -> 여자 , M -> 남자 로 출력하시오 
   이름, 탄생년도, 성별, 도시, 이메일 
   CUST_CREDIT_LIMIT가 10000이상의 , 솔로만 ,  1984년 이후출생
*/
SELECT cust_name
     , CASE WHEN cust_gender = 'F' THEN '여자'
            WHEN cust_gender = 'M' THEN '남자'
       END as gender
     , cust_year_of_birth
     , cust_marital_status
     , cust_city
     , cust_email 
FROM CUSTOMERS
WHERE cust_marital_status = 'single'
AND cust_credit_limit >= 10000  
AND cust_year_of_birth >= 1984;

-- BETWEEN A AND B   a ~ b 
SELECT employee_id 
    , emp_name
    , salary
FROM employees
WHERE salary BETWEEN 2000 AND 2500;
-- IN 조건식 **
SELECT employee_id 
    , emp_name
    , salary
    , department_id
FROM employees
--WHERE department_id IN (10, 20, 30);     -- 10,20,30부서만 
WHERE department_id NOT IN (10, 20, 30);   -- 10,20,30이 아닌 
--LIKE *** 
SELECT emp_name
FROM employees
--WHERE emp_name LIKE 'A%' ;  -- A로 시작하는 모든 
--WHERE emp_name LIKE '%d' ;  -- d로 끝나는 모든 
WHERE emp_name LIKE '%fer%' ; -- fer이 포함된 
CREATE TABLE ex3_1(
    nm VARCHAR2(100)
);
INSERT INTO ex3_1 VALUES('길동');
INSERT INTO ex3_1 VALUES('홍길동');
INSERT INTO ex3_1 VALUES('김길동');
INSERT INTO ex3_1 VALUES('홍길동상');
SELECT * 
FROM ex3_1
WHERE nm LIKE '_길동';
--우리반 학생중 김씨만 조회하시오 
SELECT *
FROM TB_INFO
WHERE hobby is null;  -- null 검색은 is null or is not null

/* 문자열 함수 substr, replace, lower, upper, trim 많이 사용*/

SELECT emp_name
     , LOWER(emp_name) as low
     , UPPER(emp_name) as up
FROM employees
WHERE LOWER(emp_name) LIKE '%'|| LOWER('Donald') ||'%'; -- '%donald%'

SELECT emp_name
     , LOWER(emp_name) as low
     , UPPER(emp_name) as up
FROM employees
WHERE emp_name LIKE '%donald%';

/*  SUBSTR(char, pos, len) char의 대상 문자열에서 pos 번째 문자부터 
                    len 길이만큼 자른뒤 반환 (디폴트 1,음수 뒤부터 )
*/
SELECT SUBSTR('ABCD EFG', 1, 4)  -- 1인덱스 부터 4자리 
     , SUBSTR('ABCD EFG', 2)     -- 2인덱스 부터 끝까지 
     , SUBSTR('ABCD EFG', -1)    -- 뒤에서부터 1개 
     , SUBSTR('ABCD EFG', -4, 3) -- 뒤에서4번째 부터 오른쪽으로 3개 
FROM DUAL;  --<-- dual 테스트 테이블 
/*INSTR(str, str2, pos, occur) 일치하는 위치 반환 
  str 에서 str2를 찾는데 pos에서부터 occur 몇번째 위치하는지 
  디폴트 1
*/
SELECT INSTR('ABCDABEFAB', 'AB')
      ,INSTR('ABCDABEFAB', 'AB', 1 ) 
      ,INSTR('ABCDABEFAB', 'AB', 1 , 2) 
      ,INSTR('ABCDABEFAB', 'AB', 4 , 2) 
FROM dual;
      



































