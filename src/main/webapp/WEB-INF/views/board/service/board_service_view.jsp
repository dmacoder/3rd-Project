<%@page import="com.cafe24.ourplanners.member.dto.LoginDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	if (request.getProtocol().equals("HTTP/1.1"))
		response.setHeader("Cache-Control", "no-cache");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="description" content="">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>|OUR PLANNERS</title>
<jsp:useBean id="today" class="java.util.Date" scope="page" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel='stylesheet' href='http://fonts.googleapis.com/css?family=Open+Sans:300,400,400italic,600,700|Raleway:300,400,500,600'>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commonTop_1.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commonTop_2.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commonBottom.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/view.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/images/icons/favicon.ico">


<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->



<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />"></script>

<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />"></script>

<script type="text/javascript" charset="utf-8">
	sessionStorage.setItem("contextpath", "${pageContext.request.contextPath}");
	
	var isEmpty = function(value){ if( value == "" || value == null || value == undefined || ( value != null && typeof value == "object" && !Object.keys(value).length ) ){ return true }else{ return false } };
</script>


<script type="text/javascript">
$(document).ready(function(){
	
	initSideNav("${category_srl}","${subcategory_srl}");
	
	getTagsList("${category_srl}", "${subcategory_srl}");
	
	if (!isEmpty("${subcategory_srl}"))
	$("#cateTitle").html(setCategoryTitle("${category_srl}","${subcategory_srl}"));
	
	//최초 상세보기 페이지 로딩시 게시판 번호에 따른 페이지 ajax로 가져오기
	viewPage("${board_srl}");
	//해당 글번호에 따른 댓글 가져오기
	//getListComment(1, "${board_srl}");
	
	var board_srl = '<c:out value="${board_srl}"/>';
	
	var srl = ${board_srl};
	
	var board_type = '<c:out value="${board_type}"/>';
	
	if(board_type=="E")
	{
		$('#allplanners-btn').removeClass('btn-info');
		$('#engineer-btn').removeClass('btn-info');
		$('#customer-btn').removeClass('btn-info');
		$('#engineer-btn').addClass('btn-info');	
	}else if(board_type=="C")
	{
		$('#allplanners-btn').removeClass('btn-info');
		$('#engineer-btn').removeClass('btn-info');
		$('#customer-btn').removeClass('btn-info');
		$('#customer-btn').addClass('btn-info');	
	}else{
		$('#allplanners-btn').removeClass('btn-info');
		$('#engineer-btn').removeClass('btn-info');
		$('#customer-btn').removeClass('btn-info');
		$('#allplanners-btn').addClass('btn-info');	
	}
	
	getListComment(1, "${board_srl}", "R");
	
	
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

function choosePerson(user_id){
	popLayerMsg(user_id+"를 채택 하셨습니다.");
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
				inHTML += "				<td>"+ commentList.user_id +"</td>";
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

<script>


$(document).ready(function() {
	
	//                  (nowPage, category_srl, subcategory_srl , board_type ,searchType,keyword) 
	//getServiceSearchList(1, "${category_srl}", "${subcategory_srl}" , "${board_type}" ,"${searchType}","${keyword}");
	
	$("#writeBoardBtn").on("click", function() {
		getWriteFormBoard();
	});
	
	$("#allplanners-btn").on("click", function() {
		$('#allplanners-btn').removeClass('btn-info');
		$('#engineer-btn').removeClass('btn-info');
		$('#customer-btn').removeClass('btn-info');
		$(this).addClass('btn-info');
		getServiceSearchList(1, $('#category_srl').val(), $('#subcategory_srl').val(), "", $('#searchType').val(), $('#keyword').val());
		
	});

	$("#engineer-btn").on("click", function() {
		//getServiceSearchList(1, "${category_srl}", "${subcategory_srl}", "E", "${searchType}", "${keyword}");
		$('#allplanners-btn').removeClass('btn-info');
			$('#engineer-btn').removeClass('btn-info');
			$('#customer-btn').removeClass('btn-info');
			$(this).addClass('btn-info');
		getServiceSearchList(1, $('#category_srl').val(), $('#subcategory_srl').val(), "E", $('#searchType').val(), $('#keyword').val());
	});

	$("#customer-btn").on("click", function() {
		$('#allplanners-btn').removeClass('btn-info');
		$('#engineer-btn').removeClass('btn-info');
		$('#customer-btn').removeClass('btn-info');
		$(this).addClass('btn-info');
		//getServiceSearchList(1, "${category_srl}", "${subcategory_srl}", "C", "${searchType}", "${keyword}");
		getServiceSearchList(1, $('#category_srl').val(), $('#subcategory_srl').val(), "C", $('#searchType').val(), $('#keyword').val());
	});

	$('#searchBoardBtn').click(function() {

		var searchType = $('#select-form-control option:selected').val();

		var keyword = $('#keyword').val();
		
		var category_srl = $('#category_srl').val();
		
		var subcategory_srl = $('#subcategory_srl').val();
		
		var board_type = $('#board_type').val();
		
		if (isEmpty(keyword)) {
			popLayerMsg("검색어를 입력하세요.");
			return;
		} else {	
			
			//getServiceSearchList(1, "${category_srl}", "${subcategory_srl}", "${board_type}", "${searchType}", "${keyword}");
			getServiceSearchList(1, category_srl, subcategory_srl, board_type, searchType, keyword);
			
		}
		
	});

	
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
	
	//검색폼에서 엔터로 검색 
	$('#keyword').keydown(function(event) {
	    // enter has keyCode = 13, change it if you want to use another button
	    if (event.keyCode == 13) {
	    	$('#searchBoardBtn').trigger('click');
	      return false;
	    }
	  });
	
	//글쓰기 폼 가져오기
	function getWriteFormBoard() {
		
		//$("#faqHead").text("FAQ 글쓰기");
		var category_srl = $('#category_srl').val();
		
		var subcategory_srl = $('#subcategory_srl').val();
		
		var board_type = $('#board_type').val();
		
		var params = "board_type=" + board_type + "&category_srl=" + category_srl+"&subcategory_srl="+subcategory_srl;
		
		$.ajax({
			url : "${pageContext.request.contextPath}/board/service/new",
			type : "get",
			dataType : "html",
			contentType : "text/html; charset=UTF-8",
			
			/* data : JSON.stringify({
				
				board_type : board_type,
				category_srl : category_srl,
				subcategory_srl : subcategory_srl
		}), */
		data : params,
		
			success : function(d) {
				//alert(d);
				$("#boardBody").empty();
				$("#boardBody").html(d);
			},
			error : function(e) {
				popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);
			}
		});
	}
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
				//$(this).parent().hide();
			}						
		},
		error:function(e){
			popLayerMsg("AJAX Error 발생"+ e.status+":"+e.statusText);
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

//세자리 콤마
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function servicePaging(nowPage, category_srl, subcategory_srl , board_type,searchType,keyword) {
	var params = "nowPage="+nowPage+"&board_type="+board_type+"&pageSize=6&blockPage=5&keyword="+keyword+"&searchType="+searchType;
	//alert(params);
	getServiceSearchList(nowPage, category_srl, subcategory_srl , board_type,searchType,keyword);
}

function selectCategory(category_srl){
	getServiceSearchList(1, category_srl);
}

function selectSubCategory(category_srl,subcategory_srl){
	getServiceSearchList(1, category_srl, subcategory_srl);
}

function keyExists(key, search) {
    if (!search || (search.constructor !== Array && search.constructor !== Object)) {
        return false;
    }
    for (var i = 0; i < search.length; i++) {
        if (search[i] === key) {
            return true;
        }
    }
    return key in search;
}

function initSideNav(category_srl,subcategory_srl) {

	category_srl = typeof category_srl !== 'undefined' ? category_srl : "";

	if (isEmpty(category_srl)) {

		category_srl = "";
	}

	subcategory_srl = typeof subcategory_srl !== 'undefined' ? subcategory_srl : "";

	if (isEmpty(subcategory_srl)) {

		subcategory_srl = "";
	}
	
	$('#CategoryTitle').empty();
	$('#subCategoryList').empty();

	var url = "${pageContext.request.contextPath}/board/json/subcategory_list.json";
	var params = "category_srl=" + category_srl;

	$.ajax({
		cache : false, // 캐시 사용 없애기
		type : 'get',
		url : url,
		data : params,
		//data : JSON.stringify({ board_type: 'E', pageSize: '3', blockPage: '1'}),
		//contentType: 'application/json; charset=utf-8',
		dataType : 'json',
		//contentType: "application/x-www-form-urlencoded; charset=utf-8",				
		//dataType: "text",	
		success : function(data) {
			//alert(JSON.stringify(data));
			var items = [];
			var inHTML = "";

			var inHTMLCategoryName = "";
			var count=0;
			$.each(data.subCategoryList, function(index, categoryVO) { // each로 모든 데이터 가져와서 items 배열에 넣고
				if (isEmpty(category_srl)) {
					if(!keyExists(categoryVO.category_name, items)){
						count++;
						inHTML += "<li><a href=\"javascript:selectCategory(" + categoryVO.category_srl + ")\"><span>" + count + "</span>" + categoryVO.category_name + "</a></li>";
						items.push(categoryVO.category_name);
						inHTMLCategoryName = categoryVO.category_name;
					}
					
				}else{
					count++;
					if(!isEmpty(subcategory_srl) && categoryVO.subcategory_srl==subcategory_srl)
					inHTML += "<li class=\"active\"><a href=\"javascript:selectSubCategory(" + categoryVO.category_srl + "," + categoryVO.subcategory_srl + ")\"><span>" + count + "</span>" + categoryVO.subcategory_name + "</a></li>";
					else
					inHTML += "<li><a href=\"javascript:selectSubCategory(" + categoryVO.category_srl + "," + categoryVO.subcategory_srl + ")\"><span>" + count + "</span>" + categoryVO.subcategory_name + "</a></li>";
					inHTMLCategoryName = categoryVO.category_name+" 서브 카테고리";
				}
				

			});//each끝

			if (isEmpty(category_srl)) {
				$('#CategoryTitle').html("전체 카테고리");
			} else {
				$('#CategoryTitle').html(inHTMLCategoryName);
			}

			if (jQuery.isEmptyObject(data.subCategoryList)) {
				$('#subCategoryList').html("<li><a href=\"#\">서브 카테고리 없음</a></li>");
			} else {
				$('#subCategoryList').html(inHTML);
			}

		},

		error : function(e) {
			popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);
		}

	});
}

function getTagsList(category_srl,subcategory_srl){
	
	var url = "${pageContext.request.contextPath}/board/json/top_search_list.json";

	category_srl = typeof category_srl !== 'undefined' ? category_srl : "";
	
	subcategory_srl = typeof subcategory_srl !== 'undefined' ? subcategory_srl : "";
	
	if (isEmpty(category_srl)) {
		category_srl = "";
	}
	
	if (isEmpty(subcategory_srl)) {
		subcategory_srl = "";
	}
	
	var params = "category_srl="+category_srl+"&subcategory_srl="+subcategory_srl;
	
	//태그리스트 내용 지우기
	$("#tags").empty();

	//var params="";
	//alert(url);

	$.ajax({
		cache : false, // 캐시 사용 없애기
		type : 'post',
		url : url,
		data : params,
		//contentType: 'application/json; charset=utf-8',
		dataType : 'json',
		//contentType: "application/x-www-form-urlencoded; charset=utf-8",				
		//dataType: "text",	
		success : function(resdata) { //success에 성공했을 때 동작 넣기.

			//data= JSON.parse(resdata)

			var data;

			try {
				data = JSON.parse(JSON.stringify(resdata));
				//var data = JSON.parse( jsonData );								/* JSON 형식의 text 를 객체로 컨버팅 */
			} catch (e) {

				popLayerMsg(resdata + " : JSON 객체 파서 에러");
				popLayerMsg(" 페이지 JSON 객체 파서 에러 errURL : " + document.location + " , sendURL : " + url);

				return;
			}

			//alert(responseData.bbsList[0]);
			//var data = JSON.parse(responseData);

			//$("#bbs_content1").html("");

			//var key = Object.keys(data["bbsList"][0]); // 키 값 가져오기 num, title, content, id, postdate,visitcount, name, commentCnt

			var items = [];
			var tagInHTML = "";
			$.each(resdata.list, function(index, hotKeyWord) { // each로 모든 데이터 가져와서 items 배열에 넣고

				if (index == 10)
					return false; //break; true=>continue

				//배열에 푸쉬후 뿌려줄 영역에 html메소드로 넣기
				//items.push("<a class='title' href='bbs/bbs_detail.jsp?num=" + hotKeyWord.num + "&nowPage=1'>"+hotKeyWord.title+"</a>");
				//<a href='${pageContext.request.contextPath}/board/service?category="+hotKeyWord.category_srl+"&subcategory="+hotKeyWord.subcategory_srl+"' title='"+hotKeyWord.searchword+"'><i class='fa fa-tag'></i> "+hotKeyWord.searchword+"</a>
				tagInHTML += "<span><a href='${pageContext.request.contextPath}/board/service?category_srl=" + hotKeyWord.category_srl + "&subcategory_srl=" + hotKeyWord.subcategory_srl + "' title='10 Topics'><i class='fa fa-tag'></i> " + hotKeyWord.searchword + "</a></span>";

			});//each끝
			//alert(tagInHTML);
			$('#tags').html(tagInHTML);
			//$('#tagsList').html(items.join(''));
		},
		error : function(e) {
			popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);

		}
	});
	
}

function getServiceSearchList(nowPage, category_srl, subcategory_srl , board_type ,searchType,keyword) {
	
	//var params = "nowPage="+nowPage+"&board_type="+board_type+"&pageSize=6&blockPage=5&keyword="+keyword+"&searchType="+searchType;
	//alert(params);
	
	nowPage = typeof nowPage !== 'undefined' ? nowPage : 1;
	
	board_type = typeof board_type !== 'undefined' ? board_type : "";
	
	category_srl = typeof category_srl !== 'undefined' ? category_srl : "";
	subcategory_srl = typeof subcategory_srl !== 'undefined' ? subcategory_srl : "";
	
	searchType = typeof searchType !== 'undefined' ? searchType : "";
	
	keyword = typeof keyword !== 'undefined' ? keyword : "";
	
	if (isEmpty(board_type)) {
		board_type = "";
	}	
	if (isEmpty(category_srl)) {
		category_srl = "";
	}
	if (isEmpty(subcategory_srl)) {
		subcategory_srl = "";
	}
	if (isEmpty(searchType)) {
		searchType = "";
	}
	if (isEmpty(keyword)) {
		keyword = "";
	}
	
	//히든 폼에 페이지 영역 저장
	$('#nowPage').val(nowPage);

	$('#keyword').val(keyword);

	$('#category_srl').val(category_srl);

	$('#subcategory_srl').val(subcategory_srl);

	$('#board_type').val(board_type);
	
	if(board_type=="E")
	{
		$('#allplanners-btn').removeClass('btn-info');
		$('#engineer-btn').removeClass('btn-info');
		$('#customer-btn').removeClass('btn-info');
		$('#engineer-btn').addClass('btn-info');	
	}else if(board_type=="C")
	{
		$('#allplanners-btn').removeClass('btn-info');
		$('#engineer-btn').removeClass('btn-info');
		$('#customer-btn').removeClass('btn-info');
		$('#customer-btn').addClass('btn-info');	
	}else{
		$('#allplanners-btn').removeClass('btn-info');
		$('#engineer-btn').removeClass('btn-info');
		$('#customer-btn').removeClass('btn-info');
		$('#allplanners-btn').addClass('btn-info');	
	}
	
	initSideNav(category_srl, subcategory_srl);
	
	getTagsList(category_srl, subcategory_srl);
	
	if (!isEmpty(category_srl)||!isEmpty(subcategory_srl))
	$("#cateTitle").html(setCategoryTitle(category_srl,subcategory_srl));
		
	var url = "${pageContext.request.contextPath}/board/json/service_list.json";
	var serviceMainImgPath = "${pageContext.request.contextPath}/resources/upload/service/";
	//내용 지우기
	$("#boardBody").empty();
	$("#boardPagingDiv").empty();
	
	var params = "nowPage="+nowPage+"&category_srl="+category_srl+"&subcategory_srl="+subcategory_srl+"&board_type="+board_type+"&pageSize=10&blockPage=10&keyword="+keyword+"&searchType="+searchType;
	
	//alert(params);
	$.ajax({
		cache : false, // 캐시 사용 없애기
		type : 'post',
		url : url,
		data : params,
		//data : JSON.stringify({ board_type: 'E', pageSize: '3', blockPage: '1'}),
		//contentType: 'application/json; charset=utf-8',
		dataType : 'json',
		//contentType: "application/x-www-form-urlencoded; charset=utf-8",				
		//dataType: "text",	
		success : function(data) {
			//alert(JSON.stringify(data));
			var items = [];
			var inHTML = "";
			
		      inHTML += "<table class=\"table table-hover\">";
		         inHTML += "<colgroup>";
		            inHTML += "<col width=\"12%\">";
		            inHTML += "<col width=\"*%\">";
		            inHTML += "<col width=\"12%\">";
		            inHTML += "<col width=\"14%\">";
		            inHTML += "<col width=\"10%\">";
		            inHTML += "<col width=\"10%\">";
		         inHTML += "</colgroup>"
		         inHTML += "<thead>";
		         inHTML += "<tr>";
		            inHTML += "<th>아이디</th>";
		            inHTML += "<th>제목</th>";
		            inHTML += "<th>예상비용</th>";
		            inHTML += "<th>서비스기간</th>";
		            inHTML += "<th>지역</th>";
		            inHTML += "<th>조회수</th>";
		         inHTML += "</tr>";
		         inHTML += "</thead>";
		         inHTML += "<tbody>";
			
			
			$.each(data.searchList, function(index, boardVO) { // each로 모든 데이터 가져와서 items 배열에 넣고

				//if(index==5)
				//return false; //break; true=>continue

				//배열에 푸쉬후 뿌려줄 영역에 html메소드로 넣기

				 inHTML += "<tr>";
	               inHTML += "<td>"+boardVO.user_id+"</td>";
	               inHTML += "<td><a href=\"javascript:viewPage("+boardVO.board_srl+")\">"+boardVO.title+"</a></td>";
	               
	               service_cost = numberWithCommas(boardVO.service_cost);
	               
	               inHTML += "<td>"+service_cost+"</td>";
	               inHTML += "<td>"+boardVO.service_time_start+"<br/> ~ "+boardVO.service_time_end+"</td>";
	               inHTML += "<td>"+boardVO.location+"</td>";
	               inHTML += "<td>"+boardVO.visitcount+"</td>";
	            inHTML += "</tr>";
	            
	            
				
			});//each끝
			
			inHTML += "</tbody>";
		      inHTML += "</table>";
		      
		      inHTML += "<div class=\"row text-center\">";
		      inHTML += "<ul class=\"pagination\" id=\"boardPagingDiv\">";
		      inHTML += "</ul></div>";
		          
			if (jQuery.isEmptyObject(data.searchList)) {
				$('#boardBody').html("<div class=\"row text-center\">해당 하는 검색 결과가 없습니다.</div>");
			} else {
				$('#boardBody').html(inHTML);
			}

			getTagsList(category_srl, subcategory_srl);
			$("#boardPagingDiv").html(data.pagingDiv);
			$(window).scrollTop(0);
			
			//alert(inHTML);
			//$('#hot_engineer_div').html(items);

		},

		error : function(e) {
			popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);
		}

	});
}

//글 읽기
function viewPage(board_srl){
	
	//location.href="${pageContext.request.contextPath}/board/service/"+board_srl;
	 
	$.ajax({
		url : "${pageContext.request.contextPath}/board/service/"+board_srl+"/little",
		dataType : "html",
		type : "get",
		contentType : "text/html; charset:utf-8",
		success : function(d){
			
			$('#boardBody').html(d);
			
		},
		error : function(request, status, error){
			popLayerMsg("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	
}

function setCategoryTitle(category_srl, subcategory_srl) {

	var url = "${pageContext.request.contextPath}/board/json/subcategory_list.json";

	var returnLabel = "";

	subcategory_srl = typeof subcategory_srl !== 'undefined' ? subcategory_srl : "";

	if (isEmpty(subcategory_srl)) {
		subcategory_srl = "";
	}

	var params = "category_srl=" + category_srl + "&subcategory_srl=" + subcategory_srl;

	$.ajax({
		async : false,
		cache : false, // 캐시 사용 없애기
		type : 'get',
		url : url,
		data : params,
		//data : JSON.stringify({ board_type: 'E', pageSize: '3', blockPage: '1'}),
		//contentType: 'application/json; charset=utf-8',
		dataType : 'json',
		//contentType: "application/x-www-form-urlencoded; charset=utf-8",				
		//dataType: "text",	
		success : function(data) {
			//alert(JSON.stringify(data));
			$.each(data.subCategoryList, function(index, categoryVO) { // each로 모든 데이터 가져와서 items 배열에 넣고

				
			
				
				
				if (isEmpty(subcategory_srl)) {
					
					categoryVO.category_name = categoryVO.category_name + " 인기 검색어 목록";
					
					if (categoryVO.category_srl == 1)
						returnLabel += "<h2 class=\"category label label-default text-danger\">" + categoryVO.category_name + "</h2>";
					else if (categoryVO.category_srl == 2)
						returnLabel += "<h2 class=\"category label label-primary text-danger\">" + categoryVO.category_name + "</h2>";
					else if (categoryVO.category_srl == 3)
						returnLabel += "<h2 class=\"category label label-success text-danger\">" + categoryVO.category_name  + "</h2>";
					else if (categoryVO.category_srl == 4)
						returnLabel += "<h2 class=\"category label label-info text-danger\">" + categoryVO.category_name  + "</h2>";
					else if (categoryVO.category_srl == 5)
						returnLabel += "<h2 class=\"category label label-warning text-danger\">" + categoryVO.category_name + "</h2>";
					else
						returnLabel += "<h2 class=\"category label label-danger text-danger\">" + categoryVO.category_name  + "</h2>";

				} else {

					categoryVO.subcategory_name = categoryVO.subcategory_name + " 인기 검색어 목록";
					
					if (categoryVO.category_srl == 1)
						returnLabel += "<h2 class=\"category label label-default text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h2>";
					else if (categoryVO.category_srl == 2)
						returnLabel += "<h2 class=\"category label label-primary text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h2>";
					else if (categoryVO.category_srl == 3)
						returnLabel += "<h2 class=\"category label label-success text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h2>";
					else if (categoryVO.category_srl == 4)
						returnLabel += "<h2 class=\"category label label-info text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h2>";
					else if (categoryVO.category_srl == 5)
						returnLabel += "<h2 class=\"category label label-warning text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h2>";
					else
						returnLabel += "<h2 class=\"category label label-danger text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h2>";
				}
			
				return false;

			});//each끝

			//alert(inHTML);
			//$('#hot_engineer_div').html(items);

		},

		error : function(e) {
			popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);
		}

	});

	return returnLabel;
}

//TOP 인기 검색어
	$(document).ready(function() {

		var url = "${pageContext.request.contextPath}/board/json/top_search_list.json";

		var params = "category=${category_srl}&subcategory=${subcategory_srl}";
		//태그리스트 내용 지우기
		$("#tags").empty();

		//var params="";
		//alert(url);

		$.ajax({
			cache : false, // 캐시 사용 없애기
			type : 'post',
			url : url,
			data : params,
			//contentType: 'application/json; charset=utf-8',
			dataType : 'json',
			//contentType: "application/x-www-form-urlencoded; charset=utf-8",				
			//dataType: "text",	
			success : function(resdata) { //success에 성공했을 때 동작 넣기.

				//data= JSON.parse(resdata)

				var data;

				try {
					data = JSON.parse(JSON.stringify(resdata));
					//var data = JSON.parse( jsonData );								/* JSON 형식의 text 를 객체로 컨버팅 */
				} catch (e) {

					popLayerMsg(resdata + " : JSON 객체 파서 에러");
					popLayerMsg(" 페이지 JSON 객체 파서 에러 errURL : " + document.location + " , sendURL : " + url);

					return;
				}

				//alert(responseData.bbsList[0]);
				//var data = JSON.parse(responseData);

				//$("#bbs_content1").html("");

				//var key = Object.keys(data["bbsList"][0]); // 키 값 가져오기 num, title, content, id, postdate,visitcount, name, commentCnt

				var items = [];
				var tagInHTML = "";
				$.each(resdata.list, function(index, hotKeyWord) { // each로 모든 데이터 가져와서 items 배열에 넣고

					if (index == 10)
						return false; //break; true=>continue

					//배열에 푸쉬후 뿌려줄 영역에 html메소드로 넣기
					//items.push("<a class='title' href='bbs/bbs_detail.jsp?num=" + hotKeyWord.num + "&nowPage=1'>"+hotKeyWord.title+"</a>");
					//<a href='${pageContext.request.contextPath}/board/service?category="+hotKeyWord.category_srl+"&subcategory="+hotKeyWord.subcategory_srl+"' title='"+hotKeyWord.searchword+"'><i class='fa fa-tag'></i> "+hotKeyWord.searchword+"</a>
					tagInHTML += "<span><a href='${pageContext.request.contextPath}/board/service?category=" + hotKeyWord.category_srl + "&subcategory=" + hotKeyWord.subcategory_srl + "' title='10 Topics'><i class='fa fa-tag'></i> " + hotKeyWord.searchword + "</a></span>";

				});//each끝
				//alert(tagInHTML);
				$('#tags').html(tagInHTML);
				//$('#tagsList').html(items.join(''));
			},
			error : function(e) {
				popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);

			}
		});
				
	});
	

	
</script>

</head>

<body>
	<!-- PRELOADER -->
	<img id="preloader" src="${pageContext.request.contextPath}/resources/images/preloader.gif" alt="" />
	<!-- //PRELOADER -->
	<div class="preloader_hide">

		<!-- HEADER -->

		<!-- header section -->
		<%@ include file="../../common/commonTop_1.jsp"%>
		<!--// header section -->
		<!-- header section -->
		<%@ include file="../../common/commonTop_2.jsp"%>
		<!--// header section -->

		<!-- Search List Area -->

		<!-- CONTAINER -->
		<section class="section-3 section-dark mt0 section-list">
			<div class="container">
				<div class="row">
					<div class="col-sm-10 col-sm-offset-1">
						<div class="text-center">
							<div class="mb0">
								<h2 class="title-h2" id="cateTitle">전체 카테고리 인기 검색어 목록</h2>
								<div id="tags" class="tags">
									<a href="#" title="10 Topics"><i class="fa fa-tag"></i> 검색어</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>

		<section class="section-4">
			<div class="container">
				<div class="row">
					<div class="col-sm-7 col-md-9 col-md-push-3 col-sm-push-5 space-left push-off">
						<!-- 상단 버튼부분 -->
						<div class="row" id="table-btn">
							<div class="col-xs-6">
								<button type="button" class="btn btn-default list-btn" id="allplanners-btn">전체 게시판</button>
								<button type="button" class="btn btn-default list-btn" id="engineer-btn">기술자 게시판</button>
								<button type="button" class="btn btn-default list-btn" id="customer-btn">의뢰인 게시판</button>
							</div>
							
								<div class="from-group col-xs-2" id="from-group">
									<select name="searchType" class="form-control" id="select-form-control">
										<option value="t">제목</option>
										<option value="c">내용</option>
										<option value="tc">제목+내용</option>
										<option value="i">작성자(ID)</option>
									</select>
								</div>
								<div class="input-group col-xs-4">
								<input type="hidden" id="nowPage" value="${nowPage}">
								<input type="hidden" id="category_srl" value="${ category_srl}">
								<input type="hidden" id="subcategory_srl" value="${subcategory_srl }">
								<input type="hidden" id="board_type" value="${board_type }">
								
									<input type="text" class="form-control" placeholder="검색어" id="keyword" name="keyword" value="${keyword}"/>
									<div class="input-group-btn">
										<button class="btn btn-default margin-right-15"  id="searchBoardBtn" type="submit">
											<i class="glyphicon glyphicon-search" ></i>
										</button>
										<button type="button" class="btn btn-success write-btn-list" id="writeBoardBtn">글쓰기</button>
									</div>
								</div>
							
						</div>

						<!-- 리스트부분 반복 -->
						<div id="boardBody">
							
							<div class="row" id="row-body-view">
	
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
					<div class="textarea">
						${view.contents }
					</div>
				</div>
				<div class="need-contents">
					<p class="p-title">필수사항</p>
					<div class="form-inline">
						<p>서비스지역 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp; ${view.location }
						</p>
						<p>서비스기간 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;
							${view.service_time_start } ~ ${view.service_time_end }</p>
						<p>서비스비용 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;
							<fmt:formatNumber value="${view.service_cost }"/>원</p>
						<p>연락가능시간 &nbsp;&nbsp;: &nbsp;&nbsp; ${view.contact_time_start } ~ ${view.contact_time_end }</p>
					</div>
				</div>
				<div class="images">
					<p class="p-title">시공사례 이미지</p>
					<!-- <img class="img-responsive" src="../images/tile1.jpg" /><br /> <img
						class="img-responsive" src="../images/tile2.jpg" /><br /> <img
						class="img-responsive" src="../images/tile3.jpg" /><br /> -->
				</div>
			</div>

			<!-- 뷰페이지 버튼부분 -->
			<div class="view-btn">
			
			<c:if test="${loginUserInfo.user_id eq view.user_id || loginUserInfo.is_admin =='Y'}">
				
				<button type="button" class="btn btn-info" id="btn-modify" 
					name="modifyBtn" onclick="javascript:modifyBoard(${view.board_srl});">수정하기</button>
				
				<button type="button" class="btn btn-danger" id="btn-delete"
					
					onclick="javascript:deleteBoard(${view.board_srl});">삭제하기</button>
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
									<input type="hidden" name="parent_board_srl" id="parent_board_srl_R" value="${view.board_srl}" />
									<input type="hidden" name="user_id" value="${loginUserInfo.user_id}" />
									<input type="hidden" name="comment_type" value="R" />
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
									<input type="hidden" name="parent_board_srl" id="parent_board_srl_C" value="${view.board_srl}" />
									<input type="hidden" name="user_id" value="${loginUserInfo.user_id}" />
									<input type="hidden" name="comment_type" value="C" />
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
							
						</div>
					</div>

					<!-- 좌측 사이드 메뉴 -->
					<%@ include file="/WEB-INF/views/common/commonLeft.jsp"%>


				</div>
			</div>
		</section>


		<!-- //CONTAINER -->
		<!-- //HOME -->

		<!-- 모달창 -->
		<%@ include file="../../common/modal_msg.jsp"%>
		<!-- //모달창 끝 -->


		<!-- Footer section(하단부분) -->
		<!-- Bottom영역 -->
		<div class="row">
			<%@ include file="../../common/commonBottom.jsp"%>
		</div>
		<!-- Footer section(하단부분) -->

	</div>
</body>
</html>
