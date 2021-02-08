package daangnmungcat.controller;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import daangnmungcat.dto.AuthInfo;
import daangnmungcat.dto.Criteria;
import daangnmungcat.dto.FileForm;
import daangnmungcat.dto.GpsToAddress;
import daangnmungcat.dto.Member;
import daangnmungcat.dto.PageMaker;
import daangnmungcat.dto.Sale;
import daangnmungcat.mapper.JoongoListMapper;
import daangnmungcat.service.GpsToAddressService;
import daangnmungcat.service.JoongoSaleService;
import daangnmungcat.service.MemberService;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
public class JoongoListController {
	
	@Autowired
	private JoongoListMapper mapper;
	
	@Autowired
	private MemberService service;

	@Autowired
	private JoongoSaleService s;

	@GetMapping("/joongo_list")
	public String list(Model model, Criteria cri, HttpSession session) throws UnsupportedEncodingException {
		AuthInfo loginUser = (AuthInfo) session.getAttribute("loginUser");
		if (loginUser == null) {
			return "redirect:/joongo_list/all";
		} else {
			System.out.println("loginUser check : "+ loginUser);
			if (loginUser.getDongne1().getName() == null || loginUser.getDongne2().getName() == null) {
				return "redirect:/joongo_list/all";
			} else {
				return "redirect:/joongo_list/"+ URLEncoder.encode(loginUser.getDongne1().getName(), "UTF-8") +"/"+ URLEncoder.encode(loginUser.getDongne2().getName(), "UTF-8");
			}
		}
	}
	
	@GetMapping("/joongo_list/all")
	public String listAll(Model model, Criteria cri, HttpSession session) throws UnsupportedEncodingException {
		System.out.println(cri);
		List<Sale> list = mapper.selectJoongoByAllPage(cri);
		System.out.println(list);
		model.addAttribute("list", list);
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		pageMaker.setTotalCount(mapper.listCount());
		model.addAttribute("pageMaker", pageMaker);
		
		return "/joongo_list";
	}
	
	@GetMapping("/joongo_list/{dongne1}")
	public String listDongne1(Model model, @PathVariable("dongne1") String dongne1, Criteria cri){
		List<Sale> list = mapper.selectJoongoByDongne1(dongne1, cri);
		model.addAttribute("list", list);
		model.addAttribute("dongne1Name", dongne1);

		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		pageMaker.setTotalCount(mapper.listCount1(dongne1));
		model.addAttribute("pageMaker", pageMaker);
		return "/joongo_list";
	}
	
	@GetMapping("/joongo_list/{dongne1}/{dongne2}")
	public String listDongne2(Model model, @PathVariable("dongne1") String dongne1, @PathVariable("dongne2") String dongne2, Criteria cri) {
		System.out.println(dongne1);
		List<Sale> list = mapper.selectJoongoByDongne2(dongne1, dongne2, cri);
		model.addAttribute("list", list);
		model.addAttribute("dongne1Name", dongne1);
		model.addAttribute("dongne2Name", dongne2);

		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		pageMaker.setTotalCount(mapper.listCount2(dongne1, dongne2));
		model.addAttribute("pageMaker", pageMaker);
		return "/joongo_list";
	}
	
	@PostMapping("/gpsToAddress")
	public void find(HttpServletResponse rs ,@RequestBody GpsToAddress gpsToAddress) throws Exception {
		try {
			JSONObject jso = new JSONObject();
			GpsToAddressService gps = new GpsToAddressService(gpsToAddress.getLat(), gpsToAddress.getLon());
			String[] address = gps.getAddress().split(" ");
			jso.put("address1", address[1]);
			jso.put("address2", address[2]);
			rs.setContentType("text/html;charset=utf-8");
			PrintWriter out = rs.getWriter();
			out.print(jso.toString());
		} catch (Exception e) {
			System.out.println("오류");
		}
	}
	
	@GetMapping("/GpsToAddress/{lat}/{lon}")
	public String findAddress(@PathVariable("lat") double lat, @PathVariable("lon") double lon) throws Exception {
		System.out.println("왔다리");
		double latitude = lat;
		double longitude = lon;

		GpsToAddressService gps = new GpsToAddressService(latitude, longitude);
		System.out.println(gps.getAddress());
		System.out.println(lat + ", " + lon);
		return null;
	}
	
	
	//insertForm용 - > 바로글쓰기버튼
	@GetMapping("/joongoSale/addList")
	public String addListForm(Model model, HttpSession session) {
			return "joongoSale/addList";
		}
	
	//insertForm용  -> 동네1 선택
	@GetMapping("/joongoSale/addList/dongne1")
	public ResponseEntity<Object> dongne1() {
		return ResponseEntity.ok(service.Dongne1List());
	}
	
	//insertForm용 -> 동네2선택 후
	@GetMapping("joongoSale/addList/dongne2/{dongne1}")
	public ResponseEntity<Object> dongne2(@PathVariable int dongne1) {
		return ResponseEntity.ok(service.Dongne2List(dongne1));
	}
	
	//update용  
	@GetMapping("/joongoSale/modiList")
	public String updateForm(@RequestParam int id, Model model, HttpSession session) {
		Sale sale = s.getSaleById(id);
		List<FileForm> flist = s.selectImgPath(id);
		model.addAttribute("sale", sale);
		model.addAttribute("flist", flist);
		
		return "joongoSale/sale_update";
	}
	
	//update용  -> 동네1 선택
	@GetMapping("/joongoSale/modify/dongne1")
	public ResponseEntity<Object> dongne1Modify() {
		return ResponseEntity.ok(service.Dongne1List());
	}
	
	//update용 -> 동네2선택 후
	@GetMapping("joongoSale/modify/dongne2/{dongne1}")
	public ResponseEntity<Object> dongne2Modify(@PathVariable int dongne1) {
		return ResponseEntity.ok(service.Dongne2List(dongne1));
	}
	
	@PostMapping("/joongoSale/insert")
	public String add(HttpSession session,  Model model, HttpServletRequest request, HttpServletResponse response, Sale sale, int category, @RequestParam(value = "file") MultipartFile[] fileList) throws Exception {
		request.setCharacterEncoding("UTF-8");
		
		AuthInfo loginUser = (AuthInfo) session.getAttribute("loginUser");
		switch (category) {
		case 1:
			sale.setDogCate("y");
			sale.setCatCate("n");
			break;
		case 2:
			sale.setDogCate("n");
			sale.setCatCate("y");
			break;
		case 3:
			sale.setDogCate("y");
			sale.setCatCate("y");
			break;
		}

		sale.setMember(new Member(loginUser.getId()));
		s.insertJoongoSale(sale, fileList, request);
		int id = sale.getId();
		String textUrl = "detailList?id=" + id;
		model.addAttribute("msg", "등록되었습니다.");
		model.addAttribute("url", textUrl);
		return "/joongoSale/alertFrom";
	}
	
	@PostMapping("/joongoSale/modify")
	public String update(HttpSession session,  Model model, HttpServletRequest request, HttpServletResponse response, Sale sale, int category, @RequestParam(value = "file") MultipartFile[] fileList) throws Exception {
		request.setCharacterEncoding("UTF-8");
		
		log.info("수정 후 SaleState: " + sale.getSaleState() + sale.getSaleState().getCode() + sale.getSaleState().getLabel());
	
		return null;
	}
	
	
}