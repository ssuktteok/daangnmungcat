package daangnmungcat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import daangnmungcat.dto.AuthInfo;
import daangnmungcat.dto.Member;
import daangnmungcat.exception.WrongIdPasswordException;
import daangnmungcat.mapper.MemberMapper;

@Component
public class AuthService {
	
	@Autowired
	private MemberService service;
	
	public AuthInfo authenicate(String id, String pwd) {
		Member member = service.selectMembetById(id);
		if(member == null) {
			throw new WrongIdPasswordException();
		}
		
		if(!member.matchPassword(pwd)) {
			throw new WrongIdPasswordException();
		}
		
		return new AuthInfo(member.getId());
	}
}
