package com.spring.javaclassS9.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS9.vo.BoardLikeVO;
import com.spring.javaclassS9.vo.FreeBoardVO;
import com.spring.javaclassS9.vo.ReplyVO;
import com.spring.javaclassS9.vo.ReportVO;

public interface BoardDAO {

	public int totRecCnt();

	public int totRecCntSearch(@Param("search") String search, @Param("searchString") String searchString);

	public ArrayList<FreeBoardVO> getFreeBoardList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

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


}