show tables;

create table deleteMember(
	deleteDate datetime default now(),
	deleteReason int not null,	/* 탈퇴 사유 분류 */
	reasonDetail varchar(15),		/* 이하 탈퇴 사유 */
	etc text		/* 기타 선택시 */
);

/*
1: 찾는 제품이 없어서
2: 이용이 불편해서
3: 다른 사이트가 더 좋아서
4: 사용 빈도가 낮아서
5: 콘텐츠 불만
6: 기타
*/

insert into deleteMember values(default, 2, '이용이 불편해서','');
insert into deleteMember values(default, 4, '사용 빈도가 낮아서','');
insert into deleteMember values(default, 1, '찾는 제품이 없어서','');
insert into deleteMember values(default, 1, '찾는 제품이 없어서','');
insert into deleteMember values(default, 4, '사용 빈도가 낮아서','');
insert into deleteMember values(default, 2, '이용이 불편해서','');
insert into deleteMember values(default, 3, '다른 사이트가 더 좋아서','');

select deleteReason,reasonDetail, count(*) as reasonCnt from deleteMember
	where deleteReason between 1 and 6 group by deleteReason;
	
create table consultingS(
	idx int not null auto_increment,
	part enum('SERVICE','COMPLAINT'),
	name varchar(20) not null,
	email varchar(40) not null,
	phone varchar(20),
	title varchar(20) not null,
	content text not null,
	writeDate datetime default now(),
	answer text,
	completeDate datetime,
	primary key(idx)
);

desc consultingS;

create table noticeS(
	idx int not null auto_increment,
	part varchar(10) not null,	/* 일반공지사항(notices), 이벤트(events) */
	title varchar(50) not null,
	content text not null,
	popup varchar(2) not null default 'NO',
	writeDate datetime default now(),
	endDate datetime,		/* 이벤트 진행 시 종료 날짜 선택 */
	important varchar(2) not null default 'NO',
	primary key(idx)
);
desc noticeS;

create table faqS(
	idx int not null auto_increment,
	part varchar(10) not null,
	title varchar(100) not null,
	content text not null,
	primary key(idx)
);

select part from faqS group by part;