package com.spring.javaclassS9.common;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

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
		else if(mailFlag.equals("adminSendEmail")) {
			content += "<h3>그린 엔지니어링에서 전해드립니다.</h3><br>";
			content += imsiContent+"<br><hr>";
		}
		
		content += "<p><img src='cid:logo.jpg'></p>";
		content += "<p>사이트 방문하기 : <a href='http://localhost:9090/javaclassS9/main'>javaclass</a>";
		// content += "<hr>";
		content = content.replace("\n", "<br>");
		messageHelper.setText(content, true);
		
		FileSystemResource file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/logo.jpg"));
		messageHelper.addInline("logo.jpg", file);
		
		mailSender.send(message);
		
		return "1";
	}
	
	// 파일 이름 변경하기(중복방지)
	public String saveFileName(String oFileName) {
		String fileName = "";
		
		Calendar cal = Calendar.getInstance(); // 싱글톤 객체랑 같은 형식(객체 생성 x)
		fileName += cal.get(Calendar.YEAR);
		fileName += cal.get(Calendar.MONTH)+1;
		fileName += cal.get(Calendar.DATE);
		fileName += cal.get(Calendar.HOUR_OF_DAY);
		fileName += cal.get(Calendar.MINUTE);
		fileName += cal.get(Calendar.SECOND);
		fileName += "_" + oFileName;
		
		return fileName;
	}
	
	// 파일 업로드
	public void writeFile(MultipartFile fName, String sFileName, String urlPath) throws IOException {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		FileOutputStream fos = new FileOutputStream(realPath+sFileName);
		if(fName.getBytes().length != -1) {
			fos.write(fName.getBytes());
		}
		fos.flush();
		fos.close();
	}
	
	// 파일 삭제
	public void deleteFile(String photo, String urlPath) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		
		File file = new File(realPath+photo);
		if(file.exists()) file.delete();
	}
	
}
