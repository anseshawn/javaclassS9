package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class AsRequestVO {
	private int idx;
	private String asMid;
	private String asName;
	private String asDate;
	private String asPlace;
	private String address;
	private int engineerIdx;
	private Machine machine;
	private Progress progress;
	private String requestDate;
	private String detailNote;
	private String endDate;
	private String comment;
	
	private String engineerName;
	private String engineerMid;
	private int date_diff;
	
	public enum Machine {
		UV, AAs, ICP, GC, LC, etc
	}
	
	public enum Progress {
		REGIST, ACCEPT, PROGRESS, PAYMENT, COMPLETE
	}
}

