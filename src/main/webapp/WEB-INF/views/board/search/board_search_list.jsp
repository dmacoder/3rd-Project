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
<title>서비스 게시판 (갤러리형)|OUR PLANNERS</title>
<jsp:useBean id="today" class="java.util.Date" scope="page" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel='stylesheet' href='http://fonts.googleapis.com/css?family=Open+Sans:300,400,400italic,600,700|Raleway:300,400,500,600'>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commonTop_1.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commonTop_2.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commonBottom.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/list2.css?ver=<fmt:formatDate value="${today}" pattern="yyyyMMddHHmmss" />">

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

	var isEmpty = function(value) {
		if (value == "" || value == null || value == undefined || (value != null && typeof value == "object" && !Object.keys(value).length)) {
			return true
		} else {
			return false
		}
	};
</script>

<script>
	$(document).ready(function() {

		//                  (nowPage, category_srl, subcategory_srl , board_type ,searchType,keyword) 		
		//최초 페이지 로딩시 리스트 목록 가져오기	
		//서치 리스트

		initSideNav("${category_srl}","${subcategory_srl}");

		getTagsList("${category_srl}", "${subcategory_srl}");

		if (!isEmpty("${subcategory_srl}"))
			$("#cateTitle").html(setCategoryTitle("${category_srl}", "${subcategory_srl}"));

		getServiceSearchList(1, "${category_srl}", "${subcategory_srl}", "${board_type}", "${searchType}", "${keyword}");

		var board_type = '<c:out value="${board_type}"/>';

		if (board_type == "E") {
			$('#allplanners-btn').removeClass('btn-info');
			$('#engineer-btn').removeClass('btn-info');
			$('#customer-btn').removeClass('btn-info');
			$('#engineer-btn').addClass('btn-info');
		} else if (board_type == "C") {
			$('#allplanners-btn').removeClass('btn-info');
			$('#engineer-btn').removeClass('btn-info');
			$('#customer-btn').removeClass('btn-info');
			$('#customer-btn').addClass('btn-info');
		} else {
			$('#allplanners-btn').removeClass('btn-info');
			$('#engineer-btn').removeClass('btn-info');
			$('#customer-btn').removeClass('btn-info');
			$('#allplanners-btn').addClass('btn-info');
		}

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
			$('#allplanners-btn').removeClass('btn-info');
			$('#engineer-btn').removeClass('btn-info');
			$('#customer-btn').removeClass('btn-info');
			$(this).addClass('btn-info');
			//getServiceSearchList(1, "${category_srl}", "${subcategory_srl}", "E", "${searchType}", "${keyword}");
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

				getServiceSearchList(1, category_srl, subcategory_srl, board_type, searchType, keyword);
				getTagsList(category_srl, subcategory_srl);
			}

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

			if (isEmpty(category_srl)) {
				popLayerMsg("카테고리를 선택하세요.");
				return false;
			}
			if (isEmpty(subcategory_srl)) {
				popLayerMsg("서브 카테고리를 선택하세요.");
				return false;
			}
			if (isEmpty(board_type)) {
				popLayerMsg("게시판 타입(기술자/의뢰인)을 선택하세요.");
				return false;
			}

			var params = "board_type=" + board_type + "&category_srl=" + category_srl + "&subcategory_srl=" + subcategory_srl;

			$.ajax({
				url : "${pageContext.request.contextPath}/board/service/new",
				type : "get",
				dataType : "html",
				contentType : "text/html; charset=UTF-8",
				/* data : JSON.stringify({
					
					board_type : board_type,
					category_srl : category_srl,
					subcategory_srl : subcategory_srl
				}),		 */
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

	//세자리 콤마
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	function selectCategory(category_srl) {
		getServiceSearchList(1, category_srl);
	}

	function selectSubCategory(category_srl, subcategory_srl) {
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
				var count = 0;
				$.each(data.subCategoryList, function(index, categoryVO) { // each로 모든 데이터 가져와서 items 배열에 넣고
					if (isEmpty(category_srl)) {
						if (!keyExists(categoryVO.category_name, items)) {
							count++;
							inHTML += "<li><a href=\"javascript:selectCategory(" + categoryVO.category_srl + ")\"><span>" + count + "</span>" + categoryVO.category_name + "</a></li>";
							items.push(categoryVO.category_name);
							inHTMLCategoryName = categoryVO.category_name;
						}

					} else {
						count++;
						if(!isEmpty(subcategory_srl) && categoryVO.subcategory_srl==subcategory_srl)
						inHTML += "<li class=\"active\"><a href=\"javascript:selectSubCategory(" + categoryVO.category_srl + "," + categoryVO.subcategory_srl + ")\"><span>" + count + "</span>" + categoryVO.subcategory_name + "</a></li>";
						else
						inHTML += "<li><a href=\"javascript:selectSubCategory(" + categoryVO.category_srl + "," + categoryVO.subcategory_srl + ")\"><span>" + count + "</span>" + categoryVO.subcategory_name + "</a></li>";
						inHTMLCategoryName = categoryVO.category_name + " 서브 카테고리";
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

	//세자리 콤마
	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

	function servicePaging(nowPage, category_srl, subcategory_srl, board_type, searchType, keyword) {
		//var params = "board_type="+board_type+"&pageSize=6&blockPage=5&keyword="+keyword+"&searchType="+searchType;
		//alert(params);
		getServiceSearchList(nowPage, category_srl, subcategory_srl, board_type, searchType, keyword);
	}

	function getTagsList(category_srl, subcategory_srl) {

		var url = "${pageContext.request.contextPath}/board/json/top_search_list.json";

		category_srl = typeof category_srl !== 'undefined' ? category_srl : "";

		subcategory_srl = typeof subcategory_srl !== 'undefined' ? subcategory_srl : "";

		if (isEmpty(category_srl)) {
			category_srl = "";
		}

		if (isEmpty(subcategory_srl)) {
			subcategory_srl = "";
		}

		var params = "category_srl=" + category_srl + "&subcategory_srl=" + subcategory_srl;

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

	function getServiceSearchList(nowPage, category_srl, subcategory_srl, board_type, searchType, keyword) {

		//getServiceSearchList(1, "${category_srl}", "${subcategory_srl}" , "${board_type}" ,"${searchType}","${keyword}");

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

		if (board_type == "E") {
			$('#allplanners-btn').removeClass('btn-info');
			$('#engineer-btn').removeClass('btn-info');
			$('#customer-btn').removeClass('btn-info');
			$('#engineer-btn').addClass('btn-info');
		} else if (board_type == "C") {
			$('#allplanners-btn').removeClass('btn-info');
			$('#engineer-btn').removeClass('btn-info');
			$('#customer-btn').removeClass('btn-info');
			$('#customer-btn').addClass('btn-info');
		} else {
			$('#allplanners-btn').removeClass('btn-info');
			$('#engineer-btn').removeClass('btn-info');
			$('#customer-btn').removeClass('btn-info');
			$('#allplanners-btn').addClass('btn-info');
		}

		initSideNav(category_srl,subcategory_srl);

		getTagsList(category_srl, subcategory_srl);

		if (!isEmpty(category_srl) || !isEmpty(subcategory_srl))
			$("#cateTitle").html(setCategoryTitle(category_srl, subcategory_srl));

		var url = "${pageContext.request.contextPath}/board/json/service_list.json";
		var serviceMainImgPath = "${pageContext.request.contextPath}/resources/upload/service/";
		//내용 지우기
		$("#boardBody").empty();
		$("#search_list_paging_div").empty();

		var params = "nowPage=" + nowPage + "&category_srl=" + category_srl + "&subcategory_srl=" + subcategory_srl + "&board_type=" + board_type + "&pageSize=6&blockPage=5&keyword=" + keyword + "&searchType=" + searchType;
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
				$.each(data.searchList, function(index, boardVO) { // each로 모든 데이터 가져와서 items 배열에 넣고

					//if(index==5)
					//return false; //break; true=>continue

					//배열에 푸쉬후 뿌려줄 영역에 html메소드로 넣기

					if (index == 0) {
						inHTML += "<div class=\"item active\">";
					} else {
						inHTML += "<div class=\"item\">";
					}
					inHTML += "<div class=\"col-md-4\">";
					inHTML += "<div class=\"card card-blog\">";
					inHTML += "<div class=\"card-image\">";

					if (boardVO.main_image == null) {
						inHTML += "<a href=\"#pablo\"> <img class=\"img img-raised\" src=\"${pageContext.request.contextPath}/resources/images/noimage.gif\">";
					} else {
						inHTML += "<a href=\"#pablo\"> <img class=\"img img-raised\" src=\""+serviceMainImgPath+boardVO.main_image+"\">";
					}

					inHTML += "</a>";
					inHTML += "<div class=\"colored-shadow\" style=\"background-image: url('" + serviceMainImgPath + boardVO.main_image + "'); opacity: 1;\"></div>";
					inHTML += "<div class=\"ripple-container\"></div>";
					inHTML += "</div>";
					inHTML += "<div class=\"card-content\">";
					//inHTML += "<h6 class=\"category text-info\">"+boardVO.category_srl+"-"+ boardVO.subcategory_srl + "</h6>";
					inHTML += getLabelName(boardVO.category_srl, boardVO.subcategory_srl);
					inHTML += "<h4 class=\"card-title\">";
					inHTML += "<a href=\"${pageContext.request.contextPath}/board/service/"+boardVO.board_srl+"\">" + boardVO.title + "</a>";
					inHTML += "</h4>";
					inHTML += "<p class=\"card-description text-left\">";
					inHTML += "작성자 : " + boardVO.user_id + "<br/>";
					inHTML += "서비스 지역 : " + boardVO.location + "<br/>";
					inHTML += "서비스 비용 : " + numberWithCommas(boardVO.service_cost) + "<br/>";
					inHTML += "서비스 기간 : " + boardVO.service_time_start + " ~ " + boardVO.service_time_end + "<br/>";

					//inHTML += "<a href=\"${pageContext.request.contextPath}/board/service/"+boardVO.board_srl+"\"> 자세히 보기 </a>";
					inHTML += "<a href=\"javascript:viewPage(" + boardVO.board_srl + ")\"> 자세히 보기 </a>";
					inHTML += "</p>";
					inHTML += "</div>";
					inHTML += "</div>";
					inHTML += "</div>";
					inHTML += "</div>";

					//inHTML+="<span><a href='./board/engineer/"+boardVO.board_srl+"?category="+hotKeyWord.category_srl+"&subcategory="+hotKeyWord.subcategory_srl+"'>"+hotKeyWord.searchword+"</a></span>");						

				});//each끝
				if (jQuery.isEmptyObject(data.searchList)) {
					$('#boardBody').html("<div class=\"row\">해당 하는 검색 결과가 없습니다.</div>");
				} else {
					$('#boardBody').html(inHTML);
				}

				getTagsList(category_srl, subcategory_srl);
				$("#search_list_paging_div").html(data.pagingDiv);

				$(window).scrollTop(0);

				//alert(inHTML);
				//$('#hot_engineer_div').html(items);

			},

			error : function(e) {
				popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);
			}

		});
	}

	function getLabelName(category_srl, subcategory_srl) {

		var url = "${pageContext.request.contextPath}/board/json/subcategory_list.json";

		var returnLabel = "";
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

					categoryVO.subcategory_name = categoryVO.subcategory_name + " 인기 검색어 목록";
					if (categoryVO.category_srl == 1)
						returnLabel += "<h6 class=\"category label label-default text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h6>";
					else if (categoryVO.category_srl == 2)
						returnLabel += "<h6 class=\"category label label-primary text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h6>";
					else if (categoryVO.category_srl == 3)
						returnLabel += "<h6 class=\"category label label-success text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h6>";
					else if (categoryVO.category_srl == 4)
						returnLabel += "<h6 class=\"category label label-info text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h6>";
					else if (categoryVO.category_srl == 5)
						returnLabel += "<h6 class=\"category label label-warning text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h6>";
					else
						returnLabel += "<h6 class=\"category label label-danger text-danger\">" + categoryVO.category_name + "-" + categoryVO.subcategory_name + "</h6>";

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

	function viewPage(board_srl) {

		//location.href="${pageContext.request.contextPath}/board/service/"+board_srl;

		$.ajax({
			url : "${pageContext.request.contextPath}/board/service/" + board_srl + "/little",
			dataType : "html",
			type : "get",
			contentType : "text/html; charset:utf-8",
			success : function(d) {

				$('#boardBody').html(d);

			},
			error : function(request, status, error) {
				popLayerMsg("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
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
							returnLabel += "<h2 class=\"category label label-success text-danger\">" + categoryVO.category_name + "</h2>";
						else if (categoryVO.category_srl == 4)
							returnLabel += "<h2 class=\"category label label-info text-danger\">" + categoryVO.category_name + "</h2>";
						else if (categoryVO.category_srl == 5)
							returnLabel += "<h2 class=\"category label label-warning text-danger\">" + categoryVO.category_name + "</h2>";
						else
							returnLabel += "<h2 class=\"category label label-danger text-danger\">" + categoryVO.category_name + "</h2>";

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
								<input type="hidden" id="nowPage" value="${nowPage}"> <input type="hidden" id="category_srl" value="${ category_srl}"> <input type="hidden" id="subcategory_srl" value="${subcategory_srl }"> <input type="hidden" id="board_type" value="${board_type }"> <input type="text" class="form-control" placeholder="검색어" id="keyword" name="keyword" value="${keyword}" />
								<div class="input-group-btn">
									<button class="btn btn-default margin-right-15" id="searchBoardBtn">
										<i class="glyphicon glyphicon-search"></i>
									</button>
									<button type="button" class="btn btn-success write-btn-list" id="writeBoardBtn">글쓰기</button>
								</div>
							</div>

						</div>
						<div id="portfolio-isotope">
							<div class="portfolio-container">
								<div id="boardBody" class="row mt10">
									<div class="col-sm-6 col-md-3">
										<div class="blog-item">
											<div class="blog-image">
												<img src="${pageContext.request.contextPath}/resources/upload/service/1/images/mainimage.jpg" alt="blog post">
											</div>
											<div class="blog-caption">
												<h3 class="post-title">About Magento</h3>
												<div class="sub-post-title">
													<span>12 June, 2018</span> <span><i class="fa fa-user"></i> <a href="#"> by John Doe</a></span>
												</div>
												<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Veritatis, ipsum, optio.</p>
												<a href="blog_single_left.html" class="read-more">Read more</a>
											</div>
										</div>
									</div>

								</div>
							</div>
						</div>

						<div class="text-center">
							<ul class="pagination" id="search_list_paging_div">
								<li class="disabled"><a href="#"><i class="fa fa-chevron-left"></i></a></li>
								<li class="active"><a href="#">1</a></li>
								<li><a href="#">2</a></li>
								<li><a href="#">3</a></li>
								<li><a href="#">4</a></li>
								<li><a href="#">5</a></li>
								<li><a href="#"><i class="fa fa-chevron-right"></i></a></li>
							</ul>
						</div>
					</div>

					<%@ include file="/WEB-INF/views/common/commonLeftSearch.jsp"%>


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
