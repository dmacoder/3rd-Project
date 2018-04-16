package com.cafe24.ourplanners.like.domain;

public class LikeVO {
	private String user_id;
	private int like_srl;
	private int board_srl;
	
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public int getLike_srl() {
		return like_srl;
	}
	public void setLike_srl(int like_srl) {
		this.like_srl = like_srl;
	}
	public int getBoard_srl() {
		return board_srl;
	}
	public void setBoard_srl(int board_srl) {
		this.board_srl = board_srl;
	}
}
