package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class ReviewVO {
	private int idx;
	private String memberMid;
	private int asIdx;
	private int engineerIdx;
	private double starPoint;
	private String reviewDetail;
}

