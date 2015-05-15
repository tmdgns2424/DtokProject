package com.psnm.dtok.com.code.ejb;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>설 명 : 코드조회 컴포넌트는 화면에서 코드정보를 조회하기위해 PU 클래스만 제공하며, FU, DU는 [공유공통]의 클래스를 참조한다.</li>
 * <li>작성일 : 2014-11-14 11:52:17</li>
 * <li>작성자 : admin (admin)</li>
 * </ul>
 *
 * @author admin (admin)
 */
public class CODEBean extends nexcore.framework.coreext.pojo.biz.OnlineBizComponent {

    /**
     * @see nexcore.framework.coreext.pojo.biz.OnlineBizComponent#getFqId()
     */
    @Override
    public String getFqId() {
        return "com.CODE";
    }

}
