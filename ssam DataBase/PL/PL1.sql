/*  PL/SQL 집합적 언어와 절차적 언어의 특징을 모두 가짐 
    대량의 데이터 처리나 반복적인 처리가 있을때 효과적임 
    DB자체에서 작업하기 때문에 빠름 (JAVA, JSP사용보다)
    
    기본 단위 block 
    이름부, 선언부, 실행부, 예외처리부 
    이름부는 블록의 명칭이 오는데 생략하면 익명으록이 됨. 
*/
-- 익명블록 (테스트 or 다른 프로시져에서 사용)
DECLARE -- DECLARE (익명블록 일때)
 vn_num NUMBER := 0; 
BEGIN 
 DBMS_OUTPUT.PUT_LINE(vn_num);
 vn_num := 10 ** 10 ;
 DBMS_OUTPUT.PUT_LINE( '값:'||vn_num); 
END;
-- 실행시 블록 영역을 잡고 실행
SET SERVEROUTPUT ON


DECLARE -- DECLARE (익명블록 일때)
 vn_num CONSTANT NUMBER := 3.14; -- 상수는 선언시 값 할당해야함.
BEGIN 
 DBMS_OUTPUT.PUT_LINE(vn_num); -- 상수는 변경안됨.
END;
-- DML 문 

DECLARE 
  vs_emp_name VARCHAR2(80) ; 
  vs_dep_name departments.department_name%TYPE;
BEGIN
  SELECT a.emp_name, b.department_name
  INTO vs_emp_name, vs_dep_name -- into data
  FROM employees a, departments b
  WHERE a.department_id = b.department_id
  AND   a.employee_id = 100;
  DBMS_OUTPUT.PUT_LINE(vs_emp_name || ':'  || vs_dep_name);
END;

-- 변수선언이 필요없다면 BEGIN ~ END; 만 사용가능 
BEGIN
  DBMS_OUTPUT.PUT_LINE('3 * 1 =' || 3 * 1); 
END;

-- 기본 LOOP문 
-- EXIT 탈출 조건이 필수 
DECLARE 
 vn_base_num NUMBER := 3;
 vn_cnt      NUMBER := 1;
BEGIN -- 2 ~ 9단 출력 
 LOOP
  DBMS_OUTPUT.PUT_LINE(vn_base_num || '*'
                       || vn_cnt || '=' || vn_base_num * vn_cnt);
    vn_cnt := vn_cnt + 1;
  EXIT WHEN vn_cnt > 9; -- 조건이 true이면 루프 종료 
 END LOOP;
END;


DECLARE 
 i NUMBER := 2;
 j NUMBER ;
BEGIN -- 2 ~ 9단 출력 
 LOOP
   DBMS_OUTPUT.PUT_LINE(i || '단');
   j := 1;
   LOOP
      DBMS_OUTPUT.PUT_LINE(i || '*'|| j || '=' || i * j);
        j := j + 1;
     EXIT WHEN j > 9; 
    END LOOP; 
   i := i + 1;
   DBMS_OUTPUT.PUT_LINE('======================');
  EXIT WHEN i >9;
 END LOOP;
END;

-- WHILE
DECLARE 
 vn_base_num NUMBER := 3;
 vn_cnt      NUMBER := 1;
BEGIN -- 2 ~ 9단 출력 
 WHILE vn_cnt <=9 -- 조건이 ture일때 
 LOOP
  DBMS_OUTPUT.PUT_LINE(vn_base_num || '*'
                       || vn_cnt || '=' || vn_base_num * vn_cnt);
    vn_cnt := vn_cnt + 1;
 END LOOP;
END;

-- FOR 문 
DECLARE 
  vn_num NUMBER := 3;
BEGIN
  FOR i IN REVERSE 1..9  -->  REVERSE <--
  LOOP
--    CONTINUE WHEN i = 5; -- 조건이 ture 이면 건너뜀 
    IF i = 5 THEN 
      NULL; --- 아무 작업을 하지 않을때 문법상 어떤 로직이든 있어야함.
    ELSIF i != 5 THEN 
      DBMS_OUTPUT.PUT_LINE(vn_num ||'*'||i ||'='||vn_num*i );
    END IF;
  END LOOP;
END;

-- 1 ~50 까지 출력 짝수만 출력하시오 



BEGIN 
  FOR i IN 1..50
  LOOP
    IF MOD(i,2) = 0 THEN 
        DBMS_OUTPUT.PUT_LINE(i);
    END IF;
  END LOOP;
END;


/*
신입생이 들어왔습니다. ^^ 
신규 학생의 학번을 생성해주세요 
    
올해 첫 신입생은  2023000001(기존 학번의 max값에서 앞 4자리비교) 
다음은2023000001 + 1 
 :이름, :주소, :전공, :부전공, :생년월일 (을 입력받도록)
 1.max값 select 
 2.올해 년도와 비교 
 3.학번 생성 
 4.INSERT 
*/
DECLARE 
  vn_year  VARCHAR2(4) := TO_CHAR(SYSDATE, 'YYYY');
  vn_max   NUMBER := 0;
  vn_hakno NUMBER := 0;
BEGIN
  SELECT MAX(학번)
  INTO vn_max
  FROM 학생;
  IF SUBSTR(vn_max,1,4) = vn_year THEN 
    vn_hakno := vn_max + 1;
  ELSE 
    vn_hakno := TO_NUMBER(vn_year ||'000001');
  END IF;
  INSERT INTO 학생 (학번, 이름, 주소, 전공, 부전공, 생년월일 )
  VALUES (vn_hakno, :이름, :주소, :전공, :부전공, TO_DATE(:생년월일));
  COMMIT;
END;

select *
from 학생 ;























