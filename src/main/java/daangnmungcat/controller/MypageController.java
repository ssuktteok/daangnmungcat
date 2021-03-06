package daangnmungcat.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.Nullable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import daangnmungcat.dto.AuthInfo;
import daangnmungcat.dto.Criteria;
import daangnmungcat.dto.Member;
import daangnmungcat.dto.Mileage;
import daangnmungcat.dto.Order;
import daangnmungcat.dto.OrderDetail;
import daangnmungcat.dto.OrderState;
import daangnmungcat.dto.PageMaker;
import daangnmungcat.dto.Payment;
import daangnmungcat.dto.Sale;
import daangnmungcat.dto.SearchCriteriaForOrder;
import daangnmungcat.dto.kakao.KakaoPayApprovalVO;
import daangnmungcat.exception.DuplicateMemberException;
import daangnmungcat.service.JoongoSaleService;
import daangnmungcat.service.KakaoPayService;
import daangnmungcat.service.MemberService;
import daangnmungcat.service.MileageService;
import daangnmungcat.service.OrderService;
import oracle.net.aso.m;

@RestController
@Controller
public class MypageController {
	
	//_대신 - 이고 최소화
	//대문, 행위는 url에 포함 x
	//마지막 슬래시 x
	
	@Autowired
	private OrderService orderService;
	
	@Autowired
	private MemberService service;
	
	@Autowired
	private KakaoPayService kakaoService;
	
	@Autowired
	private PasswordEncoder encoder;
	
	@Autowired
	private MileageService mileService;
	
	@Autowired
	private JoongoSaleService joongoService;
	
	//프로필사진 삭제 -> default로
	@GetMapping("/profile/get")
	public int defaultSetProfile(AuthInfo info, HttpSession session) {
		int res = service.deleteProfilePic(info.getId(), getRealPath(session));
		return res;
	}
	
	//프로필 사진 변경
	@PostMapping("/profile/post")
	public int uploadProfile(AuthInfo info, MultipartFile[] uploadFile, HttpSession session) {
		int res = service.updateProfilePic(info.getId(), uploadFile, getRealPath(session));
		return res;
	}

	//프로필소개 변경
	@PostMapping("/profile-text/post")
	public int updateProfileText(@RequestBody String json, AuthInfo info) throws ParseException {
		Member loginUser = service.selectMemberById(info.getId());
		
		String text = json.toString();
		loginUser.setProfileText(text);
		int res = service.updateProfileText(loginUser);
		return res;
	}
	
	//내 프로필사진만 가져오기
	@GetMapping("/member/pic")
	public Map<String, String> profilePic(AuthInfo loginUser) throws ParseException {
		Member member = service.selectMemberById(loginUser.getId());
		String path = member.getProfilePic();
		Map<String, String> map = new HashMap<>();
		map.put("path", path);
		return map;
		
	}
	
	//비밀번호 일치 확인
	@PostMapping("/member/checkPwd")
	public ResponseEntity<Object> checkPwd(AuthInfo loginUser, @RequestBody Map<String, Object> data) {
		try {
			String pwd = (String) data.get("pwd");
			System.out.println("pwd: " + pwd);
			
			Member member = service.selectMemberById(loginUser.getId());
			boolean res = encoder.matches(pwd, member.getPwd());
			System.out.println(res);
			if(res == true) {
				return ResponseEntity.ok(res);
			} else {
				return ResponseEntity.status(HttpStatus.CONFLICT).build();
			}
		} catch(Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}
	}
	
	//비밀번호 수정
	@PutMapping("/member/pwd")
	public ResponseEntity<Object> updatePwd(AuthInfo loginUser, @RequestBody Map<String, Object> data) {
		try {
			String nowPwd = (String) data.get("now_pwd");
			String newPwd = (String) data.get("new_pwd");
			
			System.out.println("nowPwd: " + nowPwd);
			System.out.println("newPwd: " + newPwd);
			
			Member member = service.selectMemberById(loginUser.getId());
			boolean res = encoder.matches(nowPwd, member.getPwd());
			System.out.println(res);
			
			if(res == true) {
				member.setPwd(encoder.encode(newPwd));
				return ResponseEntity.ok(service.updatePwd(member));
			} else {
				return ResponseEntity.status(HttpStatus.CONFLICT).build();
			}
		} catch(Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}
	}
	
	
	//멤버 모든 정보
	@GetMapping("/member/info")
	public Map<String, Object> memberInfo(AuthInfo loginUser) throws ParseException {
		Member member = service.selectMemberById(loginUser.getId());
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("member", member);
		return map;

	}
	
	
	//멤버 정보 수정
	@PostMapping("/member/info/post")
	public ResponseEntity<Object> updateMember(@RequestBody Member member) {
		System.out.println("update member");
		System.out.println(member);
		try {
			return ResponseEntity.ok(service.updateInfo(member));
		} catch (DuplicateMemberException e) {
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}

	}
	
	//폰번호 변경
	@PostMapping("/phone/post")
	public int updatePhone(@RequestBody String json, AuthInfo info) throws ParseException {
		Member loginUser = service.selectMemberById(info.getId());
		String phone = json.toString();
		loginUser.setPhone(phone);
		
		int res = service.updatePhone(loginUser);
		System.out.println("폰번호변경:" + res);
		return res;
	}
	
	//비밀번호 변경
	@PostMapping("/pwd/post")
	public int updatePwd(@RequestBody String json, AuthInfo info) {
		Member loginUser = service.selectMemberById(info.getId());
		
		String pwd = json.toString();
		loginUser.setPwd(pwd);
		int res = service.updatePwd(loginUser);
		return res;
	}
	
	//탈퇴
	@PostMapping("/withdrawal")
	public ResponseEntity<Object> withdraw(AuthInfo loginUser, @RequestBody Map<String, String> data, HttpSession session) {
		try {
			
			String pwd = (String) data.get("pwd");
			System.out.println("pwd: " + pwd);
			
			Member member = service.selectMemberById(loginUser.getId());
			boolean matches = encoder.matches(pwd, member.getPwd());
			System.out.println(matches);
			if(matches == true) {
				int res = service.deleteMember(member.getId());
				session.invalidate();
				return ResponseEntity.ok(res);
			} else {
				return ResponseEntity.status(HttpStatus.CONFLICT).build();
			}
		} catch(Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}
	}
	
	@PostMapping("/order-cancel")
	public ResponseEntity<Object> orderCancel(@RequestBody Map<String, String> map) {
		try {
			System.out.println(map.get("id").toString());
			
			String id = map.get("id").toString();
			Order order = orderService.getOrderByNo(id);
			List<OrderDetail> odList = orderService.getOrderDetail(id);
			
			int res = orderService.myPageOrderCancel(order, odList);
			
			return ResponseEntity.ok(res);
		} catch(Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}
		
	}
	
	
	//구매확정 -> 마일리지 인서트
	@PostMapping("/order-confirm")
	public ResponseEntity<Object> orderConfirm(@RequestBody Map<String, String> map, AuthInfo loginUser){
		try {
			Member member = service.selectMemberById(loginUser.getId());
			
			String odId = map.get("id").toString();
			OrderDetail od = orderService.getOrderDetailById(odId);
			
			int mileage = orderService.myPageOrderConfirm(od, member);
			
			return ResponseEntity.ok(mileage);
		} catch(Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}
	}
	
	
/////// 주문내역 mv
	
	@GetMapping("/mypage/mypage_order_list")
	public ModelAndView orderList(SearchCriteriaForOrder cri, AuthInfo loginUser, @Nullable @RequestParam(name = "id") String id) {
		ModelAndView mv = new ModelAndView();
		
		Member member = service.selectMemberById(loginUser.getId());
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		cri.setPerPageNum(10);
		
		
		if(id != null) {
			Order order = orderService.getOrderByNo(id);
			List<OrderDetail> odList = orderService.sortingOrderDetail(order.getId());
			
			order.setDetails(odList);
			for(OrderDetail od: odList) {
				od.setOrderId(order.getId());
			}
			
			//무통장
			Payment kakao = orderService.getPaymentById(order.getPayId());
			Payment accountPay = orderService.selectAccountPaymentByOrderId(order.getId());
			
			mv.addObject("order", order);
			mv.addObject("kakao", kakao);
			mv.addObject("account", accountPay);
			mv.setViewName("/mypage/mypage_order_detail");
			
		}else {	
			
			List<Order> list = orderService.selectOrderById(cri, member.getId());
			pageMaker.setTotalCount(orderService.selectOrderByIdCount(cri, member.getId()));
			
			for(Order o: list) {
				List<OrderDetail> odList = orderService.sortingOrderDetail(o.getId());
				o.setDetails(odList);
				for(OrderDetail od: odList) {
					od.setOrderId(o.getId());
				}
			}
			
			mv.addObject("list", list);
			mv.addObject("pageMaker", pageMaker);
			mv.setViewName("/mypage/mypage_order_list");
		}
		
		
		return mv;
	}
	

	
	@GetMapping("/mypage/mypage_order_cancel_list")
	public ModelAndView getCancelOrder(SearchCriteriaForOrder cri, AuthInfo loginUser,
			@Nullable @RequestParam String id) {
		ModelAndView mv = new ModelAndView();
		
		Member member = service.selectMemberById(loginUser.getId());
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		cri.setPerPageNum(10);
		
		
		
		if(id != null) {
			Order order = orderService.getOrderByNo(id);
			List<OrderDetail> odList = orderService.sortingOrderDetail(order.getId());
			
			order.setDetails(odList);
			for(OrderDetail od: odList) {
				od.setOrderId(order.getId());
			}
			
			//무통장
			Payment kakao = orderService.getPaymentById(order.getPayId());
			Payment accountPay = orderService.selectAccountPaymentByOrderId(order.getId());
			
			mv.addObject("order", order);
			mv.addObject("kakao", kakao);
			mv.addObject("account", accountPay);
			mv.setViewName("/mypage/mypage_order_detail");
			
		}else {
		
			List<Order> list = orderService.selectCancelOrderById(cri, member.getId());
			pageMaker.setTotalCount(orderService.selectCancelOrderByIdCount(cri, member.getId()));
			
			for(Order o: list) {
				List<OrderDetail> odList = orderService.sortingOrderDetail(o.getId());
				o.setDetails(odList);
				for(OrderDetail od: odList) {
					od.setOrderId(o.getId());
				}
			}
			
			mv.addObject("list", list);
			mv.addObject("pageMaker", pageMaker);
			mv.setViewName("/mypage/mypage_order_cancel_list");
		}
		
		return mv;
		
	}
	
	@GetMapping("/mypage/mypage_main")
	public ModelAndView myPage(AuthInfo loginUser) {
		
		Member member = service.selectMemberById(loginUser.getId());
		int mileage = mileService.getMileage(member.getId());
		
		Criteria cri = new Criteria(1, 4);
		List<Sale> saleList = joongoService.getListsByStateAndMember("ALL", loginUser.getId(), cri);
		int saleTotal = joongoService.countsByStateAndMember("ALL", loginUser.getId());
		
		List<Sale> heartedList = joongoService.getHeartedList(loginUser.getId(), cri);
		int heartedTotal = joongoService.getHeartedCounts(loginUser.getId());
		
		List<Order> orderList = orderService.selectOrderByMonth(member.getId());
		for(Order o:orderList) {
			List<OrderDetail> odList = orderService.sortingOrderDetail(o.getId());
			o.setDetails(odList);
			for(OrderDetail od: odList) {
				od.setOrderId(o.getId());
			}
		}


		ModelAndView mv = new ModelAndView();
		mv.addObject("saleList", saleList);
		mv.addObject("saleTotal", saleTotal);
		mv.addObject("heartedList", heartedList);
		mv.addObject("heartedTotal", heartedTotal);
		mv.addObject("list", orderList);
		mv.addObject("grade",member.getGrade().getName().toUpperCase());
		mv.addObject("member", member);
		mv.addObject("mile", mileage);
		mv.setViewName("/mypage/mypage_main");
	
		return mv;
	}

	
	private File getRealPath(HttpSession session) {
		return new File(session.getServletContext().getRealPath("")); 
	}
}
