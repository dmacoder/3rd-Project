package com.cafe24.ourplanners.document.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.cafe24.ourplanners.document.domain.DocumentVO;
import com.cafe24.ourplanners.util.SearchDocumentCriteria;

@Repository
public class DocumentDAOImpl implements DocumentDAO{

	@Inject 
	private SqlSession sqlSession;
	private String namespace = "com.cafe24.ourplanners.mapper.DocumentMapper";
	
	@Override
	public List<DocumentVO> getDocumentListJson(SearchDocumentCriteria srcri) {
		return sqlSession.selectList(namespace+".getDocumentListJson",srcri);
		
	}

	@Override
	public int getTotalRecordCount(SearchDocumentCriteria srcri) {
		return sqlSession.selectOne(namespace+".getTotalRecordCount",srcri);
	}

	@Override
	public void updateStep(int parent,int step) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("parent", parent);
		paramMap.put("step", step);
		sqlSession.update(namespace +".updateStep", paramMap);
		
	}

	@Override
	public int write(DocumentVO vo) {
		// TODO Auto-generated method stub
		return sqlSession.insert(namespace +".insertDocument", vo);
	}

	@Override
	public DocumentVO read(int document_srl) {
		return sqlSession.selectOne(namespace+".readDocument", document_srl);
	}

	@Override
	public int reply(DocumentVO vo) {
		// TODO Auto-generated method stub
		return sqlSession.insert(namespace +".insertReDocument", vo);
	}

	@Override
	public int modify(DocumentVO vo) {
		return sqlSession.update(namespace +".updateDocument", vo);
	}
	
	

}
