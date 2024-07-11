show tables;

create table productS(
	idx int not null auto_increment,
	proType enum('UV','AAs','ICP','GC','LC','etc'),
	proName varchar(50) not null,
	proMade varchar(20) not null,
	proPrice int not null,
	proYear varchar(10) not null,
	proPhoto varchar(50) default 'noimage2.png',
	etcDetail text,s
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
	statement enum('QUOTE','CANCEL','ORDERING','DELIVER','PAYMENT','COMPLETE'),
	co_name varchar(20) not null,
	tel varchar(15) not null,
	email varchar(40) not null,
	etcDetail text,
	primary key(idx),
	foreign key(memberMid) references memberS(mid),
	foreign key(productIdx) references productS(idx)
);

drop table productSaleS;