package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class ProductSaleVO {
	private int idx;
	private String memberMid;
	private int productIdx;
	private String requestDate;
	private Statement statement;
	private String co_name;
	private String tel;
	private String email;
	private String etcDetail;
	
	public enum Statement {
		QUOTE, CANCEL, ORDERING, DELIVER, PAYMENT, COMPLETE
	}
}

