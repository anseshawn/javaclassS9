package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class ConsultingVO {
	private int idx;
	private ServicePart part;
	private String name;
	private String email;
	private String phone;
	private String title;
	private String content;
	private String writeDate;
	private String answer;
	private String completeDate;
	
	private int date_diff;
	private int date_diffC;
	private String mid;
	
	public enum ServicePart {
		SERVICE, COMPLAINT
	}
	
}

