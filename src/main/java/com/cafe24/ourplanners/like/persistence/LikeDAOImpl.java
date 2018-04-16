package com.cafe24.ourplanners.like.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class LikeDAOImpl implements LikeDAO{
	
	@Inject
	private SqlSession sqlSession;
	private static String namespace = "com.kosmo.mapper.LikeMapper";
	
	
}
