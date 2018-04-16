<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="today" class="java.util.Date" scope="page" />
<style>
.like {
	border: 0;
	background: none;
	outline: none;
}

.like.active {
	color: red;
}
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/view.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<script type="text/javascript" charset="utf-8">
	sessionStorage.setItem("contextpath", "${pageContext.request.contextPath}");
	
	//넘어온 값이 빈값인지 체크합니다. // !value 하면 생기는 논리적 오류를 제거하기 위해 // 명시적으로 value == 사용 //
	//[], {} 도 빈값으로 처리
	var isEmpty = function(value){ if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){ return true }else{ return false } };
	var board_srl = '<c:out value="${view.board_srl}"/>';
	
	
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#boardListBtn").on("click",function(){
		var searchType = $('#select-form-control option:selected').val();

		var nowPage = $('#nowPage').val();
		
		var keyword = $('#keyword').val();
		
		var category_srl = $('#category_srl').val();
		
		var subcategory_srl = $('#subcategory_srl').val();
		
		var board_type = $('#board_type').val();
		
		//if (keyword == null || keyword.length() == 0) 
		getServiceSearchList(nowPage, category_srl, subcategory_srl, board_type, searchType, keyword);
	});
	
	var board_srl = '<c:out value="${view.board_srl}"/>';
	
	var srl = ${view.board_srl};
	
	getListComment(1, srl, "R");
	
	/* var url = "./reply/list/"+${view.board_srl};
	
	$.ajax({
		url : url,
		dataType : "html",
		type : "get",
		contentType : "text/html; charset:UTF-8",
		data : {param1:"값1"},
		success : function(d){
			$('#listReply').html(d); 
		},
		error : function(d){
			alert("실패 : "+d.status+":"+d.statusText);
		}
	});
	 */
	 
	 
	//채택요청 등록하기
	$('#requestSubmit').click(function(){
		
		//alert('요청등록');
		
		if($("textarea[id='requestText']").val()==""){
			alert("등록할 요청내용을 입력하세요");
			return false;
		}
		
		//$.ajax메소드 사용
		
		var submit_url = "${pageContext.request.contextPath}/comment";
		var user_id = $("input[type='text'][name='user_id']").val();
		var parent_board_srl = $("input[type='text'][id='parent_board_srl_R']").val();
	 	var comments = $("textarea[name='comments']").val();
	 	var params = $('#requestCommentsForm').serialize();
	 	
	 	//var comment_type = "R";
	 	//alert(params);
		
		$.ajax({
			cache : false, // 캐시 사용 없애기
			url : "${pageContext.request.contextPath}/comment",
			type : "post",
			dataType : "json",
			//contentType : "text/html; charset=utf-8",
			data : params,
			
			/*  data : JSON.stringify({
				//user_id : user_id,
				comment_type : comment_type,
				parent_board_srl : parent_board_srl,
				comments : comments
		}),  */
		
			success : function(d){
				if (d.result == "fail") {
					if (d.errorMsg == "isNotLogin") {
						popLayerMsg("댓글을 작성하시려면 로그인 해주세요.");
						location.href = "${pageContext.request.contextPath}/member/login";
					} 

				} else if (d.result == "success") {

					/* console.log("result: " + d.result); */
					popLayerMsg("채택 요청 작성이 성공하였습니다.");
					getListComment(1, '<c:out value="${view.board_srl}"/>', 'R');
					//$('#boardListBtn').trigger('click');
					//location.href = "${pageContext.request.contextPath}/customercenter/board";
				}

			},
			error : function(request, status, error){
				popLayerMsg("status:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});
	});
	 
	 
	$('#commentSubmit').click(function(){
		//alert('요청등록');
		
		if($("textarea[id='commentText']").val()==""){
			alert("후기를 입력하세요");
			return false;
		}
		
		//$.ajax메소드 사용
		
		var submit_url = "${pageContext.request.contextPath}/comment";
		var user_id = $("input[type='text'][name='user_id']").val();
		var parent_board_srl = $("input[type='text'][id='parent_board_srl_C']").val();
	 	var comments = $("textarea[id='commentText']").val();
	 	var params = $('#commentCommentsForm').serialize();
	 	
	 	//var comment_type = "R";
	 	//alert(params);
		
		$.ajax({
			cache : false, // 캐시 사용 없애기
			url : "${pageContext.request.contextPath}/comment",
			type : "post",
			dataType : "json",
			//contentType : "text/html; charset=utf-8",
			data : params,
			
			/*  data : JSON.stringify({
				//user_id : user_id,
				comment_type : comment_type,
				parent_board_srl : parent_board_srl,
				comments : comments
		}),  */
		
			success : function(d){
				if (d.result == "fail") {
					if (d.errorMsg == "isNotLogin") {
						popLayerMsg("후기를 작성하시려면 로그인 해주세요.");
						location.href = "${pageContext.request.contextPath}/member/login";
					} 

				} else if (d.result == "success") {

					/* console.log("result: " + d.result); */
					popLayerMsg("후기 작성이 성공하였습니다.");
					
					getListComment(1, '<c:out value="${view.board_srl}"/>', 'C');
					
					//$('#boardListBtn').trigger('click');
					//location.href = "${pageContext.request.contextPath}/customercenter/board";
				}

			},
			error : function(request, status, error){
				popLayerMsg("status:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		});	
	});
	 
	 
	 
});


function deleteBoard(board_srl) {
	
	if(confirm("정말로 삭제 하시겠습니까?")){
	var url = "${pageContext.request.contextPath}/board/service/"+board_srl;
	//alert(url);
	$.ajax({
		url:url,
		type : 'delete',
		headers : {
			"Content-Type" : "application/json",
			"X-HTTP-Method-Override" : "DELETE"
		},
		/* data : JSON.stringify({
			replytext : replytext
		}), */
		dataType:"json",
		contentType:"text/html; charset:utf-8",
		success:function(d){
			if(d.result == "fail"){
				popLayerMsg("게시물 삭제에 실패하였습니다.");
			}
			else if(d.result == "success"){
				popLayerMsg("게시물 삭제에 성공하였습니다.");
				$('#boardListBtn').trigger('click');
				//$("#noticeDiv_"+board_srl).hide(1000);
				//$(this).parent().hide();
			}						
		},
		error : function(request, status, error){
			popLayerMsg("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	}
}

//수정폼 가져오기
function modifyBoard(board_srl) {
//$("#noticeHead").text("Notice 글수정");
var url = "${pageContext.request.contextPath}/board/service/"+board_srl+"/edit";

	$.ajax({
		
		url:url,
		type : "get",
		dataType : "html",
		contentType : "text/html; charset=UTF-8",
		success : function(d){
			//alert(d);
			$("#boardBody").empty();
			$("#boardBody").html(d);
				
		},
		error : function(e){
			popLayerMsg("AJAX Error 발생"+ e.status+":"+e.statusText);
		}
	});
}

function choosePerson(user_id){
	alert(user_id+"를 채택 하셨습니다.");
}
//리스트 가져오기
function getListComment(nowPage, parent_board_srl, comment_type) {
	nowPage = typeof nowPage !== 'undefined' ? nowPage : 1;

	comment_type = typeof comment_type !== 'undefined' ? comment_type : 1;
	
	parent_board_srl = typeof parent_board_srl !== 'undefined' ? parent_board_srl : "";
	
	if (isEmpty(comment_type)) {
		comment_type = "";
	}
	
	if (isEmpty(parent_board_srl)) {
		parent_board_srl = "";
	}
	
	//service_srl = typeof service_srl !== 'undefined' ? service_srl : 1;

	var url = "${pageContext.request.contextPath}/comment/json/comment_list.json";
	var inHTML = "";

	var inHTMLPaging = "";
	$("#commentList").empty();
	var params = "comment_type="+comment_type+"&parent_board_srl=" + parent_board_srl + "&nowPage=" + nowPage;
	
	//alert(params);
	
	$.ajax({
		url : url,
		dataType : "json",
		type : "get",
		data : params,
		contentType : "text/html; charset=utf-8",
		success : function(data) {
			$.each(data.commentLists, function(index, commentList) { // each로 모든 데이터 가져와서 items 배열에 넣고

				inHTML += "<div class=\"table-responsive\">";
				inHTML += "		<table class=\"table table-hover\" id=\"table-hover\">";
				inHTML += "			<thead>";
				if(comment_type=="R")
					inHTML += "			<tr class=\"success\">";	
				else
					inHTML += "			<tr class=\"info\">";
				
				inHTML += "				<th>아이디</th>";
				if(comment_type=="R")
				inHTML += "				<th colspan=\"2\">채택내용</th>";
				else
					inHTML += "				<th colspan=\"2\">후기내용</th>";
				inHTML += "			</tr>";
				inHTML += "			</thead>";
				
				inHTML += "			<tbody>";
				inHTML += "			<tr>";
				//inHTML += "				<td><div class=\"popup\" onclick=\"popUserMenu2(\""+commentList.user_id+")\">"+ commentList.user_id +"</div></td>";
				inHTML += "				<td>"+commentList.user_id +"</td>";
				inHTML += "				<td>"+ commentList.comments +"</td>";
				inHTML += "				<td>";
				if(comment_type=="R")
				{
					inHTML += "					<button type=\"button\" class=\"btn btn-info\" onclick=\"javascript:choosePerson('"+commentList.user_id+"')\">채택하기</button>";
				}
				inHTML += "				</td>";
				inHTML += "			</tr>";
				inHTML += "			</tbody>";
				inHTML += "		</table>";
				inHTML += "</div>";

			});//each끝
			inHTML += "<div class=\"row text-center\">";
			inHTML += "<ul class=\"pagination\" id=\"commentPagingDiv\">";
			inHTML += "</ul> </div>";
			inHTML += "		</div>";
			inHTML += "		</div>";
			if(comment_type=="R"){
				$("#commentListR").html(inHTML);
			}
			else{
				$("#commentListC").html(inHTML);
			}
			$("#commentPagingDiv").html(data.pagingDiv);
		},
		error : function(e) {
			popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);
		}
	});
}


</script>

<script type="text/javascript">
function toggleWish(board_srl){
	
	var write_user_id = '<c:out value="${view.user_id}"/>';
	var login_user_id = '<c:out value="${loginUserInfo.user_id}"/>';
	var per_id = $("input[name='"+like_srl+"_per_id']").val();
	var formData = {"board_srl":board_srl};
	var selector = "."+like_srl;
	
	var active = $(cla).hasClass("active");
	if(active){
		$.ajax({
			type : "POST",
			url : "delLike",
			cache : false,
			data : formData,
			success : function() {
				$(selector).removeClass("active");
			},
			error : function(){
				alert("위시리스트 실패하였습니다.");
			}
		});
	}else{
		$.ajax({
			type : "POST",
			url : "addLike",
			cache : false,
			data : formData,
			success : function() {
				$(selector).addClass("active");
			},
			error : function(){
				alert("위시리스트 실패하였습니다.");
			}
		});
	}
}
</script>
<!-- Body영역 -->
<div class="row text-left" id="row-body-view">

	<!-- 뷰 머리 -->
	<div class="view-head">
		<p class="p-title">시공사례 대표이미지</p>
		<!-- <img class="img-responsive" src="../images/tile4.jpg"
					style="height: 500px; width: 100%;" /> <br /> -->
		<div class="title">
			<p class="p-title">제목</p>
			<h4>${view.title }</h4>
		</div>
	</div>
	<!-- 뷰 별평가 -->
	<!-- <div class="view-star">
				<img src="../images/star.png" /> <img src="../images/star.png" />
				<img src="../images/star.png" /> <img src="../images/star.png" />
				<img src="../images/star.png" />
				<p>15개의 평가</p>
			</div> -->
	<!-- 뷰 상세내용 -->
	<div class="view-body">
		<div class="contents">
			<p class="p-title">서비스내용</p>
			<div class="textarea">${view.contents }</div>
		</div>
		<div class="need-contents">
			<p class="p-title">필수사항</p>
			<div class="form-inline">
				<p>서비스지역 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp; ${view.location }</p>
				<p>서비스기간 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp; ${view.service_time_start } ~ ${view.service_time_end }</p>
				<p>
					서비스비용 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;
					<fmt:formatNumber value="${view.service_cost }" />
					원
				</p>
				<p>연락가능시간 &nbsp;&nbsp;: &nbsp;&nbsp; ${view.contact_time_start } ~ ${view.contact_time_end }</p>
			</div>
		</div>
		<div class="images">
			<p class="p-title">시공사례 이미지</p>
			<!-- <img class="img-responsive" src="../images/tile1.jpg" /><br /> <img
						class="img-responsive" src="../images/tile2.jpg" /><br /> <img
						class="img-responsive" src="../images/tile3.jpg" /><br /> -->
		</div>

		<div class="extra content">
			<input type="hidden" name="${like.like_srl}_per_id" value="${like.per_id }"> 
			
			<span class="right floated">
			<i class="glyphicon glyphicon-heart like active" onclick="toggleWish(${view.board_srl})"></i>좋아요</span>
		</div>


	</div>

	<!-- 뷰페이지 버튼부분 -->
	<div class="view-btn">

		<c:if test="${loginUserInfo.user_id eq view.user_id || loginUserInfo.is_admin =='Y'}">

			<button type="button" class="btn btn-info" id="btn-modify" name="modifyBtn" onclick="javascript:modifyBoard(${view.board_srl});">수정하기</button>

			<button type="button" class="btn btn-danger" id="btn-delete" onclick="javascript:deleteBoard(${view.board_srl});">삭제하기</button>
		</c:if>

		<button type="button" class="btn btn-success" id="boardListBtn">목록보기</button>
	</div>


	<!-- 요청&댓글부분 -->

	<div class="view-comment-head">
		<div class="container">
			<ul class="nav nav-tabs" id="nav-tabs">
				<li class="active"><a data-toggle="tab" href="#home" onclick="getListComment(1, ${view.board_srl}, 'R');">채택요청</a></li>
				<li><a data-toggle="tab" href="#menu1" onclick="getListComment(1, ${view.board_srl}, 'C');">댓글후기</a></li>
			</ul>
			<div class="tab-content">
				<!-- 요청리스트부분 -->
				<div id="home" class="tab-pane fade in active">
					<div class="write-comment">

						<div id="commentListR">
							<%-- <div class="table-responsive">
										<table class="table table-hover" id="table-hover">
											<thead>
												<tr class="success">
													<th>아이디</th>
													<th colspan="2">채택내용</th>
												</tr>
											</thead>
											<tbody>
											<c:forEach var="reply" items="${reply }">	
												<tr>
													<td>${reply.user_id }</td>
													<td>${reply.contents }</td>
													<td>
														<button type="button" class="btn btn-default"
															id="btn-select">채택하기</button>
													</td>
												</tr>
											</c:forEach>	
											</tbody>
										</table>
									</div> --%>
						</div>
						<!-- <div class="container-fluid" align="center">
									<div class="pagination">
										<ul class="pagination pagination" id="pagination-ul">
											<li><a href="#"><span
													class="glyphicon glyphicon-backward"></span></a></li>
											<li><a href="#"><span
													class="glyphicon glyphicon-triangle-left"></span></a></li>
											<li><a href="#">6</a></li>
											<li><a href="#">7</a></li>
											<li><a href="#">8</a></li>
											<li><a href="#">9</a></li>
											<li><a href="#">10</a></li>
											<li><a href="#"><span
													class="glyphicon glyphicon-triangle-right"></span></a></li>
											<li><a href="#"><span
													class="glyphicon glyphicon-forward"></span></a></li>
										</ul>
									</div>
								</div> -->
						<div class="view-comment-write">
							<form id="requestCommentsForm">
								<input type="hidden" name="parent_board_srl" id="parent_board_srl_R" value="${view.board_srl}" /> <input type="hidden" name="user_id" value="${loginUserInfo.user_id}" /> <input type="hidden" name="comment_type" value="R" />
								<div class="form-inline">


									<textarea class="form-control" placeholder="채택요청을 입력하세요" id="requestText" name="comments"></textarea>
									<button type="button" class="btn btn-info" id="requestSubmit">채택요청</button>
								</div>
							</form>
						</div>
					</div>
				</div>
				<!-- 댓글후기 리스트 -->
				<div id="menu1" class="tab-pane fade">
					<div class="write-comment">
						<div id="commentListC">
							<div class="table-responsive">
								<!-- <table class="table table-hover" id="table-hover">
										<thead>
											<tr class="info">
												<th>아이디</th>
												<th colspan="2">댓글내용</th>
											</tr>
										</thead>
										<tbody>
											
											<tr>
												<td>choose432</td>
												<td>잘 공사해주셨서 감사해요!</td>
												<td>
													<button type="button" class="btn btn-default"
														id="btn-select">댓글삭제</button>
												</td>
											</tr>

										</tbody>
									</table> -->
							</div>
						</div>
						<!-- <div class="container-fluid" align="center">
									<div class="pagination">
										<ul class="pagination pagination" id="pagination-ul">
											<li><a href="#"><span
													class="glyphicon glyphicon-backward"></span></a></li>
											<li><a href="#"><span
													class="glyphicon glyphicon-triangle-left"></span></a></li>
											<li><a href="#">6</a></li>
											<li><a href="#">7</a></li>
											<li><a href="#">8</a></li>
											<li><a href="#">9</a></li>
											<li><a href="#">10</a></li>
											<li><a href="#"><span
													class="glyphicon glyphicon-triangle-right"></span></a></li>
											<li><a href="#"><span
													class="glyphicon glyphicon-forward"></span></a></li>
										</ul>
									</div>
								</div> -->
						<div class="view-comment-write">
							<form id="commentCommentsForm">
								<input type="hidden" name="parent_board_srl" id="parent_board_srl_C" value="${view.board_srl}" /> <input type="hidden" name="user_id" value="${loginUserInfo.user_id}" /> <input type="hidden" name="comment_type" value="C" />
								<div class="form-inline">
									<textarea class="form-control" placeholder="후기를 등록하세요" id="commentText" name="comments"></textarea>
									<button type="button" class="btn btn-success" id="commentSubmit">후기등록</button>
								</div>
								<div class="form-inline">
									<div>서비스평가 점수 5점 만점</div>
									<input type="number" name="service_score" min="0" max="5" step="1" value="5">
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</div>