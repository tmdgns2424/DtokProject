package test;

import java.net.URLDecoder;

public class MiscTest {

	public static void main(String[] args) throws Exception {
		String abc = "a\\b\\c\\d\\e\\";
		
		System.out.println("abc = [" + abc + "] ==> [" + abc.replaceAll("\\\\", "/") + "]");
		
		decodeTest();
	}
	
	public static void decodeTest() throws Exception {
		String s = "%5B%7B%22columnIndex%22%3A0%2C%22key%22%3A%22HDQT_TEAM_ORG_NM%22%2C%22title%22%3A%22%EB%B3%B8%EC%82%AC%ED%8C%80%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%22100px%22%7D%2C%7B%22columnIndex%22%3A1%2C%22key%22%3A%22HDQT_PART_ORG_NM%22%2C%22title%22%3A%22%EB%B3%B8%EC%82%AC%ED%8C%8C%ED%8A%B8%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%22100px%22%7D%2C%7B%22columnIndex%22%3A2%2C%22key%22%3A%22SALE_DEPT_ORG_ID%22%2C%22title%22%3A%22%EC%98%81%EC%97%85%EA%B5%ADID%22%2C%22hidden%22%3Atrue%7D%2C%7B%22columnIndex%22%3A3%2C%22key%22%3A%22SALE_DEPT_ORG_NM%22%2C%22title%22%3A%22%EC%98%81%EC%97%85%EA%B5%AD%EB%AA%85%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%22100px%22%7D%2C%7B%22columnIndex%22%3A4%2C%22key%22%3A%22UNIT_TYP_CD%22%2C%22title%22%3A%22%EC%83%81%ED%92%88%EA%B5%AC%EB%B6%84%EC%BD%94%EB%93%9C%22%2C%22hidden%22%3Atrue%7D%2C%7B%22columnIndex%22%3A5%2C%22key%22%3A%22UNIT_TYP_NM%22%2C%22title%22%3A%22%EC%83%81%ED%92%88%EA%B5%AC%EB%B6%84%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%22100px%22%7D%2C%7B%22columnIndex%22%3A6%2C%22key%22%3A%22MGMT_RT%22%2C%22title%22%3A%22%EA%B4%80%EB%A6%AC%EB%B9%84%EC%9C%A8(%25)%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%2280px%22%2C%22editable%22%3A%7B%22type%22%3A%22text%22%2C%22rule%22%3A%22comma%22%7D%2C%22render%22%3A%7B%22type%22%3A%22string%22%2C%22rule%22%3A%22comma%22%2C%22readonly%22%3Atrue%7D%7D%2C%7B%22columnIndex%22%3A7%2C%22key%22%3A%22EXEC_TRGT_QTY%22%2C%22title%22%3A%22%EC%8B%A4%ED%96%89%EB%AA%A9%ED%91%9C%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%2280px%22%2C%22editable%22%3A%7B%22type%22%3A%22text%22%2C%22rule%22%3A%22comma%22%7D%2C%22render%22%3A%7B%22type%22%3A%22string%22%2C%22rule%22%3A%22comma%22%2C%22readonly%22%3Atrue%7D%7D%5D";
		
		String d1 = URLDecoder.decode(s, "UTF-8");
		System.out.println("decoded1 : " + d1 + "");
		
		String s2 = "%5B%7B%22columnIndex%22%3A0%2C%22key%22%3A%22HDQT_TEAM_ORG_NM%22%2C%22title%22%3A%22%EB%B3%B8%EC%82%AC%ED%8C%80%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%22100px%22%7D%2C%7B%22columnIndex%22%3A1%2C%22key%22%3A%22HDQT_PART_ORG_NM%22%2C%22title%22%3A%22%EB%B3%B8%EC%82%AC%ED%8C%8C%ED%8A%B8%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%22100px%22%7D%2C%7B%22columnIndex%22%3A2%2C%22key%22%3A%22SALE_DEPT_ORG_ID%22%2C%22title%22%3A%22%EC%98%81%EC%97%85%EA%B5%ADID%22%2C%22hidden%22%3Atrue%7D%2C%7B%22columnIndex%22%3A3%2C%22key%22%3A%22SALE_DEPT_ORG_NM%22%2C%22title%22%3A%22%EC%98%81%EC%97%85%EA%B5%AD%EB%AA%85%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%22100px%22%7D%2C%7B%22columnIndex%22%3A4%2C%22key%22%3A%22UNIT_TYP_CD%22%2C%22title%22%3A%22%EC%83%81%ED%92%88%EA%B5%AC%EB%B6%84%EC%BD%94%EB%93%9C%22%2C%22hidden%22%3Atrue%7D%2C%7B%22columnIndex%22%3A5%2C%22key%22%3A%22UNIT_TYP_NM%22%2C%22title%22%3A%22%EC%83%81%ED%92%88%EA%B5%AC%EB%B6%84%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%22100px%22%7D%2C%7B%22columnIndex%22%3A6%2C%22key%22%3A%22MGMT_RT%22%2C%22title%22%3A%22%EA%B4%80%EB%A6%AC%EB%B9%84%EC%9C%A8(%25)%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%2280px%22%7D%2C%7B%22columnIndex%22%3A7%2C%22key%22%3A%22EXEC_TRGT_QTY%22%2C%22title%22%3A%22%EC%8B%A4%ED%96%89%EB%AA%A9%ED%91%9C%22%2C%22align%22%3A%22center%22%2C%22width%22%3A%2280px%22%7D%5D";
		System.out.println("decoded2 : " + URLDecoder.decode(s2, "UTF-8") + "");
	}
}
