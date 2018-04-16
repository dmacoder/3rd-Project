package com.cafe24.ourplanners.like.service;

import java.util.HashMap;

import com.cafe24.ourplanners.util.LikeCriteria;

public interface LikeService {

	void getLikeListJson(LikeCriteria lcri, HashMap<String, Object> map);

}
