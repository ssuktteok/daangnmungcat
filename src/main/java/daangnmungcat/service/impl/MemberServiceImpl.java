package daangnmungcat.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import daangnmungcat.dto.Address;
import daangnmungcat.dto.Authority;
import daangnmungcat.dto.Criteria;
import daangnmungcat.dto.Dongne1;
import daangnmungcat.dto.Dongne2;
import daangnmungcat.dto.Member;
import daangnmungcat.dto.Mileage;
import daangnmungcat.dto.SearchCriteria;
import daangnmungcat.mapper.MemberMapper;
import daangnmungcat.service.AuthoritiesService;
import daangnmungcat.service.MemberService;
import daangnmungcat.service.MileageService;
import lombok.extern.log4j.Log4j2;
import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

@Service
@Log4j2
public class MemberServiceImpl implements MemberService {

	private static final String UPLOAD_PATH = "resources" + File.separator + "upload" + File.separator + "profile";
	
	@Autowired
	private MemberMapper mapper;
	
	@Autowired
	private AuthoritiesService authoritesService;
	
	@Autowired
	private MileageService mService;
	
	@Override
	public List<Member> selectMemberByAll() {
		return mapper.selectMemberByAll();
	}

	@Override
	public List<Member> getList(Member member, Criteria criteria) {
		return mapper.selectMemberByConditionWithPaging(member, criteria);
	}
	
	@Override
	public Member selectMemberById(String id) {
		return mapper.selectMemberById(id);
	}
	
	@Override
	public int deleteMember(String id) {
		return mapper.deleteMember(id);
	}


	@Override
	@Transactional
	public int registerMember(Member member) {
		Mileage mile = new Mileage();
		mile.setMileage(1000);
		mile.setOrder(null);
		mile.setContent("회원가입");
		mile.setMember(member);
		
		Authority authority = new Authority(member.getId(), "USER");
		
		int res = mService.insertMilegeInfo(mile);
		res += mapper.insertMember(member);
		res += authoritesService.registerAuthorityIntoMember(authority);
		
		if(res != 3) {
			throw new RuntimeException();
		}
		
		return res;
	}

	@Override
	public Integer checkPwd(String id, String pwd) {
		return mapper.checkPwd(id, pwd);
	}

	@Override
	public int idCheck(String id) {
		int res = mapper.idCheck(id); 
		return res;
	}

	@Override
	public int emailCheck(String email) {
		int res =  mapper.emailCheck(email);
		return res;
	}
	
	@Override
	public int phoneCheck(String phone) {
		int res = mapper.phoneCheck(phone);
		return res;
	}
	
	
	@Override
	public List<Dongne1> Dongne1List() {
		return mapper.Dongne1List();
	}

	@Override
	public List<Dongne2> Dongne2List(int dongne1) {
		return mapper.Dongne2List(dongne1);
	}
	
	@Override
	public void certifiedPhoneNumber(String phoneNumber, String cerNum) {

        String api_key = "NCSEEVJOI1LJEMQC";
        String api_secret = "0DGQ4GKFFZIVZEOVXWIVQTTU3JONGQZS";
        Message coolsms = new Message(api_key, api_secret);

        // 4 params(to, from, type, text) are mandatory. must be filled
        HashMap<String, String> params = new HashMap<String, String>();
        params.put("to", phoneNumber);    // 수신전화번호
        params.put("from", "01056156004");    // 발신전화번호. 테스트시에는 발신,수신 둘다 본인 번호로 하면 됨
        params.put("type", "SMS");
        params.put("text", "당근멍캣 휴대폰인증 테스트 메시지 : 인증번호는" + "["+cerNum+"]" + "입니다.");
 
        try {
            JSONObject obj = (JSONObject) coolsms.send(params);
            System.out.println(obj.toString());
        } catch (CoolsmsException e) {
            System.out.println(e.getMessage());
            System.out.println(e.getCode());
        }
	}

	
	@Override
	@Transactional
	public String modifyProfile(Member member, MultipartFile uploadFile, File realPath, boolean isChanged) {
		String fileName = "images/default_user_image.png";
		
		/* 업로드할 폴더 지정. 폴더가 없는 경우 생성 */
		File dir = new File(realPath, UPLOAD_PATH);
		
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		// 이미지가 변경된 경우, 삭제된 경우(기존 파일 삭제), 없었는데 추가된 경우
		if(isChanged == true) {
			try {
				Member originMember = selectMemberById(member.getId());
				
				// 이미지가 변경되거나 추가된 경우, 파일을 저장
				if(!uploadFile.isEmpty()) {
					String uploadFileName = uploadFile.getOriginalFilename();
					String exc = uploadFileName.substring(uploadFileName.lastIndexOf(".")+1, uploadFileName.length());
					
					uploadFileName = member.getId() + "." + exc;
					File saveFile = new File(dir, uploadFileName);
					
					uploadFile.transferTo(saveFile);
					fileName = "upload/profile/" + uploadFileName;
				}
				
				member.setProfilePic(fileName);
				mapper.updateProfilePic(member);
				mapper.updateProfileText(member);
				mapper.updateInfo(member);
				
				if(uploadFile.isEmpty()) {
					// 이미지가 삭제된 경우, 파일 삭제
					File deleteFile = new File(dir, originMember.getProfilePic());
					deleteFile.delete();
				}
				
				log.info("파일이 변경됨");
				log.info(member.toString());
				
			} catch (IllegalStateException | IOException e) {
				log.error(e.getStackTrace());
			}
		} else {
			log.info("파일이 변경되지 않음");
			log.info(member.toString());
			mapper.updateProfileText(member);
			mapper.updateInfo(member);
		}
		
		return member.getId();
	}
	
	
	@Override
	public int deleteProfilePic(String id, File realPath) {		
		Member member = selectMemberById(id);
		
		/* 업로드할 폴더 지정. 폴더가 없는 경우 생성 */
		File dir = new File(realPath, UPLOAD_PATH);
		
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		System.out.println("delete할 Path:" + dir);
		
		File files[] = dir.listFiles();
		//파일리스트에서 이름 찾아서 지우기
		for(int i=0; i<files.length; i++) {
			File file = files[i];
			String fileName = file.getName();
			int idx = fileName.lastIndexOf(".");
			String onlyName = fileName.substring(0, idx);
		
			System.out.println("파일목록:" + onlyName);
			if(onlyName.equals(member.getId())) {
				file.delete();
			}
		}
		File deletePic = new File(dir, member.getProfilePic());
		deletePic.delete();
		String def = "images/default_user_image.png";
		member.setProfilePic(def);
		
		return mapper.updateProfilePic(member);
	}
	
	@Override
	public int updateProfilePic(String id, MultipartFile[] uploadFile, File realPath) {
		Member member = selectMemberById(id);
		
		/* 업로드할 폴더 지정. 폴더가 없는 경우 생성 */
		File dir = new File(realPath, UPLOAD_PATH);
		
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		for(MultipartFile multipartFile : uploadFile) {
			
			System.out.println("Upload File Name: " + multipartFile.getOriginalFilename());
			System.out.println("Upload File Size: " + multipartFile.getSize());
			
			String uploadFileName = multipartFile.getOriginalFilename();
			System.out.println("only file name: " + uploadFileName);
			
			//확장자 구하기
			String exc = uploadFileName.substring(uploadFileName.lastIndexOf(".")+1, uploadFileName.length());
			
			//아이디로 파일이름 변경
			uploadFileName = member.getId() + "." + exc;
			
			//랜덤이름
			//UUID uuid = UUID.randomUUID();
			//uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			File saveFile = new File(dir, uploadFileName);
			
			try {
				multipartFile.transferTo(saveFile);
			} catch(Exception e) {
				e.getMessage();
			}
			
			String path = "upload/profile/"+ member.getId() + "." + exc;
			member.setProfilePic(path);
		}
		
		return mapper.updateProfilePic(member);
	}
	
	/*
	private String getFolder(HttpServletRequest request) {
		String path = request.getSession().getServletContext().getRealPath("resources\\upload\\profile");
		return path;
	}*/

	@Override
	public int updateProfileText(Member member) {
		return mapper.updateProfileText(member);
	}

	@Override
	public int updatePhone(Member member) {
		return mapper.updatePhone(member);
	}
	
	@Override
	public int updatePwd(Member member) {
		return mapper.updatePwd(member);
	}
	
	@Override
	public int updateInfo(Member member) {
		return mapper.updateInfo(member);
	}

	
	@Override
	public int dongneUpdate(String id, Dongne1 dongne1, Dongne2 dongne2) {
		return mapper.dongneUpdate(id, dongne1, dongne2);
	}

	@Override
	public List<Address> myAddress(String id) {
		return mapper.selectAddressById(id);
	}

	@Override
	public int insertAddress(Address address) {
		return mapper.insertAddress(address);
	}

	@Override
	public int updateMyAddress(Member member) {
		return mapper.updateMyAddress(member);
	}

	@Override
	public int updateShippingAddress(Address address) {
		return mapper.updateAddress(address);
	}

	@Override
	public Address getAddress(String id) {
		return mapper.getAddress(id);
	}

	@Override
	public int deleteShippingAddress(String id) {
		return mapper.deleteAddress(id);
	}

	// admin
	@Override
	public List<Member> search(SearchCriteria scri, Member member) {
		List<Member> list = mapper.selectMemberBySearch(scri, member);
		return list;
	}
	
	@Override
	public int getTotalBySearch(SearchCriteria scri, Member member) {
		int count = mapper.selectMemberCountBySearch(scri, member);
		return count;
	}

	@Override
	public int findMember(String id, String name, String email) {
		return mapper.findMember(id, name, email);
	}

	@Override
	public String selectIdByCondition(String id, String name, String email) {
		return mapper.selectIdByCondition(id, name, email);
	}

}
