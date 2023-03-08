
CREATE OR REPLACE FUNCTION fn_hash(pw VARCHAR2)
 RETURN VARCHAR2
IS
  input_string  VARCHAR2 (200) := pw;  
  input_raw     RAW(128);                        -- 입력 RAW 데이터 
  encrypted_raw RAW (2000); -- 암호화 데이터 
BEGIN
  input_raw := UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8');
  encrypted_raw := DBMS_CRYPTO.HASH( src => input_raw,typ => DBMS_CRYPTO.HASH_SH1);                                    
  RETURN RAWTOHEX(encrypted_raw);
END;
CREATE TABLE temp_member as
SELECT mem_id, mem_name, mem_pass, fn_hash(mem_pass) as pw
FROM member;

SELECT * 
FROM temp_member 
WHERE mem_id = 'a001'
AND pw = fn_hash('asdfasdfa');



SELECT fn_hash('1234')
FROM dual;



CREATE OR REPLACE FUNCTION fn_hash_sc(pw VARCHAR2, user_id VARCHAR2)
RETURN VARCHAR2
IS
  input_string  VARCHAR2 (200) := pw;  -- 입력 VARCHAR2 데이터
  input_raw     RAW(128);                        -- 입력 RAW 데이터 
  encrypted_raw RAW (2000); -- 암호화 데이터 
  key_string VARCHAR2(8) := user_id;  -- MAC 함수에서 사용할 비밀 키
  raw_key RAW(128) := UTL_RAW.CAST_TO_RAW(CONVERT(key_string,'AL32UTF8','US7ASCII')); -- 비밀키를 RAW 타입으로 변환
BEGIN
	-- VARCHAR2를 RAW 타입으로 변환
  input_raw := UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8');
  DBMS_OUTPUT.PUT_LINE('----------- MAC 함수 -------------'); 
  encrypted_raw := DBMS_CRYPTO.MAC( src => input_raw,
                                    typ => DBMS_CRYPTO.HMAC_MD5,
                                    key => raw_key);   
                                    
  
  RETURN RAWTOHEX(encrypted_raw);
END;


SELECT fn_hash_sc('1234','nick')
FROM dual ;
CREATE TABLE temp2_member AS
SELECT mem_id, mem_name, mem_pass, fn_hash_sc(mem_pass, mem_id) as pw
FROM member;


SELECT *
FROM temp2_member
WHERE pw = fn_hash_sc('asdfasdf','a001');





