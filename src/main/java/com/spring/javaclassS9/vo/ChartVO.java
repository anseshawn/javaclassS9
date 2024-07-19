package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class ChartVO {
	private String title;	// 차트 제목
	private String subTitle; // 차트 부제목
	private String part;
	
	private String xtitle; // x축 이름
	private String legend1; // x축 범례
	
	private String x1;
	private String x2;
	private String x3;
	private String x4;
	private String x5;
	
	private int value1;
	private int value2;
	private int value3;
	private int value4;
	private int value5;
	
}

