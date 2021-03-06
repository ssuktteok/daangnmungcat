package daangnmungcat.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import daangnmungcat.dto.Criteria;
import daangnmungcat.dto.MallProduct;
import daangnmungcat.dto.Sale;
import daangnmungcat.service.JoongoSaleService;
import daangnmungcat.service.MallPdtService;

@Controller
public class HomeController {
	
	@Autowired
	private JoongoSaleService saleService;

	@Autowired
	private MallPdtService mallService;
	
	@RequestMapping(value= "/" ,method={RequestMethod.POST,RequestMethod.GET})
	public String main(Model model,HttpServletRequest request, HttpServletResponse response) throws Exception{
		Criteria cri = new Criteria();
		cri.setRowStart(1);
		cri.setRowEnd(8);
		
		List<Sale> saleList = saleService.getLists(cri);
		
		List<MallProduct> dogList = mallService.selectDogByAll(cri);
		List<MallProduct> catList = mallService.selectCatByAll(cri);
		model.addAttribute("saleList", saleList);
		model.addAttribute("dogList", dogList);
		model.addAttribute("catList", catList);

		return "/main";
	}
}
