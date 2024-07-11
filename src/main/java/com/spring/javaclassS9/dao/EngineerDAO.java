package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.ReviewVO;

public interface EngineerDAO {

	public EngineerVO getEngineerIdCheck(@Param("mid") String mid);

	public int setEngineerJoinOk(@Param("vo") EngineerVO vo);

	public int totRecCnt();

	public int totRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<EngineerVO> getEngineerSearchList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("part") String part, @Param("searchString") String searchString);

	public ArrayList<EngineerVO> getAllEngineerList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public EngineerVO getEngineerIdxCheck(@Param("idx") int idx);

	public int setEngineerReviewInput(@Param("idx") int engineerIdx, @Param("starPoint") double starAvg);

}
