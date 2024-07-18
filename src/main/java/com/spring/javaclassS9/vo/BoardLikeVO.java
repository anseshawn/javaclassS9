package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class BoardLikeVO {
	private int idx;
	private String memberMid;
	private String board;
	private int boardIdx;
	private String likeDate;
}

