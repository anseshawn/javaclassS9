package com.spring.javaclassS9.controller;

import java.time.LocalDate;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.javaclassS9.pagination.PageProcess;
import com.spring.javaclassS9.service.AdminService;
import com.spring.javaclassS9.service.BoardService;
import com.spring.javaclassS9.vo.NoticeVO;
import com.spring.javaclassS9.vo.PageVO;
import com.spring.javaclassS9.vo.PdsVO;

@Controller
@RequestMapping("/company")
public class CompanyController {

	@Autowired
	AdminService adminService;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	BoardService boardService;
	
	@RequestMapping(value = "/aboutUs", method = RequestMethod.GET)
	public String aboutUsGet() {
		return "company/aboutUs";
	}
	
	// 공지 팝업창
	@RequestMapping(value = "/popupNotice", method = RequestMethod.GET)
	public String popupNoticeGet(Model model) {
		NoticeVO vo = adminService.getPopupNoticeContent();
		model.addAttribute("vo", vo);
		return "company/popupNotice";
	}
	
	// 공지사항 리스트
	@RequestMapping(value = "/noticeList", method = RequestMethod.GET)
	public String noticeListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
		) {
		ArrayList<NoticeVO> imVos = adminService.getImportantNoticeList();
		
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "notice", part, searchString);
		ArrayList<NoticeVO> vos = adminService.getNoticeListAll(pageVO.getStartIndexNo(),pageSize,part,searchString);
		if(!part.equals(""))	{
			if(part.equals("title")) part = "제목";
			else if(part.equals("content")) part = "내용";
			else if(part.equals("part")) part = "분류";
			model.addAttribute("part", part);
			model.addAttribute("searchString", searchString);
			model.addAttribute("searchCount", vos.size());
		}
		LocalDate today = LocalDate.now();
		model.addAttribute("today", today);
		model.addAttribute("imVos", imVos);
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "company/noticeList";
	}
	
	// 공지사항 내용보기
	@RequestMapping(value = "/noticeContent", method = RequestMethod.GET)
	public String noticeContentGet(Model model,
			@RequestParam(name="idx",defaultValue = "0", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "notice", part, searchString);
		NoticeVO vo = adminService.getNoticeContent(idx);
		LocalDate today = LocalDate.now();
		model.addAttribute("today", today);
		model.addAttribute("vo", vo);
		model.addAttribute("pageVO", pageVO);
		return "company/noticeContent";
	}
	
	// 자료실 내용 입력
	@RequestMapping(value = "/pds/pdsInput", method = RequestMethod.GET)
	public String pdsInputGet() {
		return "company/pds/pdsInput";
	}
	
	// 자료실 내용 입력
	@RequestMapping(value = "/pds/pdsInput", method = RequestMethod.POST)
	public String pdsInputPost(MultipartHttpServletRequest mFile, PdsVO vo) {
		int res = boardService.setPdsInputOk(mFile,vo);
		if(res != 0) return "redirect:/message/boardInputOk?pathFlag=pds";
		else return "redirect:/message/boardInputNo?pathFlag=pds";
	}
	
	// 자료실 리스트 보기
	@RequestMapping(value = "/pds/pdsList", method = RequestMethod.GET)
	public String pdsListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "pds", part, searchString);
		ArrayList<PdsVO> vos = boardService.getPdsListAll(pageVO.getStartIndexNo(),pageSize,part,searchString);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		
		return "company/pds/pdsList";
	}
	
	// 자료실 내용 보기
	@RequestMapping(value = "/pds/pdsContent", method = RequestMethod.GET)
	public String pdsContentGet(Model model, HttpSession session, HttpServletRequest request,
			@RequestParam(name="idx",defaultValue = "1", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString,
			@RequestParam(name = "fileLocation", defaultValue = "", required = false) String fileLocation
			) {
		
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "pds", part, searchString);
		PdsVO vo = boardService.getPdsContent(idx);
		if(vo==null) return "redirect:/message/boardContentNo?pathFlag=pds";
		
		// 게시글 조회수 1씩 증가시키기
		session = request.getSession();
		ArrayList<String> contentReadNum = (ArrayList<String>)session.getAttribute("sContentIdx");
		if(contentReadNum==null) contentReadNum = new ArrayList<String>();
		String imsiContentReadNum = "pds"+idx;
		if(!contentReadNum.contains(imsiContentReadNum)) {
			boardService.setRecruitBoardReadNumPlus(idx);
			contentReadNum.add(imsiContentReadNum);
		}
		session.setAttribute("sContentIdx", contentReadNum);
		
		model.addAttribute("vo", vo);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("fileLocation", fileLocation);
		
		return "company/pds/pdsContent";
	}
	
	// 자료실 내용 보기
	@RequestMapping(value = "/pds/pdsEdit", method = RequestMethod.GET)
	public String pdsContentGet(Model model, 
			@RequestParam(name="idx",defaultValue = "1", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize
			) {
		
		PdsVO vo = boardService.getPdsContent(idx);
		if(vo==null) return "redirect:/message/boardContentNo?pathFlag=pds";
		
		model.addAttribute("vo", vo);
		model.addAttribute("pag", pag);
		model.addAttribute("pageSize", pageSize);
		
		return "company/pds/pdsEdit";
	}
	
	// 자료실 내용 수정하기
	@RequestMapping(value = "/pds/pdsEdit", method = RequestMethod.POST)
	public String pdsEditPost(MultipartHttpServletRequest mFile, PdsVO vo) {
		int res = boardService.setPdsEditOk(mFile,vo);
		if(res != 0) return "redirect:/message/boardEditOk?pathFlag=pds";
		else return "redirect:/message/boardEditNo?pathFlag=pds?idx="+vo.getIdx();
	}
	
}
