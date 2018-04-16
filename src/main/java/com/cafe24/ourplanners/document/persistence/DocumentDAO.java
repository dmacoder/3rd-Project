package com.cafe24.ourplanners.document.persistence;

import java.util.List;

import com.cafe24.ourplanners.document.domain.DocumentVO;
import com.cafe24.ourplanners.util.SearchDocumentCriteria;

public interface DocumentDAO {

	List<DocumentVO> getDocumentListJson(SearchDocumentCriteria srcri);

	int getTotalRecordCount(SearchDocumentCriteria srcri);

	void updateStep(int parent,int step);

	int write(DocumentVO vo);
	
	DocumentVO read(int document_srl);
	
	int reply(DocumentVO vo);
	
	int modify(DocumentVO vo);
}
