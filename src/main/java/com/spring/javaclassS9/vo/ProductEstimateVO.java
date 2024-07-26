package com.spring.javaclassS9.vo;

import com.spring.javaclassS9.vo.ProductSaleVO.Statement;

import lombok.Data;

@Data
public class ProductEstimateVO {
	private int idx;
	private int saleIdx;
	private int productIdx;
	private String co_name;
	private String name;
	private String email;
	private String sendDate;
	private Statement statement;
	private int proPrice;
	private int quantity;
	private int unitPrice;
	private int vat;
	private int totPrice;
	private String payDate;
	
	private String proName;
	
}

