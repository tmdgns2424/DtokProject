package com.psnm.dtok.biz.dfaxrcv.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/업무</li>
 * <li>단위업무명: FFAXRCV001</li>
 * <li>설  명 : D-FAX접수결과 FU</li>
 * <li>작성일 : 2014-12-24 16:09:14</li>
 * <li>작성자 : 이민재 (leeminjae)</li>
 * </ul>
 *
 * @author 이민재 (leeminjae)
 */
public class FFAXRCV001 extends nexcore.framework.coreext.pojo.biz.FunctionUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public FFAXRCV001(){
		super();
	}

	/**
	 * D-FAX접수결과 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2014-12-24 16:10:50
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchFaxRcv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DFAXRCV001 du = (DFAXRCV001) lookupDataUnit(DFAXRCV001.class);
	    	
	    	String DUTY = onlineCtx.getUserInfo().get("DUTY").toString();
			String ATTC_CAT = onlineCtx.getUserInfo().get("ATTC_CAT").toString();
	    	
	    	//MA인 경우 정보 자동 셋팅
			if( requestData.getField("HDQT_TEAM_ORG_ID") == null || 
				(ATTC_CAT.startsWith("4") 	&& !DUTY.equals("14")
											&& !DUTY.equals("16")	//팀장일 경우 팀 전체 보기
									   		&& !DUTY.equals("17")
								   			&& !DUTY.equals("19")
								   			&& !DUTY.equals("20")) ) {
				requestData.putField("HDQT_TEAM_ORG_ID", onlineCtx.getUserInfo().get("HDQT_TEAM_ORG_ID").toString());
				requestData.putField("AGNT_ID", onlineCtx.getUserInfo().get("CPLAZA_ORG_CD").toString());
			}
	    	
			responseData = du.dSearchFaxRcv(requestData, onlineCtx);
			responseData.putField("count", du.dSearchFaxRcvCount(requestData, onlineCtx).getIntField("count"));
			responseData.putFieldMap(du.dSearchFaxRcvTotalCount(requestData, onlineCtx).getFieldMap());
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}

	/**
	 * D-FAX접수업무승인 정보를 저장하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-02-27 15:57:12
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fInsertFaxRcvBizAprv(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
			
	    	DFAXRCV001 du = (DFAXRCV001) lookupDataUnit(DFAXRCV001.class);
			
	    	du.dUpdateFaxRcvTsal(requestData, onlineCtx);
			du.dInsertFaxRcvBizAprv(requestData, onlineCtx);
			du.dInsertFaxRcvBizAprvHst(requestData, onlineCtx);
			
			//첨부파일 저장
			if(requestData.getRecordSet("gridfile") != null){
				//첨부파일 정보를 저장(등록 | 삭제) : 공유컴포넌트 호출
				requestData.putField("ATCH_MGMT_ID", "DFAX"+requestData.getField("FAX_RCV_NO"));
				requestData.putField("FILE_GRP_ID", "FAX");
				callSharedBizComponentByDirect("com.SHARE", "fSaveFileList", requestData, onlineCtx);
			}
			
			if("02".equals(requestData.getField("BIZ_APRV_OP_ST_CD"))){ // 요청취소
				// 첨부파일 삭제
				requestData.putField("ATCH_MGMT_ID", "DFAX"+requestData.getField("FAX_RCV_NO"));
				requestData.putField("FILE_GRP_ID", "FAX");
				callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByMgmtId", requestData, onlineCtx);
			}
			
			if("R".equals(requestData.getField("BIZ_APRV_YN"))){ // 승인요청
				
				IDataSet _ds_sms = new DataSet();
				
				if("01".equals(requestData.getField("BIZ_APRV_REQ_CL_CD"))){ // MA -> 국장
					requestData.putField("BIZ_APRV_REQ_CL_NM", "MA");
					
					_ds_sms = du.dSearchFaxRcvReqSms01(requestData, onlineCtx);
					
				}else if("02".equals(requestData.getField("BIZ_APRV_REQ_CL_CD"))){ // 팀장 -> 국장,MA
					requestData.putField("BIZ_APRV_REQ_CL_NM", "팀장");
					
					_ds_sms = du.dSearchFaxRcvReqSms02(requestData, onlineCtx);
			    	
				}else{ // 국장 -> MA
					
					_ds_sms = du.dSearchFaxRcvReqSms03(requestData, onlineCtx);
				}
				
				_ds_sms.putField("TRAN_MENU_ID", "1708");
		    	_ds_sms.putField("TRAN_TYP_CD", "05"); // [D-tok] MA 업무 승인 요청(팀장代) : 1인2개통/ 서울1국 홍길동
		    	_ds_sms.putField("TRAN_SYS", "TKEY");

		    	callSharedBizComponentByDirect("com.SHARE", "fSendSms", _ds_sms, onlineCtx);
		    	
		    	IDataSet _ds_sms2 = du.dSearchFaxRcvReqSms(requestData, onlineCtx);
		    	_ds_sms2.putField("TRAN_MENU_ID", "1708");
		    	_ds_sms2.putField("TRAN_TYP_CD", "06"); // [D-tok] 관리자 승인 필요 업무유형 : 1인2개통
		    	_ds_sms2.putField("TRAN_SYS", "TKEY");

		    	callSharedBizComponentByDirect("com.SHARE", "fSendSms", _ds_sms2, onlineCtx);
				
			}else if("Y".equals(requestData.getField("BIZ_APRV_YN"))){ // 승인
				
				if("03".equals(requestData.getField("BIZ_APRV_OP_ST_CD"))){ // 국장승인
					
					requestData.putField("DUTY_CD", "4"); // 영업국 담당
					IDataSet _ds_sms = du.dSearchFaxRcvAppReqSms(requestData, onlineCtx);
					
					_ds_sms.putField("TRAN_MENU_ID", "1708");
			    	_ds_sms.putField("TRAN_TYP_CD", "00"); // [D-tok] 업무 승인 요청 : 1인2개통/ 서울1국 홍길동
			    	_ds_sms.putField("TRAN_SYS", "TKEY");

			    	callSharedBizComponentByDirect("com.SHARE", "fSendSms", _ds_sms, onlineCtx);
			    	
				}else if("05".equals(requestData.getField("BIZ_APRV_OP_ST_CD"))){ // 승인완료
				
					requestData.putField("DUTY_CD", "12"); // 개통실 담당
					IDataSet _ds_sms = du.dSearchFaxRcvAppSms(requestData, onlineCtx);
					
					_ds_sms.putField("TRAN_MENU_ID", "1708");
			    	_ds_sms.putField("TRAN_TYP_CD", "04"); // [D-tok] 업무 승인 완료 : 1인2개통/ 서울1국 홍길동
			    	_ds_sms.putField("TRAN_SYS", "TKEY");

			    	callSharedBizComponentByDirect("com.SHARE", "fSendSms", _ds_sms, onlineCtx);
					
				}
				
			}else{ // 반려
				
				// 첨부파일 삭제
				requestData.putField("ATCH_MGMT_ID", "DFAX"+requestData.getField("FAX_RCV_NO"));
				requestData.putField("FILE_GRP_ID", "FAX");
				callSharedBizComponentByDirect("com.SHARE", "fDeleteFileByMgmtId", requestData, onlineCtx);
				
				requestData.putField("DUTY_CD", "12"); // 개통실 담당
				IDataSet _ds_sms = du.dSearchFaxRcvReturnSms(requestData, onlineCtx);
				
				_ds_sms.putField("TRAN_MENU_ID", "1708");
		    	_ds_sms.putField("TRAN_TYP_CD", "07"); // [D-tok] 업무 승인 반려 : 1인2개통/ 서울1국 홍길동 사유 :
		    	_ds_sms.putField("TRAN_SYS", "TKEY");
		    	
		    	callSharedBizComponentByDirect("com.SHARE", "fSendSms", _ds_sms, onlineCtx);
				
			}
			
			responseData.setOkResultMessage("PSNM-I000", null);
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		} 
	
	    return responseData;
	}

	/**
	 * D-FAX접수결과조회모바일 정보를 조회하는 메소드
	 *
	 * @author 이민재 (leeminjae)
	 * @since 2015-03-09 14:29:29
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet fSearchFaxRcvMobile(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try {
	    	
	    	DFAXRCV001 du = (DFAXRCV001) lookupDataUnit(DFAXRCV001.class);
	    	
	    	String DUTY = onlineCtx.getUserInfo().get("DUTY").toString();
	    	
			if("14".equals(DUTY)){
				requestData.putField("HDQT_TEAM_ORG_ID", onlineCtx.getUserInfo().get("HDQT_TEAM_ORG_ID").toString());
				requestData.putField("HDQT_PART_ORG_ID", onlineCtx.getUserInfo().get("HDQT_PART_ORG_ID").toString());
				requestData.putField("SALE_DEPT_ORG_ID", onlineCtx.getUserInfo().get("SALE_DEPT_ORG_ID").toString());
				requestData.putField("BIZ_APRV_OP_ST_CD", "01");
			}else{
				requestData.putField("HDQT_TEAM_ORG_ID", onlineCtx.getUserInfo().get("HDQT_TEAM_ORG_ID").toString());
				requestData.putField("BIZ_APRV_OP_ST_CD", "03");
			}
	    	
			responseData = du.dSearchFaxRcvMobile(requestData, onlineCtx);
			
			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000", e);
		}
	
	    return responseData;
	}
  
}
