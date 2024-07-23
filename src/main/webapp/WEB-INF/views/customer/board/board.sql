show tables;

create table freeBoardS(
	idx INT NOT NULL auto_increment,
	mid VARCHAR(20) NOT NULL,
	nickName VARCHAR(10) NOT NULL,
	title VARCHAR(50) NOT NULL,
	content text NOT NULL,
	hostIp VARCHAR(40) NOT NULL,
	readNum INT DEFAULT 0,
	writeDate datetime DEFAULT now(),
	good INT DEFAULT 0,
	report INT DEFAULT 0,
	PRIMARY KEY(idx),
	FOREIGN KEY(mid) REFERENCES memberS(mid)
);

DESC freeBoardS;

INSERT INTO freeBoardS VALUES (default,'admin','관리자','게시판 서비스를 시작합니다.','많은 이용부탁드립니다.','192.168.50.58',default,default,default,default);

create table questionBoardS(
	idx int not null auto_increment,	/* 게시글 고유번호 */
	mid varchar(10) not null,					/* 작성자 아이디 */
	nickName varchar(10) not null,		/* 작성자 닉네임 */
	title varchar(50) not null,				/* 게시글 제목 */
	content text not null,						/* 게시글 내용 */
	hostIp varchar(40) not null,			/* 작성자 아이피 */
	readNum int default 0,						/* 조회수 */
	writeDate datetime default now(),	/* 작성일 */
	part varchar(10) not null,				/* 질문분류(실험방법,실험장비,법규,기타) */
	good int default 0,								/* 좋아요 */
	report int default 0,							/* 신고(5번 신고하면 리스트에서 블라인드) */
	primary key(idx),
	foreign key(mid) references memberS(mid)
);
INSERT INTO questionBoardS VALUES (default,'admin','관리자','질문 게시판 서비스를 시작합니다.','회원님들의 많은 이용부탁드립니다.','192.168.50.58',default,default,'기타',default,default);

create table recruitBoardS(
	idx int not null auto_increment,	/* 게시글 고유번호 */
	mid varchar(20) not null,					/* 작성자 아이디 */
	nickName varchar(10) not null,		/* 작성자 닉네임 */
	title varchar(50) not null,				/* 게시글 제목 */
	content text not null,						/* 게시글 내용 */
	hostIp varchar(40) not null,			/* 작성자 아이피 */
	readNum int default 0,						/* 조회수 */
	writeDate datetime default now(),			/* 작성일 */
	part varchar(10) not null,				/* 채용구분(신입,경력,경력무관,인턴) */
	location varchar(100) not null,		/* 근무지역 */
	startDate datetime not null default now(),	/* 채용시작일 */
	endDate datetime not null,									/* 채용종료일 */
	etcContent text,									/* 유의사항 */
	rcfName varchar(200),							/* 첨부파일 (있을 경우) */
	rcfSName varchar(200),						/* 서버에 저장되는 첨부파일 이름 */
	good int default 0,								/* 좋아요 */
	report int default 0,							/* 신고(5번 신고하면 리스트에서 블라인드) */
	primary key(idx),
	foreign key(mid) references memberS(mid)
);
drop table recruitBoardS;
desc recruitBoardS;

create table replyS(
	idx INT NOT NULL auto_increment,
	board VARCHAR(20) NOT NULL,		/* 게시판 종류 */
	boardIdx INT NOT NULL,				/* 게시판 고유번호 */
	re_step INT NOT NULL,					/* 레벨에 따른 들여쓰기(계층번호): 부모댓글의 re_step은 0이다. 대댓글의 경우는 부모의 re_step+1로 처리한다. */
	re_order INT NOT NULL,				/* 댓글의 순서 결정. 부모 댓글을 1번, 대댓글의 경우는 자신의 부모댓글보다 큰 대댓글은 re_order+1 하고, 자신은 부모댓글의 re_order보다 +1처리한다. */
	parentId int,									/* 부모댓글의 아이디. 부모댓글의 경우 null, 대댓글의 경우는 부모댓글의 아이디 */
	mid VARCHAR(20) NOT NULL,
	nickName VARCHAR(10) NOT NULL,
	replyDate datetime DEFAULT now(),
	hostIp VARCHAR(50) NOT NULL,
	content text NOT NULL,
	report INT default 0,
	PRIMARY KEY(idx)
);
DESC replyS;

SELECT *, datediff(writeDate, now()) AS date_diff, timestampdiff(hour, writeDate, now()) AS hour_diff,
	(SELECT count(*) FROM replyS WHERE board='freeBoard' and boardIdx = b.idx) as replyCnt 
	FROM freeBoardS b ORDER BY idx desc;
	

create table boardLikeS(
	idx int not null auto_increment,
	memberMid varchar(20) not null,	/* 좋아요 누른 회원 아이디 */
	board varchar(20) not null,
	boardIdx int not null,
	likeDate datetime default now(),
	primary key(idx),
	foreign key(memberMid) references memberS(mid) on delete cascade
);
desc boardLikeS;

create table reportS(
	idx int not null auto_increment,
	board varchar(20) not null,
	boardIdx int not null,
	rpMid varchar(20) not null,
	rpContent text not null,
	rpDate datetime default now(),
	primary key(idx),
	foreign key(rpMid) references memberS(mid)
);
desc reportS;

select * from reportS where boardIdx = (select boardIdx from reportS where idx = 19);
