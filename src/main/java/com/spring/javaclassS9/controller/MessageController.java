package com.spring.javaclassS9.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MessageController {
	
	@RequestMapping(value = "/message/{msgFlag}", method = RequestMethod.GET)
	public String home(Model model,
			@PathVariable String msgFlag,
			@RequestParam(name="mid", defaultValue = "", required = false) String mid,
			@RequestParam(name="pathFlag", defaultValue = "", required = false) String pathFlag,
			@RequestParam(name="idx", defaultValue = "0", required = false) int idx
			) {
		
		if(msgFlag.equals("idCheckNo")) {
			model.addAttribute("msg", "이미 사용중인 아이디입니다.");
			model.addAttribute("url", "/member/memberJoin");
		}
		else if(msgFlag.equals("nickCheckNo")) {
			model.addAttribute("msg", "이미 사용중인 닉네임입니다.");
			model.addAttribute("url", "/member/memberJoin");
		}
		else if(msgFlag.equals("existMemberNo")) {
			model.addAttribute("msg", "회원정보가 존재합니다.\\n가입시 이용했던 아이디로 로그인을 시도해주세요.");
			model.addAttribute("url", "/member/memberLogin/main");
		}
		else if(msgFlag.equals("memberJoinOk")) {
			model.addAttribute("msg", "회원가입이 완료되었습니다.\\n로그인하여 다양한 서비스를 이용해보세요.");
			model.addAttribute("url", "/member/memberLogin/main");
		}
		else if(msgFlag.equals("memberJoinNo")) {
			model.addAttribute("msg", "회원가입에 실패했습니다. 입력 정보를 다시 한번 확인해주세요.");
			model.addAttribute("url", "/member/memberJoin");
		}
		else if(msgFlag.equals("memberLoginOk")) {
			model.addAttribute("msg", mid+"님, 환영합니다.");
			if(pathFlag.equals("main"))	model.addAttribute("url", "/");
			else if(pathFlag.equals("customer"))	model.addAttribute("url", "/customer/cmain");
		}
		else if(msgFlag.equals("memberLoginNo")) {
			model.addAttribute("msg", "아이디가 존재하지 않거나 비밀번호가 맞지 않습니다.");
			model.addAttribute("url", "/member/memberLogin/main");
		}
		else if(msgFlag.equals("memberLogout")) {
			model.addAttribute("msg", mid+"님, 로그아웃 되었습니다.");
			model.addAttribute("url", "/");
		}
		else if(msgFlag.equals("pwdChangeOk")) {
			model.addAttribute("msg", "비밀번호가 변경되었습니다.\\n새로운 비밀번호로 다시 로그인하세요.");
			model.addAttribute("url", "/member/memberLogin/main");
		}
		else if(msgFlag.equals("pwdChangeNo")) {
			model.addAttribute("msg", "비밀번호 변경 실패. 다시 시도하세요.");
			if(pathFlag.equals("engineer")) model.addAttribute("url", "/engineer/pwdChange");
			else model.addAttribute("url", "/member/pwdChange");
		}
		else if(msgFlag.equals("memberUpdateOk")) {
			model.addAttribute("msg", "회원 정보가 수정되었습니다.");
			model.addAttribute("url", "/member/myPage");
		}
		else if(msgFlag.equals("memberUpdateNo")) {
			model.addAttribute("msg", "회원 정보 수정 실패. 입력 정보를 다시 확인하세요.");
			model.addAttribute("url", "/member/myPage?part=1");
		}
		else if(msgFlag.equals("pwdCheckNo")) {
			model.addAttribute("msg", "비밀번호가 맞지 않습니다. 다시 확인하세요.");
			model.addAttribute("url", "/member/memberDelete");
		}
		else if(msgFlag.equals("memberDeleteOk")) {
			model.addAttribute("msg", "탈퇴 요청이 완료되었습니다.\\n한달 간 같은 아이디를 사용할 수 없습니다.");
			model.addAttribute("url", "/");
		}
		else if(msgFlag.equals("memberDeleteNo")) {
			model.addAttribute("msg", "탈퇴 요청이 제대로 진행되지 않았습니다.\\n관리자에게 문의하세요.");
			model.addAttribute("url", "/member/memberDelete");
		}
		else if(msgFlag.equals("emailInputOk")) {
			model.addAttribute("msg", "메일 전송이 완료되었습니다.");
			model.addAttribute("url", "/admin/member/memberList");
		}
		else if(msgFlag.equals("emailInputNo")) {
			model.addAttribute("msg", "메일 전송에 실패했습니다.");
			model.addAttribute("url", "/admin/emailInput");
		}
		else if(msgFlag.equals("engineerIdCheckNo")) {
			model.addAttribute("msg", "같은 이름의 사원이 존재합니다.");
			model.addAttribute("url", "/admin/engineer/engineerInput");
		}
		else if(msgFlag.equals("engineerJoinOk")) {
			model.addAttribute("msg", "엔지니어를 등록했습니다.");
			model.addAttribute("url", "/admin/engineer/engineerList");
		}
		else if(msgFlag.equals("engineerJoinNo")) {
			model.addAttribute("msg", "엔지니어 등록 실패.");
			model.addAttribute("url", "/admin/engineer/engineerInput");
		}
		else if(msgFlag.equals("asAppointmentOk")) {
			model.addAttribute("msg", "A/S신청이 완료되었습니다.\\n진행사항은 메뉴에서 확인할 수 있습니다.");
			model.addAttribute("url", "/customer/cmain");
		}
		else if(msgFlag.equals("asAppointmentNo")) {
			model.addAttribute("msg", "A/S신청에 실패했습니다.\\n다시 입력해주세요.");
			model.addAttribute("url", "/customer/requests/asAppointment");
		}
		else if(msgFlag.equals("productInputOk")) {
			model.addAttribute("msg", "판매 제품을 등록했습니다.");
			model.addAttribute("url", "/admin/product/productList");
		}
		else if(msgFlag.equals("productInputNo")) {
			model.addAttribute("msg", "판매 제품 등록에 실패했습니다.");
			model.addAttribute("url", "/admin/product/productInput");
		}
		else if(msgFlag.equals("productSaleCustomerInputOk")) {
			model.addAttribute("msg", "견적을 요청했습니다.");
			model.addAttribute("url", "/product/productSale");
		}
		else if(msgFlag.equals("productSaleCustomerInputNo")) {
			model.addAttribute("msg", "견적 요청 중 오류가 발생했습니다.\\n다시 시도해주세요.");
			model.addAttribute("url", "/product/productEstimate");
		}
		else if(msgFlag.equals("productEditOk")) {
			model.addAttribute("msg", "장비 내용이 수정되었습니다.");
			model.addAttribute("url", "/admin/product/productList");
		}
		else if(msgFlag.equals("productEditNo")) {
			model.addAttribute("msg", "장비 내용 수정 실패");
			model.addAttribute("url", "/admin/product/productEdit?idx="+idx);
		}
		else if(msgFlag.equals("engineerUpdateOk")) {
			model.addAttribute("msg", "엔지니어 정보를 수정했습니다.");
			if(pathFlag.equals("admin")) model.addAttribute("url", "/admin/engineer/engineerList");
			else model.addAttribute("url", "/engineer/myPageMain");
		}
		else if(msgFlag.equals("engineerUpdateNo")) {
			model.addAttribute("msg", "정보 수정 실패");
			if(pathFlag.equals("admin")) model.addAttribute("url", "/admin/engineer/engineerUpdate");
			else model.addAttribute("url", "/engineer/engineerUpdate");
		}
		else if(msgFlag.equals("boardInputOk")) {
			model.addAttribute("msg", "게시판에 글이 등록되었습니다.");
			if(pathFlag.equals("freeBoard")) model.addAttribute("url", "/customer/board/freeBoardList");
			else if(pathFlag.equals("questionBoard")) model.addAttribute("url", "/customer/board/questionBoardList");
			else if(pathFlag.equals("recruitBoard")) model.addAttribute("url", "/customer/board/recruitBoardList");
			else model.addAttribute("url", "/customer/cmain");
		}
		else if(msgFlag.equals("boardInputNo")) {
			model.addAttribute("msg", "글 등록 실패");
			if(pathFlag.equals("freeBoard")) model.addAttribute("url", "/customer/board/freeBoardInput");
			else if(pathFlag.equals("questionBoard")) model.addAttribute("url", "/customer/board/questionBoardInput");
			else if(pathFlag.equals("recruitBoard")) model.addAttribute("url", "/customer/board/recruitBoardInput");
			else model.addAttribute("url", "/customer/cmain");
		}
		else if(msgFlag.equals("boardEditOk")) {
			model.addAttribute("msg", "게시글이 수정되었습니다.");
			if(pathFlag.equals("freeBoard")) model.addAttribute("url", "/customer/board/freeBoardList");
			else if(pathFlag.equals("questionBoard")) model.addAttribute("url", "/customer/board/questionBoardList");
			else if(pathFlag.equals("recruitBoard")) model.addAttribute("url", "/customer/board/recruitBoardList");
			else model.addAttribute("url", "/customer/cmain");
		}
		else if(msgFlag.equals("boardEditNo")) {
			model.addAttribute("msg", "게시글 수정 실패");
			if(pathFlag.equals("freeBoard")) model.addAttribute("url", "/customer/board/freeBoardEdit?idx="+idx);
			else if(pathFlag.equals("questionBoard")) model.addAttribute("url", "/customer/board/questionBoardEdit?idx="+idx);
			else if(pathFlag.equals("recruitBoard")) model.addAttribute("url", "/customer/board/recruitBoardEdit?idx="+idx);
			else model.addAttribute("url", "/customer/cmain");
		}
		else if(msgFlag.equals("boardDeleteOk")) {
			model.addAttribute("msg", "게시글이 삭제되었습니다.");
			if(pathFlag.equals("freeBoard")) model.addAttribute("url", "/customer/board/freeBoardList");
			else if(pathFlag.equals("questionBoard")) model.addAttribute("url", "/customer/board/questionBoardList");
			else if(pathFlag.equals("recruitBoard")) model.addAttribute("url", "/customer/board/recruitBoardList");
			else model.addAttribute("url", "/customer/cmain");
		}
		else if(msgFlag.equals("boardDeleteNo")) {
			model.addAttribute("msg", "게시글 삭제 실패");
			if(pathFlag.equals("freeBoard")) model.addAttribute("url", "/customer/board/freeBoardContent?idx="+idx);
			else if(pathFlag.equals("questionBoard")) model.addAttribute("url", "/customer/board/questionBoardContent?idx="+idx);
			else if(pathFlag.equals("recruitBoard")) model.addAttribute("url", "/customer/board/recruitBoardContent?idx="+idx);
			else model.addAttribute("url", "/customer/cmain");
		}
		else if(msgFlag.equals("consultingInputOk")) {
			model.addAttribute("msg", "문의가 전송되었습니다.\\n답변에 2~3일 소요됩니다.");
			model.addAttribute("url", "/customer/cmain");
		}
		else if(msgFlag.equals("consultingInputNo")) {
			model.addAttribute("msg", "문의 등록 실패\\n다시 시도하세요");
			if(pathFlag.equals("service")) model.addAttribute("url", "/service/serviceMain");
			else model.addAttribute("url", "/service/complaintMain");
		}
		else if(msgFlag.equals("adminNo")) {
			model.addAttribute("msg", "관리자 전용 메뉴입니다. 일반 회원은 사용할 수 없습니다.");
			model.addAttribute("url", "/");
		}
		else if(msgFlag.equals("memberNo")) {
			model.addAttribute("msg", "회원 로그인 후 사용 가능합니다.");
			model.addAttribute("url", "/member/memberLogin/main");
		}
		else if(msgFlag.equals("engineerNo")) {
			model.addAttribute("msg", "엔지니어 전용 메뉴입니다. 일반 회원은 사용할 수 없습니다.");
			model.addAttribute("url", "/member/myPage");
		}
		else if(msgFlag.equals("memberLevelNo")) {
			model.addAttribute("msg", "재직자 회원만 사용 가능합니다.\\n재직자 인증을 받아주세요.");
			model.addAttribute("url", "/member/myPage");
		}
		else if(msgFlag.equals("noticeInputOk")) {
			model.addAttribute("msg", "공지사항이 등록되었습니다.");
			model.addAttribute("url", "/admin/notice/noticeList");
		}
		else if(msgFlag.equals("noticeInputNo")) {
			model.addAttribute("msg", "공지사항 등록 실패");
			model.addAttribute("url", "/admin/notice/noticeInput");
		}
		
		return "include/message";
	}
	
}
