package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class ReplyVO {
	private int idx;
	private String board;
	private int boardIdx;
	private int re_step;
	private int re_order;
	private int parentId;
	private String mid;
	private String nickName;
	private String replyDate;
	private String hostIp;
	private String content;
	private int report;
	
	private int hour_diff;
	private int date_diff;
}

