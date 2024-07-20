package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class ReportVO {
	private int idx;
	private String board;
	private int boardIdx;
	private String rpMid;
	private String rpContent;
	private String rpDate;
	
	private int date_diff;
	
	private int fbIdx;
	private String fbTitle;
	private String fbContent;
	private String fbMid;
	private int qtIdx;
	private String qtTitle;
	private String qtContent;
	private String qtMid;
	
}

