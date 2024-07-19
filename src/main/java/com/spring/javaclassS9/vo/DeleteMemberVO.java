package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class DeleteMemberVO {
	private String deleteDate;
	private int deleteReason;
	private String reasonDetail;
	private String etc;
	
	private int reasonCnt;
}

