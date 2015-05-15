/*
 * Copyright (c) 2015 PS&M. All rights reserved.
 */

(function ($) {

    var _pop_msg = ""; //popinit() 에서 사용하는 메시지 문자열 

    $.PSNMPop = {

        popinit: function(param) {
            $("body").keyup(function(e) {
                _debug("PSNMPop.popinit", "which = " + e.which, "nodeName = " + e.target.nodeName);
                if (27==e.which) { //ESC 키
                    if ( $.PSNM.confirm("팝업창을 종료하시겠습니까?") ) {
                        $a.close();
                    }
                }
            });
            _debug("PSNMPop.popinit", "popinited ---------------------------------------------------------");
        }
        //end of [popinit: function]

        //----------------------------------------------------------------------------------------------------------------------------//
    };
    //end of [$.PSNMPop]

})(jQuery);
