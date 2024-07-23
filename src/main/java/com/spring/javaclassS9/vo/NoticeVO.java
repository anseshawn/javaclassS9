package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class NoticeVO {
	private int idx;
	private String part;
	private String title;
	private String content;
	private String popup;
	private String writeDate;
	private String endDate;
	private String important;
	
	private int date_diff;
	
}

