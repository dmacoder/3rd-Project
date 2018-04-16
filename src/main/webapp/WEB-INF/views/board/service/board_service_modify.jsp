<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:useBean id="today" class="java.util.Date" scope="page" />
<%
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	if (request.getProtocol().equals("HTTP/1.1"))
		response.setHeader("Cache-Control", "no-cache");
%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/write.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">
$(document).ready(function(){
	
	var editor_object = [];
	var ctx = sessionStorage.getItem("contextpath");
	
	nhn.husky.EZCreator.createInIFrame({
		oAppRef : editor_object,
		elPlaceHolder : "contents",
		sSkinURI : ctx + "/resources/smarteditor/SmartEditor2Skin.html",
		htParams : {
			// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseToolbar : true,
			// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : true,
			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true,
			fOnBeforeUnload : function() {

			}
		}
	});
	
	//목록으로
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
			
	//글쓰기
	$('#modifyActionBtn').click(function(){
		
		//폼값 검증
		if($("input[type='text'][name='title']").val()==""){
			alert("제목을 입력해주세요");
			$("input[type='text'][name='title']").focus();
			return;
		}
	
		//id가 smarteditor인 textarea에 에디터에서 대입
		editor_object.getById["contents"].exec("UPDATE_CONTENTS_FIELD", []);
		
		// 이부분에 에디터 validation 검증
		var el = document.createElement('html');
		el.innerHTML = editor_object.getById["contents"].elPlaceHolder.value;
		
        var ir1 = $("#contents").val();

        if( ir1 == ""  || ir1 == null || ir1 == '&nbsp;' || ir1 == '<p>&nbsp;</p>')  {
             alert("내용을 입력하세요.");
             editor_object.getById["contents"].exec("FOCUS"); //포커싱
             return;
        }
	/* 	if($("textarea[name='contents']").val()==""){
			alert("내용을 입력해주세요");
			$("textarea[name='contents']").focus();
			return;
		} */
		if($("input[type='text'][name='service_time_start']").val()==""){
			alert("서비스 시작 기간을 입력해주세요");
			$("input[type='text'][name='service_time_start']").focus();
			return;
		}
		if($("input[type='text'][name='service_time_end']").val()==""){
			alert("서비스 종료 기간을 입력해주세요");
			$("input[type='text'][name='service_time_end']").focus();
			return;
		}
		if($("input[type='text'][name='service_cost']").val()==""){
			alert("서비스 종료 기간을 입력해주세요");
			$("input[type='text'][name='service_cost']").focus();
			return;
		}
		if($("input[type='text'][name='contact_time']").val()==""){
			alert("연락 가능 시간을 입력해주세요");
			$("input[type='text'][name='contact_time']").focus();
			return;
		}
		
		//폼값 전송
		var params = $('#modifyFrm').serialize();
		
		//var board_srl = $("input[type='text'][name='board_srl']").val();
		
		
		
		//var contents = $("#contents").val();
		
		var board_srl = '<c:out value="${boardVO.board_srl}"/>';
		
		var title = $("input[type='text'][name='title']").val();
		
		var contents = editor_object.getById["contents"].getIR();
		
		var location = $("input[type='text'][name='location']").val();
		
		var service_time_start = $("input[type='text'][name='service_time_start']").val();
		
		var service_time_end = $("input[type='text'][name='service_time_end']").val();
		
		var service_cost = $("input[type='text'][name='service_cost']").val();
		
		var contact_time_start = $("input[type='text'][name='contact_time_start']").val();
		
		var contact_time_end = $("input[type='text'][name='contact_time_end']").val();
		
		var url = "${pageContext.request.contextPath}/board/service/" + board_srl;
		
		
		//popLayerMsg(jsonStr);
		
		$.ajax({
			cache : false, // 캐시 사용 없애기
			url : url,
			type : "put",
			headers : {
				"Content-Type" : "application/json",
				"X-HTTP-Method-Override" : "PUT"
			},

			dataType : "json",
			//contentType : "text/html; charset=utf-8",
			 data : JSON.stringify({
				 	title : title,
					contents : contents,
					location : location,
					service_time_start : service_time_start,
					service_time_end : service_time_end,
					service_cost : service_cost,
					contact_time_start : contact_time_start,
					contact_time_end : contact_time_end
			}), 
			//data : params,
			success : function(d) {
				if (d.result == "fail") {
					if (d.errorMsg == "isNotLogin") {
						popLayerMsg("글을 수정하시려면 로그인 해주세요.");
						location.href = "${pageContext.request.contextPath}/member/login";
					} else if (d.errorMsg == "hasNotAuth") {
						popLayerMsg("작성하신 글이 본인 글이 아니어서 수정할 수 없습니다.");
						
					}

				} else if (d.result == "success") {

					/* console.log("result: " + d.result); */
					popLayerMsg("글수정을 성공하였습니다.");
					$('#boardListBtn').trigger('click');
					//location.href = "${pageContext.request.contextPath}/customercenter/board";
				}

			},
			error : function(e) {
				popLayerMsg("요청실패:" + e.status + " " + e.statusText);
			}
		});
	
	});
});
</script>

<script type="text/javascript" charset="utf-8">
		sessionStorage.setItem("contextpath", "${pageContext.request.contextPath}");
</script>

	
		<!-- <form id="writeFrm"> -->
		<form id="modifyFrm">
			
			
			<input type="hidden" name="board_srl" value="${boardVO.board_srl }" />
			<input type="hidden" name="board_type" value="${boardVO.board_type }" />
		 	<input type="hidden" name="category_srl" value="${boardVO.category_srl }" />
			<input type="hidden" name="subcategory_srl" value="${boardVO.subcategory_srl }" />
			
			<div class="row" id="row-body-write">
			
			
					<div class="write-body">
						<div class="title">
							<p class="p-title">제목</p>
							<input type="text" class="form-control" placeholder="제목을 입력하세요" name="title" value="${boardVO.title }"/>
						</div>
						<div class="contents">
							<p class="p-title">서비스내용</p>
							
							
							<textarea class="form-control" name="contents" id="contents" 
								rows="10" cols="80" placeholder="서비스 내용을 입력하세요">${boardVO.contents }</textarea>	
						</div>
						<div class="need-contents">
							<p class="p-title">필수사항</p>
							<div class="form-inline">
								<p>
									서비스지역 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;
									<input name="location"
										class="form-control" id="input-area" type="text"
										style="display: inline;" placeholder="지역을 입력하세요" value="${boardVO.location }"/>
								</p>
								<p>
									서비스기간 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;
									<input name="service_time_start"
										class="form-control" id="input-time-s" type="text"
										placeholder="이때부터" value="${boardVO.service_time_start }"/>&nbsp; ~ &nbsp;
									<input name="service_time_end"
										class="form-control" id="input-time-e" type="text" placeholder="여기까지" value="${boardVO.service_time_end }"/>
								</p>
								<p>
									서비스비용 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp;
									<input name="service_cost"
										class="form-control" id="input-cost" type="text"
										placeholder="비용을 입력하세요" value="${boardVO.service_cost }"/>
								</p>
								<p>
									연락가능시간 &nbsp;&nbsp;: &nbsp;&nbsp;
									<input name="contact_time_start"
										class="form-control" id="input-call" type="text" 
										placeholder="연락가능시간을 입력하세요" value="${boardVO.contact_time_start }"/>
										
										~
										
									<input name="contact_time_end"
										class="form-control" id="input-call" type="text" 
										placeholder="연락가능시간을 입력하세요" value="${boardVO.contact_time_end }"/>
								</p>
							</div>
						</div>
						<div class="images">
							<!-- <p class="p-title">
								<img src="" alt="메인 이미지" id="main_image"/>
							</p>
							
							<p class="p-title">
								<img src="" alt="컨텐츠 이미지" id="contents_image"/>
							</p> -->
						</div>
					</div>
					<div class="write-btn">
						<button type="button" class="btn btn-success" id="boardListBtn">목록보기</button>
						<button type="button" class="btn btn-warning" id="modifyActionBtn">수정하기</button>
					</div>
				
			</div>
		</form>
  