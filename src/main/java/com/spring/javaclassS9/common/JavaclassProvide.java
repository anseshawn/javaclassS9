package com.spring.javaclassS9.common;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class JavaclassProvide {
	@Autowired
	JavaMailSender mailSender;
	
	
	public String mailSend(String toMail, String title, String imsiContent, String mailFlag, HttpServletRequest request) throws MessagingException {
		String content = "";
		
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper = new MimeMessageHelper(message, true,  "UTF-8");
		
		messageHelper.setTo(toMail);
		messageHelper.setSubject(title);
		messageHelper.setText(content);
		
		if(mailFlag.equals("pwdSearch")) {
			content += "<br><hr><h3>임시 비밀번호 발급</h3><hr><br>";
			content += imsiContent+"<br>";
			content += "<div>로그인 후 비밀번호를 변경해주세요.</div><br><hr>";
		}
		
		content += "<p><img src='cid:logo.jpg'></p>";
		content += "<p>사이트 방문하기 : <a href='http://localhost:9090/javaclassS9/main'>javaclass</a>";
		content += "<hr>";
		content = content.replace("\n", "<br>");
		messageHelper.setText(content, true);
		
		FileSystemResource file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/logo.jpg"));
		messageHelper.addInline("logo.jpg", file);
		
		mailSender.send(message);
		
		return "1";
	}
}
