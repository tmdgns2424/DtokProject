/*! Alopex UI - v2.2.30 - 2014-10-02
* http://ui.alopex.io
* Copyright (c) 2014 alopex.ui; Licensed Copyright. SK C&C. All rights reserved. */
/*!
* Copyright (c) 2012 SK C&C Co., Ltd. All rights reserved.
*
* This software is the confidential and proprietary information of SK C&C.
* You shall not disclose such confidential information and shall use it
* only in accordance with the terms of the license agreement you entered into
* with SK C&C.
*
* Alopex UI Javascript Validation Plugin
*
*/
(function($, window) {
	var rsubmitterTypes = /^(?:submit|button|image|reset|file)$/i, rsubmittable = /^(?:input|select|textarea|keygen)/i, manipulation_rcheckableType = /^(?:checkbox|radio)$/i, rCRLF = /\r?\n/g;

	function idFilterValue(param) {
		if (typeof param === "string" && param.indexOf("#") === 0){
			var $selected = $(param);
			return $selected.length ? $selected.val() : param;
		}
		return param;
	}
	var Validator = {
		defaultOption: {},
		addMethod: function(name, handler) {
			//handler : function(elem, value, param) for legacy support
			this.method[name] = function(value, param, elem) {
				return handler(elem, value, param);
			}
		},
		defineMethod: function(name, handler) {
			//handler : function(value, param, elem)
			this.method[name] = handler;
		},
		test: function(methodName, value, param) {
			var method = this.method[methodName];
			if (!$.isFunction(method)) {
				return "No such method : " + methodName;
			}
			return method(value, param);
		},
		method: { //function(extractedValue, param, elem) to support Validator.test('email', 'test@skcc.com') or something like that.
			required: function(value, param, elem) {
				if (typeof param === "string") {
					var $dep = $(param);
					var type = $dep.attr('type') || "";
					if (manipulation_rcheckableType.test(type)) {
						var name = $dep.attr('name');
						var $form = $(locateForm($dep));
						$dep = $dep.add($form.find('[name="' + name + '"]'));
					}
					var valueLength = getValueLength(extractValueFromArray(name, serializeInputs($dep)));
					if (valueLength === 0) {
						return "optional";
					}
				}
				if (isNullValue(value)) {
					if (param !== false) {
						return false;
					}
				}
				return true;
			},
			equalTo: function(value, param, elem) {
				return ((typeof param === "string" && param.indexOf("#") === 0) ? $(param).val() : param) === value;
			},
			minlength: function(value, param, elem) {
				return getValueLength(value) >= param;
			},
			maxlength: function(value, param, elem) {
				return getValueLength(value) <= param;
			},
			rangelength: function(value, param, elem) {
				if (!$.isArray(param)) {
					return false;
				}
				var len = getValueLength(value);
				return param[0] <= len && len <= param[1];
			},
			minblength: function(value, param, elem) {
				return getByteLength(value) >= param;
			},
			maxblength: function(value, param, elem) {
				return getByteLength(value) <= param;
			},
			rangeblength: function(value, param, elem) {
				if (!$.isArray(param)) {
					return false;
				}
				var len = getByteLength(value);
				return param[0] <= len && len <= param[1];
			},

			min: function(value, param, elem) {
				return Number(value) >= Number(param);
			},
			max: function(value, param, elem) {
				return Number(value) <= Number(param);
			},
			range: function(value, param, elem) {
				if (!$.isArray(param)) {
					return false;
				}
				return Number(param[0]) <= Number(value) && Number(value) <= Number(param[1]);
			},

			digits: function(value, param, elem) {
				return /^\s*\d+\s*$/.test(value);
			},
			number: function(value, param, elem) {
				return !isNaN(Number(value));
			},
			integer : function(value, param, elem) {
				return /^\s*(\+|-)?\d+\s*$/.test(value);
			},
			alphabet: function(value, param, elem) {
				return /^[a-zA-Z]*$/.test(value);
			},
			numalpha: function(value, param, elem) {
				return /^[0-9a-zA-Z]*$/.test(value);
			},
			nospace: function(value, param, elem) {
				return !/\s/g.test(value);
			},
			hangul: function(value, param, elem) {
				return /^[ㄱ-힣]*$/.test(value);
			},
			numhan: function(value, param, elem) {
				return /^[0-9ㄱ-힣]*$/.test(value);
			},
			email: function(value, param, elem) {
				return /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/.test(value);
			},
			url: function(value, param, elem) {
				var urlreg = new RegExp("^(http[s]?:\\/\\/(www\\.)?|ftp:\\/\\/(www\\.)?|(www\\.)?){1}([0-9A-Za-z-\\.@:%_\‌​+~#=]+)+((\\.[a-zA-Z]{2,3})+)(/(.)*)?(\\?(.)*)?");
				return urlreg.test(value);
			},
			date: function(value, param, elem) {
				return /^\d{4}[\/\-](0?[1-9]|1[012])[\/\-](0?[1-9]|[12][0-9]|3[01])$/.test(value);
			},
			mindate: function(value, param, elem) {
				var date = (new Date(value)).getTime();
				var from = (new Date(idFilterValue(param))).getTime();
				if (isNaN(date) || isNaN(from))
					return false;
				return from <= date;
			},
			maxdate: function(value, param, elem) {
				var date = (new Date(value)).getTime();
				var to = (new Date(idFilterValue(param))).getTime();
				if (isNaN(date) || isNaN(to))
					return false;
				return date <= to;
			},
			daterange: function(value, param, elem) {
				var isdate = /^\d{4}[\/\-](0?[1-9]|1[012])[\/\-](0?[1-9]|[12][0-9]|3[01])$/.test(value);
				if (!isdate || !$.isArray(param))
					return false;
				var from = (new Date(idFilterValue(param[0]))).getTime();
				var to = (new Date(idFilterValue(param[1]))).getTime();
				var date = (new Date(value)).getTime();
				if (isNaN(from) || isNaN(to) || isNaN(date))
					return false;
				return ((from <= date) && (date <= to));
			},
			oneof: function(value, param, elem) {
				if ($.isArray(param)) {
					for (var i = 0, l = param.length; i < l; i++) {
						if (value === param[i])
							return true;
					}
				}
				return false;
			},
			phone : function(value, param, elem) {
				var regExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})?-?[0-9]{3,4}-?[0-9]{4}$/;
				return regExp.test(value);
			},
			mobile : function(value, param, elem) {
				var regExp = /^(01[016789]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
				return regExp.test(value);
			},
			decimal : function(value, param, elem) {
				var v = String(value).split(',').join('');
				if(!(!isNaN(parseFloat(v)) && isFinite(v))) {
					return false;
				}
				var trimmedval = String(v).split('+').join('').split('-').join('');
				var llen = param[0];
				var rlen = param[1] || 0;
				var lval = trimmedval.split('.')[0];
				var rval = trimmedval.split('.')[1];
				if(llen && lval && (lval.length > (llen-rlen))) return false;
				if(rlen && rval && rval.length > rlen) return false;
				return true;
			}
		},
		defaultOption: {
			onsubmit: true,

			oninit: false,

			onkeyup: true,
			onchange: true,
			onblur: true,

			messageToLabel: false, //<label for="id" ...
			messageToDataFor: true, //<span data-for="id" ...

			validClass: null,
			invalidClass: null,
			validMessageClass: 'valid',
			invalidMessageClass: 'invalid'
		},
		message: {
			required: '반드시 입력해야 하는 항목입니다.',
			required_select: '반드시 선택해야 하는 항목입니다.',
			minlength: '최소 {0}글자 이상 입력하십시오.',
			maxlength: '최대 {0}글자 까지 입력 가능합니다.',
			rangelength: '{0}에서 {1} 글자 사이로 입력하십시오.',
			minblength: '최소 {0}바이트 이상 입력하십시오.',
			maxblength: '최대 {0}바이트 까지 입력 가능합니다.',
			rangeblength: '{0}에서 {1} 바이트 사이로 입력하십시오.',
			min: '최소 입력가능 값은 {0}입니다.',
			max: '최대 입력가능 값은 {0}입니다.',
			range: '{0}에서 {1} 사이의 값을 입력해 주십시오.',
			email: '이메일 형식에 맞게 입력해 주십시오.',
			url: 'url 형식에 맞게 입력해 주십시오.',
			date: '날짜를 YYYY/MM/DD 또는 YYYY-MM-DD 형식에 맞게 입력해 주십시오.',
			mindate: '{0} 또는 {0} 이후의 날짜를 입력해 주십시오.',
			maxdate: '{0} 또는 {0} 이전의 날짜를 입력해 주십시오.',
			daterange: '{0}에서 {1} 사이의 날짜를 입력해 주십시오.',
			oneof: '다음중 하나의 값을 입력해 주십시오 : {param}.',
			number: '실수를 입력해 주십시오.',
			integer: '정수를 입력해 주십시오.',
			digits: '숫자만 입력 가능합니다.',
			alphabet: '알파벳만 입력 가능합니다.',
			equalTo: '{0} 값만 가능합니다.',
			numalpha: '숫자 또는 영문자만 입력 가능합니다.',
			nospace: '스페이스는 입력할 수 없습니다.',
			hangul: '한글만 입력 가능합니다.',
			numhan: '숫자 또는 한글만 입력 가능합니다.',
			phone:'대시(-)가 들어간 전화번호 형태를 입력해 주십시오.',
			mobile:'대시(-)가 들어간 휴대전화번호 형태를 입력해 주십시오.',
			decimal:'최대 {0}자리 정수, 소숫점 {1}자리까지 허용됩니다.'
		},
		setMessage: function(name, message) {
			this.message[name] = message;
		},
		mergeErrorMessage: function(messages, name) {
			function mergeArray(messageArray, name) {
				var result = "";
				name = name || messageArray.name;
				if ($.isArray(messageArray)) {
					result = name ? (name + " : ") : "";
					$.each(messageArray, function(idx, msg) {
						result += msg + " ";
					});
				}
				return result;
			}
			function mergeObject(messageObject) {
				var result = "";
				if ($.isPlainObject(messageObject)) {
					$.each(messageObject, function(name, messageArray) {
						result += mergeArray(messageArray, null) + '\n';
					});
				}
				return result;
			}
			if ($.isArray(messages)) {
				return mergeArray(messages, name);
			}
			return mergeObject(messages);
		}
	};
	var uniqueidbase = new Date().getTime() % 100;
	function generateUniqueId() {
		return "alopexvalidator" + (uniqueidbase++);
	}
	function stringify(obj, stringquote) {
		var str = "";
		if ($.isPlainObject(obj)) {
			str += "{";
			var started = false;
			for ( var prop in obj) {
				if (obj.hasOwnProperty(prop)) {
					if (started) {
						str += ',';
					} else {
						started = true;
					}
					str += (prop + ':');
					str += stringify(obj[prop], stringquote);
				}
			}
			str += "}";
		} else if ($.isArray(obj)) {
			var newarr = [];
			for (var i = 0; i < obj.length; i++) {
				newarr[i] = stringify(obj[i], stringquote);
			}
			str += "[" + newarr.join(',') + "]";
		} else if (typeof obj === "string") {
			var q = typeof stringquote === "string" ? stringquote : "'";
			str += q + obj + q;
		} else {
			str += obj;
		}
		return str;
	}
	function evalObjectString(str) {
		if (typeof str !== "string" || str === "" || !str)
			return null;
		var result = eval('(' + str + ')');
		return $.isPlainObject(result) ? result : null;
	}
	function getObjectProperty() {
		var args = $.makeArray(arguments);
		if (args.length <= 1 || !$.isPlainObject(args[0])) {
			return args[0];
		}
		args[1] = args[0][args[1]];
		return getObjectProperty.apply(null, args.slice(1));
	}
	function hasClass(el, name) {
		return new RegExp('(\\s|^)' + name + '(\\s|$)').test(el.className);
	}
	function addClass(el, name) {
		if (!hasClass(el, name)) {
			el.className = el.className + (el.className ? ' ' : '') + name;
		}
	}
	function removeClass(el, name) {
		if (hasClass(el, name)) {
			el.className = el.className.replace(new RegExp('(\\s|^)' + name + '(\\s|$)'), ' ').replace(/^\s+|\s+$/g, '');
		}
	}

	function serializeInputs($inputs) {
		return $inputs.filter(function() {
			var type = this.type;
			// Use .is(":disabled") so that fieldset[disabled] works
			return this.name && /*!jQuery(this).is(":disabled") && */ rsubmittable.test(this.nodeName) && !rsubmitterTypes.test(type) && (this.checked || !manipulation_rcheckableType.test(type));
		}).map(function(i, elem) {
			var val = jQuery(this).val();
			return val == null ? null : jQuery.isArray(val) ? jQuery.map(val, function(val) {
				return {
					name: elem.name,
					value: val.replace(rCRLF, "\r\n")
				};
			}) : {
				name: elem.name,
				value: val.replace(rCRLF, "\r\n")
			};
		}).get();
	}
	function extractValueFromArray(name, serializedArray) {
		var value = null;
		$.each(serializedArray, function(idx, entity) {
			if (entity.name === name) {
				if (value === null) {
					value = entity.value;
				} else {
					value = $.isArray(value) ? value : [value];
					value.push(entity.value);
				}
			}
		});
		return value;
	}
	function isNullValue(value) {
		if (value === null || value === undefined || value === "") {
			return true;
		}
		return false;
	}
	function getByteLength(value) {
		if (isNullValue(value)) {
			return 0;
		}
		if (value.hasOwnProperty('length')) {
			var len = 0,ch;
			for(var i=0;ch = value.charCodeAt(i++); len += ch>>11?3:ch>>7?2:1);
			return len;
		}
		return 0;
	}
	function getValueLength(value) {
		if (isNullValue(value)) {
			return 0;
		}
		if (value.hasOwnProperty('length')) {
			return value.length || 0;
		}
		return 0;
	}
	function validate($form, $inputs, $messages, serializedArray, continueAfterFirstInvalid, returnErrorMessage) {
		var result = true;
		var errorMessage = {};

		$inputs.filter('[data-validate-rule],[data-validation-rule]').each(function(idx) {
			var input = this;
			var type = input.attributes['type'];
			var name = input.attributes['name'];
			var rule = $.extend({},
					//$.data(input,'data-validation-rule'),
					evalObjectString(input.attributes['data-validation-rule'] ? input.attributes['data-validation-rule'].value:null),
					evalObjectString(input.attributes['data-validate-rule'] ? input.attributes['data-validate-rule'].value:null));
			if($.isEmptyObject(rule)) return;
			var option = $.extend({},
					Validator.defaultOption,
					$.data(input,'data-validation-option'),
					evalObjectString(input.attributes['data-validation-option'] ? input.attributes['data-validation-option'].value:null),
					evalObjectString(input.attributes['data-validate-option'] ? input.attributes['data-validate-option'].value:null));
			var message = $.extend({},
					Validator.message,
					$.data(input,'data-validation-message'),
					evalObjectString(input.attributes['data-validation-message'] ? input.attributes['data-validation-message'].value:null),
					evalObjectString(input.attributes['data-validate-message'] ? input.attributes['data-validate-message'].value:null));
			var vname = input.attributes['data-validate-name'] || input.attributes['data-validation-name'];
			var judge = true;
			var id = input.id;

			type = type ? type.value : 'text';
			name = name ? name.value : '';

			var value = extractValueFromArray(name, serializedArray);

			for ( var methodName in rule) {
				var method = Validator.method[methodName];
				var param = rule[methodName];
				//method 자체가 없을 경우 에러메세지는 다른 양상으로 생성이 되어야 함.
				var methodTest = $.isFunction(method) ? method(value, param, input) : false;
				if (methodTest === "optional") {
					delete errorMessage[name];
					judge = true;
					break;
				}
				if (!methodTest && name && !errorMessage[name]) {
					errorMessage[name] = [];
				}

				if (!methodTest) {
					var resultMessage = message[methodName] || "";
					if ($.isFunction(resultMessage)) {
						resultMessage = resultMessage.call(input, input, param);
					} else {
						var ruleParam = $.isArray(param) ? param : [param];
						for (var i = 0; i < ruleParam.length; i++) {
							//resultMessage = resultMessage.replace('{' + i + '}', ruleParam[i]);
							resultMessage = resultMessage.split('{'+i+'}').join(idFilterValue(ruleParam[i]));
						}
						resultMessage = resultMessage.replace(/{param}/g, $.isArray(param) ? ('"' + param.join('", "') + '"') : idFilterValue(param));
						resultMessage = resultMessage.replace(/{attr:([^}]*)}/g, function(a0, a1, a2, a3) {
							return input.getAttribute(a1);
						});

					}
					resultMessage = option.title ? resultMessage.replace('{title}', option.title) : resultMessage;
					if (vname && vname.value) {
						errorMessage[name] ? (errorMessage[name].name = vname.value) : "";
					}
					errorMessage[name] ? errorMessage[name].push(resultMessage) : "";
				}
				if (methodTest === false) {
					judge = false;
					if (continueAfterFirstInvalid !== true) {
						break;
					}
				}
			}

			if (isNullValue(value)) { //값이 없는데 required가 아닌 경우 테스트결과를 반영하지 않는다.
				if (rule.required !== true && typeof rule.required !== "string") {
					judge = true;
					delete errorMessage[name];
				}
			}

			if (returnErrorMessage !== true) { //에러메세지 취합이 아닌, DOM에 결과를 반영하는 경우.
				$messages ? $messages.each(function() {
					var doit = false;
					if (option.messageToLabel && this.tagName === "LABEL" && this.attributes["for"] && this.attributes["for"].value === id) {
						doit = true;
					}
					if (option.messageToDataFor && this.attributes["data-for"] && this.attributes["data-for"].value === id) {
						doit = true;
					}
					if (doit) {
						this.innerText = continueAfterFirstInvalid === true ? (errorMessage[name] || []).join(' ') : (getObjectProperty(errorMessage, name, 0) || "");
						option.validMessageClass ? (judge ? addClass : removeClass)(this, option.validMessageClass) : "";
						option.invalidMessageClass ? (!judge ? addClass : removeClass)(this, option.invalidMessageClass) : "";
					}
				}) : "";
				if (option.validClass || option.invalidClass) {
					option.validClass ? (judge ? addClass : removeClass)(input, option.validClass) : "";
					option.invalidClass ? (!judge ? addClass : removeClass)(input, option.invalidClass) : "";
				}
			}

			if (judge === false) {
				result = false;
			}
		});
		return (returnErrorMessage === true) ? errorMessage : result;
	}
	function locateForm(elem) {
		if (elem.jquery && elem.length>0) {
			elem = elem[0];
		}
		var tagName = elem.tagName;
		while (tagName !== "FORM" && tagName !== "BODY" && tagName !== "HEAD") {
			elem = elem.parentNode;
			if (!elem) {
				return document.body;
			}
			tagName = elem.tagName;
		}
		if (tagName === "BODY" || tagName === "HEAD") {
			return document.body;
		}
		return elem;
	}
	function createNameForInputs($inputs) {
		$inputs.filter(
				function() {//name이 없는 input들에 대해서 name이 필요한지 판별하고, name을 임의로 생성하여 넣는다.
					var type = this.type;
					return !this.name && (this.attributes['data-validate-rule'] || this.attributes['data-validation-rule']) 
						&& rsubmittable.test(this.nodeName) && !rsubmitterTypes.test(type) 
						&& (((this.checked || manipulation_rcheckableType.test(type)) && (this.value || this.value.length)) 
								|| !manipulation_rcheckableType.test(type) //checkable인데 값이 있거나, 아님 아예 checkable이 아니거나.
							);
				}).each(function() {
			if (!this.name) {
				this.name = generateUniqueId();
			}
		});
	}
	function addGroupInputs($form, $inputs) {
		$inputs.each(function(idx, input){
			var type = input.type;
			if (manipulation_rcheckableType.test(type)) {
				$inputs = $inputs.add($form.find('[name="' + input.name + '"]'));
			}
		});
		return $inputs;
	}

	//Validate Plugin
	$.fn.validate = function() {
		var $elem = this.eq(0);
		var $form = null;
		var $inputs = null;
		var $messages = null;
		var serializedArray = null;
		var validatePlainObject = false;
		var updateConfig = false;
		var _argc = 0;
		if ($.isPlainObject(arguments[0])) {
			updateConfig = arguments[_argc++];
		}
		var _continueAfterFirstInvalid = arguments[_argc++];
		var _returnErrorMessage = arguments[_argc++];

		if ($.isPlainObject($elem[0])) {
			validatePlainObject = $elem[0];
		}
		$form = $(locateForm($elem));

		if (validatePlainObject) {
			var vconf = validatePlainObject;
			var $inputs = $();
			$.each($elem[0], function(key, value) {
				var $input = $('<input type="hidden">');
				$input.attr('name', key).attr('value', value);
				$inputs = $inputs.add($input);
			});
		} else {
			if ($elem.prop('tagName') === "FORM") {
				$inputs = $form.map(function() {
					var elements = jQuery.prop(this, "elements");
					return jQuery.makeArray(elements);
				});
			} else if(rsubmittable.test(($elem.prop('tagName')+"").toLowerCase())){
				//form이 아닐경우, 다중선택지(input[type="checkbox"] 등)가 존재하는 요소에 대해 이들을 추가로 선택하여 더해야 한다.
				$inputs = this;
//				var type = $inputs.prop('type');
//				if (manipulation_rcheckableType.test(type)) {
//					$inputs = $inputs.add($form.find('[name="' + $inputs.attr('name') + '"]'));
//				}
			} else {
				$form = this;
				$inputs = $form.find('[data-validate-rule],[data-validation-rule]');
			}
		}
		if (updateConfig) {
			$inputs.validator(updateConfig);
		}
		$inputs = addGroupInputs($form,$inputs);
		createNameForInputs($inputs);//name이 없는 input들에 대해서 name이 필요한지 판별하고, name을 임의로 생성하여 넣는다.
		serializedArray = serializeInputs($inputs);
		$messages = $form.find('[for], [data-for]');
		var returnValue = validate($form, $inputs, $messages, serializedArray, _continueAfterFirstInvalid, _returnErrorMessage);
		if (_returnErrorMessage === true && $elem.prop('tagName') !== 'FORM' && $elem.prop('name')) {
			returnValue = returnValue[$elem.prop('name')] || null;
		}
		return returnValue;
	};

	//Validator Plugin
	$.fn.validator = function(config) {
		var $targets = this;
		var $form = locateForm(this);
		var isFormConfig = false;
		if (this.prop('tagName') === 'FORM') {
			$targets = $targets.add($($.makeArray(this.prop("elements"))));
			isFormConfig = true;
		}
		$targets.each(function() {
			var $this = $(this);
			var isForm = (this.tagName === "FORM");
			var type = $this.attr('type');
			var name = $this.attr('name');

			if ($.isPlainObject(config) && !$.isEmptyObject(config)) {//configuration update
				if (!isForm) {
					var updatedRule = $.extend({}, 
							evalObjectString($this.attr('data-validation-rule')),
							evalObjectString($this.attr('data-validate-rule')),
							getObjectProperty(config, 'rule'), 
							getObjectProperty(config, 'elements', name, 'rule')
							);
					var updatedMessage = $.extend({}, 
							$this.data('data-validation-message'),
							evalObjectString($this.attr('data-validation-message')),
							evalObjectString($this.attr('data-validate-message')),
							getObjectProperty(config, 'message'), 
							getObjectProperty(config, 'elements', name,'message')
							);
					if(!$.isEmptyObject(updatedRule)){
						$this.attr('data-validation-rule', stringify(updatedRule)).removeAttr('data-validate-rule');
					}
					if(!$.isEmptyObject(updatedMessage)) {
						//$this.attr('data-validation-message', stringify(updatedMessage)).removeAttr('data-validate-message');
						$this.data('data-validation-message', updatedMessage).removeAttr('data-validate-message').removeAttr('data-validation-message');
					}
				}
				var updatedOption = $.extend({}, 
						$this.data('data-validation-option'),
						evalObjectString($this.attr('data-validation-option')),
						evalObjectString($this.attr('data-validate-option')), 
						!isForm && isFormConfig ? null : getObjectProperty(config, 'option'), 
						getObjectProperty(config, 'elements', name, 'option')
						);
				if(!$.isEmptyObject(updatedOption)) { 
					//$this.attr('data-validation-option', stringify(updatedOption)).removeAttr('data-validate-option');
					$this.data('data-validation-option', updatedOption).removeAttr('data-validate-option').removeAttr('data-validation-option');
				}
			}

			var rule = $.extend({}, 
					$this.data('data-validation-rule'),
					evalObjectString($this.attr('data-validation-rule')), 
					evalObjectString($this.attr('data-validate-rule'))
					);
			var option = $.extend({},
					Validator.defaultOption,
					$this.data('data-validation-option'),
					evalObjectString($this.attr('data-validation-option')),
					evalObjectString($this.attr('data-validate-option'))
					);
			var message = $.extend({},
					Validator.message,
					$this.data('data-validation-message'),
					evalObjectString($this.attr('data-validation-message')),
					evalObjectString($this.attr('data-validate-message'))
					);
			//config.rule, config.message, config.option
			//isForm ? config.elements, config.option
			if (isForm) {
				$this.off('.alopexvalidatorFormSubmit')
				if (option.onsubmit) {
					$this.on('submit.alopexvalidatorFormSubmit', option.submitHandler || function(e) {
						if (!$(this).validate()) {
							e.preventDefault();
						}
					});
				}
			} else {
				if (typeof rule.required === "string" && rule.required.indexOf('#') === 0) {
					//ID selector required로 되어있던 input의 rule.required값을 변경할 경우 의존하고 있는 엘리먼트가 변경될 때
					//의존중인 엘리먼트의 rule.required값을 확인하여 계속 의존하고 있지 않을경우 데이터를 삭제하도록 한다.
					var $requiredElem = $(rule.required);
					$requiredElem.data('alopexvalidatorDependency', $this.add($requiredElem.data('alopexvalidatorDependency')));
				}

				$this.off('.alopexvalidatorInputChange');
				var events = [];
				if (option['onkeyup']) {
					option['onclick'] = true;
				}
				$.each(['onkeyup', 'onchange', 'onblur', 'onclick'], function(idx, eventname) {
					if (option[eventname]) {
						events.push(eventname.split('on')[1] + '.alopexvalidatorInputChange');
					}
				});
				if (events.length) {
					$this.on(events.join(' '), function(e) {
						var $eventthis = $(this);
						setTimeout(function() {
							//check의 경우 포커스를 잃기 전까지 값이 바뀌지 않는다.
							//http://stackoverflow.com/questions/4471401/getting-value-of-html-checkbox-from-onclick-onchange-events
							$eventthis.validate();
							//다른 input이 이 input을 required로 지정했을때의 처리
							var $dep = $eventthis.data('alopexvalidatorDependency');
							if ($dep) {
								var dependencyRule = $.extend({},
										evalObjectString($dep.attr('data-validation-rule')),
										evalObjectString($dep.attr('data-validate-rule')));
								var dependencyValid = $.isPlainObject(dependencyRule) && (dependencyRule.required === ('#' + $eventthis.prop('id')));
								if (dependencyValid) {
									$dep.validate();
								} else {
									var $data = $requiredElem.data('alopexvalidatorDependency');
									if ($data && $data.jquery) {
										$data = $data.remove('#' + $eventthis.prop('id'));
									}
									if (!$data || !$data.length) {
										$eventthis.removeData('alopexvalidatorDependency');
									}
								}
							}
						}, 0);
					});
				}
			}

			if (option.oninit || getObjectProperty(config, 'oninit')) {
				setTimeout(function() {
					$this.validate();
				}, 0);
			}
			//TODO javascript config를 checkbox 등에 적용하는 경우 attribute가 동일 name input에 모두 생성이 된다.
			//이에 대한 대책은?
		});
		return this;
	};
	var _getErrorMessageConflict = $.fn.getErrorMessage;
	$.fn.getErrorMessage = function() {
		if (_getErrorMessageConflict) {
			var _runPrev = true;
			var $targets = this;
			if ($targets.prop('elements')) {
				$targets = $targets.add($($.makeArray($targets.prop('elements'))));
			}
			$targets.each(function() {
				if (this.attributes['data-validate-rule'] || this.attributes['data-validation-rule']) {
					_runPrev = false;
					return false;
				}
			});
			if (_runPrev) {
				return _getErrorMessageConflict.apply(this, arguments);
			}
		}
		return this.validate(true, true);
	};
	//  $(function() {
	//    $('[data-validate-option]').validator();
	//  })
	window.Validator = Validator;
})(jQuery, window);