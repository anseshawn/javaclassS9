package com.spring.javaclassS9.service;

import java.util.ArrayList;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS9.vo.ProductLikeVO;
import com.spring.javaclassS9.vo.ProductSaleVO;
import com.spring.javaclassS9.vo.ProductVO;

public interface ProductService {

	public int setProductInputOk(MultipartFile fName, ProductVO vo);

	public ArrayList<ProductVO> getAllProductList(int startIndexNo, int pageSize);

	public ProductVO getProductContent(int idx);

	public int setProductAddLike(int idx, String mid);

	public int setProductRemoveLike(int idx, String mid);

	public ProductLikeVO getProductLikeList(String mid);

	public int setProductSaleCustomerInput(ProductSaleVO vo);

}