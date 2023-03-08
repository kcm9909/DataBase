CREATE TABLE 상품 (
           상품코드 VARCHAR2(10) CONSTRAINT 상품_PK PRIMARY KEY 
          ,상품명   VARCHAR2(100) NOT NULL
          ,제조사  VARCHAR2(100)
          ,소비자가격 NUMBER
          ,재고수량 NUMBER DEFAULT 0
        );
                
CREATE TABLE 입고 (
   입고번호 NUMBER CONSTRAINT 입고_PK PRIMARY KEY
  ,상품코드 VARCHAR(10) CONSTRAINT 입고_FK REFERENCES 상품(상품코드)
  ,입고일자 DATE DEFAULT SYSDATE
  ,입고수량 NUMBER
  ,입고단가 NUMBER
  ,입고금액 NUMBER
);

INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('a001','마우스','삼성','1000');
INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('a002','마우스','NKEY','2000');
INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('b001','키보드','LG','2000');
INSERT INTO 상품 (상품코드, 상품명, 제조사, 소비자가격) VALUES ('c001','모니터','삼성','1000');



SELECT *
FROM 상품;

CREATE OR REPLACE TRIGGER warehousing_insert
AFTER INSERT ON 입고 
FOR EACH ROW 
DECLARE 
 vn_cnt 상품.재고수량%type;
 vn_nm  상품.상품명%type;
BEGIN
  SELECT 재고수량, 상품명
    INTO vn_cnt, vn_nm
  FROM 상품 
  WHERE 상품코드 = :NEW.상품코드;
  
  UPDATE 상품 
  SET 재고수량 = :NEW.입고수량 + 재고수량 
  WHERE 상품코드 = :NEW.상품코드 ;
  DBMS_OUTPUT.PUT_LINE(vn_nm || '상품의 수량 정보가 변경되었음.');
  DBMS_OUTPUT.PUT_LINE('수정 전 수량:'||vn_cnt);
  DBMS_OUTPUT.PUT_LINE('입고 수량 :'||:NEW.입고수량);
  DBMS_OUTPUT.PUT_LINE('수정 후 수량:'||(vn_cnt + :NEW.입고수량));
  
END;
desc  입고;

SELECT * FROM 입고;
SELECT * FROM 상품 ;

UPDATE 상품
SET 재고수량 = 110
WHERE 상품코드 = 'a002';

INSERT INTO 입고 VALUES(2, 'a002', sysdate ,10, 1000, 10000);
UPDATE 입고 
SET 입고수량 = 1000
WHERE 입고번호 = 1;
-- 입고테이블에 입고 수량이 변경되면 
-- 상품테이블에 재고수량이 변경되도록 트리거를 만드세요 


CREATE OR REPLACE TRIGGER warehousing_update
AFTER UPDATE ON 입고 
FOR EACH ROW 
DECLARE 
 vn_cnt 상품.재고수량%type;
 vn_nm  상품.상품명%type;
BEGIN
  SELECT 재고수량, 상품명
    INTO vn_cnt, vn_nm
  FROM 상품 
  WHERE 상품코드 = :NEW.상품코드;
  
  UPDATE 상품 
  SET 재고수량 = 재고수량 - :OLD.입고수량 + :NEW.입고수량
  WHERE 상품코드 = :NEW.상품코드 ;
  DBMS_OUTPUT.PUT_LINE(vn_nm || '상품의 입고번호 '||:NEW.입고번호||'수량 정보가 변경되었음.');
  DBMS_OUTPUT.PUT_LINE('수정 전 수량:'||vn_cnt);
  DBMS_OUTPUT.PUT_LINE('입고 수량 :'||:OLD.입고수량 || '>' || :NEW.입고수량);
  DBMS_OUTPUT.PUT_LINE('수정 후 수량:'||(vn_cnt -:OLD.입고수량 + :NEW.입고수량 ));
  
END;
