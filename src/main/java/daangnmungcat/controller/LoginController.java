package daangnmungcat.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class LoginController {
	
	@GetMapping("/signup")
	public String signForm() {
		return "sign/signup";
	}
	
	@RequestMapping(value="/login", method= {RequestMethod.GET, RequestMethod.POST})
	public String login() {
		return "/login";
	}
	
	/*@RequestMapping(value="/login", method=RequestMethod.POST)
	public String submit(Member member, HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		HttpSession session = null;
		
		try {
			session = request.getSession();
			AuthInfo authInfo = authService.authenicate(member.getId(), member.getPwd());
			session.setAttribute("loginUser", authInfo);
			
			// 비회원 상태의 장바구니가 존재하면, 해당 회원의 장바구니로 이전시켜줌
			Optional<Cookie> cookie = Arrays.stream(request.getCookies()).filter(c -> c.getName().equals("basket_id")).findAny();
			cookie.ifPresent(c -> {
				c.setMaxAge(0);
				cartService.moveToMember(c.getValue(), authInfo.getId());
				response.addCookie(c);
			});
			
			return "redirect:/";
		} catch (Exception e) {
			e.printStackTrace(); // 에러 발생시 확인
			request.setAttribute("msg", "아이디나 비밀번호가 맞지 않습니다.");
			return "/login";
		}
	}*/
	
	// 로그아웃 get 요청도 처리
	@GetMapping("/logout")
	public String logout(HttpServletRequest request, HttpServletResponse response) {

	    Authentication auth = SecurityContextHolder.getContext().getAuthentication();

	    if(auth != null && auth.isAuthenticated()) {
	         new SecurityContextLogoutHandler().logout(request, response, auth);
	    }
	    
		return "redirect:/";
	}
		
}
