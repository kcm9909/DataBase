CREATE TABLE 강의내역 (
     강의내역번호 NUMBER(3)
    ,교수번호 NUMBER(3)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시  NUMBER(3)
    ,수강인원 NUMBER(5)
    ,년월 date
);

CREATE TABLE 과목 (
     과목번호 NUMBER(3)
    ,과목이름 VARCHAR2(50)
    ,학점 NUMBER(3)
);

CREATE TABLE 교수 (
     교수번호 NUMBER(3)
    ,교수이름 VARCHAR2(20)
    ,전공 VARCHAR2(50)
    ,학위 VARCHAR2(50)
    ,주소 VARCHAR2(100)
);

CREATE TABLE 수강내역 (
    수강내역번호 NUMBER(3)
    ,학번 NUMBER(10)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시 NUMBER(3)
    ,취득학점 VARCHAR(10)
    ,년월 DATE 
);

CREATE TABLE 학생 (
     학번 NUMBER(10)
    ,이름 VARCHAR2(50)
    ,주소 VARCHAR2(100)
    ,전공 VARCHAR2(50)
    ,부전공 VARCHAR2(500)
    ,생년월일 DATE
    ,학기 NUMBER(3)
    ,평점 NUMBER
);


COMMIT;



/*       강의내역, 과목, 교수, 수강내역, 학생 테이블을 만드시고 아래와 같은 제약 조건을 준 뒤 
        (1)'학생' 테이블의 PK 키를  '학번'으로 잡아준다 
        (2)'수강내역' 테이블의 PK 키를 '수강내역번호'로 잡아준다 
        (3)'과목' 테이블의 PK 키를 '과목번호'로 잡아준다 
        (4)'교수' 테이블의 PK 키를 '교수번호'로 잡아준다
        (5)'강의내역'의 PK를 '강의내역번호'로 잡아준다. 
        (6)'학생' 테이블의 PK를 '수강내역' 테이블의 '학번' 컬럼이 참조한다 FK 키 설정
        (7)'과목' 테이블의 PK를 '수강내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정 
        (8)'교수' 테이블의 PK를 '강의내역' 테이블의 '교수번호' 컬럼이 참조한다 FK 키 설정
        (9)'과목' 테이블의 PK를 '강의내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정
            각 테이블에 엑셀 데이터를 임포트 

    ex) ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
        
        ALTER TABLE 수강내역 
        ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
        REFERENCES 학생(학번);

*/

ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
ALTER TABLE 수강내역 ADD CONSTRAINT PK_수강내역 PRIMARY KEY (수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINT PK_과목내역_과목번호 PRIMARY KEY (과목번호);
ALTER TABLE 교수 ADD CONSTRAINT PK_교수_교수번호 PRIMARY KEY (교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINT PK_강의내역 PRIMARY KEY (강의내역번호);


ALTER TABLE 수강내역 
ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
REFERENCES 학생(학번);

ALTER TABLE 수강내역 
ADD CONSTRAINT FK_과목번호 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_교수번호 FOREIGN KEY(교수번호)
REFERENCES 교수(교수번호);

ALTER TABLE 강의내역 
ADD CONSTRAINT FK_과목번호2 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);







SELECT a.학번
      ,a.이름
      ,b.수강내역번호 
      ,b.과목번호 
      ,b.강의실 
FROM 학생 a
   , 수강내역 b
WHERE a.학번 = b.학번 -- 동등조인, 이너조인 (값이동일할때 연결)
AND   a.이름 = '최숙경';

-- 과목이름 
SELECT a.학번
      ,a.이름
      ,b.수강내역번호 
      ,b.과목번호 
      ,b.강의실 
      ,c.과목이름  
FROM 학생 a
   , 수강내역 b
   , 과목 c 
WHERE a.학번 = b.학번 -- 동등조인, 이너조인 (값이동일할때 연결)
AND   b.과목번호 = c.과목번호 
AND   a.이름 = '최숙경';



SELECT a.학번
      ,a.이름
      ,b.수강내역번호 
      ,b.과목번호 
      ,b.강의실 
FROM 학생 a
   , 수강내역 b
WHERE a.학번 = b.학번(+); -- 외부조인, 아웃터 조인 (null 포함하는쪽 (+))


SELECT *
FROM 학생 a
   , 수강내역 b
WHERE a.학번 = b.학번(+);


/* 모든 학생의 수강내역 건수를 출력하시오 
   정렬:수강건수 내림차순 
*/

/* 전공별 학생 수를 출력하시오 (전체건수 포함) */
SELECT 전공 
     , COUNT(*) as 학생수 
FROM 학생 
GROUP BY ROLLUP(전공);

SELECT 전공 
     , COUNT(*) as 학생수 
FROM 학생 
GROUP BY 전공
UNION 
SELECT '전체' 
     , COUNT(*) 
FROM 학생 ;


/* 전체 학생의 평균 평점 보다 높은 학생을 출력하시오 
   subquery 
   3.중첩쿼리(where절사용)
*/
SELECT *
FROM 학생 
WHERE 평점 >= (SELECT AVG(평점)
              FROM 학생) ;
SELECT *
FROM 학생 
WHERE 평점 >= 3.13333333863152333333333333333333333333 ;              
              
              
-- 수강내역이 있는 학생의 학생정보를 조회하시오 
SELECT *
FROM 학생 
WHERE 학번 IN(SELECT DISTINCT 학번 
              FROM 수강내역 );
SELECT *
FROM 학생 
WHERE 학번 IN(2001211121,1997131542,1998131205
            ,1999232102,2001110131,2002110110);





SELECT a.학번
      ,a.이름
      ,b.수강내역번호 
      ,b.과목번호 
      ,b.강의실 
      , (SELECT 과목이름 
         FROM 과목 WHERE 과목번호 = b.과목번호) as 과목명 
FROM 학생 a
   , 수강내역 b
WHERE a.학번 = b.학번 -- 동등조인, 이너조인 (값이동일할때 연결)
AND   a.이름 = '최숙경';

/* 세미조인 (exists 사용)
   exists 존재하는지 , not exists 존재하지 않는 
*/
SELECT *
FROM 학생 a
WHERE EXISTS (SELECT 1 
              FROM 수강내역 
              WHERE 학번 =  a.학번);
SELECT *
FROM 학생 a
WHERE NOT EXISTS (SELECT 1 
                  FROM 수강내역 
                  WHERE 학번 =  a.학번);

--강의내역이 없는 교수의 정보를 출력하시오 

SELECT *
FROM 교수 a
WHERE NOT EXISTS (SELECT *
                  FROM 강의내역 
                  WHERE 교수번호 = a.교수번호);
SELECT *
FROM 교수 a
WHERE 교수번호 NOT IN (SELECT DISTINCT 교수번호 
                      FROM 강의내역 );
                  
                  
                  
                  

-- 입학 년도별 법학, 경제학, 경영학 학생수를 출력하시오 




SELECT SUBSTR(학번, 1,4) as 년도 
     , SUM(DECODE(전공, '법학',1, 0)) as 법학
     , SUM(DECODE(전공, '경제학',1, 0)) as 경제학
     , SUM(DECODE(전공, '경영학',1, 0)) as 경영학
FROM 학생 
GROUP BY SUBSTR(학번, 1,4) 
ORDER BY 1 ;















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






