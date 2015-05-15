/*! Alopex UI - v2.2.30 - 2014-10-02
* http://ui.alopex.io
* Copyright (c) 2014 alopex.ui; Licensed Copyright. SK C&C. All rights reserved. */

+function($) {
	if(!window._useAlopexController) { // alopex_controller polyfill
		function isValid(arg) {
			if (arg == undefined || arg == null) {
				var caller = arguments.callee;
				while (true) {
					caller = caller.caller;
					if (caller == null) {
						break;
					}
					if (caller.name != "") {
//						console.log("Caller : " + caller.name);
					}
				}

				return false;
			} else {
				return true;
			}
		}
		function MemoryPreference() {
		}
		MemoryPreference.prototype.contains = function(key) {
			if (isValid(key)) {
				if (window.parent.name.indexOf("ù") != -1) {
					var keys = window.parent.name.split("ù")[0];
					var keyArray = keys.split("♠");

					for ( var i = 0; i < keyArray.length; i++) {
						if (keyArray[i] == "mp-" + key) {
							return true;
						}
					}
				}
				return false;
			}
		};
		MemoryPreference.prototype.get = function(key) {
			if (isValid(key)) {
				if (window.parent.name.indexOf("ù") != -1) {
					var keys = window.parent.name.split("ù")[0];
					var values = window.parent.name.split("ù")[1];
					var keyArray = keys.split("♠");
					var valueArray = values.split("♠");

					for ( var i = 0; i < keyArray.length; i++) {
						if (keyArray[i] == "mp-" + key) {
							return valueArray[i];
						}
					}
				}
				return "undefined";
			} else {
				return "undefined";
			}
		};
		MemoryPreference.prototype.put = function(key, value) {
			if (isValid(key) && isValid(value)) {

				if (window.parent.name.indexOf("ù") != -1) {
					var keys = window.parent.name.split("ù")[0];
					var values = window.parent.name.split("ù")[1];
					var keyArray = keys.split("♠");
					var valueArray = values.split("♠");

					for ( var i = 0; i < keyArray.length; i++) {
						if (keyArray[i] == "mp-" + key) {
							valueArray[i] = value;
							window.parent.name = keyArray.join("♠") + "ù" +
									valueArray.join("♠");
							return;
						}
					}
					keyArray.push("mp-" + key);
					valueArray.push(value);

					window.parent.name = keyArray.join("♠") + "ù" +
							valueArray.join("♠");
				} else {
					window.parent.name = "mp-" + key + "ù" + value;
				}
			}
		};

		MemoryPreference.prototype.remove = function(key) {
			if (isValid(key)) {

				var keys = window.parent.name.split("ù")[0];
				var values = window.parent.name.split("ù")[1];

				if (keys != null && values != null) {
					var keyArray = keys.split("♠");
					var valueArray = values.split("♠");

					for ( var i = 0; i < keyArray.length; i++) {
						if (keyArray[i] == "mp-" + key) {
							keyArray.splice(i, 1);
							valueArray.splice(i, 1);
							window.parent.name = keyArray.join("♠") + "ù" +
									valueArray.join("♠");
							return;
						}
					}
				}
			}
		};

		MemoryPreference.prototype.removeAll = function() {
			var keys = window.parent.name.split("ù")[0];
			var values = window.parent.name.split("ù")[1];

			if (keys != null && values != null) {
				var keyArray = keys.split("♠");
				var valueArray = values.split("♠");

				var len = keyArray.length;
				for ( var i = 0; i < len; i++) {
					if (keyArray[i] != null) {
						if (keyArray[i].substring(0, 3) == "mp-") {
							keyArray.splice(i, 1);
							valueArray.splice(i, 1);
							i--;
							len--;
						}
					}
				}
				window.parent.name = keyArray.join("♠") + "ù" + valueArray.join("♠");
			}
		};
		if(!window.memoryPreference) {
			window.memoryPreference = new MemoryPreference();
		}
		

		function Preference() {
		}

		Preference.prototype.contains = function(key) {
			if (isValid(key)) {
				return (preference.get(key) !== undefined && preference.get(key) !== 'undefined');
			}
			return false;
		};

		/*
		 * source from jQuery Cookie Plugin v1.3(MIT)
		 * https://github.com/carhartl/jquery-cookie
		 */

		Preference.prototype.get = function(key) {

			if (isValid(key)) {

				var decode = function(s) {
					return decodeURIComponent(s.replace(/\+/g, ' '));
				}

				var cookies = document.cookie.split('; ');
				for ( var i = 0, l = cookies.length; i < l; i++) {
					var parts = cookies[i].split('=');
					var part = parts.shift();
					if (decode(part) === key) {
						var cookie = decode(parts.join('='));
						return cookie;
					}
				}

				return undefined;
			}
		};

		Preference.prototype.put = function(key, value, expires) {

			if (isValid(key)) {
				if (typeof expires === 'number') {
					var days = expires, t = expires = new Date();
					t.setDate(t.getDate() + days);
				}
				document.cookie = [encodeURIComponent(key), '=',
						encodeURIComponent(value),
						expires ? '; expires=' + expires.toUTCString() : '' // use expires attribute, max-age is not supported by IE
				].join('');

			}
		};

		Preference.prototype.remove = function(key) {
//			console.log("[Preference/remove]");
			if (isValid(key)) {
				if (preference.get(key) !== undefined) {
					preference.put(key, undefined);
				}
			}
		};

		Preference.prototype.removeAll = function() {
//			console.log("[Preference/removeAll]");
			notSupported("Preference.removeAll");
		};
		
		if(!window.preference) {
			window.preference = new Preference();
		}
	}
}(jQuery);

+function($) {
	$.alopex.validator = window.Validator,
	window.$a = $.alopex;
}(jQuery);

+function($) {
	$.alopex.decorator = function(config) {
		this.process = function() {
			config.template = this.template;
			var decorator = $('script[type="text/alopex-decorator"]').attr('data-decorator');
			var metas = config.options.metas;
			for (i in metas) {
				var tag = '<meta';
				for (j in metas[i]) {
					var metaAttr = metas[i][j];
					tag += ' ' + metaAttr.prop + '="' + metaAttr.value + '"';
				}
				tag += '/>'
				$('head').prepend(tag);
			}
			if(config[decorator || config.options.defaultDecorator]){
				config[decorator || config.options.defaultDecorator]();
			}

			//깜빡임 현상을 방지하기 위하여 HTML을 display:none했다가 show
			$('html').show();
		}
		return this;
	};

	$.alopex.view = function(name, view) {
		var inst = $.alopex.viewConfig.views[name];
		if (inst == undefined && view !== undefined) {
			inst = new $.alopex._view(name, view);
			$.alopex.viewConfig.views[name] = inst;
		}
		return inst;
	}

	$.alopex.viewSetup = function(options) {
		$.extend($.alopex.viewConfig.settings, options);
	};

	$.alopex.viewConfig = {
		views: {},
		settings: {
			templateBasePath: 'source/templates',
			templateFileExtension: '.html'
		}
	}

	$.alopex._view = function(name, view) {
		this.name = name;
		$.extend(this, view);
	}
	
	$.alopex._view.prototype = {
		template: function(model) {
			var templateName = this.templateName || (this.name + $.alopex.viewConfig.settings.templateFileExtension);
			var method = AlopexWebApp.Templates[$.alopex.viewConfig.settings.templateBasePath + '/' + templateName];
			if(method && typeof method == 'function') {
				return method(model);
			}
			return '';
		},
		render: function(model) {
			var outlet = this.outlet || this.name;
			model = model || this.model;
			model = (model && typeof model === 'function') ? model() : model;
			var $outlet = $('[data-outlet="' + outlet + '"]');
			
			$outlet.html(this.template(model));
			$outlet.convert(); //alopex ui convert
		}
	};
}(jQuery);
+function($){
	var _legacyHttpObjects = [];
	function _legacyHttp() {
		this.error = -1;
		this.errorMessage = null;
		this.response = null;
		this.responseHeader = null;
		_legacyHttpObjects = _legacyHttpObjects || [];
		_legacyHttpObjects.push(this);
		this.index = _legacyHttpObjects.length - 1;
		this.httpRequestHeaders = {};
		//this.httpRequestKeys = [];
		//this.httpRequestValues = [];
		this.httpObject;
	}
	function _httpIsValid(d) {
		if (d === undefined || d === null)
			return false;
		return true;
	}
	
	_legacyHttp.prototype.cancelDownload = function() {
		if (this.httpObject != null)
			this.httpObject.abort();
	};
	
	_legacyHttp.prototype.cancelRequest = function() {
		if (this.httpObject != null)
			this.httpObject.abort();
	};
	
	_legacyHttp.prototype.cancelUpload = function() {
		if (this.httpObject != null)
			this.httpObject.abort();
	};
	
	_legacyHttp.prototype.download = function(entity, successCallback,
			errorCallback, progressCallback, cancelCallback) {
	};
	
	_legacyHttp.prototype.getResponseHeader = function(header) {
		if (this.httpObject != null) {
			return this.httpObject.getResponseHeader(header);
		} else {
			return null;
		}
	};
	
	_legacyHttp.prototype.request = function(entity, successCallback, errorCallback) {
	
		if (_httpIsValid(entity) && _httpIsValid(successCallback)
				|| _httpIsValid(errorCallback)) {
			entity.index = this.index;
			var http = {};
			var paramString = "";
	
			if (entity["parameters"] != null) {
				paramString = "?";
				for ( var j in entity["parameters"])
					paramString = paramString + "&" + j + "="
							+ entity["parameters"][j];
				paramString = paramString.substring(0, 1)
						+ paramString.substring(2);
			}
	
			this.httpObject = new XMLHttpRequest();
	
			this.httpObject.onreadystatechange = function() {
				if (this.readyState == 4) {
					http.status = this.status;
					http.statusText = this.statusText;
					if (this.status == 200) {
						http.response = this.responseText;
						var headerStr = this.getAllResponseHeaders();
						if (headerStr) {
							http.responseHeader = {};
							var headerPairs = headerStr.split('\u000d\u000a');
							for (var i = 0, ilen = headerPairs.length; i < ilen; i++) {
								var headerPair = headerPairs[i];
								var index = headerPair.indexOf('\u003a\u0020');
								if (index > 0) {
									http.responseHeader[headerPair.substring(0,
											index)] = headerPair
											.substring(index + 2);
								}
							}
						}
						successCallback(http);
					} else {
						http.error = this.status;
						http.errorMessage = this.statusText;
						errorCallback(http);
					}
				}
			};
	
			if (entity["method"].toLowerCase() == "get") {
				this.httpObject.open(entity["method"], entity["url"] + paramString,
						true);
			} else {
				this.httpObject.open(entity["method"], entity["url"], true);
			}
	
			if(!this.httpRequestHeaders['Content-Type']) {
				if (entity["onBody"]) {
					this.httpObject.setRequestHeader("Content-Type",
						"application/json; charset=UTF-8");
				} else {
					this.httpObject.setRequestHeader("Content-Type",
						"application/x-www-form-urlencoded; charset=UTF-8");
				}
			}
	
			for (var key in this.httpRequestHeaders) {
				this.httpObject.setRequestHeader(key, this.httpRequestHeaders[key]);
			}
			
	    if(this.timeout) {
	      this.httpObject.timeout = this.timeout;
	    }
	
			try {
				if (entity["method"].toLowerCase() == "post") {
					if (entity["onBody"]) {
						this.httpObject.send(entity["content"]);
					} else {
						this.httpObject.send(paramString);
					}
				} else {
					this.httpObject.send();
				}
			} catch (e) {
				var result = {};
				result.error = e.code;
				result.errorMessage = e.message;
	
				errorCallback(result);
	
				return;
			}
	
			this.httpRequestHeaders = {};
			//this.httpRequestKeys = [];
			//this.httpRequestValues = [];
		}
	};
	
	_legacyHttp.prototype.setRequestHeader = function(header, value) {
		if (_httpIsValid(header) && _httpIsValid(value)) {
			this.httpRequestHeaders[header] = value;
			//this.httpRequestKeys.push(header);
			//this.httpRequestValues.push(value);
		}
	};
	
	_legacyHttp.prototype.setTimeout = function(timeout) {
		this.timeout = timeout;
	};
	
	_legacyHttp.prototype.upload = function(entity, successCallback, errorCallback,
			progressCallback, cancelCallback) {
	};

	window._legacyHttp = _legacyHttp;
}(jQuery);
+function($) {
	$.extend($.alopex, {
		/**
		 * 화면에 모달뷰 띄우는 함수.
		 */
		block: function() {
			var $modalview = $('<div></div>').attr('data-alopexmodal', 'true').appendTo('body');
			$modalview.css({
				"position": "absolute",
				"left": "0",
				"top": "0",
				"width": $(window).width() + "px",
				"height": $(window).height() + "px",
				"z-index": "9999",
				"opacity": "0.7",
				"background-color": "#111"
			});
			
			$.alopex.__htmlHeight = $('html')[0].style.height;
			$.alopex.__htmlWidth = $('html')[0].style.width;
			$.alopex.__bodyHeight = $('body')[0].style.height;
			$.alopex.__bodyWidth = $('body')[0].style.width;
			$('html').css({
			    height: '100%',
			    width: '100%'
			});
			$('body').css({
			    height: '100%',
			    width: '100%',
			    overflow: 'hidden'
			});
			
			$modalview.on('mousedown.alopexbloack mouseup.alopexblock scroll.alopexblock', function(e) {
				e.preventDefault();
				e.stopPropagation();
				return false;
			});
		},
		
		/**
		 * 화면에 있는 모달뷰 제거하는 함수.
		 */
		unblock: function() {
			$('html')[0].style.height = ($.alopex.__htmlHeight) ? $.alopex.__htmlHeight : '';
			$('html')[0].style.width = ($.alopex.__htmlWidth) ? $.alopex.__htmlWidth : '';
			$('body')[0].style.height = ($.alopex.__bodyHeight) ? $.alopex.__bodyHeight : '';
			$('body')[0].style.width = ($.alopex.__bodyWidth) ? $.alopex.__bodyWidth : '';
			$('[data-alopexmodal]').remove();
		}
	});
}(jQuery);


/*!
* Copyright (c) 2014 SK C&C Co., Ltd. All rights reserved.
*
* This software is the confidential and proprietary information of SK C&C.
* You shall not disclose such confidential information and shall use it
* only in accordance with the terms of the license agreement you entered into
* with SK C&C.
*
* Alopex Javascript Framework
* alopex-page
*
*/
+function($) {
	
	var isAlopexReady = false; //ready조건 : alopexready && DOMContentLoaded
	var popupparam, navparam, queryparam, results;
	var re = /([^&=]+)=?([^&]*)/g;
	var decode = function(str) {
		return decodeURIComponent(str.replace(/\+/g, ' '));
	};
	function decodeQuery(query) {
		var params = {};
		while (e = re.exec(query)) {
			var k = decode(e[1]);
			var v = decode(e[2]);
			if (params[k] !== undefined) {
				if (!$.isArray(params[k])) {
					params[k] = [params[k]];
				}
				params[k].push(v);
			} else {
				params[k] = v;
			}
		}
		return params;
	}
	
	function init() {
		$(document).on('screenback', function() {
			if($a.page.screenback) {
				var args = $.makeArray(arguments);
				$a.page.screenback.apply(this, args);
			}
		});
		$(document).on('pause', function() {
			if($a.page.screenpause) {
				var args = $.makeArray(arguments);
				$a.page.screenpause.apply(this, args);
			}
		});
		$(document).on('resume', function() {
			if($a.page.screenresume) {
				var args = $.makeArray(arguments);
				$a.page.screenresume.apply(this, args);
			}
		});
	}
	
	

	$.extend($.alopex, {
		
		_navigationCofig: {
			url: function(url, options) {
				return url;
			}
		},
		//$.alopex.page(Object pageObject)
		//$.alopex.page(Function initFunc)
		//$.alopex.page(Function initFunc, Object pageObject)
		page: function() {
			var args = $.makeArray(arguments);
			var inits = [];
			$.each(args, function(idx, arg) {
				if ($.isFunction(arg)) {
					inits.push(arg);
				} else if ($.isPlainObject(arg)) {
					$.alopex.page = $.extend($.alopex.page, arg);
					if (arg.init) {
						inits.push(arg.init);
					}
				}
			});
			$.each(inits, function(idx, arg) {
				
				function runArg() {
					isAlopexReady = true;
					
					// query string.
					var query = String(window.location.search);
					if (query.substr(0, 1) == '?') {
						query = query.substr(1);
					}
					queryparam= decodeQuery(query);
					
					// navigation parameter
					try{
						navparam = JSON.parse($a.session('alopex_parameters'));
						$a.session('alopex_parameters', '');
					}catch(e){}
					
					// popup parameter
					popupparam = $.alopex._WindowPopupData;
					var pageId;
					if (window._useAlopexController) { 
						pageId = navigation.pageId;
						results = navigation.results;
					} else {
						pageId = window.location.pathname;
						try{
							results = JSON.parse($a.session('alopex_results'));
							$a.session('alopex_results', '');
						} catch(e){}
						
					}
					arg(pageId, $.extend(true, results, navparam, popupparam, queryparam));
				}
				
				if(isAlopexReady) { // Alopex Runtime을 사용하고, 해당 페이지가 나중에 로드된 케이스.
					$(document).one('alopexuiready', function() {
						$(runArg);
					});
				} else {
					if (window._useAlopexController) {
						$(document).one('alopexready', function() {
							$(runArg);
						});
					} else {
						$(document).ready(function(){
							$(runArg);
						});
					}
					
				}
			});
		},
		
		/**
		 * $a.navigate 함수 호출 시 기준되는 위치는 /html/폴더 하위입니다.
		 * $a.navigate('DS/DS0001') or $a.navigate('DS/DS0001.html')
		 */
		navigate: function(url, param) {
			if (typeof url !== "string")
				return;
			var targetUrl = $.alopex._navigationCofig.url(url, param);
			$.alopex.session('alopex_parameters', JSON.stringify(param));
			if (window._useAlopexController) {
				navigation.backToOrNavigate({
					"pageId": targetUrl
				});
			} else {
				window.location.href = targetUrl;
			}
		},
		
		back: function(results) {
			if (window._useAlopexController) {
				navigation.back(results);
			} else {
				$.alopex.session('alopex_results', JSON.stringify(results));
				history.back();
			}
		},
		
		backTo: function(id, params) {
			navigation.backTo({
				"pageId": _url,
				"parameters" : params
			});
		}, 
		
		backToOrNavigate: function(id, params) {
			navigation.backToOrNavigate({
				"pageId": _url,
				"parameters" : params
			});
		},
		
		exit: function() {
			navigation.exit();
		}, 
		
		/**
		 * Used with Alopex Runtime
		 */
		goHome: function() {
			navigation.goHome();
		},

		/**
		 * 이전 페이지 상태 관리 함수.
		 */
		status: {
			add: function(params) {
				if (params && typeof params == 'object') { // setter
					if (!window["_temp_alopex"]) {
						window["_temp_alopex"] = {};
					}
					$.extend(window["_temp_alopex"], params);
				}
			},
			remove: function() {
				var url = window.location.href.split('?')[0];
				$a.session(url, undefined);
			},
			get: function() {
				var url = window.location.href.split('?')[0];
				url = url.replace('http://', '');
				url = url.substring(url.indexOf('/') + 1);
				if ($a.session(url)) {
					try {
						return JSON.parse($a.session(url));
					} catch (e) {
						return undefined;
					}

				} else {
					return undefined;
				}
			}
		}
	});
	
	$.extend($.alopex.navigate, {
		setup: function(config) {
			$.alopex._navigationCofig = config;
		}
	});
}(jQuery);
+function($) {

	// popup API를 사용해 팝업을 띄울 경우, window.name으로 아이디 전달.
	var _AlopexPopupID = window.name;
	if (window.opener && window.opener.$) {
		// 팝업 종료 시 처리 : 팝업 창 닫힐 때 메인화면 modal unblock 함수 실행.
		window.onbeforeunload = function() { // modal 설정이 있을 경우, unblock 처리.
			if(config && config.modal) {
				window.opener.$a.unblock();
			}
		};
	} else { // 메인화면이 닫힐 경우, 자신이 띄운 팝업들 닫기.
		window.onbeforeunload = function() { 
			if($.alopex._AlopexPopupList.length > 0) {
				for(var i=0; i<$.alopex._AlopexPopupList.length; i++) {
					if($.alopex._AlopexPopupList[i] && $.alopex._AlopexPopupList[i].close) {
						$.alopex._AlopexPopupList[i].close();
					}
				}
			}
		};
	}
	
	var config;
	if(window.opener && window.opener.$ && window.opener.$.alopex && window.opener.$.alopex._PopupConfig && window.opener.$.alopex._PopupConfig[_AlopexPopupID]) {
		config = window.opener.$.alopex._PopupConfig[_AlopexPopupID];
		$.alopex._WindowPopupData = config.data; // windowpopup data 전달.
	} else if(window.parent && window.parent.$ && window.parent.$.alopex && window.parent.$.alopex._PopupConfig && window.parent.$.alopex._PopupConfig[_AlopexPopupID]) {
		config = window.parent.$.alopex._PopupConfig[_AlopexPopupID];
		$.alopex._WindowPopupData = config.data; // windowpopup data 전달.
	}
	
	/**
	 * 팝업 또는 다이얼로그 url을 입력할 경우, 그에 맞는 id를 리턴합니다.
	 */
	function _GenerateId(url) {
		var index = $.alopex._DialogUrlList.indexOf(url);
		var isExisting = (index != -1);
		if(isExisting) {
			return 'AlopexDialog_' + index;
		} else {
			var length = $.alopex._DialogUrlList.length;
			$.alopex._DialogUrlList.push(url);
			return 'AlopexDialog_' + length;
		}
	}
	
	function _DialogOpen(setting) {
		var dialog = document.getElementById(setting.id);
		var $dialog = $(dialog);
		if($dialog.length == 0) {
			var markup = '<div id="' + setting.id + '" data-type="dialog" data-dialog-type="blank" ';
			if(setting.modalclose) {
				markup += 'data-modalclose="true" ';
			}
			if(setting.toggle) {
				markup += 'data-toggle="true" ';
			}
			markup += '>';
			if(setting.iframe) {
				markup += '<iframe data-type="panel" data-fill="vertical" style="width:100%;overflow:auto;border:0"></iframe>';
			}
			markup += '</div>';
			$dialog = $(markup).appendTo('body').dialog(); // 다이얼로그 생성.
		}
		if(setting.iframe) {
//			var url = setting.url + '?'; // querystring으로 parameter전달.
//			if(setting.data) {
//				url += 'parameters=' + encodeURIComponent(JSON.stringify((setting.data)));
//			}
			$dialog.find('iframe').attr('src', setting.url);
			$dialog.find('iframe')[0].contentWindow.name = setting.id;
			$dialog.find('iframe').on('load', function() {
			    //setting.modal = false;
			    $dialog.open(setting);
			    $dialog.find('iframe').refresh();
			    $dialog.find('iframe')[0].contentWindow.alopexready = true;
			});
		} else {
			$dialog.load(setting.url, function() {
				$dialog.open(setting);
				if(setting.scroll){
					$dialog.css('overflow', 'scroll');
				}
			});
		}
	}
	
	function _WindowOpen(setting, base) {
		var param = '';
		if(setting.width) {
			param += 'width='+setting.width+',';
		}
		if(setting.height) {
			param += 'height='+setting.height+',';
		}
		if (setting.center === true) {
			param += 'left=' + (window.screen.width - parseInt(setting.width)) / 2+',';
			param += 'top=' + Math.max((window.screen.height - parseInt(setting.height)) / 2 - 50, 0)+',';
		}
		if (setting.scroll === true) {
			param += 'scrollbars=yes,';
		}
		if(setting.other) {
			param += setting.other;
		}
		if (setting.modal === true) {
			$a.block();
		}
		if(!base) {
			base = window;
		}
		var popup = base.open(setting.url, setting.id, param);
		$.alopex._AlopexPopupList.push(popup);
	}
	
	$.extend($.alopex, {
		_DialogUrlList: [], // 이 리스트의 인덱스를 활용하여 다이얼로그 id를 생성합니다.
		_AlopexPopupList: [],
		_PopupConfig: {},
		
		popup: function(option, base) {
			// options
			// scroll, modal, width, height, center, scroll, modal, url, callback,
			
			// popup id 지정 : 이 아이디를 가지고 부모창에서 인자를 가져감.
			// default setting.
			var setting = {
				id: _GenerateId(option.url),
				scroll: false,
				modal: true,
				width: parseInt(window.innerWidth*0.9),
				height: parseInt(window.innerHeight*0.9),
				title: (option.title || option.url),
				iframe: true,
				windowpopup: false,
				toggle: true // E&S에서 개발된 기능으로 다이얼로그 접혔다 펼쳤다하는 기능.
			};
			$.extend(setting, option);
			
			// 팝업 Url변환.
			if(location.href.indexOf('.html') == -1) { // net
				if(setting.url.indexOf('.html') != -1) {
					setting.url = setting.url.replace('.html', '');
				}
			} else { // simulator, android
				if(setting.url.indexOf('/') == 0) { // '/'로 시작하는 주소.
					setting.url = location.href.split('www')[0] + 'www/html' + setting.url;
				}
				if(setting.url.indexOf('.html') == -1) {
					setting.url += '.html';
				}
			}
			$.alopex._PopupConfig[setting.id] = setting; 
			if(setting.windowpopup) { // window open으로 띄우기
				_WindowOpen(setting, base);
			} else {
				_DialogOpen(setting);
			}
		},
		
		/**
		 * 현재 윈도우를 종료하는 함수. (popup 윈도우 내 스크립트 에서 실행합니다.)
		 * 
		 * @param data popup창을 띄운 윈도우의 콜백함수의 인자로 전달됩니다.
		 */
		close: function(data) {
			var parent = window;
			if (window.parent) {
				parent = window.parent;
			}
			if (window.opener) {
				parent = window.opener;
			}
			// window popup & iframe내에서
			var config = parent.$.alopex._PopupConfig[_AlopexPopupID]; // callback 함수 찾기 위해.
			if (config && config.callback) {
				config.callback(data);
			}
			if (config.modal && window.opener) {
				parent.$.alopex.unblock();
			}
			var dialog = parent.document.getElementById(config.id);
			if(dialog) {
				parent.$(dialog).close();
			} else {
				//_AlopexPopupList, _PopupConfig 지워주는 처리.
				window.close();
			}
		},
		
		/**
		 * alopex dialog를 띄우는 함수입니다.
		 */
		dialog: function(option){
			var setting = {
				dialog: true,
				id: _GenerateId(option.url),
				iframe: false,
				modal: true,
				modalclose: false,
				scroll: true,
				title: (option.title || option.url),
				height: parseInt(window.innerHeight*0.9),
				width: parseInt(window.innerWidth*0.9)
			};
			$.extend(setting, option);
			_DialogOpen(setting);
		}
	});
}(jQuery);

/*!
* Copyright (c) 2014 SK C&C Co., Ltd. All rights reserved.
*
* This software is the confidential and proprietary information of SK C&C.
* You shall not disclose such confidential information and shall use it
* only in accordance with the terms of the license agreement you entered into
* with SK C&C.
*
* Alopex Javascript Framework
* alopex-service
*
*/
function getGridKey(grid) {
	var $target = grid.jquery ? grid : $(grid);
	var key;
	if($target.attr('data-bind')) {
		key = $target.attr('data-bind').replace('grid', '').replace(':', '').trim();
	} else {
		key = $target.attr('id');
	}
	return key;
}



+function($) {
	var setupConfig = {}; // setup함수로 등록된 공통 및 플랫폼 설정 정보를 가지고 있음.
	/**
	 * Service API
	 */
	$.alopex.request = function(id, option) {
		// param 은 개발자 코드단에서만 제공.
		// 공통 및 플랫폼에서 변경하고 싶으면, before 활용.
		if(!option) { option = {};}
		var request = $.extend(true, {
				data: {},
				requestHeaders: {},
				responseHeaders: {},
				id: id
			}, setupConfig);
		if(request.platform) {
			$.extend(true, request.data, request[request.platform].dataFormat); // default data
		}
	
		var ServiceHttp;
		if(typeof Http !== "function" && typeof _legacyHttp === "function") {
			ServiceHttp = _legacyHttp;
		} else {
			ServiceHttp = Http;
		}
		var http = new ServiceHttp();
		var entity = {};
		entity["url"] = $.isFunction(request.url) ? request.url.call(request, id, option):request.url;
		entity["method"] = $.isFunction(request.method) ? request.method.call(request, id, option) : request.method;
		entity["onBody"] = ((String(request.method).toUpperCase() === "POST") ? true : false);
		
		if ($.isPlainObject(request.requestHeaders)) {
			$.each(request.requestHeaders, function(header, value) {
				http.setRequestHeader(header, value);
			});
		}
		
		// data 추출.
		// data key는 service함수 option에만 정의.
		if(option.data) {
			if(typeof option.data == 'function') { // function
				$.extend(true, request.data, option.data.call(request, option));
			} else if(typeof option.data == 'string' || (option.data instanceof Array)) { // meta
				var selectors = $.makeArray(option.data);
				for(var i=0; i<selectors.length; i++) {
					var $el = $(selectors[i]);
					if($el.attr('data-alopexgrid')) {
						request[request.platform].gridToData($el, request);
					} else {
						request[request.platform].formToData($el, request);
					}
				}
			} else {
				$.extend(true, request.data, option.data);
			}
		}
		
		// BEFORE!!!!!!!!!!!!!!!!!!!!!!!!!
		// 순서 : 공통 + 사용자 -> 플랫폼. before 처리.
		if(typeof request.before == 'function') { // 공통 before
			request.before.call(request, id, option);
		}
		if(typeof option.before == 'function') { // 사용자 before
			option.before.call(request, id, option);
		}
		// 플랫폼 before 호출 (어댑터 역할만 수행)
		if(request.platform && request[request.platform] && typeof request[request.platform].before == 'function') {
				request[request.platform].before.call(request, id, option);
		}
		
		// parameter들이 변환된 이후에 처리.
		entity["content"] = $.isPlainObject(request.data) ? JSON.stringify(request.data) : String(request.data);
		if(String(request.method).toUpperCase() === "GET" && $.isPlainObject(request.data) && !$.isEmptyObject(request.data)) {
			entity["url"] += "?" + $.param(request.data);
		}
//		log('@@ request.data ===== ', request.data)
		
		http.setTimeout(request.timeout || 30000);
		var progress_option = {
			//"message" : "Loading",
			"cancelable": false,
			"color": "grey"
		};
		window.platformUIComponent ? platformUIComponent.showProgressDialog(progress_option) : null;
		if(window.deviceJSNI) {
			http.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
		}
		http.request(entity, 
				(function(option, req){ // 이 부분은 멀티 서비스 호출 시 option 값 보존을 위해 필요.
					return function(res) {
						var platform = req.platform;
						req.responseText = res.response;//original data. parsing은 platform before processor의 처리내용.
						req.responseHeaders = res.responseHeader;
						try{ 
							req.response = JSON.parse(req.responseText); // response : json object 
						}catch(e) {
							req.isSuccess = false;
							res.errorCode = 'E01';
							res.errorText = '유효하지 않은 JSON파일입니다.';
						}
						
						// platform after 호출. (변환)
						if(req.platform && req[req.platform] && typeof req[req.platform].after == 'function') {
							req[req.platform].after.call(req, req.response);
						}
						if(req.isSuccess !== false && typeof req.after == 'function') {
							req.after.call(req, req.response);
						}
						if (req.isSuccess === false) {	// fail
							if(typeof req.fail == 'function') {
								req.fail.call(req, req.response);
							}
							if(typeof option.fail == 'function') {
								option.fail.call(req, req.response);
							}
						} else {	// success
							if(typeof req.success == 'function') {
								req.success.call(req, req.response);
							}
							if(typeof option.success == 'function') {
								option.success.call(req, req.response);
							} else if(typeof option.success == 'string' || option.success instanceof Array) { // meta
								// 이 경우 option.before는 selector
								var selectors = $.makeArray(option.success);
								for(var i=0; i<selectors.length; i++) {
									var $el = $(selectors[i]);
									if($el.attr('data-alopexgrid')) {
										req[req.platform].dataToGrid($el, req);
									} else {
										req[req.platform].dataToForm($el, req);
									}
								}
							}
						}
						window.platformUIComponent ? platformUIComponent.dismissProgressDialog() : null; // callback 호출되기 이전에 progress 없애기. callback에서 또다른 서비스 호출 존재 시 문제됨.
					};
				})(option, request),
				(function(option, req) {
					return function(res) {
						// erroCallback 호출.
						var platform = req.platform;
						req.originalResponse = res.responseText;
						req.responseHeaders = res.responseHeader;
						req.data = res.status;
						req.status = res.status;
						req.statusText = res.statusText;
						
						if(setupConfig.error) {
							setupConfig.error.call(req, res);
						}
						if(option.error) {
							option.error.call(req, res);
						}
						window.platformUIComponent ? platformUIComponent.dismissProgressDialog() : null;
					}
				})(option, request));
	};
	
	// setup API 
	$.extend($.alopex.request, {
		setup: function() {
			if(typeof arguments[0] == 'string') { // platform setup
				if(setupConfig[arguments[0]]) {
					$.extend(true, setupConfig[arguments[0]], arguments[1]);
				} else {
					setupConfig[arguments[0]] = arguments[1];
				}
				
			} else {
				$.extend(true, setupConfig, arguments[0]);
			}
		},
		prototype: {},
		
		getGridData: function (grid) {
			var key = getGridKey(grid);
			var $target = grid.jquery ? grid : $(grid);
			var list = $target.alopexGrid('dataGet');
			for (var i = 0, l = list.length; i < l; i++) {
				list[i] = AlopexGrid.trimData(list[i]);
			}
			var pageinfo = $target.alopexGrid('pageInfo');
			return {
				key: key,
				list: list,
				page: pageinfo
			};
		},
		/*
		 * data: {
		 * 		list: [],
		 * 		page: {
		 * 			
		 * 		}
		 * }
		 */
		setGridData: function(grid, data) {
			$(grid).alopexGrid('dataSet', data.list, ($.alopex.util.isValid(grid.paging))? grid.paging : undefined);
		},
		getFormData: function(form) {
			return $(form).alopex('dataGet');
		},
		setFormData: function(form, data) {
			$(form).alopex('dataSet', data);
		}
	});
	
}(jQuery);





+function($) {
	
	/**
	 * 메타 처리하는 부분은 service core 부분으로 처리.
	 * 사용자가 커스터마이징 할 부분이 별로 없음.
	 */

	/**
	 * platform : 어댑터 정의. 
	 * 이 영역에는 설정 정보 없음.
	 * 어댑터 형태의 전환만 설정.
	 */
	$.alopex.request.setup("NEXCORE.J2EE", { // platform
		dataFormat: {
			dataSet: {
				fields: {},
				recordSets: {}
			},
			transaction: {},
			attributes: {}
		},
		gridToData: function(grid, request) {
			var griddata = $.alopex.request.getGridData(grid);
			if(griddata.key && griddata.list) {
				var data = request.data.dataSet.recordSets[griddata.key] = {};
				data.nc_list = griddata.list;
				if($.alopex.util.isValid(griddata.paging)) {
					data.nc_pageNo = griddata.paging.current;
					data.nc_recordCount = griddata.list.length;
					data.nc_recordCountPerPage = griddata.paging.perPage;
					data.nc_totalRecordCount = griddata.paging.dataLength;
				}
			}
		},
		
		dataToGrid: function(grid, request) {
			var key = getGridKey(grid);
			var griddata = {
				list: request.response.dataSet.recordSets[key].nc_list,
				paging: {
					current: request.response.dataSet.recordSets[key].nc_pageNo,
					perPage: request.response.dataSet.recordSets[key].nc_recordCountPerPage,
					dataLength: request.response.dataSet.recordSets[key].nc_totalRecordCount
				}
			};
			$.alopex.request.setGridData(grid, griddata);
		},
		
		formToData: function(form, request) {
			$.extend(true, request.data.dataSet.fields, $.alopex.request.getFormData(form));
		},
		
		
		
		dataToForm: function(form, request) {
			$(form).alopex('dataSet', request.response.dataSet.fields);
		},
		
		before: function(id, option) {
			// 헤더 추가.
			this.requestHeaders["Content-Type"] ="application/json; charset=UTF-8";
			this.data.transaction.id = id;
		},
		after: function(res) {
			if(res.dataSet.message.result != 'OK') { // 실패 체크.
				this.isSuccess = false;
			}
		},
		transformP2J: function(id, options) {
			var request = this;
			var parameter = {
				dataSet: {
					fields : {},
					recordSets : {}
				},
				transaction: {
					id: null
				},
				attributes: {}
			};
			var data = parameter.dataSet;
			data['fields'] = {};
			data['recordSets'] = {};
			
			for(var i in request.data) {
				if(!request.data.hasOwnProperty(i)) {
					continue;
				}
				if(request.data[i] instanceof Array) { // recordSets 데이터로 분류.
					data['recordSets'][i] = {};
					data['recordSets'][i].nc_list = request.data[i];
					if(request.data.grid_data && request.data.grid_data[i]) {
						data['recordSets'][i].nc_recordCount = request.data[i].length;
						data['recordSets'][i].nc_pageNo = request.data.grid_data[i].current;
						data['recordSets'][i].nc_recordCountPerPage = request.data.grid_data[i].perPage;
						data['recordSets'][i].nc_totalRecordCount = request.data.grid_data[i].dataLength;
					}
				} else { // fields로 분류.
					data['fields'][i] = this.data[i];
				}
			}
			this.data = parameter;
		},
		
		transformJ2P: function() {
			var data = $.extend(true, {}, this.response.dataSet.fields);
			$.extend(true, data, this.response.dataSet.message);
			if(this.response.dataSet.recordSets) {
				for(var i in this.response.dataSet.recordSets) {
					var temp = {};
					temp[i] = this.response.dataSet.recordSets[i].nc_list;
					$.extend(true, data, temp);
					if(this.response.dataSet.recordSets[i].nc_pageNo) {
						data[i+'_pageNo'] = this.response.dataSet.recordSets[i].nc_pageNo;
						data[i+'_recordCount'] = this.response.dataSet.recordSets[i].nc_recordCount;
						data[i+'_recordCountPerPage'] = this.response.dataSet.recordSets[i].nc_recordCountPerPage;
						data[i+'_totalRecordCount'] = this.response.dataSet.recordSets[i].nc_totalRecordCount;
					}
				}
			}
			this.response = data;
		}
	});
}(jQuery);

//
//+function($) {
//
//	/**
//	 * 공통 설정 부분.
//	 * before : 전처리, 
//	 * after : success 판단 여부 처리 
//	 * success : 성공 시 공통으로 처리해주는 후처리. 
//	 * url : "" or function() {return "http://localhost:9000";}
//	 * method : "GET" or "POST" or function() { return "GET";}
//	 */
//	$.alopex.request.setup({
//		platform: 'NEXCORE.J2EE',
//		//url : "http://150.28.65.2:7001/web/stand.jmd",
//		/* 조건에 따라 다른 url에 지정이 가능하다. */
//		url: function() {
//			if(true){
//				return "http://150.28.65.2:7001/web/stand.jmd";
//			}
//			return 'dddd'
//		},
//		//*/
//		method : "POST",
//		timeout: 3000,
//		before : function(id, option) { // before
//			// 전처리기.
//			$('body').progress(); //progress bar 시작
//		},
//		after : function() {
//			// response 받아서 여기서 성공판단.
//			log('after ==== ');
//			$('body').progress().remove();  //progress 종료
//		},
//		success : function() {
//			
//		},
//		fail: function(res) {
//			$('body').progress().remove();  //progress 종료
//			log('errorcode = ', res);
//			alert( ' FAIL! ' ); 
//		},
//		error  : function() {
//			$('body').progress().remove();  //progress 종료
//			log('errorcode = ' + this.status + ' message = ' + this.statusText);
//			alert( ' Error! ' ); 
//			
//		}
//	});
//}(jQuery);

/*!
* Copyright (c) 2014 SK C&C Co., Ltd. All rights reserved.
*
* This software is the confidential and proprietary information of SK C&C.
* You shall not disclose such confidential information and shall use it
* only in accordance with the terms of the license agreement you entered into
* with SK C&C.
*
* Alopex Javascript Framework
* alopex-service
*
*/
+function($) {
	
	function extendProperty(to, from) {
		$.each(from, function(key, value) {
			if (!$.isFunction(value) && from.hasOwnProperty(key)) {
				to[key] = $.isPlainObject(value) ? $.extend(true, {}, value) : value;
			}
		});
	}
	var rcallbackKey = /^(?:before|after|success|fail|error)/i;
	var __id = (Math.random() * 100) | 0;
	function randstr() {
		return "alopexservice" + (__id++);
	}
	function populatePrototype() {
		$.each($.alopex.service, function(prop, val) {
			//TODO fix logic
			if ($.alopex.service.hasOwnProperty(prop) && $.isFunction(val)) {
				$.alopex.service[prop] = $.alopex.service.prototype[prop] = val;
				//$.alopex.service.plugin(prop, val);
			}
		});
	}
	function processorKeyword(value) {
		return value === true || value === "pre" || value === "meta" || value === "post";
	}
	function doChaining(context, chain, args) {
		if (!$.isArray(chain))
			return;
		var metaProcessor = [];
		var preProcessor = [];
		var postProcessor = [];
		var proceed = true;
		$.each(chain, function(idx, item) {
			if ($.isArray(item) && processorKeyword(item[0]) && $.isFunction(item[1])) {
				if (item[0] === true || item[0] === "meta") {
					metaProcessor.push(item[1]);
				} else if (item[0] === "pre") {
					preProcessor.push(item[1]);
				} else if (item[0] === "post") {
					postProcessor.push(item[1]);
				}
			}
		});
		proceed && $.each(preProcessor, function(idx, p) {
			if (p.apply(context, $.isFunction(args) ? args(context) : args) === false) {
				proceed = false;
				return false;
			}
		});
		proceed && $.each(chain, function(idx, item) { // 이전 버전에서 chain & metaProcessor를 분리하였으나, 다시 E&S버전으로 롤백.
			if ($.isFunction(item)) {
				if (item.apply(context, $.isFunction(args) ? args(context) : args) === false) {
					proceed = false;
					return false;
				}
			} else if ($.isArray(item) && item[0] !== true) {
				for ( var i = 0, l = metaProcessor.length; i < l; i++) {
					if (metaProcessor[i].apply(context, item) === false) {
						proceed = false;
						return false;
					}
				}
			}
		});
		proceed && $.each(postProcessor, function(idx, p) {
			if (p.apply(context, $.isFunction(args) ? args(context) : args) === false) {
				procees = false;
				return false;
			}
		});
		return proceed;
	}

	function addToChain(chain, value, forcePriority) {
		//value의 가능한 형태
		//function
		//[function]
		//[true,function]
		//[[function,function..],[true,function]]
		if ($.isFunction(value)) {
			chain.push(value);
		} else if ($.isArray(value)) {
			if (processorKeyword(value[0]) && $.isFunction(value[1])) {
				chain.push(value);
			} else if (typeof value[0] === "string") {
				chain.push(value);
			} else {
				for ( var i = 0, l = value.length; i < l; i++) {
					addToChain(chain, value[i]);
				}
			}
		} else if ($.isPlainObject(value)) {
			chain.push(value);
		}
		return;
	}
	/**
	 * Star Alopex Service Constructor
	 * 
	 * var newservice = new $a.service();
	 * newservice.service(id, data, success, fail, error);
	 * 
	 * $a.service(id, data, success, fail, error);
	 */
	$.alopex.service = function(copy) {
		var self = this;
		if (self instanceof $.alopex.service && !self.alopexservice) { //new로 호출됨.
			self.alopexservice = randstr();
			self.settings = {
				success: [],
				fail: [],
				error: []
			};
			self.request = {};//before영역. before함수들의 this가 된다.
			self.response = {};//after영역. after함수들의 this가 된다.
			//.service()가 호출되는 시점에 $.alopex.service의 property를 가져와야 한다. 
			//extendProperty(self.request, $.alopex.service);
			self.request.chain = [];//before chain. 플랫폼 기본체인 호출 후 적용이 된다.
			self.response.chain = [];//after chain

			if (copy && copy.alopexservice) {
				extendProperty(self.settings, copy.settings);
			}
			if (copy && copy.request && $.isArray(copy.request.chain)) {
				self.request.chain = self.request.chain.concat(copy.request.chain);
			}
			if (copy && copy.response && $.isArray(copy.response.chain)) {
				self.response.chain = self.response.chain.concat(copy.response.chain);
			}

		} else { //일반 함수로 호출 
			self = new $.alopex.service();
			if (arguments[0] !== $.alopex && arguments.length) {
				self.service.apply(self, arguments);
			}
		}
		populatePrototype();
		return self;
	};
	$.extend($.alopex.service, {
		settings: {
			platform: "GENERIC",
			url: "",
			method: "GET",
			before: [],
			after: [],
			success: [],
			fail: [],
			error: []
		},
		fix: function(inst) {
			//prototype exposure
			populatePrototype();
			//instance fix
			return (inst && inst.alopexservice) ? inst : new $.alopex.service();
		},
		clone: function() {
			if (this.alopexservice) {
				return new $.alopex.service(this);
			} else {
				return new $.alopex.service();
			}
		},
		/**
		 * Star Alopex Service Setup
		 * 
		 * $a.service.setup({
		 *   platform : "NEXCORE.J2EE",
		 *   url : "/service",
		 *   ...
		 * });
		 * $a.service.setup({
		 *   "PlatformName" : {
		 *     platform : true,
		 *     setting1 : "value1",
		 *     setting2 : "value2",
		 *     before : [],
		 *     after : []
		 *   }
		 * });
		 */
		setup: function(o) {
			var self = this;
			if ($.isPlainObject(o)) {
				self.settings = self.settings || {};
				$.each(o, function(key, value) {
					if (value === undefined || value === null) {
						delete self.settings[key];
						if(rcallbackKey.test(key)) {
							self.settings[key] = [];
						}
					} else if (rcallbackKey.test(key)) {
						addToChain(self.settings[key], value);//to global or to instance
					} else if ($.isPlainObject(value) && (value.platform === true)) {
						if (!$.alopex.service[key] || !$.alopex.service[key].alopexservice) {
							$.alopex.service[key] = new $.alopex.service();
						}
						//before : function
						//before : [true, function]
						//before : [function, [], function, []]
						$.each(value, function(k, v) {
							if (k !== "before" && k !== "after" && k !== "platform" && k !== "success" && k !== "fail" && k !== "error") {
								$.alopex.service[key].settings[k] = v;
							}
						});
						$.each(["after", "before", "success", "fail", "error"], function(idx, f) {
							value[f] ? $.alopex.service[key][f](value[f]) : "";
						});
					} else {
						self.settings[key] = value;
					}
				});
			}
			return self;
		},
		/**
		 * 사용자가 .service()를 호출하기전 실행하고자 하는 콜백함수 등록
		 * function callback(id, data, success, fail, error) {
		 *   var request = this;
		 *   request.data = data
		 *   ...
		 * }
		 */
		before: function(callback) {
			var self = $.alopex.service.fix(this);
			addToChain(self.request.chain, $.makeArray(arguments));
			return self;
		},
		/**
		 * 사용자가 .service()를 호출하고 데이터가 수신되었을 때 실행하고자 하는 콜백함수 등록
		 * function callback(data, headers) {
		 *  var response = this;
		 *  response.data = JSON.parse(response.responseText);
		 *  response.success = true;//설정여부에 따라 success/fail callback 호출.
		 * }
		 */
		after: function(callback) {
			var self = $.alopex.service.fix(this);
			addToChain(self.response.chain, $.makeArray(arguments));
			return self;
		},
		/**
		 * 
		 */
		success: function(callback) {
			var self = $.alopex.service.fix(this);
			addToChain(self.settings.success, $.makeArray(arguments));
			return self;
		},
		/**
		 * 
		 */
		fail: function(callback) {
			var self = $.alopex.service.fix(this);
			addToChain(self.settings.fail, $.makeArray(arguments));
			return self;
		},
		/**
		 * 
		 */
		error: function(callback) {
			var self = $.alopex.service.fix(this);
			addToChain(self.settings.error, $.makeArray(arguments));
			return self;
		},
		/**
		 * service 호출
		 */
		service: function(id, data, success, fail, error) {
			var self = $.alopex.service.fix(this);
			var args = $.makeArray(arguments);
			//self.request for before
			//self.response for after
			//platform chain
			var request = {
				data: null,
				headers: {}
			};
			var response = {
				data: null,
				headers: {}
			};
			//글로벌설정 가져옴
			extendProperty(request, $.alopex.service.settings);
			//플랫폼설정을 가져옴
			var platform = request.platform;
			extendProperty(request, self.settings);
			//글로벌 설정에 의거한($.alopex.service.platform)플랫폼 설정 가져옴
			//인스턴스 설정 가져옴
			extendProperty(request, self.request);
			request.chain = [];
			//Before Chaining Order : "[GlobalSetup -> UserChain] -> PlatformBefore" per every priority 
			request.chain = request.chain
				.concat(request.before || [])
				.concat(self.request.chain || [])
				.concat($.alopex.service[request.platform].request.chain || []);
			if (doChaining(request, request.chain, args) === false) {
				return false;
			}

			//platform = request.platform;
			response.request = request;
			response.chain = [];
			//After Chaining Order : "PlatformAfter -> [GlobalSetup -> UserChain]" per every priority
			response.chain = response.chain
				.concat($.alopex.service[platform].response.chain || [])
				.concat(request.after || [])
				.concat(self.response.chain || []);
			var ServiceHttp;
			if(typeof Http !== "function" && typeof _legacyHttp === "function") {
				ServiceHttp = _legacyHttp;
			} else {
				ServiceHttp = Http;
			}
			var http = new ServiceHttp();
			var entity = {};
			entity["url"] = $.isFunction(request.url) ? request.url.apply(request, args):request.url;
			entity["method"] = $.isFunction(request.method) ? request.method.apply(request, args) : request.method;
			entity["onBody"] = ((String(request.method).toUpperCase() === "POST") ? true : false);
			entity["content"] = $.isPlainObject(request.data) ? JSON.stringify(request.data) : String(request.data);
			if(String(request.method).toUpperCase() === "GET" && $.isPlainObject(request.data) && !$.isEmptyObject(request.data)) {
				entity["url"] += "?" + $.param(request.data);
			}
			if ($.isPlainObject(request.headers)) {
				$.each(request.headers, function(header, value) {
					http.setRequestHeader(header, value);
				});
			}
			http.setTimeout(request.timeout || 30000);
			var progress_option = {
				//"message" : "Loading",
				"cancelable": false,
				"color": "grey"
			};
			window.platformUIComponent ? platformUIComponent.showProgressDialog(progress_option) : null;
			if(window.deviceJSNI) {
				http.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
			}
			http.request(entity, 
				(function(self, response, success, fail, error){
					return function(res) {
						var platform = response.request.platform;
						response.responseText = res.response;//original data. parsing은 platform before processor의 처리내용.
						response.headers = res.responseHeader;
						if ($.isArray(response.chain)) {
							doChaining(response, response.chain, function(res) {
								return [res.data, res.headers];
							});
						}
						window.platformUIComponent ? platformUIComponent.dismissProgressDialog() : null; // callback 호출되기 이전에 progress 없애기. callback에서 또다른 서비스 호출 존재 시 문제됨.
						if (response.success === false) {
							//var fails = [].concat(response.callback.fail).push(fail);
							//플랫폼공통 -> [글로벌공통 -> 사용자지정] 순서.
							doChaining(response, [].concat($.alopex.service[platform].settings.fail).concat($.alopex.service.settings.fail).concat(self.settings.fail), [response.data, response.headers]);
							$.isFunction(fail) ? fail.call(response, response.data, response.headers) : "";
						} else {
							doChaining(response, [].concat($.alopex.service[platform].settings.success).concat($.alopex.service.settings.success).concat(self.settings.success), [response.data, response.headers]);
							$.isFunction(success) ? success.call(response, response.data, response.headers) : "";
						}
					};
				})(self, response, success, fail, error), 
				(function(self, response, success, fail, error){
					return function(res) {
						var platform = response.request.platform;
						response.originalResponse = response.responseText;
						response.data = res.status;
						response.status = res.status;
						response.statusText = res.statusText;
						doChaining(response, [].concat($.alopex.service[platform].settings.error).concat($.alopex.service.settings.error).concat(self.settings.error), [response.data, response.headers]);
						$.isFunction(error) ? error.call(response, response.data, response.headers) : "";
						if (!error) {
							doChaining(response, [].concat($.alopex.service[platform].settings.fail).concat($.alopex.service.settings.fail).concat(self.settings.fail), [response.data, response.headers]);
							$.isFunction(fail) ? fail.call(response, response.data, response.headers) : "";
						}
						window.platformUIComponent ? platformUIComponent.dismissProgressDialog() : null;
					};
				})(self, response, success, fail, error));
			return self;
		},
		prototype: {}
	});
}(jQuery);

(function($) {
	/**
	 * GENERIC 기본 설정.
	 */
	$.alopex.service.setup({
		"GENERIC" : {
			platform:true,
			before:[
				function(id,data,success,fail,error){
					var request = this;
					request["data"] = $.extend(true, {}, request["data"] , data);
					request["url"] = request["url"] || id;
				},
				[true, function(metas){
					var request = this;
					if(!metas) return;
					if(!$.isArray(metas)) {
						metas = $.makeArray(arguments);
					}
					$.each(metas,function(idx,meta) {
						var $target = $(meta);
						if(!$target.length) return;
						var model = $.alopex.datamodel(meta, true).get();
						request["data"] = $.extend(true, {}, request["data"], model);
					});
				}]
			],
			after:[function(data,headers){
				var response = this;
				try {
					response["data"] = JSON.parse(response.responseText);
				} catch (e1) {
					try {
						if (window.DOMParser) {
							var parser = new DOMParser();
							var xmlDoc = parser.parseFromString(response.reponseText, "text/xml");
						} else { // Internet Explorer
							var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
							xmlDoc.async = false;
							xmlDoc.loadXML(response.reponseText);
						}
						response["data"] = response.responseText;
					} catch (e2) {
						response["data"] = response.responseText;
						response["success"] = false;
					}
				}
			}],
			success:[
			[true, function(metas){
				var response = this;
				if(!response.data || !metas) return;
				if(!$.isArray(metas)) {
					metas = $.makeArray(metas);
				}
				$.each(metas, function(idx, meta) {
					var $target = $(meta);
					if(!$target.length) return;
					$.alopex.databind(response.data, meta);
				});
			}]
			]
		}
	});
})(jQuery);
	
(function($) {	
	/**
	 * J2EE 설정.
	 */
	$.alopex.service.setup({
		"NEXCORE.J2EE" : {
			platform : true,
			before : [function(id, data, success, fail, error) { // data
				// parameter 생성.
				this.data["transaction"] = {
					"id" : id
				};
				this.headers = {
					"Content-Type" : "application/json; charset=UTF-8"
				};
			}],
			after : [function(data, headers) { // 플랫폼 별로 다른 형태 타입이 올떄 처리.
				var response = this;
				var data = {};
				try {
					data = JSON.parse(response.responseText);
					if (data) {
						response.originalResponse = data;
					}
					if (data && data.dataSet) {
						response.data = data.dataSet;
					}
				} catch (e) {
					response.success = false;
				}
			}, function(data, headers) { // J2EE 에러 처리.
				var response = this;
				if (response.data && response.data.message) {
					if (response.data.message.result !== "OK") {
						response.success = false;
					}
				}
			}]
		}
	});
})(jQuery);


(function($) {
	/**
	 * .NET 서비스호출 설정 $a.service('skcc.net.type#serviceName', {key:value,
	 * key:value}, success,fail,error) dataset(table)전송은?
	 * $a.service.before({"table1":[{},{},{},{}],"tablemeta":10,...})
	 * .before('#grid1') .before({"table2":'#grid2'})
	 * .service('skcc.net.type#serviceName', {key:value, key:value}, ...)?
	 */
	$.alopex.service.setup({
		"NEXCORE.NET" : {
			platform : true,
			before : [function(id, data, success, fail, error) {
				// 클라이언트 레벨에서 J2EE 스펙 기준으로 작업한 부분이
				// 나중에 변경.
				var _comm_param = $.extend(true, {}, this.data.dataSet);
				var _net_param = {
					DataSet : {
						DataSetName : "DataSetName",
						Tables : []
					},
					Hashtable : {}
				};

				this.data = {};
				this.data.request = {};
				// .NET 플랫폼에서 id를 사용하여,
				// id = svcAdapter[id] || id;
				if (id.indexOf('#') == -1) { // ServiceId 사용
					this.data.request["ServiceId"] = id;
				} else if (id.split('#').length == 2) {
					this.data.request["ServiceType"] = String(id.split('#')[0]);
					this.data.request["ServiceName"] = String(id.split('#')[1]);
				} else {
					alert('Service 함수의 TransactionId 값이 유효하지 않습니다.')
					return false;
				}
				// recordSets -> dataset
				for ( var i in _comm_param.recordSets) {
					if (_comm_param.recordSets.hasOwnProperty(i)) {
						// var rs = _comm_param.recordSets[i];
						recordSetsToDataSet(i, _comm_param.recordSets, _net_param);
					}
				}

				// fields -> hashtable
				$.extend(_net_param.Hashtable, _comm_param.fields);

				// .NET 용으로 _ENCODE 해준다.
				this.data.request.ServiceData = _net_param;
				this.data.request = _ENCODE(this.data.request);

			}],
			after : [function(data, headers) {
				// 하는 역할: decode 데이터 및 InvokeSer, success 여부 판단,
				var response = this;
				var data = {};
				try {
					data = JSON.parse(response.responseText);
					data["InvokeServiceResult"] = _DECODE(data["InvokeServiceResult"]);
					//
					// 사용.
					response.originalResponse = data;
					// response.success =
					// isSuccess(data["InvokeServiceResult"]);
				} catch (e) {
					response.success = false;
				}
			}, function(data, headers) {
				var response = this;
				if (response.success !== false) {
					var data = {
						"fields" : {},
						"recordSets" : {}
					};
					var orgdata = response.originalResponse["InvokeServiceResult"];
					// Key-value성 데이터 처리
					$.extend(true, data["fields"], orgdata["Hashtable"]);

					// page 정보가 hashtable에 저장됨.
					orgdata["Object"] ? (data["fields"]["Object"] = orgdata["Object"]) : 0;
					// list성 데이터 처리
					if (orgdata["DataTable"] && !$.isEmptyObject(orgdata["DataTable"])) {
						addTableToRecordSets(orgdata["DataTable"], data);
					}
					if (orgdata["DataSet"] && $.isArray(orgdata["DataSet"]["Tables"])) {
						$.each(orgdata["DataSet"]["Tables"], function(idx, tableObject) {
							addTableToRecordSets(tableObject, data);
						});
					}
					// 최종데이터기록
					response.data = data;
				} else {
					response.data = response.originalResponse["InvokeServiceResult"];
				}

			}]
		}
	});
	
	// .NET의 datatable의 데이터를 dataset 내의 recordsets에 저장.
	// 
	function addTableToRecordSets(tableObject, dataset) {
		if (!$.isPlainObject(tableObject) || $.isEmptyObject(tableObject) || !$.isPlainObject(dataset) || !$.isPlainObject(dataset["recordSets"])) {
			return;
		}
		var name = tableObject["TableName"];
		var list = tableObject["Rows"];
		if (!name || !$.isArray(list)) {
			return;
		}
		var recordCoun
		dataset["recordSets"][name] = {
			"nc_list" : list
		};
		if (dataset["fields"]["nc_rowCount_" + name]) { // paging 관련 정보가 존재하는
		// 경우.
		// TODO 이름 수정 필요.(이진우 과장님한테 이름 픽스필요).
			var recordset = dataset["recordSets"][name];
			if(dataset["fields"]["nc_rowCount_" + name] > 0) {
				recordset["nc_recordCount"] = list.length;
				recordset["nc_pageNo"] = dataset["fields"]["nc_pageNum_" + name];
				recordset["nc_recordCountPerPage"] = dataset["fields"]["nc_rowCount_" + name];
				recordset["nc_totalRecordCount"] = dataset["fields"]["nc_totalRowCount_" + name];
			}
		}
	}
	function recordSetsToDataSet(key, recordSets, dataSets) {
		var rs = recordSets[key];
		dataSets.DataSet.Tables.push({
			TableName : key,
			Rows : rs.nc_list
		});

		dataSets.Hashtable["nc_pageNum_" + key] = rs.nc_pageNo;
		dataSets.Hashtable["nc_???_" + key] = rs.nc_recordCount;
		dataSets.Hashtable["nc_rowCount_" + key] = rs.nc_recordCountPerPage;
		dataSets.Hashtable["nc_totalRowCount_" + key] = rs.nc_totalRecordCount;
	}
	// .NET 프레임워크와 통신 스펙 맞추기 위해 URI encoding 처리.
	function _ENCODE(obj) {
		return encodeURIComponent(JSON.stringify(obj));
	}
	/**
	 * .NET 플래폼에서 인코딩된 패킷을 디코드하고, 오브젝트로 리턴.
	 */
	function _DECODE(str) {
		return JSON.parse(decodeURIComponent(str));
	}
	
})(jQuery);


(function($) {
	// 모든 플랫폼이 공통으로 사용하는 로직.
	// 비즈니스 단에서는 해당 로직이 공통으로 사용됨.
	$.alopex.service.setup({
		before : [function(id, data, success, fail, error) { // data
			// parameter 생성.
			this.data = {};
			this.data["attributes"] = {};
			this.data["dataSet"] = {
				"fields" : $.extend(true, {}, data),
				"recordSets" : {}
			};
		}, 
		[true, function(metas){
			var request = this;
			if(!metas) return;
			if(!$.isArray(metas)) {
				metas = $.makeArray(arguments);
			}
			// 서비스 전송 전에 추가 바인딩하는 데이터가 있을 경우 data를 조립
			var dataSet = this.data["dataSet"];

			$.each(metas, function(idx, meta) {
				if (typeof meta === "string" || (meta && meta.jquery && meta.prop('nodeType'))) {
					// 일반 form selector이거나 또는 grid selector. grid selector일땐 id를 자동추출한다 또는 일반 엘리먼트이거나 그리드 엘리먼트 이거나
					var $elem = $(meta);
					if (!$elem.length || !$elem.prop('nodeType'))
						return;
					if (!$elem.prop('id')) {
						// 엘리먼트 ID가 없을때엔 향후 bind-extract를 위해 임의의 id를 배정한다.
						$elem.prop(id, randomId());
					}
					if ($elem.attr('data-alopexgrid')) {
						// 그리드일때의 바인딩은 recordSets에서 추출
						dataSet.recordSets = $.extend(true, dataSet.recordSets, {});
						var recordSets = dataSet.recordSets;
						recordSets[$elem.prop('id')] = gridToRecordSet($elem);
					} else {
						// 일반엘리먼트일 때의 바인딩은 fields에서 추출
						dataSet.fields = $.extend(true, dataSet.fields, {});
						elementToFields($elem, dataSet.fields);
					}
				}
				if ($.isPlainObject(meta)) {
					// id가 지정된 grid
					// selector
					var recordSets = response.data.recordSets;
					if (!recordSets) {
						return;
					}
					$.each(meta, function(id, selector) {
						if ($(selector).attr('data-alopexgrid')) {
							dataSet.recordSets = $.extend(true, dataSet.recordSets, {});
							dataSet.recordSets[$elem.prop('id')] = gridToRecordSet($elem);
						}
					});
				}
			});
		}]],
		after : [],
		success : [
			[true, function(metas){
			if(!metas) return;
			if(!$.isArray(metas)) {
				metas = $.makeArray(arguments);
			}
		
			// sample implementation
			var response = this;

			$.each(metas, function(idx, meta) {
				if (typeof meta === "string" || (meta && meta.jquery && meta.prop('nodeType'))) {
					// 일반 form selector이거나 또는
					// grid selector. grid
					// selector일땐 id를 자동추출한다
					// 또는 일반 엘리먼트이거나 그리드 엘리먼트
					// 이거나
					var $elem = $(meta);
					if (!$elem.length || !$elem.prop('nodeType'))
						return;
					if (!$elem.prop('id')) {
						// 엘리먼트 ID가 없을때엔 향후
						// bind-extract를 위해 임의의
						// id를 배정한다.
						$elem.prop(id, randomId());
					}
					if ($elem.attr('data-alopexgrid')) {
						// 그리드일때의 바인딩은
						// recordSets에서 추출
						var recordSets = response.data.recordSets;
						if (!recordSets) {
							return;
						}
						if (recordSets.hasOwnProperty($elem.prop('id'))) {
							recordSetToGrid(recordSets[$elem.prop('id')], $elem);
						}
					} else {
						// 일반엘리먼트일 때의 바인딩은
						// fields에서 추출
						var id = $elem.attr('id');
						fieldsToElement(formDataFromData(response.data, id), $elem);
					}
				}
				if ($.isPlainObject(meta)) {
					// id가 지정된 grid selector
					var recordSets = response.data.recordSets;
					if (!recordSets) {
						return;
					}
					$.each(meta, function(id, selector) {
						if (recordSets.hasOwnProperty(id) && $(selector).attr('data-alopexgrid')) {
							recordSetToGrid(recordSets[id], $(selector));
						}
					});
				}
			});
		}]]
	});
	
	// 메타 프로세스에서 사용하는 함수들.
	// 클라이언트에서 작업 시 J2EE와 동일한 데이터 형식으로 작업하는 것을 표준으로 함.

	var seed = (Math.random() * 1000) | 0;
	function randomId() {
		return "J2EE" + seed++;
	}
	// 수신된 recordSet을 grid에 매핑시킨다
	function recordSetToGrid(rs, $elem) {
		var $target = $elem.jquery ? $elem : $($elem);
		if (!isValidElem($elem))
			return;
		if (!rs || !$elem)
			return;
		//
		$elem = $elem || $('#' + tableObject["TableName"]);
		if (!$elem.prop('nodeType'))
			return;
		if (!$elem.attr('data-alopexgrid'))
			return;
		var pobj = rs;
		// DOTO dataSet을 하면서 pagingObject를 넘기게 되면 이후에는 동적 페이징으로 작동한다.
		// 만일 동적 페이징을 사용하지 않고 한번에 모든 데이터를 로드하여 사용한다면
		// dataSet의 두번째 파라메터로 pagingObject를 넘기지 않는다.
		var dynamicpaging = pobj.hasOwnProperty('nc_pageNo') && (pobj['nc_pageNo'] > 0) && pobj.hasOwnProperty('nc_totalRecordCount') && pobj.hasOwnProperty('nc_recordCountPerPage');

		$target.alopexGrid('dataSet', $.isArray(pobj.nc_list) ? pobj.nc_list : [], dynamicpaging ? {
			current : pobj.nc_pageNo,
			total : Math.ceil(1.0 * pobj.nc_totalRecordCount / pobj.nc_recordCountPerPage) | 0,
			perPage : pobj.nc_recordCountPerPage,
			dataLength : pobj.nc_totalRecordCount
		} : null);
	}
	// 그리드로부터 recordSet을 추출한다.
	function recordSetToRecordSets(id, rs, rss) {
		if ($.isPlainObject(rss) && $.isPlainObject(rs) && typeof id === "string") {
			rss[id] = rs;
			return rss;
		}
	}
	function recordSetFromRecordSets(id, rss) {
		if ($.isPlainObject(rss) && typeof id === "string" && rss.hasOwnProperty(id)) {
			return rss[id];
		}
	}
	function gridToRecordSet(grid, rs) {
		var $target = grid.jquery ? grid : $(grid);
		var m_rs = {};
		var nc_list = $target.alopexGrid('dataGet');
		for ( var i = 0, l = nc_list.length; i < l; i++) {
			nc_list[i] = AlopexGrid.trimData(nc_list[i]);
		}
		var pageinfo = $target.alopexGrid('pageInfo');
		m_rs["nc_recordCount"] = nc_list.length;
		m_rs["nc_pageNo"] = pageinfo.current;
		m_rs["nc_recordCountPerPage"] = pageinfo.perPage;
		m_rs["nc_totalRecordCount"] = pageinfo.dataLength;
		m_rs["nc_list"] = nc_list;
		if ($.isPlainObject(rs)) {
			$.extend(true, rs, m_rs);
			return rs;
		}
		return m_rs;
	}

	// recordset을 grid외의 요소에 매핑시킬때의 규칙
	function recordSetToElement(rs, elem) {

	}
	function elementToRecordSet(elem, rs) {

	}

	// dataSet.fields의 값을 일반 databind로 적용
	function fieldsToElement(fields, elem) {
		// $.alopex.page[idselector] = $.alopex.databind(response.data.fields,
		// $target[0]);
		var $elem = (elem && elem.jquery) ? elem : $(elem);
		if (!$elem.length || !$elem.prop('nodeType')) {
			return;
		}
		if($.alopex.page['#' + $elem.prop('id')]) { // 이미 model이 생성된 경우.
			$.alopex.page['#' + $elem.prop('id')].set(fields);
		} else {
			$.alopex.page['#' + $elem.prop('id')] = $.alopex.datamodel($elem, true);
		    $.alopex.page['#' + $elem.prop('id')].set(fields);
		}
		
	}
	function elementToFields(elem, fields) {
		var $elem = (elem && elem.jquery) ? elem : $(elem);
		if (!$elem.length || !$elem.prop('nodeType'))
			return;
		if (!$.alopex.page['#' + $elem.prop('id')]) {
			$.alopex.page['#' + $elem.prop('id')] = $.alopex.datamodel('#' + $elem.prop('id'));
		}
		var model = $.alopex.page['#' + $elem.prop('id')].get();
		if ($.isPlainObject(fields)) {
			$.extend(true, fields, model);
		}
		return model;
	}
	// .NET에서 formdata를 DataSet에 넣는 케이스 고려.
	function formDataFromData(data, id) {
		var fields = $.extend(true, {}, data.fields);
		if (!id) {
			id = 'Table';
		}
		// .NET의 경우, form data의 경우도 datatable로 넘기는 경우가 다수 발생.
		if (data["recordSets"] && data["recordSets"][id] && $.isArray(data["recordSets"][id]["nc_list"])) {
			$.extend(true, fields, data["recordSets"][id]["nc_list"][0]);
		}
		return fields;
	}
	function isValidElem($elem) {
		if (!$elem || !$elem.prop('nodeType'))
			return false;
		return true;
	}
	
})(jQuery);
+function($) {
	$.extend($.alopex, {
		session: function() {
			if (window.opener && window.opener.$a) {
				var $parent = window.opener.$a;
				return $parent.session.apply(this, arguments);
			} else if (window.parent != window && window.parent.$a) {
				var $parent = window.parent.$a;
				return $parent.session.apply(this, arguments);
			} else {
				if (arguments.length == 1) {
					return memoryPreference.get(arguments[0]);
				} else if (arguments.length > 1) {
					memoryPreference.put.apply(null, arguments);
				}
			}
		},
		
		cookie: function() {
			if (arguments.length == 1) {
				return preference.get(arguments[0]);
			} else if (arguments.length > 1) {
				preference.put.apply(null, arguments);
			}
		}
	});
	$.alopex.session.clear = function() {
		memoryPreference.removeAll();
	};
	$.alopex.cookie.clear = function() {
		preference.removeAll();
	};
}(jQuery);

+function($) {
	/**
	 * 공통 설정 부분.
	 * before : 전처리, 
	 * after : success 판단 여부 처리 
	 * success : 성공 시 공통으로 처리해주는 후처리. 
	 * url : "" or function() {return "http://localhost:9000";}
	 * method : "GET" or "POST" or function() { return "GET";}
	 */
	$.alopex.request.setup({
//		platform: 'NEXCORE.J2EE',
//		//url : "http://150.28.65.2:7001/web/stand.jmd",
//		/* 조건에 따라 다른 url에 지정이 가능하다. */
//		url: function() {
//			if(true){
//				return "http://150.28.65.2:7001/web/stand.jmd";
//			}
//			return 'dddd'
//		},
//		//*/
//		method : "POST",
//		timeout: 3000,
//		before : function(id, option) { // before
//			// 전처리기.
//			$('body').progress(); //progress bar 시작
//		},
//		after : function(res) {
//			this.isSuccess = true | false;
//		},
//		success : function(res) {
//		},
//		fail: function(res) {
//		},
//		error  : function(err) {
//		}
	});
	
	
	$.alopex.navigate.setup({
		/**
		 * 이 함수를 통해 navigate 함수의 경로가 바뀌는 것을 조정할 수 있습니다.
		 */
		url: function(url, param) {
			var targetUrl = url;
//			var baseDirectory = '/html/';
//			var semanticUrl = window.location.href.split('?')[0];
//			semanticUrl = semanticUrl.replace('//', '');
//			semanticUrl = semanticUrl.substring(semanticUrl.indexOf('/') + 1); // protocol & domain 부분 제외. 절대 경로. '/FM/dd/
//			var currentUrlPath = semanticUrl.split('/');
//			var urlPath = targetUrl.split('/');
//			if(!$.alopex.util.isValid(currentUrlPath[currentUrlPath.length-1])) {
//				currentUrlPath.pop();
//			}
//			if(!$.alopex.util.isValid(urlPath[urlPath.length-1])) {
//				urlPath.pop();
//			}
//			var extension = '';
//			var path = currentUrlPath[currentUrlPath.length-1];
//			if(path.split('.').length>1) {
//				extension = path.split('.')[path.split('.').length-1].toLowerCase().trim();
//			}
//			var hasHTMLExtension = (extension == 'html');
//			
//			if(url.indexOf('/') == 0) { // 절대 경로.
//				if(currentUrlPath.length == urlPath.length) { // 절대 경로로 navigate함수 호출하고, 그에 따라 이동.
//					// do Nothing!
//				} else { // 모바일 프레임워크와 같이 /html/ 디렉토리가 기준이 되어 이동하는 케이스.
//					targetUrl = (baseDirectory + targetUrl);
//					if(hasHTMLExtension) { 
//						// Controller 사용 시 html확장자를 가지고 있는 경우, 
//						// 이동 기준이 되는 디렉토리가 html 폴더 기준으로 이동하는 것이 표준.
//						targetUrl += (targetUrl.lastIndexOf('.html') + 5 == targetUrl.length? '': '.html');
//					}
//				}
//			} else {
//				
//			}
			
			
			return targetUrl;
		}
	});
}(jQuery);



