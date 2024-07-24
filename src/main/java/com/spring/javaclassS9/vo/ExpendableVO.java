package com.spring.javaclassS9.vo;

import com.spring.javaclassS9.vo.AsRequestVO.Machine;

import lombok.Data;

@Data
public class ExpendableVO {
	private int idx;
	private Machine categoryMain;
	private String expendableCode;
	private String expendableName;
	private int price;
}
