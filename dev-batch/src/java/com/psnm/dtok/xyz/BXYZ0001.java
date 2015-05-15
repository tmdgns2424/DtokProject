package com.psnm.dtok.xyz;

import nexcore.framework.bat.IBatchContext;
import org.apache.commons.logging.Log;
import nexcore.framework.bat.base.AbsBatchComponent;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/샘플</li>
 * <li>서브 업무명 : BXYZ0001</li>
 * <li>설  명 : </li>
 * <li>작성일 : 2015-03-12 13:29:17</li>
 * <li>작성자 : 안종광 (rhkd)</li>
 * </ul>
 */
public class BXYZ0001 extends AbsBatchComponent {
    private Log log;
    
    public BXYZ0001() {
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
        log.info("로그 테스트");
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
