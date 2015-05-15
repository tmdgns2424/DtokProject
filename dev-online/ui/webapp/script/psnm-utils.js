/*
 * Copyright (c) 2014 PS&M. All rights reserved.
 */

(function ($) {

    //var _g_var_0;

    $.PSNMUtils = {

        //입력된 객체를 문자열로 반환
        toString : function(object) {
            return JSON.stringify(object);
        }
        ,
        //입력된 객체가 null 또는 빈값이면 true를 반환
        isEmpty : function(o) {
            if (undefined==o || null==o) return true;
            if ( $.isArray(o) ) {
                if (o.length<1) return true;
            }
            if ( 'string' === typeof o ) {
                if (''==o) return true;
            }
            return false;
        }
        ,
        isNotEmpty : function(o) {
            return !$.PSNMUtils.isEmpty(o);
        }
        ,
        //넥스코어 요청파라미터 dataSet.fields 에 입력되는 객체는 array 배열이 포함되면 안됨.
        //이를 위해 array 배열을 제거한 파라미터객체를 반환
        //@since 2014-12-03
        removeParamArrays : function(oParamData) {
            var oTrimedParamData = {};

            for(var key in oParamData) {
                var val = oParamData[key];
                if ( !jQuery.isArray(val) ) {
                    oTrimedParamData[key] = val;
                }
            }
            return oTrimedParamData;
        }
        ,
        getUploadUrl : function(sType) {
            if  ( $.PSNMUtils.isEmpty(sType) ) {
                    sType = "BBS";
            }
            var sUrl = _FILE_HANDLER_URL + "?biz=" + sType;

            return sUrl;
        } 
        ,
        getDownloadUrl : function(fileinfo) {
            if  ( $.PSNMUtils.isEmpty(fileinfo) ) {
                return "";
            }
            //$.PSNMUtils.getDownloadUrl(fileinfo.FILE_GRP_ID, fileinfo.ATCH_FILE_ID, fileinfo.FILE_NM, fileinfo.FILE_PATH);
            var sUrl = _FILE_HANDLER_URL + "?cmd=download&biz=" + fileinfo.FILE_GRP_ID;
                sUrl+= "&dir=" + fileinfo.FILE_PATH;
                sUrl+= "&id=" + fileinfo.ATCH_FILE_ID;
                sUrl+= "&name=" + encodeURIComponent(fileinfo.FILE_NM);
            return sUrl;
        }
        ,
        getDownloadUrl2 : function(sType, sFileId, sFileNm, sDir) {
            if  ( $.PSNMUtils.isEmpty(sType) ) {
                sType = "BBS";
            }
            if  ( $.PSNMUtils.isEmpty(sFileNm) ) {
                sFileNm = sFileId;
            }
            var sUrl = _FILE_HANDLER_URL + "?cmd=download&biz=" + sType;
                sUrl+= "&dir=" + sDir;
                sUrl+= "&id=" + sFileId;
                sUrl+= "&name=" + sFileNm; //encodeURIComponent(fileinfo.FILE_NM);
            return sUrl;
        }
        ,
        download : function(fileinfo) {
            if  ( $.PSNMUtils.isEmpty(fileinfo) ) {
                return;
            }
            var downloadURL = $.PSNMUtils.getDownloadUrl(fileinfo); //alert(JSON.stringify(fileinfo) + "\n\n" + downloadURL);
            $a.navigate(downloadURL);
            return;
        }
        ,

        setFileUploadAndGrid : function(sBizType, sFileInputId, sFileGridId, sFormId) {
            if  ( $.PSNMUtils.isEmpty(sBizType) ) {
                alert("첨부파일을 설정하기 위해서 업무구분을 지정하십시오!");
                return;
            }
            if  ( $.PSNMUtils.isEmpty(sFileInputId) ) {
                sFileInputId = "fileupload";
            }
            if  ( $.PSNMUtils.isEmpty(sFileGridId) ) {
                sFileGridId = "gridfile";
            }
            sFileInputId = "#" + sFileInputId.replace(/^#/, ""); //디폴트 #fileupload
            sFileGridId  = "#" + sFileGridId.replace(/^#/, "");  //디폴트 #gridfile
            _debug("<PSNMUtils.setFileUploadAndGrid> 첨부파일 : 업무구분 = [" + sBizType + "], file 객체ID = [" + sFileInputId + "], grid 객체ID = [" + sFileGridId + "]");

            //파일 업로드 컴포넌트 설정
            $(sFileInputId).fileupload({
                dataType: 'json',
                url : _FILE_HANDLER_URL + "?biz=" + sBizType, /* 파일 업로드시 업무구분(소문자)로 지정함(TOBE) */
                done: function (e, data) {
                    $.each(data.result, function (index, fileinfo) {
                        var numOfFile = $("#gridfile").alopexGrid('pageInfo').dataLength;
                        _debug("<PSNMUtils.setFileUploadAndGrid> 현재 첨부파일 개수 = " + numOfFile + "\n-업로드된 파일정보 : " + JSON.stringify(fileinfo));

                        //파입업로드가 완료(성공)하면, 그리드에 첨부된 파일정보를 추가함.
                        $( sFileGridId ).alopexGrid("dataAdd", {
                            "FLAG"         : "I",
                            //"ATCH_SEQ"     : 1 + numOfFile,
                            "FILE_NM"      : fileinfo.name,
                            "FILE_SIZE"    : fileinfo.size,
                            "ATCH_FILE_ID" : fileinfo.id,
                            "FILE_GRP_ID"  : fileinfo.group,
                            "FILE_PATH"    : fileinfo.dir
                        });

                        var webEditElemId = $.PSNMUtils.getWebEditorId();
                        var filetype = fileinfo.type;
                        if ( $.PSNMUtils.isNotEmpty(webEditElemId) && filetype.indexOf("image")>=0 ) {
                            var imgUrl = _FILE_HANDLER_URL + "?cmd=download&biz=" + fileinfo.group;
                                imgUrl+= "&dir=" + fileinfo.dir;
                                imgUrl+= "&id=" + fileinfo.id;
                                imgUrl+= "&name=" + encodeURIComponent(fileinfo.name);
                            _debug("getWebEditorId : " + webEditElemId + "\n\nimgUrl : " + imgUrl);
                            $("#"+webEditElemId).val( $("#"+webEditElemId).val() + "<br/><img src='" + imgUrl + "' alt='" + fileinfo.name + "'/>");
                        }
                    });
                }
            })
            ;
            if ( $.PSNMUtils.isNotEmpty(sFormId) ) {
                //TODO
            }

            //첨부파일 그리드 초기화
            $( sFileGridId ).alopexGrid({
                pager : false, //첨부파일 그리드는 페이징 처리하지 않음.
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 1, key : "FLAG",         title : "F",            align : "center", width : "40px" },
                    //{ columnIndex : 2, key : "ATCH_SEQ",     title : "순번",         align : "center", width : "80px" },
                    { columnIndex : 2, key : "FILE_NM",      title : "파일명",       align : "left",   width : "600px" },
                    { columnIndex : 3, key : "FILE_SIZE",    title : "파일크기",     align : "right",  width : "100px" /* sorting : true,  */,
                                        render : function ( value , data, mapping ) {
                                            return $.PSNMUtils.getFormatedFileSize(value);
                                        }
                    },
                    { columnIndex : 4, key : "ATCH_FILE_ID", title : "ATCH_FILE_ID", hidden : true },
                    { columnIndex : 5, key : "FILE_GRP_ID",  title : "FILE_GRP_ID",  hidden : true },
                    { columnIndex : 6, key : "FILE_PATH",    title : "FILE_PATH",    hidden : true }
                ]
            });
            $( sFileGridId ).alopexGrid('updateOption', {
                on : {
                    'cell' : {
                        "click" : function(data, eh, e) {
                            if ( data._index.column == 2 ) {
                                _debug("<PSNMUtils.setFileUploadAndGrid> 더블클릭된 데이터 : " + data.ATCH_FILE_ID + "\n\n" + data["ATCH_SEQ"] + "\n\n" + $.PSNMUtils.toString(data));
                                 $.PSNMUtils.download(data); //파일다운로드
                            }
                        }
                    }
                }
                ,
                message : {
                    nodata : "<p style='text-align:center;'>첨부파일이 없습니다.</p>"
                }
            });
        }
        ,
        //첨부파일GRID를 초기화함
        //@param    sFileGridId 파일그리드ID(문자열)
        //@param    bReadonly   조회전용GRID 여부(디폴트 false)
        setFileGrid : function(sFileGridId, bReadonly) {
            if  ( $.PSNMUtils.isEmpty(sFileGridId) ) {
                sFileGridId = "gridfile"; //디폴트 파일그리드ID = 'gridfile'
            }
            if  ( $.PSNMUtils.isEmpty(bReadonly) ) {
                bReadonly = false; //조회용GRID 여부(디폴트 false)
            }
            sFileGridId  = "#" + sFileGridId.replace(/^#/, "");
            _debug("<PSNMUtils.setFileGrid> 첨부파일그리드 : grid 객체ID = [" + sFileGridId + "], bReadonly = " + bReadonly + "");

            //첨부파일 그리드 초기화
            $( sFileGridId ).alopexGrid({
                pager : false, //첨부파일 그리드는 페이징 처리하지 않음.
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 1, key : "FLAG",         title : "F",            align : "center", width : "40px" },
                    { columnIndex : 2, key : "FILE_NM",      title : "파일명",       align : "left",   width : "600px" },
                    { columnIndex : 3, key : "FILE_SIZE",    title : "파일크기",     align : "right",  width : "100px" /* sorting : true,  */ ,
				                    	render : function ( value , data, mapping ) {
				                            return $.PSNMUtils.getFormatedFileSize(value);
				                        }	
				    },
                    { columnIndex : 4, key : "ATCH_FILE_ID", title : "ATCH_FILE_ID", hidden : true },
                    { columnIndex : 5, key : "FILE_GRP_ID",  title : "FILE_GRP_ID",  hidden : true },
                    { columnIndex : 6, key : "FILE_PATH",    title : "FILE_PATH",    hidden : true }
                ],
                on : {
                    'cell' : {
                        "dblclick" : function(data, eh, e) {
                            _debug("<PSNMUtils.setFileGrid> 더블클릭된 데이터 : " + data.ATCH_FILE_ID + "\n\n" + data["ATCH_SEQ"] + "\n\n" + $.PSNMUtils.toString(data));
                            $.PSNMUtils.download(data); //파일다운로드
                        }
                    }
                },
                message : {
                    nodata : "<p style='text-align:center;'>첨부파일이 없습니다.</p>"
                }
            });
            if  ( bReadonly ) {
                $(sFileGridId).alopexGrid('updateOption', {
                    columnMapping : [
                        { columnIndex : 0, selectorColumn : true, hidden : true },
                        { columnIndex : 1, key : "FLAG", title : "F", hidden : true },
                        { columnIndex : 2, key : "FILE_NM",      title : "파일명",       align : "left",   width : "600px" },
                        { columnIndex : 3, key : "FILE_SIZE",    title : "파일크기",     align : "right",  width : "100px" /* sorting : true,  */  ,
				                        	render : function ( value , data, mapping ) {
					                            return $.PSNMUtils.getFormatedFileSize(value);
					                        }	
                        },
                        { columnIndex : 4, key : "ATCH_FILE_ID", title : "ATCH_FILE_ID", hidden : true },
                        { columnIndex : 5, key : "FILE_GRP_ID",  title : "FILE_GRP_ID",  hidden : true },
                        { columnIndex : 6, key : "FILE_PATH",    title : "FILE_PATH",    hidden : true }
                    ]
                });
            }
        }
        ,
        delFile : function() {
            _debug("파일삭제 시작 처리 시작 ...");
            var filesToDelete = $("#gridfile").alopexGrid("dataGet", { _state : {selected:true} } ); //선택된 데이터

            if (filesToDelete.length<1) {
                //alert('선택된 첨부파일이 없습니다.');
                $.PSNM.alert("E011", ["선택된 첨부파일"]); //"PSNM-E011", "MESSAGE_NAME":"{0} 데이터가 없습니다!"
                return;
            }
            if ( ! $.PSNM.confirm("I004", ["첨부파일을 삭제"]) ) {
                return;
            }

            var lenSelected = filesToDelete.length;

            //그리드에서 (선택된 행 & 플래그=I) 데이터를 삭제함
            //$("#gridfile").alopexGrid( "dataEdit", {"FLAG":"D"}, {_state:{selected:true}} ); //선택된 파일의 FLAG 값을 'D'로 설정함
            //$("#gridfile").alopexGrid( "dataEdit", {_state:{selected:false}}, {_state:{selected:true}} ); //체크 해제

            for(var i=lenSelected-1; i>=0; i--) {
                var oFileToDel = filesToDelete[i];
                var flag = oFileToDel["FLAG"];
                var idx = oFileToDel._index.data;
                if ( "I" == flag ) {
                    $("#gridfile").alopexGrid("dataDelete", {_index:{data:idx}});
                }
                else {
                    $("#gridfile").alopexGrid("dataEdit", {"FLAG":"D"}, {_index:{data:idx}}); //선택된 파일의 FLAG 값을 'D'로 설정함
                    $("#gridfile").alopexGrid("dataEdit", {_state:{selected:false}}, {_index:{data:idx}}); //체크 해제
                }
            }
        }
        ,
        // 폼(또는 어떠한 객체라도)의 내부 입력필드의 값을 객체로 생성하여 반환. 
        // (참고) 속성에 data-type="dateinput" 인 것이면 하이픈 문자 제거
        //@param  폼ID
        //@since  2014-11-18
        getFormData : function(sFormId) {
            var formdata = {}; //input:text, input:hidden, input:password, input:file
            $("#" + sFormId).find('input:not([type=radio],[type=checkbox]), select, textarea').each(function() {
                var val = $(this).val();
                var key = $(this).attr("id");
                if ( $.PSNMUtils.isEmpty(key) || 'undefined'==key || 'null'==key || 0==key.indexOf("alopex") ) {
                    key = $(this).attr("name");
                }
                _debug("<getFormData> id = [" + $(this).attr("id") + "], name = [" + $(this).attr("name") + "], key = [" + key + "], value = [" + val + "]");
                var typeStr =$(this).data("type"); //data-type="dateinput"
                    val = typeStr=="dateinput" ? val.replace(/-/g, "") : val; //dateinput 타입이면 문자 - 를 제거함.
                formdata[key] = val;
            });
            $("#" + sFormId).find("input[type='radio']:checked").each(function() {
                _debug("<getFormData> 라디오 name = [" + $(this).attr("name") + "] = [" + $(this).val() + "]");
                var key = $(this).attr("name");
                var val = $(this).val();
                if ( $.PSNMUtils.isEmpty(key) ) { $(this).attr("id"); }
                formdata[key] = val;
            });
            $("#" + sFormId).find("input[type='checkbox']").each(function() {
                _debug("<getFormData> 체크박스 name = [" + $(this).attr("name") + "] = [" + $(this).val() + "] checked = " + $(this).is(':checked'));
                var key = $(this).attr("name");
                var chk = $(this).is(':checked');
                if ( $.PSNMUtils.isEmpty(key) ) { $(this).attr("id"); }
                var val = true==chk || "checked"==chk ? $(this).val() : "";
                formdata[key] = val;
            });
            return formdata;
        }
        ,
        //객체에  {키, 값}을 병합함. 같은 키의 값이 있으면 값문자열을 콤마(,)로 연결함(@since 2015-02-12)
        //@param    sFormId   {키,값}을 수집할 폼ID
        //@return   {키, 값}이 병합된 객체. 같은 키의 값이 있으면 값문자열을 콤마(,)로 연결함
        getFormData2 : function(sFormId) {
            var formdata = {}; //input:text, input:hidden, input:password, input:file
            $("#" + sFormId).find('input:not([type=radio],[type=checkbox]), select, textarea').each(function() {
                var val = $(this).val();
                var key = $(this).attr("name");
                if ( $.PSNMUtils.isEmpty(key) || 'undefined'==key || 'null'==key || 0==key.indexOf("alopex") ) {
                    key = $(this).attr("id");
                }
                _debug("<getFormData2> id = [" + $(this).attr("id") + "], name = [" + $(this).attr("name") + "], key = [" + key + "], value = [" + val + "]");
                var typeStr =$(this).data("type"); //data-type="dateinput"
                    val = typeStr=="dateinput" ? val.replace(/-/g, "") : val; //dateinput 타입이면 문자 - 를 제거함.
                formdata = $.PSNMUtils.appendValueToObject(formdata, key, val); //formdata[key] = val;
            });
            $("#" + sFormId).find("input[type='radio']:checked").each(function() {
                _debug("<getFormData> 라디오 name = [" + $(this).attr("name") + "] = [" + $(this).val() + "]");
                var key = $(this).attr("name");
                var val = $(this).val();
                if ( $.PSNMUtils.isEmpty(key) ) { $(this).attr("id"); }
                formdata = $.PSNMUtils.appendValueToObject(formdata, key, val); //formdata[key] = val;
            });
            $("#" + sFormId).find("input[type='checkbox']").each(function() {
                _debug("<getFormData2> 체크박스 name = [" + $(this).attr("name") + "] = [" + $(this).val() + "] checked = " + $(this).is(':checked'));
                var key = $(this).attr("name");
                var chk = $(this).is(':checked');
                if ( $.PSNMUtils.isEmpty(key) ) { $(this).attr("id"); }
                var val = true==chk || "checked"==chk ? $(this).val() : "";
                formdata = $.PSNMUtils.appendValueToObject(formdata, key, val); //formdata[key] = val;
            });
            return formdata;
        }
        ,
        //객체에  {키, 값}을 병합함. 같은 키의 값이 있으면 값문자열을 콤마(,)로 연결함(@since 2015-02-12)
        //@param    oObject   추가되어질 객체(Object). {키,값} 형태만 가능하며, 값이 또 객체인 경우(deep 수준)은 지원안함
        //@param    sKey      추가할 키 문자열
        //@param    sValue    추가할 값 문자열
        //@return   {키, 값}이 병합된 객체. 같은 키의 값이 있으면 값문자열을 콤마(,)로 연결함
        appendValueToObject : function(oObject, sKey, sValue) {
            if ( null==sKey || undefined==sKey ) {
                return oObject; //키 문자열이 없으면 그냥 반환
            }
            if ( null==sValue || undefined==sValue ) {
                sValue = "";
            }
            if ( null==oObject || undefined==oObject ) {
                oObject = new Object();
            }

            if ( oObject.hasOwnProperty(sKey) ) {
                oObject[sKey] = oObject[sKey] + "," + sValue;
            }
            else {
                oObject[sKey] = sValue;
            }
            return oObject;
        }
        ,
        getDateInput : function(id){
            var val = $("#"+id).val();
            var typeStr = $("#"+id).data("type"); //data-type="dateinput"
            val = typeStr == "dateinput" ? val.replace(/-/g, "") : val; //dateinput 타입이면 문자 - 를 제거함.
            return val;
        }
        ,
        //alopex.request 의 data 에 들어갈 데이터 객체를 생성하여 반환.
        //@param  arg1, arg2, ...  폼ID, 그리드ID_1, 그리드ID_2, ... (참고) 속성에 data-bind="grid" 인 것이면 그리드로 인식함.
        //@since  2014-11-19
        getRequestData : function() {
            var fieldsData = {}; // $.PSNMUtils.getFormData("form");
            var recordSetsData = {};

            for (var i=0; i<arguments.length; i++) {
                var elemId  = arguments[i];
                var bindStr = $("#" + elemId).data("bind");
                _debug("<getRequestData> elemId = [" + elemId + "], bind = [" + bindStr + "]");

                if ( $.PSNMUtils.isEmpty(bindStr) || bindStr.indexOf("grid")<0 ) {
                    fieldsData = jQuery.extend(fieldsData, $.PSNMUtils.getFormData(elemId));
                }
                else {
                    var gridData = {
                        nc_list: $("#" + elemId).alopexGrid("dataGet")
                    };
                    recordSetsData[elemId] = gridData;
                }
            }
            
            var dataSetData = {};
                dataSetData["fields"] = fieldsData;
                dataSetData["recordSets"] = recordSetsData;
                
            var dataData = {};
                dataData["dataSet"] = dataSetData;

            /*{
                dataSet: {
                    fields: formdata,
                    recordSets: {
                        grid: {
                            nc_list: filelist
                        },
                        grid2: {
                            nc_list: filelist
                        }
                    }
                }
            }*/
            
            return dataData;
        }
        ,
        //alopex.request 의 data 에 들어갈 데이터 객체를 생성하여 반환.
        //(참고) 폼이 아닌 그리드의 데이터는 추가,수정,삭제된 데이터만 참조함
        //@param  arg1, arg2, ...  폼ID, 그리드ID_1, 그리드ID_2, ... (참고) 속성에 data-bind="grid" 인 것이면 그리드로 인식함.
        //@since  2014-12-11
        getRequestDataUpdated : function() {
            var fieldsData = {}; // $.PSNMUtils.getFormData("form");
            var recordSetsData = {};

            for (var i=0; i<arguments.length; i++) {
                var elemId  = arguments[i];
                    elemId  = elemId.replace(/#/, "");

                var bindStr = $("#" + elemId).data("bind");
                _debug("getRequestDataUpdated", "elemId = [" + elemId + "]", "bind = [" + bindStr + "]");

                if ( $.PSNMUtils.isEmpty(bindStr) || bindStr.indexOf("grid")<0 ) {
                    fieldsData = jQuery.extend(fieldsData, $.PSNMUtils.getFormData(elemId));
                }
                else {
                    var arrDataEdited = $("#" + elemId).alopexGrid("dataGet", {_state:{edited:true}}); //,added:true,deleted:true
                    var arrDataAdded  = $("#" + elemId).alopexGrid("dataGet", {_state:{edited:false,added:true}});
                    var arrDataDeled  = $("#" + elemId).alopexGrid("dataGet", {_state:{edited:false,deleted:true}});
                    var arrDataUpdated = AlopexGrid.trimData(arrDataEdited); //변경된 데이터
                        arrDataUpdated = $.merge(arrDataUpdated, AlopexGrid.trimData(arrDataAdded) ); //추가
                        arrDataUpdated = $.merge(arrDataUpdated, AlopexGrid.trimData(arrDataDeled) ); //삭제
                    var gridData = {
                        nc_list: arrDataUpdated
                    };
                    recordSetsData[elemId] = gridData;
                }
            }
            var dataSetData = {};
                dataSetData["fields"] = fieldsData;
                dataSetData["recordSets"] = recordSetsData;
            var dataData = {};
                dataData["dataSet"] = dataSetData;
            return dataData;
        }
        ,
        //getRequestData()와 같으나, 폼데이터 값을 수집할떄 같은 name의 input이 있으면 값문자열을 콤마(,)로 연결함(@since 2015-02-12)
        //(주의) 이때 input의 id이 아닌 name으로 '키'를 구성함
        //@param    sFormId   {키,값}을 수집할 폼ID
        //@return   {키, 값}이 병합된 객체. 같은 키의 값이 있으면 값문자열을 콤마(,)로 연결함
        getRequestData2 : function() {
            var fieldsData = {};
            var recordSetsData = {};

            for (var i=0; i<arguments.length; i++) {
                var elemId  = arguments[i];
                var bindStr = $("#" + elemId).data("bind");

                if ( $.PSNMUtils.isEmpty(bindStr) || bindStr.indexOf("grid")<0 ) {
                    //fieldsData = jQuery.extend(fieldsData, $.PSNMUtils.getFormData(elemId));
                    fieldsData = $.PSNMUtils.mergeFormData(fieldsData, $.PSNMUtils.getFormData2(elemId));
                }
                else {
                    var gridData = {
                        nc_list: $("#" + elemId).alopexGrid("dataGet")
                    };
                    recordSetsData[elemId] = gridData;
                }
            }
            
            var dataSetData = {};
                dataSetData["fields"] = fieldsData;
                dataSetData["recordSets"] = recordSetsData;
                
            var dataData = {};
                dataData["dataSet"] = dataSetData;
            return dataData;
        }
        ,

        //
        //입력되는 공통코드 검색정보 1건에 대하여 공통코드를 조회하여 해당 배열로 반환
        //(참고) 이 공통코드 정보는 화면ELEMENT와 연동되지 않으므로, elemid는 입력하지 않고, codeid를 필수로 입력해야함.
        //
        //@param  oParam  공통코드 검색정보 (예) { t:'code', 'codeid' : 'DSM_RCV_TYP_CD', 'header' : '-전체-' }
        //@since  2014-12-15
        getCode : function(oParam) {
            if ( $.PSNMUtils.isEmpty(oParam) ) {  return; } //입력되는 파라미터가 없으면 여기서 반환
            _debug("getCode", "oParam", JSON.stringify(oParam));

            var _type    = $.PSNMUtils.isNotEmpty( oParam["type"] ) ? oParam["type"]  : "code"; 
            var _header  = oParam["header"];
            //var _elem_id = oParam["elemid"];
            var _code_id = oParam["codeid"]; //$.PSNMUtils.isNotEmpty( oParam["codeid"] ) ? oParam["codeid"]  : "DSM_" + _elem_id; 
            if ( $.PSNMUtils.isEmpty(_code_id) ) {
                _debug("getCode", "공통코드조회시 코드ID가 필요합니다!");
                $.PSNM.alert("공통코드조회시 코드ID가 필요합니다!");
                return; 
            }

            var _codedata_session = sessionStorage.getItem("psnm-code-" + _code_id);
            if ( $.PSNMUtils.isNotEmpty(_codedata_session) ) {
                var arrCodeList = JSON.parse(_codedata_session);
                _debug("getCode", "in sessionStorage", "코드ID=", _code_id, "코드길이=", arrCodeList.length);
                var arrCodes = $.PSNMUtils._getCodeDataForSelBox(_type, _header, arrCodeList);
                return arrCodes; 
            }

            var params = new Array();
                params.push(oParam);
            var _code_list = null;

            $.alopex.request('com.CODE@PCODE_pSearchCodesByList', { //com.CODE@PCODE_pSearchCodes
                url: _NOSESSION_REQ_URL,
                showProgress:false,
                async:false, //sync ###
                data: {
                    dataSet: {
                        recordSets: {
                            CODE_INFO_LIST : {
                                nc_list: params
                            }
                        }
                    }
                },
                success: function(res) {
                    var rsCodeList = res.dataSet.recordSets;
                    _code_list = rsCodeList[_code_id].nc_list; //코드ID로 응답됨.
                    sessionStorage.setItem("psnm-code-" + _code_id, JSON.stringify(_code_list)); //코드ID로 세션스토리지에 저장해둠!(로그아웃시 삭제함)
                    _debug("getCode", "SAVE in sessionStorage", "코드ID=", _code_id, "코드길이=", _code_list.length);
                }
            });
            var arrCodes2 = $.PSNMUtils._getCodeDataForSelBox(_type, _header, _code_list);
            return arrCodes2;
        } //end of "getCode"
        ,
        //입력되는 공통코드정보 배열을 참조하여 공통코드를 조회하여 해당 화면요소에 데이터를 설정함
        setCodeData : function(params, callback) {
            if ( $.PSNMUtils.isEmpty(params) ) {  return; } //입력되는 파라미터가 없으면 여기서 반환
            if ( ! $.isArray(params) ) {
                //$.PSNMUtils.setCodeDataById(params);
                //return;
            }
            _debug("<setCodeData> params :" + JSON.stringify(params));

            $.alopex.request('com.CODE@PCODE_pSearchCodesByList', { //com.CODE@PCODE_pSearchCodes
                url: _NOSESSION_REQ_URL,
                showProgress:false,
                async:false, //공통코드 조회는 sync로 조회함
                data: {
                    dataSet: {
                        //fields: {
                        //    COMM_CD_ID : _code_id_list
                        //}
                        recordSets: {
                            CODE_INFO_LIST : {
                                nc_list: params
                            }
                        }
                    }
                },
                success: function(res) {
                    var rsCodeList = res.dataSet.recordSets;

                    $.each(rsCodeList, function(key, codeDataSet) {
                        //alert(key + "\n\n" + JSON.stringify(codeDataSet)); //(key는 공통코드그룹ID == 'DSM_RCV_TYP_CD')
                        var _paramList = $.grep(params, function(e){ return e.elemid == key; }); //(주의) elemid 가 코드조회 레코드셋의 키
                        var _param = _paramList[0]; //ui에 id 임. 1개만 처리

                        var codeList = codeDataSet.nc_list;

                        var s = "<공통코드설정> 화면요소ID = [" + key + "]";
                            s+= "\n- 코드조회입력정보 : " +  JSON.stringify(_param);

                        var _type    = _param["t"]; //코드타입 : 없거나 code, org1~org4
                        var _elem_id = _param["elemid"];
                        var _header  = _param["header"];

                        //if ( $.PSNMUtils.isValueRequired(_elem_id) ) {
                        //    _header = '-선택-';
                        //}
                        //else {
                        //    _header = '-전체-';
                        //}

                        var _code_id  = $.PSNMUtils.isNotEmpty( _param["codeid"] )  ? _param["codeid"]  : "DSM_" + _elem_id;     //미설정이면 'DSM_' 접두어
                        var _data_key = $.PSNMUtils.isNotEmpty( _param["dataKey"] ) ? _param["dataKey"] : "options_" + _elem_id; //미설정이면 'options_' 접두어

                            s+= "\n- 코드그룹ID = [" + _code_id + "]";
                            s+= "\n- 조회된공통코드목록 : " +  JSON.stringify(codeList);
                        //_debug( s );

                        var codeOptions2 = $.PSNMUtils._getCodeDataForSelBox(_type, _header, codeList);
                        var optData = new Object();
                            optData[""+_data_key] = codeOptions2;

                        $("#" + _elem_id).setData(optData);
                    });

                    if ( $.PSNMUtils.isNotEmpty(callback) && typeof(callback) == "function"  ) {
                        //_debug("<setCodeData> callback function defined. 함수명 : " + callback + "");
                        callback.call(undefined, params, rsCodeList); //공통코드 데이터를 반환함!
                        return;
                    }
                }
            });
        } //end of "setCodeData"
        ,
        _getCodeDataForSelBox : function(_type, _header, _arrCodeList) {
            var codeOptions = [];

            if ( $.PSNMUtils.isNotEmpty(_header) ) {
                codeOptions.push({ value: "", text: _header});
            }
            $.each(_arrCodeList, function (index, codeinfo) {
                var codeOpt = new Object();
                if ( "org1"==_type ) { //'본사팀' 조직목록 조회
                    codeOpt["value"] = codeinfo.HDQT_TEAM_ORG_ID;
                    codeOpt["text"]  = codeinfo.HDQT_TEAM_ORG_NM;
                }
                else if ( "org2"==_type ) { //'본사파트' 조직목록 조회
                    codeOpt["value"] = codeinfo.HDQT_PART_ORG_ID;
                    codeOpt["text"]  = codeinfo.HDQT_PART_ORG_NM;
                }
                else if ( "org3"==_type ) { //'영업국' 조직목록 조회
                    codeOpt["value"] = codeinfo.SALE_DEPT_ORG_ID;
                    codeOpt["text"]  = codeinfo.SALE_DEPT_ORG_NM;
                }
                else if ( "org4"==_type ) { //'영업팀' 조직목록 조회
                    codeOpt["value"] = codeinfo.SALE_TEAM_ORG_ID;
                    codeOpt["text"]  = codeinfo.SALE_TEAM_ORG_NM;
                }
                else if ( "org5"==_type ) { //'에이전트' 조직목록 조회
                    codeOpt["value"] = codeinfo.SALE_AGNT_ORG_ID; //주의 :: 에이전트는 'ORG_' 아님!
                    codeOpt["text"]  = codeinfo.SALE_AGNT_ORG_NM;
                }
                else if ( "duty"==_type ) { //'직무' 코드목록 조회
                    codeOpt["value"] = codeinfo.DUTY_CD;
                    codeOpt["text"]  = codeinfo.DUTY_NM;
                }
                else { //디폴트 공통코드
                    codeOpt["value"] = codeinfo.COMM_CD_VAL;
                    codeOpt["text"]  = codeinfo.COMM_CD_VAL_NM;
                    //codeOpt["ADD_INFO_01"]  = codeinfo.ADD_INFO_01;
                }
                codeOptions.push(codeOpt);
            });
            return codeOptions;
        }
        ,
        
        //화면에서 디폴트 시작일자(1일) ~ 종료일자(마지막일)를 설정함
        setDefaultYmd : function(sFromDatepickerId, sToDatepickerId) {
            var today    = new Date();
            var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
            var lastDay  = new Date(today.getFullYear(), today.getMonth() + 1, 0);

            if ( $.PSNMUtils.isNotEmpty(sFromDatepickerId) ) {
                sFromDatepickerId = sFromDatepickerId.replace(/^#/, "");
                var fromYmd = firstDay.format("yyyy-mm-dd");
                $("#" + sFromDatepickerId).val(fromYmd);
            }
            if ( $.PSNMUtils.isNotEmpty(sToDatepickerId) ) {
                sToDatepickerId = sToDatepickerId.replace(/^#/, "");
                var toYmd = lastDay.format("yyyy-mm-dd");
                $("#" + sToDatepickerId).val(toYmd);
            }
        } //end of "setDefaultYmd"
        ,

        //화면에서 사용하는 디폴트 시작일자(1일) ~ 종료일자(마지막일)를 구하여 객체로 반환
        getDefaultFromToYmd : function() {
            var today    = new Date();
            var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
            var lastDay  = new Date(today.getFullYear(), today.getMonth() + 1, 0);
            
            var fromYmd = firstDay.format("yyyy-mm-dd");
            var toYmd = lastDay.format("yyyy-mm-dd");

            var oResult = new Object();
                oResult["FROM_DT"] = fromYmd;
                oResult["TO_DT"] = toYmd;
                oResult["TODAY_DT"] = today.format("yyyy-mm-dd");
            return oResult;
        }
        ,

        //지정된 그리드를 엑셀로 export 하여 엑셀파일 다운로드 처리함.
        exportGridExcel : function(sFromDatepickerId, sToDatepickerId) {
            var today    = new Date();
            var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
            var lastDay  = new Date(today.getFullYear(), today.getMonth() + 1, 0);

            if ( $.PSNMUtils.isNotEmpty(sFromDatepickerId) ) {
                sFromDatepickerId = sFromDatepickerId.replace(/^#/, "");
                var fromYmd = firstDay.format("yyyy-mm-dd");
                $("#" + sFromDatepickerId).val(fromYmd);
            }
            if ( $.PSNMUtils.isNotEmpty(sToDatepickerId) ) {
                sToDatepickerId = sToDatepickerId.replace(/^#/, "");
                var toYmd = lastDay.format("yyyy-mm-dd");
                $("#" + sToDatepickerId).val(toYmd);
            }
        } //end of "setDefaultYmd"
        ,

        // 
        // 엑셀 템플릿파일을 다운로드 함
        // (참고) 관련된 GRID를 생성하며, 이 템플릿그리드의 스키마와 엑셀IMPORT 그리드의 스키마 동일하게 유지함.
        // (참고) 템플릿GRID, IMPORT그리드 2개를 유지함(같은 스키마라고 하더라도 1개를 같이쓰지않고 따로 두도록 함)
        //
        //@param  sExcelTelmplateGridId 엑셀템플릿 파일과 연관된 grid의 요소ID(화면에서는 style='dispaly:none;' 으로 숨김)
        //@param  aExcelSampleData      엑셀템플릿 grid에 설정할 데이터(보통 1개 레코드의 배열형)
        //@param  oExcepMetaInfo        (optional) 다운로드 엑셀의 메타정보(다운로드파일명, 시트명)
        //@since  2014-12-05
        downloadExcelTemplate : function(sExcelTelmplateGridId, aExcelSampleData, oExcepMetaInfo) {
            if ( $.PSNMUtils.isEmpty(sExcelTelmplateGridId) ) {
                alert("엑셀 템플릿 파일과 연관된 grid 정보가 지정되지 않았습니다!");
                return;
            }
            if ( $.PSNMUtils.isEmpty(aExcelSampleData) ) {
                alert("엑셀 템플릿 파일의 샘플데이터가 없습니다!");
                return;
            }
            if ( !jQuery.isArray(aExcelSampleData) ) {
                alert("엑셀 템플릿 파일의 샘플데이터 형식이 다릅니다!");
                return;
            }
            var gridname = sExcelTelmplateGridId.replace(/^#/, "");
            sExcelTelmplateGridId = "#" + gridname; //디폴트 "#gridexceltemplate"

            _debug("<PSNMUtils.downloadExcelTemplate> 엑셀템플릿GRID : '" + sExcelTelmplateGridId + "\n\tDATA(배열필수) : " + JSON.stringify(aExcelSampleData) + "");

            $(sExcelTelmplateGridId).alopexGrid("dataSet", aExcelSampleData); //"#gridexceltemplate"

            var columnList = $(sExcelTelmplateGridId).alopexGrid("columnGet");
            var dataList   = AlopexGrid.trimData( $(sExcelTelmplateGridId).alopexGrid("dataGet") );
            _debug("<PSNMUtils.downloadExcelTemplate>\n\tCOLS(AlopexGrid) : " + JSON.stringify(columnList) + "\n\tDATA(AlopexGrid) : " + JSON.stringify(dataList));

            var colKey  = "";
            var colName = "";

            $.each(columnList, function (index, columnInfo) {
                if (index>0) {
                    colKey  += ",";
                    colName += ",";
                }
                colKey  += "" + columnInfo["key"];
                colName += "" + columnInfo["title"];
            });
            _debug("<PSNMUtils.downloadExcelTemplate> KEY=[" + colKey + "], TITLE=[" + colName + "]");

            var today = new Date();

            if ( $.PSNMUtils.isEmpty(oExcepMetaInfo) ) {
                oExcepMetaInfo = new Object();
                oExcepMetaInfo["filename"]  = "PSNM_EXCEL_" + today.format("yyyymmdd") + ".xls"; //디폴트 다운로도 엑셀파일명
                oExcepMetaInfo["sheetname"] = "template";
                oExcepMetaInfo["gridname"]  = gridname; //"gridexceltemplate"
            }
            if ( $.PSNMUtils.isEmpty(oExcepMetaInfo["gridname"]) ) {
                oExcepMetaInfo["gridname"]  = gridname; //"gridexceltemplate"
            }
            _debug("<PSNMUtils.downloadExcelTemplate> 엑셀메타정보 : " + JSON.stringify(oExcepMetaInfo) + "");

            var excelMetaInfo = new Array();
                excelMetaInfo.push(oExcepMetaInfo);

            var encodedMeta   = encodeURIComponent(JSON.stringify(excelMetaInfo));
            var encodedColMap = encodeURIComponent(JSON.stringify(columnList));
            var encodedData   = encodeURIComponent(JSON.stringify(dataList)); //dataList | aExcelSampleData

            var g = "";
                g += '<form name="exportform" action="' + _CTX_PATH + 'psnmExcel.jsp" method="post">';
                g += '<input type="hidden" name="metaInfo"            value="' + encodedMeta   + '">';
                g += '<input type="hidden" name="' +gridname+ '_cols" value="' + encodedColMap + '">'; //gridexceltemplate_cols
                g += '<input type="hidden" name="' +gridname+ '_data" value="' + encodedData   + '">'; //gridexceltemplate_data
                g += "</form>";
                g += "<script>document.exportform.submit();<\/script>";
    
            var doc = $('#footer-hidden-iframe')[0].contentWindow.document;
                doc.open();
                doc.write(g);
                doc.close();
        } //endof-function
        ,

        // 
        // 엑셀 템플릿파일에 채워진 엑셀 데이터파일을 업로드하고
        // 지정된 그리드에 엑셀 데이터를 채우며, 업무에서 추가작업을 위해 콜백함수를 호출함
        // (참고) 템플릿grid, 데이터grid 가 화면에 있으며 2개의 grid 스키마는 동일함(보통은 화면에서 보이지 않도록 함)
        //
        //@param  sFileInputId       파일입력요소ID
        //@param  sExcelImportGridId 엑셀import 시 필요한 grid의 요소ID(화면에서는 style='dispaly:none;' 으로 숨김)
        //@param  callback           콜백함수 지정. 엑셀파일을 업로드 완료후 각 업무에서 추가 작업하기 위한 콜백. arg1에 grid 데이터를 반환
        //@since  2014-12-05
        setExcelUploadImport : function(sFileInputId, sExcelImportGridId, callback) {
            if  ( $.PSNMUtils.isEmpty(sFileInputId) ) {
                sFileInputId = "excelupload";
            }
            if  ( $.PSNMUtils.isEmpty(sExcelImportGridId) ) {
                sExcelImportGridId = "gridexcelimported";
            }
            sFileInputId       = "#" + sFileInputId.replace(/^#/, "");       //디폴트 "#excelupload"
            sExcelImportGridId = "#" + sExcelImportGridId.replace(/^#/, ""); //디폴트 "#gridexcelimported"

            _debug("<PSNMUtils.setExcelUploadImport> 엑셀첨부파일 : input file 객체ID = [" + sFileInputId + "], 엑셀GRID아이디 = [" + sExcelImportGridId + "]");

            var columnList = $(sExcelImportGridId).alopexGrid("columnGet"); //[{"columnIndex":0,"key":"RN","title":"번호","align":"center","width":"40px"},{"columnIndex":1,"key":"ANNCE_ID",
            //var encodedColMap = encodeURIComponent(JSON.stringify(columnList));
            _debug("<PSNMUtils.setExcelUploadImport> 엑셀import grid칼럼 정보\n\t" + JSON.stringify(columnList));

            //엑셀 파일 업로드 컴포넌트 설정
            $(sFileInputId).fileupload({
                dataType: 'json',
                url : _EXCEL_IMPORT_URL, /* 엑셀 import 는 파일 업로드를 저장하지 않음! */
                done: function (e, data) {
                    var parsedListData = data.result;
                    _debug("<PSNMUtils.setExcelUploadImport> 업로드된데이터레코드:\n\t" + JSON.stringify(parsedListData));
                    var keyChangedList = [];

                    //(예) [{"번호":"1","공지사항ID":"1234567890","공지대상":"전에이전트","제목":"공지사항제목입니다.","조회수":"1","게시일":"2014-12-04"},{"번호":"2","공지사항ID":"1234567891","공지대상":"전에이전트","제목":"공지사항제목입니다. 222222222","조회수":"1","게시일":"41978"}] 
                    $.each(data.result, function (index, excelRecord) {
                        var keyChangedRecord = {};

                        for(keyTitle in excelRecord) { //여기의 key는 한글명(title)
                            var keyKey = "";
                            for(var i=0; i<columnList.length; i++) {
                                if ( keyTitle == columnList[i].title ) { //(예)"title":"번호"
                                    keyKey = columnList[i].key; //(예)"key":"RN"
                                    break;
                                }
                            }
                            keyChangedRecord[""+keyKey] = excelRecord[keyTitle]; //새로운 키(RN)으로 기존값(1)을 저장
                        }
                        keyChangedList.push(keyChangedRecord);
                    });
                    _debug("<PSNMUtils.setExcelUploadImport> 업로드된데이터레코드 키변경:\n\t" + JSON.stringify(keyChangedList));

                    //$(sExcelImportGridId).alopexGrid("dataSet", keyChangedList); //@since 2015-02-25

                    if ( $.PSNMUtils.isNotEmpty(callback) && typeof(callback) == "function"  ) {
                        _debug("<PSNMUtils.setExcelUploadImport> callback function defined. 함수명 : " + callback.name + "");
                        callback.call(undefined, keyChangedList);
                        return;
                    }
                    else {
                        $(sExcelImportGridId).alopexGrid("dataSet", keyChangedList); //@since 2015-02-25
                    }
                }
            //}).bind('fileuploadsubmit', function (e, data) { data.formData = { };
            })
            .on('fileuploadsend', function (e, data) { _debug(".....엑셀파일IMPORT시작....."); document.body.style.cursor = 'wait'; })
            .on('fileuploaddone', function (e, data) { _debug(".....엑셀파일IMPORT완료....."); document.body.style.cursor = 'default'; })
            ;
        }
        ,

        // 
        // 현재 지정된 GRID의 데이터를 엑셀 파일로 다운로드 함
        //
        //@param  sGridId         엑셀템플릿 파일과 연관된 grid의 화면요소ID(화면에서는 style='dispaly:none;' 으로 숨김)
        //@param  oExcepMetaInfo  (optional) 다운로드 엑셀의 메타정보(다운로드파일명, 시트명) (예) { filename  : "공지사항목록.xls", sheetname : "공지사항목록", gridname  : "grid" }
        //@since  2014-12-08
        //
        downloadExcelPage : function(sGridId, oExcepMetaInfo, aFilterIndex) {
            if ( $.PSNMUtils.isEmpty(sGridId) ) {
                alert("엑셀로 저장할 그리드가 지정되지 않았습니다!");
                return;
            }
            sGridId = "#" + sGridId.replace(/^#/, ""); //디폴트 "#excelupload"
            var _grid_id = sGridId.replace(/^#/, "");

            if ( $.PSNMUtils.isEmpty(oExcepMetaInfo) ) {
                var today = new Date();
                oExcepMetaInfo = new Object();
                oExcepMetaInfo["filename"]  = "PSNM_EXCEL_" + today.format("yyyymmdd") + ".xls"; //디폴트 다운로도 엑셀파일명
                oExcepMetaInfo["sheetname"] = "데이터";
                oExcepMetaInfo["gridname"]  = sGridId.replace(/^#/, "");
            }
            _debug("<PSNMUtils.downloadExcelPage> 엑셀메타정보 : " + JSON.stringify(oExcepMetaInfo) + "");

            var columnList = $( sGridId ).alopexGrid("columnGet");
                //필요할 칼럼항목만 전달함.
                var newColumnList = [];
                for(var i=0; i<columnList.length; i++) {
                    var columnInfo = $.PSNMUtils.trimColumnMappingInfo( columnList[i] );
                    _debug("<PSNMUtils.downloadExcelAll> 칼럼정보[" +i+ "] : " + JSON.stringify(columnInfo) + "");
                    var doFilter = false;
                    if ( null!=aFilterIndex && aFilterIndex.length>0 ) {
                        for(var j=0; j<aFilterIndex.length; j++) {
                            //_debug("<PSNMUtils.downloadExcelAll> - [" + aFilterIndex[j] + "] ==? [" + columnInfo["columnIndex"] + "]");
                            if ( aFilterIndex[j] == columnInfo["columnIndex"] ) {
                                doFilter = true;
                                break;
                            }
                        }
                    }
                    if (!doFilter) {
                        newColumnList.push(columnInfo);
                    }
                    else {
                        _debug("<PSNMUtils.downloadExcelAll> - column[" + i + "] filtered!");
                    }
                }
                columnList = newColumnList;
            var dataList   = AlopexGrid.trimData( $(sGridId).alopexGrid("dataGet") );
            _debug("<PSNMUtils.downloadExcelPage> 칼럼정보 : " + JSON.stringify(columnList) + "");
            //alert("headerGroupData : [" + JSON.stringify( $("#grid").alopexGrid('readOption').headerGroup )  + "]");
    
            var colKey  = "";
            var colName = "";

            $.each(columnList, function (index, columnInfo) {
                delete columnInfo["editable"];
                delete columnInfo["render"];
                if (index>0) {
                    colKey  += ",";
                    colName += ",";
                }
                colKey  += "" + columnInfo["key"];
                colName += "" + columnInfo["title"];
            });

            var arrExcelMetaInfos = [];
                arrExcelMetaInfos.push( oExcepMetaInfo );

            var encodedMeta   = encodeURIComponent(JSON.stringify(arrExcelMetaInfos));
            var encodedColMap = encodeURIComponent(JSON.stringify(columnList));
            var encodedData   = encodeURIComponent(JSON.stringify(dataList));

            var g = "";
                g += '<form name="exportform" action="' + _CTX_PATH + 'psnmExcel.jsp" method="post">';
                g += '<input type="hidden" name="metaInfo"  value="' + encodedMeta + '">';
                g += '<input type="hidden" name="' + _grid_id + '_cols" value="' + encodedColMap + '">';
                g += '<input type="hidden" name="' + _grid_id + '_data" value="' + encodedData + '">';
                g += "</form>";
                g += "<script>document.exportform.submit();<\/script>";
    
            var doc = $('#footer-hidden-iframe')[0].contentWindow.document;
                doc.open();
                doc.write(g);
                doc.close();
        }
        ,

        // 
        // 현재 지정된 GRID의 데이터를 엑셀 파일로 다운로드 함
        // (주의) 거래를 처리하는 PU에서는 해당 그리드ID로 결과셋을 저장하여 반환해야 함.
        //
        //@param  sFormId         데이터를 조회하기 위한 폼의 화면요소ID
        //@param  sTrnxId         데이터를 조회하기 위한 넥스코어 거래ID
        //@param  sGridId         엑셀의 칼럼정보를 참조하기 위한 GRID의 ID
        //@param  oExcepMetaInfo  (optional) 다운로드 엑셀의 메타정보(다운로드파일명, 시트명) 
        //                        (예) { filename  : "공지사항목록.xls", sheetname : "공지사항목록", gridname  : "grid" }
        //@since  2014-12-08
        //
        downloadExcelAll : function(sFormId, sTrnxId, sGridId, oExcelMetaInfo, aFilterIndex) {
            if ( $.PSNMUtils.isEmpty(sFormId) ) {
                alert("엑셀 데이터 검색을 위한 폼이 지정되지 않았습니다!");
                return;
            }
            if ( $.PSNMUtils.isEmpty(sTrnxId) ) {
                alert("조회를 위한 거래ID 정보가 지정되지 않았습니다!");
                return;
            }
            if ( $.PSNMUtils.isEmpty(sGridId) ) {
                alert("관련된 그리드가 지정되지 않았습니다!");
                return;
            }
            sFormId = "#" + sFormId.replace(/^#/, "");
            sGridId = "#" + sGridId.replace(/^#/, "");
            _debug("<PSNMUtils.downloadExcelAll> 폼ID = [" + sFormId + "], 거래ID = [" + sTrnxId + "], 그리드ID = [" + sGridId + "]");

            if ( $.PSNMUtils.isEmpty(oExcelMetaInfo) ) {
                var today = new Date();
                oExcelMetaInfo = new Object();
                oExcelMetaInfo["filename"]  = "PSNM_EXCEL_" + today.format("yyyymmdd") + ".xls"; //디폴트 다운로도 엑셀파일명
                oExcelMetaInfo["sheetname"] = "데이터";
                oExcelMetaInfo["gridname"]  = sGridId.replace(/^#/, "");
            }
            _debug("<PSNMUtils.downloadExcelAll> 엑셀메타정보 : " + JSON.stringify(oExcelMetaInfo) + "");

            var columnList = $( sGridId ).alopexGrid("columnGet");
            //if ( null!=aFilterIndex && aFilterIndex.length>0 ) {
                var newColumnList = [];
                for(var i=0; i<columnList.length; i++) {
                    var columnInfo = $.PSNMUtils.trimColumnMappingInfo( columnList[i] );
                    _debug("<PSNMUtils.downloadExcelAll> 칼럼정보[" +i+ "] : " + JSON.stringify(columnInfo) + "");
                    var doFilter = false;
                    if ( null!=aFilterIndex && aFilterIndex.length>0 ) {
                        for(var j=0; j<aFilterIndex.length; j++) {
                            //_debug("<PSNMUtils.downloadExcelAll> - [" + aFilterIndex[j] + "] ==? [" + columnInfo["columnIndex"] + "]");
                            if ( aFilterIndex[j] == columnInfo["columnIndex"] ) {
                                doFilter = true;
                                break;
                            }
                        }
                    }
                    if (!doFilter) {
                        newColumnList.push(columnInfo);
                    }
                    else {
                        _debug("<PSNMUtils.downloadExcelAll> - column[" + i + "] filtered!");
                    }
                }
                columnList = newColumnList;
            //}
            //var dataList   = AlopexGrid.trimData( $(sGridId).alopexGrid("dataGet") );
            _debug("<PSNMUtils.downloadExcelAll> 칼럼정보 : " + JSON.stringify(columnList) + "");
            //alert("headerGroupData : [" + JSON.stringify( $("#grid").alopexGrid('readOption').headerGroup )  + "]");

            var formdata = $.PSNMUtils.getFormData( sFormId.replace(/^#/, "") );
                formdata.page = 1;
                formdata.page_size = 50000; //(참고) 기존 목록 조회 함수 재사용을 위해서 페이지 사이즈 최대 1000건 지정 //$("#grid .perPage").val();
            _debug("<PSNMUtils.downloadExcelAll> 조회조건 : " + JSON.stringify(formdata));    

            var arrExcelMetaInfos = [];
                arrExcelMetaInfos.push( oExcelMetaInfo );
    
            var encodedMeta   = encodeURIComponent(JSON.stringify(arrExcelMetaInfos));
            var encodedColMap = encodeURIComponent(JSON.stringify(columnList));

            var g = "";
                g += '<form name="exportform" action="' + _CTX_PATH + 'psnm.cmd" target="_self" method="post">'; //
                g += '<input type="hidden" name="nc_trId"   value="' + sTrnxId + '">';
                g += '<input type="hidden" name="nc_target" value="forward:/psnmExcelAll.jsp">';
                g += '<input type="hidden" name="metaInfo"  value="' + encodedMeta + '">';
                g += '<input type="hidden" name="' + (sGridId.replace(/^#/, "")) + '_cols" value="' + encodedColMap + '">'; //(주의) mygridid_cols

            for(var key in formdata) {
                g += '<input type="hidden" name="' + key + '" value="' + formdata[key] + '">';
            }
                g += "</form>";
                g += "<script>document.exportform.submit();<\/script>";

            var doc = $('#footer-hidden-iframe')[0].contentWindow.document;
                doc.open();
                doc.write(g);
                doc.close();
        }
        ,
        // 엑셀다운로드를 위해서 칼럼매핑정보중 {columnIndex, key, title, align, width, hidden } 정보만 추출함
        //{"columnIndex":4,"key":"MENU_NM","title":"메뉴명","align":"left","width":"160px","editable":{"type":"text"}} 
        //(예) {"columnIndex":2,"key":"ANNCE_ID","title":"공지사항ID","align":"center","width":"80px"}
        trimColumnMappingInfo : function(oColumnInfo) {
            if (null==oColumnInfo) return null;
            var oNewColInfo = {};
            var ttl = oColumnInfo["title"];
            if (null==ttl) { ttl = oColumnInfo["key"]; }
            if (null==ttl) { ttl = "" }
                ttl = ttl.replace(/(<([^>]+)>)/ig,"");
            oNewColInfo["columnIndex"] = oColumnInfo["columnIndex"];
            oNewColInfo["key"]         = oColumnInfo["key"];
            oNewColInfo["title"]       = ttl; //HTML태그제거 //oColumnInfo["title"];
            oNewColInfo["align"]       = oColumnInfo["align"];
            oNewColInfo["width"]       = oColumnInfo["width"];
            oNewColInfo["hidden"]      = oColumnInfo["hidden"];
            return oNewColInfo;
        }
        ,
        // 그리드의 데이터가 변경되었는지 판단하여 정수로 반환
        isGridDataChanged : function(sGridId) {
            var gridid = sGridId.replace(/#/, "");
            var list = $("#" + gridid).alopexGrid("dataGet", {_state:{edited:true}});
            var cnt = (null==list ? -1 : list.length);
            _debug("isGridDataChanged", "cnt", cnt);
            return cnt; //1이상=변경된 데이터 있음, 0=변경된 데이터 없음, -1=그리드없음
        }
        ,
        // 그리드의 데이터가 '추가'되었는지 판단하여 정수로 반환
        isGridDataRowAdded : function(sGridId) {
            var gridid = sGridId.replace(/#/, "");
            var list = $("#" + gridid).alopexGrid("dataGet", {_state:{added:true}});
            var cnt = (null==list ? -1 : list.length);
            return cnt; //1이상=추가된 데이터 있음, 0=추가된 데이터 없음, -1=그리드없음
        }
        ,
        // 그리드의 데이터가 '삭제'되었는지 판단하여 정수로 반환
        isGridDataRowDeleted : function(sGridId) {
            var gridid = sGridId.replace(/#/, "");
            var list = $("#" + gridid).alopexGrid("dataGet", {_state:{deleted:true}});
            var cnt = (null==list ? -1 : list.length);
            return cnt; //1이상=삭제된 데이터 있음, 0=삭제된 데이터 없음, -1=그리드없음
        }
        ,
        // 그리드 데이터 행수를 정수로 반환
        getGridRowCount : function(sGridId) {
            var gridid = sGridId.replace(/#/, "");
            var list = $("#" + gridid).alopexGrid("dataGet");
            var cnt = (null==list ? -1 : list.length);
            return cnt;
        }
        ,
        // 그리드의 지정된 칼럼에서 최대값을 구하여 반환(참고 : 해당 칼럼데이터는 숫자형이어야 함)
        getGridDataMaxValue : function(sGridId, sColumnId) {
            var gridid = sGridId.replace(/#/, "");
            var list = $("#" + gridid).alopexGrid("dataGet");
            var cnt = (null==list ? -1 : list.length);
            if (cnt<1) {
                _debug("getGridDataMaxValue", "데이터 없음!", cnt);
                return null;
            }
            var maxValue = 0;
            for(var i=0; i<cnt; i++) {
                var oRecord = list[i];
                var sValue  = oRecord[""+sColumnId];
                var fValue  = parseFloat( sValue );
                if (0==i) {
                    maxValue = sValue;
                    continue;
                }
                if ( !isNaN(fValue) && maxValue<fValue ) {
                    maxValue = sValue;
                }
            }
            return maxValue; //
        }
        ,

        // 그리드의 지정된 칼럼을 전체 탐색하여 배열로 반환
        getGridColumnData : function(sGridId, sColumnId) {
            var gridid = sGridId.replace(/#/, "");
            var list = $("#" + gridid).alopexGrid("dataGet");
            var cnt = (null==list ? -1 : list.length);
            if (cnt<1) {
                return []; //빈 배열을 반환
            }
            var arrColumnData = [];
            for(var i=0; i<cnt; i++) {
                var oRecord = list[i];
                arrColumnData.push( oRecord[""+sColumnId] );
            }
            return arrColumnData;
        }
        ,
        
        //모바일 브라우저로 접속한지 여부 (@since 2014-12-23)
        isMobile : function()  {
            var mobilePhones = ['iphone','ipad','ipod','ios','android','blackberry','windows ce','windows phone','nokia','webos','opera mini','opera mobi','polaris','sonyericsson','iemobile','lgtelecom'];
    //if (userAgent.match(/iphone|ipod|ios|ipad|android|windows ce|blackberry|symbian|windows phone|webos|opera mini|opera mobi|polaris|iemobile|lgtelecom|nokia|sonyericsson/i) != null || userAgent.match(/lg|samsung/) != null) {
            
            var uAgent = navigator.userAgent.toLowerCase();
            for(var i=0; i<mobilePhones.length; i++){
                if (uAgent.indexOf(mobilePhones[i]) != -1){
                    return true;
                } 
            }
            return false;
        }
        ,

        //엘레멘트의 입력값이 필수인지 판단 : 필수이면 true를 반환 (@since 2015-01-27)
        isValueRequired : function(sElemId) {
            sElemId = sElemId.replace(/#/, "");
            //var validator = $("#" + sElemId).validator();
            var sValidRule = $("#" + sElemId).data("validation-rule");
            var bIsReq = false;
            if ( $.PSNMUtils.isNotEmpty(sValidRule) && sValidRule.indexOf('required')>=0 ) {
                bIsReq = true;
            }
            _debug("[" + sElemId + "] isValueRequired = " + bIsReq);
            return bIsReq;
        }
        ,

        //select 상자에 디폴트로 '-선택-' 또는 '-전체-'를 표시함 (@since 2015-01-27)
        //(참고) 필수입력값, 즉 validation-rule이 설정된 select 상자는 '-선택-'을 표시, 아니면 '-전체-'를 표시
        //(주의) 이 함수로 설정되는 select 상자는 options 데이터가 설정되기 전에 디플트 1건만 표시되는 것임.
        setSelectDefaultPlaceHolder : function(sElemId, sOptionsName) {
            if ( $.PSNMUtils.isEmpty(sElemId) ) {
                return;
            }

            var _default_options_ = [ { value: "", text: "-선택-"} ];
            var _stxt = "-선택-";
            //$('#SALE_TEAM_ORG_ID').setData({options_SALE_TEAM_ORG_ID : _default_options_}).setSelected("-선택-");
            if ( $.PSNMUtils.isEmpty(sOptionsName) ) {
                sOptionsName = "options_" + sElemId;
            }

            if ( ! $.PSNMUtils.isValueRequired(sElemId) ) {
                _default_options_ = [ { value: "", text: "-전체-"} ];
                _stxt = "-전체-";
            }
            
            var param = new Object();
                param[sOptionsName] = _default_options_;

            $('#' + sElemId).setData(param).setSelected(_stxt);
        }
        ,

        //grid에서 전체 또는 지정된 상태의 raw 데이터를 배열로 추출하여 반환(@since 2015-01-28)
        //@param    sGridId     그리드ID(문자열)
        //@param    bTrim       데이터 트림 여부(boolean)
        //@param    sRestrictStateName     데이터를 제한할 상태(문자열) : (예) "added"
        getUpdatedGridArrData : function(sGridId, bTrim, sRestrictStateName) {
            if ( $.PSNMUtils.isEmpty(sGridId) ) {
                return null;
            }
            sGridId = sGridId.replace(/#/, "");

            var addedArrData   = $("#" + sGridId).alopexGrid("dataGet", {_state:{added:true}});   //추가
            var deletedArrData = $("#" + sGridId).alopexGrid("dataGet", {_state:{deleted:true}}); //삭제
            var editedArrData  = $("#" + sGridId).alopexGrid("dataGet", {_state:{edited:true}});  //편집

            if ( $.PSNMUtils.isNotEmpty(bTrim) && true===bTrim ) { //데이터 트림
                addedArrData   = AlopexGrid.trimData( addedArrData );
                deletedArrData = AlopexGrid.trimData( deletedArrData );
                editedArrData  = AlopexGrid.trimData( editedArrData );
            }

            var updatedArrData = [];
            _debug("getUpdatedGridArrData", "addedArrData=" + addedArrData.length, "deletedArrData=" + deletedArrData.length, "editedArrData=" + editedArrData.length);

            if ( $.PSNMUtils.isEmpty(sRestrictStateName) ) { //추가, 삭제, 편집된 데이터 전체
                updatedArrData = $.merge(updatedArrData, addedArrData);
                updatedArrData = $.merge(updatedArrData, deletedArrData);
                updatedArrData = $.merge(updatedArrData, editedArrData);
            }
            else {
                if ( sRestrictStateName.indexOf("added") >= 0 ) {
                    updatedArrData = $.merge(updatedArrData, addedArrData); //추가 데이터
                }
                if ( sRestrictStateName.indexOf("deleted") >= 0 ) {
                    updatedArrData = $.merge(updatedArrData, deletedArrData); //삭제 데이터
                }
                if ( sRestrictStateName.indexOf("edited") >= 0 ) {
                    updatedArrData = $.merge(updatedArrData, editedArrData); //편집 데이터
                }
            }
            return updatedArrData;
        }
        ,
        
        getMaskedName : function(sName) {
            if ( $.PSNMUtils.isEmpty(sName) ) return sName;
            var mName = sName.charAt(0);
            for(var i=1, len=sName.length-1; i<len; i++) {
                mName+= "*";
            }
            mName+= ( 2==sName.length ? "*" : sName.charAt(sName.length-1) );
            return mName;
        }
        ,

        //보통 년월일[시분초](yyyyMMdd[HHmmss]) 문자열을 일정한 형식으로 포맷팅한 문자열을 반환(@since 2015-02-11)
        //@param    sOrODate    포맷팅할 데이트객체 또는 년월일[시분초](yyyyMMdd[HHmmss]) 문자열
        //@param    sFormatType 포맷팅 양식(예, "yyyy-mm-dd"(디폴트), 'yyyy-mm-dd HH:MM:ss')
        //@return   포맷팅된 날짜[시각] 문자열
        getFormatedDate : function(sOrODate, sFormatType) {
            if ( 'string' == typeof sOrODate && isNaN(sOrODate) ) {
                return sOrODate;
            }
            if ( $.PSNMUtils.isEmpty(sFormatType) ) {
                sFormatType = "yyyy-mm-dd";
            }
            var dateDate = null;

            if ( $.PSNMUtils.isEmpty(sOrODate) ) {
                dateDate = new Date();
            }
            else {
                if ( 'string' == typeof sOrODate ) {
                    var st = sOrODate.replace(/ /, "");
                        st = st.replace(/-/, "");
                        st = st.replace(/:/, "");
                        st = st.replace(/T/, "");
                    var yy = 1970;
                    var mm = 1;
                    var dd = 1;
                    var hh = 0;
                    var nn = 0;
                    var ss = 0;

                    switch(st.length) {
                        case 14: ss = st.substring(12, 14);
                        case 12: nn = st.substring(10, 12);
                        case 10: hh = st.substring(8, 10);
                        case 8 : dd = st.substring(6, 8);
                        case 6 : mm = st.substring(4, 6);
                        case 4 : yy = st.substring(0, 4);
                        default :
                            break;
                    }
                    mm--;
                    dateDate = new Date(yy, mm, dd, hh, nn, ss);
                }
                else {
                    dateDate = sOrODate;
                }
            }

            return dateDate.format(sFormatType);;
        }
        ,

        //2객체의 값을 병합함. 같은 키의 값이 있으면 값문자열을 콤마(,)로 연결함(@since 2015-02-12)
        //@param    target   병합할 객체(Object) 1. {키,값} 형태만 가능하며, 값이 또 객체인 경우(deep 수준)은 지원안함
        //@param    param    병합할 객체(Object) 2. {키,값} 형태만 가능하며, 값이 또 객체인 경우(deep 수준)은 지원안함
        //@return   병합할 객체로 같은 키의 값이 있으면 값문자열을 콤마(,)로 연결함
        mergeFormData : function(target, param) {
            //jQuery.extend(fieldsData, $.PSNMUtils.getFormData(elemId));
            if ( !(target instanceof Object) || !(param instanceof Object) ) {
                return null;
            }
            if ( null==target || undefined==target ) {
                return param;
            }

            var oCopied = target;
            for (var attr in param) {
                if ( oCopied.hasOwnProperty(attr) ) {
                    oCopied[attr] = oCopied[attr] + "," + param[attr];
                }
                else {
                    oCopied[attr] = param[attr];
                }
            }
            return oCopied;
        }
        ,

        //폼 또는 화면에서 CK에디터로 지정된 textarea의 ID를 문자열로 반환(@since 2015-03-02)
        //@param    sFormId  지정된 폼, 없으면 화면 전체어서 찾음
        //@return   CK에디터로 지정된 textarea의 ID
        getWebEditorId : function(sFormId) {
            var ta; //sFileGridId  = "#" + sFileGridId.replace(/^#/, ""); //$("#sub-menu-div #sub-menu-dropdown-" + topMenuId).length < 1
            
            if ( $.PSNMUtils.isEmpty(sFormId) ) {
                ta = $("textarea:eq(0)");
            }
            else {
                var fid = "#" + sFormId.replace(/^#/, "");
                ta = $("#"+fid + " textarea:eq(0)");
            }
            if (null==ta) return null;
            var taId = $(ta).attr("id");
            if ( $("#cke_" + taId).length == 1 ) {
                return taId;
            }
            return "";
        }
        ,

        getFormatedFileSize : function(filesize) {
            var kb = 0.0, mb = 0.0;
            
            try {
                kb = Math.round(filesize/1024);
            }
            catch(E) {
                kb = 0.0;
            }
            if (kb<=0.0) {
                return filesize; //입력값 오류시 그대로 반환
            }

            if (kb<1024.0) {
                return kb.toFixed(1) + " KB";
            }

            mb = Math.round(kb/1024);

            return mb.toFixed(1) + " MB";
        }
        ,
        // 프린트
        getPrint : function(){
        	var print;
    		for (var i=0; i<arguments.length; i++) {
        		if(i == 0) print = $("#"+arguments[i]).clone();
        		if(i != 0) {
        			var sub = $("#"+arguments[i]).clone();
        			$(sub).find("#cmntBtn").hide();
        			print.append($(sub).html());
        		}
        	}
        	
			$(print).printElement({
        		printMode: 'popup'
				, overrideElementCSS:['/css/psnm-layout.css'
				                      , '/css/psnm-alopex-ui.css'
				                      , '/css/psnm-alopex-grid.css'
				                      , '/css/psnm-default.css']
        	});
        }
        ,
        //숫자(ex: 12,345)
        numberformat : function(numstr) {
        	var reg = /(\d+)(\d{3})/;
      	  	if (reg.test(numstr)){
      	  		return numstr.replace(reg,function(str,$1,$2){ return $.PSNMUtils.numberformat($1) + "," + $2 });
      	  	}else return numstr;
      	}
    }
    ;
    //end of [$.PSNMUtils = {]

})(jQuery);


/*
 * Date Format 1.2.3
 * (c) 2007-2009 Steven Levithan <stevenlevithan.com>
 * MIT license
 *
 * Includes enhancements by Scott Trenda <scott.trenda.net>
 * and Kris Kowal <cixar.com/~kris.kowal/>
 *
 * Accepts a date, a mask, or a date and a mask.
 * Returns a formatted version of the given date.
 * The date defaults to the current date/time.
 * The mask defaults to dateFormat.masks.default.
 */
var dateFormat = function () {
	var	token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
		timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
		timezoneClip = /[^-+\dA-Z]/g,
		pad = function (val, len) {
			val = String(val);
			len = len || 2;
			while (val.length < len) val = "0" + val;
			return val;
		};

	// Regexes and supporting functions are cached through closure
	return function (date, mask, utc) {
		var dF = dateFormat;

		// You can't provide utc if you skip other args (use the "UTC:" mask prefix)
		if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
			mask = date;
			date = undefined;
		}

		// Passing date through Date applies Date.parse, if necessary
		date = date ? new Date(date) : new Date;
		if (isNaN(date)) throw SyntaxError("invalid date");

		mask = String(dF.masks[mask] || mask || dF.masks["default"]);

		// Allow setting the utc argument via the mask
		if (mask.slice(0, 4) == "UTC:") {
			mask = mask.slice(4);
			utc = true;
		}

		var	_ = utc ? "getUTC" : "get",
			d = date[_ + "Date"](),
			D = date[_ + "Day"](),
			m = date[_ + "Month"](),
			y = date[_ + "FullYear"](),
			H = date[_ + "Hours"](),
			M = date[_ + "Minutes"](),
			s = date[_ + "Seconds"](),
			L = date[_ + "Milliseconds"](),
			o = utc ? 0 : date.getTimezoneOffset(),
			flags = {
				d:    d,
				dd:   pad(d),
				ddd:  dF.i18n.dayNames[D],
				dddd: dF.i18n.dayNames[D + 7],
				m:    m + 1,
				mm:   pad(m + 1),
				mmm:  dF.i18n.monthNames[m],
				mmmm: dF.i18n.monthNames[m + 12],
				yy:   String(y).slice(2),
				yyyy: y,
				h:    H % 12 || 12,
				hh:   pad(H % 12 || 12),
				H:    H,
				HH:   pad(H),
				M:    M,
				MM:   pad(M),
				s:    s,
				ss:   pad(s),
				l:    pad(L, 3),
				L:    pad(L > 99 ? Math.round(L / 10) : L),
				t:    H < 12 ? "a"  : "p",
				tt:   H < 12 ? "am" : "pm",
				T:    H < 12 ? "A"  : "P",
				TT:   H < 12 ? "AM" : "PM",
				Z:    utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
				o:    (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
				S:    ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
			};

		return mask.replace(token, function ($0) {
			return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
		});
	};
}();

// Some common format strings
dateFormat.masks = {
	"default":      "ddd mmm dd yyyy HH:MM:ss",
	shortDate:      "m/d/yy",
	mediumDate:     "mmm d, yyyy",
	longDate:       "mmmm d, yyyy",
	fullDate:       "dddd, mmmm d, yyyy",
	shortTime:      "h:MM TT",
	mediumTime:     "h:MM:ss TT",
	longTime:       "h:MM:ss TT Z",
	isoDate:        "yyyy-mm-dd",
	isoTime:        "HH:MM:ss",
	isoDateTime:    "yyyy-mm-dd'T'HH:MM:ss",
	isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
	dayNames: [
		"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
		"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
	],
	monthNames: [
		"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
		"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
	]
};

// For convenience...
Date.prototype.format = function (mask, utc) {
	return dateFormat(this, mask, utc);
};