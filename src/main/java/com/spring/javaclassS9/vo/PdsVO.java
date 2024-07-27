package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class PdsVO {
	private int idx;
	private String mid;
	private String title;
	private String content;
	private int readNum;
	private String fileName;
	private String fileSName;
	private int fileSize;
	private String writeDate;
	
	private int date_diff;
	
}

