show tables;

create table engineerS(
	idx int not null auto_increment,		/* 고유번호 */
	name varchar(10) not null,					/* 엔지니어 이름 */
	mid varchar(20) not null,						/* 엔지니어 아이디 */
	pwd varchar(100) not null,					/* 비밀번호 */
	level int default 1,
	tel varchar(15) not null,						/* 연락처 */
	email varchar(40) not null,					/* 이메일 */
	place varchar(50) not null,					/* 출장가능지역 */
	machine varchar(50) not null,		/* 담당기기 */
	photo varchar(50) default 'noimage.jpg', /* 사진 */
	joinDate datetime default now(),		/* 입사일 */
	starPoint double not null default 0.0,				/* 별점 */
	primary key(idx),
	unique(mid)
);
drop table engineerS;
desc engineerS;

select * from engineerS where place = '서울';

CREATE TABLE scheduleS (
	idx INT NOT NULL AUTO_INCREMENT PRIMARY KEY,   /* 일정 고유번호 */
	engineerIdx INT NOT NULL,
	title VARCHAR(255) NOT NULL,                   /* 일정 내용 */
	startTime DATETIME NOT NULL,                   /* 일정 시작 시간 */
	endTime DATETIME,                              /* 일정 종료 시간 */
	allDay BOOLEAN NOT NULL DEFAULT FALSE,          /* 종일 일정 여부 (TRUE: 종일, FALSE: 시간 지정) */
	FOREIGN KEY(engineerIdx) REFERENCES engineerS(idx)
);
desc scheduleS;
drop table scheduleS;

insert into scheduleS values(default, 2, '일정시작', '2024-06-01', '2024-06-02', false);

select r.*, datediff(r.asDate, now()) as date_diff, 
	e.name as engineerName, e.mid as engineerMid 
	from asRequest r
	left join engineerS e on e.idx = r.engineerIdx where e.name like '%철%'
	order by r.idx desc;