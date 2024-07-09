show tables;

create table engineerS(
	idx int not null auto_increment,		/* 고유번호 */
	name varchar(10) not null,					/* 엔지니어 이름 */
	mid varchar(20) not null,						/* 엔지니어 아이디 */
	pwd varchar(100) not null,					/* 비밀번호 */
	level int default 3,
	tel varchar(15) not null,						/* 연락처 */
	email varchar(40) not null,					/* 이메일 */
	place varchar(50) not null,		/* 출장가능지역 */
	instrument varchar(50) not null,	/* 담당기기 */
	photo varchar(50) default 'noimage.jpg', /* 사진 */
	joinDate datetime default now(),			/* 입사일 */
	starPoint datetime default 0,			/* 입사일 */
	primary key(idx),
	unique(mid)
);
drop table engineerS;
desc engineerS;

select * from engineerS where place = '서울';

