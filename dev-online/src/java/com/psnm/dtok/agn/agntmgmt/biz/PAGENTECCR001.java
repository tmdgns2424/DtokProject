package com.psnm.dtok.agn.agntmgmt.biz;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.exception.BizRuntimeException;
import nexcore.framework.core.util.StringUtils;

import com.psnm.common.util.CryptoUtils;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/에이전트</li>
 * <li>단위업무명: PAGENTECCR001</li>
 * <li>설  명 : MA지원상담조회 PU</li>
 * <li>작성일 : 2014-11-19 16:30:21</li>
 * <li>작성자 : 한상곤 (hansanggon)</li>
 * </ul>
 *
 * @author 한상곤 (hansanggon)
 */
public class PAGENTECCR001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PAGENTECCR001(){
		super();
	}

	/**
	 * MA지원상담 조회 PM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-19 16:30:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try {			
	    	
	    	FAGENTECCR001 fu = (FAGENTECCR001)lookupFunctionUnit(FAGENTECCR001.class);
	    	
	    	//비밀번호 암호화
	    	if( !StringUtils.isEmpty(requestData.getField("SCRT_NUM")) ) {
	    		requestData.putField("SCRT_NUM", CryptoUtils.digestSHA256(requestData.getField("SCRT_NUM")));	
	    	}
	    	
	    	responseData = fu.fSearchAgentEccr(requestData, onlineCtx);
	    	
	    	responseData.getRecordSet("grid").setPageNo(requestData.getIntField("page"));
	    	responseData.getRecordSet("grid").setRecordCountPerPage(requestData.getIntField("page_size"));
	    	responseData.getRecordSet("grid").setTotalRecordCount(responseData.getIntField("count"));
	    	
			responseData.setOkResultMessage("PSNM-I000", null);			
			
		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
 
	    return responseData;
	}

	/**
	 * MA지원상담 상세조회 PM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-24 09:26:46
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDetailAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try{
	    	
	    	FAGENTECCR001 fu = (FAGENTECCR001)lookupFunctionUnit(FAGENTECCR001.class);
	    	
	    	responseData = fu.fDetailAgentEccr(requestData, onlineCtx);
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null); 
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
 
	    return responseData;
	}

	/**
	 * MA지원상담 상담국배정및상태수정 PM
	 *
	 * @author 한상곤 (hansanggon)
	 * @since 2014-11-19 16:30:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSaveAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

		String userId = onlineCtx.getUserInfo().getLoginId();
		requestData.putField("USER_ID", userId);

	    try{
	    	
	    	FAGENTECCR001 fu = (FAGENTECCR001)lookupFunctionUnit(FAGENTECCR001.class);
	    	
	    	//저장버튼을 클릭, 상담종료(적합)일 경우와 에이전트 매핑정보를 저장.
	    	if( "04".equals( requestData.getField("APL_ST_CD")) && StringUtils.isNotEmpty(requestData.getField("AGNT_ID"))) {
	    		
	    		responseData = fu.fUpdateAgentEccrAgentId(requestData, onlineCtx);
	    		
	    	}else{
	    		
	    		responseData = fu.fUpdateAgentEccr(requestData, onlineCtx);
	    		
	    		//SMS발송
				//처리상태가 영업국배정이라면 sms를 발송한다.
				if( "02".equals( requestData.getField("APL_ST_CD")) ) {
					
					//1. 지원자
					requestData.putField("SMS_CHK", "1");
					IDataSet requestSms1 = fu.fSelectAgentEccrSmsSend(requestData, onlineCtx);
					requestSms1.putField("TRAN_MENU_ID", "1306");
					requestSms1.putField("TRAN_TYP_CD", "01");
					requestSms1.putField("TRAN_SYS", "BO");
					callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms1, onlineCtx);
					
					//2.국장
					requestData.putField("SMS_CHK", "2");
					IDataSet requestSms2 = fu.fSelectAgentEccrSmsSend(requestData, onlineCtx);
					requestSms2.putField("TRAN_MENU_ID", "1306");
					requestSms2.putField("TRAN_TYP_CD", "02");
					requestSms2.putField("TRAN_SYS", "BO");
					requestSms2.putField("SND_SEQ", 2);		
					callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms2, onlineCtx);
				}
				//상담종료(적합) sms를 발송한다.
				else if( "04".equals( requestData.getField("APL_ST_CD"))) {
					
					//1. SMS발송 : 지원자
		    		requestData.putField("SMS_CHK", "3");
					IDataSet requestSms1 = fu.fSelectAgentEccrSmsSend(requestData, onlineCtx);
					requestSms1.putField("TRAN_MENU_ID", "1306");
					requestSms1.putField("TRAN_TYP_CD", "04");	
					requestSms1.putField("TRAN_SYS", "BO");
					callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms1, onlineCtx);
					
					//2.SMS발송 : 국장
					requestData.putField("SMS_CHK", "2");
					IDataSet requestSms2 = fu.fSelectAgentEccrSmsSend(requestData, onlineCtx);
					requestSms2.putField("TRAN_MENU_ID", "1306");
					requestSms2.putField("TRAN_TYP_CD", "04");
					requestSms2.putField("TRAN_SYS", "BO");
					requestSms2.putField("SND_SEQ", 2);		
					callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms2, onlineCtx);
					
				}
				//상담종료(부적합) sms를 발송한다.
				else if( "05".equals( requestData.getField("APL_ST_CD"))) {
					
					//1. 지원자
					requestData.putField("SMS_CHK", "1");
					IDataSet requestSms1 = fu.fSelectAgentEccrSmsSend(requestData, onlineCtx);
					requestSms1.putField("TRAN_MENU_ID", "1306");
					requestSms1.putField("TRAN_TYP_CD", "03");
					requestSms1.putField("TRAN_SYS", "BO");
					callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms1, onlineCtx);
				}

	    	}
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
 
	    return responseData;
	}

	/**
	 * MA지원상담 저장 PM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2014-11-19 16:30:21
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pMergeAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	    
	    try{
	    	
	    	FAGENTECCR001 fu = (FAGENTECCR001)lookupFunctionUnit(FAGENTECCR001.class);
	    	//익명 사용자로 셋팅(9999999999)
	    	//requestData.putField("USER_ID", BaseUtils.getConfiguration("trms.anonymous.user"));
	    	requestData.putField("USER_ID", "9999999999");
	    	
	    	//비밀번호 암호화
	    	requestData.putField("SCRT_NUM", CryptoUtils.digestSHA256(requestData.getField("SCRT_NUM")));
	    	
	    	//시퀀스번호 취득
	    	if( StringUtils.isEmpty(requestData.getField("APLCNSL_MGMT_NUM")) ) {
	    		requestData.putField("KEY_NAME", "MAB");
	    		requestData.putField("APLCNSL_MGMT_NUM", fu.fSelectAgentEccrNoSeq(requestData, onlineCtx).getField("APLCNSL_MGMT_NUM"));
	    		
	    		//SMS전송:SMS관리에서 지정된 메시지 구분이 MA지원상담요청의 임직원
	    		requestData.putField("SMS_CHK", "4");
	    		IDataSet requestSms = fu.fSelectAgentEccrSmsSend(requestData, onlineCtx);	    		
	    		requestSms.putField("TRAN_MENU_ID", "1605");
				requestSms.putField("TRAN_TYP_CD", "44");
				requestSms.putField("TRAN_SYS", "BO");
	    		callSharedBizComponentByDirect("com.SHARE", "fSendSms", requestSms, onlineCtx);
	    	}
	    	
	    	responseData = fu.fMergeAgentEccr(requestData, onlineCtx);
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * MA지원상담 삭제 PM
	 *
	 * @author 김보선 (kimbosun)
	 * @since 2015-02-23 18:32:30
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pDeleteAgentEccr(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();
	
	    try{
	    	
	    	FAGENTECCR001 fu = (FAGENTECCR001)lookupFunctionUnit(FAGENTECCR001.class);
	    	
	    	fu.fDeleteAgentEccr(requestData, onlineCtx);
	    	
	    	responseData.setOkResultMessage("PSNM-I000", null);
	    	
	    } catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}
  
}
