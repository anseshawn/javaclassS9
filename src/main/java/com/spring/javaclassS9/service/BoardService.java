package com.spring.javaclassS9.service;

import java.util.ArrayList;

import com.spring.javaclassS9.vo.BoardLikeVO;
import com.spring.javaclassS9.vo.FreeBoardVO;
import com.spring.javaclassS9.vo.ReplyVO;
import com.spring.javaclassS9.vo.ReportVO;

public interface BoardService {

	public ArrayList<FreeBoardVO> getFreeBoardList(int startIndexNo, int pageSize);

	public ArrayList<FreeBoardVO> getFreeBoardBestList();

	public FreeBoardVO getFreeBoardContent(int idx);

	public void imgCheck(String content);

	public int setFreeBoardInput(FreeBoardVO vo);

	public int setFreeBoardEdit(FreeBoardVO vo);

	public void imgDelete(String content);

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

}
