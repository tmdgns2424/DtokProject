package com.psnm.dtok.com.mainlogin.ejb;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>설 명 : 메인 홈 및 로그인 처리 관련 컴포넌트</li>
 * <li>작성일 : 2014-11-19 15:07:40</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class MAINLOGINBean extends nexcore.framework.coreext.pojo.biz.OnlineBizComponent {

    /**
     * @see nexcore.framework.coreext.pojo.biz.OnlineBizComponent#getFqId()
     */
    @Override
    public String getFqId() {
        return "com.MAINLOGIN";
    }

}
