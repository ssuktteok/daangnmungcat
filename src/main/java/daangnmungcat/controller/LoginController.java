package daangnmungcat.controller;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.logging.Log;
import org.apache.ibatis.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import daangnmungcat.dto.AuthInfo;
import daangnmungcat.dto.Member;
import daangnmungcat.exception.WrongIdPasswordException;
import daangnmungcat.mapper.MemberMapper;
import daangnmungcat.service.AuthService;

@Controller
public class LoginController {
	private static final Log log = LogFactory.getLog(LoginController.class);
	
	@Autowired
	private AuthService authService;
	
	@Autowired
	private MemberMapper mapper;
	
	@GetMapping("/signup")
	public String signForm() {
		return "/signup";
	}
	
	@GetMapping("/login")
	public String login() {
		//파라미터에 member 추가하면 세션자동인듯
		return "/login";
	}
	
	@PostMapping("/login")
	public ModelAndView submit(Member member, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/login");
		try {
			AuthInfo authInfo = authService.authenicate(member.getId(), member.getPwd());
			//세션에 id pwd 저장
			session.setAttribute("member", member);
			mav.setViewName("redirect:/");
		}catch(WrongIdPasswordException e) {
			
		}
		
		return mav;
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	
	
	//security 테스트용
	@GetMapping("/all")
	public String doAll() {
		return "/sample/all";
	}
	
	@GetMapping("/admin")
	public String doAdmin() {
		return "/sample/admin";
	}
	
	@GetMapping("/member")
	public String doMember() {
		return "/sample/member";
	}

}