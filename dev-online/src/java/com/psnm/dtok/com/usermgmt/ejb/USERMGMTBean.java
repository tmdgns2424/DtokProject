package com.psnm.dtok.com.usermgmt.ejb;

/**
 * <ul>
 * <li>업무 그룹명 : com/psnm/dtok/공통</li>
 * <li>설 명 : 회원관리</li>
 * <li>작성일 : 2015-01-15 09:25:36</li>
 * <li>작성자 : 안진갑 (ahnjingap)</li>
 * </ul>
 *
 * @author 안진갑 (ahnjingap)
 */
public class USERMGMTBean extends nexcore.framework.coreext.pojo.biz.OnlineBizComponent {

    /**
     * @see nexcore.framework.coreext.pojo.biz.OnlineBizComponent#getFqId()
     */
    @Override
    public String getFqId() {
        return "com.USERMGMT";
    }

}
