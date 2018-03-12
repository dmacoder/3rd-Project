package com.cafe24.ourplanners.admin.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MutablePropertySources;
import org.springframework.core.io.support.ResourcePropertySource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.cafe24.ourplanners.admin.service.AdminService;
import com.cafe24.ourplanners.member.domain.MemberVO;
import com.cafe24.ourplanners.util.SearchMemberCriteria;

@RestController
public class AdminRestController {

	@Inject
	private AdminService adminService;

	// 서비스 게시판 내 검색하기 searchType 기능 추가
	@RequestMapping(value = "admin/json/member_list.json")
	public HashMap<String, Object> getMemberListSearch(HttpServletRequest req, Model model,
			@RequestParam(required = false, defaultValue = "1") Integer nowPage,
			@RequestParam(required = false) Integer pageSize, @RequestParam(required = false) Integer blockPage,
			@RequestParam(required = false) Integer member_srl,
			@RequestParam(required = false, defaultValue = "") String user_id,
			@RequestParam(required = false, defaultValue = "") String user_name,
			@RequestParam(required = false, defaultValue = "") String email_address,

			@RequestParam(required = false, defaultValue = "") String searchType,
			@RequestParam(required = false, defaultValue = "") String keyword) {

		HashMap<String, Object> map = new HashMap<String, Object>();

		if (pageSize == null || blockPage == null) {
			ConfigurableApplicationContext ctx = new GenericXmlApplicationContext();

			ConfigurableEnvironment env = ctx.getEnvironment();

			MutablePropertySources propertySources = env.getPropertySources();

			try {
				propertySources.addLast(new ResourcePropertySource("classpath:Environment.properties"));
				pageSize = Integer.parseInt(env.getProperty("admin.member.pageSize"));
				blockPage = Integer.parseInt(env.getProperty("admin.member.blockPage"));
			} catch (Exception e) {

				e.printStackTrace();
			}

			ctx.close();
		}

		SearchMemberCriteria scri = new SearchMemberCriteria();

		if (member_srl != null && member_srl != 0)
			scri.setMember_srl(member_srl);

		scri.setUser_id(user_id);
		scri.setUser_name(user_name);
		scri.setEmail_address(email_address);

		scri.setNowPage(nowPage);
		scri.setPageSize(pageSize);
		scri.setBlockPage(blockPage);

		if (searchType != null && searchType.length() != 0)
			scri.setSearchType(searchType);
		if (keyword != null && keyword.length() != 0)
			scri.setKeyword(keyword);

		adminService.getSearchMemberList(scri, map);

		return map;
	}

	@RequestMapping(value = "admin/members", method = RequestMethod.DELETE)
	public ResponseEntity<Map<String, Object>> deleteMember(
			@RequestBody List<String> deleteList,
			HttpSession session) throws Exception {
		
		
		// 삭제할 사용자 ID마다 반복해서 사용자 삭제
		//Ajax를 통해 Array로 받은 deleteList를 하나씩 빼서 ArrayList에 넣음		
		//List<String> deleteLists = Arrays.asList(deleteList.split(","));
		
		int totalDeletedCount = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		ResponseEntity<Map<String, Object>> entity = null;
		MemberVO memVO = null;
		String user_id = null;
		try {
			if (session.getAttribute("loginUserInfo") == null) {
				map.put("result", "fail");
				map.put("errorMsg", "isNotLogin");
			} else {
				
				memVO = ((MemberVO) session.getAttribute("loginUserInfo"));
				user_id = memVO.getUser_id();
				
				if (!memVO.getIs_admin().equalsIgnoreCase("Y")) {
					map.put("result", "fail");
					map.put("errorMsg", "isNotAdmin");
				} else {
					
					for (String delete_user_id : deleteList) {
						if(user_id.equalsIgnoreCase(delete_user_id))
						{
							map.put("layer_msg", "현재 로그인 된 관리자 아이디는 삭제할 수 없습니다.<br/>다른 관리자 아이디를 이용하거나 회원탈퇴 메뉴를 이용하세요.");
							map.put("result", "fail");
							entity = new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
							return entity;
						}
						System.out.println("사용자 ID = " + delete_user_id + "삭제");
						int delete_count = adminService.deleteMember(delete_user_id);
						totalDeletedCount += delete_count;
					}
					
					if (totalDeletedCount <= 0) {
						map.put("result", "fail");
						map.put("errorMsg", "sqlError");
					} else {
						map.put("result", "success");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<Map<String, Object>>(HttpStatus.BAD_REQUEST);
		}

		if (((String) map.get("result")).equals("fail")) {
			entity = new ResponseEntity<Map<String, Object>>(map, HttpStatus.BAD_REQUEST);
		} else if (((String) map.get("result")).equals("success")) {
			System.out.println("회원 삭제 성공");
			entity = new ResponseEntity<Map<String, Object>>(map, HttpStatus.OK);
		}
		return entity;
		
	}

}
