package com.cafe24.ourplanners.util;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class DocumentCriteria extends com.cafe24.ourplanners.util.common.Criteria {

	private int document_srl;
	private String user_id;
	private String title;
	private String contents;
	@DateTimeFormat(pattern = "yyyy/MM/dd")
	private Date postdate;
	private int parent;
	private int step;
	private int indent;
	
	public int getDocument_srl() {
		return document_srl;
	}
	public void setDocument_srl(int document_srl) {
		this.document_srl = document_srl;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public Date getPostdate() {
		return postdate;
	}
	public void setPostdate(Date postdate) {
		this.postdate = postdate;
	}
	public int getParent() {
		return parent;
	}
	public void setParent(int parent) {
		this.parent = parent;
	}
	public int getStep() {
		return step;
	}
	public void setStep(int step) {
		this.step = step;
	}
	public int getIndent() {
		return indent;
	}
	public void setIndent(int indent) {
		this.indent = indent;
	}
	
	
}
