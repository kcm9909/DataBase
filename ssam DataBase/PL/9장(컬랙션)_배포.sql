--------------------------------------------------------------------------------------------------------------------------------------------------------------------- 컬렉션 
--19
/*
 연관배열
 Associative Array 키와 값으로 구성된 컬렉션 (키를 index라고 부르기도 하기때문에 index-by 테이블 이라고도 한다. )
                   문자형이나 PLS_INTEGER 값을 사용가능
 TYPE 연관_배열명 IS TABLE OF 연관_배열_값타입 INDEX BY 인덱스타입;
*/

-- PLS_INTEGER는 -2,147,483,648에서 2,147,483,647까지 범위를 가진 숫자 타입으로, NUMBER 형에 비해 내부적으로 저장 공간을 덜 차지한다. 
DECLARE
   -- 숫자-문자 쌍의 연관배열 선언
   TYPE av_type IS TABLE OF VARCHAR2(40) INDEX BY PLS_INTEGER;
   -- 연관배열 변수 선언
   vav_test av_type;
BEGIN
  -- 연관배열에 값 할당
  vav_test(10) := '10에 대한 값';
  vav_test(20) := '20에 대한 값';
  
  --연관배열 값 출력
  DBMS_OUTPUT.PUT_LINE(vav_test(10));
  DBMS_OUTPUT.PUT_LINE(vav_test(20));

END;
--20
DECLARE
   -- 숫자-문자 쌍의 연관배열 선언
   TYPE av_type IS TABLE OF VARCHAR2(40) INDEX BY VARCHAR2(30);
        
   -- 연관배열 변수 선언
   vav_test av_type;
BEGIN
  -- 연관배열에 값 할당
  vav_test('A') := '10에 대한 값';
  vav_test('B') := '20에 대한 값';
  
  --연관배열 값 출력
  DBMS_OUTPUT.PUT_LINE(vav_test('A'));
  DBMS_OUTPUT.PUT_LINE(vav_test('B'));

END;

--21
/**
 VARRAY 
 Variavle - Size Array 는 가변 길이 배열로서 연관 배열과는 달리 '크기에 제한'이 있다. 
 즉 선언 할때 크기(요소 개수)를 지정하면 이보다 큰 수로 요소를 만들 수 없다. 
 자동으로 순번이 매겨지며 최솟값은 1이다. 
*/
DECLARE
   -- 5개의 문자형 값으로 이루어진 VARRAY 선언
   TYPE va_type IS VARRAY(5) OF VARCHAR2(20);
   -- VARRY 변수 선언
   vva_test va_type;
   vn_cnt NUMBER := 0;
BEGIN
  -- 생성자를 사용해 값 할당 (총 5개지만 최초 3개만 값 할당)
  vva_test := va_type('FIRST', 'SECOND', 'THIRD', '', '');
  
  LOOP
     vn_cnt := vn_cnt + 1;     
     -- 크기가 5이므로 5회 루프를 돌면서 각 요소 값 출력 
     IF vn_cnt > 5 THEN 
        EXIT;
     END IF;
     -- VARRY 요소 값 출력 
     DBMS_OUTPUT.PUT_LINE(vva_test(vn_cnt));
  END LOOP;
  -- 값 변경
  vva_test(2) := 'TEST';
  vva_test(4) := 'FOURTH';
  -- 다시 루프를 돌려 값 출력
  vn_cnt := 0;
  LOOP
     vn_cnt := vn_cnt + 1;     
     -- 크기가 5이므로 5회 루프를 돌면서 각 요소 값 출력 
     IF vn_cnt > 5 THEN 
        EXIT;
     END IF;
     -- VARRY 요소 값 출력 
     DBMS_OUTPUT.PUT_LINE(vva_test(vn_cnt));
  END LOOP;
END;

--22
/**
 중첩 테이블 Nested Table 컬렉션 타입의 한 종류로 중첩 테이블은 크기에 제한이 없다(숫자형 인덱스만 사용가능)
 TYPE 중첩_테이블명 IS TABLE OF 값타입;
*/

DECLARE
  -- 중첩 테이블 선언
  TYPE nt_typ IS TABLE OF VARCHAR2(10);
  
  -- 변수 선언
  vnt_test nt_typ;
BEGIN
  -- 생성자를 사용해 값 할당
  vnt_test := nt_typ('FIRST', 'SECOND', 'THIRD', ''); 
  vnt_test(4) := 'FOURTH';
  -- 값 출력
  DBMS_OUTPUT.PUT_LINE (vnt_test(1));
  DBMS_OUTPUT.PUT_LINE (vnt_test(2));
  DBMS_OUTPUT.PUT_LINE (vnt_test(3));
  DBMS_OUTPUT.PUT_LINE (vnt_test(4));
  
END;

--23
/*
 컬렉션 메소드란 컬렉션의 요소에 접근해 값을 가져오고 수정하고 삭제하는 기능을 하는 일련의 빌트인(내장형) 프로시저와 함수를 말한다. 
*/ 
-- DELETE 메소드 프로시저 타입에 : 컬렉션의 요소를 삭제
DECLARE
   -- 숫자-문자 쌍의 연관배열 선언
   TYPE av_type IS TABLE OF VARCHAR2(40) INDEX BY VARCHAR2(10);
   -- 연관배열 변수 선언
   vav_test av_type;
   vn_cnt number := 0;
BEGIN
  -- 연관배열에 값 할당
  vav_test('A') := '10에 대한 값';
  vav_test('B') := '20에 대한 값';
  vav_test('C') := '20에 대한 값';
  
  vn_cnt := vav_test.COUNT;
  DBMS_OUTPUT.PUT_LINE('삭제 전 요소 개수: ' || vn_cnt);  
  
  vav_test.DELETE('A', 'B');
  vn_cnt := vav_test.COUNT;
  DBMS_OUTPUT.PUT_LINE('삭제 후 요소 개수: ' || vn_cnt);
END;


--24
-- TRIM 메소드 메소드 프로시저 타입에 : VARRAY나 중첩 테이블의 끝에서 요소를 삭제
DECLARE
  -- 중첩 테이블 선언
  TYPE nt_typ IS TABLE OF VARCHAR2(10);
  
  -- 변수 선언
  vnt_test nt_typ;
BEGIN
  -- 생성자를 사용해 값 할당
  vnt_test := nt_typ('FIRST', 'SECOND', 'THIRD', 'FOURTH', 'FIFTH');

  -- 맨 마지막부터 2개 요소 삭제 
  vnt_test.TRIM(2);
  
  DBMS_OUTPUT.PUT_LINE(vnt_test(1));
  DBMS_OUTPUT.PUT_LINE(vnt_test(2));
  DBMS_OUTPUT.PUT_LINE(vnt_test(3));
  DBMS_OUTPUT.PUT_LINE(vnt_test(4));
  
  EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE( DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;


--25
-- EXTEND 메소드 프로시저 타입에 : VARRAY나 중첩 테이블의 끝에서 요소를 추가
DECLARE
  -- 중첩 테이블 선언
  TYPE nt_typ IS TABLE OF VARCHAR2(10);
  
  -- 변수 선언
  vnt_test nt_typ;
BEGIN
  -- 생성자를 사용해 값 할당
  vnt_test := nt_typ('FIRST', 'SECOND', 'THIRD');

  -- 맨 끝에 NULL 요소 추가한 뒤 값 할당 후 출력
  vnt_test.EXTEND;
  vnt_test(4) := 'fourth';
  DBMS_OUTPUT.PUT_LINE(vnt_test(4));
  
  -- 맨 끝에 첫 번째 요소를 2개 복사해 추가 후 출력
  vnt_test.EXTEND(2, 1);
  DBMS_OUTPUT.PUT_LINE('첫번째 : ' || vnt_test(1));
  -- 첫 번째 요소를 복사해 2개 추가했으므로 추가된 요소는 5, 6
  DBMS_OUTPUT.PUT_LINE('추가한 요소1 : ' || vnt_test(5));
  DBMS_OUTPUT.PUT_LINE('추가한 요소2 : ' || vnt_test(6));

END;
--26
-- FIRST와 LAST 메소드 함수 타입에 : 컬렉션의 첫번째 인덱스 반환, 마지막인덱스 반환
DECLARE
  -- 중첩 테이블 선언
  TYPE nt_typ IS TABLE OF VARCHAR2(10);
  
  -- 변수 선언
  vnt_test nt_typ;
BEGIN
  -- 생성자를 사용해 값 할당
  vnt_test := nt_typ('FIRST', 'SECOND', 'THIRD', 'FOURTH', 'FIFTH');

  -- FIRST와 LAST 메소드를 FOR문에서 사용해 컬렉션 값을 출력
  FOR i IN vnt_test.FIRST..vnt_test.LAST
  LOOP
  
     DBMS_OUTPUT.PUT_LINE(i || '번째 요소 값: ' || vnt_test(i));
  END LOOP;

END;

--27
-- COUNT와 LIMIT 메소드 함수 타입에 : 컬렉션의 요소의 총 수를 반환, 컬렉션이 가질 수 있는 요소의 최대 수를 반환

DECLARE
  
  TYPE nt_typ IS TABLE OF VARCHAR2(10);      -- 중첩테이블 선언
  TYPE va_type IS VARRAY(5) OF VARCHAR2(10); -- VARRAY 선언
 
  -- 변수 선언
  vnt_test nt_typ;
  vva_test va_type;
BEGIN
  -- 생성자를 사용해 값 할당
  vnt_test := nt_typ('FIRST', 'SECOND', 'THIRD', 'FOURTH'); -- 중첩테이블
  vva_test := va_type('첫번째', '두번째', '세번째', '네번째'); -- VARRAY
  
  DBMS_OUTPUT.PUT_LINE('VARRAY COUNT: ' || vva_test.COUNT);
  DBMS_OUTPUT.PUT_LINE('중첩테이블 COUNT: ' || vnt_test.COUNT);

  DBMS_OUTPUT.PUT_LINE('VARRAY LIMIT: ' || vva_test.LIMIT); 
  DBMS_OUTPUT.PUT_LINE('중첩테이블 LIMIT: ' || vnt_test.LIMIT);  

END;

--28
-- PRIOR와 NEXT
DECLARE
  TYPE va_type IS VARRAY(5) OF VARCHAR2(10); -- VARRAY 선언
  -- 변수 선언
  vva_test va_type;
BEGIN
  -- 생성자를 사용해 값 할당
  vva_test := va_type('첫번째', '두번째', '세번째', '네번째'); -- VARRAY
  
  DBMS_OUTPUT.PUT_LINE('FIRST의 PRIOR : ' || vva_test.PRIOR(vva_test.FIRST));
  DBMS_OUTPUT.PUT_LINE('LAST의 NEXT : ' || vva_test.NEXT(vva_test.LAST));

  DBMS_OUTPUT.PUT_LINE('인덱스3의 PRIOR :' || vva_test.PRIOR(3));
  DBMS_OUTPUT.PUT_LINE('인덱스3의 NEXT :' || vva_test.NEXT(3));

END;

--29
-- 사용자 정의 데이터 타입 (유형 트리에 생성됨)
-- 5개의 문자형 값으로 이루어진 VARRAY 사용자정의타입 선언
CREATE OR REPLACE TYPE ch11_va_type IS VARRAY(5) OF VARCHAR2(20);

--30
-- 문자형 값의 중첩테이블 사용자정의타입 선언
CREATE OR REPLACE TYPE ch11_nt_type IS TABLE OF VARCHAR2(20);


--31
-- 사용자정의타입인 va_type와 nt_type 사용
DECLARE
   vva_test ch11_va_type;  -- VARRAY인 va_type 변수선언   
   vnt_test ch11_nt_type;  -- 중첩테이블인  nt_type 변수선언   

BEGIN
    -- 생성자를 사용해 값 할당 (총 5개지만 최초 3개만 값 할당)
    vva_test := ch11_va_type('FIRST', 'SECOND', 'THIRD', '', '');
    vnt_test := ch11_nt_type('FIRST', 'SECOND', 'THIRD', '');
    
    DBMS_OUTPUT.PUT_LINE('VARRAY의 1번째 요소값: ' || vva_test(1));
    DBMS_OUTPUT.PUT_LINE('중첩테이블의 1번째 요소값: ' || vnt_test(1));

END;


-- 컬렉션 타입별 차이점과 활용
-- 다차원 컬렉션
--32
DECLARE
    -- 첫 번째 VARRAY 타입선언 (구구단중 각단 X5값을 가진  요소를 갖는 VARRAY )
    TYPE va_type1 IS VARRAY(5) OF NUMBER;
    
    -- 위에서 선언한 va_type1을 요소타입으로 하는 VARRAY 타입 선언 (구구단중 1~3단까지 요소를 갖는 VARRAY)
    TYPE va_type11 IS VARRAY(3) OF va_type1;
    -- 두번째 va_type11 타입의 변수 선언 
    va_test va_type11;
BEGIN
    -- 생성자를 이용해 값 초기화, 
    va_test := va_type11( va_type1(1, 2, 3, 4, 5), 
                          va_type1(2, 4, 6, 8, 10),
                          va_type1(3, 6, 9, 12, 15)
                       );
                        
   -- 구구단 출력                               
   DBMS_OUTPUT.PUT_LINE('2곱하기 3은 ' || va_test(2)(3));             
   DBMS_OUTPUT.PUT_LINE('3곱하기 5는 ' || va_test(3)(5));               

END;


--33
DECLARE
    -- 요소타입을 employees%ROWTYPE 로 선언, 즉 테이블형 레코드를 요소 타입으로 한 중첩테이블 
    TYPE nt_type IS TABLE OF employees%ROWTYPE;

   -- 중첩테이블 변수선언
   vnt_test nt_type;
BEGIN
  -- 빈 생성자로 초기화
  vnt_test := nt_type();
  
  -- 중첩테이블에 요소 1개 추가 
  vnt_test.EXTEND;
  
  -- 사원테이블에서 100번 사원의 정보를 가져온다. 
  SELECT *
     INTO vnt_test(1) -- 위에서 요소1개를 추가했으므로 인덱스는 1
    FROM employees
   WHERE employee_id = 100;
   
  -- 100반 사원의 사번과 성명 출력
  DBMS_OUTPUT.PUT_LINE(vnt_test(1).employee_id);
  DBMS_OUTPUT.PUT_LINE(vnt_test(1).emp_name);

END;


--34
DECLARE
    -- 요소타입을 employees%ROWTYPE 로 선언, 즉 테이블형 레코드를 요소 타입으로 한 중첩테이블 
    TYPE nt_type IS TABLE OF employees%ROWTYPE;

   -- 중첩테이블 변수선언
   vnt_test nt_type;
BEGIN
  -- 빈 생성자로 초기화
  vnt_test := nt_type();
  
  -- 사원테이블 전체를 중첩테이블에 담는다. 
  FOR rec IN ( SELECT * FROM employees) 
  LOOP
     -- 요소 1개 추가 
     vnt_test.EXTEND;
     
     -- LAST 메소드를 사용하면 항상 위에서 추가한 요소의 인덱스를 가져온다. 
     vnt_test ( vnt_test.LAST) := rec;
     
  END LOOP;
   
  -- 출력
  FOR i IN vnt_test.FIRST..vnt_test.LAST
  LOOP
       DBMS_OUTPUT.PUT_LINE(vnt_test(i).employee_id || ' - ' ||   vnt_test(i).emp_name);
  END LOOP;

END;
