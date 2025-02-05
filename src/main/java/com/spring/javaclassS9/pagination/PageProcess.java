package com.spring.javaclassS9.pagination;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS9.dao.AdminDAO;
import com.spring.javaclassS9.dao.BoardDAO;
import com.spring.javaclassS9.dao.CustomerDAO;
import com.spring.javaclassS9.dao.EngineerDAO;
import com.spring.javaclassS9.dao.MemberDAO;
import com.spring.javaclassS9.dao.ProductDAO;
import com.spring.javaclassS9.vo.PageVO;

@Service
public class PageProcess {
	
	@Autowired
	MemberDAO memberDAO;
	
	@Autowired
	EngineerDAO engineerDAO;
	
	@Autowired
	CustomerDAO customerDAO;
	
	@Autowired
	ProductDAO productDAO;
	
	@Autowired
	BoardDAO boardDAO;
	
	@Autowired
	AdminDAO adminDAO;
	
	// 게시판종류: section, 소분류: part
	public PageVO totRecCnt(int pag, int pageSize, String section, String part, String searchString) {
		PageVO pageVO = new PageVO();
		
		int totRecCnt = 0;
		String search = "";
		
		if(section.equals("member")) {
			if(part.equals(""))	totRecCnt = memberDAO.totRecCnt();
			else {
				search = part;
				totRecCnt = memberDAO.totRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("engineer")) {
			if(part.equals(""))	totRecCnt = engineerDAO.totRecCnt();
			else {
				search = part;
				totRecCnt = engineerDAO.totRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("asRequest")) {
			if(part.equals("mid")) totRecCnt = customerDAO.totRecCnt(searchString);
			else if(part.equals("engineerIdx")) totRecCnt = engineerDAO.totAsRequestRecCnt(searchString);
			else if(part.equals("searchDate")) {
				String[] keyword = searchString.split(",");
				totRecCnt = customerDAO.totAsRequestDateRecCnt(keyword[0],keyword[1],keyword[2]); // 아이디, 시작날짜, 끝날짜 순
			}
			else if(part.equals("searchDateEngineer")) {
				String[] keyword = searchString.split(",");
				int engineerIdx = Integer.parseInt(keyword[0]);
				totRecCnt = engineerDAO.totAsRequestDateRecCnt(engineerIdx,keyword[1],keyword[2]); // idx, 시작날짜, 끝날짜 순
			}
			System.out.println("토탈 : "+totRecCnt);
		}
		else if(section.equals("product")) {
			if(part.equals("")) totRecCnt = productDAO.totRecCnt();
		}
		else if(section.equals("productEstimate")) {
			if(part.equals("")) totRecCnt = productDAO.estimateTotRecCnt();
			else {
				search = part;
				totRecCnt = productDAO.estimateTotRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("pds")) {
			if(part.equals("")) totRecCnt = boardDAO.pdsTotRecCnt();
			else {
				search = part;
				totRecCnt = boardDAO.pdsTotRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("freeBoard")) {
			if(part.equals("")) totRecCnt = boardDAO.freeTotRecCnt();
			else {
				search = part;
				totRecCnt = boardDAO.freeTotRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("questionBoard")) {
			if(part.equals("")) totRecCnt = boardDAO.questionTotRecCnt();
			else {
				search = part;
				totRecCnt = boardDAO.questionTotRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("recruitBoard")) {
			if(part.equals("")) totRecCnt = boardDAO.recruitTotRecCnt();
			else {
				search = part;
				totRecCnt = boardDAO.recruitTotRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("reportBoardList")) {
			totRecCnt = adminDAO.reportBoardTotRecCnt();
		}
		else if(section.equals("reportMemberList")) {
			totRecCnt = memberDAO.reportMemberTotRecCnt();
		}
		else if(section.equals("adminAsRequestList")) {
			if(part.equals("")) totRecCnt = adminDAO.adminAsRequestTotRecCnt();
			else if(part.equals("searchDate")) {
				String[] keyword = searchString.split(",");
				String start = keyword[0];
				String end = keyword[1];
				totRecCnt = adminDAO.adminAsRequestDateTotRecCnt(start,end);
			}
			else {
				search = part;
				totRecCnt = adminDAO.adminAsRequestTotRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("consulting")) {
			if(part.equals("")) totRecCnt = adminDAO.consultingTotRecCnt();
			else {
				search = part;
				totRecCnt = adminDAO.consultingTotRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("consultingMember")) {
			String[] searchStrings = searchString.split("/");
			totRecCnt = memberDAO.consultingTotRecCnt(searchStrings[0],searchStrings[1]);
		}
		else if(section.equals("notice")) {
			if(part.equals("")) totRecCnt = adminDAO.noticeTotRecCnt();
			else {
				search = part;
				totRecCnt = adminDAO.noticeTotRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("faq")) {
			if(part.equals("")) {
				totRecCnt = adminDAO.faqTotRecCnt();
			}
			else if(searchString.equals("")) totRecCnt = adminDAO.faqTotRecCntPart(part);
			else totRecCnt = adminDAO.faqTotRecCntSearch(searchString);
		}
		else if(section.equals("writeBoard")) {
			if(part.equals("")) totRecCnt = boardDAO.writeBoardTotRecCnt(searchString);
			else {
				String[] keyWord = searchString.split(",");
				search = part;
				searchString = keyWord[0];
				totRecCnt = boardDAO.writeBoardTotRecCntSearch(search,searchString, keyWord[1]);
			}
		}
		else if(section.equals("writeReply")) {
			if(part.equals("")) totRecCnt = boardDAO.writeReplyTotRecCnt(searchString);
			else {
				String[] keyWord = searchString.split(",");
				search = part;
				searchString = keyWord[0];
				totRecCnt = boardDAO.writeReplyTotRecCntSearch(search,searchString, keyWord[1]);
			}
		}
		//else if(section.equals("pds"))	totRecCnt = pdsDAO.totRecCnt(part);
		
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStartNo = totRecCnt - startIndexNo;
		//System.out.println("curScrStartNo: "+curScrStartNo);
		int blockSize = 3;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;
		System.out.println("페이지네이션 startindexNo : "+startIndexNo);
		pageVO.setPag(pag);
		pageVO.setPageSize(pageSize);
		pageVO.setTotRecCnt(totRecCnt);
		pageVO.setTotPage(totPage);
		pageVO.setStartIndexNo(startIndexNo);
		pageVO.setCurScrStartNo(curScrStartNo);
		pageVO.setBlockSize(blockSize);
		pageVO.setCurBlock(curBlock);
		pageVO.setLastBlock(lastBlock);
		pageVO.setSearch(search);
		pageVO.setSearchString(searchString);
		pageVO.setPart(part);
		
		return pageVO;
	}
	
	
}
