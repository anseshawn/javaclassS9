package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class ScheduleVO {
	private int idx;
	private String title;
	private String startTime;
	private String endTime;
	private boolean allDay;
	
	private String engineerMid;
	private int engineerIdx;
	private String engineerName;
}

