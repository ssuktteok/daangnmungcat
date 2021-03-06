package daangnmungcat.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import daangnmungcat.dto.AuthInfo;
import daangnmungcat.dto.Criteria;
import daangnmungcat.dto.Member;
import daangnmungcat.dto.Mileage;
import daangnmungcat.dto.PageMaker;
import daangnmungcat.service.MileageService;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
public class MileageController {
	
	@Autowired
	private MileageService mileageService;

	@GetMapping("/mypage/mileage/list")
	public String mileageMypageList(Model model, AuthInfo loginUser, Criteria cri) {
	
		Mileage mile = new Mileage();
		mile.setMember(new Member(loginUser.getId()));
		List<Mileage> list = mileageService.selectMileageBySearch(mile, cri);
		model.addAttribute("list",list);
		
		
		PageMaker pageMaker = new PageMaker();
		pageMaker.setCri(cri);
		int totalCount = list.size();
		pageMaker.setTotalCount(totalCount);
		model.addAttribute("pageMaker", pageMaker);
		
		
		return "/mypage/mileage_list";
	}

}
