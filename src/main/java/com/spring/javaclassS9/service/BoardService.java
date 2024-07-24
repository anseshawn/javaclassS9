package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.javaclassS9.vo.BoardLikeVO;
import com.spring.javaclassS9.vo.FreeBoardVO;
import com.spring.javaclassS9.vo.QuestionBoardVO;
import com.spring.javaclassS9.vo.RecruitBoardVO;
import com.spring.javaclassS9.vo.ReplyVO;
import com.spring.javaclassS9.vo.ReportVO;

public interface BoardService {

	public ArrayList<FreeBoardVO> getFreeBoardList(int startIndexNo, int pageSize, String search, String searchString);

	public ArrayList<FreeBoardVO> getFreeBoardBestList();

	public FreeBoardVO getFreeBoardContent(int idx);

	public void imgCheck(String content, String board);

	public int setFreeBoardInput(FreeBoardVO vo);

	public int setFreeBoardEdit(FreeBoardVO vo);

	public void imgDelete(String content, String board);

	public ReplyVO getBoardParentReplyCheck(String board, int boardIdx);

	public int setBoardReplyInput(ReplyVO vo);

	public ArrayList<ReplyVO> getBoardReply(String board, int idx);

	public void setReplyOrderUpdate(String board, int boardIdx, int re_order);

	public ReplyVO getBoardOtherReplyCheck(String board, int boardIdx, int parentId);

	public int setBoardReplyDelete(String board, int boardIdx, int idx);

	public ReplyVO getBoardReplyOne(String board, int boardIdx, int idx);

	public int setBoardReplyUpdate(ReplyVO vo);

	public int setFreeBoardDelete(int idx);

	public int setBoardLikeAdd(BoardLikeVO vo);

	public int setBoardLikeDelete(BoardLikeVO vo);

	public int setFreeBoardGoodUpdate(int idx);

	public ArrayList<BoardLikeVO> getBoardLikeList(String board, String mid);

	public int setBoardReportInput(ReportVO vo);

	public void setFreeBoardReportUpdate(int boardIdx);

	public void setFreeBoardReadNumPlus(int idx);

	public ArrayList<BoardLikeVO> getBoardLikeListAll(String mid);

	public ArrayList<QuestionBoardVO> getQuestionBoardList(int startIndexNo, int pageSize, String search,
			String searchString);

	public ArrayList<QuestionBoardVO> getRecentReplyQuestionBoard();

	public int setQuestionBoardInput(QuestionBoardVO vo);

	public QuestionBoardVO getQuestionBoardContent(int idx);

	public void setQuestionBoardReadNumPlus(int idx);

	public int setQuestionBoardGoodUpdate(int boardIdx);

	public void setQuestionBoardReportUpdate(int boardIdx);

	public ArrayList<RecruitBoardVO> getRecruitPartCount();

	public ArrayList<RecruitBoardVO> getRecruitBoardList(int startIndexNo, int pageSize, String part,
			String searchString);

	public int setRecruitBoardInput(MultipartHttpServletRequest mFile, RecruitBoardVO vo);

	public RecruitBoardVO getRecruitBoardContent(int idx);

	public int setRecruitBoardDelete(int idx, String rcfSName);

	public int setRecruitBoardEdit(MultipartHttpServletRequest mFile, RecruitBoardVO vo);

	public int setRecruitBoardGoodUpdate(int boardIdx);

	public void setRecruitBoardReportUpdate(int boardIdx);

	public void setRecruitBoardReadNumPlus(int idx);

	public int setQuestionBoardEdit(QuestionBoardVO vo);

	public int setQuestionBoardDelete(int idx);

}
