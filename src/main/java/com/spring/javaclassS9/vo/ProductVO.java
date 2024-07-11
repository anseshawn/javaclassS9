package com.spring.javaclassS9.vo;

import com.spring.javaclassS9.vo.AsRequestVO.Machine;

import lombok.Data;

@Data
public class ProductVO {
	private int idx;
	private Machine proType;
	private String proName;
	private String proMade;
	private int proPrice;
	private String proYear;
	private String proPhoto;
	private String etcDetail;
	private String available;
}

