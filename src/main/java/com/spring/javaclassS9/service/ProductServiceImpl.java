package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.common.JavaclassProvide;
import com.spring.javaclassS9.dao.ProductDAO;
import com.spring.javaclassS9.vo.ProductLikeVO;
import com.spring.javaclassS9.vo.ProductSaleVO;
import com.spring.javaclassS9.vo.ProductVO;
import com.spring.javaclassS9.vo.ProductSaleVO.Statement;

@Service
public class ProductServiceImpl implements ProductService {
	
	@Autowired
	ProductDAO productDAO;
	
	@Autowired
	JavaclassProvide javaclassProvide;

	@Override
	public int setProductInputOk(MultipartFile fName, ProductVO vo) {
		int res = 0;
		String oFileName = fName.getOriginalFilename();
		String sFileName = "";
		if(fName != null && oFileName != "") {
			sFileName = vo.getProName()+"_"+javaclassProvide.saveFileName(oFileName);
			try {
				javaclassProvide.writeFile(fName, sFileName, "product");
				res = 1;
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if(res != 0) vo.setProPhoto(sFileName);
		else vo.setProPhoto("noimage2.png");
		
		return productDAO.setProductInputOk(vo);
	}

	@Override
	public ArrayList<ProductVO> getAllProductList(int startIndexNo, int pageSize) {
		return productDAO.getAllProductList(startIndexNo,pageSize);
	}

	@Override
	public ProductVO getProductContent(int idx) {
		return productDAO.getProductContent(idx);
	}

	@Override
	public int setProductAddLike(int idx, String mid) {
		return productDAO.setProductAddLike(idx, mid);
	}

	@Override
	public int setProductRemoveLike(int idx, String mid) {
		return productDAO.setProductRemoveLike(idx, mid);
	}

	// 장비 관심 등록 한 적 있는지 확인
	@Override
	public ProductLikeVO getProductLikeList(String mid) {
		return productDAO.getProductLikeList(mid);
	}

	@Override
	public int setProductSaleCustomerInput(ProductSaleVO vo) {
		vo.setStatement(Statement.QUOTE);
		return productDAO.setProductSaleCustomerInput(vo);
	}
	
	
}
