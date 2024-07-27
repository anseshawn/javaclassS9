show tables;

create table pdsS(
	idx int not null auto_increment,
	mid varchar(20) not null,
	title varchar(50) not null,
	content text,
	readNum int default 0,
	fileName varchar(200),
	fileSName varchar(200),
	fileSize int,
	writeDate datetime default now(),
	primary key(idx)
);

desc pdsS;