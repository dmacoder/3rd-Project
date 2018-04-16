package com.cafe24.ourplanners.util.common;

public class Criteria {

	//int offset = ; // 게시글 시작 번호 (page -1) * 10
	//int limit = 3; // 한 페이지에 출력할 게시물의 개수 (RPP =  Record per page)
	//int blockPage = 2; // 한 블럭에 표시할 페이지 번호의 개수
	
	private int page;
	private int limit;
	private int blockPage;
	private int offset;
	
	public Criteria(){
		this.page = 1;
		this.limit = 10;
		this.blockPage= 10;
		this.offset = 0;
	}

	public int getPage() {
		return page;
	}
	
	public void setPage(int page){
		
		if(page <= 0){
			this.page = 1;
			return;
		}
		
		this.page = page;
	}
	
	public int getPageSize(){
		
		return this.limit;
	}

	public void setPageSize(int limit){
		
		if(limit <= 0 || limit > 100){
			this.limit = 10;
			return;
		}
		
		this.limit = limit;
	}
	


	public int getBlockPage() {
		return blockPage;
	}
		
	public void setBlockPage(int blockPage) {
		
		if(blockPage <= 0 || blockPage > 100){
			this.blockPage = 10;
			return;
		}
		
		this.blockPage = blockPage;
	}
	

	//method for MyBatis SQL Mapper
	public int getPageStart() {
		
		return (this.page - 1) * limit +1;
	}
	
	//method for MyBatis SQL Mapper 
	public int getPageEnd() {
		return page * limit;
	}
	
	
	//oracle rownum 1부터 시작 mysql에서 offset의 경우 0 부터 시작 함.. limit 
	
	public void setOffset(int offset) {
		this.offset = offset;
	}

	//offset
	//method for MyBatis SQL Mapper
	public int getOffset() {
		
		return (this.page - 1) * limit +1;
	}
	
	//limit
	//method for MyBatis SQL Mapper 
	public int getLimit() {
		return page * limit;  // (this.page - 1) * limit +1 + limit => page*limit-
	}
	
	@Override
	public String toString() {
		return "Criteria [page=" + page + ", limit=" + limit + "]";
	}
}


