/*
  테이블 스페이스 생성 
  물리적으로 저장되는 공간(파일)
*/
create tablespace myts
datafile '/u01/app/oracle/oradata/XE/myts.dbf'
size 100m autoextend on next 5m;
-- 명령어의 구분은 ; <-- 세미클론 
/*  유저 생성(계정) 
    java/oracle 
    create user 계정이름 identified by 비밀번호 
*/
create user java identified by oracle
default tablespace myts
temporary tablespace temp;
/* 권한 설정 
   접속 및 테이블 생성 관리 권한 
*/
grant connect to java;
grant resource to java;


/*
  SQL 구조화된 질의 언어 (문법은 거의 모든 RDB에서 동일, 부분적으로 다름)
  DDL(Data Definition Language) 데이터 정의어 
    CREATE, ALTER, DROP, TRUNCATE 등 
    테이블이나 관계의 구조를 생성할때 사용.
  DML(Data Manipulation Language) 데이터 조작어 
    SELECT, INSERT, UPDATE, DELETE, COMMIT, ROLLBACK
    데이터 검색, 수정, 삭제, 삽입등 을 할때 사용.
  DCL (Data Control Language) 데이터 제어어 
    GRANT, REVOKE 
    데이터의 권한을 관리하는데 사용. 
  * SQL은 대소문자를 구별하지 않음.(데이터 값자체는 구별)    
*/

/*  TABLE 객체 
    테이블명 컬럼명의 최대 크기는 30byte
    테이블명 컬럼명으로 예약어는 사용할 수 없음.
    테이블명 컬럼명으로 문자, 숫자, _, $, # 사용할 수 있지만 첫글자는 문자
    한 테이블에 사용가능한 컬럼은 255개 
*/
-- 테이블 생성문 (각 컬럼은 타입을 지정해야함, 컬럼 구분은 ,) 
CREATE TABLE ex1_1 (
    col1 CHAR(10)
   ,col2 VARCHAR2(10)
);




