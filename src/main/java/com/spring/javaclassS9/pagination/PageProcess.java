package com.spring.javaclassS9.pagination;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
			if(part.equals("mid"))totRecCnt = customerDAO.totRecCnt(searchString);
			else if(part.equals("engineerIdx")) totRecCnt = engineerDAO.totAsRequestRecCnt(searchString);
		}
		else if(section.equals("product")) {
			if(part.equals(""))totRecCnt = productDAO.totRecCnt();
		}
		else if(section.equals("productEstimate")) {
			if(part.equals(""))totRecCnt = productDAO.estimateTotRecCnt();
			else {
				search = part;
				totRecCnt = productDAO.estimateTotRecCntSearch(search,searchString);
			}
		}
		else if(section.equals("freeBoard")) {
			if(part.equals(""))totRecCnt = boardDAO.totRecCnt();
			else {
				search = part;
				totRecCnt = boardDAO.totRecCntSearch(search,searchString);
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
