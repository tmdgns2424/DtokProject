package com.psnm.dtok.batch;

import java.math.BigDecimal;
import java.util.Map;

import nexcore.framework.bat.IBatchContext;

import org.apache.commons.logging.Log;

import nexcore.framework.bat.base.AbsBatchComponent;
import nexcore.framework.core.data.DataSet;
import nexcore.framework.core.data.IDataSet;
import nexcore.framework.core.data.IRecordSet;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/배치</li>
 * <li>서브 업무명 : CUSTPGVCOPSMS</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-04-16 11:28:50</li>
 * <li>작성자 : 허용 (06476)</li>
 * </ul>
 */
public class CUSTPGVCOPSMS extends AbsBatchComponent {
    private Log log;
    private BigDecimal batchJobSeq;    
    
    public CUSTPGVCOPSMS() {
        super();
    }

    /**
     * 배치 전처리 메소드. 
     * 여기서 Exception 발생시 execute() 메소드는 실행되지 않고, afterExecute() 는 실행됨
     */
    public void beforeExecute(IBatchContext context) {
		log = getLog(context);
		
    }

    /**
     * 배치 메인 메소드
     */
    public void execute(final IBatchContext context) {
    	Map<String, String> param = context.getInParameters();
    	
    	try {

    		txBegin();    		
    		
    	    IDataSet requestData = new DataSet();    		
    	    IDataSet responseData = new DataSet();    		

    		//IRecordSet rs = dbSelect("dSelectMrtgList", requestData.getFieldMap(), context);
    		IRecordSet rs = dbSelectMulti("dSelectPgvcOpList", requestData.getFieldMap(), context);    		
    		
    		Map<String, Object> paramMap  = null;
    		int sndCnt = 0;
    		
    		if(rs != null && rs.getRecordCount() >0 ){
	    		for(int i = 0 ; i < rs.getRecordCount() ; i++) {
	
	    			paramMap = rs.getRecordMap(i);
		    		
		    		BigDecimal smsTranSeq = dbSelectSingle("dSelectSmsTranSeq", param, context).getBigDecimal("TRAN_CNT");
		    		BigDecimal telnkCmpMsgId = dbSelectSingle("dSelectSmsCmpMsgSeq", param, context).getBigDecimal("CMP_MSG_ID");
		    			    			    		
		    		paramMap.put("TRAN_CNT", smsTranSeq);
		    		paramMap.put("CMP_MSG_ID", telnkCmpMsgId);    		  		
		    		paramMap.put("ERR_YN", "N");	   	    		  				    		
		    		
		    		int msgCnt = dbInsert("dInsertSmsTran", paramMap, context);
		    		msgCnt = dbInsert("dInsertSmsTranDtl", paramMap, context);			
		    		msgCnt = dbInsert("dInsertTelinkSms", paramMap, context);	    		
		    			    
		    		sndCnt++;
		    	}
    		}    		    	    				    		
    		

    		
			txCommit();
    		
    	}
    	catch (Exception e) {
    		txRollback();
    		
    		try {
				txBegin();

	    		BigDecimal smsTranSeq = dbSelectSingle("dSelectSmsTranSeq", param, context).getBigDecimal("TRAN_CNT");
	    		BigDecimal telnkCmpMsgId = dbSelectSingle("dSelectSmsCmpMsgSeq", param, context).getBigDecimal("CMP_MSG_ID");
	    		if (log.isDebugEnabled()) log.debug("####################### TRAN_CNT = " + smsTranSeq + ", CMP_MSG_ID = "+ telnkCmpMsgId);
	    		
	    		param.put("TRAN_CNT", String.valueOf(smsTranSeq));
	    		param.put("CMP_MSG_ID", String.valueOf(telnkCmpMsgId));
	    		param.put("CONTEXT", "고객민원/비정상영업 처리 독려 SMS오류");
	    		param.put("ERR_YN", "Y");
	    		
	    		int msgCnt = dbInsert("dInsertSmsTran", param, context);
	    		msgCnt = dbInsert("dInsertSmsTranDtl", param, context);
	    		
	    		param.put("SND_MSG", "고객민원/비정상영업 처리 독려 SMS오류");
	    		msgCnt = dbInsert("dInsertTelinkSms", param, context);
	    		
	    		txCommit();
	    	}
	    	catch (Exception se) {
	    		txRollback();
	    	}
    	}
    }
    
    /**
     * 배치 후처리 메소드. 
     * beforeExecute(), execute() 의 Exception 발생 여부와 관계없이 이 메소드는 실행됨
     */
    public void afterExecute(IBatchContext context) {
        if (super.exceptionInExecute == null) {
            // execute() 정상인 경우
            
        }else {
            // execute() 에서 에러 발생할 경우
            
        }
    }

}
