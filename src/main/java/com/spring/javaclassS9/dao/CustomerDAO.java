package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.AsRequestVO;

public interface CustomerDAO {

	public int setAsAppointmentOk(@Param("vo") AsRequestVO vo);

	public int totRecCnt(@Param("searchString") String searchString);
	
	public ArrayList<AsRequestVO> getAsRequestList(@Param("asMid") String asMid, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public AsRequestVO getAsRequestContent(@Param("idx") int idx);

	
}
