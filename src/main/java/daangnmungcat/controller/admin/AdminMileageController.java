package daangnmungcat.controller.admin;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import daangnmungcat.dto.Criteria;
import daangnmungcat.dto.Member;
import daangnmungcat.dto.Mileage;
import daangnmungcat.dto.PageMaker;
import daangnmungcat.exception.DuplicateMemberException;
import daangnmungcat.service.MemberService;
import daangnmungcat.service.MileageService;

@Controller
public class AdminMileageController {
	
	@Autowired
	private MileageService service;
	
	@Autowired
	private MemberService memService;
	
	@GetMapping("/admin/mileage/list")
	public String list(Model model, Criteria cri, @RequestParam @Nullable String content, @RequestParam @Nullable String member) {
		List<Mileage> list = new ArrayList<Mileage>();
		
		if(content != null  || member != null ) {
			Mileage mileage = new Mileage();
			if(content != null) {
				mileage.setContent(content);
			}
			if(member != null) {
				mileage.setMember(new Member(member));
			}
			list = service.selectMileageBySearch(mileage, cri);
		}else {
			list = service.selectMileageByAll(cri);
		}
		model.addAttribute("list", list);
		System.out.println(list);
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		pageMaker.setTotalCount(service.listCount());
		model.addAttribute("pageMaker", pageMaker);
		
		return "/admin/mileage/mileage_list";
	}
	
	@GetMapping("/admin/mileage/update")
	public String updateViewProduct(Model model, @RequestParam int id) {
		Mileage mileage = service.selectMileageById(id);
		model.addAttribute("mileage", mileage);
		
		return "/admin/mileage/mileage_update";
	}
	
	@PostMapping("/admin/mileage/update")
	public ResponseEntity<Object> updateMileage (@RequestBody Mileage mileage ) {
		System.out.println("오긴오냐?");
		try {
			return ResponseEntity.ok(service.updateMileageById(mileage));
		} catch (DuplicateMemberException e) {
			return ResponseEntity.status(HttpStatus.CONFLICT).build();
		}

	}
	
	@GetMapping("/admin/mileage/delete")
	public String deleteMileage (@RequestParam int id) {
		service.deleteMileage(id);
		return "redirect:/admin/mileage/list";
	}
	

	@GetMapping("/admin/mileage/write")
	public String writeMileage (Model model) {
		List<Member> list = memService.selectMemberByAll();
		model.addAttribute("list", list);
		return "/admin/mileage/mileage_write";
	}
	
}
