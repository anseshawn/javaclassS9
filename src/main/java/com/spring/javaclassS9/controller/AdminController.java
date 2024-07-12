package com.spring.javaclassS9.controller;

import java.util.ArrayList;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.pagination.PageProcess;
import com.spring.javaclassS9.service.AdminService;
import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.service.MemberService;
import com.spring.javaclassS9.service.ProductService;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.PageVO;
import com.spring.javaclassS9.vo.ProductVO;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	JavaclassProvide javaclassProvide;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	EngineerService engineerService;
	
	@Autowired
	ProductService productService;
	
	
	@RequestMapping(value = "/adminMain", method = RequestMethod.GET)
	public String adminMainGet() {
		return "admin/adminMain";
	}
	
	// 회원리스트(검색어 포함)
	@RequestMapping(value = "/member/memberList", method = RequestMethod.GET)
	public String memberListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString,
			@RequestParam(name = "m_group", defaultValue = "", required = false) String m_group
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "", "");
		
		ArrayList<MemberVO> vos = null;
		if(!m_group.equals("")) {
			pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "m_group", m_group);
			vos = adminService.getMemberLevelList(pageVO.getStartIndexNo(),pageSize,m_group);
		}
		else if(!part.equals("")) {
			pageVO = pageProcess.totRecCnt(pag, pageSize, "member", part, searchString);
			vos = adminService.getMemberSearchList(pageVO.getStartIndexNo(),pageSize,part,searchString);
		}
		else vos = adminService.getAllMemberList(pageVO.getStartIndexNo(),pageSize);
		
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "admin/member/memberList";
	}
	
	// 개별회원모달
	@ResponseBody
	@RequestMapping(value = "/member/memberList/{mid}", method = RequestMethod.POST)
	public MemberVO memberListPost(@PathVariable String mid) {
		MemberVO mVo = memberService.getMemberIdCheck(mid);
		return mVo;
	}
	
	// 개별회원 재직자로 등급 변경
	@ResponseBody
	@RequestMapping(value = "/member/memberChangeLevel", method = RequestMethod.POST)
	public String memberChangeLevelPost(@RequestParam(name = "mid", defaultValue = "", required = false) String mid) {
		return adminService.setMemberLevelUpdateOk(mid)+"";
	}
	
	// 개별회원 DB에서 영구삭제처리
	@ResponseBody
	@RequestMapping(value = "/member/memberDeleteAll", method = RequestMethod.POST)
	public String memberDeleteAllPost(@RequestParam(name = "mid", defaultValue = "", required = false) String mid) {
		return adminService.setMemberDeleteAll(mid)+"";
	}
	
	// 메일 전송 창 연결
	@RequestMapping(value = "/emailInput/{mids}", method = RequestMethod.GET)
	public String emailInputGet(Model model,
			@PathVariable String mids
			) {
		ArrayList<MemberVO> mVos = adminService.getAllMemberList(0, 0);
		model.addAttribute("mVos", mVos);
		
		if(!mids.equals("all")) model.addAttribute("toMail", mids);
		
		return "admin/emailInput";
	}
	
	// 메일 전송하기
	@RequestMapping(value = "/emailInput/{mids}", method = RequestMethod.POST)
	public String emailInputPost(String toMail, String title, String content,
			HttpServletRequest request, @PathVariable String mids) throws MessagingException {
		String res = "";
		MemberVO vo = null;
		if(toMail.contains(",")) { // 아이디로 여러명에게 전송
			String[] midStr = toMail.split(",");
			for(String mid : midStr) {
				vo = memberService.getMemberIdCheck(mid.trim());
				res = javaclassProvide.mailSend(vo.getEmail(), title, content, "adminSendEmail", request);
			}
		}
		else if(mids.equals("all") && toMail.contains("@")) { // 메일 주소로 한명에게 전송
			res = javaclassProvide.mailSend(toMail, title, content, "adminSendEmail", request);
		}
		else { // 멤버리스트에서 메일주소 클릭 시 한명에게 전송
			vo = memberService.getMemberIdCheck(toMail);
			res = javaclassProvide.mailSend(vo.getEmail(), title, content, "adminSendEmail", request);
		}
		
		if(res != "0") return "redirect:/message/emailInputOk";
		else return "redirect:/message/emailInputNo";
	}
	
	// 아이디로 멤버 검색
	@ResponseBody
	@RequestMapping(value = "/midSearch", method = RequestMethod.POST)
	public ArrayList<MemberVO> midSearchPost(Model model, String mid) {
		ArrayList<MemberVO> mVos = adminService.getMemberSearchList(0, 0, "mid", mid);
		//model.addAttribute("mVos", mVos);
		return mVos;
	}
	
	// 엔지니어 등록 창 출력
	@RequestMapping(value = "/engineer/engineerInput", method = RequestMethod.GET)
	public String engineerInputGet() {
		return "admin/engineer/engineerInput";
	}
	// 엔지니어 아이디 중복 검사
	@ResponseBody
	@RequestMapping(value = "/engineer/engineerIdCheck", method = RequestMethod.POST)
	public String engineerIdCheckPost(String mid) {
		EngineerVO vo = engineerService.getEngineerIdCheck(mid);
		MemberVO mVo = memberService.getMemberIdCheck(mid);
		if(vo != null || mVo != null) return "1";
		else return "0";
	}
	
	// 엔지니어 등록하기
	@RequestMapping(value = "/engineer/engineerInput", method = RequestMethod.POST)
	public String engineerInputPost(MultipartFile fName, EngineerVO vo) {
		if(engineerService.getEngineerIdCheck(vo.getMid()) != null) return "redirect:/message/engineerIdCheckNo";
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		
		int res = engineerService.setEngineerJoinOk(fName,vo);
		if(res != 0) return "redirect:/message/engineerJoinOk";
		else return "redirect:/message/engineerJoinNo";
	}
	

	// 엔지니어리스트(검색어 포함)
	@RequestMapping(value = "/engineer/engineerList", method = RequestMethod.GET)
	public String engineerListGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "engineer", "", "");
		
		ArrayList<EngineerVO> vos = null;
		if(!part.equals("")) {
			pageVO = pageProcess.totRecCnt(pag, pageSize, "engineer", part, searchString);
			vos = engineerService.getEngineerSearchList(pageVO.getStartIndexNo(),pageSize, part, searchString);
		}
		else vos = engineerService.getAllEngineerList(pageVO.getStartIndexNo(),pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "admin/engineer/engineerList";
	}
	
	// 개별사원모달
	@ResponseBody
	@RequestMapping(value = "/engineer/engineerList/{mid}", method = RequestMethod.POST)
	public EngineerVO engineerListPost(@PathVariable String mid) {
		EngineerVO mVo = engineerService.getEngineerIdCheck(mid);
		return mVo; 
	}
	
	// 개별사원 DB에서 영구삭제처리
	@ResponseBody
	@RequestMapping(value = "/engineer/engineerDeleteAll", method = RequestMethod.POST)
	public String engineerDeleteAllPost(@RequestParam(name = "mid", defaultValue = "", required = false) String mid) {
		return adminService.setEngineerDeleteAll(mid)+"";
	}
	
	// 제품 등록 창 출력
	@RequestMapping(value = "/product/productInput", method = RequestMethod.GET)
	public String productInputGet() {
		return "admin/product/productInput";
	}
	// 기기 등록하기
	@RequestMapping(value = "/product/productInput", method = RequestMethod.POST)
	public String productInputPost(MultipartFile fName, ProductVO vo) {
		int res = productService.setProductInputOk(fName,vo);
		if(res != 0) return "redirect:/message/productInputOk";
		else return "redirect:/message/productInputNo";
	}
	
	// 장비 리스트 창 출력
	@RequestMapping(value = "/product/productList", method = RequestMethod.GET)
	public String productListGet(Model model) {
		ArrayList<ProductVO> vos = productService.getAllProductList(0, 0);
		model.addAttribute("vos", vos);
		return "admin/product/productList";
	}
	
	// 장비 수정 창 출력
	@RequestMapping(value = "/product/productEdit", method = RequestMethod.GET)
	public String productEditGet(int idx, Model model) {
		ProductVO vo = productService.getProductContent(idx);
		model.addAttribute("vo", vo);
		return "admin/product/productEdit";
	}
	// 장비 수정하기
	@RequestMapping(value = "/product/productEdit", method = RequestMethod.POST)
	public String productEditPost(MultipartFile fName, ProductVO vo) {
		int res = productService.setProductContentEdit(fName, vo);
		if(res != 0) return "redirect:/message/productEditOk";
		else return "redirect:/message/productEditNo?idx="+vo.getIdx();
	}
	
	// 관리자 화면에서 장비 상세 보기
	@RequestMapping(value = "/product/productContent", method = RequestMethod.GET)
	public String productContentGet(Model model, int idx) {
		ProductVO vo = productService.getProductContent(idx);
		model.addAttribute("vo", vo);
		return "admin/product/productContent";
	}
	
	// 장비 삭제하기
	@ResponseBody
	@RequestMapping(value = "/product/productDelete", method = RequestMethod.POST)
	public String productDeletePost(int idx, String photo) {
		if(!photo.equals("noimage2.png")) javaclassProvide.deleteFile(photo, "product");
		return adminService.setProductDeleteOk(idx)+"";
	}
}
