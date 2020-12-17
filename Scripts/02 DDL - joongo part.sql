DROP TABLE MEMBER CASCADE CONSTRAINTS; /* 멤버 */
DROP TABLE DONGNE1 CASCADE CONSTRAINTS; /* 중고동네_1차 */
DROP TABLE DONGNE2 CASCADE CONSTRAINTS; /* 중고동네_2차 */
DROP TABLE JOONGO_IMAGE CASCADE CONSTRAINTS; /* 중고_이미지 */
DROP TABLE JOONGO_SALE CASCADE CONSTRAINTS; /* 중고판매글 */
DROP TABLE JOONGO_COMMENT CASCADE CONSTRAINTS; /* 중고댓글 */
DROP TABLE JOONGO_HEART CASCADE CONSTRAINTS; /* 중고_찜 */
DROP TABLE JOONGO_REVIEW CASCADE CONSTRAINTS; /* 중고리뷰 */
DROP TABLE JOONGO_CHAT_MSG CASCADE CONSTRAINTS; /* 중고_채팅_메시지 */
DROP TABLE JOONGO_CHAT CASCADE CONSTRAINTS; /* 중고_대화 */
DROP TABLE JOONGO_MYSALE CASCADE CONSTRAINTS; /* 중고_판매내역 */
DROP TABLE JOONGO_MYBUY CASCADE CONSTRAINTS; /* 중고_구매내역 */


/* 멤버 */
CREATE TABLE MEMBER (
	id VARCHAR2(20) NOT NULL PRIMARY key, /* 회원아이디 */
	pwd VARCHAR2(255) NOT NULL, /* 비밀번호 */
	name VARCHAR2(36) NOT NULL, /* 이름 */
	nickname VARCHAR2(36) NOT NULL, /* 닉네임 */
	email VARCHAR2(50) NOT NULL, /* 이메일 */
	phone VARCHAR2(20) NOT NULL, /* 연락처 */
	mydongne VARCHAR2(30) NOT NULL, /* 내동네 */
	grade NUMBER(1) NOT NULL, /* 등급 */
	profile_pic VARCHAR2(255), /* 프로필사진 */
	profile_text VARCHAR2(600),/* 프로필소개 */
	regdate DATE DEFAULT sysdate /* 가입일 */
);


ALTER TABLE MEMBER ADD UNIQUE (email);
ALTER TABLE MEMBER ADD UNIQUE (phone);

	--identity_yn VARCHAR2(1) NOT NULL, /* 본인인증 여부 */
	--birthday DATE, /* 생일 */
	--zipcode NUMBER(5), /* 우편번호 */
	--address1 VARCHAR2(255), /* 주소 */
	--address2 VARCHAR2(255), /* 상세주소 */
	--mileage NUMBER(10), /* 마일리지 */

ALTER TABLE MEMBER
ADD CONSTRAINT PK_MEMBER PRIMARY KEY (id);
	

/* 중고동네_1차 */
CREATE TABLE DONGNE1 (
	id NUMBER(12) NOT NULL, /* 동네1차아이디 */
	name VARCHAR2(36) NOT NULL /* 동네1차이름 */
);

ALTER TABLE DONGNE1
ADD CONSTRAINT PK_DONGNE1 PRIMARY KEY (id);

/* 중고동네_2차 */
CREATE TABLE DONGNE2 (
	id NUMBER(12) NOT NULL, /* 동네2차아이디 */
	dongne1_id NUMBER(12) NOT NULL, /* 동네1차 아이디 */
	name VARCHAR2(36) NOT NULL /* 동네2차이름 */
);

ALTER TABLE DONGNE2
ADD CONSTRAINT PK_DONGNE2 PRIMARY KEY (id);
	


/* 중고판매글 */
CREATE TABLE JOONGO_SALE (
	id NUMBER(12) NOT NULL, /* 중고판매글아이디 */
	mem_id VARCHAR2(20) NOT NULL, /* 회원아이디 */
	dog_cate VARCHAR2(1), /* 개카테고리 */
	cat_cate VARCHAR2(1), /* 고양이카테고리 */
	title VARCHAR2(1500) NOT NULL, /* 제목 */
	content VARCHAR2(4000), /* 내용 */
	price NUMBER(10) NOT NULL, /* 가격 */
	dongne1_id NUMBER(12) NOT NULL, /* 동네1차아이디 */
	dongne2_id NUMBER(12) NOT NULL, /* 동네2차아이디 */
	buy_mem_id VARCHAR2(20), /* 구매자 아이디 */
	sale_state NUMBER(1) NOT NULL, /* 판매상태 */
	regdate DATE NOT NULL, /* 작성일시 */
	redate DATE, /* 끌올일시 */
	hits NUMBER(12) NOT NULL, /* 조회수 */
	chat_count NUMBER(12), /* 채팅수 */
	heart_count NUMBER(12) /* 찜수 */
);

ALTER TABLE JOONGO_SALE
ADD CONSTRAINT PK_JOONGO_SALE PRIMARY KEY (id);
	
/* 중고_이미지 */
CREATE TABLE JOONGO_IMAGE (
	id NUMBER(12) NOT NULL, /* 이미지아이디 */
	sale_id NUMBER(12) NOT NULL, /* 판매글 */
	image_name VARCHAR2(255) NOT NULL /* 파일이름 */
);

ALTER TABLE JOONGO_IMAGE
ADD CONSTRAINT PK_JOONGO_IMAGE PRIMARY KEY (id);

/* 중고댓글 */
CREATE TABLE JOONGO_COMMENT (
	id NUMBER(12) NOT NULL, /* 새 컬럼 */
	sale_id NUMBER(12) NOT NULL, /* 글 아이디 */
	mem_id VARCHAR2(20) NOT NULL, /* 회원아이디 */
	origin_id NUMBER(12), /* 원댓ID */
	tag_mem_id VARCHAR2(20), /* 사용자태그 대상 */
	content VARCHAR2(4000) NOT NULL, /* 내용 */
	regdate DATE NOT NULL /* 등록일시 */
);

ALTER TABLE JOONGO_COMMENT
ADD CONSTRAINT PK_JOONGO_COMMENT PRIMARY KEY (id);

/* 중고_찜 */
CREATE TABLE JOONGO_HEART (
	id NUMBER(12) NOT NULL, /* 찜아이디 */
	mem_id VARCHAR2(20) NOT NULL, /* 멤버아이디 */
	sale_id NUMBER(12) NOT NULL, /* 하트를 누른 글 */
	regdate DATE NOT NULL /* 등록일 */
);

ALTER TABLE JOONGO_HEART
ADD CONSTRAINT PK_JOONGO_HEART PRIMARY KEY (id);

/* 중고리뷰 */
CREATE TABLE JOONGO_REVIEW (
	id NUMBER(12) NOT NULL, /* 리뷰글아이디 */
	sale_id NUMBER(12) NOT NULL, /* 중고판매글아이디 */
	buy_mem_id VARCHAR2(20) NOT NULL, /* 회원아이디 */
	rating NUMBER(1,1) NOT NULL, /* 평점 */
	content VARCHAR2(1500), /* 내용 */
	regdate DATE NOT NULL /* 작성일 */
);

ALTER TABLE JOONGO_REVIEW
ADD CONSTRAINT PK_JOONGO_REVIEW PRIMARY KEY (id);



/* 중고_구매내역 */
CREATE TABLE JOONGO_MYBUY (
	mem_id VARCHAR2(20) NOT NULL, /* 구매자 아이디 */
	sale_id NUMBER(12) NOT NULL /* 구매상품 아이디 */
);

/* 중고_판매내역 */
CREATE TABLE JOONGO_MYSALE (
	mem_id VARCHAR2(20) NOT NULL, /* 판매자아이디 */
	sale_id NUMBER(12) NOT NULL /* 판매상품 아이디 */
);



/* 중고_대화 */
CREATE TABLE JOONGO_CHAT (
	id NUMBER(12) NOT NULL, /* 채팅방아이디 */
	sale_id NUMBER(12) NOT NULL, /* 판매글 */
	sale_mem_id VARCHAR2(20), /* 판매자 아이디 */
	buy_mem_id VARCHAR2(20) NOT NULL, /* 구매자 아이디 */
	regdate DATE NOT NULL, /* 채팅시작일자 */
	latest_date DATE /* 최근채팅일자 */
);

ALTER TABLE JOONGO_CHAT
ADD CONSTRAINT PK_JOONGO_CHAT PRIMARY KEY (id);

/* 중고_채팅_메시지 */
CREATE TABLE JOONGO_CHAT_MSG (
	id NUMBER(12) NOT NULL, /* 메시지 아이디 */
	chat_id NUMBER(12) NOT NULL, /* 채팅방 아이디 */
	mem_id VARCHAR2(20) NOT NULL, /* 메시지 작성자 */
	content VARCHAR2(1500), /* 내용 */
	regdate DATE NOT NULL, /* 발송일시 */
	read_yn VARCHAR2(1) NOT NULL, /* 읽음여부 */
	image VARCHAR2(255) /* 사진 */
);

ALTER TABLE JOONGO_CHAT_MSG
ADD CONSTRAINT PK_JOONGO_CHAT_MSG PRIMARY KEY (id);



ALTER TABLE JOONGO_COMMENT
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_COMMENT
		FOREIGN KEY (
			mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_COMMENT
	ADD
		CONSTRAINT FK_JNG_COMMENT_TO_JNG_CMNT
		FOREIGN KEY (
			origin_id
		)
		REFERENCES JOONGO_COMMENT (
			id
		);

ALTER TABLE JOONGO_COMMENT
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_COMMENT2
		FOREIGN KEY (
			tag_mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_COMMENT
	ADD
		CONSTRAINT FK_JNG_SALE_TO_JOONGO_CMNT
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_MYSALE
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_MYSALE
		FOREIGN KEY (
			mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_MYSALE
	ADD
		CONSTRAINT FK_JNG_SALE_TO_JOONGO_MSL
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_SALE
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_SALE
		FOREIGN KEY (
			mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_SALE
	ADD
		CONSTRAINT FK_DONGNE2_TO_JOONGO_SALE
		FOREIGN KEY (
			dongne2_id
		)
		REFERENCES DONGNE2 (
			id
		);

ALTER TABLE JOONGO_CHAT
	ADD
		CONSTRAINT FK_JOONGO_SALE_TO_JOONGO_CHAT
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_CHAT
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_CHAT2
		FOREIGN KEY (
			buy_mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE DONGNE2
	ADD
		CONSTRAINT FK_DONGNE1_TO_DONGNE2
		FOREIGN KEY (
			dongne1_id
		)
		REFERENCES DONGNE1 (
			id
		);

ALTER TABLE JOONGO_MYBUY
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_MYBUY
		FOREIGN KEY (
			mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_MYBUY
	ADD
		CONSTRAINT FK_JOONGO_SALE_TO_JOONGO_MYBUY
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_IMAGE
	ADD
		CONSTRAINT FK_JOONGO_SALE_TO_JOONGO_IMAGE
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_CHAT_MSG
	ADD
		CONSTRAINT FK_JNG_CHAT_TO_JNG_CHT_MSG
		FOREIGN KEY (
			chat_id
		)
		REFERENCES JOONGO_CHAT (
			id
		);

ALTER TABLE JOONGO_HEART
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_HEART
		FOREIGN KEY (
			mem_id
		)
		REFERENCES MEMBER (
			id
		);

ALTER TABLE JOONGO_HEART
	ADD
		CONSTRAINT FK_JOONGO_SALE_TO_JOONGO_HEART
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_REVIEW
	ADD
		CONSTRAINT FK_JNG_SALE_TO_JOONGO_RVW
		FOREIGN KEY (
			sale_id
		)
		REFERENCES JOONGO_SALE (
			id
		);

ALTER TABLE JOONGO_REVIEW
	ADD
		CONSTRAINT FK_MEMBER_TO_JOONGO_REVIEW
		FOREIGN KEY (
			buy_mem_id
		)
		REFERENCES MEMBER (
			id
		);