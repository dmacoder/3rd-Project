package com.cafe24.ourplanners.document.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.cafe24.ourplanners.document.domain.DocumentVO;
import com.cafe24.ourplanners.document.persistence.DocumentDAO;
import com.cafe24.ourplanners.util.PagingUtil;
import com.cafe24.ourplanners.util.SearchDocumentCriteria;

@Service
public class DocumentServiceImpl implements DocumentService{

	@Inject
	private DocumentDAO dao;
	
	@Override
	public List<DocumentVO> getDocumentListJson(SearchDocumentCriteria srcri, HashMap<String, Object> map) {
		List<DocumentVO> lists = new ArrayList<DocumentVO>();
		
		lists = dao.getDocumentListJson(srcri);
		
		map.put("result", lists);
		
		int totalRecordCount = dao.getTotalRecordCount(srcri);
		
		String pagingDiv = PagingUtil.pagingAjaxDocument(totalRecordCount, srcri, "documentPaging");
		
		map.put("pagingDiv", pagingDiv);
		
		return lists;
	}

	@Override
	public DocumentVO write(DocumentVO vo) {
		
		return dao.read(dao.write(vo));
	}

	@Override
	public DocumentVO reply(DocumentVO vo) {
		DocumentVO parentVO = dao.read(vo.getDocument_srl());
		//기존 그룹화된 글들 스텝 증가
		dao.updateStep(parentVO.getParent(),parentVO.getStep());	
		
		vo.setParent(parentVO.getParent());
		vo.setIndent(parentVO.getIndent()+1);
		vo.setStep(parentVO.getStep()+1);
		
		return dao.read(dao.reply(vo));
	}

	@Override
	public void view(Integer document_srl, Model model) {
		
		DocumentVO vo = dao.read(document_srl);
		model.addAttribute("documentVO",vo);
	}

	@Override
	public DocumentVO findById(Integer document_srl) {
		return dao.read(document_srl);
	}

	@Override
	public void delete(Integer document_srl) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteAll() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public DocumentVO modify(DocumentVO vo) {
		// TODO Auto-generated method stub
		return dao.read(dao.modify(vo));
	}
	
}
