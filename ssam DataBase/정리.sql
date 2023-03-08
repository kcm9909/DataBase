-- 수행쿼리 시험 
-- 1 ~ 10 문제 (1 ~ 6장, 10장)
-- 서술형 시험 
-- 총 8 문제 (데이터베이스 구현 4, SQL활용 4)
-- 1 ~ 6장

/* 정리 

  계정 생성  : 28p
  CREATE USER 유저명 IDENTIFIED BY 비밀번호 ; 
  권한 부여 
  GRANT 권한 TO 계정명;
  ex) GRANT CONNECT, RESOURCE TO 계정명 
     롤 : 다수의 사용자와 다양한 권한을 효과적으로 관리하기 위해 
          권한을 그룹화한 개념 
        CONNECT 롤 : 전속 및 세션 생성.. 
        RESOURCE 롤 : 테이블, 시퀀스, ...객체를 생성할 수 있는 권한 
        DBA 롤 : 전체 권한 부여 
        
  권한 해제 
  REVOKE 권한 FROM 계정명; 
  
  -객체 48p 참고 
  ex 시노님(synonim) 데이터베이스 객체에 대한 별칭을 부여한 객체로 
     '동의어'란 뜻으로 데이터베이스 객체의 고유한 이름에 동의어를 
      만드는 것 . 
      PUBLIC과 PRIVATE 시노님이 있으며 
      PUBLIC은 모든 사용자가 사용할 수 있도록 하는 시노님이기 때문에 
      DBA권한이 있어야 생성,삭제 할 수 있다. 
      시노님을 사용하는 이유는 1.보안 목적으로 실제 객체의 이름을 숨기기 위해
      2.개발의 편의성 (프로젝트 단계에서 변경될 수 있는 이름을 동의어를 부여해 
                     일관성을 줄 수 있음)
  DML 데이터 조작어 93p
  SELECT/INSERT/UPDATE/DELETE 
  집계함수(그룹바이절) 152p 
  AVG, SUM, MIN, MAX.. 
  조인(JOIN inner, outer)176p
  일반 inner, outer
  ANSI inner, left, right
  분석함수 231p
  rank, row_number..
  
*/











