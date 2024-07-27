package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class ChartVO {
	private String title;	// 차트 제목
	private String subTitle; // 차트 부제목
	private String part;
	
	private String xtitle; // x축 이름
	private String legend1; // x축 범례
	
}

