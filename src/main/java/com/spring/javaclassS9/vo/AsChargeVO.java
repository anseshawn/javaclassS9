package com.spring.javaclassS9.vo;

import com.spring.javaclassS9.vo.AsRequestVO.Machine;

import lombok.Data;

@Data
public class AsChargeVO {
	private int idx;
	private int asIdx;
	private int engineerIdx;
	private Machine categoryMain;
	private String expendableName;
	private int price;
	private String quantity;
	private int laborCharge;
	private int totPrice;
	private String chargeDate;
	private String payDate;
	private Statement statement;
	
	public enum Statement {
		WAITING, COMPLETE
	}
}

