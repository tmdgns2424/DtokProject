package com.psnm.dtok.com.share.biz;

import java.util.Map;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;

import com.psnm.common.file.FileResourceManager;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: FFILE</li>
 * <li>설  명 : 공통 첨부파일 정보처리 기능 클래스</li>
 * <li>작성일 : 2014-11-12 20:23:56</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class FFILE extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FFILE(){
		super();
	}

	/**
	 * 첨부파일정보 조회
	 *
	 * @author admin (admin)
	 * @since 2014-11-12 20:28:22
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchFile(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<첨부파일조회> 입력파라미터 정보 ----\n" + requestData);
		}

	    try {
	    	DFILE du = (DFILE) lookupDataUnit(DFILE.class);
		    IRecordSet fileList = du.dSearchFile(requestData, onlineCtx).getRecordSet("ds");
		    responseData.putRecordSet("ds", fileList);

		    responseData.setOkResultMessage("PSNM-I000", null);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 첨부파일정보(DSM_ATCH_FILE)와 첨부파일매핑정보(DSM_ATCH_FILE_MGMT)를 저장(등록 or 삭제)함
	 이 함수는 데이터셋의 필드맵(단건)을 참조하여 처리함
	 *
	 * @author admin (admin)
	 * @since 2014-11-12 20:23:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveFile(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Map<String, Object> param = requestData.getFieldMap();
	    Log log = getLog(onlineCtx);

		try {
			DFILE     du  = (DFILE) lookupDataUnit(DFILE.class);
			DFILEMGMT du2 = (DFILEMGMT) lookupDataUnit(DFILEMGMT.class); //첨부파일매핑정보처리
			//DFILEMAP du2 = (DFILEMAP) lookupDataUnit(DFILEMAP.class); //첨부파일매핑정보처리

			if ( log.isDebugEnabled()) {
				log.debug("<첨부파일저장> <단건> 입력파라미터 정보 : " + param);
			}

			IDataSet paramData = new DataSet();
			paramData.putFieldMap( param );

			String flag = requestData.getField("FLAG"); //_flag
			String fileGrpId = requestData.getField("FILE_GRP_ID"); //파일그룹ID=업무구분

			if ( StringUtils.isBlank(fileGrpId) ) {
				throw new BizRuntimeException("PSNM-E011", new String[]{"업무구분"}); //{0} 데이터가 없습니다!
			}

			//1. 첨부관리ID(ATCH_MGMT_ID)가 없으면, 컨텐츠ID를 첨부관리ID로 설정함.
			String atchMgmtId = paramData.getField("ATCH_MGMT_ID"); 

	    	if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		atchMgmtId = this.getAtchMgmtId(paramData);

	    		//첨부관리ID(ATCH_MGMT_ID) 값을 설정함
	    		paramData.putField("ATCH_MGMT_ID", atchMgmtId);
	    		log.info("<첨부파일등록> 첨부관리ID(ATCH_MGMT_ID) 설정 : " + atchMgmtId);
	    	}
	    	if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		throw new BizRuntimeException("PSNM-E001", new String[]{"(원인) 컨텐츠ID 없음!"}); //"처리중 오류가 발생하였습니다! {0}"
	    	}

			if ( StringUtils.equals(flag, "I") ) { //등록
				du.dInsertFile(paramData, onlineCtx); //첨부파일 정보 등록
				//du2.dInsertFileMapByType(paramData, onlineCtx); //첨부파일매핑 정보 등록
				du2.dInsertFileMgmt(paramData, onlineCtx); //첨부파일매핑 정보 등록
			}
			else if ( StringUtils.equals(flag, "D") ) { //삭제
				String fileId = paramData.getField("ATCH_FILE_ID");
				String groupId = paramData.getField("FILE_GRP_ID"); //== applCd
				String svrDir  = paramData.getField("FILE_PATH");
				boolean isDel = FileResourceManager.removeUploadFile(fileId, groupId, svrDir);
				if ( log.isDebugEnabled()) {
					log.debug("<첨부파일저장> <단건> DISK 파일삭제결과 : " + isDel);
				}

				du.dDeleteFile(paramData, onlineCtx); //첨부파일 정보 삭제
				du2.dDeleteFileMgmt(paramData, onlineCtx);
				//du2.dDeleteFileMapByType(paramData, onlineCtx); //첨부파일 매핑정보 삭제
				//첨부파일매핑삭제시 '컨텐츠ID' 즉, 각 매핑테이블의 PK1은 필수조건임. (예) ANNCE_ID, BIZ_ID, BLTCONT_ID, DSM_CONT_ID 등 
			}

			responseData.setOkResultMessage("PSNM-I000", null);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * 첨부파일정보(DSM_ATCH_FILE)와 첨부파일매핑정보(DSM_ATCH_FILE_MGMT)를 저장(등록 or 삭제)함
	 이 함수는 레코드셋(recordSets)에서 키=[fileList] 인 목록을 참조하여 처리함
	 *
	 * @author admin (admin)
	 * @since 2014-11-12 20:23:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSaveFileList(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled()) {
			log.debug("<첨부파일등록> 입력파라미터(fields) : " + requestData.getFieldMap());
		}

		try {
			DFILE     du  = (DFILE) lookupDataUnit(DFILE.class);
			DFILEMGMT du2 = (DFILEMGMT) lookupDataUnit(DFILEMGMT.class); //첨부파일매핑정보처리

			IRecordSet rs = requestData.getRecordSet("gridfile"); //첨부파일 정보목록
			if (rs == null) {
				String keyName = requestData.getField("KEY_FILE_LIST");
				rs = requestData.getRecordSet(keyName);
			}
			log.debug("<첨부파일등록> 입력파라미터(recordSets.fileList)\n" + rs);

			//1. 첨부관리ID(ATCH_MGMT_ID)가 없으면, 컨텐츠ID를 첨부관리ID로 설정함.
			String atchMgmtId = requestData.getField("ATCH_MGMT_ID"); 

	    	if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		atchMgmtId = this.getAtchMgmtId(requestData);

	    		//첨부관리ID(ATCH_MGMT_ID) 값을 설정함
	    		requestData.putField("ATCH_MGMT_ID", atchMgmtId);
	    		log.info("<첨부파일등록> 첨부관리ID(ATCH_MGMT_ID) 설정 : " + atchMgmtId);
	    	}
	    	if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		throw new BizRuntimeException("PSNM-E001", new String[]{"(원인) 컨텐츠ID 없음!"}); //"처리중 오류가 발생하였습니다! {0}"
	    	}

	    	//2. 업무구분(FILE_GRP_ID)가 없으면, 첨부관리ID의 앞 3자리를 업무구분(FILE_GRP_ID)으로 설정
			String fileGrpId = requestData.getField("FILE_GRP_ID");

			if ( null==fileGrpId || StringUtils.isBlank(fileGrpId) ) {
				fileGrpId = atchMgmtId.substring(0, 3);
	    		requestData.putField("FILE_GRP_ID", fileGrpId); //업무구분(FILE_GRP_ID) 값을 설정함
	    		log.info("<첨부파일등록> 업무구분(FILE_GRP_ID) 설정 : " + fileGrpId);
	    	}

			int fileLen = rs.getRecordCount() ;

			//3. 첨부파일 등록|삭제 처리
			for(int i=0; i<fileLen; i++) {
				IDataSet paramData = new DataSet();

				paramData.putFieldMap( rs.getRecordMap(i) );
				paramData.putFieldMap( requestData.getFieldMap() ); //컨텐츠ID + 첨부관리ID 있음!
				
				log.debug("<첨부파일등록> 파일[" + i + "] " + paramData.getFieldMap());

				String flag = paramData.getField("FLAG"); //_flag

				if ( StringUtils.equals(flag, "I") ) {
					paramData.putField("FILE_GRP_ID", fileGrpId); //첨부파일 테이블에 등록

					du.dInsertFile(paramData, onlineCtx); //첨부파일 정보 등록
					du2.dInsertFileMgmt(paramData, onlineCtx); //첨부파일매핑 정보 등록
				}
				else if ( StringUtils.equals(flag, "D") ) {
					//파일서버에서 삭제하는 부분, 실 서버 적용시 테스트
					//removeUploadFile(String uploadFileId, String applCd, String relativeDir)
					String filePath = requestData.getField("FILE_PATH");

					boolean isDel = FileResourceManager.removeUploadFile(paramData.getField("ATCH_FILE_ID"), fileGrpId, filePath);
					if (!isDel) {
						log.warn("<파일삭제오류> " + paramData);
					}
					du2.dDeleteFileMgmt(paramData, onlineCtx); //첨부파일 매핑정보 삭제 @2015-01-14
					du.dDeleteFile(paramData, onlineCtx); //첨부파일 정보 삭제
				}
			}
			responseData.setOkResultMessage("PSNM-I000", null);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

	    return responseData;
	}




	/**
	 * 필드맴에서 컨텐츠ID값을 조회하여 반환.
	 * (주의) 여러개의 컨텐츠ID가 있다면 영문사전상 가장뒤의 컨텐츠ID가 선택됨
	 * 
	 * @param requestData
	 * @return
	 */
	private String getAtchMgmtId(IDataSet requestData) {
		String atchMgmtId = null;

		if ( requestData.containsField("AGENT_EDUT_MGMT_NUM") ) atchMgmtId = requestData.getField("AGENT_EDUT_MGMT_NUM"); //DSM_AGENT_EDU
		if ( requestData.containsField("ANNCE_ID") ) atchMgmtId = requestData.getField("ANNCE_ID"); //DSM_ANNCE
		if ( requestData.containsField("DSM_CONT_ID") ) atchMgmtId = requestData.getField("DSM_CONT_ID"); //
		if ( requestData.containsField("BIZ_ID") ) atchMgmtId = requestData.getField("BIZ_ID"); //DSM_BIZTRGT
		if ( requestData.containsField("BLTCONT_ID") ) atchMgmtId = requestData.getField("BLTCONT_ID"); //DSM_BLTCONT, DSM_P2P_CNSL
		if ( requestData.containsField("FAQ_ID") ) atchMgmtId = requestData.getField("FAQ_ID"); //DSM_FAQ
		if ( requestData.containsField("ISS_ID") ) atchMgmtId = requestData.getField("ISS_ID"); //DSM_ISSUE
		if ( requestData.containsField("PAPER_ID") ) atchMgmtId = requestData.getField("PAPER_ID"); //DSM_RCV_PAPER, DSM_SND_PAPER
		if ( requestData.containsField("DSM_SALES_PLCY_ID") ) atchMgmtId = requestData.getField("DSM_SALES_PLCY_ID"); //DSM_SALES_PLCY
		if ( requestData.containsField("SCH_ID") ) atchMgmtId = requestData.getField("SCH_ID"); //DSM_SCHMGMT
		if ( requestData.containsField("EXCEL_MGMT_NUM") ) atchMgmtId = requestData.getField("EXCEL_MGMT_NUM"); //EXCEL_MGMT_NUM
		if ( requestData.containsField("UNLAW_MGMT_NUM") ) atchMgmtId = requestData.getField("UNLAW_MGMT_NUM"); //EXCEL_MGMT_NUM

		return atchMgmtId;
	}
	
	
	
	/**
	 * 해당 컨텐츠ID(예, 공지사항ID, FAQ ID등)로 해당 게시글의 첨부파일목록을 조회하여 반환
	 (참고) 첨부파일의 업무구분ID(FILE_GRP_ID)가 파라미터로 전달되며, 없으면 디폴트 DSM (DSM_ATCH_FILE_MGMT) 참조함.
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-12 20:23:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchFileMapping(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<첨부파일매핑조회> 입력파라미터 정보 : " + requestData.getFieldMap());
		}

	    try {
	    	//DFILEMAP du = (DFILEMAP) lookupDataUnit(DFILEMAP.class);
	    	//IRecordSet fileList = du.dSearchFileMapByType(requestData, onlineCtx).getRecordSet("ds"); //DU 참조
		    //responseData.putRecordSet("ds", fileList);
	    	DFILEMGMT du = (DFILEMGMT) lookupDataUnit(DFILEMGMT.class);

	    	String atchMgmtId = requestData.getField("ATCH_MGMT_ID"); 

	    	if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		atchMgmtId = this.getAtchMgmtId(requestData);

	    		//첨부관리ID(ATCH_MGMT_ID) 값을 설정함
	    		requestData.putField("ATCH_MGMT_ID", atchMgmtId);
	    		log.info("<첨부파일매핑조회> 첨부관리ID(ATCH_MGMT_ID) 설정 : " + atchMgmtId);
	    	}

	    	if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		throw new BizRuntimeException("PSNM-E001", new String[]{"(원인) 컨텐츠ID 없음!"}); //"처리중 오류가 발생하였습니다! {0}"
	    	}

	    	responseData = du.dSearchFileMgmt(requestData, onlineCtx); //레코드셋 "ds"
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * 첨부파일ID와 각 업무별 컨텐츠의 매핑정보를 등록
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-12 20:23:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertFileMapping(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<첨부파일매핑등록> 입력파라미터 정보 :: " + requestData.getFieldMap());
		}

	    try {
	    	//DFILEMAP du2 = (DFILEMAP) lookupDataUnit(DFILEMAP.class);
	    	//responseData = du2.dInsertFileMapByType(requestData, onlineCtx); //@since 2014-12-15
	    	DFILEMGMT du = (DFILEMGMT) lookupDataUnit(DFILEMGMT.class);
	    	
	    	String atchMgmtId = requestData.getField("ATCH_MGMT_ID"); 

	    	if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		atchMgmtId = this.getAtchMgmtId(requestData);

	    		//첨부관리ID(ATCH_MGMT_ID) 값을 설정함
	    		requestData.putField("ATCH_MGMT_ID", atchMgmtId);
	    		log.info("<첨부파일매핑조회> 첨부관리ID(ATCH_MGMT_ID) 설정 : " + atchMgmtId);
	    	}

	    	if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		throw new BizRuntimeException("PSNM-E001", new String[]{"(원인) 컨텐츠ID 없음!"}); //"처리중 오류가 발생하였습니다! {0}"
	    	}

	    	responseData = du.dInsertFileMgmt(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 * 첨부파일매핑삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-09 11:37:25
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteFileMapping(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();
		Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled() ) {
			log.debug("<첨부파일매핑삭제> 입력파라미터 정보 :: " + requestData.getFieldMap());
		}

	    try {
	    	//DFILEMAP du2 = (DFILEMAP) lookupDataUnit(DFILEMAP.class);
	    	//responseData = du2.dDeleteFileMapByType(requestData, onlineCtx); //@since 2014-12-15
	    	DFILEMGMT du = (DFILEMGMT) lookupDataUnit(DFILEMGMT.class);

	    	String atchMgmtId = requestData.getField("ATCH_MGMT_ID"); 

	    	if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		atchMgmtId = this.getAtchMgmtId(requestData);

	    		//첨부관리ID(ATCH_MGMT_ID) 값을 설정함
	    		requestData.putField("ATCH_MGMT_ID", atchMgmtId);
	    		log.info("<첨부파일매핑조회> 첨부관리ID(ATCH_MGMT_ID) 설정 : " + atchMgmtId);
	    	}

	    	if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		throw new BizRuntimeException("PSNM-E001", new String[]{"(원인) 컨텐츠ID 없음!"}); //"처리중 오류가 발생하였습니다! {0}"
	    	}

	    	responseData = du.dDeleteFileMgmt(requestData, onlineCtx);
		}
	    catch (BizRuntimeException be) {
			throw be;
		}
	    catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    responseData.setOkResultMessage("PSNM-I000", null);
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2015-01-20 17:05:10
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSavePictuerFile(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 

	    Log log = getLog(onlineCtx);

		if ( log.isDebugEnabled()) {
			log.debug("<첨부파일등록> 입력파라미터(fields) : " + requestData.getFieldMap());
		}

		try {
			DFILE     du  = (DFILE) lookupDataUnit(DFILE.class);

			String fileGrpId = nexcore.framework.core.util.StringUtils.nvl( requestData.getField("FILE_GRP_ID"), "PIC");
			
			requestData.putField("FILE_GRP_ID", fileGrpId);
			
			du.dInsertFile(requestData, onlineCtx); //첨부파일 정보 등록
				
			responseData.setOkResultMessage("PSNM-I000", null);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}

	    return responseData;
	}

	/**
	 * [FM]첨부파일삭제(매핑ID조건) - 첨부파일과 첨부파일매핑 정보 삭제
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-12 20:23:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteFileByMgmtId(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled()) {
			log.debug("<첨부파일삭제(매핑ID조건)> <단건> 입력파라미터 정보 : " + requestData.getFieldMap());
		}

	    try {
			DFILE     duFile     = (DFILE) lookupDataUnit(DFILE.class);
			DFILEMGMT duFIleMgmt = (DFILEMGMT) lookupDataUnit(DFILEMGMT.class);

			String atchMgmtId = requestData.getField("ATCH_MGMT_ID"); //첨부관리ID
		
			if ( null==atchMgmtId || StringUtils.isBlank(atchMgmtId) ) {
	    		throw new BizRuntimeException("PSNM-E001", new String[]{"(원인) 첨부관리ID 없음!"}); //"처리중 오류가 발생하였습니다! {0}"
	    	}

			IRecordSet filemgmt = duFIleMgmt.dSearchFileMgmt(requestData, onlineCtx).getRecordSet("ds"); //레코드셋 "ds"
			int fileLen = filemgmt.getRecordCount() ;

			//첨부파일삭제 처리
			for(int i=0; i<fileLen; i++) {
				Map<String, Object> fileinfo = filemgmt.getRecordMap(i);

				IDataSet paramData = new DataSet();
				paramData.putFieldMap(fileinfo); //첨부관리ID 포함

				String fileId  = paramData.getField("ATCH_FILE_ID");
				String groupId = paramData.getField("FILE_GRP_ID");
				String svrDir  = paramData.getField("FILE_PATH");

				boolean isDel = FileResourceManager.removeUploadFile(fileId, groupId, svrDir);
				if ( log.isDebugEnabled()) {
					log.debug("<첨부파일삭제(매핑ID조건)> <단건> DISK 파일삭제결과 : " + isDel);
				}

				duFile.dDeleteFile(paramData, onlineCtx); //첨부파일 정보 삭제
				duFIleMgmt.dDeleteFileMgmt(paramData, onlineCtx); //첨부파일매핑 정보 삭제
			}


			responseData.setOkResultMessage("PSNM-I000", null);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 *
	 *
	 * @author 안진갑 (ahnjingap)
	 * @since 2014-11-12 20:23:56
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fDeleteFileByFileId(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    // 처리 결과값을 responseData에 넣어서 리턴하십시요 

	    Log log = getLog(onlineCtx);
		if ( log.isDebugEnabled()) {
			log.debug("<첨부파일삭제(파일ID조건)> <단건> 입력파라미터 정보 : " + requestData.getFieldMap());
		}

	    try {
			DFILE     duFile     = (DFILE) lookupDataUnit(DFILE.class);

			String atchFileId = requestData.getField("ATCH_FILE_ID"); //첨부관리ID
		
			if ( null==atchFileId || StringUtils.isBlank(atchFileId) ) {
	    		throw new BizRuntimeException("PSNM-E001", new String[]{"(원인) 첨부파일ID 없음!"}); //"처리중 오류가 발생하였습니다! {0}"
	    	}


			//첨부파일삭제 처리
			String fileId  = requestData.getField("ATCH_FILE_ID");
			String groupId = requestData.getField("FILE_GRP_ID");
			String svrDir  = requestData.getField("FILE_PATH");

			boolean isDel = FileResourceManager.removeUploadFile(fileId, groupId, svrDir);
			if ( log.isDebugEnabled()) {
				log.debug("<첨부파일삭제(파일ID조건)> <단건> DISK 파일삭제결과 : " + isDel);
			}

			duFile.dDeleteFile(requestData, onlineCtx); //첨부파일 정보 삭제

			responseData.setOkResultMessage("PSNM-I000", null);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	    return responseData;
	}

}
