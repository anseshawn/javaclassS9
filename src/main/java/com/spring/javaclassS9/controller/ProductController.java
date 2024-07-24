package com.spring.javaclassS9.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javaclassS9.pagination.PageProcess;
import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.service.MemberService;
import com.spring.javaclassS9.service.ProductService;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.PageVO;
import com.spring.javaclassS9.vo.ProductLikeVO;
import com.spring.javaclassS9.vo.ProductSaleVO;
import com.spring.javaclassS9.vo.ProductVO;

@Controller
@RequestMapping("/product")
public class ProductController {
	
	@Autowired
	EngineerService engineerService;
	
	@Autowired
	ProductService productService;
	
	@Autowired
	PageProcess pageProcess;
	
	@Autowired
	MemberService memberService;
	
	// 판매페이지 리스트
	@RequestMapping(value = "/productSale", method = RequestMethod.GET)
	public String productSaleGet(Model model,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "product", "", "");
		ArrayList<ProductVO> vos = productService.getAllProductList(pageVO.getStartIndexNo(),pageSize);
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "product/productSale";
	}
	
	// 장비 상세페이지(1건)
	@RequestMapping(value = "/productContent", method = RequestMethod.GET)
	public String productContentGet(Model model, HttpSession session,
			@RequestParam(name="idx",defaultValue = "0", required = false) int idx,
			@RequestParam(name="pag",defaultValue = "1", required = false) int pag,
			@RequestParam(name="pageSize",defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "part", defaultValue = "", required = false) String part,
			@RequestParam(name = "searchString", defaultValue = "", required = false) String searchString
			) {
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "product", "", "");
		ProductVO vo = productService.getProductContent(idx);
		String mid = (String) session.getAttribute("sMid");
		if(mid != null) {
			ArrayList<ProductLikeVO> vos = productService.getProductLikeList(mid);
			if(vos.size()!=0) {
				for(int i=0; i<vos.size(); i++) {
					if(vos.get(i).getProductIdx() == idx) model.addAttribute("likeSw", "act");
				}
			}
		}
		model.addAttribute("vo", vo);
		model.addAttribute("pageVO", pageVO);
		return "product/productContent";
	}
	
	// 관심 장비 등록
	@ResponseBody
	@RequestMapping(value = "/productAddLike", method = RequestMethod.POST)
	public String productAddLikePost(int idx, String mid) {
		return productService.setProductAddLike(idx, mid) + "";
	}
	// 관심 장비 삭제
	@ResponseBody
	@RequestMapping(value = "/productRemoveLike", method = RequestMethod.POST)
	public String productRemoveLikePost(int idx, String mid) {
		return productService.setProductRemoveLike(idx, mid) + "";
	}
	
	//장비 견적 요청
	@RequestMapping(value = "/productEstimate", method = RequestMethod.GET)
	public String productEstimateGet(Model model, HttpSession session,
			@RequestParam(name = "idx", defaultValue = "0", required = false) int idx
			) {
		ProductVO vo = null;
		if(idx != 0) {
			vo = productService.getProductContent(idx);
			model.addAttribute("vo", vo);
		}
		else {
			model.addAttribute("sw", "all");
		}
		String mid = (String) session.getAttribute("sMid");
		MemberVO mVo = memberService.getMemberIdCheck(mid);
		ArrayList<ProductVO> vos = productService.getAllProductList(-1, 0);
		model.addAttribute("vos", vos);
		model.addAttribute("mVo", mVo);
		return "product/productEstimate";
	}
	
	// 견적 요청 폼에서 장비명 변경시 이미지 변경
	@ResponseBody
	@RequestMapping(value = "/productEstimate/productImgChange", method = RequestMethod.POST)
	public String productImgChangePost(int idx) {
		ProductVO vo = productService.getProductContent(idx);
		return vo.getProPhoto();
	}
	// 견적 요청 보내기
	@RequestMapping(value = "/productEstimate", method = RequestMethod.POST)
	public String productEstimatePost(ProductSaleVO vo) {
		int res = productService.setProductSaleCustomerInput(vo);
		if(res != 0) return "redirect:/message/productSaleCustomerInputOk";
		else return "redirect:/message/productSaleCustomerInputNo";
	}
	
}
