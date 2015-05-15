/*
 * Copyright (c) 2014 PS&M. All rights reserved.
 *
 * @file psnm-misc.js
 *
 * 이 스크립트 파일에 일반적으로 개발자가 공통으로 사용할 스크립트를 추가하도록 함.
 */

//이 함수|객체에 간략한 주석을 표시하도록 함.
var PsnmUser = function() {
	return {
		//파라메터로 넘어온 사용자id가 세션의 id와 같은지를 검사.
		isLogin : function() { return !$.PSNMUtils.isEmpty($.PSNM.getSession("USER_ID")) },
		isLoginUser : function(userId) { return $.PSNM.getSession("USER_ID") == userId; },
		//팀장 여부 C7:팀장
		isTeamLeader : function() {
			var result = false;
			if($.PSNM.getSession("DUTY") === "16" || $.PSNM.getSession("DUTY") === "19" || $.PSNM.getSession("DUTY") === "20"){
				result = true;
			}  
			return result; 
		},
		//MA여부
		isMa : function() { 
			var result = false;
			if($.PSNM.getSession("DUTY") === "15" || $.PSNM.getSession("DUTY") === "17" || $.PSNM.getSession("DUTY") === "18"){
				result = true;
			}  
			return result; 
		},
		//국장  B6:국장
		isDirector : function() { return $.PSNM.getSession("DUTY") === "14"; },
		//임직원 여부
		isStaff : function() {
			var result = false;
			if($.PSNM.getSession("DUTY") === "1" || $.PSNM.getSession("DUTY") === "2" || $.PSNM.getSession("DUTY") === "3" || $.PSNM.getSession("DUTY") === "4" || $.PSNM.getSession("DUTY") === "6" || $.PSNM.getSession("DUTY") === "7"){
				result = true;
			}  
			return result;
		}
	}
}();

//문자열의 바이트 
function getBytes(str) {
    var i, tmp = escape(str);
    var bytes = 0;
    for (i = 0; i < tmp.length; i++) {
        if (tmp.charAt(i) == "%") {
            if (tmp.charAt(i + 1) == "u") {
                bytes += 2;
                i += 5;
            } else {
                bytes += 1;
                i += 2;
            }
        } else {
            bytes += 1;
        }
    }

    return bytes;
}

//해당 요일에 날짜 add
function getAddDate(curDay,plusDayInt){
	var curDay = curDay.split('-').join('');
	
	var yyyy = curDay.substring(0,4);
	var mm = eval(curDay.substring(4,6)+"-1");
	var dd = curDay.substring(6);
	
	var dt3 = new Date(yyyy,mm,eval(dd+'+'+plusDayInt));
	
	yyyy = dt3.getFullYear();
	mm = (dt3.getMonth()+1)<10?"0"+(dt3.getMonth()+1):(dt3.getMonth()+1);
	dd = dt3.getDate()<10?"0"+dt3.getDate():dt3.getDate();
	return yyyy + "-" + mm + "-" + dd;
	
}

//현재월의 첫번째 일자
function getFirstdate() {
	var now = new Date(); 
	var year = now.getFullYear(); 
	var month = (now.getMonth()+1); 
	if(month < 10 ) month = "0" + month;
	
	return year + "-" + month + "-" +"01";
}

//검색조건의 같은 년월인지 체크
function checkDate(fromDt, toDt) {

	var fromDt = fromDt.split('-').join('');
	var toDt = toDt.split('-').join('');
	
	if( fromDt.length >= 6 && toDt.length >= 6){
		if (fromDt.substr(0,6) == toDt.substr(0,6)) {
			return true;
		}
	}
	return false;
}

//해당월의 마지막 날짜
function getLastDate(sYM)
{
    if(sYM.length != 6)
    {
        alert("정확한 년월을 입력하십시요.");
        return;
    }

    daysArray = new makeArray(12);    // 배열을 생성한다.

    for (i=1; i<8; i++)
    {
        daysArray[i] = 30 + (i%2);
    }

    for (i=8; i<13; i++)
    {
        daysArray[i] = 31 - (i%2);
    }

    var sYear = sYM.substring(0, 4) * 1;
    var sMonth	= sYM.substring(4, 6) * 1;

    if (((sYear % 4 == 0) && (sYear % 100 != 0)) || (sYear % 400 == 0))
    {
        daysArray[2] = 29;
    }else{
        daysArray[2] = 28;
    }

    return daysArray[sMonth].toString(); 
}

//오늘날짜
function getCurrdate() {
	var now = new Date;
	var year = now.getFullYear().toString();
	var month = now.getMonth() + 1;
	var today = now.getDate();

	if(month < 10)
		month = "0" + month;
	if(today < 10)
		today = "0" + today;
	
	to_day = year +"-"+ month + "-"+ today;

	return to_day;
}

//오늘날짜 기준으로   addMn 해당하는 날짜 
function getAddMonthDate(addMn,ymdFormat) {
	
	if(ymdFormat == null) ymdFormat='yyyymmdd'
	if(addMn == null) addMn=0;
	
	var now = new Date();
	var currYmd = new Date(now.getFullYear(),now.getMonth(),now.getDate());
	var year = currYmd.getFullYear(); 
	var month = (currYmd.getMonth()+addMn); 
	var addYear = Math.floor((currYmd.getMonth()+addMn)/12);
	
	
	if(addMn < 0){
		addMn = addMn-1;
	}
	

	if(addMn >= 0){
		if( month > 12){
		    month = month%12;
		    year = year+addYear;
		}
	}else{
		if((now.getMonth()+1) > addMn*(-1)){
			month = month;
		    year =year;
		}else if((now.getMonth()+1) == addMn*(-1)){
			month = 12;
			year = year-1;
		}else{ 
			month = ((-12)*addYear + month) % 12;
			year = year+addYear;
			if(month == 0){
				month = 12;
				year = year-1;
			}
		}
	}
	
	if(month < 10 ) month = "0" + month;
	
	var date = currYmd.getDate();
	if(date < 10 ) date = "0" + date;
	var curDate = year + "-" + month + "-" + date;
	if(ymdFormat =="yyyymm"){
		return year + "-" + month;
	}
	return year + "-" + month + "-" + date;
	
}

// 지정일자 기준 addMn 해당하는 날짜 
function getCurrAddMonth(currYmd,addMn,ymdFormat) {
	
	if(ymdFormat == null) ymdFormat='yyyymmdd'
	if(addMn == null) addMn=0;
	
	//var currYmd = new Date(strDt.getFullYear(),strDt.getMonth(),strDt.getDate());
	var year = currYmd.getFullYear(); 
	var month = (currYmd.getMonth()+addMn); 
	var addYear = Math.floor((currYmd.getMonth()+addMn)/12);
	
	if(addMn >= 0){
		if( month > 12){
		    month = month%12;
		    year = year+addYear;
		}
	}else{
		if((strDt.getMonth()+1) > addMn*(-1)){
			month = month;
		    year =year;
		}else if((strDt.getMonth()+1) == addMn*(-1)){
			month = 12;
			year = year-1;
		}else{ 
			month = ((-12)*addYear + month) % 12;
			year = year+addYear;
			if(month == 0){
				month = 12;
				year = year-1;
			}
		}
	}
	
	if(month < 10 ) month = "0" + month;
	
	var date = currYmd.getDate();
	if(date < 10 ) date = "0" + date;
	var curDate = year + "-" + month + "-" + date;
	if(ymdFormat =="yyyymm"){
		return year + "-" + month;
	}
	return year + "-" + month + "-" + date;
	
}

//두 날짜 비교 ( baseDate:비교 기준일,checkDate:비교 대상일)
function compareDate(baseDate,checkDate){
	
	baseDate = baseDate.split('-').join('');
	checkDate = checkDate.split('-').join('');
	
	if(baseDate=="" || checkDate=="" || baseDate > checkDate) return false;
	else return true;
}

//두 날짜를 입력받아 차이를 계산 (yyyyMMdd 8자리 포맷만 가능)
function getDateDiff(date1, date2)
{
	yy1 = date1.substring(0,4);
	mm1 = date1.substring(4,6);
	dd1 = date1.substring(6,8);
	start_dt = new Date(yy1, mm1-1, dd1);

	yy2 = date2.substring(0,4);
	mm2 = date2.substring(4,6);
	dd2 = date2.substring(6,8);
	end_dt = new Date(yy2, mm2-1, dd2);

	start_stamp = start_dt.getTime();
	end_stamp = end_dt.getTime();

	stamp_diff = end_stamp-start_stamp;

	date_diff = stamp_diff/(24*60*60*1000);

	return date_diff+1;
}

//날짜 포맷을 제거하고 리턴한다.
function removeDateFormat( date ) {
	var str = date.getValue === undefined ? date : date.getValue();
	return str.replace(/-/g, '');
}

function getSetDate(day){
	var today = new Date();
    var date = new Date(today.getFullYear(), today.getMonth(), day);
	return (date).yyyymmdd();
}

function getSetNextDate(day){
	var today = new Date();
    var date = new Date(today.getFullYear(), today.getMonth()+1, day);
	return (date).yyyymmdd();
}

//TEXTAREA 글자수 체크
function updateChar(obj) {

    var length = calculate_msglen(obj.value);
    document.getElementById("textlimit").innerText = length;
}

function updateCharFind(obj) {
	var limitctt 	= $(obj).parent().parent().find("#limitctt");
	var textlimit 	= limitctt.find("#textlimit");
    var length = calculate_msglen(obj.value);
    
    textlimit.html(length);
}

//TEXTAREA 글자수 체크
function calculate_msglen(message) {
    var nbytes = 0;

    for (i=0; i<message.length; i++) {
         var ch = message.charAt(i);

         if(escape(ch).length > 4) {
              nbytes += 1;  // 한글일때 2씩 더함
         } else if(ch == '\n') {
              if (message.charAt(i-1) != '\r') {
                   nbytes += 0;  // Enter일때 1씩 더하지않음
              }
         } else if(ch == ' ') {
              nbytes += 0;  // 공백일때 더하지 않음
         } else {
              nbytes += 1;  // 기타 문자들일때 1씩 더함
         }
    }

    return nbytes;
}

//yyyymmdd 형태로 포매팅된 날짜 반환
Date.prototype.yyyymmdd = function()
{
    var yyyy = this.getFullYear().toString();
    var mm = (this.getMonth() + 1).toString();
    var dd = this.getDate().toString();

    return yyyy + (mm[1] ? mm : '0'+mm[0]) + (dd[1] ? dd : '0'+dd[0]);
}

//연속된 문자(1234,abcd..) 체크로직
function isContinuedValue(value) 
{
    var intCnt1 = 0;
    var intCnt2 = 0;
    
    var temp0 = "";
    var temp1 = "";
    var temp2 = "";
    var temp3 = "";

    for ( var i = 0; i < value.length; i++ ) {
            temp0 = value.charAt(i);
            temp1 = value.charAt(i+1);
            temp2 = value.charAt(i+2);
            temp3 = value.charAt(i+3);

            if ( temp0.charCodeAt(0) - temp1.charCodeAt(0) == 1 && 
                 temp1.charCodeAt(0) - temp2.charCodeAt(0) == 1 && 
                 temp2.charCodeAt(0) - temp3.charCodeAt(0) == 1)
            {
                       intCnt1 = intCnt1 + 1;
            }

           if ( temp0.charCodeAt(0) - temp1.charCodeAt(0) == -1 && 
                 temp1.charCodeAt(0) - temp2.charCodeAt(0) == -1 && 
                 temp2.charCodeAt(0) - temp3.charCodeAt(0) == -1) 
           {
                       intCnt2 = intCnt2 + 1;
            }
    }
    
    if (intCnt1 > 0 || intCnt2 > 0){
            return true;
    } else{
            return false;
    }
}

//패스워드 유효성 검사
function isPwdValidate( pwd )
{
	 if(!/^[a-zA-Z0-9]{10,12}$/.test(pwd) || pwd.indexOf(' ') > -1) 
	 {
		 alert('비밀번호는 숫자와 영문자 조합으로 10~12자리를 사용해야 합니다.');
		 return false;
	 }
	 var chk_num = pwd.search(/[0-9]/g);
	 var chk_eng = pwd.search(/[a-z]/ig);
	 /*
	 if(getTrmsUserId() == pwd){
		dialog.alert('비밀번호는 ID와 동일 할 수 없습니다.');
		return false;
	 }
	 */
	 if(chk_num < 0 || chk_eng < 0)
	 {
		 alert('비밀번호는 숫자와 영문자를 혼용하여야 합니다.');
		 return false;
	 }

     if(/(admin|system|master|sys)/gi.test(pwd))
     {
    	 alert('비밀번호에 차단된 단어가 포함되어 있습니다.');
    	 return false;
     }
     
     if(/(\w)\1/.test(pwd))
     {
    	 alert('비밀번호에 같은 문자를 연속하여 사용하실 수 없습니다.');
    	 return false;
     }
     
     if(isContinuedValue(pwd))
     {
    	 alert('비밀번호에 연속된 문자를 사용하실 수 없습니다.');
    	 return false;
     }
     
     return true;
}