SELECT ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, DONGNE1_ID, DONGNE2_ID, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT FROM JOONGO_SALE;

SELECT js.ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, d1.ID AS DONGNE1ID, d1.NAME AS DONGNE1NAME, d2.ID AS DONGNE2ID, d2.NAME AS DONGNE2NAME, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT 
 FROM JOONGO_SALE js LEFT JOIN DONGNE1 d1 ON js.DONGNE1_ID = d1.ID LEFT JOIN DONGNE2 d2 ON js.DONGNE2_ID = d2.ID;

SELECT js.ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, d1.ID AS DONGNE1ID, d1.NAME AS DONGNE1NAME, d2.ID AS DONGNE2ID, d2.NAME AS DONGNE2NAME, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT 
 FROM JOONGO_SALE js LEFT JOIN DONGNE1 d1 ON js.DONGNE1_ID = d1.ID LEFT JOIN DONGNE2 d2 ON js.DONGNE2_ID = d2.ID WHERE d1.NAME = '부산광역시' AND d2.NAME = '동구';

SELECT ID FROM DONGNE1 WHERE NAME = '부산광역시';

SELECT rownum, js.*
  FROM JOONGO_SALE js 
 WHERE rownum BETWEEN 1 AND 5
 ORDER BY rownum desc;
 
SELECT rownum, js.ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, d1.ID AS DONGNE1ID, d1.NAME AS DONGNE1NAME, d2.ID AS DONGNE2ID, d2.NAME AS DONGNE2NAME, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT 
  FROM JOONGO_SALE js LEFT JOIN DONGNE1 d1 ON js.DONGNE1_ID = d1.ID LEFT JOIN DONGNE2 d2 ON js.DONGNE2_ID = d2.ID
  --WHERE rownum BETWEEN 1 AND 5
  ORDER BY js.ID;
 
SELECT a.*
  FROM (SELECT rownum AS rnum, b.*
  		FROM (SELECT js.ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, d1.ID AS DONGNE1ID, d1.NAME AS DONGNE1NAME, d2.ID AS DONGNE2ID, d2.NAME AS DONGNE2NAME, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT 
  FROM JOONGO_SALE js LEFT JOIN DONGNE1 d1 ON js.DONGNE1_ID = d1.ID LEFT JOIN DONGNE2 d2 ON js.DONGNE2_ID = d2.ID WHERE title LIKE '%자전거%') b) a
 WHERE a.rnum BETWEEN 1 AND 10
ORDER BY a.rnum;
  
SELECT count(a.id)
  FROM (SELECT rownum AS rnum, b.*
  		FROM (SELECT js.ID, MEM_ID, DOG_CATE, CAT_CATE, TITLE, CONTENT, PRICE, d1.ID AS DONGNE1ID, d1.NAME AS DONGNE1NAME, d2.ID AS DONGNE2ID, d2.NAME AS DONGNE2NAME, BUY_MEM_ID, SALE_STATE, REGDATE, REDATE, HITS, CHAT_COUNT, HEART_COUNT 
  FROM JOONGO_SALE js LEFT JOIN DONGNE1 d1 ON js.DONGNE1_ID = d1.ID LEFT JOIN DONGNE2 d2 ON js.DONGNE2_ID = d2.ID ORDER BY js.id desc) b) a;
 
SELECT * FROM JOONGO_SALE;
SELECT * FROM JOONGO_IMAGE;

UPDATE JOONGO_SALE SET BUY_MEM_ID = 'chattest2' WHERE ID = 3;

SELECT joongo_comment_seq.nextval FROM DUAL;
SELECT * FROM JOONGO_COMMENT jc LEFT OUTER JOIN MEMBER m ON jc.MEM_ID = m.ID ORDER BY jc.ID ;
INSERT INTO JOONGO_COMMENT(ID, SALE_ID, MEM_ID, CONTENT) values(joongo_comment_seq.nextval, 2, 'chattest1', '댓글 테스트입니다.');
INSERT INTO JOONGO_COMMENT(ID, SALE_ID, MEM_ID, ORIGIN_ID, TAG_MEM_ID, CONTENT) VALUES(joongo_comment_seq.nextval, 1, 'chattest2', 23, 'chattest1', '계층형 댓글 테스트입니다.4');
INSERT INTO JOONGO_COMMENT(ID, SALE_ID, MEM_ID, CONTENT) values(joongo_comment_seq.nextval, 10, 'chattest1', '테스트');

SELECT a.*
  FROM (SELECT rownum AS rnum, b.*
    FROM (SELECT jc.id, MEM_ID, m.PROFILE_PIC, m.GRADE, SALE_ID, ORIGIN_ID, TAG_MEM_ID, CONTENT, jc.REGDATE 
  FROM JOONGO_COMMENT jc LEFT OUTER JOIN MEMBER m ON jc.MEM_ID = m.ID
 WHERE mem_id = 'chattest1'
 START WITH origin_id IS NULL
 CONNECT BY PRIOR jc.id = ORIGIN_ID
 ORDER SIBLINGS BY ID) b) a
 WHERE a.rnum BETWEEN 1 AND 10
ORDER BY a.rnum;

SELECT a.*
  FROM (SELECT rownum AS rnum, b.*
    FROM (SELECT jc.id, MEM_ID, m.PROFILE_PIC, m.GRADE, SALE_ID, ORIGIN_ID, TAG_MEM_ID, CONTENT, jc.REGDATE 
  FROM JOONGO_COMMENT jc LEFT OUTER JOIN MEMBER m ON jc.MEM_ID = m.ID ORDER BY jc.ID DESC) b) a
 WHERE a.rnum BETWEEN 1 AND 10
ORDER BY a.rnum;

-- delete
DELETE FROM JOONGO_COMMENT WHERE ID = 23 OR ORIGIN_ID = 23;

-- update
UPDATE JOONGO_COMMENT SET CONTENT = '글을 수정해봅니다.' WHERE ID = 36;

SELECT count(id) FROM JOONGO_COMMENT WHERE SALE_ID = 2;

SELECT * FROM JOONGO_COMMENT jc CONNECT BY ID = ORIGIN_ID ORDER SIBLINGS BY SALE_ID ;

SELECT id, MEM_ID, SALE_ID, ORIGIN_ID, TAG_MEM_ID, CONTENT, REGDATE 
  FROM JOONGO_COMMENT jc 
 START WITH origin_id IS NULL
 CONNECT BY PRIOR id = ORIGIN_ID
 ORDER SIBLINGS BY ID;
 


SELECT * FROM MEMBER;
UPDATE MEMBER SET DONGNE1 = 1, DONGNE2 = 1 WHERE ID = 'chattest1';
UPDATE MEMBER SET DONGNE1 = 3, DONGNE2 = 44 WHERE ID = 'chattest1';

SELECT * FROM MALL_DOG_CATE ORDER BY ID;
SELECT * FROM MALL_CAT_CATE;
SELECT * FROM MALL_PDT ORDER BY ID;

SELECT * FROM MALL_PDT WHERE DOG_CATE = 2;

UPDATE MALL_PDT SET CAT_CATE = 2 WHERE CAT_CATE = 1;

INSERT INTO MALL_PDT VALUES(mall_pdt_seq.nextval, 1, NULL, '네츄럴코어', 13000, '네츄럴코어 사료입니다.', 'Y', 100, NULL, NULL, NULL, '조건부 무료배송', 50000, 3000, sysdate);

INSERT INTO MALL_PDT(ID, DOG_CATE, CAT_CATE, NAME, PRICE, CONTENT, SALE_YN, STOCK, IMAGE1, IMAGE2, IMAGE3, DELIVERY_KIND, DELIVERY_CONDITION, DELIVERY_PRICE)
 VALUES(mall_pdt_seq.nextval, 1, NULL, '네츄럴코어2', 13000, '네츄럴코어 사료입니다.', 'Y', 100, NULL, NULL, NULL, '조건부 무료배송', 50000, 3000);
 
SELECT id, name FROM MALL_DOG_CATE WHERE id NOT IN (1) ORDER BY ID;

select mp.ID, DOG_CATE, mdc.NAME AS DOG_NAME, CAT_CATE, mcc.NAME AS CAT_NAME, mp.NAME, PRICE, CONTENT, SALE_YN, STOCK, IMAGE1, IMAGE2, IMAGE3, DELIVERY_KIND, DELIVERY_CONDITION, DELIVERY_PRICE, REGDATE from MALL_PDT mp LEFT OUTER JOIN MALL_DOG_CATE mdc ON mp.DOG_CATE = mdc.ID LEFT OUTER JOIN MALL_CAT_CATE mcc ON mp.CAT_CATE = mcc.ID;

SELECT a.*
  FROM (SELECT rownum AS rnum, b.*
  		FROM (SELECT mp.ID, DOG_CATE, mdc.NAME AS DOG_NAME, CAT_CATE, mcc.NAME AS CAT_NAME, mp.NAME, PRICE, CONTENT, SALE_YN, STOCK, IMAGE1, IMAGE2, IMAGE3, DELIVERY_KIND, DELIVERY_CONDITION, DELIVERY_PRICE, REGDATE 
  	from MALL_PDT mp LEFT OUTER JOIN MALL_DOG_CATE mdc ON mp.DOG_CATE = mdc.ID LEFT OUTER JOIN MALL_CAT_CATE mcc ON mp.CAT_CATE = mcc.ID where dog_cate = 2 AND sale_yn = 'Y' ORDER BY mp.ID desc) b) a
 WHERE a.rnum BETWEEN 1 AND 5
 ORDER BY a.rnum;
 
SELECT count(id) FROM MALL_PDT WHERE DOG_CATE = 2 AND SALE_YN = 'Y';
 
UPDATE MALL_PDT SET DOG_CATE = 1, CAT_CATE = 1, name = '품절상품', PRICE = 20000, CONTENT = '수정한 상품', SALE_YN = 'N', STOCK = 99, IMAGE1 = NULL, IMAGE2 = NULL, IMAGE3 = NULL, DELIVERY_KIND = '무료배송', DELIVERY_CONDITION = 0, DELIVERY_PRICE = 0 WHERE ID = 10;

SELECT * FROM JOONGO_SALE;
SELECT * FROM JOONGO_REVIEW;
SELECT * FROM MEMBER_VIEW mv ;

SELECT * FROM sale_review_view;

SELECT jr.ID, jr.SALE_ID, js.MEM_ID AS SALE_MEM_ID, jr.BUY_MEM_ID, mv.NICKNAME AS BUY_MEM_NICKNAME, mv.PROFILE_PIC AS BUY_MEM_PROFILE_PIC, mv.DONGNE1 AS BUY_MEM_DONGNE1_NAME, mv.DONGNE2 AS BUY_MEM_DONGNE2_NAME, jr.RATING, jr.CONTENT, jr.REGDATE
 FROM JOONGO_REVIEW jr LEFT OUTER JOIN MEMBER_VIEW mv ON jr.BUY_MEM_ID = mv.ID LEFT OUTER JOIN JOONGO_SALE js ON jr.SALE_ID = js.ID;

UPDATE JOONGO_SALE SET BUY_MEM_ID = 'chattest2' WHERE ID = 1;

SELECT ID, SALE_ID, BUY_MEM_ID, RATING, CONTENT, REGDATE FROM JOONGO_REVIEW WHERE SALE_ID = 2;
DELETE FROM JOONGO_REVIEW WHERE ID = 2;
INSERT INTO JOONGO_REVIEW(ID, SALE_ID, BUY_MEM_ID, RATING, CONTENT) values(joongo_review_seq.nextval, 1, 'chattest1', 4, '아주아주 좋아요');

SELECT COUNT(ID) FROM SALE_REVIEW_VIEW WHERE SALE_MEM_ID = 'chattest1';

UPDATE JOONGO_REVIEW SET RATING = 3, CONTENT = '굿뜨' WHERE ID = 1;

SELECT * FROM MALL_ORDER ;
SELECT * FROM MALL_ORDER_DETAIL;
SELECT * FROM MALL_PAYMENT;
SELECT * FROM SALE_VIEW WHERE REGEXP_LIKE(DONGNE1_NAME, '대구|서구') OR REGEXP_LIKE(DONGNE2_NAME, '대구|서구');

SELECT * FROM SALE_VIEW WHERE REGEXP_LIKE(DONGNE1_NAME, (SELECT NAME FROM DONGNE1 WHERE REGEXP_LIKE(NAME , '대구|서구'))) ;

SELECT NAME FROM DONGNE1 WHERE REGEXP_LIKE(NAME , '대구|서구');

SELECT D1NAME FROM DONGNE_VIEW dv WHERE REGEXP_LIKE(D2NAME, '대구|서구') ;
SELECT * FROM MEMBER;
SELECT * FROM MALL_PDT;