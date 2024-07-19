package com.spring.javaclassS9.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.dao.BoardDAO;
import com.spring.javaclassS9.vo.BoardLikeVO;
import com.spring.javaclassS9.vo.FreeBoardVO;
import com.spring.javaclassS9.vo.ReplyVO;
import com.spring.javaclassS9.vo.ReportVO;

@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	BoardDAO boardDAO;
	
	@Autowired
	JavaclassProvide javaclassProvide;

	@Override
	public ArrayList<FreeBoardVO> getFreeBoardList(int startIndexNo, int pageSize, String search, String searchString) {
		return boardDAO.getFreeBoardList(startIndexNo,pageSize,search,searchString);
	}

	@Override
	public ArrayList<FreeBoardVO> getFreeBoardBestList() {
		return boardDAO.getFreeBoardBestList();
	}

	@Override
	public FreeBoardVO getFreeBoardContent(int idx) {
		return boardDAO.getFreeBoardContent(idx);
	}

	// content에 이미지가 있다면 이미지를 'ckeditor'폴더에서 'board'폴더로 복사처리한다.
	@Override
	public void imgCheck(String content) {
		
		Document doc = Jsoup.parse(content); // content에 뽑아낼 html 문자열을 넣는다
		
		HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/");
		
		//List<String> imagesName = new ArrayList<>();
		Elements imgElements = doc.select("img"); // html 코드에서 img만 추출
		for (Element imgElement : imgElements) {
			String src = imgElement.attr("src"); // img 코드에서 src만 추출
			String fileName = "";
			// 이미지를 경로로 넣었나 직접 올렸나 확인
			if(src.indexOf("http") == -1) fileName = src.substring(src.lastIndexOf("/") + 1);
			else fileName = src;
			//imagesName.add(fileName); // images 리스트에 추가
			
			String origFilePath  = realPath+"ckeditor/" + fileName;
			String copyFilePath  = realPath+"freeBoard/" + fileName;
			javaclassProvide.fileCopyCheck(origFilePath,copyFilePath); // ckeditor폴더의 그림 파일을 board폴더 위치로 복사처리하는 메소드
		}
		//String imageFileName = String.join("|", imagesName); // 파일명들만 가진 문자열이 필요하면 join으로 결합
	}

	@Override
	public int setFreeBoardInput(FreeBoardVO vo) {
		return boardDAO.setFreeBoardInput(vo);
	}

	@Override
	public void imgDelete(String content) {
		Document doc = Jsoup.parse(content);
		
		Elements imgElements = doc.select("img");
		for(Element imgElement : imgElements) {
			String src = imgElement.attr("src");
			String fileName = "";
			
			if(src.indexOf("http") == -1) fileName = src.substring(src.lastIndexOf("/") + 1);
			else fileName = src;
			
			javaclassProvide.deleteFile(fileName, "freeBoard");
		}
	}
	
	@Override
	public int setFreeBoardEdit(FreeBoardVO vo) {
		return boardDAO.setFreeBoardEdit(vo);
	}

	@Override
	public ReplyVO getBoardParentReplyCheck(String board, int boardIdx) {
		return boardDAO.getBoardParentReplyCheck(board,boardIdx);
	}

	@Override
	public int setBoardReplyInput(ReplyVO vo) {
		return boardDAO.setBoardReplyInput(vo);
	}

	@Override
	public ArrayList<ReplyVO> getBoardReply(String board, int idx) {
		return boardDAO.getBoardReply(board,idx);
	}

	@Override
	public void setReplyOrderUpdate(String board, int boardIdx, int re_order) {
		boardDAO.setReplyOrderUpdate(board,boardIdx,re_order);
	}

	@Override
	public ReplyVO getBoardOtherReplyCheck(String board, int boardIdx, int parentId) {
		return boardDAO.getBoardOtherReplyCheck(board,boardIdx,parentId);
	}

	@Override
	public int setBoardReplyDelete(String board, int boardIdx, int idx) {
		return boardDAO.setBoardReplyDelete(board, boardIdx, idx);
	}

	@Override
	public ReplyVO getBoardReplyOne(String board, int boardIdx, int idx) {
		return boardDAO.getBoardReplyOne(board,boardIdx,idx);
	}

	@Override
	public int setBoardReplyUpdate(ReplyVO vo) {
		return boardDAO.setBoardReplyUpdate(vo);
	}

	@Override
	public int setFreeBoardDelete(int idx) {
		int res = boardDAO.setBoardReplyDelete("freeBoard", idx, 0);
		int res2 = 0;
		if(res != 0) res2 = boardDAO.setFreeBoardDelete(idx);
		return res2;
	}

	@Override
	public int setBoardLikeAdd(BoardLikeVO vo) {
		return boardDAO.setBoardLikeAdd(vo);
	}

	@Override
	public int setBoardLikeDelete(BoardLikeVO vo) {
		int res = boardDAO.setBoardLikeDelete(vo);
		int res2 = 0;
		if(res != 0) {
			if(vo.getBoard().equals("freeBoard")) res2 = boardDAO.setFreeBoardGoodDown(vo.getBoardIdx());
		}
		return res2;
	}

	@Override
	public int setFreeBoardGoodUpdate(int idx) {
		return boardDAO.setFreeBoardGoodUpdate(idx);
	}

	@Override
	public ArrayList<BoardLikeVO> getBoardLikeList(String board, String mid) {
		return boardDAO.getBoardLikeList(board,mid);
	}

	@Override
	public int setBoardReportInput(ReportVO vo) {
		ReportVO reportVO = boardDAO.getBoardReportRecord(vo);
		int res = 0;
		if(reportVO==null) res = boardDAO.setBoardReportInput(vo);
		return res;
	}

	@Override
	public void setFreeBoardReportUpdate(int boardIdx) {
		boardDAO.setFreeBoardReportUpdate(boardIdx);
	}

	@Override
	public void setFreeBoardReadNumPlus(int idx) {
		boardDAO.setFreeBoardReadNumPlus(idx);
	}

	@Override
	public ArrayList<BoardLikeVO> getBoardLikeListAll(String mid) {
		return boardDAO.getBoardLikeListAll(mid);
	}


}
