package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class QuestionBoardVO {
	private int idx;
	private String mid;
	private String nickName;
	private String title;
	private String content;
	private String hostIp;
	private int readNum;
	private String writeDate;
	private String part;
	private int good;
	private int report;
	
	private int hour_diff;
	private int date_diff;
	private int replyCnt;
}

