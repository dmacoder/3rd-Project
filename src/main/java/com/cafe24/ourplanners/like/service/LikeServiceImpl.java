package com.cafe24.ourplanners.like.service;

import java.util.HashMap;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.cafe24.ourplanners.like.persistence.LikeDAO;
import com.cafe24.ourplanners.util.LikeCriteria;

@Service
public class LikeServiceImpl implements LikeService {
	
	@Inject
	private LikeDAO likeDAO;

	@Override
	public void getLikeListJson(LikeCriteria lcri, HashMap<String, Object> map) {
		
		
		
	}
	
	
	
}
