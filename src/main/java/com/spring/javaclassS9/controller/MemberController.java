package com.spring.javaclassS9.controller;

import java.util.ArrayList;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.service.AdminService;
import com.spring.javaclassS9.service.BoardService;
import com.spring.javaclassS9.service.EngineerService;
import com.spring.javaclassS9.service.MemberService;
import com.spring.javaclassS9.service.ProductService;
import com.spring.javaclassS9.vo.BoardLikeVO;
import com.spring.javaclassS9.vo.EngineerVO;
import com.spring.javaclassS9.vo.FreeBoardVO;
import com.spring.javaclassS9.vo.MemberVO;
import com.spring.javaclassS9.vo.MessageVO;
import com.spring.javaclassS9.vo.ProductLikeVO;
import com.spring.javaclassS9.vo.ProductVO;
import com.spring.javaclassS9.vo.QuestionBoardVO;

@Controller
@RequestMapping("/member")
public class MemberController {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	JavaclassProvide javaclassProvide;
	
	@Autowired
	EngineerService engineerService;
	
	@Autowired
	ProductService productService;
	
	@Autowired
	BoardService boardService;
	
	@Autowired
	AdminService adminService;
	
	// 회원가입창 연결
	@RequestMapping(value = "/memberJoin", method = RequestMethod.GET)
	public String memberJoinGet() {
		return "member/memberJoin";
	}
	// 아이디 중복체크
	@ResponseBody
	@RequestMapping(value = "/memberIdCheck", method = RequestMethod.GET)
	public String memberIdCheckGet(String mid) {
		MemberVO vo = memberService.getMemberIdCheck(mid);
		EngineerVO eVo = engineerService.getEngineerIdCheck(mid);
		if(vo != null || eVo != null) return "1";
		else return "0";
	}
	// 닉네임 중복체크
	@ResponseBody
	@RequestMapping(value = "/memberNickCheck", method = RequestMethod.GET)
	public String memberNickCheckGet(String nickName) {
		MemberVO vo = memberService.getMemberNickCheck(nickName);
		if(vo != null) return "1";
		else return "0";
	}
	
	// 회원가입 진행
	@RequestMapping(value = "/memberJoin", method = RequestMethod.POST)
	public String memberJoinPost(MemberVO vo) {
		// 아이디, 닉네임 중복체크 한번 더
		if(memberService.getMemberIdCheck(vo.getMid()) != null || engineerService.getEngineerIdCheck(vo.getMid()) != null) return "redirect:/message/idCheckNo";
		if(memberService.getMemberNickCheck(vo.getNickName()) != null) return "redirect:/message/nickCheckNo";
		
		// 이름과 이메일이 모두 같은 경우 같은 회원으로 본다
		MemberVO mVo = memberService.getMemberNameCheck(vo.getName());
		if(mVo != null && mVo.getEmail().equals(vo.getEmail())) return "redirect:/message/existMemberNo";
		
		// 비밀번호 암호화
		vo.setPwd(passwordEncoder.encode(vo.getPwd()));
		
		if(vo.getEmailNews() == null) vo.setEmailNews("NO");
		
		int res = memberService.setMemberJoinOk(vo);
		if(res != 0) return "redirect:/message/memberJoinOk";
		else return "redirect:/message/memberJoinNo";
	}
	
	// 일반 로그인창 연결
	@RequestMapping(value = "/memberLogin/{pathFlag}", method = RequestMethod.GET)
	public String memberLoginGet(@PathVariable String pathFlag, HttpServletRequest request) {
		Cookie[] cookies = request.getCookies();
		if(cookies != null) {
			for(int i=0; i<cookies.length; i++) {
				if(cookies[i].getName().equals("cMid")) {
					request.setAttribute("mid", cookies[i].getValue());
					break;
				}
			}
		}
		return "member/memberLogin";
	}
	
	// 카카오 로그인 하기
	
	
	// 일반 로그인 성공 / 실패 처리
	@RequestMapping(value = "/memberLogin/{pathFlag}", method = RequestMethod.POST)
	public String memberLoginPost(HttpServletRequest request, HttpServletResponse response,
			HttpSession session, @PathVariable String pathFlag,
			@RequestParam(name="mid", defaultValue = "", required = false) String mid,
			@RequestParam(name="pwd", defaultValue = "", required = false) String pwd,
			@RequestParam(name="idSave", defaultValue = "", required = false) String idSave
			) {
		
		MemberVO vo = memberService.getMemberIdCheck(mid);
		EngineerVO eVo = engineerService.getEngineerIdCheck(mid);
		String loginOk = "";
		
		// 유저 / 엔지니어 로그인
		String strLevel = "";
		if(vo != null && vo.getUserDel().equals("NO") && passwordEncoder.matches(pwd, vo.getPwd())) {
			loginOk = "OK";
			if(vo.getLevel()==0) strLevel="관리자";
			else if(vo.getLevel()==1) strLevel="엔지니어";
			else if(vo.getLevel()==2) strLevel="기업회원";
			else if(vo.getLevel()==3) strLevel="일반회원";
			session.setAttribute("sNickName", vo.getNickName());
			session.setAttribute("sLevel", vo.getLevel());
		}
		else if(eVo != null && passwordEncoder.matches(pwd, eVo.getPwd())) {
			loginOk = "OK";
			strLevel="엔지니어";
			//System.out.println("eVo if문 통과");
			session.setAttribute("sLevel", eVo.getLevel());
			session.setAttribute("sNickName", eVo.getName());
		}
		
		// 전체 로그인 완료
		if(loginOk.equals("OK")) {
			// 1. 세션 처리
			session.setAttribute("strLevel", strLevel);
			session.setAttribute("sMid", mid);
			// 아이디 저장 처리
			if(idSave.equals("on")) {
				Cookie cookieMid = new Cookie("cMid", mid);
				cookieMid.setPath("/");
				cookieMid.setMaxAge(60*60*24*7);
				response.addCookie(cookieMid);
			}
			else {
				Cookie[] cookies = request.getCookies();
				if(cookies != null) {
					for(int i=0; i<cookies.length; i++) {
						if(cookies[i].getName().equals("cMid")) {
							cookies[i].setMaxAge(0);
							response.addCookie(cookies[i]);
							break;
						}
					}
				}
			}
			System.out.println("레벨 : "+strLevel);
			return "redirect:/message/memberLoginOk?mid="+mid+"&pathFlag="+pathFlag;
		}
		else return "redirect:/message/memberLoginNo";
	}
	
	// 일반 로그아웃
	@RequestMapping(value = "/memberLogout", method = RequestMethod.GET)
	public String memberLogoutGet(HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		session.invalidate();
		return "redirect:/message/memberLogout?mid="+mid;
	}
	
	// 아이디 찾기창 연결
	@RequestMapping(value = "/midSearch", method = RequestMethod.GET)
	public String midSearchGet() {
		return "/member/midSearch";
	}
	// 아이디찾기 결과
	@RequestMapping(value = "/midSearch", method = RequestMethod.POST)
	public String midSearchPost(String name, String email) {
		MemberVO vo = memberService.getMemberNameCheck(name);
		String mid = "";
		if(email.equals(vo.getEmail())){
			//int ran = (int)(Math.random()*4+1-2)+2;
			int ran = 0;
			if(vo.getMid().length()<=5) ran=2;
			else if(vo.getMid().length()<=7) ran=3;
			else ran=4;
			for(int i=0; i<vo.getMid().length(); i++) {
				if(i < ran) {
					mid += vo.getMid().charAt(i);					
				}
				else {
					mid += "*";
				}
			}
		}
		return "redirect:/member/midSearchResult?mid="+mid;
	}
	// 아이디찾기 결과창
	@RequestMapping(value = "/midSearchResult", method = RequestMethod.GET)
	public String midSearchResultGet(String mid, Model model) {
		model.addAttribute("mid",mid);
		return "/member/midSearchResult";
	}
	
	// 비밀번호 찾기
	@RequestMapping(value = "/pwdSearch", method = RequestMethod.GET)
	public String pwdSearchGet() {
		return "/member/pwdSearch";
	}
	// 임시 비밀번호 발급
	@ResponseBody
	@RequestMapping(value = "/pwdSearchOk", method = RequestMethod.POST)
	public String pwdSearchOkPost(String mid, String email, HttpSession session,
			HttpServletRequest request
			) throws MessagingException {
		MemberVO vo = memberService.getMemberIdCheck(mid);
		if(vo != null && vo.getEmail().equals(email)) {
			UUID uid = UUID.randomUUID();
			String pwd = uid.toString().substring(0,8);
			
			int pwdUpdate = memberService.setMemberPwdUpdate(mid, passwordEncoder.encode(pwd));
			
			String title = "임시 비밀번호 발급";
			String imsiContent = "임시 비밀번호 : <b>"+pwd+"</b>";
			String mailFlag = "pwdSearch";
			
			String res = javaclassProvide.mailSend(email, title, imsiContent, mailFlag, request);
			session.setAttribute("sLogin", "OK"); // 쿠키에 비밀번호 저장해서 만료기간...???
			return res+pwdUpdate;
		}
		return "0";
	}
	
	// 비밀번호 변경
	@RequestMapping(value = "/pwdChange", method = RequestMethod.GET)
	public String pwdChangeGet() {
		return "/member/pwdChange";
	}
	@RequestMapping(value = "/pwdChange", method = RequestMethod.POST)
	public String pwdChangePost(String mid, String pwdNew, HttpSession session) {
		int res = 0;
		res = memberService.setMemberPwdUpdate(mid, passwordEncoder.encode(pwdNew));
		if(res != 0) {
			session.invalidate();
			return "redirect:/message/pwdChangeOk";
		}
		else return "redirect:/message/pwdChangeNo";
	}
	
	// 마이페이지
	@RequestMapping(value = "/myPage", method = RequestMethod.GET)
	public String myPageGet(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		model.addAttribute("mid", mid);
		return "member/myPage";
	}
	// 회원정보수정창
	@RequestMapping(value = "/memberUpdate", method = RequestMethod.GET)
	public String memberUpdateGet(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		MemberVO vo = memberService.getMemberIdCheck(mid);
		model.addAttribute("vo",vo);
		return "member/memberUpdate";
	}
	// 회원정보수정처리
	@RequestMapping(value = "/myPage", method = RequestMethod.POST)
	public String memberUpdateGet(MemberVO vo, HttpSession session) {
		String originNickName = (String) session.getAttribute("sNickName");
		// 닉네임 중복체크 한번 더
		if(!originNickName.equals(vo.getNickName()) && memberService.getMemberNickCheck(vo.getNickName()) != null) return "redirect:/message/nickCheckNo";
		
		// 수정한 이름과 이메일이 모두 같은 회원이 존재할 경우 거절
		MemberVO mVo = memberService.getMemberIdCheck(vo.getMid());
		if(!mVo.getName().equals(vo.getName())) {
			if(mVo.getEmail().equals(vo.getEmail())) return "redirect:/message/existMemberNo";
		}
		
		if(vo.getEmailNews() == null) vo.setEmailNews("NO");
		
		int res = memberService.setMemberUpdateOk(vo);
		if(res != 0) return "redirect:/message/memberUpdateOk";
		else return "redirect:/message/memberUpdateNo";
	}
	
	// 회원 탈퇴 화면
	@RequestMapping(value = "/memberDelete", method = RequestMethod.GET)
	public String memberDeleteGet() {
		return "member/memberDelete";
	}
	// 회원 탈퇴하기
	@RequestMapping(value = "/memberDelete", method = RequestMethod.POST)
	public String memberDeletePost(String deleteReason, String pwd, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		
		// 비밀번호 확인
		MemberVO vo = memberService.getMemberIdCheck(mid);
		if(!passwordEncoder.matches(pwd, vo.getPwd())) return "redirect:/message/pwdCheckNo";
		
		String etcReason="";
		if(deleteReason.contains("/")) {
			String[] reasons = deleteReason.split("/");
			deleteReason = reasons[0];
			etcReason = reasons[1];
		}
		int res = memberService.setMemberDeleteOk(mid);
		
		// adminService 에서 탈퇴사유 추가하기 (탈퇴사유 한글로 바꾸는건 서비스에서...?)
		adminService.setMemberDeleteReason(deleteReason,etcReason);
		
		if(res != 0) {
			session.invalidate();
			return "redirect:/message/memberDeleteOk";
		}
		else return "redirect:/message/memberDeleteNo";
	}
	
	// 마이페이지 - 관심장비목록
	@RequestMapping(value = "/machineLikeList", method = RequestMethod.GET)
	public String machineLikeListGet(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		ArrayList<ProductLikeVO> likeVOS = productService.getProductLikeList(mid);
		ArrayList<ProductVO> vos = new ArrayList<ProductVO>();
		for(int i=0; i<likeVOS.size(); i++) {
			ProductVO vo = productService.getProductContent(likeVOS.get(i).getProductIdx());
			vos.add(vo);
		}
		model.addAttribute("vos", vos);
		return "member/machineLikeList";
	}
	
	// 마이페이지 - 관심글목록
	@RequestMapping(value = "/boardLikeList", method = RequestMethod.GET)
	public String boardLikeListGet(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		ArrayList<BoardLikeVO> likeVOS = boardService.getBoardLikeListAll(mid);
		ArrayList<FreeBoardVO> freeBoardVOS = new ArrayList<FreeBoardVO>();
		ArrayList<QuestionBoardVO> questionBoardVOS = new ArrayList<QuestionBoardVO>();
		for(int i=0; i<likeVOS.size(); i++) {
			if(likeVOS.get(i).getBoard().equals("freeBoard")){
				FreeBoardVO fVo = boardService.getFreeBoardContent(likeVOS.get(i).getBoardIdx());
				freeBoardVOS.add(fVo);
			}
			if(likeVOS.get(i).getBoard().equals("questionBoard")) {
				QuestionBoardVO qVo = boardService.getQuestionBoardContent(likeVOS.get(i).getBoardIdx());
				questionBoardVOS.add(qVo);
			}
		}
		model.addAttribute("freeBoardVOS", freeBoardVOS);
		model.addAttribute("questionBoardVOS", questionBoardVOS);
		return "member/boardLikeList";
	}
	
	// 마이페이지 - 쪽지 확인
	@RequestMapping(value = "/messageList", method = RequestMethod.GET)
	public String messageListGet(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		ArrayList<MessageVO> receiveVOS = memberService.getAllReceiveMessageList(mid);
		ArrayList<MessageVO> sendVOS = memberService.getAllSendMessageList(mid);
		for(int i=0; i<receiveVOS.size(); i++) {
			if(receiveVOS.get(i).getReceiveSw().equals("n")) model.addAttribute("newMsg", "OK");
		}
		model.addAttribute("receiveVOS", receiveVOS);
		model.addAttribute("sendVOS", sendVOS);
		return "member/messageList";
	}
	// 마이페이지 - 쪽지 수신확인 상태로 만들기
	@ResponseBody
	@RequestMapping(value = "/messageCheck", method = RequestMethod.POST)
	public void messageCheckPost(int idx) {
		memberService.setMessageCheck(idx);
	}
	// 마이페이지 - 받은 메세지 / 보낸 메세지 삭제하기
	@ResponseBody
	@RequestMapping(value = "/messageDelete", method = RequestMethod.POST)
	public String messageDeletePost(int idx, String sw) {
		int res =	memberService.setMessageDelete(idx, sw);
		return res + "";
	}
	
	// 쪽지 보내기 창
	@RequestMapping(value = "/sendMessage", method = RequestMethod.GET)
	public String sendMessageGet(Model model,
			@RequestParam(name = "receiveMid", defaultValue = "", required = false) String receiveMid
			) {
		model.addAttribute("receiveMid", receiveMid);
		return "member/sendMessage";
	}
	// 쪽지 보내기
	@ResponseBody
	@RequestMapping(value = "/sendMessage", method = RequestMethod.POST)
	public String sendMessagePost(MessageVO vo) {
		MemberVO mVo = memberService.getMemberIdCheck(vo.getReceiveMid());
		int res = 0;
		if(mVo==null) return res+"";
		else {
			vo.setSendSw("s");
			vo.setReceiveSw("n");
			res = memberService.setMessageInputOk(vo);
		}
		return res + "";
	}
	// 쪽지 완전 삭제하기 (DB삭제)
	@ResponseBody
	@RequestMapping(value = "/messageDeleteDB", method = RequestMethod.POST)
	public String messageDeleteDBPost(int idx) {
		int res =	memberService.setMessageDeleteDB(idx);
		return res + "";
	}
}
