show tables;

create table asRequest(
	idx int not null auto_increment,
	asMid varchar(20) not null,			/* 고객 아이디 */
	asName varchar(20) not null,		/* 고객 이름 */
	asDate datetime not null,			/* 요청 날짜 */
	asPlace varchar(2) not null,	/* 지역 */
	address varchar(100) not null,	/* 상세주소 */
	engineer int not null,				/* 담당 엔지니어 */
	machine enum('UV','AAs','ICP','GC','LC','etc'),			/* (UV, AAs, ICP, GC, LC, etc) */
	progress enum('REGIST','ACCEPT','PROGRESS','PAYMENT','COMPLETE'),				/* (신청완료,접수완료,진행중,입금대기,진행완료) */
	requestDate datetime default now(),
	detailNote text,
	endDate datetime,
	comment text,
	primary key(idx),
	foreign key(asMid) references memberS(mid),
	foreign key(engineer) references engineerS(idx)
);

desc asRequest;

select a.*, e.name from asRequest a left join engineerS e on a.engineer = e.idx where a.asMid = 'atom1234' order by a.idx limit 0,5;


create table review(
	idx int not null auto_increment,
	memberMid varchar(20) not null,
	asIdx int not null,
	engineerIdx int not null,
	starPoint double not null,
	reviewDetail text,
	primary key(idx),
	foreign key(memberMid) references memberS(mid),
	foreign key(asIdx) references asRequest(idx),
	foreign key(engineerIdx) references engineerS(idx) on delete cascade
);

desc review;
drop table review;
