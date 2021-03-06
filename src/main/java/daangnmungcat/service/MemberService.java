package daangnmungcat.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import daangnmungcat.dto.Address;
import daangnmungcat.dto.Criteria;
import daangnmungcat.dto.Dongne1;
import daangnmungcat.dto.Dongne2;
import daangnmungcat.dto.Member;
import daangnmungcat.dto.SearchCriteria;

@Service
public interface MemberService {
	List<Member> selectMemberByAll();
	List<Member> getList(Member member, Criteria criteria);
	Member selectMemberById(@Param("id")String id);
	Integer checkPwd(@Param("id")String id, @Param("pwd")String pwd);
	
	List<Dongne1> Dongne1List();
	List<Dongne2> Dongne2List(@Param("dongne1Id")int dongne1);
	
	int deleteMember(String id);
	int registerMember(Member member);
	int idCheck(String id);
	int emailCheck(String email);
	int phoneCheck(String phone);
	
	String modifyProfile(Member member, MultipartFile uploadFile, File realPath, boolean isChanged);
	int deleteProfilePic(String id, File realPath);
	int updateProfilePic(String id, MultipartFile[] uploadFile, File realPath);
	int updateProfileText(Member member);
	int updatePhone(Member member);
	int updatePwd(Member member);
	int updateInfo(Member member);
	
	
	//휴대폰인증
	void certifiedPhoneNumber(String phoneNumber, String cerNum);
	
	int dongneUpdate(@Param("id") String id, @Param("dongne1") Dongne1 dongne1, @Param("dongne2") Dongne2 dongne2);
	
	//주소
	List<Address> myAddress(String id);
	int insertAddress(Address address);
	int updateMyAddress(Member member);
	Address getAddress(String id);	
	int updateShippingAddress(Address address);
	int deleteShippingAddress(String id);
	

	// admin
	List<Member> search(SearchCriteria scri, Member member);
	int getTotalBySearch(SearchCriteria scri, Member member);
	
	//find
	int findMember(String id, String name, String email);
	String selectIdByCondition(String id, String name, String email);
	
}