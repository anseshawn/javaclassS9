package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class MessageVO {
	private int idx;
	private String sendMid;
	private String receiveMid;
	private String content;
	private String sendSw;
	private String sendDate;
	private String receiveSw;
	private String receiveDate;
}

