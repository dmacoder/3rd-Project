package com.cafe24.ourplanners.search.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.cafe24.ourplanners.board.domain.BoardVO;
import com.cafe24.ourplanners.board.domain.SubCategoryVO;
import com.cafe24.ourplanners.board.domain.WordCloudVO;
import com.cafe24.ourplanners.util.Criteria;
import com.cafe24.ourplanners.util.SearchServiceBoardCriteria;
import com.cafe24.ourplanners.util.ServiceBoardCriteria;

@Repository
public class SearchDAOImpl implements SearchDAO {

	@Autowired
	private SqlSession sqlSession;

	private static String searchMapper = "com.kosmo.mapper.SearchMapper";
	private static String wordCloudMapper = "com.kosmo.mapper.WordCloudMapper";

	@Override
	public List<BoardVO> getHotServiceList(Criteria cri) {

		return sqlSession.selectList(searchMapper + ".getHotServiceList", cri);

	}

	@Override
	public List<WordCloudVO> getHotKeyWordList(ServiceBoardCriteria cri) {

		return sqlSession.selectList(wordCloudMapper + ".getHotWordCloud", cri);
	}

	@Override
	public List<SubCategoryVO> getSubCategoryListSearch(SubCategoryVO vo) {
		return sqlSession.selectList(searchMapper + ".getSubCategoryListSearch", vo);
	}

	@Override
	public List<BoardVO> getServiceListSearch(SearchServiceBoardCriteria scri) {
		return sqlSession.selectList(searchMapper + ".getServiceListSearch", scri);
	}

	// 검색어 워드 클라우드 입력
	@Override
	public int insertWordCloud(SearchServiceBoardCriteria scri) {

		HttpServletRequest req = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String ip = req.getHeader("X-FORWARDED-FOR");
		if (ip == null)
		ip = req.getRemoteAddr();

		Map<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("ip_address", ip);
		
		paramMap.put("searchword", scri.getKeyword());
		paramMap.put("subcategory_srl", scri.getSubcategory_srl());
		paramMap.put("category_srl", scri.getCategory_srl());
		paramMap.put("board_type", scri.getBoard_type());

		//return sqlSession.insert(wordCloudMapper + ".insertWordCloud", paramMap);
		return sqlSession.insert(wordCloudMapper + ".mergeWordCloud", paramMap);
		
	}

	@Override
	public int getTotalServiceCount(SearchServiceBoardCriteria scri) {
		return sqlSession.selectOne(searchMapper + ".getTotalServiceCount", scri);
	}

	@Override
	public int writeBoard(BoardVO vo) {
		return sqlSession.insert(searchMapper + ".writeBoard", vo);
	}

	@Override
	public int deleteBoard(Integer board_srl) {
		return sqlSession.delete(searchMapper + ".deleteBoard", board_srl);
	}

	@Override
	public int modifyBoard(BoardVO vo) {
		return sqlSession.update(searchMapper + ".modifyBoard", vo);
	}

	@Override
	public BoardVO readBoard(Integer board_srl) {
		return sqlSession.selectOne(searchMapper + ".readBoard", board_srl);
	}

	@Override
	public void visitCount(Integer boardSrl) {
		sqlSession.update(searchMapper + ".visitCount", boardSrl);
	}

}
