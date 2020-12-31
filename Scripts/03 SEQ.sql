DROP SEQUENCE dongne1_seq;
DROP SEQUENCE dongne2_seq;
DROP SEQUENCE sale_seq;
DROP SEQUENCE chat_seq;
DROP SEQUENCE chat_msg_seq;

CREATE SEQUENCE dongne1_seq
START WITH 1
INCREMENT BY 1
MINVALUE 1;

CREATE SEQUENCE dongne2_seq
START WITH 1
INCREMENT BY 1
MINVALUE 1;

-- joongo_sale - id : 판매글 아이디
CREATE SEQUENCE sale_seq
START WITH 1 
INCREMENT BY 1
MINVALUE 1;

CREATE SEQUENCE chat_seq
START WITH 1
INCREMENT BY 1
MINVALUE 1;

CREATE SEQUENCE chat_msg_seq
START WITH 1
INCREMENT BY 1
MINVALUE 1;