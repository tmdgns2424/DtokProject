<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>MA 지원서 작성 방법 - PS&Marketing</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
        },
        setEventListener : function() {
            $("#btnClose").click( closeWithout );
        },
    });

    function closeWithout() {
        $a.close();
    }

    </script>

<style>
    * {
        font-family:"맑은 고딕";
        font-size:12px;
        margin:0;
        padding:0;
    }
    
    table {
        border-left:2px solid #333;
        border-right:4px solid #333;
        border-bottom:2px solid #333;
    }
     
    .top_font_white {
        color:white;
        font-size:14pt;
        font-weight:bold;
        text-align:center;
        background-color:#333;
    } 

    .font_red {
        color:red;
        font-weight:bold;
        font-size:13pt;
        text-align:right;
	    border-bottom:solid;
	    border-bottom-color:#333;
	    border-bottom-style:dotted;
	    border-bottom-width:thin;
	}     
     
    .bottom_line {
	    border-bottom:solid;
	    border-bottom-color:#333;
	    border-bottom-style:dotted;
	    border-bottom-width:thin;
	}
     
    .subquestion_css {
	    color: #666;
	    text-align:center;
	    padding:2px 0;
	    font-weight:bold;
	    font-size:13px;
    }
     
    .img_padding {
        padding-top:20px;
        padding-bottom:10px;
    }
         
    .txt_css {
        color: #666;
        text-indent:150px;
        font-size:12px;
        line-height:20px;
    }
    .floatL2 {margin-bottom:20px}
    
</style>

</head>

<body>
<table width="850" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td height="37" colspan="2" class="top_font_white">MA 지원서 작성방법</td>
            </tr>
            <tr>
                <td height="30" class="font_red">Step 1 ▶</td>
                <td class="bottom_line">　<strong>MA</strong>지원 클릭!</td>
            </tr>
            <tr>
                <td width="150" height="30" class="font_red">Step 2 ▶</td>
                <td width="700" class="bottom_line"><strong>　D-tok 접속</strong>　www.d-tok.com</td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="img_padding"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/ma_1.jpg" width="650" height="279" /></td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="img_padding"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/ma_2.jpg" width="650" height="279" /></td>
            </tr>
            <tr>
                <td colspan="2" class="subquestion_css">주의 | Internet Explorer Version이 상이할 경우, 접속 및 작성이 원활하지 않습니다. (IE9이상, 크롬, 사파리에서만 정상 이용 가능)</td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="img_padding"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/ma_4.jpg" width="650" height="317" /></td>
            </tr>
            <tr>
                <td height="1" colspan="2" class="bottom_line"></td>
            </tr>
            <tr>
                <td height="30" class="font_red">Step 3 ▶</td>
                <td class="bottom_line">사진 등록</td>
            </tr>
            <tr>
                <td colspan="2" class="txt_css">
                    <p>(1) 사진이미지파일준비(반명함사진스캔파일 or 직접촬영)</p>
                    <p>(2) 편집할  이미지 선택 – [예시]알씨 (http://www.altools.co.kr/)</p>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="img_padding"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/ma_5.jpg" width="466" height="300" /></td>
            </tr>
            <tr>
                <td colspan="2" class="txt_css">
                    <p>(3) 이미지 편집 / 저장</p>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="img_padding"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/ma_6.jpg" width="534" height="411" /></td>
            </tr>
            <tr>
                <td colspan="2" class="txt_css">
                    <p>(4) 등록 Click</p>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="img_padding"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/ma_7.jpg" width="624" height="491" /></td>
            </tr>
            <tr>
                <td colspan="2" class="txt_css">
                    <p>(5) 이미지 파일 선택</p>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="img_padding"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/ma_8.jpg" width="624" height="300" /></td>
            </tr>
            <tr>
                <td height="1" colspan="2" class="bottom_line"></td>
            </tr>
            <tr>
                <td height="30" class="font_red">Step 4 ▶</td>
                <td class="bottom_line">내용 입력</td>
            </tr>
            <tr>
                <td colspan="2" class="txt_css">
                    <p>(1) 인적 사항 입력 (필수)</p>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="img_padding"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/ma_9.jpg" width="624" height="300" /></td>
            </tr>
            <tr>
                <td colspan="2" class="txt_css">
                    <p>(2) 학력사항, 경력사항, 자기소개, 판매계획 (선택)</p>
                    <p> - 개인정보 수집 및 이용 동의 후 “추가”버튼 클릭 후 등록</p>
                    <p>  ※ 선택 정보는 동의하지 않을 권리가 있으나, 미 동의 시 심사에 불리하게 작용함</p>
                    <p>  ※ 자기소개(200자), 판매계획(300자)은 기준 글자 이상 작성해야 함</p>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="img_padding"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/ma_10.jpg" width="624" height="475" /></td>
            </tr>
            <tr>
                <td colspan="2" class="txt_css">
                    <p>(3) 기타 사항, 희망부서(선택)</p>
                    <p> - 개인정보 수집 및 이용 동의 후 “추가”버튼 클릭 후 등록</p>
                    <p>  ※ 선택 정보는 동의하지 않을 권리가 있으나, 미 동의 시 심사에 불리하게 작용함</p>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" class="img_padding"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/ma_11.jpg" width="624" height="382" /></td>
            </tr>
            
            </table>
        </td>
    </tr>
</table>

 <p class="floatL2">
     <input id="btnClose" name="btnClose" type="button"  data-type="button" data-theme="af-n-btn23" data-altname="닫기">
 </p>

</body>
</html>