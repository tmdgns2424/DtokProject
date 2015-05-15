package com.psnm.dtok.com.mainlogin.biz;

import java.util.Iterator;
import java.util.Map.Entry;
import java.util.Set;

import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IOnlineContext;
import nexcore.framework.core.data.IRecordSet;
import nexcore.framework.core.data.IResultMessage;
import nexcore.framework.core.data.user.UserInfo;
import nexcore.framework.core.exception.BizRuntimeException;

import org.apache.commons.logging.Log;


/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>단위업무명: PLOGIN001</li>
 * <li>설  명 : 로그인 로그아웃 처리 PU</li>
 * <li>작성일 : 2014-11-19 15:09:04</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class PLOGIN001 extends nexcore.framework.coreext.pojo.biz.ProcessUnit {

	/**
	 * 이 클래스는 Singleton 객체로 수행됩니다. 
	 * 여기에 필드를 선언하여 사용하면 동시성 문제를 일으킬 수 있습니다.
	 */

	/**
	 * Default Constructor
	 */
	public PLOGIN001(){
		super();
	}

	/**
	 * 사용자ID로 사용자정보 조회하여 로그인 처리함 
	 *
	 * @author admin (admin)
	 * @since 2014-11-19 15:09:04
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchLogin(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
	    if (log.isDebugEnabled()) {
			log.debug("<로그인처리> 입력데이터 : " + requestData.toString());
		}

		try {
			FLOGIN001 fu = (FLOGIN001) lookupFunctionUnit(FLOGIN001.class);

			responseData = fu.fSearchLogin(requestData, onlineCtx);

			if (log.isDebugEnabled()) {
				log.debug("<로그인처리> 사용자정보 : " + responseData);
			}
		}
		catch (BizRuntimeException be) {
			//throw be; 
			//로그인시 실패건수 처리를 위해 성공처리함
			responseData.setResultMessage(IResultMessage.FAIL, "PSNM-E002", new String[] { be.getMessage() }, null);
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000"); //이때는 트랜잭션 ROLLBACK
		}
	    return responseData;
	}

	/**
	 * 로그아웃 처리
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-11-21 16:31:31
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pLogout(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
	    if (log.isDebugEnabled()) {
			log.debug("<로그아웃> 입력데이터 : " + requestData.getFieldMap());
		}

		try {
			FLOGIN001 fu = (FLOGIN001) lookupFunctionUnit(FLOGIN001.class);

			responseData = fu.fLogout(requestData, onlineCtx);

			if (log.isDebugEnabled()) {
				log.debug("<로그아웃> 사용자정보 : " + responseData);
			}
		}
		catch (BizRuntimeException be) {
			//throw be; 
			//로그인시 실패건수 처리를 위해 성공처리함
			responseData.setResultMessage(IResultMessage.FAIL, "PSNM-E002", new String[] { be.getMessage() }, null);
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000"); //이때는 트랜잭션 ROLLBACK
		}
	    return responseData;
	}

	/**
	 * 지정된 메뉴의 하위 메뉴 TREE 목록을 조회
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-01 11:25:32
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSearchMenuTree(IDataSet requestData, IOnlineContext onlineCtx) {
	    IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if (log.isDebugEnabled()) {
			log.debug("<하위메뉴TREE조회> 입력데이터 : " + requestData.toString());
		}

		try {
			UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
			if (log.isDebugEnabled()) {
				//log.debug("<하위메뉴TREE조회> 세션사용자정보 : " + userInfo);
				log.debug("<하위메뉴TREE조회> 세션사용자ID : " + userInfo.getLoginId()); //로그인ID는 직접 참조
				log.debug("<하위메뉴TREE조회> 세션사용자성명 : " + userInfo.get("USER_NM")); //USER_NM=DSM운영자
			}

			FLOGIN001 fu = (FLOGIN001) lookupFunctionUnit(FLOGIN001.class);

			IRecordSet rs = fu.fSearchMenuTree(requestData, onlineCtx).getRecordSet("ds");
			responseData.putRecordSet("gridmenu", rs); //[alopex] 그리드 데이터는 dataSet.recordSets 하위에 그리드 아이디를 키로 위치

			log.debug("<하위메뉴TREE조회> 조회된 메뉴건수 = " + rs.getRecordCount());

			responseData.setOkResultMessage("PSNM-I000", null);

		} catch (BizRuntimeException be) {
			throw be;
		} catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	
	    return responseData;
	}

	/**
	 * 현재 세션사용자정보를 반환
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-02 15:42:54
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pSessionUser(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = new DataSet();

	    Log log = getLog(onlineCtx);
		if (log.isDebugEnabled()) {
			log.debug("<하위메뉴TREE조회> 입력데이터 : " + requestData.toString());
		}

		try {
			UserInfo userInfo = (UserInfo)onlineCtx.getUserInfo();
			if (log.isDebugEnabled()) {
				log.debug("<세션정보반환> 세션사용자ID : " + userInfo.getLoginId()); //로그인ID는 직접 참조
				log.debug("<세션정보반환> 세션사용자성명 : " + userInfo.get("USER_NM")); //USER_NM=DSM운영자
			}

			Set<Entry<String,Object>> set = userInfo.entrySet();
			Iterator<Entry<String,Object>> iter = set.iterator();

			while ( iter.hasNext() ) {
				Entry<String,Object> ent = iter.next();

				responseData.putField(ent.getKey(), ent.getValue());
			}
			responseData.putField("USER_ID", userInfo.getLoginId());
			responseData.putField("USER_IP", userInfo.getIp());

			if (log.isDebugEnabled()) {
				log.debug("<세션정보반환> 세션사용자성명 : " + responseData.getFieldMap()); //USER_NM=DSM운영자
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
	 * 비밀번호변경
	 *
	 * @author 안종광 (rhkd)
	 * @since 2014-12-19 11:41:20
	 *
	 * @param requestData 요청정보 DataSet 객체
	 * @param onlineCtx   요청 컨텍스트 정보
	 * @return 처리결과 DataSet 객체
	 */
	public IDataSet pUpdatePwd(IDataSet requestData, IOnlineContext onlineCtx) {
		IDataSet responseData = null;
		try {
			FLOGIN001 fu = (FLOGIN001) lookupFunctionUnit(FLOGIN001.class);
			responseData = fu.fUpdatePwd(requestData, onlineCtx);
			responseData.setOkResultMessage("PSNM-I000", null);
		}
		catch (BizRuntimeException be) {
			throw be;
		}
		catch (Exception e) {
			throw new BizRuntimeException("PSNM-E000");
		}
	    return responseData;
	}
  
}
