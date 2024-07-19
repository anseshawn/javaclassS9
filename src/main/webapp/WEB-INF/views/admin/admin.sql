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