package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class OrderAddressVO {
	private int idx;
	private int saleIdx;
	private String addressName;
	private double longitude;
	private double latitude;
}

