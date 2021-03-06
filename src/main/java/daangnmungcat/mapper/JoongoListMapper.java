package daangnmungcat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import daangnmungcat.dto.Criteria;
import daangnmungcat.dto.FileForm;
import daangnmungcat.dto.Sale;

public interface JoongoListMapper {
	List<Sale> selectJoongoByAll();
	
	List<Sale> selectJoongoByAllPage(Criteria cri);
	
	List<Sale> selectJoongoByDongne1(@Param("dongne1") String dongne1, @Param("cri") Criteria cri);
	
	List<Sale> selectJoongoByDongne2(@Param("dongne1") String dongne1, @Param("dongne2") String dongne2, @Param("cri") Criteria cri);
	
	
	
	List<Sale> selectJoongoBySearch(@Param("sale") Sale sale, @Param("cri") Criteria cri);
	
	//insertForm용
	List<Sale> selectDongne1ByAll(@Param("dongne1") String dongne1);
	List<Sale> selectDongne2ByAll(@Param("dongne1") String dongne1, @Param("dongne2") String dongne2);
	
	// 프로필 쪽에서 쓰는 검색
	List<Sale> selectJoongoListByMemberAndState(@Param("state") String state, @Param("memberId") String memberId, @Param("cri") Criteria cri);
	int selectCountJoongoByMemberIdAndState(@Param("state") String state, @Param("memberId") String memberId);
	
	int listCount();
	int listSearchCount(Sale sale);
	int listCount1(@Param("dongne1") String dongne1);
	int listCount2(@Param("dongne1") String dongne1, @Param("dongne2") String dongne2);
	
	int insertJoongoSale(Sale sale);
	int updateJoongoSale(Sale sale);
	int updateSold(Sale sale);
	int deleteJoongoSale(int id);
	
	int selectHeartedJoongoCountsByMemberId(@Param("memberId") String memberId);
	List<Sale> selectHeartedJoongoByMemberIdWithPaging(@Param("memberId") String memberId, @Param("criteria") Criteria criteria);
//	int insertFileForm(FileForm FileForm);
	int nextID();


	
	
}
