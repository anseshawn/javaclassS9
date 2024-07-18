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

