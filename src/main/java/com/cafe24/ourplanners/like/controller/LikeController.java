package com.cafe24.ourplanners.like.controller;

import java.util.HashMap;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MutablePropertySources;
import org.springframework.core.io.support.ResourcePropertySource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cafe24.ourplanners.like.service.LikeService;
import com.cafe24.ourplanners.util.LikeCriteria;
import com.cafe24.ourplanners.util.SearchFAQCriteria;

@Controller
public class LikeController {
	
	private static final Logger logger = LoggerFactory.getLogger(LikeController.class);
	
	@Inject
	private LikeService likeService;
		@ResponseBody
		@RequestMapping(value = "/like/json/like_list.json")
		public HashMap<String, Object> getLikeListJson(HttpServletRequest req, Model model,
				@RequestParam(required = false, defaultValue = "1") Integer nowPage,

				@RequestParam(required = false) Integer board_srl,

				@RequestParam(required = false) String user_id,
				
				@RequestParam(required = false) Integer pageSize, 
				@RequestParam(required = false) Integer blockPage) {

			HashMap<String, Object> map = new HashMap<String, Object>();

			if (pageSize == null || blockPage == null) {
				ConfigurableApplicationContext ctx = new GenericXmlApplicationContext();

				ConfigurableEnvironment env = ctx.getEnvironment();

				MutablePropertySources propertySources = env.getPropertySources();

				try {
					propertySources.addLast(new ResourcePropertySource("classpath:Environment.properties"));
					if (pageSize == null)
						pageSize = Integer.parseInt(env.getProperty("like.pageSize"));
					if (blockPage == null)
						blockPage = Integer.parseInt(env.getProperty("like.blockPage"));
				} catch (Exception e) {

					e.printStackTrace();
				}

				ctx.close();
			}

			LikeCriteria lcri = new LikeCriteria();

			if (board_srl != null) {
				lcri.setBoard_srl(board_srl);
			}

			if (user_id != null && user_id.length() != 0) {
				lcri.setUser_id(user_id);
			}
			
			lcri.setNowPage(nowPage);
			lcri.setPageSize(pageSize);
			lcri.setBlockPage(blockPage);

			likeService.getLikeListJson(lcri, map);

			return map;
		}
	
	
	@RequestMapping(value = "like/{board_srl}", method = RequestMethod.GET)
	public String viewFAQ(@PathVariable Integer board_srl, Model model) {
		logger.info("게시물 번호에 해당하는 like user 구하기");		
		model.addAttribute("board_srl", board_srl);
		return "like/faq/customercenter_faq_view";
	}
	
}
