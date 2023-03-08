/* PL/SQL 
   이름이 있는 블록 
   -----------------
   이름
   IS
   선언부 
   BEGIN
   END;
   -----------------
   이름이 없는 블록 
   DECLARE
   선언부 
   BEGIN
   END;
*/
-- 
CREATE OR REPLACE FUNCTION my_mod(num1 NUMBER, num2 NUMBER DEFAULT 2)
 RETURN NUMBER -- 반환 타입 
IS 
 vn_remainder NUMBER :=0; -- 반환할 몫 
 vn_quotient  NUMBER :=0; -- 몫
BEGIN
 vn_quotient := FLOOR(num1 / num2);
 vn_remainder := num1 - (num2 * vn_quotient); 
 RETURN vn_remainder;
END;

SELECT my_mod(4) 
FROM dual;

--m:마이너스, p:플러스   디폴트 :p 
--입력을 받아서 
--정수 50 ~ 50000 사이의 랜덤 값으로 리턴하는 함수를 작성하시오 
SELECT DBMS_RANDOM.VALUE(50, 50000)
FROM DUAL;
-- 함수 호출 
 SELECT fn_get_coin('p')
       ,fn_get_coin('m')
       ,fn_get_coin()
 FROM dual;
 
 
 
 
 

CREATE OR REPLACE FUNCTION fn_get_coin(flag VARCHAR2 DEFAULT 'p')
 RETURN NUMBER -- 반환 타입 
IS 
 vn_coin NUMBER :=0; 
BEGIN
 vn_coin := CEIL(DBMS_RANDOM.VALUE(50, 50000));
 IF flag = 'm' THEN
    vn_coin := -vn_coin ;
 END IF;
 RETURN vn_coin;
END;
-- 국가 테이블에서 국가번호를 입력받아서 국가명을 반환하는 함수 생성 
SELECT country_name
FROM countries
WHERE country_id = 52790;
CREATE OR REPLACE FUNCTION fn_get_country_name(p_id NUMBER)
 RETURN VARCHAR2
IS
 vs_nm countries.country_name%TYPE;
 vn_cnt NUMBER;
BEGIN
 SELECT count(*)
 INTO vn_cnt
 FROM countries
 WHERE country_id = p_id; 
 
 IF vn_cnt > 0 THEN
     SELECT country_name
     INTO vs_nm
     FROM countries
     WHERE country_id = p_id; 
 ELSE 
     vs_nm := '해당국가없음';
 END IF;
 
 RETURN vs_nm;
END;

SELECT fn_get_country_name(0)
     , fn_get_country_name(52790)
FROM DUAL;

-- 학생 이름을 입력받아 수강학점(varchar2로)을 리턴하는 함수를 만드시오 
-- 학생이 없다면 '학생없음' 리턴 
-- input: VARCHAR2, return : VARCHAR2
-- 함수 이름 : fn_get_hak
SELECT fn_get_hak('최숙경')
     , fn_get_hak('양지운')
     , fn_get_hak('김길동')
FROM DUAL;

SELECT NVL(SUM(과목.학점),0)
FROM 학생, 수강내역, 과목 
WHERE 학생.학번 = 수강내역.학번(+)
AND   수강내역.과목번호 = 과목.과목번호(+)
AND   학생.이름 = '양지운';


CREATE OR REPLACE FUNCTION fn_get_hak(p_nm VARCHAR2)
 RETURN VARCHAR2
IS
 vn_hak VARCHAR2(100);
 vn_cnt NUMBER;
BEGIN
 SELECT count(*)
 INTO vn_cnt
 FROM 학생 
 WHERE 이름 = p_nm; 
 
 IF vn_cnt > 0 THEN
     SELECT NVL(SUM(과목.학점),0)
     INTO vn_hak
     FROM 학생, 수강내역, 과목 
     WHERE 학생.학번 = 수강내역.학번(+)
     AND   수강내역.과목번호 = 과목.과목번호(+)
     AND 이름 = p_nm; 
 ELSE 
     vn_hak := '학생없음';
 END IF;
 RETURN vn_hak;
END;

------------------------------------------------------------
/*  프로시저 PROCEDURE 
    함수와 비슷하지만 다른점은 서버에서 실행되며, 리턴값이 0 ~ n 가질수 있다. 
    IN: 내부에서 사용, OUT: 리턴 , IN OUT : 내부에서 사용 후 리턴 
    DML문에서 사용할 수 없음. 
    단독으로 실행 EXEC or EXECUTE
    프로시저 내에서 사용은 프로시저명*/
CREATE OR REPLACE PROCEDURE test_proc(
     p_v1 VARCHAR2, p_v2 OUT VARCHAR2, p_v3 IN OUT VARCHAR2
)
IS 
BEGIN
     DBMS_OUTPUT.PUT_LINE('p_v1 :'|| p_v1);
     DBMS_OUTPUT.PUT_LINE('p_v2 :'|| p_v2);
     DBMS_OUTPUT.PUT_LINE('p_v3 :'|| p_v3);
     p_v2 := 'out v2';
     p_v3 := 'out v3'
END;

DECLARE 
  v_v1 VARCHAR2(20) := 'A';
  v_v2 VARCHAR2(20) := 'B';
  v_v3 VARCHAR2(20) := 'C';
BEGIN
  test_proc('A', v_v2, v_v3); -- 프로시져 실행 
  DBMS_OUTPUT.PUT_LINE('v_v2:'|| v_v2);
  DBMS_OUTPUT.PUT_LINE('v_v3:'|| v_v3);
END;


----------------------------------------------------
CREATE OR REPLACE PROCEDURE ex_test1_proc
IS 
 vn_num NUMBER;
BEGIN
 vn_num := 10/0;
 DBMS_OUTPUT.PUT_LINE('success');
END;

CREATE OR REPLACE PROCEDURE ex_test2_proc
IS 
 vn_num NUMBER;
BEGIN
 vn_num := 10/0;
 DBMS_OUTPUT.PUT_LINE('success');
EXCEPTION WHEN OTHERS THEN 
 DBMS_OUTPUT.PUT_LINE('오류 발생했음.');
END;

BEGIN
 ex_test2_proc;
 DBMS_OUTPUT.PUT_LINE('정상종료');
END;






























