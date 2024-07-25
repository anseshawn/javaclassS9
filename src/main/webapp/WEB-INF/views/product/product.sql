show tables;

create table productS(
	idx int not null auto_increment,
	proType enum('UV','AAs','ICP','GC','LC','etc'),
	proName varchar(50) not null,
	proMade varchar(20) not null,
	proPrice int not null,
	proYear varchar(10) not null,
	proPhoto varchar(50) default 'noimage2.png',
	etcDetail text,
	available varchar(2) not null default 'OK',
	primary key(idx)
);

desc productS;

create table productLikeS(
	idx int not null auto_increment,
	memberMid varchar(20) not null,
	productIdx int not null,
	likeDate datetime default now(),
	primary key(idx),
	foreign key(memberMid) references memberS(mid),
	foreign key(productIdx) references productS(idx)
);

desc productLikeS;

create table productSaleS(
	idx int not null auto_increment,
	memberMid varchar(20) not null,
	productIdx int not null,
	requestDate datetime default now(),
	statement enum('QUOTE','CANCEL','CHECK','ORDERING','DELIVER','PAYMENT','COMPLETE'),
	/* 요청(QUOTE), 취소(CANCEL), 견적확인(관리자)(CHECK), 발주요청(ORDERING), 발주진행(DELEVER), 결제대기(PAYMENT), 진행완료(COMPLETE) */
	co_name varchar(20) not null,
	tel varchar(15) not null,
	email varchar(40) not null,
	etcDetail text,
	primary key(idx),
	foreign key(memberMid) references memberS(mid),
	foreign key(productIdx) references productS(idx)
);

create table productEstimateS(
	idx int not null auto_increment,
	saleIdx int not null,
	productIdx int not null,
	sendDate datetime default now(),
	statement enum('QUOTE','CANCEL','CHECK','ORDERING','DELIVER','PAYMENT','COMPLETE'),
	proPrice int not null,			/* 단가 */
	quantity int not null,			/* 수량 */
	unitPrice int not null,			/* 단가 x 수량 */
	vat int not null,						/* 부가세 */
	totPrice int not null,			/* 총합계 */
	payDate datetime,
	primary key(idx),
	foreign key(saleIdx) references productSaleS(idx) on delete cascade,
	foreign key(productIdx) references productS(idx) on delete cascade
);

create table expendableS(
	idx int not null,
	categoryMain enum('UV','AAs','ICP','GC','LC','etc'),
	expendableCode varchar(3) not null,
	expendableName varchar(50) not null,
	price int not null,
	primary key(idx)
);

desc expendableS;
drop table expendableS;