package com.cafe24.ourplanners.document.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.cafe24.ourplanners.document.domain.DocumentVO;
import com.cafe24.ourplanners.util.SearchDocumentCriteria;

public interface DocumentService {

	List<DocumentVO> getDocumentListJson(SearchDocumentCriteria srcri, HashMap<String, Object> map);

	DocumentVO write(DocumentVO vo);
	
	DocumentVO modify(DocumentVO vo);
	
	DocumentVO reply(DocumentVO vo);

	void view(Integer document_srl, Model model);

	DocumentVO findById(Integer document_srl);

	void delete(Integer document_srl);

	void deleteAll();

	

}
