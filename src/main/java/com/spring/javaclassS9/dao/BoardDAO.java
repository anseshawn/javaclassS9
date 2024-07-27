package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.BoardLikeVO;
import com.spring.javaclassS9.vo.FreeBoardVO;
import com.spring.javaclassS9.vo.PdsVO;
import com.spring.javaclassS9.vo.QuestionBoardVO;
import com.spring.javaclassS9.vo.RecruitBoardVO;
import com.spring.javaclassS9.vo.ReplyVO;
import com.spring.javaclassS9.vo.ReportVO;

public interface BoardDAO {

	public int freeTotRecCnt();

	public int freeTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);
	
	public int questionTotRecCnt();
	
	public int questionTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<FreeBoardVO> getFreeBoardList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<FreeBoardVO> getFreeBoardBestList();

	public FreeBoardVO getFreeBoardContent(@Param("idx") int idx);

	public int setFreeBoardInput(@Param("vo") FreeBoardVO vo);

	public int setFreeBoardEdit(@Param("vo") FreeBoardVO vo);

	public ReplyVO getBoardParentReplyCheck(@Param("board") String board, @Param("boardIdx") int boardIdx);

	public int setBoardReplyInput(@Param("vo") ReplyVO vo);

	public ArrayList<ReplyVO> getBoardReply(@Param("board") String board, @Param("boardIdx") int idx);

	public void setReplyOrderUpdate(@Param("board") String board, @Param("boardIdx") int boardIdx, @Param("re_order") int re_order);

	public ReplyVO getBoardOtherReplyCheck(@Param("board") String board, @Param("boardIdx") int boardIdx, @Param("parentId") int parentId);

	public int setBoardReplyDelete(@Param("board") String board, @Param("boardIdx") int boardIdx, @Param("idx") int idx);

	public ReplyVO getBoardReplyOne(@Param("board") String board, @Param("boardIdx") int boardIdx, @Param("idx") int idx);

	public int setBoardReplyUpdate(@Param("vo") ReplyVO vo);

	public int setFreeBoardDelete(@Param("idx") int idx);

	public int setBoardLikeAdd(@Param("vo") BoardLikeVO vo);

	public int setBoardLikeDelete(@Param("vo") BoardLikeVO vo);

	public int setFreeBoardGoodUpdate(@Param("idx") int idx);

	public int setFreeBoardGoodDown(@Param("idx") int boardIdx);

	public ArrayList<BoardLikeVO> getBoardLikeList(@Param("board") String board, @Param("mid") String mid);

	public ReportVO getBoardReportRecord(@Param("vo") ReportVO vo);

	public int setBoardReportInput(@Param("vo") ReportVO vo);

	public void setFreeBoardReportUpdate(@Param("idx") int boardIdx);

	public void setFreeBoardReadNumPlus(@Param("idx") int idx);

	public ArrayList<BoardLikeVO> getBoardLikeListAll(@Param("mid") String mid);

	public ArrayList<QuestionBoardVO> getQuestionBoardList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize,
			@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<QuestionBoardVO> getRecentReplyQuestionBoard();

	public int setQuestionBoardInput(@Param("vo") QuestionBoardVO vo);

	public QuestionBoardVO getQuestionBoardContent(@Param("idx") int idx);

	public void setQuestionBoardReadNumPlus(@Param("idx") int idx);

	public int setQuestionBoardGoodUpdate(@Param("idx") int boardIdx);

	public int setQuestionBoardGoodDown(@Param("idx") int boardIdx);

	public void setQuestionBoardReportUpdate(@Param("idx") int boardIdx);

	public ArrayList<RecruitBoardVO> getRecruitPartCount();

	public int recruitTotRecCnt();

	public int recruitTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<RecruitBoardVO> getRecruitBoardList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize,
			@Param("search") String search, @Param("searchString") String searchString);

	public int setRecruitBoardInput(@Param("vo") RecruitBoardVO vo);

	public RecruitBoardVO getRecruitBoardContent(@Param("idx") int idx);

	public int setRecruitBoardDelete(@Param("idx") int idx);

	public int setRecruitBoardEdit(@Param("vo") RecruitBoardVO vo);

	public void setRecruitBoardReadNumPlus(@Param("idx") int idx);

	public int setRecruitBoardGoodUpdate(@Param("idx") int boardIdx);

	public void setRecruitBoardReportUpdate(@Param("idx") int boardIdx);

	public int setRecruitBoardGoodDown(@Param("idx") int boardIdx);

	public int setQuestionBoardEdit(@Param("vo") QuestionBoardVO vo);

	public int setQuestionBoardDelete(@Param("idx") int idx);

	public ArrayList<ReplyVO> getBoardReplyMidCheck(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("search") String search, @Param("searchString") String searchString, @Param("mid") String mid);

	public ArrayList<FreeBoardVO> getFreeBoardMidCheck(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("search") String search, @Param("searchString") String searchString, @Param("mid") String mid);

	public ArrayList<QuestionBoardVO> getQuestionBoardMidCheck(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("search") String search, @Param("searchString") String searchString, @Param("mid") String mid);

	public ArrayList<RecruitBoardVO> getRecruitBoardMidCheck(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("search") String search, @Param("searchString") String searchString, @Param("mid") String mid);

	public int writeBoardTotRecCnt(@Param("mid") String mid);

	public int writeBoardTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString, @Param("mid") String mid);

	public int writeReplyTotRecCnt(@Param("mid") String mid);

	public int writeReplyTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString, @Param("mid") String mid);

	public int setPdsInputOk(@Param("vo") PdsVO vo);

	public int pdsTotRecCnt();

	public int pdsTotRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<PdsVO> getPdsListAll(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize,
			@Param("search") String search, @Param("searchString") String searchString);

	public PdsVO getPdsContent(@Param("idx") int idx);

	public int setPdsEditOk(@Param("vo") PdsVO vo);

}
