package com.psnm.dtok.brd.brdbannce.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.user.IUserInfo;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.coreext.pojo.biz.SharedBizComponent;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import com.psnm.common.util.PsnmStringUtil;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/게시판</li>
 * <li>단위업무명: PBRD0001</li>
 * <li>설  명 : 공지사항</li>
 * <li>작성일 : 2014-11-05 11:36:47</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class PBRD0001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PBRD0001(){
		super();
	}

	/**
	 * 공지사항 목록조회(페이징처리)
	 *
	 * @author admin (admin)
	 * @since 2014-11-05 11:41:13
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pBRD01001(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if (log.isDebugEnabled()) {
			log.debug("<공지사항 목록조회> 입력데이터 : " + requestData.toString());
		}

		try {
			UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
			if (log.isDebugEnabled()) {
				log.debug("<공지사항 목록조회> 세션사용자정보 : " + userInfo);
				log.debug("<공지사항 목록조회> 세션사용자ID : " + userInfo.getLoginId()); //로그인ID는 직접 참조
				log.debug("<공지사항 목록조회> 세션사용자성명 : " + userInfo.get("USER_NM")); //USER_NM=DSM운영자
				//다음음 세션정보 예로 userInfo.get("USER_NM") 형태로 참조함
			}
			

			DDSM_ANNCE du = (DDSM_ANNCE) lookupDataUnit(DDSM_ANNCE.class);

			IRecordSet rs = du.dDSM_ANNCE_S001(requestData, onlineCtx).getRecordSet("ds");
			responseData.putRecordSet("grid", rs); //[alopex] 그리드 데이터는 dataSet.recordSets 하위에 그리드 아이디를 키로 위치

			rs.setPageNo(requestData.getIntField("page")); // page는 클라이언트에서 넘기는 것을 그대로 리턴하면 됩니다.
			rs.setRecordCountPerPage(requestData.getIntField("page_size"));

			IRecordSet rs2 = du.dDSM_ANNCE_S002(requestData, onlineCtx).getRecordSet("ds");
			rs.setTotalRecordCount(rs2.getRecord(0).getInt("ANNCE_CNT"));

			log.debug("<공지사항 목록조회> 검색조건의 전체건수 = " + rs2.getRecord(0).getInt("ANNCE_CNT"));

			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
		responseData.setOkResultMessage("PSNM-I000", null);
	
	    return responseData;
	}

	/**
	 * 공지사항 1건조회
	 *
	 * @author admin (admin)
	 * @since 2014-11-05 11:36:47
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
	    if (log.isDebugEnabled()) {
			log.debug("<공지사항 1건조회> 입력데이터 : " + requestData.toString());
		}

		try {
			DDSM_ANNCE du = (DDSM_ANNCE) lookupDataUnit(DDSM_ANNCE.class);

			Map rs1 = du.dSearchAnnce(requestData, onlineCtx).getFieldMap();

			IDataSet fileData = new DataSet();
			fileData.putField("FILE_GRP_ID", "ANN"); //(공유공통) 업무구분=ANN. 첨부파밍매핑정보를 조회함
			fileData.putField("ANNCE_ID", rs1.get("ANNCE_ID")); //ANNCE_ID 필수

			IDataSet ds2 = callSharedBizComponentByDirect("com.SHARE", "fSearchFileMapping", fileData, onlineCtx);
			IRecordSet rs2 = ds2.getRecordSet("ds");

			//du결과값을 레코드셋으로 입력
			responseData.putFieldMap(rs1);
			responseData.putRecordSet("gridfile", rs2); //화면의 alopex grid의 ID와 동일하도록 키명을 설정함.

			responseData.setOkResultMessage("PSNM-I000", null);
			log.debug("<공지사항 1건조회> 공지사항 제목 : [" + rs1.get("ANNCE_TITL_NM") + "] 첨부파일개수 = " + rs2.getRecordCount());
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    return responseData;
	}

	/**
	 * 공지사항 저장(등록|수정)
	 *
	 * @author admin (admin)
	 * @since 2014-11-11 10:09:41
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveAnnce(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled() ) {
			log.debug("\n\n\n\n<공지사항저장> requestData ------\n" + requestData);
		}
		
		IUserInfo iUserInfo = onlineCtx.getUserInfo();

		try {
			DDSM_ANNCE du = (DDSM_ANNCE) lookupDataUnit(DDSM_ANNCE.class);

			String sesstionUserId = iUserInfo.getLoginId(); //StarStringUtil.isNullToString(((StarUserInfo)onlineCtx.getUserInfo()).getCustomProp("loginId").toString());

			requestData.putField("USER_ID", sesstionUserId);
			String annceId = requestData.getField("ANNCE_ID");
			//String MESSAGE = "";

			if ( StringUtils.isBlank(annceId) ) {
				IDataSet dsSeq = du.dSearchAnnceIdSeq(requestData, onlineCtx);
				IRecordSet rsSeq = dsSeq.getRecordSet("ds");
				Map map = rsSeq.getRecordMap(0);
				annceId = PsnmStringUtil.isNullToString(map.get("ANNCE_ID"));
				log.debug("<공지사항저장> <등록> 채번된 ANNCE_ID = " + annceId);

				requestData.putField("ANNCE_ID", annceId);

				//1.1 공지사항 등록
				du.dInsertAnnce(requestData, onlineCtx);
			}
			else {
				log.debug("<공지사항저장> <수정> ANNCE_ID : " + annceId);
				requestData.putField("UPDR_ID", sesstionUserId); //수정자ID

				//1.2 공지사항 수정
				du.dUpdateAnnce(requestData, onlineCtx);
			}

			IRecordSet fileList = requestData.getRecordSet("gridfile");
			int fileListCount = null==fileList ? 0 : fileList.getRecordCount();

			//2. 첨부파일 저장
			for(int i=0; i<fileListCount; i++) {
				IDataSet fileData = new DataSet();
				fileData.putFieldMap( fileList.getRecordMap(i) );
				fileData.putField("ANNCE_ID", annceId);
				fileData.putField("USER_ID",  sesstionUserId);

				log.debug("<공지사항 첨부파일> 저장할 첨부파일 정보 : " + fileData.getFieldMap());

				String flag = fileData.getField("FLAG");

				//첨부파일 정보를 저장(등록 | 삭제) : 공유컴포넌트 호출
				IDataSet resultData = callSharedBizComponentByDirect("com.SHARE", "fSaveFile", fileData, onlineCtx);

				//공지사항은 첨부파일-공지사항 매핑정보가 따로 있음. 추가적으로 매핑정보를 저장함.
				if ( StringUtils.equals(flag, "I") ) { //첨부파일 등록
					//du.dInsertAnnceAtchFile(fileData, onlineCtx); //첨부파일-공지사항 매핑정보 등록
					fileData.putField("FILE_GRP_ID", "ANNCE");
					callSharedBizComponentByDirect("com.SHARE", "fInsertFileMapping", fileData, onlineCtx);
				}
				else if ( StringUtils.equals(flag, "D") ) {
					//du.dDeleteAnnceAtchFile(fileData, onlineCtx); //첨부파일-공지사항 매핑정보 삭제
					fileData.putField("FILE_GRP_ID", "ANNCE");
					callSharedBizComponentByDirect("com.SHARE", "fDeleteFileMapping", fileData, onlineCtx);
				}
			}

			responseData.setOkResultMessage("PSNM-I000", null);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000",e);
		}
	    return responseData;
	}
  
}
