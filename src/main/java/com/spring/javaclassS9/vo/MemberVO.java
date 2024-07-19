package com.spring.javaclassS9.vo;

import lombok.Data;

@Data
public class MemberVO {
	private int idx;
	private String name;
	private String mid;
	private String pwd;
	private String nickName;
	private String birthday;
	private String email;
	private String emailNews;
	private String tel;
	private String address;
	private String m_group;
	private String co_name;
	private String co_category;
	private String co_address;
	private String co_tel;
	private String purpose;
	private int level;
	private int point;
	private String userDel;
	private String startDate;
	private String lastDate;
	
	private int deleteDiff;
	
	// 차트를 위한 vo
	private String joinDate;
	private int joinCnt;
}
