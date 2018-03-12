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
<!--[if lt IE 7]>      <html class="no-js sidebar-large lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js sidebar-large lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js sidebar-large lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js sidebar-large"> <!--<![endif]-->

<head>
    <!-- BEGIN META SECTION -->
    <meta charset="utf-8">
    <title>서비스 게시판 관리|OUR PLANNERS</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta content="" name="description" />
    <meta content="themes-lab" name="author" />
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/favicon.png">
    <!-- END META SECTION -->
    <!-- BEGIN MANDATORY STYLE -->
    <link href="${pageContext.request.contextPath}/resources/pixit/admin/assets/css/icons/icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/pixit/admin/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/pixit/admin/assets/css/plugins.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/pixit/admin/assets/css/style.min.css" rel="stylesheet">
    <link href="#" rel="stylesheet" id="theme-color">
    <!-- END  MANDATORY STYLE -->
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/modernizr/modernizr-2.6.2-respond-1.1.0.min.js"></script>
    
    <script>
	$(document).ready(function() {
		getBoardListByAdmin(1);
	});

	function boardAdminPaging(nowPage, is_admin, board_type) {
		getBoardListByAdmin(nowPage, is_admin, board_type);
	}
	
	//리스트 가져오기
	function getBoardListByAdmin(nowPage, is_admin, board_type) {
		nowPage = typeof nowPage !== 'undefined' ? nowPage : 1;

		is_admin = typeof is_admin !== 'undefined' ? is_admin : "";

		board_type = typeof board_type !== 'undefined' ? board_type : "";

		var url = "${pageContext.request.contextPath}/admin/json/member_list.json";
		var inHTML = "";
		
		var inHTMLPaging = "";
		$("#memberTBody").empty();
		var params = "nowPage=" + nowPage + "&is_admin=" + is_admin + "&member_type=" + member_type;
		//alert(url + params);
		$.ajax({
			url : url,
			dataType : "json",
			type : "get",
			data : params,
			contentType : "text/html; charset=utf-8",
			success : function(data) {
				$.each(data.boardLists, function(index, boardObj) { // each로 모든 데이터 가져와서 items 배열에 넣고
					//<span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> jquery</span>
					inHTML += "<tr>";
					inHTML += "<td class=\"\">";
					inHTML += "	<input type=\"checkbox\" class=\"memberIds\" id=\"memberIds\" name=\"memberIds\" value=\""+boardObj.user_id+"\" />";
					inHTML += "</td>";
					inHTML += "<td class=\"\">";
					inHTML += "" + boardObj.user_id + "";
					inHTML += "</td>";
					inHTML += "<td class=\"\">";
					inHTML += "" + boardObj.title + "";
					inHTML += "</td>";
					inHTML += "<td class=\"\">";
					inHTML += "" + boardObj.email_address + "";
					inHTML += "</td>";
					inHTML += "<td class=\"\">";
					inHTML += "" + boardObj.regdate + "";
					inHTML += "</td>";
					inHTML += "<td class=\"\">";

					if (memberObj.is_admin == 'Y')
						inHTML += "관리자";
					else {
						if (memberObj.member_type == 'P')
							inHTML += "개인";
						else if (memberObj.member_type == 'C')
							inHTML += "기업";
					}

					inHTML += "</td>";
					inHTML += "<td class=\"\">";

					inHTML += "<a href=\"${pageContext.request.contextPath}/member/myinfo?action=modifyAdmin&modify_id=" + memberObj.user_id + "\"target=\"_blank\">조회/수정</a>";
					inHTML += "</td>";
					inHTML += "</tr>";

				});//each끝

				inHTML += "<div class=\"row text-center\">";
				inHTML += "<ul class=\"pagination\" id=\"memberPagingDiv\">";
				inHTML += "</ul> </div>";
				inHTML += "		</div>";
				inHTML += "		</div>";

				$("#memberTBody").html(inHTML);

				$("#memberPagingDiv").html(data.pagingDiv);
			},
			error : function(e) {
				popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);
			}
		});
	}

	$(document).ready(function() {

		$('#toggle_check_all').click(function() {

			var isChecked = $(this).prop("checked");

			$(".memberIds").prop("checked", isChecked);

		})

		$("#checkedMemberDeleteBtn").click(function() {
			var isChecked = false;

			$(".memberIds").each(function(index, data) {
				if (data.checked) {
					isChecked = data.checked;
				}
			});

			if (!isChecked) {
				//체크
				popLayerMsg("삭제할 회원을 선택하세요.");
				return;
			}

			/* 삭제는 중요하니 한번 더 확인 */

			var checkArray = new Array();
			var inValidDeleteId = false;
			$("input[name='memberIds']:checked").each(function(i) {
				if ($(this).val() == "${loginUserInfo.user_id}") {
					popLayerMsg("현재 로그인 된 관리자 아이디는 삭제할 수 없습니다.<br/>다른 관리자 아이디로 로그인하여 삭제 하시거나 회원탈퇴를 이용하세요.");
					inValidDeleteId = true;
					return false;
					
				}
				checkArray.push($(this).val());
			});
			
			if(inValidDeleteId)
			{
				return;
			}
			
			var params = $('#adminMemberListForm').serialize();
			//var params = {"checkArray": checkboxValues };
			//alert(params);
			//alert(checkArray);
			if (confirm("정말 삭제하시겠습니까?")) {
				var url = "${pageContext.request.contextPath}/admin/members";
				//alert(url);
				$.ajax({
					url : url,
					type : 'delete',
					headers : {
						"Content-Type" : "application/json",
						"X-HTTP-Method-Override" : "DELETE"
					},
					//data : {memberIds : checkArray},
					data : JSON.stringify(checkArray),
					dataType : "json",
					contentType : "text/html; charset:utf-8",
					success : function(d) {
						if (d.result == "fail") {
							popLayerMsg("해당 회원을 삭제하는데 실패하였습니다.");
						} else if (d.result == "success") {
							popLayerMsg("해당 회원이 삭제 되었습니다.");
							getMemberListByAdmin(1);
							//$("#faqDiv_" + faq_srl).hide(1000);
							//$(this).parent().hide();
						}
					},
					error : function(e) {
						popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);
					}
				});

				//array초기화
				checkArray = new Array();

			}
		});

	});

	//수정폼 가져오기
	function modifyFAQ(faq_srl) {
		$("#faqHead").text("FAQ 글수정");
		var url = "${pageContext.request.contextPath}/customercenter/faq/" + faq_srl + "/edit";

		$.ajax({

			url : url,
			type : "get",
			dataType : "html",
			contentType : "text/html; charset=UTF-8",
			success : function(d) {
				//alert(d);
				$("#faqBody").empty();
				$("#faqBody").html(d);

			},
			error : function(e) {
				popLayerMsg("AJAX Error 발생" + e.status + ":" + e.statusText);
			}
		});
	}
	</script>
    
</head>

<body data-page="posts" class="posts">
   	<!-- BEGIN TOP MENU -->
		<%@include file="common/common_top.jsp" %>
	<!-- END TOP MENU -->
	<!-- BEGIN WRAPPER -->
	<div id="wrapper">
	
	<!--  left side bar -->
	<%@include file ="common/common_left.jsp" %>
        <!-- BEGIN MAIN CONTENT -->
        <div id="main-content">
            <div class="top-page clearfix">
                <div class="page-title pull-left">
                    <h3 class="pull-left"><strong>Manage Articles</strong></h3>
                </div>
                 <div class="pull-right">
                    <a href="post_edit.html" class="btn btn-primary m-t-10"><i class="fa fa-plus p-r-10"></i> Add a Post</a>
                </div>
            </div>
            <div class="top-menu">
                <a href="#"><strong>All</strong></a><span class="label label-default m-l-10">112</span> <span class="c-gray p-l-10 p-r-5">|</span>
                <a href="#">Draft</a><span class="label label-default m-l-10">18</span> <span class="c-gray p-l-10 p-r-5">|</span>
                <a href="#">Deleted</a><span class="label label-default m-l-10">42</span> <span class="c-gray p-l-10 p-r-5">|</span>
                <a href="#">Scheduled</a><span class="label label-default m-l-10">4</span>
            </div>
            <div class="row">
                <div class="col-md-12 col-sm-12 col-xs-12 table-responsive">
                    <div class="filter-checkbox">
                        <select>
                            <option value="">Bulk Actions</option>
                            <option value="delete">Deleted</option>
                            <option value="publish">Published</option>
                            <option value="draft">Draft</option>
                        </select>
                        <a href="#" class="btn btn-default">Apply</a>
                    </div>
                    <table id="posts-table" class="table table-tools table-striped">
                        <thead>
                            <tr>
                                <th style="min-width:50px">
                                    <input type="checkbox" class="check_all"/>
                                </th>
                                <th>Title</th>
                                <th>Author</th>
                                <th>Categories</th>
                                <th>Tags</th>
                                <th>Creation</th>
                                <th>Comments</th>
                                <th class="text-center">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Geolocation API</a></td>
                                <td><a href="profil_edit.html">Fred Aster</a></td>
                                <td><a href="#">Javascript</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> map</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> jquery</span>
                                </td>
                                <td>06/10/2014</td>
                                <td>5</td>
                                <td class="text-center">
                                    <span class="label label-success w-300">Online</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Authentification</a></td>
                                <td><a href="profil_edit.html">Miles Bines</a></td>
                                <td><a href="#">PHP</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> session</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> cookie</span>
                                </td>
                                <td>06/08/2014</td>
                                <td>2</td>
                                <td class="text-center">
                                    <span class="label label-success w-300">Online</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Upload Files</a></td>
                                <td><a href="profil_edit.html">Bobby Brown</a></td>
                                <td><a href="#">PHP</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> upload</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> php</span>
                                </td>
                                <td>06/07/2014</td>
                                <td>5</td>
                                <td class="text-center">
                                    <span class="label label-success w-300">Online</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Loop functions</a></td>
                                <td><a href="profil_edit.html">Martin Vones</a></td>
                                <td><a href="#">Jquery</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> jquery</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> function</span>
                                </td>
                                <td>03/05/2014</td>
                                <td>6</td>
                                <td class="text-center">
                                    <span class="label label-success w-300">Online</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Sending Email</a></td>
                                <td><a href="profil_edit.html">John Milo</a></td>
                                <td><a href="#">HTML</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> html</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> email</span>
                                </td>
                                <td>06/03/2014</td>
                                <td>4</td>
                                <td class="text-center">
                                    <span class="label label-success w-300">Online</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">User Profil</a></td>
                                <td><a href="profil_edit.html">Alex Wilson</a></td>
                                <td><a href="#">HTML</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> profil</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> css</span>
                                </td>
                                <td>03/02/2014</td>
                                <td>6</td>
                                <td class="text-center">
                                    <span class="label label-dark w-300">Draft</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Ajax PHP</a></td>
                                <td><a href="profil_edit.html">Steve Nils</a></td>
                                <td><a href="#">PHP</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> ajax</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> php</span>
                                </td>
                                <td>06/10/2014</td>
                                <td>5</td>
                                <td class="text-center">
                                    <span class="label label-success w-300">Online</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">PayPal API</a></td>
                                <td><a href="profil_edit.html">Miles Bines</a></td>
                                <td><a href="#">PHP</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> session</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> cookie</span>
                                </td>
                                <td>03/10/2014</td>
                                <td>2</td>
                                <td class="text-center">
                                    <span class="label label-dark w-300">Draft</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Image Croping</a></td>
                                <td><a href="profil_edit.html">Martin Crew</a></td>
                                <td><a href="#">PHP</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> image</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> resize</span>
                                </td>
                                <td>05/09/2014</td>
                                <td>8</td>
                                <td class="text-center">
                                    <span class="label label-success w-300">Online</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">MySQL Connection</a></td>
                                <td><a href="profil_edit.html">Alexa Johnson</a></td>
                                <td><a href="#">SQL</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> sql</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> connect</span>
                                </td>
                                <td>02/09/2014</td>
                                <td>2</td>
                                <td class="text-center">
                                    <span class="label label-dark w-300">Draft</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Watermark Image</a></td>
                                <td><a href="profil_edit.html">Ben Bills</a></td>
                                <td><a href="#">PHP</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> image</span>
                                </td>
                                <td>01/08/2014</td>
                                <td>5</td>
                                <td class="text-center">
                                    <span class="label label-success w-300">Online</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">CSS3 Animation</a></td>
                                <td><a href="profil_edit.html">Miles Bines</a></td>
                                <td><a href="#">PHP</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> css</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> animation</span>
                                </td>
                                <td>03/10/2014</td>
                                <td>2</td>
                                <td class="text-center">
                                    <span class="label label-danger w-300">Deleted</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Margin &amp; Padding</a></td>
                                <td><a href="profil_edit.html">Henry Steward</a></td>
                                <td><a href="#">CSS</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> css</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> margin</span>
                                </td>
                                <td>06/009/2014</td>
                                <td>5</td>
                                <td class="text-center">
                                    <span class="label label-success w-300">Online</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Header &amp; Footer</a></td>
                                <td><a href="profil_edit.html">Miles Bines</a></td>
                                <td><a href="#">HTML</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> html</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> header</span>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> footer</span>
                                </td>
                                <td>01/09/2014</td>
                                <td>2</td>
                                <td class="text-center">
                                    <span class="label label-danger w-300">Deleted</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Security</a></td>
                                <td><a href="profil_edit.html">Fred Aster</a></td>
                                <td><a href="#">PHP</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> security</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> php</span>
                                </td>
                                <td>06/09/2014</td>
                                <td>5</td>
                                <td class="text-center">
                                    <span class="label label-success w-300">Online</span>
                                </td>
                            </tr>
                            <tr>
                                <td><input type="checkbox"/></td>
                                <td><a href="post_edit.html">Shopping Cart</a></td>
                                <td><a href="profil_edit.html">Miles Bines</a></td>
                                <td><a href="#">PHP</a></td>
                                <td>
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> cart</span> 
                                    <span class="label label-default"><i class="fa fa-tag f-10 p-r-5 c-gray-light"></i> shoppping</span>
                                </td>
                                <td>03/09/2014</td>
                                <td>2</td>
                                <td class="text-center">
                                    <span class="label label-dark w-300">Draft</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
              
            </div>
        </div>
        <!-- END MAIN CONTENT -->
    </div>
    <!-- END WRAPPER -->
    <!-- BEGIN CHAT MENU -->
    <nav id="menu-right">
        <ul>
            <li class="mm-label label-big">ONLINE</li>
            <li class="img no-arrow have-message">
                <span class="inside-chat">
                    <i class="online"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar3.png" alt="avatar 3"/>
                    <span class="chat-name">Alexa Johnson</span>
                    <span class="pull-right badge badge-danger hide">3</span>
                    <span>Los Angeles</span>
                </span>
                <ul class="chat-messages">
                    <li class="img">
                        <span>
                            <span class="chat-detail">
                                <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar3.png" alt="avatar 3"/>
                                <span class="chat-bubble"><span class="bubble-inner">Hi you!</span></span>
                            </span>
                        </span>
                    </li>
                    <li class="img">
                        <span>
                            <span class="chat-detail">
                                <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar3.png" alt="avatar 3"/>
                                <span class="chat-bubble"><span class="bubble-inner">You there?</span></span>
                            </span>
                        </span>
                    </li>
                    <li class="img">
                        <span>
                            <span class="chat-detail">
                                <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar3.png" alt="avatar 3"/>
                                <span class="chat-bubble">
                                    <span class="bubble-inner">Let me know when you come back</span>
                                </span>
                            </span>
                        </span>
                    </li>
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="img no-arrow">
                <span class="inside-chat">
                    <i class="online"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar2.png" alt="avatar 2"/>
                    <span class="chat-name">Bobby Brown</span>
                    <span>New York</span>
                </span>
                <ul class="chat-messages">
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="img no-arrow">
                <span class="inside-chat">
                    <i class="busy"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar13.png" alt="avatar 13"/>
                    <span class="chat-name">Fred Smith</span>
                    <span>Atlanta</span>
                </span>
                <ul class="chat-messages">
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="img no-arrow">
                <span class="inside-chat">
                    <i class="away"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar4.png" alt="avatar 4"/>
                    <span class="chat-name">James Miller</span>
                    <span>Seattle</span>
                </span>
                <ul class="chat-messages">
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="img no-arrow">
                <span class="inside-chat">
                    <i class="online"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar5.png" alt="avatar 5"/>
                    <span class="chat-name">Jefferson Jackson</span>
                    <span>Los Angeles</span>
                </span>
                <ul class="chat-messages">
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="mm-label label-big m-t-30">OFFLINE</li>

            <li class="img no-arrow">
                <span class="inside-chat">
                    <i class="offline"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar6.png" alt="avatar 6"/>
                    <span class="chat-name">Jordan</span>
                    <span>Savannah</span>
                </span>
                <ul class="chat-messages">
                   <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="img no-arrow">
                <span class="inside-chat">
                    <i class="offline"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar7.png" alt="avatar 7"/>
                    <span class="chat-name">Kim Addams</span>
                    <span>Birmingham</span>
                </span>
                <ul class="chat-messages">
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="img no-arrow">
                <span class="inside-chat">
                    <i class="offline"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar8.png" alt="avatar 8"/>
                    <span class="chat-name">Meagan Miller</span>
                    <span>San Francisco</span>
                </span>
                <ul class="chat-messages">
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="img no-arrow">
                <span class="inside-chat">
                        <i class="offline"></i>
                        <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar9.png" alt="avatar 9"/>
                        <span class="chat-name">Melissa Johnson</span>
                        <span>Austin</span>
                    </span>
                <ul class="chat-messages">
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="img no-arrow">
                <span class="inside-chat">
                    <i class="offline"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar12.png" alt="avatar 12"/>
                    <span class="chat-name">Nicole Smith</span>
                    <span>San Diego</span>
                </span>
                <ul class="chat-messages">
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="img no-arrow">
                <span class="inside-chat">
                    <i class="offline"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar11.png" alt="avatar 11"/>
                    <span class="chat-name">Samantha Harris</span>
                    <span>Salt Lake City</span>
                </span>
                <ul class="chat-messages">
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
            <li class="img no-arrow">
                <span class="inside-chat">
                    <i class="offline"></i>
                    <img src="${pageContext.request.contextPath}/resources/pixit/admin/assets/img/avatars/avatar10.png" alt="avatar 10"/>
                    <span class="chat-name">Scott Thomson</span>
                    <span>Los Angeles</span>
                </span>
                <ul class="chat-messages">
                    <li>
                        <span class="chat-input">
                            <input type="text" class="form-control send-message" placeholder="Type your message" />
                        </span>
                    </li>
                </ul>
            </li>
        </ul>
    </nav>
    <!-- END CHAT MENU -->
    <!-- BEGIN MANDATORY SCRIPTS -->
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/jquery-1.11.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/jquery-migrate-1.2.1.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/jquery-ui/jquery-ui-1.10.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/jquery-mobile/jquery.mobile-1.4.2.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/bootstrap/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/bootstrap-dropdown/bootstrap-hover-dropdown.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/bootstrap-select/bootstrap-select.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/mcustom-scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/mmenu/js/jquery.mmenu.min.all.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/nprogress/nprogress.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/charts-sparkline/sparkline.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/breakpoints/breakpoints.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/numerator/jquery-numerator.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/jquery.cookie.min.js" type="text/javascript"></script>
    <!-- END MANDATORY SCRIPTS -->
    <!-- BEGIN PAGE LEVEL SCRIPTS -->
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/datatables/dynamic/jquery.dataTables.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/datatables/dataTables.bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/plugins/datatables/dataTables.tableTools.js"></script>
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/js/blog.js"></script>
    <!-- END  PAGE LEVEL SCRIPTS -->
    <script src="${pageContext.request.contextPath}/resources/pixit/admin/assets/js/application.js"></script>
</body>
</html>


