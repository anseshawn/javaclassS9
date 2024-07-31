package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class ReportMemberVO {
	private int idx;
	private String hostIp;
	private String rpMid;
	private String rpDate;
	private String block;
	private int blockNum;
	
	private int rpNum;
}

