package com.spring.javaclassS9.controller;

import java.time.LocalDate;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.javaclassS9.pagination.PageProcess;
import com.spring.javaclassS9.service.AdminService;
import com.spring.javaclassS9.vo.NoticeVO;
import com.spring.javaclassS9.vo.PageVO;

@Controller
@RequestMapping("/company")
public class CompanyController {

	@Autowired
	AdminService adminService;
	
	@Autowired
	PageProcess pageProcess;
	
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
	
}
