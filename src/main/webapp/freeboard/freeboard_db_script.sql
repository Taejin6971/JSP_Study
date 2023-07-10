/* Oracle DB (XE)  용 */ 
--- 게시판 ( 질문 답변형 게시판 ) 
Create Table freeboard (
    id number constraint PK_freeboard_id Primary Key,   -- 게시글 번호
    name varchar2(100) not null, 
    password varchar2(100) not null, 		-- 자신의 글을 삭제시 
    email varchar2(100) null, 
    subject varchar2(100) not null, 		-- 제목
    content varchar2(2000) not null, 		-- 글내용
    inputdate varchar2(100) not null, 		-- 글쓴날짜
    -- 답변글을 처리하는 컬럼 
    masterid number default 0 , 
    readcount number default 0 , 			-- 글 조회수
    replaynum number default 0 , 
    step number default 0
); 

select * from freeboard; 

/* MSSQL  DB (myDB)  용 */ 
--- 게시판 ( 질문 답변형 게시판 ) 
Create Table freeboard (
    id int constraint PK_freeboard_id Primary Key, 
    name varchar(100) not null, 
    password varchar(100) not null, 
    email varchar(100) null, 
    subject varchar(100) not null, 
    content varchar(2000) not null, 
    inputdate varchar(100) not null, 
    -- 답변글을 처리하는 컬럼 
    masterid int default 0 , 
    readcount int default 0 , 
    replaynum int default 0 , 
    step int default 0
); 

/* MY-SQL  DB (myDB)  용 */ 
Create Table freeboard (
    id int ,
    constraint PK_freeboard_id Primary Key (id) , 
    name varchar(100) not null, 
    password varchar(100) not null, 
    email varchar(100) null, 
    subject varchar(100) not null, 
    content varchar(2000) not null, 
    inputdate varchar(100) not null, 
    -- 답변글을 처리하는 컬럼 
    masterid int default 0 , 
    readcount int default 0 , 
    replaynum int default 0 , 
    step int default 0
); 



select * from freeboard; 






