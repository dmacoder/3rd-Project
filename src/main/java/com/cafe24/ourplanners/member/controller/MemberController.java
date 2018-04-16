package com.cafe24.ourplanners.member.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.WebUtils;

import com.cafe24.ourplanners.MainController;
import com.cafe24.ourplanners.member.domain.MemberVO;
import com.cafe24.ourplanners.member.dto.LoginDTO;
import com.cafe24.ourplanners.member.service.MemberService;
import com.cafe24.ourplanners.util.UploadFileUtils;


@Controller
public class MemberController {

	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	@Inject
	private MemberService service;

	// 회원가입
	@RequestMapping(value = "member/join", method = RequestMethod.GET)
	public String join(Model model, HttpServletRequest req) {
		logger.info("회원가입 이용약관");
		model.addAttribute("action", "term");
		return "member/member_join";
	}

	// 회원가입 다음단계 페이지 처리
	@RequestMapping(value = "member/join", method = RequestMethod.POST)
	public String join(MemberVO member, HttpServletRequest req, Model model, MemberVO vo) {

		logger.info("회원가입 action : " + req.getParameter("action"));

		if (req.getParameter("action") == null || req.getParameter("action").equals("")
				|| req.getParameter("action").equals("term")) {
			// String inotice = request.getParameter("inotice") == null ? " " :
			// request.getParameter("inotice");

			model.addAttribute("action", "term");
			return "member/member_join";

		} else if (req.getParameter("action").equals("signup")) {
			model.addAttribute("action", "signup");
			return "member/member_join";
		} else if (req.getParameter("action").equals("authmail")) {
			service.saveMember(req, model);

			return "member/member_join";

		} else if (req.getParameter("action").equals("complete")) {
			MemberVO vo1 = null;
			HttpSession session = req.getSession();
			System.out.println("세션");
			System.out.println("비밀번호:" + ((MemberVO) session.getAttribute("joinInfo")).getPassword());
			if (session == null || session.getAttribute("joinInfo") == null) {
				System.out.println("세션 리다이렉트");
				model.addAttribute("action", "term");
				return "member/member_join";

			} else {
				System.out.println("세션등록");
				vo1 = ((MemberVO) session.getAttribute("joinInfo"));
			}

			session.removeAttribute("joinInfo");

			service.registMember(vo1);

			model.addAttribute("action", "complete");
			model.addAttribute("joinInfo", vo1);

			return "member/member_join";

		} else {
			return "member/member_join";
		}

	}

	// 회원 프로필 사진 업로드
	@ResponseBody
	@RequestMapping(value = "member/uploadProfile", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	public void uploadProfile(MultipartFile file, String str, HttpSession session, HttpServletRequest request,
			Model model) throws Exception {

		Object obj = session.getAttribute("loginUserInfo");

		MemberVO memVO = (MemberVO) obj;

		String uploadPath = request.getSession().getServletContext().getRealPath("resources/upload/member/" + memVO.getMember_srl() + "/profile");
		
		ResponseEntity<String> imgPath = new ResponseEntity<String>(
				UploadFileUtils.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes()),
				HttpStatus.CREATED);

		String memberPicture = (String) imgPath.getBody();
		System.out.println("이미지 업로드 file path: "+memberPicture);
		logger.info(memberPicture);

		memVO.setProfile_img_path(memberPicture);
		try {
			service.uploadPicture(memVO);
			System.out.println("업로드 완료");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 회원탈퇴 동의 페이지
	@RequestMapping(value = "member/withdraw", method = RequestMethod.GET)
	public String withdraw(Model model) {

		return "member/member_withdraw";
	}

	// 회원탈퇴 처리
	@RequestMapping(value = "member/withdraw", method = RequestMethod.POST)
	public String withdraw(Model model, HttpServletRequest req, HttpSession session, RedirectAttributes rediAttr) {

		int affected = 0;
		if (req.getParameter("step").equalsIgnoreCase("2")) {
			return "member/member_withdraw_confirm_password";
		}

		else if (req.getParameter("step").equalsIgnoreCase("3")) {
			affected = service.withdrawMember(model, req, session);
		}

		if (affected <= 0) {
			model.addAttribute("layer_msg", "회원탈퇴를 실패 하였습니다.");
			return "member/member_withdraw";
		} else {
			rediAttr.addFlashAttribute("layer_msg", "회원탈퇴 처리 되었습니다.");
			// model.addAttribute("layer_msg", "회원탈퇴 처리 되었습니다.");
			/*
			 * UriComponents uri = ServletUriComponentsBuilder .fromServletMapping(req)
			 * .fromPath("/member/logout") .build();
			 */
			return "redirect:/member/logout";
			// return "redirect:"+req.getContextPath()+"member/logout";
		}

	}

	/*
	 * RedirectAttributes rediAttr
	 * 
	 * rediAttr.addFlashAttribute("msg", "비밀번호가 변경 되었습니다."); return
	 * "redirect:/member/change_password";
	 */
	// 비밀번호 변경 페이지
	@RequestMapping(value = "member/change_password", method = RequestMethod.GET)
	public String changePassword(Model model) {
		return "member/member_password_change";
	}

	// 비밀번호 변경 처리
	@RequestMapping(value = "member/change_password", method = RequestMethod.POST)
	public String changePassword(Model model, HttpServletRequest req, HttpSession session) {

		int affected = service.updatePassword(model, req, session);
		if (affected <= 0) {
			System.out.println("현재 비밀번호가 일치하지 않습니다.");
			model.addAttribute("error_msg", "현재 비밀번호가 일치하지 않습니다.");
			return "member/member_password_change";
		} else {
			model.addAttribute("layer_msg", "비밀번호가 변경 되었습니다.");
			return "index";
		}
	}

	// 로그인 화면
	@RequestMapping(value = "member/login", method = RequestMethod.GET)
	public String login(Model model, HttpServletRequest req, HttpSession session) {
		logger.info("로그인");
		String referer_url = req.getHeader("referer");
		System.out.println("리퍼러 = " + referer_url);
		String contextPath = req.getContextPath();
		// System.out.println("contextPath = "+contextPath);
		String command = null;
		String auth_prev_url = (String) session.getAttribute("auth_prev_url");

		// auth인터셉터로 타고온 로그인 처리인 경우
		if (auth_prev_url != null && auth_prev_url.length() != 0) {
			System.out.println("auth인터셉터 타고온 로그인");
			session.removeAttribute("auth_prev_url");
			session.setAttribute("prev_url", auth_prev_url);
			return "member/member_login";
		}

		// 직접 경로로 들어오는 경우 메인 페이지로 설정
		if (referer_url == null || referer_url.length() == 0) {
			String prev_url = (String) session.getAttribute("prev_url");
			if (prev_url == null || prev_url.length() == 0) {
				referer_url = "http://" + req.getServerName() + ":" + req.getServerPort() + contextPath;
				session.setAttribute("prev_url", referer_url);
			}
			return "member/member_login";
		}

		// command = prev_url.substring(contextPath.length());
		int start = referer_url.indexOf(contextPath) + contextPath.length();
		int end = referer_url.length();
		command = referer_url.substring(start, end);

		session.setAttribute("prev_url", referer_url);

		System.out.println("요청 주소 추출 : " + command + "\n이전 주소 : " + referer_url);

		if (command.equals("/member/join")) {
			// 회원가입 페이지에서 로그인시 메인 페이지로 그외는 이전 페이지를 넘김
			referer_url = "http://" + req.getServerName() + ":" + req.getServerPort() + contextPath;
			session.setAttribute("prev_url", referer_url);

		}

		return "member/member_login";
	}

	// 로그인 처리
	@RequestMapping(value = "member/loginPost", method = RequestMethod.POST)
	public void login(LoginDTO dto, HttpServletRequest req, HttpSession session, Model model) throws Exception {

		String redirect_url = (String) session.getAttribute("prev_url");

		MemberVO vo = service.login(dto, model);

		try {
			if (vo == null) {
				// 로그인 실패
				return;
			}

			model.addAttribute("loginUserInfo", vo);

			System.out.println("로그인된 아이디 : " + vo.getUser_id());

			// session.setAttribute("loginUserInfo", vo);
		} catch (Exception e) {
			// 로그인 실패
			logger.info("Exception Msg: {}", e.getMessage());
			model.addAttribute("ERROR_MSG", "예외가 발생 되었습니다. 관리자에게 문의하세요.");
			return;
		}

		if (dto.isUseCookie()) {
			int amount = 60 * 60 * 24;

			Date sessionLimit = new Date(System.currentTimeMillis() + (1000 * amount));

			service.keepLogin(vo.getMember_srl(), session.getId(), sessionLimit);

		}

	}

	@RequestMapping(value = "member/logout", method = RequestMethod.GET)
	public String logout(Model model, HttpServletRequest req, HttpServletResponse resp, HttpSession session)
			throws Exception {

		String prev_url = req.getHeader("referer");

		session.setAttribute("prev_url", prev_url);

		System.out.println("로그아웃시 이전주소 : " + prev_url);

		Object loginObj = session.getAttribute("loginUserInfo");

		if (loginObj != null) {
			MemberVO vo = (MemberVO) loginObj;

			session.removeAttribute("loginUserInfo");
			session.invalidate(); // prev_url 등 다른 세션도 삭제위해..
			Cookie loginCookie = WebUtils.getCookie(req, "loginCookie");

			if (loginCookie != null) {
				loginCookie.setPath("/");
				loginCookie.setMaxAge(0);
				resp.addCookie(loginCookie);
				service.keepLogin(vo.getMember_srl(), session.getId(), new Date());
			}
		}

		// 로그아웃처리
		// session.removeAttribute("loginUserInfo");

		// return "redirect:login";
		return "member/member_login";
	}
	
	//나의 정보 보기
		@RequestMapping(value = "member/myinfo", method = RequestMethod.GET)
		public ModelAndView viewMyInfo(Model model, HttpServletRequest req,
				@RequestParam(required = false, defaultValue = "") String type) {
			logger.info("나의 정보 보기");
			
			ModelAndView mv = new ModelAndView();
			
			HttpSession session = req.getSession();
			String action = req.getParameter("action");

			System.out.println("Method : " + req.getMethod() + " Action : " + req.getParameter("action"));

			Object obj = session.getAttribute("loginUserInfo");
			
			MemberVO memVO = (MemberVO) obj;
			String user_id = memVO.getUser_id();
			
			
			if (action == null || action.length() == 0 || action.equalsIgnoreCase("view")) {

				mv.setViewName("member/myinfo");

			}			
			else if (action.equalsIgnoreCase("modifyAdmin")) {
				
				//현재 접속된 계정의 아이디가 관리자인지 확인하고..
				if(!memVO.getIs_admin().equalsIgnoreCase("Y"))
				{
					// 비밀번호 다른경우 에러메시지와 함께 다시 비밀번호 확인창으로 뷰 이동
					// 에러 메시지 맵
					Map<String, Boolean> errorsMap = new HashMap<String, Boolean>();
					errorsMap.put("isNotAdminModifyMember", Boolean.TRUE);
					// <c:if test="${errors.isNotAdminModifyMember}">관리자 계정만 이용할 수 있습니다.</c:if>
					model.addAttribute("errors", errorsMap);
					mv.setViewName("member/member_modify_confirm_password");
									
				}
				else {
					// 관리자 계정인 경우 파라미터로 받은 user_id의 멤버 변수를 정보에 저장후 포워딩
					System.out.println("관리자 계정으로 수정 모드");
					MemberVO userInfo = null;
					String modify_id = req.getParameter("modify_id");
					
					//수정 아이디 없으면 자신계정
					if(modify_id == null || modify_id.length()==0)
						userInfo = service.getUserInfoById(user_id);	
					else
						userInfo = service.getUserInfoById(modify_id);
					
					model.addAttribute("userInfo", userInfo);
					
					model.addAttribute("modify_id", modify_id);
					
					mv.setViewName("member/myinfo_modify");
					
				}
			}
			
			return mv;
		}
			
		//나의 정보 수정
		@RequestMapping(value = "member/myinfo", method = RequestMethod.POST)
		public ModelAndView modifyMyInfoForm(Model model, HttpServletRequest req,HttpSession session) {
			
			logger.info("나의 정보 보기");
			
			ModelAndView mv = new ModelAndView();
			
			service.updateMyInfo(req,model,mv);
			

			return mv;
		}
		
	@RequestMapping(value = "member/confirmPassword", method = RequestMethod.GET)
	public String confirmPassword(Model model, HttpServletRequest request) {
		logger.info("비밀번호 확인");

		return "member/member_info_view";
	}

	@RequestMapping(value = "find/id")
	public ModelAndView findId(Model model, HttpServletRequest req) {
		logger.info("아이디 찾기");

		ModelAndView mv = new ModelAndView();
		service.findId(model, req, mv);

		// vm.setViewName("redirect:/board/boardList");
		mv.setViewName("find/find_id");
		return mv;
	}

	@RequestMapping(value = "find/password")
	public ModelAndView findPassword(Model model, HttpServletRequest req) {
		logger.info("비밀번호 찾기");

		ModelAndView mv = new ModelAndView();
		service.findPassword(model, req, mv);

		mv.setViewName("find/find_password");
		// vm.setViewName("redirect:/board/boardList");

		return mv;
	}

	// 이메일 변경 페이지
	@RequestMapping(value = "member/change_email", method= {RequestMethod.GET, RequestMethod.POST})
	public String changeEmail(Model model,HttpServletRequest req,HttpSession session) {

		
		Object obj = session.getAttribute("loginUserInfo");

		MemberVO emailInfo = (MemberVO) obj;
		String user_id = emailInfo.getUser_id();
		
		String action = req.getParameter("action");
		if(action==null || action.length()==0 || action.equals("form"))
		{
			System.out.println("이메일 변경할 사용자 아이디 : "+ user_id);
			
			
			
			System.out.println(emailInfo.getUser_id());
			System.out.println(emailInfo.getPassword());
			
			model.addAttribute("emailInfo", emailInfo);
			
			return "member/member_email_change";
		}
		else if(action.equals("change"))
		{
			String email_address = req.getParameter("email");
			
			service.updateEmail(user_id,email_address);
			
			return "member/member_email_change_complete";
		}
		return "member/member_email_change";
	}
}
