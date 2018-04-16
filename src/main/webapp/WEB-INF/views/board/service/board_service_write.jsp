<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<jsp:useBean id="today" class="java.util.Date" scope="page" />

<c:choose>
	<c:when test="${empty sessionScope.loginUserInfo }">
		<!-- 로그인 정보가 없다면 경고메시지를 띄우고 로그인 페이지로 이동한다. -->
		<script>
			alert("로그인 후 작성해주세요.");
			location.href = "${pageContext.request.contextPath}/member/login";
		</script>
	</c:when>
	<c:otherwise>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/write.css" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

		<script type="text/javascript">
			$(document).ready(function() {

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

				$("#boardListBtn").on("click", function() {
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
				$('#writeActionBtn').click(function() {

					//폼값 검증
					if ($("input[type='text'][name='title']").val() == "") {
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

					if (ir1 == "" || ir1 == null || ir1 == '&nbsp;' || ir1 == '<p>&nbsp;</p>') {
						popLayerMsg("내용을 입력하세요.");
						editor_object.getById["contents"].exec("FOCUS"); //포커싱
						return;
					}

					/* var maxLen = 4000;
					
					if (ir1.length > maxLen) {
						alert("4000자 이상 초과된 내용은 삭제 됩니다.");
						editor_object.getById["contents"].exec("SET_IR",[ir1.substr(0, maxLen)]);
						//$("#contents").val(ir1.substr(0, maxLen));
					} */

					/* 	if($("textarea[name='contents']").val()==""){
							alert("내용을 입력해주세요");
							$("textarea[name='contents']").focus();
							return;
						} */
					if ($("input[type='text'][name='service_time_start']").val() == "") {
						popLayerMsg("서비스 시작 기간을 입력해주세요");
						$("input[type='text'][name='service_time_start']").focus();
						return;
					}
					if ($("input[type='text'][name='service_time_end']").val() == "") {
						popLayerMsg("서비스 종료 기간을 입력해주세요");
						$("input[type='text'][name='service_time_end']").focus();
						return;
					}
					if ($("input[type='text'][name='service_cost']").val() == "") {
						popLayerMsg("서비스 종료 기간을 입력해주세요");
						$("input[type='text'][name='service_cost']").focus();
						return;
					}
					if ($("input[type='text'][name='contact_time']").val() == "") {
						popLayerMsg("연락 가능 시간을 입력해주세요");
						$("input[type='text'][name='contact_time']").focus();
						return;
					}

					//폼값 전송
					var params = $('#writeFrm').serialize();

					$.ajax({
						url : "${pageContext.request.contextPath}/board/service",
						dataType : "json",
						type : "post",
						//contentType : "text/html; charset=utf-8",
						data : params,
						success : function(d) {
							if (d.result == "fail") {
								if (d.errorMsg == "isNotLogin") {
									popLayerMsg("글을 작성하시려면 관리자 아이디로 로그인 해주세요.");
									location.href = "${pageContext.request.contextPath}/member/login";
								}

							} else if (d.result == "success") {

								popLayerMsg("글쓰기를 성공하였습니다.");
								$('#boardListBtn').trigger('click');

								//location.href = "${pageContext.request.contextPath}/customercenter/faq";
								//todo 여기 리스트 localstorage나 sessionstorage sessionstorage 이용하는게 좋을것같고 아니면 히든폼으로 넘기자

								//getServiceSearchList(1, "${category_srl}", "${subcategory_srl}" , "${board_type}" ,"${searchType}","${keyword}");
								//글쓰기 성공후 히든 영역폼에 저장된 목록으로 이동
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
		<form id="writeFrm">

			<input type="hidden" name="user_id" value="${loginUserInfo.user_id }" /> <input type="hidden" name="board_type" value="${board_type}" /> <input type="hidden" name="category_srl" value="${category_srl }" /> <input type="hidden" name="subcategory_srl" value="${subcategory_srl }" />

			<div class="row" id="row-body-write">


				<div class="write-body">
					<div class="title">
						<p class="p-title">제목</p>
						<input type="text" class="form-control" placeholder="제목을 입력하세요" name="title" />
					</div>
					<div class="contents">
						<p class="p-title">서비스내용</p>


						<textarea class="form-control" name="contents" id="contents" rows="10" cols="80" placeholder="서비스 내용을 입력하세요"></textarea>
					</div>
					<div class="need-contents">
						<p class="p-title">필수사항</p>
						<div class="form-inline">
							<p>
								서비스지역 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp; <input name="location" class="form-control" id="input-area" type="text" style="display: inline;" placeholder="지역을 입력하세요" />
							</p>
							<p>
								서비스기간 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp; <input name="service_time_start" class="form-control" id="input-time-s" type="text" placeholder="이때부터" />&nbsp; ~ &nbsp; <input name="service_time_end" class="form-control" id="input-time-e" type="text" placeholder="여기까지" />
							</p>
							<p>
								서비스비용 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: &nbsp;&nbsp;&nbsp; <input name="service_cost" class="form-control" id="input-cost" type="text" placeholder="비용을 입력하세요" />
							</p>
							<p>
								연락가능시간 &nbsp;&nbsp;: &nbsp;&nbsp; <input name="contact_time_start" class="form-control" id="input-call" type="text" placeholder="연락가능시간을 입력하세요" /> ~ <input name="contact_time_end" class="form-control" id="input-call" type="text" placeholder="연락가능시간을 입력하세요" />
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
					<button type="button" class="btn btn-info" id="writeActionBtn">작성완료</button>
				</div>

			</div>
		</form>
	</c:otherwise>
</c:choose>
