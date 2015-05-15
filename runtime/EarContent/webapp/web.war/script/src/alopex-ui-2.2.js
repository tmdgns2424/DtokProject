/*! Alopex UI - v2.2.30 - 2014-10-02
* http://ui.alopex.io
* Copyright (c) 2014 alopex.ui; Licensed Copyright. SK C&C. All rights reserved. */

var __ALOPEX_DEBUG = false;
var __ALOG = function() {};
if(__ALOPEX_DEBUG) { // TODO  IE에서 에러나지 않게 수정. (console.log 사용시)
	try{
		__ALOG = Function.prototype.bind ? console.log.bind(console) : function(){console.log(jQuery.makeArray(arguments).join(' '));};
	}catch(e){}
}

(function($) {
	
	$.alopex = $.extend($.alopex, {
		configMethods: {},
		widget : {},
		util: {},
		
		inherit: function(parent, child) {
			var obj = $.extend({}, parent, child);
			obj.eventHandlers = $.extend({}, parent.eventHandlers, child.eventHandlers);
			parent.getters = parent.getters || []; 
			parent.setters = parent.setters || [];
			child.getters = child.getters || [];
			child.setters = child.setters || [];
			obj.getters = parent.getters.concat(child.getters);
			obj.setters = parent.setters.concat(child.setters);
			obj.properties = $.extend({}, parent.properties, child.properties);
			obj.parent = parent;
			obj.markup = child.markup;
			obj.style = child.style;
			obj.event = child.event;
			obj.init = child.init;
			obj.defer = child.defer;
			return obj;
		},
		
		/**
		 * widget의 property를 등록하는 함수. 
		 * load 시점 이전에 호출하여야 한다.
		 */
		setup: function(widgetname, option) {
			if ($.alopex.widget[widgetname]) { // Alopex UI Component
				$.extend($.alopex.widget[widgetname].properties, option);
			} else if ($.isFunction($.alopex.configMethods[widgetname])) {
				$.alopex.configMethods[widgetname](option);
			}
		},
		
		registerSetup: function(name, handler) {
			$.alopex.configMethods[name] = handler;
		},
		
		convert: function(root) {
			var startup = {
				markup: [],
				style: [],
				event: [],
				init: [],
				defer: []
			};
			if(!$.alopex.util.isValid(root)) {
				root = 'body';
			}

			// Converting Order : markup -> style -> event -> init -> defer 
			$(root).find('[data-type]').each(function() {
				var inits = $.alopex.widget.object._getInitHandlers(this);
				startup.markup = startup.markup.concat(inits.markup);
				startup.style = startup.style.concat(inits.style);
				startup.event = startup.event.concat(inits.event);
				startup.init = startup.init.concat(inits.init);
				startup.defer = startup.defer.concat(inits.defer);
			});

			for ( var i = 0; i < startup.markup.length; i++) {
				var object = startup.markup[i];
				if(!$.alopex.util.isConverted(object.element)) { // checkup of pre-generated element
					object.constructor.call(object.widget, object.element, $.alopex.util.getOptions(object.element));
				}
			}
			for ( var i = 0; i < startup.style.length; i++) {
				var object = startup.style[i];
				if(!$.alopex.util.isConverted(object.element)) {
					object.constructor.call(object.widget, object.element, $.alopex.util.getOptions(object.element));				
				}
			}
			for ( var i = 0; i < startup.init.length; i++) {
				var object = startup.init[i];
				if(!$.alopex.util.isConverted(object.element)) {
					object.constructor.call(object.widget, object.element, $.alopex.util.getOptions(object.element));
				}
			}
			for ( var i = 0; i < startup.event.length; i++) {
				var object = startup.event[i];
				if(!$.alopex.util.isConverted(object.element)) {
					object.constructor.call(object.widget, object.element, $.alopex.util.getOptions(object.element));
				}
			}
			for ( var i = 0; i < startup.defer.length; i++) {
				var object = startup.defer[i];
				if(!$.alopex.util.isConverted(object.element)) {
					object.constructor.call(object.widget, object.element, $.alopex.util.getOptions(object.element));
				}
			}
			
			//$(document).trigger('alopexuiready');
			// alopexuiready 이벤트는 alopexready가 발생하지 않는 상황(tabs 컨텐트 로딩 등)에서
			// init 함수가 호출되는 기준이 됨. 그러나, 시점 차이로 인해 로딩 시 발생하는 것 보다 
			// 특정 케이스에서 강제로 처리.(탭 로딩 이후 컨버트까지 처리한 이후에 발생하는 등)
		},
		
		checkBrowser: function() {
			// Browser Check
			if ("ontouchstart" in document.documentElement || 'ontouchstart' in window) {
				window.browser = 'mobile';
			} else if (navigator.userAgent.toLowerCase().indexOf('msie') !== -1) {
				window.browser = 'ie';
			} else if (navigator.userAgent.toLowerCase().indexOf('chrome') !== -1) {
				window.browser = 'chrome';
			} else if (navigator.userAgent.toLowerCase().indexOf('safari') !== -1) {
				window.browser = 'safari';
			} else if (navigator.userAgent.toLowerCase().indexOf('gecko') !== -1) {
				window.browser = 'firefox';
			} else if (navigator.userAgent.toLowerCase().indexOf('opera') !== -1) {
				window.browser = 'opera';
			}
		},
		
		_getter: function(methodname, args) {
			if (this.length < 1) {
				return this;
			}
			var el = this[0];
			var dataType = (this.prop('alopextype'))?this.prop('alopextype'): [];
			if($.alopex.util.isValid(el.getAttribute('data-type'))) {
				dataType = $.alopex.util.arrayjoin(new Array(el.getAttribute('data-type')), dataType)
			}
			if ($.alopex.util.isValid(dataType)) {
				for(var i=0; i<dataType.length; i++) {
					var component = $.alopex.widget[dataType[i]];
					var method = component[methodname];
					if(method && typeof method == 'function'){
						if ($.alopex.util.isValid(component)) {
							var newArg = [el];
							for ( var i = 0; i < args.length; i++) {
								newArg.push(args[i]);
							}
							if(!$.alopex.util.isValid(el.alopex)) { // init process not started
								component._constructor.apply(component, [this, $.extend($.alopex.util.getOptions(this), args.length>0?args[0]:undefined)]);
							} else if(!$.alopex.util.isConverted(this)) {
								// in case the component is not converted
								//component._constructor.apply(component, [this, $.extend($.alopex.util.getOptions(this), args.length>0?args[0]:undefined)]);
								var __comp = component;
								var __args = newArg;
								$(el).one('initcomplete.alopexui', function() {
									return __comp[methodname].apply(__comp, __args);
								})
							}
							return component[methodname].apply(component, newArg);
						}
					}
				}
			}
		},
		
		_setter: function(methodname, args) {
			return this.each(function() {
				var dataType = ($(this).prop('alopextype'))?$(this).prop('alopextype'): [];
				if($.alopex.util.isValid(this.getAttribute('data-type'))) {
					dataType = $.alopex.util.arrayjoin(new Array(this.getAttribute('data-type')), dataType)
				}
				if (dataType.length > 0) {
					var newArg = [this];
					for ( var i = 0; i < args.length; i++) {
						newArg.push(args[i]);
					}
					for(var i=0; i<dataType.length; i++) {
						var component = $.alopex.widget[dataType[i]];
						var method = component[methodname];
						if(dataType[i] == methodname) { // init method
							if(component && component._constructor) { 
								component._constructor.apply(component, [this, $.extend($.alopex.util.getOptions(this), args.length>0?args[0]:undefined)]);
								break;
							}
						} else if(method && typeof method == 'function'){
							if ($.alopex.util.isValid(component)) {
								if(!$.alopex.util.isValid(this.alopex)) { // init process not started 
									component._constructor.apply(component, [this, $.extend($.alopex.util.getOptions(this), args.length>0?args[0]:undefined)]);
									component[methodname].apply(component, newArg);
								} else if(!$.alopex.util.isConverted(this)) { // init started, but not finished.
									// in case the componenet is not converted
									var __comp = component;
									var __args = newArg;
									$(this).one('initcomplete.alopexui', function() {
										__comp[methodname].apply(__comp, __args);
									})
								} else { // converted
									component[methodname].apply(component, newArg);
								}
								
								break;
							}
						}
					}
				} else if($.alopex.widget[methodname]) { // CASE : no data-type attribute, but constructor method called
					var component = $.alopex.widget[methodname];
					if(component.pre) {
						component.pre.apply(component, [this]);
					}
				}
			});
		}
	})
	
	$.fn.convert = function() {
		return this.each(function(){
			$.alopex.convert(this);
		});
	};
	
	$.fn.setEnabledAll = function(flag) {
		var $el = this;
		$el.find('input[data-type], select[data-type], button[data-type], textarea[data-type]').each(function() {
			$(this).setEnabled(flag);
		});
	};

})(jQuery);

(function($) {

	var builtInRegexp = {
			digits: '0-9',
			lowercase: 'a-z',
			uppercase: 'A-Z',
			english: 'a-zA-Z',
			korean: '\u3131-\u3163\uac00-\ud7a3 ', // in IE, set value and type keyboard cause everything gone
			singlespace: ' ',
			decimal: '0-9.-'
	};

	var builtInKeyCode = {
			digits: '0-9',
			lowercase: 'A-Z',
			uppercase: 'A-Z',
			english: 'A-Z',
			korean: 'å',
			singlespace: ' ',
			decimal: '0-9.-'
	};
	
	var FnKeyCode = {
			8 : 'backspace',
			9 : 'tab',
			13 : 'enter',
			16 : 'shift',
			17 : 'ctrl',
			18 : 'alt',
			19 : 'pausebreak',
			20 : 'capslock',
			21 : 'han/young',
			25 : 'chinese',
			27 : 'esc',
			//32 : 'space', // space는 function키에서 제외.
			33 : 'pageup',
			34 : 'pagedown',
			35 : 'end',
			36 : 'home',
			37 : 'left',
			38 : 'up',
			39 : 'right',
			40 : 'down',
			45 : 'insert',
			46 : 'delete',
			91 : 'win-left',
			92 : 'win-right',
			93 : 'function',
			112 : 'f1',
			113 : 'f2',
			114 : 'f3',
			115 : 'f4',
			116 : 'f5',
			117 : 'f6',
			118 : 'f7',
			119 : 'f8',
			120 : 'f9',
			121 : 'f10',
			122 : 'f11',
			123 : 'f12',
			144 : 'numlock',
			145 : 'scrolllock'
	};
	

	var _to_ascii = {
			'188': '44',
			'109': '45',
			'190': '46', //period(.)
			'191': '47', //forward slash(/)
			'192': '96',
			'220': '92',
			'222': '39',
			'221': '93',
			'219': '91',
			'173': '45',
			'187': '61', //equal sign(=+) IE Key codes
			'186': '59', // IE Key codes
			'189': '45', //dash(-) IE Key codes
			'96': '48', //numpad 0
			'97': '49', //numpad 1
			'98': '50', //numpad 2
			'99': '51', //numpad 3
			'100': '52', //numpad 4
			'101': '53', //numpad 5
			'102': '54', //numpad 6
			'103': '55', //numpad 7
			'104': '56', //numpad 8
			'105': '57', //numpad 9
			'109': '45', //numpad subtract(-)
			'110': '46', //numpad decimal point(.)
			'111': '47' //numpad device(/)
	};
  

	var shiftUps = {
			'96': '~',
			'49': '!',
			'50': '@',
			'51': '#',
			'52': '$',
			'53': '%',
			'54': '^',
			'55': '&',
			'56': '*',
			'57': '(',
			'48': ')',
			'45': '_',
			'61': '+',
			'91': '{',
			'93': '}',
			'92': '|',
			'59': ':',
			'39': '\'',
			'44': '<',
			'46': '>',
			'47': '?'
	};
	
	var ATTRIBUTE = 'keyfilter';
	function checkWord(text, regexp) {
		
		var result = text.match(regexp);
		if(text == '' || result != null && result[0] == text) {
			return true;
		}
		return false;
	}
	
	function checkElement(element, regexp) {
		if(regexp) {
			var text, inputvalue;
			text = inputvalue =  $(element).val();
			var str = '';
			var strend = '';
			while(!checkWord(text, regexp)) {
				str = text;
				text = str.substr(0, str.length-1);
				var lastch = str.substr(str.length-1);
				if(checkWord(lastch, regexp)) {
					strend = lastch + strend;
				}
			}
			if(text + strend != inputvalue) {
				var newvalue = text + strend;
				$(element).val(newvalue);
			}
			
		}
	}
  
	$(document).on('keydown.datafilter', '[data-' + ATTRIBUTE + '-rule]', function(e) {

    var key = e.which || e.charCode || e.keyCode;

    // allow copy&paste c = 67, v = 86
    if ((e.ctrlKey || e.metaKey) && (key === 67 || key === 86)) {
      return;
    }

    if (FnKeyCode[key])
      return;
    var builtinRule = $(e.currentTarget).attr('data-' + ATTRIBUTE + '-rule');
    if (typeof builtinRule == 'string') {
      var subrule = builtinRule.split('|');
      var rule = '';
      if (subrule.length == 1) {
        rule = builtInKeyCode[builtinRule];
      } else {
        for ( var i = 0; i < subrule.length; i++) {
          var temp = subrule[i];
          if (builtInKeyCode[temp]) {
            rule += builtInKeyCode[temp];
          }
        }
      }

      if (rule) {
        rule = new RegExp('[' + rule + ']', 'g');

        // normalize keyCode
        if (_to_ascii.hasOwnProperty(key)) {
          key = _to_ascii[key];
        }

        var ch = String.fromCharCode(key);

        var isUp = (key >= 65 && key <= 90) ? true : false; // uppercase
        var isLow = (key >= 97 && key <= 122) ? true : false; // lowercase
        var isShift = ( e.shiftKey ) ? e.shiftKey : ( (key == 16) ? true : false ); // shift is pressed

        // CAPSLOCK is on 무조건 대문자
        if ((ch.toUpperCase() === ch && ch.toLowerCase() !== ch && !isShift)|| //caps is on
            (ch.toUpperCase() !== ch && ch.toLowerCase() === ch && isShift)) {
          //ch = String.fromCharCode(key);
        } else if ((ch.toLowerCase() === ch && ch.toUpperCase() !== ch && !isShift)||
            (ch.toLowerCase() !== ch && ch.toUpperCase() === ch && isShift)){
          if (isUp && !isShift) {
            ch = String.fromCharCode(key + 32);
          } else if (isShift && shiftUps.hasOwnProperty(key)) {
            // get shifted keyCode value
            ch = shiftUps[key];
          }
        }

        if (!$(e.currentTarget).attr('data-' + ATTRIBUTE) && !checkWord(ch, rule)) {
          e.preventDefault();
          return false;
        }
      }
    }
  });

	$(document).on('keyup.datafilter', '[data-' + ATTRIBUTE + '-rule],[data-' + ATTRIBUTE+']', function (e){
		if(FnKeyCode[e.which]) return;
		var builtinRule = $(e.currentTarget).attr('data-' + ATTRIBUTE + '-rule');
		var rule = '';
		if(typeof builtinRule == 'string') {
			var subrule = builtinRule.split('|');
			if(subrule.length == 1) {
				rule = builtInRegexp[builtinRule];
			} else {
				for(var i=0; i<subrule.length; i++) {
					var temp = subrule[i];
					if(builtInRegexp[temp]) {
						rule += builtInRegexp[temp];
					}
				}
			}
		}
		if($(e.currentTarget).attr('data-' + ATTRIBUTE)) {
			rule += $(e.currentTarget).attr('data-' + ATTRIBUTE);
		}
		
		if(rule) {
//			__ALOG('keyup rule === ', rule)
			rule = new RegExp('['+rule+']' + '+', 'g');
			checkElement(e.currentTarget, rule)
		}
	});
	
	if(!$.alopex) {
		$.alopex = {};
	}
	$.alopex.keyfilter = {
		add: function(name, keycode, regexp) {
			__ALOG('added', name, keycode, regexp)
			if(name) {
				if(keycode) {
					builtInKeyCode[name] = keycode;
				}
				if(regexp){
					builtInRegexp[name] = regexp;
				}
			}
		}
	};
})(jQuery);
(function($) {
	/*********************************************************************************************************
	 * object
	 *********************************************************************************************************/
	$.alopex.widget.object = {

		widgetName: 'object',
		/**
		 * reference to parent class
		 * this.parent.setEnabled()
		 */
		parent: null, // parent class pointing

		/**
		 * default properties and value
		 */
		defaultClassName: 'af-object',
		defaultPressClassName: 'af-pressed',
		defaultHoverClassName: 'af-hover',
		defaultSelectClassName: 'af-selected',
		defaultDisableClassName: 'af-disabled',
		defaultThemeName: 'af-default',

		/**
		 * getter & setter api
		 */
		getters: ['getEnabled'],
		setters: ['addPressHighlight', 'addHoverHighlight', 'setEnabled', 'refresh'],

		/**
		 * default properties of component class
		 */
		properties: {
			// element-based properties.
			enabled: true,
			_markup: null, // orignal markup
			_wrapper: null // root of component after converting
		},

		/**
		 * when the user want to add event handler like the following
		 */
		eventHandlers: {
		//        key: {event: 'dragstart selectstart', selector: '', data: {}, handler: '_cancelEventHandler'}
		},

		refresh: function(el) {
			var wrapper = this._getProperty(el, '_wrapper');
			var markup = this._getProperty(el, '_markup');
			if (wrapper && markup) {
				markup = $(markup)[0];
				$(wrapper).replaceWith(markup);
				$(markup)[this.widgetName]();
			}
		},

		/**
		 * in the case the markup should be changed 
		 */
		markup: function(el, options) {
			el.alopex = $.extend({}, this.properties, options);
			if(!el.alopexoptions) {
				el.alopexoptions = {};
			}
			el.alopexoptions = $.extend(el.alopexoptions, this.properties, options);
			this._setProperty(el, '_markup', el.outerHTML); 

			var render = this.renderTo(el, options);
			if (render) {
				var $template = $(render);
				var wrapper = this._generateMarkup($template[0], el);
				this._setProperty(el, '_wrapper', wrapper);
			}
		},

		/**
		 * To add default style of component
		 */
		style: function(el, options) {
			this._addDefaultClass(el);
		},

		event: function(el, options) {
			this._addEventListener(el);
		},

		init: function(el, options) {
			var datatype = ($(el).prop('alopextype'))?$(el).prop('alopextype'): [];
			datatype.push($(el).attr('data-type'));
			$(el).prop('alopextype', datatype);
		},

		defer: function(el, option) {
			if(this.setEnabled) {
				this.setEnabled(el, $.alopex.util.parseBoolean(el.alopexoptions.enabled));
				if($.alopex.util.isValid(el.alopexoptions.disabled)) {
					this.setEnabled(el, !$.alopex.util.parseBoolean(el.alopexoptions.disabled));
				}
			}
			$(el).attr('data-converted', 'true');
			$(el).trigger('initcomplete.alopexui');
//			for ( var attr in el.dataset) {
//				var functionName = 'set' + attr[0].toUpperCase() + attr.substring(1, attr.length);
//				if ($.alopex.util.isValid(this[functionName])) {
//					$(el)[functionName](el.dataset[attr]);
//				}
//			}
		},

		_getInitHandlers: function(el) {
			function __constructor(element, widget, constructor) {
				this.element = element;
				this.widget = widget;
				this.constructor = constructor;
			}

			var markups = [];
			var styles = [];
			var events = [];
			var inits = [];
			var defers = [];
			var type = $(el).attr('data-type');
			var widget = $.alopex.widget[type];
			if (widget) {
				var parent = widget;
				while (parent) {
					if (parent['markup']) {
						markups.unshift(new __constructor(el, widget, parent['markup']));
					}
					if (parent['style']) {
						styles.unshift(new __constructor(el, widget, parent['style']));
					}
					if (parent['event']) {
						events.unshift(new __constructor(el, widget, parent['event']));
					}
					if (parent['init']) {
						inits.unshift(new __constructor(el, widget, parent['init']));
					}
					if (parent['defer']) {
						// defer 함수는 조상 함수가 가장 나중에 호출된다.
						defers.push(new __constructor(el, widget, parent['defer']));
					}
					parent = parent.parent;
				}
			}

			return {
				markup: markups,
				style: styles,
				event: events,
				init: inits,
				defer: defers
			};
		},

		_constructor: function(el, option) {
			if(el) {
				var inits = $.alopex.widget.object._getInitHandlers(el);
				var argsTemplate = [];
				for ( var i = 1; i < arguments.length; i++) {
					argsTemplate[i] = arguments[i];
				}
				for ( var i = 0; i < inits.markup.length; i++) {
					argsTemplate[0] = inits.markup[i].element;
					inits.markup[i].constructor.apply(inits.markup[i].widget, argsTemplate);
				}
				for ( var i = 0; i < inits.style.length; i++) {
					argsTemplate[0] = inits.style[i].element;
					inits.style[i].constructor.apply(inits.style[i].widget, argsTemplate);
				}
				for ( var i = 0; i < inits.init.length; i++) {
					argsTemplate[0] = inits.init[i].element;
					inits.init[i].constructor.apply(inits.init[i].widget, argsTemplate);
				}
				for ( var i = 0; i < inits.event.length; i++) {
					argsTemplate[0] = inits.event[i].element;
					inits.event[i].constructor.apply(inits.event[i].widget, argsTemplate);
				}
				for ( var i = 0; i < inits.defer.length; i++) {
					argsTemplate[0] = inits.defer[i].element;
					inits.defer[i].constructor.apply(inits.defer[i].widget, argsTemplate);
				}
			}
			
		},

		/**
		 * function with '_' keyword must be the inner function 
		 * add the handler registered in eventHandlers
		 */
		_addEventListener: function(el) {
			var $el = $(el);
			// widget constructor 이벤트 처리.
			for ( var i in this.eventHandlers) {
				var args = [this.eventHandlers[i].event];
				if (this.eventHandlers[i].selector) {
					args.push(this.eventHandlers[i].selector);
				}
				if (this.eventHandlers[i].data) {
					args.push(this.eventHandlers[i].data);
				}
				args.push(this[this.eventHandlers[i].handler]);

				$el.on.apply($el, args);
			}
		},

		/**
		 * default classname assign
		 */
		_addDefaultClass: function(el) {
			var classname;
			var theme = ' ' + this.defaultThemeName;
			if (el.getAttribute('data-theme')) {
				theme = ' ' + el.getAttribute('data-theme');
			}

			// 
			if (el.className !== undefined && el.className !== '') {
				// class name define
				if (theme !== ' af-default') {
					classname = el.className + theme;
				} else {
					classname = el.className;
				}
			} else { // no class
				classname = this.defaultClassName + theme;
			}
			if ($.alopex.util.isValid(el.getAttribute('data-style')) || $.alopex.util.isValid(el.getAttribute('data-addclass'))) { // CustomStyle apply.
				var addclass = el.getAttribute('data-addclass') || el.getAttribute('data-style');
				classname += ' ' + addclass;
			}
			$(el).attr('class', classname);
		},

		/**
		 * add event handler for press event 
		 */
		addPressHighlight: function(el, selector) {
			if (selector) {
				$(el).on('move', selector, {
					classname: this.defaultPressClassName
				}, this._removeClassName);
				$(el).on('pressed', selector, {
					classname: this.defaultPressClassName
				}, this._addClassName);
				$(el).on('unpressed', selector, {
					classname: this.defaultPressClassName
				}, this._removeClassName);
			} else {
				$(el).on('move', {
					classname: this.defaultPressClassName
				}, this._removeClassName);
				$(el).on('pressed', {
					classname: this.defaultPressClassName
				}, this._addClassName);
				$(el).on('unpressed', {
					classname: this.defaultPressClassName
				}, this._removeClassName);
			}
		},

		addHoverHighlight: function(el, selector) {
			if (selector) {
				$(el).on('mouseenter focusin', selector, {
					classname: this.defaultHoverClassName
				}, this._addClassName);
				$(el).on('mouseleave focusout', selector, {
					classname: this.defaultHoverClassName
				}, this._removeClassName);
			} else {
				$(el).on('mouseenter focusin', {
					classname: this.defaultHoverClassName
				}, this._addClassName);
				$(el).on('mouseleave focusout', {
					classname: this.defaultHoverClassName
				}, this._removeClassName);
			}
		},
		
		/**
		 * remove 
		 */
		removePressHighlight: function(el, selector) {
			if (selector) {
				$(el).off('move', selector, {
					classname: this.defaultPressClassName
				}, this._removeClassName);
				$(el).off('pressed', selector, {
					classname: this.defaultPressClassName
				}, this._addClassName);
				$(el).off('unpressed', selector, {
					classname: this.defaultPressClassName
				}, this._removeClassName);
			} else {
				$(el).off('move', {
					classname: this.defaultPressClassName
				}, this._removeClassName);
				$(el).off('pressed', {
					classname: this.defaultPressClassName
				}, this._addClassName);
				$(el).off('unpressed', {
					classname: this.defaultPressClassName
				}, this._removeClassName);
			}
		},

		removeHoverHighlight: function(el, selector) {
			if (selector) {
				$(el).off('mouseenter focusin', selector, {
					classname: this.defaultHoverClassName
				}, this._addClassName);
				$(el).off('mouseleave focusout', selector, {
					classname: this.defaultHoverClassName
				}, this._removeClassName);
			} else {
				$(el).off('mouseenter focusin', {
					classname: this.defaultHoverClassName
				}, this._addClassName);
				$(el).off('mouseleave focusout', {
					classname: this.defaultHoverClassName
				}, this._removeClassName);
			}
		},

		_eventBlockHandler: function(e) {
			e.preventDefault();
			e.stopPropagation();
			return false;
		},

		_setProperty: function(el, key, value) {
			if (el.alopex) {
				el.alopex[key] = value;
				//          el.setAttribute('data-'+key, value);
			}

		},

		_getProperty: function(el, key) {
			return el.alopex[key];
		},

		setEnabled: function(el, boolEnabled) {
			var $el = $(el);
			if (typeof boolEnabled !== 'boolean') {
				boolEnabled = $.alopex.util.parseBoolean(boolEnabled);
			}
			if (boolEnabled) {
				this._setProperty(el, 'enabled', true);
				this._removeDisabledStyle(el);
				el.removeAttribute('disabled');
				if (el.attributes['tabindex']) {
					el.setAttribute('tabindex', '0');
				}
			} else {
				this._setProperty(el, 'enabled', false);
				this._addDisabledStyle(el);
				el.setAttribute('disabled', 'disabled');
				if (el.attributes['tabindex']) {
					el.setAttribute('tabindex', '-1');
				}
			}
		},

		getEnabled: function(el) {
			return this._getProperty(el, 'enabled');
		},

		_addClassName: function(e) {
			var el = e.currentTarget;
			switch (el.getAttribute('data-type')) {
			case 'select' | 'textinput' | 'textarea':
				break;
			default:
				$(el).addClass(e.data.classname);
				break;
			}
		},

		_removeClassName: function(e) {
			var el = e.currentTarget;
			switch (el.getAttribute('data-type')) {
			case 'select' | 'input':
				break;
			default:
				$(el).removeClass(e.data.classname);
			}
		},

		_addDisabledStyle: function(el) {
			$(el).addClass(this.defaultDisableClassName);
		},

		_removeDisabledStyle: function(el) {
			$(el).removeClass(this.defaultDisableClassName);
		},

		_cancelEventHandler: function(e) {
			e.preventDefault();
			e.stopPropagation();
			return false;
		},

		/**
		 * componenet markup
		 * if a component's HTML markup is equal to the markup developer need to write, don't need this property
		 * idea : Component's tobe markup and put 'markupIdentifier' attribute on dynamically added element
		 */
		//*
		renderTo: function() {
			return null;
		},
		markupIdentifier: 'af-dynamic',
		_generateMarkup: function(template, el) {
			var wrapper;
			if (template.attributes[this.markupIdentifier]) {

				wrapper = template.cloneNode(true);
				wrapper.innerHTML = "";
				template.removeAttribute(this.markupIdentifier);
				$(el).wrap(wrapper);
				el = el.parentNode;
			}

			for ( var i = 0; i < template.children.length; i++) {
				var child = template.children[i];
				if (child.attributes[this.markupIdentifier]) {

					if (i > 0) {
						var newChild = child.cloneNode(true);
						$(newChild).insertAfter(el.children[i - 1]);
					} else {
						if (template.children.length === 1) {
							break;
						}
						var newChild = child.cloneNode(true);
						$(el).prepend(newChild);
					}

					child.removeAttribute(this.markupIdentifier);
				}
			}

			for ( var i = 0; i < template.children.length; i++) {
				this._generateMarkup(template.children[i], el.children[i])
			}

			return (wrapper) ? wrapper : el;
		}
	// */
	};

})(jQuery);

(function($) {
	if ($.alopex.util.regexp) {
		return;
	}
	var regexp = {
		number: /^[0-9]+$/,
		float: /\d+(\.\d+)?/gi,
		date: /(^\d{1,2}(\-|\/|\.)\d{1,2}(\-|\/|\.)\d{4}$)|(^\d{4}(\-|\/|\.)\d{1,2}(\-|\/|\.)\d{1,2}$)/,
		divider: /^\-|\/|\./
	};

	function isValid(variables) {
		if (variables === null || variables === undefined || variables === '' || variables === 'undefine') {
			return false;
		} else {
			return true;
		}
	}
	
	function arrayjoin(a, b) {
		var compound = $.extend([], a);
		for(var i=0; i<b.length; i++) {
			var found = false;
			for(var j=0; j<a.length; j++) {
				if(a[i] == b[j]) {
					found = true;
					break;
				}
			}
			if(!found) {
				compound.push(b[i]);
			} 
		}
		return compound;
	}

	function parseBoolean(string) {
		switch (String(string).toLowerCase()) {
		case 'true':
		case '1':
		case 'yes':
		case 'y':
			return true;
		case 'false':
		case '0':
		case 'no':
		case 'n':
			return false;
		default:
			return false;
		}
	}

	function hasClass(ele, cls) {
		return ele.className.match(new RegExp('(\\s|^)' + cls + '(\\s|$)'));
	}

	function addClass(ele, cls) {
		if (!$.alopex.util.hasClass(ele, cls)) {
			ele.className += ' ' + cls;
		}
	}

	function removeClass(ele, cls) {
		if ($.alopex.utilhasClass(ele, cls)) {
			var reg = new RegExp('(\\s|^)' + cls + '(\\s|$)');
			ele.className = ele.className.replace(reg, ' ');
		}
	}

	function getWindowHeight() {
		return $(window).height();
	}

	function getWindowWidth() {
		return $(window).width();
	}

	function getDocumentHeight() {
		return $(document).height();
	}

	function getDocumentWidth() {
		return $(document).width();
	}

	function getPagePosition(el) {
		var result = {};
		var leftPosition = 0, topPosition = 0;
		if (el.offsetParent) {
			topPosition = el.offsetTop;
			leftPosition = el.offsetLeft;
			while (el = el.offsetParent) {
				// body가 position fixed or absolute일 경우, top 계산.
				if(el.style.position == 'fixed' && el.tagName.toLowerCase() == 'body') {
					topPosition += el.style.top? parseInt(el.style.top) : 0;
					leftPosition += el.style.left? parseInt(el.style.left) : 0;
					break;
				}
				topPosition += el.offsetTop;
				leftPosition += el.offsetLeft;
			}
		}
		result.top = topPosition;
		result.left = leftPosition;
		return result;
	}

	function getRelativePosition(el) {
		var result = {};
		var leftPosition = 0, topPosition = 0;
		if (el && el.offsetParent) {
			topPosition = el.offsetTop;
			leftPosition = el.offsetLeft;
			el = el.offsetParent;
			while (el) {
				topPosition += el.offsetTop;
				leftPosition += el.offsetLeft;
				el = el.offsetParent;
			}
		}
		result.top = topPosition;
		result.left = leftPosition;
		return result;
	}

	function getScrolledPosition(el) {
		var result = {};
		var leftPosition = 0, topPosition = 0;
		if (el.offsetParent) {
			topPosition = el.offsetTop - el.scrollTop;
			leftPosition = el.offsetLeft - el.scrollLeft;
			while (el = el.offsetParent) {
				topPosition += el.offsetTop - el.scrollTop;
				leftPosition += el.offsetLeft - el.scrollLeft;
			}
		}
		result.top = topPosition;
		result.left = leftPosition;
		return result;
	}

	function getScrollbarWidth() {
		var parent, child, width;
		if (width === undefined) {
			parent = $('<div style="width:50px;height:50px;overflow:auto"><div/></div>').appendTo('body');
			child = parent.children();
			width = child.innerWidth() - child.height(99).innerWidth();
			parent.remove();
		}
		return width;
	}

	function isNumberType(data) {
		return $.alopex.util.regexp.number.test(data);
	}

	function isDateType(data) {
		return $.alopex.util.regexp.date.test(data);
	}
	
	function isConverted(el) {
		return ($(el).attr('data-converted') === 'true');
	}
	
	function getDateString(date, format) {
		if(!(date instanceof Date)) {
			return ;
		}
		var fullyear = date.getFullYear();
		var month = date.getMonth() + 1;
		var date = date.getDate();
		month = ((month < 10)? '0' : '') + month;
		date = ((date < 10)? '0' : '') + date;
		return format.replace('yyyy', fullyear).replace('MM', month).replace('dd', date);
	}

	/**
	 *
	 * @param array {array type} array of date string
	 * @return array {array} array of 'DDMMYYYY' string
	 */
	function formatDate(array) {
		var type = 'ddmm';
		var divider, data;

		// ddmm or mmdd 판단.
		for ( var i = 0; i < array.length; i++) {
			divider = array[i].match($.alopex.util.regexp.divider);
			data = array[i].split(divider);

			if (data[0].length === 4) { // 이 부분에서 YYYY 뒤로 이동.
				data.push(data[0]);
				data.shift();
				array[i] = data.join('/');
			}

			if (parseInt(data[0], 10) > 12) {
				type = 'mmdd';
				break;
			}
		}

		if (type === 'mmdd') {
			for (i = 0; i < array.lengh; i++) {
				divider = array[i].match($.alopex.util.regexp.divider);
				data = array[i].split(divider);
				var temp = data[0];
				data[0] = data[1];
				data[1] = temp;
				array[i] = data.join('/');
			}
		}

		return array;
	}

	/**
	 * create new HTML node, copy the attribute of original element
	 * @param {string} tagName tagname of new html node.
	 */
	function copyNode(oldNode, tagName) {
		if (tagName === undefined) {
			tagName = oldNode.tagName;
		}
		var newNode = document.createElement(tagName);
		for ( var i = 0; i < oldNode.attributes.length; i++) {
			var attr = oldNode.attributes[i];
			$(newNode).attr(attr.name, attr.value);
		}
		return newNode;
	}

	// used in sorting in table widget
	function insertSort(array, comparison, ascending, begin, end) {
		if (!array || !array.length) {
			return array;
		}
		if (array.length < 2) {
			return array;
		}
		begin = begin || 0;
		end = end || array.length;
		var size = end - begin;
		if (size < 2)
			return array;

		var subArray = array.slice(begin, end);
		var i, j, newValue;
		for (i = 1; i < subArray.length; i++) {
			newValue = subArray[i];
			j = i;

			if (ascending) {
				while (j > 0 && comparison(subArray[j - 1], newValue) > 0) {
					subArray[j] = subArray[j - 1];
					j--;
				}
			} else {
				while (j > 0 && comparison(subArray[j - 1], newValue) < 0) {
					subArray[j] = subArray[j - 1];
					j--;
				}
			}
			subArray[j] = newValue;
		}
		for ( var i = 0; i < subArray.length; i++) {
			array[begin + i] = subArray[i];
		}
		return array;
	}

	function mergeSort(array, comparison, ascending, begin, end) {
		if (!array || !array.length) {
			return array;
		}
		if (array.length < 2) {
			return array;
		}
		begin = begin || 0;
		end = end || array.length;
		var size = end - begin;
		if (size < 2)
			return array;
		var middle = begin + Math.floor(size / 2);
		var merged = _merge(mergeSort(array.slice(begin, middle), comparison, ascending), mergeSort(array.slice(middle, end), comparison, ascending), comparison, ascending);
		merged.unshift(begin, merged.length);
		array.splice.apply(array, merged);
		//array.splice(begin, merged.length, )
		return array;
	}
	function _merge(left, right, comparison, ascending) {
		var result = new Array();
		while ((left.length > 0) && (right.length > 0)) {
			if (comparison(left[0], right[0]) <= 0 && ascending)
				result.push(left.shift());
			else
				result.push(right.shift());
		}
		while (left.length > 0)
			result.push(left.shift());
		while (right.length > 0)
			result.push(right.shift());
		return result;
	}

	function sort_default(a, b) {
		if (a > b) {
			return 1;
		}
		if (a < b) {
			return -1;
		}
		return 0;
	}
	
	function addFloat(a, b) {
		var splitA = (''+a).split('.');
		var splitB = (''+b).split('.');
		var multiplier = 0;
		if(splitA[1]) {
			multiplier = splitA[1].length;
		}
		if(splitB[1] && splitB[1].length > multiplier) {
			multiplier = splitB[1].length;
		}
		var multiplier = Math.pow(10, multiplier);
		var result = multiplier==0?a+b:parseFloat(Math.round(a*multiplier + b*multiplier))/multiplier;
		return result;
	}

	function sort_numeric(a, b) {
		var num1 = parseFloat(a[0].replace(/[^0-9.-]/g, ''));
		if (isNaN(num1)) {
			num1 = 0;
		}
		var num2 = parseFloat(b[0].replace(/[^0-9.-]/g, ''));
		if (isNaN(num2)) {
			num2 = 0;
		}
		return num1 - num2;
	}

	function sort_date(a, b) { // MM/DD/YYYY
		var date1 = $.alopex.util.getDate(a[0]);
		var date2 = $.alopex.util.getDate(b[0]);

		if (date1 > date2) {
			return 1;
		} else if (date1 === date2) {
			return 0;
		} else {
			return -1;
		}
	}

	/**
	 *
	 * @param {string} date string type.
	 * @return {Date Object} Javascript Date Object.
	 */
	function getDate(date, option) {
		var year, month, day;
		if (option === undefined) {
			option = 'mmdd';
		}

		var divider = '/';
		divider = date.match(/\-|\/|\./);
		var dateArr = date.split(divider);
		year = dateArr[2];
		if (option === 'ddmm') {
			month = dateArr[1];
			day = dateArr[0];
		} else {
			month = dateArr[0];
			day = dateArr[1];
		}
		return new Date(year, month, day);
	}

	function trim(str) {
		return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
	}

	function erase() {
		var erased = [];
		$(document).find(':hidden').each(function() {
			if (this.parentNode) {
				var tagname = this.tagName.toLowerCase();
				switch (tagname) {
				case "head":
				case "meta":
				case "link":
				case "script":
				case "option":
				case "style":
					return;
				}
				erased.push({
					node: this,
					parent: this.parentNode
				});
				this.parentNode.removeChild(this);
			}

		});
		return erased;
	}

	function restore(obj) {
		for ( var i = 0; i < obj.length; i++) {
			if (obj[i].parent) {
				obj[i].parent.appendChild(obj[i].node);
			}
		}

	}
	
	function getOptions(el) {
		var option = {};
		for ( var i = 0; i < el.attributes.length; i++) {
			if (el.attributes[i].name.indexOf('data-') === 0) {
				var key = el.attributes[i].name.replace('data-', '').replace('-', '');
				if (key === 'type') {
					continue;
				} // ie7, 8 predefined property
				var value = el.attributes[i].value;
				option[key] = value;
			}
		}
		
		for ( var i in option) {
			if (option[i] === 'true' || option[i] === 'false') { // false
				option[i] = $.alopex.util.parseBoolean(option[i]);
			}
			if ($.alopex.util.isNumberType(option[i])) {
				option[i] = parseInt(option[i], 10);
			}
		}
		
		return option;
	}
	
	function arrayremove(array, removeItem) {
		if(!(array instanceof Array)) {
			return ;
		}
		
		for(var i=0; i<array.length; i++) {
			if(array[i] == removeItem) {
				array.splice(i, 1);
			}
		}
	}
	
	var re = /([^&=]+)=?([^&]*)/g;
	var decode = function(str) {
		return decodeURIComponent(str.replace(/\+/g, ' '));
	};
	function parseQuerystring(query) {
		var params = {}, e;
		if (query) {
			if (query.substr(0, 1) == '?') {
				query = query.substr(1);
			}

			while (e = re.exec(query)) {
				var k = decode(e[1]);
				var v = decode(e[2]);
				if (params[k] !== undefined) {
					if (!$.isArray(params[k])) {
						params[k] = [ params[k] ];
					}
					params[k].push(v);
				} else {
					params[k] = v;
				}
			}
		}
		return params;
	}

	$.extend($.alopex.util, {
		regexp: regexp,
		isValid: isValid,
		parseBoolean: parseBoolean,
		hasClass: hasClass,
		addClass: addClass,
		removeClass: removeClass,
		getWindowHeight: getWindowHeight,
		getWindowWidth: getWindowWidth,
		getDocumentHeight: getDocumentHeight,
		getDocumentWidth: getDocumentWidth,
		getPagePosition: getPagePosition,
		getRelativePosition: getRelativePosition,
		getScrolledPosition: getScrolledPosition,
		getScrollbarWidth: getScrollbarWidth,
		isNumberType: isNumberType,
		isDateType: isDateType,
		formatDate: formatDate,
		copyNode: copyNode,
		insertSort: insertSort,
		mergeSort: mergeSort,
		sort_default: sort_default,
		sort_numeric: sort_numeric,
		sort_date: sort_date,
		getDate: getDate,
		trim: trim,
		erase: erase,
		restore: restore,
		getOptions: getOptions,
		isConverted: isConverted,
		addFloat: addFloat,
		arrayjoin: arrayjoin,
		arrayremove: arrayremove,
		parseQuerystring: parseQuerystring,
		getDateString: getDateString
	});

	$.fn.hasEventHandler = function(event, handler) {
		var registeredEventList = $._data(window, 'events');
		if (registeredEventList !== undefined && registeredEventList[event] !== undefined) {
			var handlerList = registeredEventList[event];
			for ( var i = 0; i < handlerList.length; i++) {
				if (handlerList[i].handler === handler) {
					return true;
				}
			}
		}
		return false;
	};

})(jQuery);

// TODO : animation, trigger-to-open event, collapse other content when one open. 

(function($) {

	$.alopex.widget.accordion = $.alopex.inherit($.alopex.widget.object, {

		widgetName: 'accordion',
		defaultClassName: 'af-accordion',

		setters: ['accordion', 'expandAll', 'collapseAll', 'setDataSource', 'expand', 'collapse'],
		getters: [],

		eventHandlers: {
//			cancel: {
//				event: 'dragstart selectstart',
//				handler: '_cancelEventHandler'
//			}
		},

		init: function(el, options) {
			var $el = $(el);
			var that = this;
			$.extend(el, this.options, options); 
			$el.find('li').each(function() {
				var li = this;
				for ( var i = 0; i < li.children.length; i++) {
					if (li.children[i].tagName.toLowerCase() === 'a' && li.children.length > 1) {
						$(li).addClass('af-expandable');
						break;
					}
				}
			});
			$el.find('li > a').each(function() {
				that.addHoverHighlight(this);
				that.addPressHighlight(this);
				$(this).next().addClass('af-accordion-sub')
			});

			$(el).find('li > a').bind('tap', function(e) {
				var target = e.target;
				var $parent = $(target).parent();
				if ($parent.is('li.af-expandable')) {
					$parent.toggleClass('af-accordion-expand');
					if ($parent.hasClass('af-accordion-expand')) {
						$(target).next().css('display', '');
						$(el).trigger('open', [target]);
					} else {
						$(target).next().css('display', 'none');
						$(el).trigger('close', [target]);
					}
				}
			});
			this.collapseAll(el);
		},
		
		expandAll: function(el) {
			$(el).find('.af-accordion-sub').each(function() {
				var target = this;
				var $li = $(target).closest('li').addClass('af-accordion-expand');
				$(target).css('display', '');
			});
		},
		
		expand: function(el, index) {
			$(el).find('.af-accordion-sub').eq(index).each(function() {
				var target = this;
				var $li = $(target).closest('li').addClass('af-accordion-expand');
				$(target).css('display', '');
			});
		},

		collapseAll: function(el) {
			$(el).find('.af-accordion-sub').each(function() {
				var target = this;
				var $li = $(target).closest('li').removeClass('af-accordion-expand');
				$(target).css('display', 'none');
			});
		},
		
		collapse: function(el, index) {
			$(el).find('.af-accordion-sub').eq(index).each(function() {
				var target = this;
				var $li = $(target).closest('li').removeClass('af-accordion-expand');
				$(target).css('display', 'none');
			});
		},

		setDataSource: function(el, jsonArray) {
			$(el).empty();
			this._createNode(el, jsonArray);
			el.phase = undefined;
			$(el).accordion();
		},

		_createNode: function(el, jsonArray) {
			for ( var i = 0; i < jsonArray.length; i++) {
				var item = jsonArray[i];
				var li = $('<li></li>').appendTo(el)[0];
				if ($.alopex.util.isValid(item.id)) {
					$(li).attr('data-id', item.id);
				}
				var a = $('<a></a>').appendTo(li)[0];
				if ($.alopex.util.isValid(item.linkUrl)) {
					$(a).attr('href', item.linkUrl);
				}
				if ($.alopex.util.isValid(item.iconUrl)) {
					$('<img/>').attr('src', item.iconUrl).appendTo(li);
				}
				//        $('<span></span>').html(item.text).appendTo(a);
				$(a).text(item.text);

				if ($.alopex.util.isValid(item.items)) {
					var subul = $('<ul></ul>').appendTo(li)[0];
					this._createNode(subul, item.items);
				}
			}
		}
		
	});

})(jQuery);

// constructor : markup, style, init, event, defer: timing issue에 사용.


(function($) {
	// MessageBox 호출
	var imagepath = '/Resources/www/build/css/images/';

	function messagebox(type, option) {
		if($('.af-dialog-mask:hidden').length != 0)
			$('.af-dialog-mask:hidden').remove();
		if ($(document).find('.messagebox').length != 0)
			return;
		var icon;
		var msg = '';
		if (typeof (option) == 'object') {
			msg = option.msg
		} else {
			msg = option
		}
		var markup = '<div id="dialog_messagebox" data-type="dialog" class="messagebox container">' + '<div class="messageWrap clearfix">'
			+ '<div class="msg_icon ' + type + '"></div>' + '<div class="msg_txt" id="text"></div>' + '</div>' + '<div class="msgBtnWrap">'
			+ '<button id="msgBtn" data-type="button"><span class="btn_icon"></span><span class="btn_txt">OK</span></button>' + '</div>'
			+ '</div>';
		var $dialog = $(markup).appendTo(document.body).convert().open({
			modal : true
		});
		var $label = $dialog.find('#text');
		$label.html(msg.replace('\n', '<br>'));
		//$label.css('margin-top', (($label.height() - 10) * -1 / 2) + 'px');

		$('#msgBtn').on('tap', function(e) {
			$dialog.close().remove();
		}).focus();
		
		$('#dialog_messagebox').close(function() {
			$('#dialog_messagebox').remove();
			if(option.ok)
				option.ok();
		});
	};

	function confirmbox(option) {
		if($('.af-dialog-mask:hidden').length != 0)
			$('.af-dialog-mask:hidden').remove();
		
		if ($(document).find('.messagebox').length != 0)
			return;
		
		var icon;
		var msg;

		var markup = '<div id="dialog_messagebox" data-type="dialog" class="messagebox container">' + '<div class="messageWrap clearfix">'
			+ '<div class="msg_icon confirm"></div>' + '<div class="msg_txt" id="text"></div>' + '</div>' + '<div class="msgBtnWrap">'
			+ '<button id="msgBoxOk" class="btn_common black noicon"><span class="btn_icon"></span><span class="btn_txt">OK</span></button>'
			+ '<button id="msgBoxCancel" class="btn_common black noicon"><span class="btn_icon"></span><span class="btn_txt">Cancel</span></button>' + '</div>'
			+ '</div>';

		if (option.id != undefined) {
			$a.service("SKENS.CM.Biz.MsgMgmtBiz#GetMsgDetail", {
				MESSAGEID : option.id
			}, function(ds) {
				if (ds.recordSets.table1.nc_list.length != 0) {
					msg = ds.recordSets.table1.nc_list[0].MESSAGEBODY;

					var $dialog = $(markup).appendTo(document.body).convert().open({
						modal : true
					});;
					var $label = $dialog.find('#text');
					$label.html(msg.replace('\n', '<br>'));
					
					var cancelCallback;
					if (option.cancel) {
						cancelCallback = option.cancel;
					}
					// ok버튼
					$('#msgBoxOk').on('tap', function(e) {
						if (option.ok) {
						    $('#dialog_messagebox').close().remove();
						    option.ok();
						} else {
							$('#dialog_messagebox').close().remove();
						}
					}).focus();
					
					
					// 취소버튼
					$('#msgBoxCancel').on('tap', function() {
					    $('#dialog_messagebox').close().remove();
					});
					
					$('#dialog_messagebox').close(function() { // close 시 콜백함수 등록.
						$('#dialog_messagebox').remove();
						if (cancelCallback) {
							cancelCallback();
						}
					});
					
				} else {
					messagebox('error', '잘못된 Message ID를 입력했습니다.');
				}
			});
		} else if (option.msg != undefined) {
			msg = option.msg

			var $dialog = $(markup).appendTo(document.body).convert().open({
				modal : true
			});;
			var $label = $dialog.find('#text');
			$label.html(msg.replace('\n', '<br>'));
			
			var cancelCallback;
			if (option.cancel) {
				cancelCallback = option.cancel;
			}
			
			// ok버튼
			$('#msgBoxOk').on('tap', function(e) {
				if (option.ok) {
				    $('#dialog_messagebox').close(function(){
				    	option.ok();
				    });
				    $('#dialog_messagebox').close().remove();
				} else {
					$('#dialog_messagebox').close().remove();
				}
			}).focus();
			
			// 취소버튼
			$('#msgBoxCancel').on('tap', function() {
			    $('#dialog_messagebox').close().remove();
			});
			
			$('#dialog_messagebox').close(function() { // close 시 콜백함수 등록.
				$('#dialog_messagebox').remove();
				if (cancelCallback) {
					cancelCallback();
				}
			});
		} else {
			messagebox('error', '잘못된 Parameter 입니다.');
		}
	};

	$.extend($.alopex, {
		info: function(msg) {
			return messagebox('error', msg);
		},
		
		error : function(msg) {
			messagebox('error', msg);
		},
		confirm: function(option) {
			confirmbox(option);
		}
		
	})
	
})(jQuery);
(function($) {

	/*********************************************************************************************************
	 * button
	 *********************************************************************************************************/
	$.alopex.widget.basebutton = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'basebutton',
		/**
		 * property 
		 */
		// class property
		defaultClassName: 'af-basebutton',

		setters: ['basebutton'],
		getters: [],
		
		properties: {
			
		},

		eventHandlers: {
			cancel: {
				event: 'dragstart selectstart',
				handler: '_cancelEventHandler'
			}
		},

		event: function(el) {
			this.addHoverHighlight(el);
			this.addPressHighlight(el);
		},

		init: function(el) {
			if (el.tagName.toLowerCase() === 'a') {
				el.setAttribute('tabindex', '0');
			}
		}
	});

})(jQuery);

// constructor : markup, style, init, event, defer: used in timing issue
$.alopex.widget.baseinput = $.alopex.inherit($.alopex.widget.object, {
	widgetName: 'baseinput',
	eventHandlers: {
	//      focus: {event: 'focus', handler: '_focusHandler'},
	//      blur: {event: 'blur', handler: '_blurHandler'}
	},

	event: function(el) {
		this.addHoverHighlight(el);
	},

	init: function(el) {
		if (!$.alopex.util.isValid(el.getAttribute('type'))) {
			var datatype = el.getAttribute('data-type');
			el.setAttribute('type', datatype);
		}
	},

	properties: {

	}

});
(function($) {

	/*********************************************************************************************************
	 * select
	 *********************************************************************************************************/
	$.alopex.widget.baseselect = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'baseselect',
		defaultClassName: 'af-baseselect',
		getters: ['getValues', 'getTexts'],
		setters: ['baseselect', 'setPlaceholder', 'setSelected', 'clear', 'refresh'],

		init: function(el, option) {
			var placeholder = this._getProperty(el, 'placeholder');
			if(placeholder) {
				this.setPlaceholder(el, placeholder);
			}
		},
		
		setPlaceholder: function(el, text) {
			var $el = $(el);
			if($el.find('[data-placeholder]').length == 0) {
				$el.prepend('<option value="" selected="selected" data-placeholder="true" disabled>' + text + '</option>');
				$el[0].options[0].selected = true;
			}
		},

		setSelected: function(el, text) {
			// check null
			if (el.children.length === 0) {
				return;
			}
			var flag = true, i;
			for (i = 0; i < el.children.length; i++) {
				if (el.children[i].text === text) {
					$(el.children[i]).prop('selected', true);
					flag = false;
				}
			}
			if (flag) {
				for (i = 0; i < el.children.length; i++) {
					if (el.children[i].value === text) {
						$(el.children[i]).prop('selected', true);
						//el.textfield.innerHTML = el.children[i].text;
					}
				}
			}
			$(el).trigger('change');
		},

		getValues: function(el) {
			var tmpValuesArr = [];
			if (el.multi) {
				$(el).find('option:selected').each(function() {
					tmpValuesArr.push($(this).val());
				});
				return tmpValuesArr;
			} else {
				var result = [];
				$(el).find('option:selected').each(function() {
					result.push(this.value);
				});
				return result;
			}
		},

		getTexts: function(el) {
			var tmpTextsArr = [];
			if (el.multi) {
				$(el).find('option:selected').each(function() {
					tmpTextsArr.push($(this).text());
				});
				return tmpTextsArr;
			} else {
				var result = [];
				$(el).find('option:selected').each(function() {
					result.push($(this).text());
				});
				return result;
			}
		},

		clear: function(el) {
			$(el).empty();
			//data-placeholder
			if ($.alopex.util.isValid($(el).attr('data-placeholder'))) {
				$(el).prepend('<option value="" selected="selected" disabled>' + $(el).attr('data-placeholder') + '</option>');
				$(el)[0].options[0].selected = true;
				el.originWidth = $(el).width();
			}
		},

		refresh: function(el) { 
			var $el = $(el);
			if ($.alopex.util.parseBoolean(el.alopexoptions.wrap)) {
				var text = $el.find(':selected').text() || '';
				$.alopex.widget.divselect._setText(el.parentNode, text);
			}
		}
	});

})(jQuery);
(function($) {

	/*********************************************************************************************************
	 * button
	 *********************************************************************************************************/
	$.alopex.widget.button = $.alopex.inherit($.alopex.widget.basebutton, {
		widgetName: 'button',
		defaultClassName: 'af-button',
		setters: ['button'],
		getters: [],

		init: function(el) {
			var $el = $(el);
			if ($el.attr('data-role') == 'toggle') { 
				// basebutton : to keep prev version compatibility 
				$el.attr('data-type', 'togglebutton').togglebutton();
			}
		}
	});

})(jQuery);



(function($) {
	/**
	 * TODO : 
	 * - carousel markup & how to fix the size
	 * 
	 */
	$.alopex.widget.carousel = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'carousel',
		/**
		 * property 
		 */
		// class property
		defaultClassName: 'af-carousel',

		setters: ['carousel', 'nextSlide', 'prevSlide', 'setIndex'],
		getters: [],

		eventHandlers: {
			
		},

		properties: {
			width: 0, // wrapper width
			currentpage: 1, // current page of carousel, start from 1.
			totalpage: 0,
			position: 0, // carousel transform position
			maxPosition: 0,
			pages: null,
			prevButton: null,
			nextButton: null,
			paging: null,
			slidable: null,
			animationDuration: 400
		},
		
		setEnabled: null,

		init: function(el, options) {
			var $el = $(el);
			var $obj = $.alopex.widget.object;

			$el.css({
				'overflow' : 'hidden',
				'position' : 'relative'
			});

			$.extend(el, $.alopex.widget.carousel.properties, options);

			el.pages = $el.find('[data-role="page"]');
			el.pagingHeight = 50;
			el.pageHeight = (el.pages[0].offsetHeight > 0) ? el.pages[0].offsetHeight : el.offsetHeight - el.pagingHeight;
			
			el.width = el.offsetWidth;
			el.totalpage = el.pages.length;
			el.prevButton = $el.find('[data-role="prev"]').addClass('prev');
			el.nextButton = $el.find('[data-role="next"]').addClass('next');
			el.paging = $el.find('[data-role="pagination"]');
			el.maxPosition = -1 * el.width * (el.totalpage - 1);

			el.paging.attr({
				'data-type': 'pagination',
				'data-generatelink': 'mobile',
				'data-maxpage': el.pages.length,
				'data-totalpage': el.pages.length
			}).pagination();

			// slidable initiation
			el.slidable = document.createElement('div');
			el.slidable.element = el;
			el.appendChild(el.slidable);
			$(el.slidable)
				.css({
//					'height': (el.offsetHeight - el.pagingHeight) + 'px',
					'width': el.width * el.pages.length + 'px',
					'transform': 'translate3d(0px, 0px,0px)',
					'-ms-transform': 'translateZtranslate3d(0px, 0px,0px)'
				});

			// page initiation
			if ($.alopex.util.isValid(el.pages)) {
				el.pages
				.css({
					'width': el.width + 'px',
					'position': 'relative',
//					'height': '100%',
					'float': 'left'
				})
				.each(function(index) {
					this.index = index;
				});
				for ( var i = 0; i < el.pages.length; i++) {
					el.slidable.appendChild(el.pages[i]);
				}
			}
			el.slidemode = false;
		},
		
		event: function(el, options) {
			// event handler binding
			var carousel = $.alopex.widget.carousel;
			el.paging.on('pagechange', carousel._evt_pagechange);
			el.prevButton.on('tap', carousel._evt_prev_btn);
			el.nextButton.on('tap', carousel._evt_next_btn);
			$(window).on('resize', {object: el}, this._evt_resize);
			$(el.slidable).on('pressed', carousel._evt_pressed);
			if(window.browser == 'mobile') { // scroll 또는 swipe 이벤트 판단을 위해 필요.
				$(el.slidable).on('touchmove', carousel._evt_move);
			} else {
				$(el.slidable).on('swipemove', carousel._evt_swipemove);
				this._addSwipeEvent(el); // 데스크탑의 경우에만 넣어줌.
			}
			$(window).on('resize', {object: el}, this._evt_resize);
		},
		
		_evt_resize: function(e){
			el = e.data.object;
			el.width = el.offsetWidth;
			$(el.slidable)
//				.css('height', (el.offsetHeight - el.pagingHeight) + 'px')
				.css('width', el.width * el.pages.length + 'px');
			el.pages.css('width', el.width + 'px').css('position', 'relative');
			el.position = -1 * (el.currentpage - 1) * el.width;
			$.alopex.widget.carousel._slide(el, el.position);
		},
		
		_addSwipeEvent: function (el, once) {
			var method = 'on';
			if(once) {
				method = 'one';
			}
			var swipeEventHandler = this._evt_swipe;
			if(el.buttons) { // tabs 엘리먼트가 아닐 경우만 호출.
				swipeEventHandler = $.alopex.widget.tabs._evt_swipe;
			}
			//$(el.slidable)[method]('swipemove', this._evt_swipemove);
			$(el.slidable)[method]('swipecancel', this._evt_swipecancel);
			$(el.slidable)[method]('swipe', {
				distanceX: 60	// 100px 이상 swipe될 경우, 페이지 이동.
			}, swipeEventHandler);
			
		},
		
		_removeSwipeEvent: function(el) {
			$(el.slidable).off('swipemove', this._evt_swipemove);
			$(el.slidable).off('swipecancel', this._evt_swipecancel);
			$(el.slidable).off('swipe', {
				distanceX: 60	// 100px 이상 swipe될 경우, 페이지 이동.
			}, this._evt_swipe);
		},
		
		_slide: function(el, position) {
			if ($.alopex.widget.carousel.transitionSupport) {
				$(el.slidable).css('transform', 'translate(' + (position) + 'px,0)');
				$(el.slidable).css('transform', 'translate3d(' + (position) + 'px,0,0)');
			} else {
				var height = $(el).css('height');
				$(el.slidable).css({
					position: 'absolute',
					left: (position) + 'px'
				});
				if(height != undefined) {
					$(el).css('height', height);
				}
			}
		},

		_evt_pagechange: function(e, page) {
			var el = $(e.currentTarget).parent('[data-type="carousel"]')[0];
			var distance = el.currentpage - page;
			el.position = el.position + distance * el.width;
			el.currentpage = page;
			
			$.alopex.widget.carousel._slide(el, el.position);
		},

		_evt_prev_btn: function(e) {
			var el = $(e.currentTarget).parent('[data-type="carousel"]')[0];
			$(el).prevSlide();
		},

		_evt_next_btn: function(e) {
			var el = $(e.currentTarget).parent('[data-type="carousel"]')[0];
			//      $(el.slidable).css('transition', 'all ' + el.animationDuration + ' ease-in-out');
			$(el).nextSlide();
		},
		
		_evt_move: function(e) {
			var el = e.currentTarget.element;
			if(!el.pressed) {
				return false;
			}
			var point;
			var touches = e.touches || e.originalEvent.touches;
			if(touches && touches.length > 0) {
				touches = touches[0];
				point = {
					x: touches.clientX? touches.clientX: 0,
					y: touches.clientY? touches.clientY: 0
				};
			} else {
				point = {
					x: e.clientX,
					y: e.clientY
				}
			}
			if(el.mode == 'vertical') {
				// prevent안하고 내비둔다.
				__ALOG('==== 현재 스크롤 ====== ');
			} else if(el.mode == 'horizontal') {
				e.preventDefault();
				__ALOG('==== 현재 스와이프  ====== ');
				distanceX = point.x - el.presspoint.x;
				if (Math.abs(distanceX) > el.width) {
					distanceX = distanceX / distanceX * el.width;
				}
				e.preventDefault(); // android에서는 e.preventDefault 호출해줘야 계속 touchmove 이벤트 발생.
				$.alopex.widget.carousel._slide(el, el.position+distanceX);
			} else { // 미정.
				//e.preventDefault();
				$.alopex.widget.carousel._removeSwipeEvent(el);
				if(Math.abs(el.presspoint.y - point.y) > 10) {
					el.mode = 'vertical';
					__ALOG('==== 버티컬 모드로 진입 ====== ');
				} else { // swipe event handle
					__ALOG('==== 스와이프  모드로 진입 ====== ');
					el.mode = 'horizontal';
					$.alopex.widget.carousel._addSwipeEvent(el, true);
				}
			}
		},

		/**
		 * the event handler for pressed event
		 * it will attach the slides to the both side of current page slide.
		 */
		_evt_pressed: function(e, c) {
			var el = $(e.currentTarget).parent('[data-type="carousel"]')[0];
			el.mode = null;
			el.pressed = true;
			$(el.slidable).css('transition', 'all 0s ease-in-out');
			if(window.browser == 'mobile') {
				var touches = e.touches || e.originalEvent.touches || e.originalEvent.originalEvent.touches;
				if(touches && touches.length > 0) {
					touches = touches[0];
					el.presspoint = {
						x: touches.clientX? touches.clientX: 0,
						y: touches.clientY? touches.clientY: 0
					};
				}
			} else {
				el.presspoint = {
					x: e.clientX,
					y: e.clientY
				};
			}
		},

		_evt_swipemove: function(e, c) {
			var el = $(e.currentTarget).parent('[data-type="carousel"]')[0];
			if(!el.pressed) {
				return ;
			}
			if (Math.abs(c.distanceX) > el.width) {
				c.distanceX = c.distanceX / c.distanceX * el.width;
			}
			e.preventDefault(); // android에서는 e.preventDefault 호출해줘야 계속 touchmove 이벤트 발생.
			$.alopex.widget.carousel._slide(el, el.position+c.distanceX);
		},

		_evt_swipe: function(e, c) {
			var el = $(e.currentTarget).parent('[data-type="carousel"]')[0];
			var duration = (el.width - Math.abs(c.distanceX)) / c.speed * 1000;
			if (duration > 500) {
				duration = 500;
			}
			if (c.distanceX < 0) { // 좌측 이동
				$(el).nextSlide({animationDuration: duration});
			} else { // 우측 이동
				$(el).prevSlide({animationDuration: duration});
			}
			el.press = false;
			$(el).trigger('swipechange', [el.currentpage-1]);
		},

		_evt_swipecancel: function(e, c) {
			var el = $(e.currentTarget).parent('[data-type="carousel"]')[0];
			$.alopex.widget.carousel._slide(el, el.position);
			el.pressed = false;
		},

		nextSlide: function(el, options) {
			var duration = (options && options.animationDuration)? options.animationDuration : el.animationDuration;
			$(el.slidable).css('transition', 'all ' + duration + 'ms ease-in-out');
			if (el.currentpage < el.totalpage) {
				el.position -= el.width;
				el.currentpage++;
				el.paging.setSelectedPage(el.currentpage, true);
			}
			$.alopex.widget.carousel._slide(el, el.position);
			setTimeout(function() {
				$(el.slidable).css('transition', 'all ' + el.animationDuration + 'ms ease-in-out');
			}, duration);
		},

		prevSlide: function(el, options) {
			var duration = (options && options.animationDuration)? options.animationDuration : el.animationDuration;
			$(el.slidable).css('transition', 'all ' + duration + 'ms ease-in-out');
			if (el.currentpage > 1) {
				el.position += el.width;
				el.currentpage--;
				el.paging.setSelectedPage(el.currentpage, true);
			}
			$.alopex.widget.carousel._slide(el, el.position);
			setTimeout(function() {
				$(el.slidable).css('transition', 'all ' + el.animationDuration + 'ms ease-in-out');
			}, duration);
		},
		
		setIndex : function(el, index, options) {
			if(index < 0 || index >= el.pages.length) {
				return ;
			}
			var duration = (options && options.animationDuration != undefined)? options.animationDuration : el.animationDuration;
			$(el.slidable).css('transition', 'all ' + duration + 'ms ease-in-out');
			el.position = el.width*index*-1;
			el.currentpage = index+1;
			el.paging.setSelectedPage(el.currentpage, true);
			$.alopex.widget.carousel._slide(el, el.position);
			setTimeout(function() {
				$(el.slidable).css('transition', 'all ' + el.animationDuration + 'ms ease-in-out');
			}, duration);
		},

		transitionSupport: (function() {
			if (navigator.userAgent.indexOf('MSIE') !== -1 && (navigator.userAgent.indexOf('MSIE 9') === -1 && navigator.userAgent.indexOf('MSIE 10') === -1)) {
				return false;
			}
			return true;
		})()
	});

})(jQuery);
(function($) {

	$.alopex.widget.checkbox = $.alopex.inherit($.alopex.widget.baseinput, {
		widgetName : 'checkbox',
		defaultClassName : 'af-checkbox',
		defaultTextClassName : 'af-checkbox-text',
		getters : ['getValues', 'getTexts'],
		setters : ['checkbox', 'setCheckAll', 'setChecked', 'setValues', 'toggle'],

		style : function(el) {
			if (el.id) {
				$('label[for="' + el.id + '"]').addClass(this.defaultTextClassName);
			} else {
				$(el).parent('label').addClass(this.defaultTextClassName)
			}
		},

		properties : {
			quickResponse : false
		},
		
		setQuickResonse : function(el, bool) {
			// TODO
		},

		setCheckAll : function(el, bool) {
			if (!$.alopex.util.isValid(bool)) {
				return;
			}
			var checkList = $('input[name=' + el.name + ']');
			for ( var i = 0; i < checkList.length; i++) {
				var obj = checkList[i];
				if (bool) {
					obj.checked = true;
				} else {
					obj.checked = false;
				}
			}
			$(el).trigger('change');
		},

		setChecked : function(el, bool) {
			if (!$.alopex.util.isValid(bool)) {
				return;
			}
			if (el.tagName === 'INPUT') {
				if (bool) {
					el.checked = true;
				} else {
					el.checked = false;
				}
			}
			$(el).trigger('change');
		},

		getValues : function(el) {
			var tmpValuesArr = [];

			var checkList = $('input[name=' + el.name + ']:checked');
			for ( var i = 0; i < checkList.length; i++) {
				var obj = checkList[i];
				tmpValuesArr.push($(obj).val());
			}
			return tmpValuesArr;
		},

		setValues : function(el, array) {
			var checkList = $('input[name=' + el.name + ']').prop('checked', false);
			for ( var i = 0; i < checkList.length; i++) {
				var checkbox = checkList[i];
				for ( var j = 0; j < array.length; j++) {
					if (checkbox.value === array[j]) {
						$(checkbox).prop('checked', true);
						array.splice(j, 1);
					}
				}
			}
			$(el).trigger('change');
		},

		getTexts : function(el) {
			var tmpTextsArr = [];
			var checkList = $('input[name=' + el.name + ']:checked');
			for ( var i = 0; i < checkList.length; i++) {
				var obj = checkList[i];
				var elId = $(obj).attr('id');
				var el_label = $(el).parent().find('label[for=\"' + elId + '\"]');

				tmpTextsArr.push($(el_label).text());
			}
			return tmpTextsArr;
		},

		toggle : function(el) {
		  var checkList = $('input[name=' + el.name + ']');
		  for ( var i = 0; i < checkList.length; i++) {
		    var obj = checkList[i];
		    if ($(obj).prop('checked')) {
		      $(obj).prop('checked', false);
		    } else {
		      $(obj).prop('checked', true);
		    }
		  }
		  $(el).trigger('change');
		}
		
	});
})(jQuery);
(function($) {

	$.alopex.widget.dateinput = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'dateinput',
		defaultClassName: 'af-dateinput',
		setters: ['dateinput', 'setEnabled', 'update', 'clear'],
		getters: [],
		
		properties: {
			date: new Date(),
			format: 'yyyy-MM-dd',
			image: false,
			selectyear: false,
			selectmonth: false,
			pickertype: 'daily',
			mindate : null,
			maxdate: null,
			callback: null,
			resetbutton: false,
			blurcallback: null
		},
		
		_generateDate: function(str){
			str = (str).replace(/\-/gi, '');
			if(str.length != 8) {
				return;
			}
			var datestr = str.substr(0,4) + '-' + str.substr(4,2) + '-' + str.substr(6,2);
			return new Date(datestr);
		},
		
		init: function(el, options) {
			var $el = $(el);
			el.options = $.extend({}, this.properties, options);
			if(options.pickertype == 'monthly' && !options.format) {
				el.options.format = 'yyyy-MM';
			}
			$(el).attr('maxlength', el.options.format.length);
			$(el).attr('placeholder', el.options.format);
			
			this.addHoverHighlight(el);
			this.addPressHighlight(el);
			
			if(el.options.image !== false) { // data-image 속성이 존재하는 경우,
				var height = parseInt($el.css('height'));
				el.imagebutton = $('<div></div>')
					.insertAfter(el).addClass('af-dateinput-image');
				if(el.options.image !== '') { // data-image 속성에 값이 지정된 경우 
					$(el.imagebutton).css('background-image', 'url('+el.options.image+')');
				}
				el.imagebutton[0].element = el;
			}
			if(el.options.resetbutton) {
				el.resetbutton = $('<div>x</div>').insertAfter(el).addClass('af-reset-button');
				el.resetbutton[0].element = el;
				el.resetbutton.on('tap', function(e) {
					var target = e.currentTarget;
					var $el = $(target.element);
					if(!$el.is('.af-disabled')) {
						if(target.daterange){
							$(target.daterange).clear();
						} else {
							$el.clear();
						}
						e.preventDefault();
						e.stopPropagation();
					}
				});
			}
//			$el.attr('readonly', true);
			$el.attr('type', 'text');
			this.setEnabled(el, el.options.enabled);
			$el.on('blur', this._blurHandler);
		},
		
		_blurHandler: function(e) {
			var el = e.currentTarget;
			var value = $(el).val();
			var format = el.options.format;
			var seperator = format.replace('yyyy', '').replace('MM', '').replace('dd', '');
			var regexp = format.replace('yyyy', '\\d{1,4}').replace('MM', '\\d{1,2}').replace('dd', '\\d{1,2}');
			regexp = new RegExp(regexp);
			if(value.indexOf(seperator) == -1 && value.length == 8 && value == (parseInt(value)).toString()) { // 숫자만 입력한 경우.
				value = value.substr(0,4) + '-' + value.substr(4,2) + '-' + value.substr(6,2);
				$(el).trigger('change');
			} 
			var date = new Date(value);
			if(isNaN(date.getTime()) || $.alopex.util.getDateString(date, format) != value) {
				$(el).val('');
				$(el).trigger('change');
				if(el.options.blurcallback) {
					el.options.blurcallback(el, value);
				}
			}
		},
		
		update: function(el, options) {
			$.extend(el.options, options);
		},
		
		setEnabled: function(el, flag){
			var $el = $(el);
			flag = $.alopex.util.parseBoolean(flag);
			$(el).off('tap', this._clickEventHandler);
			$(el.imagebutton).off('tap', this._clickEventHandler);
			if (flag) {
				if(el.imagebutton) {
					$(el.imagebutton).on('tap', this._clickEventHandler);
				} else {
					$el.on('tap', this._clickEventHandler);
				}
				$el.add(el.imagebutton).removeClass('af-disabled');
				$el.removeAttr('readonly');
			} else {
				$el.add(el.imagebutton).addClass('af-disabled');
				$el.attr('readonly', true);
			}
		},
		
		clear: function(el) {
			$(el).val('');
			$(el).trigger('change');
		},
		
		_clickEventHandler: function(e) {
			var that = $.alopex.widget.dateinput;
			var target = e.currentTarget.element || e.currentTarget;
			var datestr = $(target).val();
			var date = new Date(datestr);
			date = (isNaN(date.getYear()))? null: date;
			var option = $.extend({}, $.alopex.widget.dateinput.properties, target.options, {
				date: date
			});
			var mindate = $(target).attr('data-mindate');
			if(mindate) {
				option.mindate = that._generateDate(mindate); 
			}
			var maxdate = $(target).attr('data-maxdate');
			if(maxdate) {
				option.maxdate = that._generateDate(maxdate); 
			}
			
			$(target).showDatePicker(function (date, datestr) {
				$(target).val(datestr);
				$(target).trigger('change'); // trigger datamodel set.
				if(target.options.callback) {
					target.options.callback.call(target, date, datestr);
				}
			}, option);
			
		}
	});

})(jQuery);
(function($) {
	if ($.alopex.datePickerMap) {
		return;
	}
	//-----------------------DatePicker----------------------//TODO

	/**
	 * 생성된 Datepicker객체들을 보관하며 set, get, remove 메소드 제공.
	 */
	$.alopex.datePickerMap = {

		datePickerObj: {},

		setObject: function(id, obj) {
			this.datePickerObj[id] = obj;
		},

		getObjectByNode: function(node) {
			var temp = $(node);
			while (temp.attr('data-type') !== 'af-datepicker') {
				temp = temp.parent();
			}
			return this.datePickerObj[temp.attr('id')];
		},

		getObjectById: function(id) {
			var objId = '';
			if (id.indexOf('datepicker_') < 0) {
				objId = 'datepicker_' + id;
			} else {
				objId = id;
			}
			return this.datePickerObj[objId];
		},

		removeObjectById: function(id) {
			var objId = '';
			if (id.indexOf('datepicker_') < 0) {
				objId = 'datepicker_' + id;
			} else {
				objId = id;
			}
			delete this.datePickerObj[objId];
		},

		removeObjectByNode: function(node) {
			var temp = $(node);
			while (temp.attr('data-type') !== 'af-datepicker') {
				temp = temp.parent();
			}
			delete this.datePickerObj[temp.attr('id')];
		}
	};

	/**
	 * DatePicker 구성을 위한 Property 및 method
	 */
	$.alopex.datePicker = {

		MONTHS_KO: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
		MONTHS_EN: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
		MONTHS_JA: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
		MONTHS_ZH: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],

		WEEKDAYS_KO: ['일', '월', '화', '수', '목', '금', '토'],
		WEEKDAYS_EN: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
		WEEKDAYS_JA: ['日', '月', '火', '水', '木', '金', '土'],
		WEEKDAYS_ZH: ['日', '一', '二', '三', '四', '五', '六'],

		POSTFIX_KO: ['년', '월', '일'],
		POSTFIX_EN: ['', '', ''],
		POSTFIX_JA: ['年', '月', '日'],
		POSTFIX_ZH: ['年', '月', '日'],

		DESC_PREVYEAR_KO: '이전년도',
		DESC_PREVYEAR_EN: 'previous year',
		DESC_PREVYEAR_JA: '前年',
		DESC_PREVYEAR_ZH: '前一年',

		DESC_NEXTYEAR_KO: '다음년도',
		DESC_NEXTYEAR_EN: 'next year',
		DESC_NEXTYEAR_JA: '翌年',
		DESC_NEXTYEAR_ZH: '明年',

		DESC_PREVMONTH_KO: '이전 월',
		DESC_PREVMONTH_EN: 'previous month',
		DESC_PREVMONTH_JA: '先月',
		DESC_PREVMONTH_ZH: '上个月',

		DESC_NEXTMONTH_KO: '다음 월',
		DESC_NEXTMONTH_EN: 'next month',
		DESC_NEXTMONTH_JA: '来月',
		DESC_NEXTMONTH_ZH: '下个月',

		DESC_CLOSE_KO: '닫기',
		DESC_CLOSE_EN: 'close',
		DESC_CLOSE_JA: '終了',
		DESC_CLOSE_ZH: '关闭',
		

				DESC_YEARSELECT_KO : '년도 선택',
		DESC_YEARSELECT_EN : 'year select',
		DESC_YEARSELECT_JA : '年を選択',
		DESC_YEARSELECT_ZH : '年份选择',

		DESC_MONTHSELECT_KO : '월 선택',
		DESC_MONTHSELECT_EN : 'month select',
		DESC_MONTHSELECT_JA : '月選択',
		DESC_MONTHSELECT_ZH : '月份选择',

		DESC_MONTH_SUMMARY_KO : '월을 선택할 수 있는 달력입니다.',
		DESC_MONTH_SUMMARY_EN : 'you can select month.',
		DESC_MONTH_SUMMARY_JA : '月を 選べるカレンダーです.',
		DESC_MONTH_SUMMARY_ZH : '选择月份的日历.',

		DESC_MONTH_CAPTION_KO : '월 달력',
		DESC_MONTH_CAPTION_EN : 'month picker',
		DESC_MONTH_CAPTION_JA : '月カレンダー',
		DESC_MONTH_CAPTION_ZH : '月份日历',

		DESC_DAY_SUMMARY_KO : '날짜를 선택할 수 있는 달력입니다.',
		DESC_DAY_SUMMARY_EN : 'you can select a day.',
		DESC_DAY_SUMMARY_JA : '日にちを選べるカレンダーです.',
		DESC_DAY_SUMMARY_ZH : '选择日期的日历.',

		DESC_DAY_CAPTION_KO : '달력',
		DESC_DAY_CAPTION_EN : 'datepicker',
		DESC_DAY_CAPTION_JA : 'カレンダー',
		DESC_DAY_CAPTION_ZH : '日历',

		DESC_TODAY_BTN_KO : '오늘',
		DESC_TODAY_BTN_EN : 'Today',
		DESC_TODAY_BTN_JA : '今日',
		DESC_TODAY_BTN_ZH : '今天',

		currentDate : null, // today info
		weekdays : [],
		months : [],
		dateFormat : null,
		datePostfix : [],
		localeInfo : null,
		certainDates : [],
		mindate : null,
		maxdate : null,

		descPrevYear : null,
		descNextYear : null,
		descPrevMonth : null,
		descNextMonth : null,
		descClose : null,
		descYearSelect : null,
		descMonthSelect : null,
		descMonthSummary : null,
		descMonthCaption : null,
		descDaySummary : null,
		descDayCaption : null,
		descTodayBtn : null,

		daysInMonth : [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ],
		calendarBody : null, // '일' 표시 영역(tbody)
		calendarMonth : null, // header의 '월' 라벨 영역
		calendarYear : null, // header의 '연도' 라벨 영역
		prevMonth : null,
		nextMonth : null,
		prevYear : null,
		nextYear : null,
		btn_close : null,
		_renderCache : [],
		targetElem: null, //datePicker의 위치에 기준이 되는 element
		_callback: null,
		closeCallback: null,
		calendarContainer: null,
		datePickerTheme: 'af-default',//default 테마 Class명
		datePickerInlineTheme: 'af-inline',
		currentArea: null,
		inline: false,
		pickertype: 'daily',
		selectyear : false,
		selectmonth : false,
		showothermonth : false,
		showbottom : false,

		/**
		 * @param {json} param : json형의 option 값.
		 */
		setDefaultDate: function(param) {
			try {
				this.currentDate = new Date(); // default : today
				if ($.alopex.util.isValid(param)) {
					if (param.hasOwnProperty('date')) {
						var obj = param.date;
						if (obj instanceof Date) {
							this.currentDate = obj;
						} else {
							if (!$.alopex.util.isValid(obj.year) || !$.alopex.util.isNumberType(obj.year) || obj.year < 1900 || obj.year > 2100 || !$.alopex.util.isValid(obj.month) ||
									!$.alopex.util.isNumberType(obj.month) || obj.month < 1 || obj.month > 12 || !$.alopex.util.isValid(obj.day) || !$.alopex.util.isNumberType(obj.day) || obj.day > 31 ||
									obj.day < 1) {
								throw '[DatePicker Error] Invalid Date => ' + obj.year + '-' + obj.month + '-' + obj.day;
							}
							this.currentDate = new Date(obj.year, (obj.month - 1), obj.day);
						}
					}
				}
			} catch (e) {
				//        __ALOG(e);
			}
		},

		/**
		 * @param {json} param : return 되는 날짜 정보 format의 key, value.
		 * ex) {'format' : 'yyyy-MM-dd'}.
		 */
		setFormat: function(param) {
			var formatStr = 'yyyyMMdd'; //default
			if ($.alopex.util.isValid(param) && param.hasOwnProperty('format') && $.alopex.util.isValid(param.format)) {
				var pattern = /[Y|m|D|e]/g;
				if (!pattern.test(param.format)) {
					formatStr = param.format;
				} else {
					//          __ALOG('[DatePicker Error] Invalid Date Pattern' + '(y, M, d, E only) => ' + param.format);
				}
			}
			this.dateFormat = formatStr;
		},

		/**
		 * @param {json} param : 달력에 표시되는 월, 요일 영역의 Locale 정보.
		 * ex) {'locale' : 'ko | en | ja | zh'}.
		 */
		setLocale: function(param) {

			var localeStr = 'ko'; //default
			this.localeInfo = 'ko'; //default

			if ($.alopex.util.isValid(param)) {
				if (param.hasOwnProperty('locale')) {
					localeStr = param.locale;
				}
			}

			switch (localeStr) {
			case 'en':
				this.weekdays = this.WEEKDAYS_EN;
				this.months = this.MONTHS_EN;
				this.datePostfix = this.POSTFIX_EN;
				this.descPrevYear = this.DESC_PREVYEAR_EN;
				this.descNextYear = this.DESC_NEXTYEAR_EN;
				this.descPrevMonth = this.DESC_PREVMONTH_EN;
				this.descNextMonth = this.DESC_NEXTMONTH_EN;
				this.descClose = this.DESC_CLOSE_EN;
				this.descYearSelect = this.DESC_YEARSELECT_EN;
				this.descMonthSelect = this.DESC_MONTHSELECT_EN;
				this.descMonthSummary = this.DESC_MONTH_SUMMARY_EN;
				this.descMonthCaption = this.DESC_MONTH_CAPTION_EN;
				this.descDaySummary = this.DESC_DAY_SUMMARY_EN;
				this.descDayCaption = this.DESC_DAY_CAPTION_EN;
				this.descTodayBtn = this.DESC_TODAY_BTN_EN;
				this.localeInfo = 'en';
				break;

			case 'ko':
				this.weekdays = this.WEEKDAYS_KO;
				this.months = this.MONTHS_KO;
				this.datePostfix = this.POSTFIX_KO;
				this.descPrevYear = this.DESC_PREVYEAR_KO;
				this.descNextYear = this.DESC_NEXTYEAR_KO;
				this.descPrevMonth = this.DESC_PREVMONTH_KO;
				this.descNextMonth = this.DESC_NEXTMONTH_KO;
				this.descClose = this.DESC_CLOSE_KO;
				this.descYearSelect = this.DESC_YEARSELECT_KO;
				this.descMonthSelect = this.DESC_MONTHSELECT_KO;
				this.descMonthSummary = this.DESC_MONTH_SUMMARY_KO;
				this.descMonthCaption = this.DESC_MONTH_CAPTION_KO;
				this.descDaySummary = this.DESC_DAY_SUMMARY_KO;
				this.descDayCaption = this.DESC_DAY_CAPTION_KO;
				this.descTodayBtn = this.DESC_TODAY_BTN_KO;
				this.localeInfo = 'ko';
				break;

			case 'ja':
				this.weekdays = this.WEEKDAYS_JA;
				this.months = this.MONTHS_JA;
				this.datePostfix = this.POSTFIX_JA;
				this.descPrevYear = this.DESC_PREVYEAR_JA;
				this.descNextYear = this.DESC_NEXTYEAR_JA;
				this.descPrevMonth = this.DESC_PREVMONTH_JA;
				this.descNextMonth = this.DESC_NEXTMONTH_JA;
				this.descClose = this.DESC_CLOSE_JA;
				this.descYearSelect = this.DESC_YEARSELECT_JA;
				this.descMonthSelect = this.DESC_MONTHSELECT_JA;
				this.descMonthSummary = this.DESC_MONTH_SUMMARY_JA;
				this.descMonthCaption = this.DESC_MONTH_CAPTION_JA;
				this.descDaySummary = this.DESC_DAY_SUMMARY_JA;
				this.descDayCaption = this.DESC_DAY_CAPTION_JA;
				this.descTodayBtn = this.DESC_TODAY_BTN_JA;
				this.localeInfo = 'ja';
				break;

			case 'zh':
				this.weekdays = this.WEEKDAYS_ZH;
				this.months = this.MONTHS_ZH;
				this.datePostfix = this.POSTFIX_ZH;
				this.descPrevYear = this.DESC_PREVYEAR_ZH;
				this.descNextYear = this.DESC_NEXTYEAR_ZH;
				this.descPrevMonth = this.DESC_PREVMONTH_ZH;
				this.descNextMonth = this.DESC_NEXTMONTH_ZH;
				this.descClose = this.DESC_CLOSE_ZH;
				this.descYearSelect = this.DESC_YEARSELECT_ZH;
				this.descMonthSelect = this.DESC_MONTHSELECT_ZH;
				this.descMonthSummary = this.DESC_MONTH_SUMMARY_ZH;
				this.descMonthCaption = this.DESC_MONTH_CAPTION_ZH;
				this.descDaySummary = this.DESC_DAY_SUMMARY_ZH;
				this.descDayCaption = this.DESC_DAY_CAPTION_ZH;
				this.descTodayBtn = this.DESC_TODAY_BTN_ZH;
				this.localeInfo = 'zh';
				break;

			default:
				this.weekdays = this.WEEKDAYS_KO;
				this.months = this.MONTHS_KO;
				this.datePostfix = this.POSTFIX_KO;
				this.descPrevYear = this.DESC_PREVYEAR_KO;
				this.descNextYear = this.DESC_NEXTYEAR_KO;
				this.descPrevMonth = this.DESC_PREVMONTH_KO;
				this.descNextMonth = this.DESC_NEXTMONTH_KO;
				this.descClose = this.DESC_CLOSE_KO;
				this.descYearSelect = this.DESC_YEARSELECT_KO;
				this.descMonthSelect = this.DESC_MONTHSELECT_KO;
				this.descMonthSummary = this.DESC_MONTH_SUMMARY_KO;
				this.descMonthCaption = this.DESC_MONTH_CAPTION_KO;
				this.descDaySummary = this.DESC_DAY_SUMMARY_KO;
				this.descDayCaption = this.DESC_DAY_CAPTION_KO;
				this.descTodayBtn = this.DESC_TODAY_BTN_KO;
				this.localeInfo = 'ko';
			}
		},

		/**
		 * 특정 style을 적용하기 위한 날짜들의 정보를 저장.
		 * 
		 * @param {json}
		 *            param : option값, 'certainDates' key에 날짜정보들이 존재.
		 */
		setCertainDates: function(param) {

			if ($.alopex.util.isValid(param) && param.hasOwnProperty('certainDates')) {
				this.certainDates = param.certainDates;
			}
		},

		setThemeClass: function(param) {

			if ($.alopex.util.isValid(param) && param.hasOwnProperty('themeClass')) {
				this.datePickerTheme = param.themeClass;
			}
		},

		setInline: function(param) {

			if ($.alopex.util.isValid(param) && param.hasOwnProperty('inline')) {
				this.inline = param.inline;
			}
		},

		setMenuSelect: function(param) {
			if ($.alopex.util.isValid(param) && 
					(param.hasOwnProperty('selectyear') || param.hasOwnProperty('selectmonth') 
							|| param.hasOwnProperty('selectYear') || param.hasOwnProperty('selectMonth'))) {
				this.selectyear = param.selectyear || param.selectYear;
				this.selectmonth = param.selectmonth || param.selectMonth;
			}
		},

		setPickerType: function(param) {
			if ($.alopex.util.isValid(param) && (param.hasOwnProperty('pickertype') || param.hasOwnProperty('pickerType'))) {
				this.pickertype = param.pickertype || param.pickerType;
			}
		},
		
		setShowOtherMonth: function(param) {
			if ($.alopex.util.isValid(param) && (param.hasOwnProperty('showOtherMonth') || param.hasOwnProperty('showOthermonth') || param.hasOwnProperty('showotherMonth') || param.hasOwnProperty('showothermonth'))) {
				this.showothermonth = param.showOtherMonth || param.showOthermonth || param.showotherMonth || param.showothermonth;
			}
		},
		
		setShowBottom: function(param) {
			if ($.alopex.util.isValid(param) && (param.hasOwnProperty('showBottom') || param.hasOwnProperty('showbottom'))) {
				this.showbottom = param.showBottom || param.showbottom;
			}
		},

		setCloseCallback: function(param) {
			if ($.alopex.util.isValid(param) && param.hasOwnProperty('closeCallback')) {
				this.closeCallback = param.closeCallback;
			}
		},

		setMinDate: function(param) {
			var now = new Date();
			if ($.alopex.util.isValid(param) && ($.alopex.util.isValid(param.mindate) || ($.alopex.util.isValid(param.minDate)))) {
				this.mindate = param.mindate || param.minDate;
				this.mindate.setHours(0);
				this.mindate.setMinutes(0);
				this.mindate.setMilliseconds(0);
			} else if (this.selectyear) {
				this.mindate = new Date(now.getFullYear() - 10, 1, 1, 0, 0, 0);
			} else {
				this.mindate = new Date(now.getFullYear() - 100, 1, 1, 0, 0, 0);
			}
			//      if(this.currentDate < this.mindate){
			//        this.currentDate = this.mindate;
			//      }
		},

		setMaxDate: function(param) {
			var now = new Date();
			if ($.alopex.util.isValid(param) && ($.alopex.util.isValid(param.maxdate) || ($.alopex.util.isValid(param.maxDate)))) {
				this.maxdate = param.maxdate || param.maxDate;
				this.maxdate.setHours(0);
				this.maxdate.setMinutes(0);
				this.maxdate.setMilliseconds(0);
			} else if (this.selectyear) {
				this.maxdate = new Date(now.getFullYear() + 10, 1, 1, 0, 0, 0);
			} else {
				this.maxdate = new Date(now.getFullYear() + 100, 1, 1, 0, 0, 0);
			}
			//      if(this.maxdate < this.currentDate){
			//        this.currentDate = this.maxdate;
			//      }

			//mindate가 maxdate 보다 클 경우 둘 다 default로 초기화
			if (this.maxdate < this.mindate) {
				if (this.selectyear) {
					this.mindate = new Date(now.getFullYear() - 10, 1, 1, 0, 0, 0);
					this.maxdate = new Date(now.getFullYear() + 10, 1, 1, 0, 0, 0);
				} else {
					this.mindate = new Date(now.getFullYear() - 100, 1, 1, 0, 0, 0);
					this.maxdate = new Date(now.getFullYear() + 100, 1, 1, 0, 0, 0);
				}
			}
		},

		/**
		 * 전달받은 날짜가 특정 날짜의 정보에 저장된 날짜인지 확인. true이면
		 * 전달받은 type에 따라 해당 값을 return, 저장된 날짜가 아니면 false return.
		 *
		 * @param {number} day : 특정 날짜 정보를 조회 할 날짜일수.
		 * @param {string} type : true일 경우 return할 key 값('name' | 'styleClass').
		 * @return {date | boolean false} 저장된 날짜가 아니면 false return.
		 */
		_isCertainDate: function(day) {
			for ( var i = 0; i < this.certainDates.length; i++) {
				var certainDateInfo = this.certainDates[i];
				for ( var j = 0; j < certainDateInfo.dates.length; j++) {
					if (this.currentYearView === certainDateInfo.dates[j].getFullYear() && this.currentMonthView === certainDateInfo.dates[j].getMonth() && Number(day) === certainDateInfo.dates[j].getDate()) {
						return certainDateInfo;
					}
				}
			}

			return false;
		},

		_isBelowMinDate: function(day) {
			var currentDate;
			if (arguments.length === 1) {
				currentDate = new Date(this.currentYearView, this.currentMonthView, day, 0, 0, 0);
			} else {
				currentDate = new Date(this.currentYearView, arguments[0], arguments[1], 0, 0, 0);
			}
			if (currentDate < this.mindate) {
				return true;
			} else {
				return false;
			}
		},

		_isAboveMaxDate: function(day) {
			var currentDate;
			if (arguments.length === 1) {
				currentDate = new Date(this.currentYearView, this.currentMonthView, day, 0, 0, 0);
			} else {
				currentDate = new Date(this.currentYearView, arguments[0], arguments[1], 0, 0, 0);
			}
			if (this.maxdate < currentDate) {
				return true;
			} else {
				return false;
			}
		},

		/**
		 * formatStr에 따라 날짜 정보를 적용 한 후 지정된 callback 함수에 return.
		 * @param {json} dateObj : 날짜정보 (year, month, day).
		 * @param {string} formatStr : 날짜 format 문자열.
		 * @param {string} certainDatesName :
		 *  특정 날짜정보들의 집합 중 선택된 정보의 'name' key의 value.
		 */
		getDateByFormat: function(dateObj, formatStr, certainDatesName, e) {
			//return 할 (json)date. value는 string 형 임.
			var date = {
				year : dateObj.year + '',
				month : dateObj.month + '',
				day : dateObj.day + ''
			};
			var dateStr = this._getFormattedDate(dateObj, formatStr);

			this._callback(date, dateStr, certainDatesName, e);
			if ($.alopex.util.isValid(this.closeCallback)) {
				this.closeCallback();
			}

		},
		
		_getFormattedDate: function(dateObj, formatStr) {
			  var dateStr = '';

			var param_date = new Date(dateObj.year, (dateObj.month - 1),
					dateObj.day);

			var i = 0;
			var num_y = 0; // the number of 'y'
			var num_M = 0; // the number of 'M'
			var num_d = 0; // the number of 'd'
			var num_E = 0; // the number of 'E'
			var delegator = []; // 구분자 보관
			var value_type = []; // 입력한 Format 순서에 맞게 날짜 타입 보관(년, 월, 일, 요일)
			var resultData = []; // delegator와 join하기 전의 최종 데이터

			// default formatStr 설정.
			if (!$.alopex.util.isValid(formatStr)) {
				formatStr = 'yyyyMMdd';
			}

			var value_split = formatStr.split('');
			var dividerStr = '';

			/**
			 * 해당 캐릭터가 DateFormat에 해당하는 캐릭터인지 여부 확인.
			 * 
			 * @param {string}
			 *            char : 체크할 캐릭터.
			 * @return {Boolean} DateFormat에 해당 하는 캐릭터 인지 여부.
			 */
			function isDateFormat(char) {
				if (char === 'y' || char === 'M' || char === 'd'
						|| char === 'E' || char === undefined || char === null
						|| char === '') {

					return true;
				} else {
					return false;
				}
			}

			// Format 타입 parsing
			while (i < value_split.length) {

				if (value_split[i] === 'y') {
					num_y = (formatStr.split('y').length - 1);
					i += num_y;
					value_type.push('y-' + num_y);

					if (isDateFormat(value_split[i])) {
						delegator.push('');
					}

				} else if (value_split[i] === 'M') {
					num_M = (formatStr.split('M').length - 1);
					i += num_M;
					value_type.push('M-' + num_M);

					if (isDateFormat(value_split[i])) {
						delegator.push('');
					}

				} else if (value_split[i] === 'd') {
					num_d = (formatStr.split('d').length - 1);
					i += num_d;
					value_type.push('d-' + num_d);

					if (isDateFormat(value_split[i])) {
						delegator.push('');
					}

				} else if (value_split[i] === 'E') {
					num_E = (formatStr.split('E').length - 1);
					i += num_E;
					value_type.push('E-' + num_E);

					if (isDateFormat(value_split[i])) {
						delegator.push('');
					}

				} else {
					dividerStr += value_split[i];

					if (isDateFormat(value_split[i + 1])) {
						delegator.push(dividerStr);
						dividerStr = '';
					}
					i++;
				}
			}

			// Format에 따른 Date data setting
			for (i = 0; i < value_type.length; i++) {
				var temp = value_type[i].split('-');

				switch (temp[0]) {

				case 'y': // 연도 data setting
					var temp_year = param_date.getFullYear();

					if (temp[1] === '2') { // yy
						resultData.push(temp_year.toString().substring(2, 4));
					} else if (temp[1] === '4') { // yyyy
						resultData.push(temp_year.toString());
					} else {
						resultData.push(temp_year.toString());
					}
					break;

				case 'M': // 월 data setting
					var temp_month = param_date.getMonth();

					if (temp[1] === '1') { // M
						resultData.push(temp_month + 1);

					} else if (temp[1] === '2') { // MM
						resultData.push((temp_month + 1) < 10 ? '0'
								+ (temp_month + 1) : (temp_month + 1));

					} else if (temp[1] === '3') { // MMM
						resultData.push(this._monthToStr(temp_month, false));

					} else if (temp[1] === '4') { // MMMM
						resultData.push(this._monthToStr(temp_month, true));

					} else {
						resultData.push((temp_month + 1) < 10 ? '0'
								+ (temp_month + 1) : (temp_month + 1));
					}
					break;

				case 'd': // 일 data setting
					if (this.pickertype !== 'daily') {
						break;
					}
					var temp_date = param_date.getDate();
					if (temp[1] === '1') { // d
						resultData.push(temp_date);
					} else if (temp[1] === '2') { // dd
						resultData.push(temp_date < 10 ? '0' + temp_date : temp_date);
					} else {
						resultData.push(temp_date < 10 ? '0' + temp_date : temp_date);
					}
					break;
				case 'E': // 요일 data setting
					var temp_day = param_date.getDay();
					if (temp[1] === '3') {
						resultData.push(this._dayToStr(temp_day, false));
					} else if (temp[1] === '4') {
						resultData.push(this._dayToStr(temp_day, true));
					} else {
						resultData.push(this._dayToStr(temp_day, false));
					}
					break;
				}
			}

			// 구분자와 Date data binding
			for (i = 0; i < resultData.length; i++) {
				dateStr += resultData[i];
				if (delegator.length !== 0) {
					if (i <= delegator.length) {
						dateStr += delegator[i];
					}
				}
			}
			return dateStr;
		},
		
		/**
		 * datepicker 닫기(내부 함수)
		 */
		_close: function(e) {
			var obj = null;

			if (!$.alopex.util.isValid(e)) {
				obj = this;

				if (obj.overlayElement) {
					setTimeout(function() {
						$(obj.overlayElement).remove();
					}, 300);
				}
				if (!obj.inline) {
					$(obj.targetElem).focus();
					$(obj.calendarContainer).remove();
					$.alopex.datePickerMap.removeObjectById(obj.calendarContainerId);
				}

			} else {
				obj = $.alopex.datePickerMap.getObjectByNode(e.currentTarget);

				if (obj.overlayElement) {
					setTimeout(function() {
						$(obj.overlayElement).remove();
					}, 300);
				}
				if (!obj.inline) {
					$(obj.targetElem).focus();
					$(obj.calendarContainer).remove();
					$.alopex.datePickerMap.removeObjectByNode(e.currentTarget);
				}
			}

			$(window).unbind('hashchange', obj._onHashChange);
			$(window).unbind('resize', obj._resizeHandler);
			$(document.body).unbind('pressed', obj._mouseDownHandler);
			$(document.body).unbind('keydown', obj._addKeyEvent);

		},

		_addKeyEvent: function(e) {

			var that = e.data.obj;
			var currentAreaValue;
			var isCtrl = false;
			var isShift = false;

			that.currentArea = $(document.activeElement);
			currentAreaValue = $(that.currentArea)[0].value;

			//Ctrl 키 press 여부
			if (e.ctrlKey) {
				isCtrl = true;
			}

			//Shift 키 press 여부
			if (e.shiftKey) {
				isShift = true;
			}

			var code = (e.keyCode ? e.keyCode : e.which);
			var resultValue;
			switch (code) {
			case 13: //enter
			case 32: //space
				$(that.currentArea).trigger('tap');

				if(!(currentAreaValue === 'prevYear' || currentAreaValue === 'nextYear' ||
            currentAreaValue === 'prevMonth' || currentAreaValue === 'nextMonth' ||
            $(that.currentArea).attr('data-type') === 'af-datepicker')){
          $(that.targetElem).focus();
        }

				e.preventDefault();
				e.stopPropagation();
				break;
			case 9: // tap

				if (isShift) {
					if ($(that.currentArea).attr('data-type') === 'af-datepicker') {
						$(that.targetElem).focus();
						that._close();
						e.preventDefault();
					}
				} else {
					if ($(that.currentArea)[0].value === 'close') {
						$(that.calendarContainer).focus();
						e.preventDefault();
					}
				}
				break;
			case 37: //left

			  if(currentAreaValue === 'prevYear' || currentAreaValue === 'nextYear' ||
            currentAreaValue === 'prevMonth' || currentAreaValue === 'nextMonth' ||
            currentAreaValue === 'close' || $(that.currentArea).attr('data-type') === 'af-datepicker'){

					that.currentArea = $(that.calendarContainer).find('a[class*=af-today]');
					if ($(that.currentArea)[0] == undefined) {
            currentAreaValue = 2;
          } else {
            currentAreaValue = $(that.currentArea)[0].value;
          }
				}

				if ((currentAreaValue - 1) <= 0) {
					$(that.prevMonth).trigger('tap');
					resultValue = that._getNumDaysOfMonth();
				} else {
					resultValue = currentAreaValue - 1;
				}

				that.currentArea = $(that.calendarContainer).find('[href=#' + resultValue + ']');
				$(that.currentArea).focus();

				e.preventDefault();
				break;
			case 39: //right

			  if(currentAreaValue === 'prevYear' || currentAreaValue === 'nextYear' ||
            currentAreaValue === 'prevMonth' || currentAreaValue === 'nextMonth' ||
            currentAreaValue === 'close' || $(that.currentArea).attr('data-type') === 'af-datepicker'){
          
					that.currentArea = $(that.calendarContainer).find('a[class*=af-today]');
					if ($(that.currentArea)[0] == undefined) {
            currentAreaValue = 0;
          } else {
            currentAreaValue = $(that.currentArea)[0].value;
          }
				}

				if ((currentAreaValue + 1) > that._getNumDaysOfMonth()) {
					$(that.nextMonth).trigger('tap');
					resultValue = 1;
				} else {
					resultValue = currentAreaValue + 1;
				}

				that.currentArea = $(that.calendarContainer).find('[href=#' + resultValue + ']');
				$(that.currentArea).focus();

				e.preventDefault();
				break;
			case 38: //up

			  if ((e.target.nodeName) === 'SELECT') {
          return;
        }
        
        if(currentAreaValue === 'prevYear' || currentAreaValue === 'nextYear' ||
            currentAreaValue === 'prevMonth' || currentAreaValue === 'nextMonth' ||
            currentAreaValue === 'close' || $(that.currentArea).attr('data-type') === 'af-datepicker'){
          
					that.currentArea = $(that.calendarContainer).find('a[class*=af-today]');
					if ($(that.currentArea)[0] == undefined) {
            currentAreaValue = 8;
          } else {
            currentAreaValue = $(that.currentArea)[0].value;
          }
				}

				if ((currentAreaValue - 7) <= 0) {
					$(that.prevMonth).trigger('tap');
					resultValue = that._getNumDaysOfMonth() + (currentAreaValue - 7);
				} else {
					resultValue = currentAreaValue - 7;
				}

				that.currentArea = $(that.calendarContainer).find('[href=#' + resultValue + ']');
				$(that.currentArea).focus();

				e.preventDefault();
				break;
			case 40: //down
			  if ((e.target.nodeName) === 'SELECT') {
          return;
        }
        
        if(currentAreaValue === 'prevYear' || currentAreaValue === 'nextYear' ||
            currentAreaValue === 'prevMonth' || currentAreaValue === 'nextMonth' ||
            currentAreaValue === 'close' || $(that.currentArea).attr('data-type') === 'af-datepicker'){
          
					that.currentArea = $(that.calendarContainer).find('a[class*=af-today]');
					if ($(that.currentArea)[0] == undefined) {
            currentAreaValue = -6;
          } else {
            currentAreaValue = $(that.currentArea)[0].value;
          }
				}
				if ((currentAreaValue + 7) > that._getNumDaysOfMonth()) {
					resultValue = (currentAreaValue + 7) - that._getNumDaysOfMonth();// should be before trigger
					$(that.nextMonth).trigger('tap');
				} else {
					resultValue = currentAreaValue + 7;
				}
				that.currentArea = $(that.calendarContainer).find('[href=#' + resultValue + ']');
				$(that.currentArea).focus();
				e.preventDefault();
				break;
			case 27: // escape
				$(that.targetElem).focus();
				that._close();
				e.preventDefault();
				break;
			case 36: // home
				if (isCtrl) {
					that.currentYearView = that._getCurrentYear();// '연도' 라벨의 값
					that.currentMonthView = that._getCurrentMonthToInteger();// '월' 라벨의 값
					//          that.calendarYear.innerHTML = that._addLocalePostfix(that.currentYearView, 'y');
					//          that.calendarMonth.innerHTML = that._addLocalePostfix(that._getMonthToString(true), 'm');
					this.setText(this.calendarYear, this._addLocalePostfix(this.currentYearView, 'y'));
					this.setText(this.calendarMonth, this._addLocalePostfix(this._getMonthToString(true), 'm'));
					while (that.calendarBody.hasChildNodes()) {
						that.calendarBody.removeChild(that.calendarBody.lastChild);
					}
					that.calendarBody.appendChild(that._renderCalendar());
					that.currentArea = $(that.calendarContainer).find('a[class*=af-today]');
					$(that.currentArea).focus();
				} else {
					that.currentArea = $(that.calendarContainer).find('[href=#1]');
					$(that.currentArea).focus();
				}
				e.preventDefault();
				break;
			case 35: // end
				that.currentArea = $(that.calendarContainer).find('[href=#' + that._getNumDaysOfMonth() + ']');
				$(that.currentArea).focus();
				e.preventDefault();
				break;
			case 33: //pageUp

				if (currentAreaValue === 'prevYear' || currentAreaValue === 'nextYear' || currentAreaValue === 'prevMonth' || currentAreaValue === 'nextMonth' || currentAreaValue === 'close' ||
						$(that.currentArea).attr('data-type') === 'af-datepicker') {

					that.currentArea = $(that.calendarContainer).find('a[class*=af-today]');
					currentAreaValue = $(that.currentArea)[0].value;
				}

				if (isShift) {
					$(that.prevYear).trigger('tap');

					//윤년처리 - 현재  2월 29일을 선택 중일 경우
					if (that.currentMonthView === 1 && currentAreaValue === 29) {
						resultValue = 28;
					} else {
						resultValue = currentAreaValue;
					}
				} else {
					$(that.prevMonth).trigger('tap');

					if (that._getNumDaysOfMonth() < currentAreaValue) {
						resultValue = that._getNumDaysOfMonth();
					} else {
						resultValue = currentAreaValue;
					}
				}

				that.currentArea = $(that.calendarContainer).find('[href=#' + resultValue + ']');
				$(that.currentArea).focus();

				e.preventDefault();
				break;
			case 34: //pageDown

				if (currentAreaValue === 'prevYear' || currentAreaValue === 'nextYear' || currentAreaValue === 'prevMonth' || currentAreaValue === 'nextMonth' || currentAreaValue === 'close' ||
						$(that.currentArea).attr('data-type') === 'af-datepicker') {

					that.currentArea = $(that.calendarContainer).find('a[class*=af-today]');
					currentAreaValue = $(that.currentArea)[0].value;
				}

				if (isShift) {
					$(that.nextYear).trigger('tap');

					//윤년처리 - 현재  2월 29일을 선택 중일 경우
					if (that.currentMonthView === 1 && currentAreaValue === 29) {
						resultValue = 28;
					} else {
						resultValue = currentAreaValue;
					}
				} else {
					$(that.nextMonth).trigger('tap');

					if (that._getNumDaysOfMonth() < currentAreaValue) {
						resultValue = that._getNumDaysOfMonth();
					} else {
						resultValue = currentAreaValue;
					}
				}

				that.currentArea = $(that.calendarContainer).find('[href=#' + resultValue + ']');
				$(that.currentArea).focus();

				e.preventDefault();
				break;
			default:
				if (!isCtrl && !isShift) {
					$(that.targetElem).focus();
					that._close();
				}
				break;
			}

		},

		/**
		 * Locale에 따른 년, 월, 일 데이터의 postfix를 add 하여 값을 리턴함.
		 * @param {string} paramStr : postfix를 add할 대상이 되는 string data.
		 * @param {string} type : 년, 월, 일 type 명시 ( 'y' | 'm' | 'd', | 'E').
		 * @return {String} : postfix를 add한 결과 string.
		 */
		_addLocalePostfix: function(paramStr, type) {

			var resultStr = paramStr + '';

			switch (type) {
			case 'y': //year
				resultStr += this.datePostfix[0];
				break;

			case 'm': //month
				resultStr += this.datePostfix[1];
				break;

			case 'd': //day
				resultStr += this.datePostfix[2];
				break;

			}

			return resultStr;

		},

		_getCurrentYear: function() {

			return this.currentDate.getFullYear();
		},

		_getCurrentMonthToInteger: function() {

			return this.currentDate.getMonth();
		},

		_getCurrentMonthToString: function(full) {
			var date = this.currentDate.getMonth();

			return this._monthToStr(date, full);
		},

		_getCurrentDay: function() {
			return this.currentDate.getDate();
		},

		_getMonthToInteger: function() {

			return this.currentMonthView;
		},

		_getMonthToString: function(full) {

			var date = this.currentMonthView;

			return this._monthToStr(date, full);
		},

		/**
		 * 각 월의 일수를 return - 윤년 계산(2월).
		 * @return {number} 각 월의 일수.
		 */
		_getNumDaysOfMonth: function(year, month) {
		  if ($.alopex.util.isValid(year) && $.alopex.util.isValid(month)) {
		    return (month === 1 && !(year & 3) && (year % 1e2 || !(year % 4e2))) ? 29 : this.daysInMonth[month];
		  } else {
		    return (this._getMonthToInteger() === 1 && !(this.currentYearView & 3) && (this.currentYearView % 1e2 || !(this.currentYearView % 4e2))) ? 29 : this.daysInMonth[this._getMonthToInteger()];
		  }
		},

//		_getNumDaysOfMonth: function() {
//		  
//		  return (this._getMonthToInteger() === 1 && !(this.currentYearView & 3) && (this.currentYearView % 1e2 || !(this.currentYearView % 4e2))) ? 29 : this.daysInMonth[this._getMonthToInteger()];
//		},

		/**
		 * html element 동적 rendering
		 *
		 * @param {string} nodeName rendering할 html태그명.
		 * @param {json} attributes html 태그의 속성 : value.
		 * @param {string} content html 태그 내의 내용(innerHTML).
		 * @return {html} rendering된 html.
		 */
		_render: function(nodeName, attributes, content) {
			var element;

			if (!(nodeName in this._renderCache)) {
				this._renderCache[nodeName] = document.createElement(nodeName);
			}

			element = this._renderCache[nodeName].cloneNode(false);

			if (attributes !== null) {
				for ( var attribute in attributes) {
					element[attribute] = attributes[attribute];
				}
			}

			if (content !== null && content !== undefined) {
				if (typeof (content) === 'object') {
					element.appendChild(content);
				} else {
					element.innerHTML = content;
				}
			}

			return element;
		},

		_monthToStr: function(date, full) {
			return ((full === true) ? this.months[date] : ((this.months[date].length > 3) ? this.months[date].substring(0, 3) : this.months[date]));
		},

		_dayToStr: function(date, full) {
			return ((full === true) ? this.weekdays[date] : ((this.weekdays[date].length > 3) ? this.weekdays[date].substring(0, 3) : this.weekdays[date]));
		},

		/**
		 *
		 * 연도 컨트롤 버튼의 click 시
		 * - 1900~2100년의 범위만 허용
		 */
		_clickYear: function() {

			if (this.currentYearView < 1900) {

				//허용 범위 중 Minimum
				this.currentYearView = 1900;
			} else if (this.currentYearView > 2100) {

				//허용 범위 중 Maximum
				this.currentYearView = 2100;
			}

			//min, max date 처리
			if (this.currentYearView === this.mindate.getFullYear() && this.currentMonthView < this.mindate.getMonth()) {
				this.currentMonthView = this.mindate.getMonth();
			}

			if (this.currentYearView === this.maxdate.getFullYear() && this.maxdate.getMonth() < this.currentMonthView) {
				this.currentMonthView = this.maxdate.getMonth();
			}

			//      this.calendarYear.innerHTML = this._addLocalePostfix(
			//          this.currentYearView, 'y');
			//      this.calendarMonth.innerHTML = this._addLocalePostfix(this
			//          ._getMonthToString(true), 'm');
			this.setText(this.calendarYear, this._addLocalePostfix(this.currentYearView, 'y'));
			if (this.calendarMonth) { // not available in month picker
				this.setText(this.calendarMonth, this._addLocalePostfix(this._getMonthToString(true), 'm'));
			}

			while (this.calendarBody.hasChildNodes()) {
				this.calendarBody.removeChild(this.calendarBody.lastChild);
			}
			if (this.pickertype === 'daily') {
				// '일' 영역 rendering
				this.calendarBody.appendChild(this._renderCalendar());
			} else if (this.pickertype === 'monthly') {
				// '월' 영역 re-rendering
				this.calendarBody.appendChild(this._renderMonth());
			} else {

			}

			return false;
		},

		setText: function(targetEl, value) {
			if (targetEl.tagName.toLowerCase() === 'input' || targetEl.tagName.toLowerCase() === 'select') {
				$(targetEl).val(value);
			} else {
				$(targetEl).text(value);
			}
		},

		/**
		 * 월 컨트롤 버튼의 click 시
		 */
		_clickMonth: function() {

			if (this.currentMonthView < 0) {
				this.currentYearView--;

				if (this.currentYearView < 1900) {
					this.currentYearView = 1900;
				}

				// '12월' 부터 다시 시작.
				this.currentMonthView = 11;

				this.setText(this.calendarYear, this._addLocalePostfix(this.currentYearView, 'y'));
				this.setText(this.calendarMonth, this._addLocalePostfix(this._getMonthToString(true), 'm'));
				//        this.calendarYear.innerHTML = this._addLocalePostfix(
				//            this.currentYearView, 'y');
				//        this.calendarMonth.innerHTML = this._addLocalePostfix(this
				//            ._getMonthToString(true), 'm');

			} else if (this.currentMonthView > 11) {
				this.currentYearView++;

				if (this.currentYearView > 2100) {
					this.currentYearView = 2100;
				}

				// '1월' 부터 다시 시작.
				this.currentMonthView = 0;

				//        this.calendarYear.innerHTML = this._addLocalePostfix(
				//            this.currentYearView, 'y');
				//        this.calendarMonth.innerHTML = this._addLocalePostfix(this
				//            ._getMonthToString(true), 'm');
				this.setText(this.calendarYear, this._addLocalePostfix(this.currentYearView, 'y'));
				this.setText(this.calendarMonth, this._addLocalePostfix(this._getMonthToString(true), 'm'));

			} else {
				//        this.calendarMonth.innerHTML = this._addLocalePostfix(this
				//            ._getMonthToString(true), 'm');
				this.setText(this.calendarMonth, this._addLocalePostfix(this._getMonthToString(true), 'm'));
			}

			// '일' 영역 re-rendering
			while (this.calendarBody.hasChildNodes()) {
				this.calendarBody.removeChild(this.calendarBody.lastChild);
			}
			this.calendarBody.appendChild(this._renderCalendar());

			return false;
		},

		/**
		 * 연도 컨트롤 버튼의 click handler 설정.
		 */
		_bindYearHandler: function() {
			var that = this;

			$(that.prevYear).unbind('tap');
			$(that.nextYear).unbind('tap');
			$(that.prevYear).children().unbind('focus');
			$(that.prevYear).children().unbind('focusout')
			$(that.nextYear).children().unbind('focus');
			$(that.nextYear).children().unbind('focusout')

			//mindate의 year가 현재 year와 같을 경우
			if (that.mindate.getFullYear() === that.currentYearView) {
				$.alopex.widget.object._addDisabledStyle($(that.prevYear).children());

			} else {
				$.alopex.widget.object._removeDisabledStyle($(that.prevYear).children());

				$(that.prevYear).bind('tap', function(e) {
					var obj = $.alopex.datePickerMap.getObjectByNode(e.currentTarget);
					obj.currentYearView--;
					return obj._clickYear();
				});

				$(that.prevYear).children().bind('focus', function(e) {
					$(this).trigger('hoverstart');
				});

				$(that.prevYear).children().bind('focusout', function(e) {
					$(this).trigger('hoverend');
				});

				$.alopex.widget.object.addPressHighlight($(that.prevYear).children()[0]);
				$.alopex.widget.object.addHoverHighlight($(that.prevYear).children()[0]);
			}

			//maxdate의 year가 현재 year와 같을 경우
			if (this.maxdate.getFullYear() === this.currentYearView) {
				$.alopex.widget.object._addDisabledStyle($(that.nextYear).children());

			} else {
				$.alopex.widget.object._removeDisabledStyle($(that.nextYear).children());

				$(that.nextYear).bind('tap', function(e) {
					var obj = $.alopex.datePickerMap.getObjectByNode(e.currentTarget);
					obj.currentYearView++;
					return obj._clickYear();
				});

				$(that.nextYear).children().bind('focus', function(e) {
					$(this).trigger('hoverstart');
				});

				$(that.nextYear).children().bind('focusout', function(e) {
					$(this).trigger('hoverend');
				});

				$.alopex.widget.object.addPressHighlight($(that.nextYear).children()[0]);
				$.alopex.widget.object.addHoverHighlight($(that.nextYear).children()[0]);
			}

		},

		/**
		 * 월 컨트롤 버튼의 click handler 설정.
		 */
		_bindMonthHandler: function() {
			var that = this;

			if (this.pickertype !== 'daily') {
				return;
			}

			$(that.prevMonth).unbind('tap');
			$(that.nextMonth).unbind('tap');
			$(that.prevMonth).children().unbind('focus');
			$(that.prevMonth).children().unbind('focusout');
			$(that.nextMonth).children().unbind('focus');
			$(that.nextMonth).children().unbind('focusout');

			//mindate의 month가 현재 month와 같을 경우
			if (this.mindate.getMonth() === this.currentMonthView && this.mindate.getFullYear() === this.currentYearView) {
				$.alopex.widget.object._addDisabledStyle($(that.prevMonth).children());

			} else {
				$.alopex.widget.object._removeDisabledStyle($(that.prevMonth).children());

				$(that.prevMonth).bind('tap', function(e) {
					var obj = $.alopex.datePickerMap.getObjectByNode(e.currentTarget);
					obj.currentMonthView--;
					return obj._clickMonth();
				});

				$(that.prevMonth).children().bind('focus', function(e) {
					$(this).trigger('hoverstart');
				});

				$(that.prevMonth).children().bind('focusout', function(e) {
					$(this).trigger('hoverend');
				});

				$.alopex.widget.object.addPressHighlight($(that.prevMonth).children()[0]);
				$.alopex.widget.object.addHoverHighlight($(that.prevMonth).children()[0]);
			}

			//maxdate의 month가 현재 month와 같을 경우
			if (this.maxdate.getMonth() === this.currentMonthView && this.maxdate.getFullYear() === this.currentYearView) {
				$.alopex.widget.object._addDisabledStyle($(that.nextMonth).children());

			} else {
				$.alopex.widget.object._removeDisabledStyle($(that.nextMonth).children());

				$(that.nextMonth).bind('tap', function(e) {
					var obj = $.alopex.datePickerMap.getObjectByNode(e.currentTarget);
					obj.currentMonthView++;
					return obj._clickMonth();
				});

				$(that.nextMonth).children().bind('focus', function(e) {
					$(this).trigger('hoverstart');
				});

				$(that.nextMonth).children().bind('focusout', function(e) {
					$(this).trigger('hoverend');
				});

				$.alopex.widget.object.addPressHighlight($(that.nextMonth).children()[0]);
				$.alopex.widget.object.addHoverHighlight($(that.nextMonth).children()[0]);
			}
		},

		/**
		 * 일 버튼의 click handler 설정.
		 */
		_bindDayHandler: function() {
			var that = this;
			var i, x;

			function isValidAnchor(element) {
				if (element.innerHTML === '') {
					return false;
				}
				if (element.className.indexOf('af-disabled') !== -1) {
					return false;
				}
				return true;
			}

			function _focusHandler(e) {
				if (!isValidAnchor(e.currentTarget)) {
					return false;
				}
				$(this).trigger('hoverstart');
			}
			function _focusoutHandler(e) {
				if (!isValidAnchor(e.currentTarget)) {
					return false;
				}
				$(this).trigger('hoverend');
			}

			function _tapHandler(e) {
				if (!isValidAnchor(e.currentTarget)) {
					e.preventDefault();
					e.stopPropagation();
					return false;
				}
				var obj = $.alopex.datePickerMap.getObjectByNode(e.currentTarget);
				var date;
				if (obj.pickertype === 'daily') {
				  if ($(e.currentTarget).attr('href').indexOf('next') == 1) {
				    date = {
              'year': obj.currentYearView,
              'month': obj.currentMonthView + 2,
              'day': this.innerHTML
            };
				  } else if ($(e.currentTarget).attr('href').indexOf('prev') == 1) {
				    date = {
              'year': obj.currentYearView,
              'month': obj.currentMonthView,
              'day': this.innerHTML
            };
				  } else {
				    date = {
	            'year': obj.currentYearView,
	            'month': obj.currentMonthView + 1,
	            'day': this.innerHTML
	          };
				  }
				} else if (obj.pickertype === 'monthly') {
					date = {
						'year': obj.currentYearView,
						'month': this.month,
						'day': 1
					};
				} else {

				}

				e.preventDefault();
				e.stopPropagation();

				var certainDatesInfo = that._isCertainDate(this.innerHTML);

				if (certainDatesInfo) {
					obj.getDateByFormat(date, obj.dateFormat, certainDatesInfo.name,e);
				} else {
					obj.getDateByFormat(date, obj.dateFormat, false,e);
				}

				if (!obj.inline) {
					if (!certainDatesInfo || certainDatesInfo.isClickToClose) {
						obj._close(e);
					}
				}

				return false;
			}

			$(this.calendarBody).on('focus', 'a', _focusHandler);
			$(this.calendarBody).on('focusout', 'a', _focusoutHandler);
			$(this.calendarBody).on('tap', 'a', _tapHandler);
			$(this.calendarBody).on('click', 'a', function(e) {
				return false;
			});

			$.alopex.widget.object.addPressHighlight(this.calendarBody, 'a');
			$.alopex.widget.object.addHoverHighlight(this.calendarBody, 'a');

		},

		/**
		 * 요일 영역 html 생성 및 바인딩
		 * @return {html} 요일 영역의 html element.
		 */
		_renderWeekdays: function() {
			var that = this;
			var html = document.createDocumentFragment();

			for ( var i = 0; i < that.weekdays.length; i++) {

				//일요일(Sun)을 빨간색으로 표시
				if (i === 0) {
					html.appendChild(that._render('th', {
						className: 'af-datepicker-weekdays holiday'
					}, that.weekdays[i].substring(0, 3)));
				} else if (i !== 0 && i % 6 === 0) {
					html.appendChild(that._render('th', {
						className: 'af-datepicker-weekdays saturday'
					}, that.weekdays[i].substring(0, 3)));
				} else {
					html.appendChild(that._render('th', {
						className: 'af-datepicker-weekdays'
					}, that.weekdays[i].substring(0, 3)));
				}
			}
			return html;
		},

		/**
		 * 분기 영역 구성.
		 * @return {html} '월'영역을 구성한 html element.
		 */
		_renderQtrly: function() {
			return '';
		},

		/**
		 * 월 영역 구성.
		 * @return {html} '월'영역을 구성한 html element.
		 */
		_renderMonth: function() {
			var i = 0, j = 0, rowNum = 3, colNum = 4, thismonth;
			var html = document.createDocumentFragment();
			for (; i < rowNum; i++) {
				var row = this._render('tr', {
					className: 'af-datepicker-tableRow'
				}, '');
				for (j = 0; j < colNum; j++) {
					thismonth = i * 4 + j;

					var month = this._render('a', {
						month: thismonth + 1,
						className: 'af-datepicker-month' + ((this._getCurrentMonthToInteger() == thismonth) ? ' af-today' : ''),
						href: '#' + (i + j + 1)
					}, this._addLocalePostfix(this._monthToStr(thismonth, true), 'm'));
					if (this._isBelowMinDate(thismonth, 1) || this._isAboveMaxDate(thismonth, 1)) {
						$.alopex.widget.object._addDisabledStyle(month);
						$(month).attr('tabindex', '-1');
					}
					row.appendChild(this._render('td', {
						className: 'af-datepicker-tableCell'
					}, month))
				}
				html.appendChild(row);
			}
			
			this._bindYearHandler();
			this._bindMonthHandler();

			return html;
		},

		/**
		 * 일 영역 구성.
		 * @return {html} '일'영역을 구성한 html element.
		 */
		_renderCalendar: function() {

			var firstOfMonth = new Date(this.currentYearView, this.currentMonthView, 1).getDay();
			var numDays = this._getNumDaysOfMonth();
			var dayCount = 0;
			var html = document.createDocumentFragment();
			var row = this._render('tr');
			var element, i;

			//첫번째 일 이전의 이전달 '일' 영역에 대한 공백
			if (this.showothermonth) {
        // 전월 날짜가져오기
        var year = this.currentYearView;
        var prevMonth = this.currentMonthView - 1;
        if (prevMonth === -1) {
          prevMonth = 11;
          year = year - 1;
        }
        var prevNumDays = this._getNumDaysOfMonth(year, prevMonth);

        var prevMonthDay = prevNumDays - firstOfMonth + 1;
        for (i = 1; i <= firstOfMonth; i++) {

          row.appendChild(this._render('td', {
            className : 'af-datepicker-tableCell'
          }, this._render('a', {
            className : 'af-datepicker-prev-month-day',
            value : prevMonthDay,
            href : '#prev' + prevMonthDay
          }, prevMonthDay)));
          prevMonthDay++;
          dayCount++;
        }
      } else {
        for (i = 1; i <= firstOfMonth; i++) {
          row.appendChild(this._render('td', {
            className : 'af-datepicker-tableCell'
          }, '&nbsp;'));
          dayCount++;
        }
      }

			for (i = 1; i <= numDays; i++) {

				if (dayCount === 7) {
					html.appendChild(row);
					row = this._render('tr');
					dayCount = 0;
				}

				//일요일일때 날짜를 빨간색으로 표시
				if (dayCount === 0) {
					element = this
							._render(
									'td',
									{
										className: 'af-datepicker-tableCell'
									},
									this
											._render(
													'a',
													{
														className: (i === this._getCurrentDay() && this.currentMonthView === this._getCurrentMonthToInteger() && this.currentYearView === this._getCurrentYear()) ? 'af-datepicker-day af-today'
																: 'af-datepicker-day holiday',
														value: i,
														href: '#' + i
													}, i));
				} else if (dayCount === 6) {
					element = this
							._render(
									'td',
									{
										className: 'af-datepicker-tableCell'
									},
									this
											._render(
													'a',
													{
														className: (i === this._getCurrentDay() && this.currentMonthView === this._getCurrentMonthToInteger() && this.currentYearView === this._getCurrentYear()) ? 'af-datepicker-day af-today'
																: 'af-datepicker-day saturday',
														value: i,
														href: '#' + i
													}, i));
				} else {
					element = this
							._render(
									'td',
									{
										className: 'af-datepicker-tableCell'
									},
									this
											._render(
													'a',
													{
														className: (i === this._getCurrentDay() && this.currentMonthView === this._getCurrentMonthToInteger() && this.currentYearView === this._getCurrentYear()) ? 'af-datepicker-day af-today'
																: 'af-datepicker-day',
														value: i,
														href: '#' + i
													}, i));
				}

				var certainDateInfo = this._isCertainDate(i);

				if (certainDateInfo) {
					$(element).children().addClass(certainDateInfo.styleClass);
				}

				if (this._isBelowMinDate(i) || this._isAboveMaxDate(i)) {
					$.alopex.widget.object._addDisabledStyle($(element).children());
					$(element).children().attr('tabindex', '-1');
				}

				row.appendChild(element);

				dayCount++;
			}

			//마지막 일 이후의 다음달 '일' 영역에 대한 공백
			if (this.showothermonth) {
        for (i = 1; i <= (7 - dayCount); i++) {
          row.appendChild(this._render('td', {
            className : 'af-datepicker-tableCell'
          }, this._render('a', {
            className : 'af-datepicker-next-month-day',
            value : i,
            href : '#next' + i
          }, i)));
        }
      } else {
        for (i = 1; i <= (7 - dayCount); i++) {
          row.appendChild(this._render('td', {
            className : 'af-datepicker-tableCell'
          }, '&nbsp;'));
        }
      }

			html.appendChild(row);

			this._bindYearHandler();
			this._bindMonthHandler();

			return html;
		},
		
		/**
     * Bottom 영역 구성.
     * @return {element} Bottom 영역을 구성한 element.
     */
		_renderBottom: function() {
      var element = this._render('div',{
         className: 'af-datepicker-bottom'
      });
      
      var childEl = this._render('div',{
        className: 'af-datepicker-childbottom'
      });
      element.appendChild(childEl);
      
      var todayButton = this._render('button',{
        className: 'af-datepicker-bottom-button'
      }, this.descTodayBtn);
      childEl.appendChild(todayButton);
      
      function _todayButtonTapHandler(e) {
        var obj = $.alopex.datePickerMap.getObjectByNode(e.currentTarget);
        var currentDate = new Date();
        var date = {
          'year': currentDate.getFullYear(),
          'month': currentDate.getMonth() + 1,
          'day': currentDate.getDate()
        };

        e.preventDefault();
        e.stopPropagation();

        obj.getDateByFormat(date, obj.dateFormat, false);

        if (!obj.inline) {
          obj._close(e);
        }
        return false;
      }
      
      $(todayButton).bind('tap', _todayButtonTapHandler);
      
      var currentDate = new Date();
      var date = {
        'year': currentDate.getFullYear(),
        'month': currentDate.getMonth() + 1,
        'day': currentDate.getDate()
      };
      
      var bottomText = this._render('span',{
        className: 'af-datepicker-bottom-text'
      }, this._getFormattedDate(date, this.dateFormat));
      childEl.appendChild(bottomText);
      
      return element;
		},

		/**
		 * DatePicker 초기화
		 */
		_initialise: function() {

			var that = this;

			if (this.currentDate < this.mindate) {
				this.currentYearView = this.mindate.getFullYear();
				this.currentMonthView = this.mindate.getMonth();
			} else if (this.currentDate > this.maxdate) {
				this.currentYearView = this.maxdate.getFullYear();
				this.currentMonthView = this.maxdate.getMonth();
			} else {
				this.currentYearView = this._getCurrentYear();// '연도' 라벨의 값
				this.currentMonthView = this._getCurrentMonthToInteger();// '월' 라벨의 값
			}

			this.calendarContainer = this._render('div', {
				className: 'af-datepicker'
			});
			$(this.calendarContainer).attr('data-type', 'af-datepicker');

			if (this.inline) {
				$(this.calendarContainer).attr('data-datepicker-inline', 'true');
				$(this.calendarContainer).addClass(this.datePickerInlineTheme);
			}

			//default 테마 적용.
			$(this.calendarContainer).addClass(this.datePickerTheme);

			//중복 생성 방지를 위해 datepicker_ 를 prefix로 id 부여.
			this.calendarContainer.id = this.calendarContainerId;

			//dstepicker의 head(header) 구성
			var header = this._render('div', {
				className: 'af-datepicker-header'
			});

			//연도 영역
			var subheader01 = this._render('div', {
				className: ((this.pickertype === 'daily') ? 'af-subHeader-year' : 'af-subHeader-year-wide')
			});

			//월 영역
			var subheader02 = this._render('div', {
				className: 'af-subHeader-month'
			});

			this.prevYear = this._render('span', {
				className: 'af-prev-year'
			}, this._render('a', {
				className: 'af-datepicker-control',
				value: 'prevYear',
				
				title: this.descPrevYear
			}, ''));
			if (this.selectyear) {
				var content = '';
				var curYear = this.currentYearView;
				//__ALOG(this.mindate, this.maxdate)
				var minYear = (this.mindate === null) ? curYear - 10 : this.mindate.getFullYear();
				var maxYear = (this.maxdate === null) ? curYear + 10 : this.maxdate.getFullYear();
				for ( var i = minYear; i <= maxYear; i++) {
					content += '<option';
					if (i === curYear) {
						content += ' selected';
					}
					content += '>' + this._addLocalePostfix('' + i, 'y') + '</option>';
				}

				this.calendarYear = this._render('select', {
					className: 'af-current-year-select',
					title: this.descYearSelect
				}, '');
				$(this.calendarYear).append(content);

				$(this.calendarYear).bind('change', function(e) {
					var obj = $.alopex.datePickerMap.getObjectByNode(e.currentTarget);
					obj.currentYearView = parseInt($(e.currentTarget).val(), 10);
					return obj._clickYear();
				});
			} else {
				this.calendarYear = this._render('span', {
					className: 'af-current-year'
				}, this._addLocalePostfix(this.currentYearView, 'y'));
			}
			this.nextYear = this._render('span', {
				className: 'af-next-year'
			}, this._render('a', {
				className: 'af-datepicker-control',
				value: 'nextYear',
				
				title: this.descNextYear
			}, ''));

			//subheader에 연도 영역 append
			subheader01.appendChild(this.prevYear);
			subheader01.appendChild(this.nextYear);
			subheader01.appendChild(this.calendarYear);
			header.appendChild(subheader01);

			if (this.pickertype === 'daily') {
				this.prevMonth = this._render('span', {
					className: 'af-prev-month '
				}, this._render('a', {
					className: 'af-datepicker-control',
					value: 'prevMonth',
					
					title: this.descPrevMonth
				}, ''));
				if (this.selectmonth) {
					var content = '';
					for ( var i = 1; i <= 12; i++) {
						content += '<option';
						if (this.months[i-1] === this._getMonthToString(true)) {
							content += ' selected';
						}
						content += '>' + this._addLocalePostfix('' + this.months[i-1], 'm') + '</option>';
					}
					this.calendarMonth = this._render('select', {
						className: 'af-current-month-select',
						title: this.descMonthSelect
					}, '');
					$(this.calendarMonth).append(content);
					$(this.calendarMonth).bind('change', function(e) {
						var obj = $.alopex.datePickerMap.getObjectByNode(e.currentTarget);
						if (obj.localeInfo === 'en') {
						  obj.currentMonthView = $.inArray($(e.currentTarget).val(), obj.months);
						} else {
						  obj.currentMonthView = parseInt($(e.currentTarget).val(), 10) - 1;
						}
						return obj._clickMonth();
					});
				} else {
					this.calendarMonth = this._render('span', {
						className: 'af-current-month'
					}, this._addLocalePostfix(this._getMonthToString(true), 'm'));
				}

				this.nextMonth = this._render('span', {
					className: 'af-next-month'
				}, this._render('a', {
					className: 'af-datepicker-control',
					value: 'nextMonth',
					
					title: this.descNextMonth
				}, ''));

				//subheader에 월 영역 append
				subheader02.appendChild(this.prevMonth);
				subheader02.appendChild(this.nextMonth);
				subheader02.appendChild(this.calendarMonth);
				header.appendChild(subheader02);
			}

			this.calendarContainer.appendChild(header);

			//inline style
			if (!this.inline) {
				this.btn_close = this._render('span', {
					className: 'af-btn-close'
				}, this._render('a', {
					className: 'af-datepicker-control',
					value: 'close',
					
					title: this.descClose
				}, ''));
				$(this.btn_close).children().bind('tap', function(e) { //TODO
					e.preventDefault();
					e.stopPropagation();

					that._close(e);

					return false;
				});
				$(this.btn_close).children().bind('focus', function(e) {
					$(this).trigger('hoverstart');
				});

				$(this.btn_close).children().bind('focusout', function(e) {
					$(this).trigger('hoverend');
				});

				$.alopex.widget.object.addPressHighlight($(this.btn_close).children()[0]);
				$.alopex.widget.object.addHoverHighlight($(this.btn_close).children()[0]);
			}

			if (this.pickertype === 'monthly') {
				//월 영역 생성
				var calendar = this._render('table', {
				  summary: this.descMonthSummary
				});
				var captionSpan = this._render('span', {} , this.descMonthCaption);
        captionSpan.style.cssText = 'visibility:hidden;overflow:hidden;position:absolute;'
          +'top:0;left:0;width:0;height:0;font-size:0;line-height:0;';
        var caption = this._render('caption', {} , captionSpan);
				calendar.appendChild(caption);
				this.calendarBody = this._render('tbody', {}, '');
				this.calendarBody.appendChild(this._renderMonth());
				calendar.appendChild(this.calendarBody);
				this.calendarContainer.appendChild(calendar);

			} else if (this.pickertype === 'quarterly') {

			} else {
				//일 영역 생성
				var calendar = this._render('table', {
					summary : this.descDaySummary
				});
				var captionSpan = this._render('span', {}, this.descDayCaption);
				captionSpan.style.cssText = 'visibility:hidden;overflow:hidden;position:absolute;'
						+ 'top:0;left:0;width:0;height:0;font-size:0;line-height:0;';
				var caption = this._render('caption', {}, captionSpan);
				calendar.appendChild(caption);
				var calendarHeader = this._render('thead', {}, this._render(
						'tr', {}, this._renderWeekdays()));
				calendar.appendChild(calendarHeader);
				this.calendarBody = this._render('tbody', {}, this._renderCalendar());

				calendar.appendChild(this.calendarBody);
				this.calendarContainer.appendChild(calendar);

				if (this.showbottom) {
				  var bottomElement = this._renderBottom();
				  this.calendarContainer.appendChild(bottomElement);
				}
			}

			//inline style
			if (!this.inline) {
				this.calendarContainer.appendChild(this.btn_close);
			}

			//inline style
			if (!this.inline) {
				$('body').append(this.calendarContainer);
			} else {
				$(this.targetElem).append(this.calendarContainer);
			}

			this._setPosition(this);

		},

		_setPosition: function(obj) {

			if (obj.inline) {
				return;
			}

			var dialog = $.alopex.widget.dialog;
			var zIndex = 1200;
			if (dialog !== null && window.afDialogNumber > 0) {
				zIndex = dialog.maxZindex + 1;
			}
			//for mobile phone type
			if (window.browser === 'mobile' && $(window).width() < 768) {

				var centerTop = ($(window).scrollTop()) ? $(window).scrollTop() + ($(window).height() - obj.calendarContainer.offsetHeight) / 2 : document.body.scrollTop +
						($(window).height() - obj.calendarContainer.offsetHeight) / 2;

				var centerLeft = ($(window).scrollLeft()) ? $(window).scrollLeft() + ($(window).width() - obj.calendarContainer.offsetWidth) / 2 : document.body.scrollLeft +
						($(window).width() - obj.calendarContainer.offsetWidth) / 2;

				obj.calendarContainer.style.cssText = 'display: none; position: absolute; z-index: ' + zIndex + '; top: ' + centerTop + 'px; left: ' + centerLeft + 'px;';

				if (!obj.overlayElement) {
					obj.overlayElement = document.createElement('div');
				}

				var overlayHeight = $(document).height();

				obj.overlayElement.style.cssText = 'width:100%; position:absolute;' + 'left:0; margin:0; padding:0; background:#000; opacity:0.5; z-index:1004;' + 'top:0px;' + 'height:' + overlayHeight +
						'px;';
				$('body').append(obj.overlayElement);

			} else {
				var topValue = $(obj.targetElem).offset().top + obj.targetElem.offsetHeight + 5;
				var leftValue = $(obj.targetElem).offset().left;

				if ($(obj.calendarContainer).width() != $(window).width() &&  // datepicker 스타일이 적용안된 경우.
						(leftValue + $(obj.calendarContainer).width()) > $(window).width()) { //DatePicker가 현재window 너비 밖으로 벗어 날 경우
					leftValue -= (leftValue + $(obj.calendarContainer).width() + 10) - $(window).width();
				}

				obj.calendarContainer.style.cssText = 'display: none; position: absolute; z-index:' + zIndex + '; top: ' + topValue + 'px; left: ' + leftValue + 'px;';
			}

			$(obj.calendarContainer).css('display', 'block');
		},

		/**
		 * 같은 DatePicker가 이미 열려있는지 체크
		 * @param {string} id : DatePicker 위치의 기준이 되는 target element의 id.
		 * @return {Boolean} : DatePicker가 현재 열려 있는지 여부.
		 */
		_isOpened: function(id) {

			var objId = 'datepicker_' + id;

			if ($.alopex.datePickerMap.datePickerObj.hasOwnProperty(objId)) {
				return true;
			} else {
				return false;
			}
		},

		_mouseDownHandler: function(e) {

			var isDatePicker = false;
			var temp = $(e.target);

			for ( var i = 0; i < 7; i++) {

				if (temp.attr('data-type') === 'af-datepicker' && temp.attr('data-datepicker-inline') !== 'true') {
					isDatePicker = true;
					break;
				}

				temp = temp.parent();
			}

			if (!isDatePicker) {
				for ( var key in $.alopex.datePickerMap.datePickerObj) {
					$.alopex.datePickerMap.datePickerObj[key]._close();
				}
			} else {
				return;
			}
		},

		_resizeHandler: function(e) {
			for ( var key in $.alopex.datePickerMap.datePickerObj) {
				$.alopex.datePickerMap.datePickerObj[key]._setPosition($.alopex.datePickerMap.datePickerObj[key]);
			}
		},

		_onHashChange: function(e) {
			for ( var key in $.alopex.datePickerMap.datePickerObj) {
				$.alopex.datePickerMap.datePickerObj[key]._close();
			}
		}

	};

	/**
	 * datepicker 열기
	 */
	$.fn.showDatePicker = function(callback, option) {

		if (!$.alopex.util.isValid(callback) || typeof (callback) !== 'function') {
			//      __ALOG('[DatePicker Error] callback is null or' + 'it is not function type');
			return;
		}

		if (!$.alopex.util.isValid(option)) {
			option = {};
		}

		for ( var key in $.alopex.datePickerMap.datePickerObj) {
			if (!option.inline) {
				$.alopex.datePickerMap.datePickerObj[key]._close();
			}
		}

		var that = $.extend(true, {}, $.alopex.datePicker);

		that.targetElem = this[0];
		that._callback = callback;
		that.calendarContainerId = 'datepicker_' + this[0].id;

		that.setDefaultDate(option);
		that.setLocale(option);
		that.setFormat(option);
		that.setCertainDates(option);
		that.setThemeClass(option);
		that.setMenuSelect(option);
		that.setMinDate(option);
		that.setMaxDate(option);
		that.setInline(option);
		that.setPickerType(option);
		that.setShowOtherMonth(option);
		that.setShowBottom(option);

		that._initialise();
		that._bindYearHandler();
		that._bindMonthHandler();
		that._bindDayHandler();

		//modal style
		if (!that.inline) {
			//for web or tablet type
			if (!(window.browser === 'mobile' && $(window).width() < 768)) {
				$(document.body).bind('pressed', that._mouseDownHandler);
				$(window).bind('hashchange', that._onHashChange);
			}

			$(window).bind('resize', that._resizeHandler);
			$(document.body).bind('keydown', {
				obj: that
			}, that._addKeyEvent);

			$(that.calendarContainer).attr('tabindex', 0);
			$(that.calendarContainer).focus();

			$(that.targetElem).bind('pressed', function(e) {
				e.stopPropagation();
			});
		}

		$(that.calendarContainer).bind('selectstart dragstart', function(e) {
			return false;
		});

		$.alopex.datePickerMap.setObject(that.calendarContainerId, that);
	};

	/**
	 * datepicker 닫기
	 */
	$.fn.closeDatePicker = function() {

		if ($.alopex.datePicker._isOpened(this[0].id)) {
			var obj = $.alopex.datePickerMap.getObjectById(this[0].id);
			obj._close();
		}
	};

	$.alopex.registerSetup('datePicker', function(option) {
		$.extend($.alopex.datePicker, option);
	});

})(jQuery);
(function($) {

	$.alopex.widget.daterange = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'daterange',
		defaultClassName: 'af-daterange',
		setters: ['daterange', 'setEnabled', 'clear'],
		getters: [],
		
		properties: {
			date: new Date(),
			format: 'yyyy-MM-dd',
			image: false,
			selectyear: false,
			selectmonth: false,
			pickertype: 'daily',
			autodisable: true,
			callback: null,
			resetbutton: false
		},

		init: function(el, options) {
			var $el = $(el);
			var $inputs = $el.find('input');

			el.options = $.extend({}, this.properties, options);
			el._start = $el.find('[data-role="' + this.id_startdate + '"]');
			el._end = $el.find('[data-role="' + this.id_enddate + '"]');
			
			el._start.attr('data-type', 'dateinput').dateinput($.extend({}, options, {callback: this._startEventHandler}));
			el._end.attr('data-type', 'dateinput').dateinput($.extend({}, options, {callback: this._endEventHandler}));
			
			if(el.options.resetbutton) {
				if(el._start.length>0 && el._start[0].resetbutton && el._start[0].resetbutton.length > 0) {
					el._start[0].resetbutton[0].daterange = el;
				}
				if(el._end.length>0 && el._end[0].resetbutton && el._end[0].resetbutton.length > 0) {
					el._end[0].resetbutton[0].daterange = el;
				}
			}
			this.setEnabled(el, el.options.enabled);
			
		},
		
		id_startdate: 'startdate',
		id_enddate: 'enddate',
		id_widget: 'daterange',

		_startEventHandler: function(date, datestr) {
			var el = $(this).closest('[data-type="daterange"]')[0];
			if(el.options.autodisable) {
				el._end.update({mindate: new Date(datestr)});
			}
			if(el.options.callback) {
				el.options.callback.call(el, date, datestr);
			}
		},

		_endEventHandler: function(date, datestr) {
			var el = $(this).closest('[data-type="daterange"]')[0];
			if(el.options.autodisable) {
				el._start.update({maxdate: new Date(datestr)});
			}
			
			if(el.options.callback) {
				el.options.callback.call(el, date, datestr);
			}
		},

		setEnabled: function(el, flag) {
			flag = $.alopex.util.parseBoolean(flag);
//			if (flag) {
//				$(el).removeClass('af-disabled');
//			} else {
//				$(el).addClass('af-disabled');
//			}
			el._start.setEnabled(flag);
			el._end.setEnabled(flag);
		},
		
		clear: function(el) {
			$(el._start).clear();
			$(el._end).clear();
		}
	});
	
//	$.alopex.registerSetup('daterange', function(option) {
//		$.alopex.widget.daterange.properties = option;
//	});

})(jQuery);
(function($) {

	$.alopex.widget.dialog = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'dialog',
		defaultClassName: 'af-dialog',
		maxZindex: 1001,
		dialoglist: [], // opened dialog

		properties: {
			dialogtype: null,
			animation: 'show',
			animationtime: 500,
			resizable: false,
			dialogmovable: false,
			modal: false,
			modalScroll: false,
			modalclose: false,
			scroll: false,
			toggle: false
		},

		element: [],
		getters: [],
		setters: ['dialog', 'open', 'close', 'ok', 'cancel', 'confirm', 'reposition'],

		defer: function(el, options) {
			$(el).css('display', 'none');
		},

		init: function(el, options) {
			for ( var i in options) {
				if (options[i] === 'true' || options[i] === 'false') {
					options[i] = $.alopex.util.parseBoolean(options[i]);
				}
				if ($.alopex.util.isNumberType(options[i])) {
					options[i] = parseInt(options[i], 10);
				}
			}
			$.extend(el, this.properties, options);
			// data-* attribute와 open 함수 호출시 parameter의 키가 다름으로 인한 처리.
			if (el.dialogmovable) {
				el.movable = el.dialogmovable;
			}
			if (el.dialogmodal) {
				el.modal = el.dialogmodal;
			}
			if (el.height) {
				$(el).css('height', el.height);
			}
			if (el.width) {
				$(el).css('width', el.width);
			}
			// dialog position style은 fixed로 수정.  by YSM 20130702
			$(el).attr('style', ($(el).attr('style') ? $(el).attr('style') : '') + ';position:fixed;z-index:1001;opacity:0;overflow:hidden;'); 
			

			//contents
			if ($.alopex.util.isValid($(el).children()[0])) {
				el.contents = $(el).children();
			}

			this._setDialogType(el, el.dialogtype);
			this._setResizable(el, el.resizable);
			this._setMovable(el, el.movable);
			this._setModal(el, el.modal);

			if(window.browser != 'mobile') {
				$(el).on('pressed focusin', $.alopex.widget.dialog._clickMoveToTop); // 선택된 다이얼로그가 상위로 올라오게 처리.
				$(el).on('keydown', $.alopex.widget.dialog._addKeydownEvent);
			}

			//origin size setting
			el.originWidth = $(el).width();
			el.originHeight = $(el).height();
			
			
			// mobile 기기에서 키패드에 의해 다이얼로그가 가려지는 현상으로 인하여 강제 올리기.
			if(window.browser == 'mobile') { 
				var __dialog = el;
				__dialog.lifted = false;
				
				function _dialog_reposition() {
					var element = document.activeElement;
					if(element.tagName.toLowerCase() == 'iframe') {
						element = element.contentWindow.document.activeElement;
					} else if(element.tagName.toLowerCase() == 'body') {
						element = $(element).find(':focus');
						if(element.length>0) {
							element = element[0];
						} else {
							return false;
						}
					}
					var elementTop = $.alopex.util.getPagePosition(element).top;
					var elementBottom = elementTop + element.offsetHeight;
					var currentWindowHeight = $(window).height();
					
					if(elementBottom >= currentWindowHeight && // 현재 선택된 엘리먼트가 가려질때.
						__dialog.windowheight > currentWindowHeight) { // 윈도우가 줄어 들었을
						__dialog.liftedHeight = Math.abs(elementBottom - currentWindowHeight)+50;
						__dialog.lifted = true;
						$(el).css('top', (parseInt(el.style.top) - __dialog.liftedHeight) + 'px');
					} else if(__dialog.windowheight < currentWindowHeight && __dialog.lifted) {
						$(el).css('top', (parseInt(el.style.top) + __dialog.liftedHeight) + 'px');
						__dialog.lifted = false;
					}
					__dialog.windowheight = currentWindowHeight;
				}
				$(window).on('resize', _dialog_reposition);
//				$(el).on('focusin', function(e) {
//					_dialog_reposition();
////					alert('focusin');
//				});
			}
		},

		_addKeydownEvent: function(e) {
			var el = e.currentTarget;
			var code = e.keyCode !== null ? e.keyCode : e.which;

			switch (code) {
			case 27:
				$(el).close();
				break;
			case 9:
				if (el.modal) { // 모달인 경우, 다이얼로그 내의 엘리먼트 만 포커스 가도록 설정.
					var selectorcondition = 'a[href], area[href], input:not([disabled]), select:not([disabled]), '
							+ 'textarea:not([disabled]), button:not([disabled]), iframe, object, embed, *[tabindex], *[contenteditable]';
					if (e.shiftKey) {
						if (document.activeElement === $(this)[0] || document.activeElement === $(this).find(selectorcondition).first()[0]) {
							$($(el).find(selectorcondition).last()).focus();
							e.preventDefault();
						}
						break;
					}
					if (document.activeElement === $(this).find(selectorcondition).last()[0]) {
						$($(el).find(selectorcondition).first()).focus();
						e.preventDefault();
					}
				}
				break;
			default:
				break;
			}
		},

		_setDialogType: function(el, type) {
			$(el.header).remove();
			$(el.button).remove();
			$(el.closebtn).remove();
			$(el.confrimbtn).remove();
			$(el.okbtn).remove();
			$(el.cancelbtn).remove();

			if (type === 'blank' || type === 'close' || type === 'confirm' || type === 'okcancel') {
				// header
				el.header = document.createElement('div');
				$(el.header).attr('class', 'dialog_header');
				
				if(el.toggle) {
					var togglebtn = document.createElement('button');
					togglebtn.dialog = el;
					$(togglebtn).attr('class', 'dialog_btn dialog_toggle');
					$(togglebtn).tap(function(e) {
						if(e.currentTarget.dialog.folded) {
							$(e.currentTarget.dialog).animate({height: e.currentTarget.dialog.defaultHeight+'px'}, 300);
							e.currentTarget.dialog.folded = false;
						} else {
							e.currentTarget.dialog.defaultHeight = $(e.currentTarget.dialog).height();
							e.currentTarget.dialog.folded = true;
							$(e.currentTarget.dialog).animate({height: '45px'}, 300);
						}
					});
					this.addHoverHighlight(togglebtn);
					this.addPressHighlight(togglebtn);
					el.header.appendChild(togglebtn);
				}

				var closebtn = document.createElement('button');
				closebtn.dialog = el;
				$(closebtn).attr('class', 'dialog_btn');
				$(closebtn).tap(function(e) {
					$(e.currentTarget.dialog).close();
				});
				this.addHoverHighlight(closebtn);
				this.addPressHighlight(closebtn);
				el.header.appendChild(closebtn);

				$(el).prepend(el.header);

				//contents
				if ($.alopex.util.isValid(el.contents)) {
				  $.each(el.contents, function(i, elem) {
				    el.appendChild(elem);
				  });
				}

				if (type === 'close') {
					//button
					el.button = document.createElement('div');
					$(el.button).attr('class', 'dialog_btn');
					this.addHoverHighlight(el.button);
					this.addPressHighlight(el.button);
					if (!el.resizable) {
						$(el.button).attr('style', 'padding-bottom:0px ;');
					}

					el.closebtn = document.createElement('button');
					el.closebtn.dialog = el;
					$(el.closebtn).attr('data-type', 'button');
					$(el.closebtn).attr('style', 'float:right;');
					$(el.closebtn).text('Close');

					$(el.closebtn).button();
					$(el.closebtn).on('click', function(e) {
						var el = e.currentTarget.dialog;
						$(el).close();
					});

					el.button.appendChild(el.closebtn);
					el.appendChild(el.button);
				} else if (type === 'confirm') {
					//button
					el.button = document.createElement('div');
					$(el.button).attr('class', 'dialog_btn');
					this.addHoverHighlight(el.button);
					this.addPressHighlight(el.button);
					if (!el.resizable) {
						$(el.button).attr('style', 'padding-bottom:0px ;');
					}

					el.confirmbtn = document.createElement('button');
					$(el.confirmbtn).attr('data-type', 'button');
					$(el.confirmbtn).attr('style', 'float:right;');
					$(el.confirmbtn).text('Confirm');

					$(el.confirmbtn).button();

					el.button.appendChild(el.confirmbtn);
					el.appendChild(el.button);
				} else if (type === 'okcancel') {
					//button
					el.button = document.createElement('div');
					$(el.button).attr('class', 'dialog_btn');
					this.addHoverHighlight(el.button);
					this.addPressHighlight(el.button);
					if (!el.resizable) {
						$(el.button).attr('style', 'padding-bottom:0px ;');
					}

					el.okbtn = document.createElement('button');
					$(el.okbtn).attr('data-type', 'button');
					$(el.okbtn).attr('style', 'position: absolute;right: 80px;');
					$(el.okbtn).text('Ok');

					el.cancelbtn = document.createElement('button');
					$(el.cancelbtn).attr('data-type', 'button');
					$(el.cancelbtn).attr('style', 'float:right;');
					$(el.cancelbtn).text('Cancel');

					$(el.okbtn).button();
					$(el.cancelbtn).button();

					el.button.appendChild(el.okbtn);
					el.button.appendChild(el.cancelbtn);
					el.appendChild(el.button);
				}
			}
		},

		_setModal: function(el, modal) {
		  // modal 일때만 blocker 생성
			if (!$.alopex.util.isValid(el.blocker) && modal) {
				el.blocker = document.createElement('div');
				el.blocker.dialog = el;
				// [IE7] 바디영역에 block를 붙히는 경우, HTML markup의 상황에 따라 다이얼로그 z-index가 큼에도 불구하고 다이얼로그가 뒤로 이동됨.
				// 이에 따라, block를 다이얼로그와 동일 depth에 위치.
				//          document.body.appendChild(el.blocker);
				//          el.parentNode.appendChild(el.blocker);
				el.parentNode.appendChild(el.blocker);
				$(el.blocker).addClass('af-dialog-mask');
				$(el.blocker).css({
					'opacity': '0.5',
					'overflow': 'hidden',
					'display': 'none',
					'z-index': '999',
					'position': 'fixed',
					'left': '0',
					'top': '0',
					'-ms-filter': 'progid:DXImageTransform.Microsoft.Alpha(Opacity=50)',
					'width': '100%',
					'height': '100%'
				});
				//TODO: blocker에서 이벤트 막아주기 위해 아래와 같이 처리하였으나, 다이얼로그에서 스크롤 이벤트 발생시 영향 있음.
				// HTML markup 상 현재 구조에서는 어쩔수 없음. 마크업 변경 또는 다른대안 필요.
				if (el.modalScroll == undefined || el.modalScroll !== 'true') {
					$(el.blocker).on('touchstart touchmove', function(e) {
						e.preventDefault();
						e.stopPropagation();
						return false;
					});
				}
				
				if(el.modalclose) {
					$(el.blocker).on('pressed', function(e) {
						var el = e.currentTarget.dialog;
						$(el).close();
					});					
				}
			}
		},

		_setMovable: function(el, movable) {
			var dialog = $.alopex.widget.dialog;
			if (movable && window.browser !== 'mobile') {
				var childrenLength = $(el).children().length;
				if (childrenLength > 0) {
					if ($.alopex.util.isValid(el.header)) {
						$(el.header).on('pressed', this._preMoveDialog);
						$(el.header).css('cursor', 'move');
					} else {
						$($(el).find('[data-dialog-movecursor=true]')[0]).on('pressed', this._preMoveDialog);
						$($(el).find('[data-dialog-movecursor=true]')[0]).css('cursor', 'move');
					}
				}
			} else {
				if ($.alopex.util.isValid(el.header)) {
					$(el.header).off('pressed', this._preMoveDialog);
					$(el.header).css('cursor', '');
				} else {
					$($(el).find('[data-dialog-movecursor=true]')[0]).off('pressed', this._preMoveDialog);
					$($(el).find('[data-dialog-movecursor=true]')[0]).css('cursor', '');
				}
			}
		},

		_setResizable: function(el, resizable) {
			var dialog = $.alopex.widget.dialog;
			if (resizable && window.browser !== 'mobile') {
				//footer
				el.footer = document.createElement('div');

				el.resizeHandleLeft = document.createElement('div');
				$(el.resizeHandleLeft).attr('style', 'position:absolute;top:0px;left:0px;width:2px;' + 'height:100%;cursor:w-resize;');

				el.resizeHandleRight = document.createElement('div');
				$(el.resizeHandleRight).attr('style', 'position:absolute;top:0px;right:0px;width:2px;' + 'height:100%;cursor:col-resize;');

				el.resizeHandleBottom = document.createElement('div');
				$(el.resizeHandleBottom).attr('style', 'position:absolute;left:0px;bottom:0px;' + 'width:100%;height:2px;cursor:s-resize;');

				el.resizeHandleBoth = document.createElement('div');
				$(el.resizeHandleBoth).attr('class', 'resizeBtn');

				el.footer.appendChild(el.resizeHandleLeft);
				el.footer.appendChild(el.resizeHandleRight);
				el.footer.appendChild(el.resizeHandleBottom);
				el.footer.appendChild(el.resizeHandleBoth);
				el.appendChild(el.footer);

				el.resizeHandleLeft.dialog = el.resizeHandleRight.dialog = el.resizeHandleBottom.dialog = el.resizeHandleBoth.dialog = el;

				$(el.resizeHandleLeft).on('pressed', this._preResizeDialog);
				$(el.resizeHandleRight).on('pressed', this._preResizeDialog);
				$(el.resizeHandleBottom).on('pressed', this._preResizeDialog);
				$(el.resizeHandleBoth).on('pressed', this._preResizeDialog);
			} else {
				$(el.footer).remove();
			}
		},

		_preMoveDialog: function(e, ae) {
			document.onselectstart = function() {
				return false;
			};

			var dialog = $.alopex.widget.dialog;
			var offset = $(this).offset();
			var data = {};
			data.x = ae.pageX - offset.left;
			data.y = ae.pageY - offset.top;
			data.element = e.currentTarget;
			$(document).on('move.alopexDialogMove', data, $.alopex.widget.dialog._moveDialog).on('unpressed.alopexDialogMove', data, $.alopex.widget.dialog._postMoveDialog);
		},

		_moveDialog: function(e, ae) {
			var x = ae.pageX - $(window).scrollLeft();
			var y = ae.pageY - $(window).scrollTop();
			if (!e.data.element) {
				return;
			}

			var el = e.data.element;
			var parent = el.parentElement;

			$(parent).css('left', x - e.data.x + 'px');
			if ((parent.offsetLeft) <= 0) {
				$(parent).css('left', '0px');
			}
			if (parent.offsetLeft >= ($(window).width() - $(parent).width())) {
				$(parent).css('left', ($(window).width() - $(parent).width()) + 'px');
			}
			$(parent).css('top', y - e.data.y + 'px');
			if (parent.offsetTop <= 0) {
				$(parent).css('top', '0px');
			}
			if ($(window).height() <= (parent.offsetTop + $(parent).height())) {
				$(parent).css('top', ($(window).height() - $(parent).height()) + 'px');
			}
		},
		_postMoveDialog: function(e, ae) {
			$(document).off('.alopexDialogMove');
			document.onselectstart = function() {
				return true;
			};
		},

		_preResizeDialog: function(e) {
			var target = e.currentTarget;
			var el = target.dialog;

			var dialog = $.alopex.widget.dialog;
			$(el.resizeHandleLeft).on('swipemove', $.alopex.widget.dialog._resizeLeftDialog).on('unpressed', $.alopex.widget.dialog._postResizeDialog);
			$(el.resizeHandleRight).on('swipemove', $.alopex.widget.dialog._resizeRightDialog).on('unpressed', $.alopex.widget.dialog._postResizeDialog);
			$(el.resizeHandleBottom).on('swipemove', $.alopex.widget.dialog._resizeBottomDialog).on('unpressed', $.alopex.widget.dialog._postResizeDialog);
			$(el.resizeHandleBoth).on('swipemove', $.alopex.widget.dialog._resizeBothDialog).on('unpressed', $.alopex.widget.dialog._postResizeDialog);

			document.onselectstart = function() {
				return false;
			};
		},

		_postResizeDialog: function(e) {
			var target = e.currentTarget;
			var el = target.dialog;

			$(el.resizeHandleLeft).off('swipemove');
			$(el.resizeHandleRight).off('swipemove');
			$(el.resizeHandleBottom).off('swipemove');
			$(el.resizeHandleBoth).off('swipemove');

			document.onselectstart = function() {
				return true;
			};
		},

		_resizeLeftDialog: function(e, ae) {
			var x = ae.pageX - $(window).scrollLeft();
			var el = e.currentTarget;
			var parent = el.parentElement.parentElement;

			var offsetRight = $(window).width() - (parent.offsetLeft + $(parent).width());
			var gap = parent.offsetLeft - x;
			var resizedX = $(parent).width() + gap;

			if (resizedX <= parent.originWidth) {
				resizedX = parent.originWidth;
				$(parent).css('width', resizedX + 'px');
				$(parent).children().each(function() {
					if (this.nodeName !== 'BUTTON') {
						$(this).css('width', resizedX + 'px');
					}
				});
				if ((offsetRight - ae.startX) <= parent.originWidth) {
					$(parent).css('left', ae.startX + 'px');
				}
			} else {
				if ((parent.offsetLeft) <= 0) {
					$(parent).css('left', '3px');
				} else {
					$(parent).css('left', x + 'px');
					$(parent).css('width', resizedX + 'px');
					$(parent).children().each(function() {
						if (this.nodeName !== 'BUTTON') {
							$(this).css('width', resizedX + 'px');
						}
					});
				}
			}
		},

		_resizeRightDialog: function(e, ae) {
			document.onselectstart = function() {
				return false;
			};

			var x = ae.pageX - $(window).scrollLeft();
			var el = e.currentTarget;
			var parent = el.parentElement.parentElement;

			var resizedX = x - parent.offsetLeft;

			if (resizedX < parent.originWidth) {
				resizedX = parent.originWidth;
			}

			$(parent).css('width', resizedX + 'px');
			$(parent).children().each(function() {
				if (this.nodeName !== 'BUTTON') {
					$(this).css('width', resizedX + 'px');
				}
			});
			if ($(parent).width() >= ($(window).width() - parent.offsetLeft)) {
				$(parent).css('width', ($(window).width() - parent.offsetLeft - 3) + 'px');
				$(parent).children().each(function() {
					if (this.nodeName !== 'BUTTON') {
						$(this).css('width', ($(window).width() - parent.offsetLeft) + 'px');
					}
				});
			}
		},

		_resizeBottomDialog: function(e, ae) {
			document.onselectstart = function() {
				return false;
			};

			var y = ae.pageY - $(window).scrollTop();

			var el = e.currentTarget;
			var parent = el.parentElement.parentElement;

			var resizedY = y - parent.offsetTop;

			if (resizedY < parent.originHeight) {
				resizedY = parent.originHeight;
			}

			$(parent).css('height', resizedY + 'px');
			if ($(parent).height() >= ($(window).height() - parent.offsetTop)) {
				$(parent).css('height', ($(window).height() - parent.offsetTop - 3) + 'px');
			}
		},

		_resizeBothDialog: function(e, ae) {
			$.alopex.widget.dialog._resizeRightDialog(e, ae);
			$.alopex.widget.dialog._resizeBottomDialog(e, ae);
		},
		
		_clickMoveToTop: function(e) {
      var el = (e) ? e.currentTarget : this.element[this.element.length-1];
      var dialog = $.alopex.widget.dialog;
      var dialogLength = dialog.dialoglist.length;
      
      var runMoveToTop = true;
      $.each(dialog.dialoglist, function(index, value) {
        if (dialog.dialoglist[index].modal) {
          runMoveToTop = false;
          return;
        }
      });
      
      if (runMoveToTop) {
        $.alopex.widget.dialog._moveToTop(e);
      }
		},

		_moveToTop: function(e) {
			var el = (e) ? e.currentTarget : this.element[this.element.length-1];
			var dialog = $.alopex.widget.dialog;
			var dialogLength = dialog.dialoglist.length;
			
			if (dialogLength <= 1) {
			  $(el).css('z-index', dialog.maxZindex);
        if (el.modal) {
          $(el.blocker).css('z-index', dialog.maxZindex - 1);
        }
        return;
      }
			
			$.each(dialog.dialoglist, function(index, value) {
			  if (dialog.dialoglist[index] === el) {
			    var topEl = dialog.dialoglist.splice(index,1);
			    dialog.maxZindex = 1000 + dialogLength;
			    $(el).css('z-index', dialog.maxZindex);
	        if (el.modal) {
	          $(el.blocker).css('z-index', dialog.maxZindex - 1);
	        }
	        
			    dialog.dialoglist = topEl.concat(dialog.dialoglist);
			    var maxZindex = dialog.maxZindex;
			    for(var i=1;i<dialogLength;i++) {
			      maxZindex--;
			      $(dialog.dialoglist[i]).css('z-index', maxZindex);
	          if (dialog.dialoglist[i].modal) {
	            $(dialog.dialoglist[i].blocker).css('z-index', maxZindex - 1);
	          }
			    }
			  }
			});
		},

		open: function(el, obj, callbck) {
			//open check
			if ($(el).is(':visible') && $(el).css('opacity') != '0') {
				return;
			}
			if (obj) {
				if (obj.height) {
					$(el).css('height', obj.height);
				}
				if (obj.width) {
					$(el).css('width', obj.width);
				}

				// 새롭게 옵션에 설정된 값 반영.
				if ($.alopex.util.isValid(obj.resizable)) {
					this._setResizable(el, obj.resizable);
				}
				if ($.alopex.util.isValid(obj.movable)) {
					this._setMovable(el, obj.movable);
				}
				if ($.alopex.util.isValid(obj.modal)) {
					this._setModal(el, obj.modal);
				}

				for (i in obj) {
					if (obj[i] === 'true' || obj[i] === 'false') {
						obj[i] = $.alopex.util.parseBoolean(obj[i]);
					}
					if ($.alopex.util.isNumberType(obj[i])) {
						obj[i] = parseInt(obj[i], 10);
					}
				}
				$.extend(el, obj);
				if (obj.type) { // 
					el.dialogtype = obj.type || el.dialogtype;
					this._setDialogType(el, el.dialogtype); // 타입 재지정.
				}

			}
			// set open button
			if ($.alopex.util.isValid(document.activeElement) && document.activeElement.tagName !== "BODY") {
				el.target = document.activeElement;
			} else if ($.alopex.util.isValid(window.event)) {
				el.target = window.event.srcElement;
			}

			if ($(el).children().length > 0) {
				if ($.alopex.util.isValid(el.title)) {
					for (i = 0; i < $($(el).children()[0]).contents().length; i++) {
						if ($($(el).children()[0]).contents()[i].nodeType === 3) {
							$(el).children()[0].removeChild($($(el).children()[0]).contents()[i]);
						}
					}
					$($(el).children()[0]).append(el.title);
				}
			}

			if (el.modal) { 
				// 20140715 
				// 이전 다이얼로그 오픈 시 바디 스크롤 막기위해서 처리 히스토리
				// body 영역의 width & height을 윈도우 영역과 맞추고 overflow:hidden 처리로 스크롤이 안되게 처리.
				// 이렇게 처리해도 
				$(el.blocker).css('display', 'block');
				if(document.body.style.position != 'fixed' && document.body.style.position != 'absolute') {
					this.bodyposition = document.body.style.position;
					this.bodywidth = document.body.style.width;
					$('body').css({
						'top': (document.body.scrollTop * -1) + 'px',
						'position': 'fixed',
						'width': '100%'
					});
				}
				
			}

			$(el).css('display', 'block');
			$(el).css('opacity', '1');
			
			// -webkit-transform 버그로 fixed position 역할을 제대로 못해줌.
			// 이 경우, 바디 및에 붙혀줌.
			if($(el).closest('[data-carousel]').length > 0 || $(el).closest('[data-carousel]').length > 0) {
				$(el).appendTo('body');
				$(el.blocker).appendTo('body');
			}

			// set dialog position
			if (!$.alopex.util.isValid(el.top)) {
				var centerTop = ($(window).height() - el.offsetHeight) / 2;
				el.top = (centerTop + this.dialoglist.length * 10);
			}
			if (!$.alopex.util.isValid(el.left)) {
				var centerLeft = ($(window).width() - el.offsetWidth) / 2;
				el.left = (centerLeft + this.dialoglist.length * 10);
			}
			$(el).css('top', el.top + 'px');
			$(el).css('left', el.left + 'px');
			
			if (el.scroll) {
			  this._calculateHeight(el);
			}
			// dialog position이 'absolute'일 경우, top & left 계산.
			
			switch (el.animation) {
			case 'slide':
				$(el).css('top', (el.offsetHeight * -1) + 'px');
				$(el).animate({
					'top': el.top + 'px'
				}, el.animationtime);
				break;
			case 'fade':
				$(el).css('opacity', '0');
				$(el).animate({
					'opacity': '1'
				}, el.animationtime);
				break;
			default:
				break;
			}
//			$(document.body).css('overflow', 'hidden'); // position: fixed 처리로 인해 불필요. 주석처리 20140715

			this.element.push(el);
			this.dialoglist.push(el);
			this._moveToTop();

			el.windowheight = $(window).height();
			$(window).on('resize', this._reposition);

			// 개발자도구 IE7모드에서, tabindex="0" 속성 사용시 focus함수 호출하면 브라우져 뻗음.
			// 일반 IE7모드에서는 focus이벤트가 계속 발생.
			//        $(el).attr('tabindex', '0');
			var selectorcondition = 'a[href], area[href], input:not([disabled]), select:not([disabled]), '
				+ 'textarea:not([disabled]), button:not([disabled]), iframe, object, embed, *[tabindex], *[contenteditable]';
			$(el).find(selectorcondition).eq(0).focus();

			if (callbck) {
				callbck.apply();
			}
			$(el).trigger('open');
		},

		ok: function(el, callback) {
			$(el.okbtn).on('tap', function() {
				callback();
			});
		},

		cancel: function(el, callback) {
			$(el.cancelbtn).on('tap', function() {
				callback();
			});
			
		},

		confirm: function(el, callback) {
			$(el.confirmbtn).on('tap', function() {
				callback();
			});
		},
		
		close: function(el, callback) {
			try{
				// close callback 등록.
				if ($.alopex.util.isValid(callback)) {
					el.closecallback = callback;
					return;
				}
			
				var dialog = $.alopex.widget.dialog;
				if ($(el).is(':hidden')) {
					return;
				}
				for(var i=0; i<this.element.length; i++) {
					if(el == this.element[i]) {
						this.element.splice(i, 1);
						break;
					}
				}
				
				$(el).css('z-index', 1001);
				$.alopex.util.arrayremove(this.dialoglist, el);
				if (this.dialoglist.length == 0) {
					this.maxZindex = 1001;
				}
				if (el.modal && this.dialoglist.length == 0) { 
					var body = document.body;
					var scrollTop = Math.abs(parseInt(body.style.top));
					$(body).css({
						'top': '',
						'position': this.bodyposition? this.bodyposition: '',
						'width': this.bodywidth? this.bodywidth: ''
					});
					
					body.scrollTop = scrollTop; // scroll 위치 조정.
					
				}

				
				if(window.browser == 'mobile') {
					setTimeout(function (){
						$.alopex.widget.dialog._close(el);
					}, 400)
				} else {
					$.alopex.widget.dialog._close(el);
				}
				
				// modal 사용 경우, 바디에 걸려있는 스크롤 락 해제.
				$(window).off('resize', this._reposition);
				$(el.okbtn).off('tap');
				$(el.cancelbtn).off('tap');
				$(el.closebtn).off('tap');
				$(el.confirmbtn).off('tap');

				if ($.alopex.util.isValid(el.target)) {
					$(el.target).focus();
				}
			}catch(e){
				
			}
			
		},
		
		_close: function(el) {
			switch (el.animation) {
				case 'slide':
					$(el).animate({
						'top': (el.offsetHeight * -1) + 'px'
					}, el.animationtime, function(e) {
						if (el.modal) {
							$(el.blocker).css('display', 'none');
						}
						$(el).css('display', 'none');
					});
					break;
				case 'fade':
					$(el).animate({
						'opacity': '0'
					}, el.animationtime, function(e) {
						if (el.modal) {
							$(el.blocker).css('display', 'none');
						}
						$(el).css('display', 'none');
					});
					break;
				default:
					if (el.modal) {
						$(el.blocker).css('display', 'none');
					}
					$(el).css('display', 'none');
					break;
				}
			if(el.closecallback) {
				el.closecallback();
			}
		},
		
		// scroll 영역 height 계산
		_calculateHeight: function(el) {
		  var parentHeight = $(el).height() - (el.offsetHeight - el.clientHeight);
      var siblingHeight = 0;
      var children = el.children;
      for ( var i = 0; i < children.length; i++) {
        if (!$(children[i]).attr('data-dialog-scroll')) {
          // check floated element
          if (children[i].style.position !== 'absolute') {
            siblingHeight += $(children[i]).height();
            if (!isNaN(parseInt($(children[i]).css('margin-top'), 10))) {
              siblingHeight += parseInt($(children[i]).css('margin-top'), 10);
            }
            if (!isNaN(parseInt($(children[i]).css('margin-bottom'), 10))) {
              siblingHeight += parseInt($(children[i]).css('margin-bottom'), 10);
            }
          }
        }
      }

      $(el).find('[data-dialog-scroll=true]').css('height', (parentHeight - siblingHeight) + 'px');
      $(el).find('[data-dialog-scroll=true]').css('overflow-y', 'scroll');
		},

		reposition: function(el) {
			
			if ($.alopex.util.isValid(el)) {
				var centerTop = ($(window).height() - el.offsetHeight) / 2;
				$(el).css('top', (centerTop + this.dialoglist.length * 10) + 'px');
				var centerLeft = ($(window).width() - el.offsetWidth) / 2;
				$(el).css('left', (centerLeft + this.dialoglist.length * 10) + 'px');
			}

			if ($.alopex.util.isValid(el) && el.modal) {
				$(el.blocker).css('height', $(document).height() + 'px');
				$(el.blocker).css('width', $(document).width() + 'px');
			}
		},

		_reposition: function(e) {
//			alert('screen.height === ' + screen.height + ', window height === ' + $(window).height())
			e.preventDefault();
			var el = $.alopex.widget.dialog.element;

			if ($.alopex.util.isValid(el) && !el.resizable && !el.movable) {
				var centerTop = ($(window).height() - el.offsetHeight) / 2;
				$(el).css('top', (centerTop + $.alopex.widget.dialog.dialoglist.length * 10) + 'px');
				var centerLeft = ($(window).width() - el.offsetWidth) / 2;
				$(el).css('left', (centerLeft + $.alopex.widget.dialog.dialoglist.length * 10) + 'px');
			}

			if ($.alopex.util.isValid(el) && el.modal) {
				$(el.blocker).css('height', $(document).height() + 'px');
				$(el.blocker).css('width', $(document).width() + 'px');
			}
		},

		id: {
			value: null,
			enumerable: true,
			configurable: false,
			writable: true
		}

	});

})(jQuery);

(function($) {

	/*********************************************************************************************************
	 * divselect
	 *********************************************************************************************************/
	$.alopex.widget.divselect = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'divselect',
		defaultClassName: 'af-select',
		eventHandlers: {
			change: {
				event: 'change',
				handler: '_changeHandler'
			}
		},
		getters: ['getValues', 'getTexts'],
		setters: ['divselect', 'setPlaceholder', 'setSelected', 'clear', 'refresh', 'setEnabled'],
		properties: {
			select: null
		},

		renderTo: function(el) {
			return '<div class="af-select-wrapper ' + el.className + '" af-dynamic data-select-wrapper="true"><select></select></div>';
		},

		markup: function(el) {
		},

		init: function(el) {
			var text = $(el).find(':selected').text();
			this._setText(el.parentNode, text);
		},
		
		_changeHandler: function(e) {
			var el = e.currentTarget;
			var text = $(el).find(':selected').text();
			$.alopex.widget.divselect._setText(el.parentNode, text);
		},

		setPlaceholder: function(el, text) {
			$.alopex.widget.baseselect.setPlaceholder(el, text);
		},

		setSelected: function(el, text) {
			$.alopex.widget.baseselect.setSelected(el, text);
		},
		
		refresh: function(el) {
			$.alopex.widget.baseselect.refresh(el);
		},

		getValues: function(el) {
			return $.alopex.widget.baseselect.getValues(el);
		},

		getTexts: function(el) {
			return $.alopex.widget.baseselect.getTexts(el);
		},

		clear: function(el) {
			$.alopex.widget.baseselect.clear(el, text);
		},

		setEnabled: function(el, bool) {
			$.alopex.widget.baseselect.setEnabled(el, bool);
			if (bool) {
				$(el.parentNode).removeClass('af-disabled');
			} else {
				$(el.parentNode).addClass('af-disabled');
			}
		},

		_setText: function(wrapper, text) {
			text = text || '';
			var node;
			var children = wrapper.childNodes;
			for ( var i in children) {
				if (children[i].nodeType === 3) {
					node = children[i];
					break;
				}
			}
			if (node) {
				node.nodeValue = (text);
			} else {
				$(wrapper).append(text);
			}
		}
	});

})(jQuery);
(function($) {

	$.alopex.widget.dropdown = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'dropdown',
		defaultClassName: 'af-dropdown',
		setters: ['dropdown', 'addHandler', 'setDataSource', 'open', 'close', 'toggle', 'refresh'],
		getters: [],

		markup: function(el, options) {
			var $el = $(el);
			$.extend(el, {
				opentrigger: 'click', // the event which the base element will trigger to OPEN the dropdown menu
				closetrigger: 'click', // the event which the base element will trigger to CLOSE the dropdown menu
				submenutrigger: null,
				base: $(el).prev(),
				curstate: 'closed',
				position: 'bottom',
				cssstyle: {
					'position': 'absolute',
					'top': '0px',
					'left': '0px'
				},
				trigger: 'click',
				margin: 3,
				focusmove: 'false',
				classname: [''],
				callback: []

			}, options);

			var $base = $(el.base);
			if ($base.length === 0) {
				return;
			}
			el.base = $base[0];
			$base.each(function() {
				this.dropdown = el;
			});
			$base.attr('tabindex', '0');
			this.refresh(el);
		},

		init: function(el, options) {
			var $el = $(el);
			var $base = $(el.base);

			// el triggered event
			if (el.opentrigger !== undefined && el.opentrigger === el.closetrigger) {
				$base.on(el.opentrigger, $.alopex.widget.dropdown._toggle);
			} else {
				if (el.opentrigger) {
					$base.on(el.opentrigger, $.alopex.widget.dropdown._open);
				}
				if (el.closetrigger) {
					$base.on(el.closetrigger, $.alopex.widget.dropdown._close);
				}
			}
			$el.on('click', 'li.af-focused', {
				element: el
			}, $.alopex.widget.dropdown._clickHandler);

			// submenu open을 담당하는 이벤트 명시.
			if (el.submenutrigger === 'click') {
				$el.on('click', 'li', {
					element: el
				}, $.alopex.widget.dropdown._toggleHandler);
			} else { // hover 
				$el.on('mouseenter', 'li', {
					element: el
				}, $.alopex.widget.dropdown._openSubmenu);
				$el.on('mouseleave', 'li', {
					element: el
				}, $.alopex.widget.dropdown._closeSubmenu);
			}

			// blur시 드랍다운 close 처리.
			$base.on('blur', $.alopex.widget.dropdown._blurHandler);
			// hover시 af-focus 표시.
			$el.on('mouseleave mouseenter', 'li.af-menuitem', function(e) {
				var target = e.currentTarget;
				if (target.className.indexOf('af-disabled') === -1) {
					var $target = $(target);
					var $el = $target.closest('[data-type]');
					$el.find('*').filter('.af-focused').removeClass('af-focused');
					$target.addClass('af-focused');
				}
			});

			$(el.base).bind('keydown', $.alopex.widget.dropdown._inputBaseKeyDownHandler);
			$(el).bind('keydown', $.alopex.widget.dropdown._inputBaseKeyDownHandler);

		},

		refresh: function(el) {
			var $el = $(el);
			$el.find('li').each(function() {
				if (this.className.indexOf('af-divider') === -1 && this.className.indexOf('af-group-header') === -1) {
					$(this).addClass('af-menuitem');
				}
			});
			$el.find('ul').addClass('af-submenu');
			$el.find('.af-submenu').parent().addClass('af-expandable');
			$el.css(el.cssstyle);
			$el.hide();
		},

		_blurHandler: function(e) {
			var dropdown = e.currentTarget.dropdown;
			//      $(dropdown).close();
		},

		addHandler: function(el, callback) {
			el.callback.push(callback);
		},

		_toggle: function(e) {
			var target = e.currentTarget;
			var el = target.dropdown;
			$(el).toggle();
		},

		_open: function(e) {
			var target = e.currentTarget;
			var el = target.dropdown;
			$(el).open();
		},

		_close: function(e) {
			var target = e.currentTarget;
			var el = target.dropdown;
			$(el).close();
		},

		_closeByKey: function(e) {
			var target = e.target;
			var arr = $.alopex.widget.dropdown.activeList;
			for ( var i = 0; i < arr.length; i++) {
				var el = $.alopex.widget.dropdown.activeList.shift();
				if ((el !== target && $(target).closest(el).length === 0) && (el.base !== target && $(target).closest(el.base).length === 0)) {
					// 드랍다운 영역이 아닌 배경화면 및 다른 컴퍼넌트 클릭.
					$(el).close();
				} else {
					$.alopex.widget.dropdown.activeList.push(el);
				}
			}
		},

		toggle: function(el) {
			var $el = $(el);
			if (el.curstate === 'closed') {
				$el.open();
			} else {
				$el.close();
			}
		},

		_toggleHandler: function(e) {
			var li = e.currentTarget;
			if (li.className.indexOf('af-expandable') !== -1) {
				$.alopex.widget.dropdown.toggleSubmenu(li);
			}
		},

		_clickHandler: function(e) {
			var el = e.data.element;
			for ( var i = 0; i < el.callback.length; i++) {
				el.callback[i].apply(el, [e]);
			}

			if (el.base.tagName.toLowerCase() === 'input' || e.which !== undefined) { // 키보드로 클릭한 경우, 가상 이벤트가 발생하기 때문에 e.which 값 undefined.
				$(el).close();
			}

		},

		_openSubmenu: function(e) {
			var li = e.currentTarget;
			$.alopex.widget.dropdown.openSubmenu(li);
		},

		_closeSubmenu: function(e) {
			var li = e.currentTarget;
			$.alopex.widget.dropdown.closeSubmenu(li);
		},

		openSubmenu: function(li) {
			var $li = $(li);
			if ($li.attr('class').indexOf('af-expandable') !== -1) {
				$li.addClass('af-expanded');
				$li.find('> ul').css('display', 'inline-block');
			}
		},

		closeSubmenu: function(li) {
			var $li = $(li);
			if ($li.attr('class').indexOf('af-expandable') !== -1) {
				$li.removeClass('af-expanded');
				$li.find('> ul').css('display', 'none');
			}
		},

		toggleSubmenu: function(li) {
			var $li = $(li);
			if ($li.attr('class').indexOf('af-expanded') !== -1) {
				$.alopex.widget.dropdown.closeSubmenu(li);
			} else {
				$.alopex.widget.dropdown.openSubmenu(li);
			}
		},

		_htmlGenerator: function(data) {
			var markup = '';
			for ( var i = 0; i < data.length; i++) {
				markup += '<li';
				if (data[i].id !== undefined) {
					markup += ' id="' + data[i].id + '"';
				}
				markup += '><a';
				if (data[i].link !== undefined) {
					markup += ' href="' + data[i].link + '"';
				}
				markup += '>';
				if (data[i].text !== undefined) {
					markup += data[i].text;
				}
				if (data[i].items) {
					markup += '</a><ul>';
					markup += $.alopex.widget.dropdown._htmlGenerator(data[i].items);
					markup += '</ul></li>';
				} else {
					markup += '</a></li>';
				}

			}
			return markup;
		},

		setDataSource: function(el, data) {
			var $el = $(el);
			switch (typeof data) {
			case 'string':
				$el.html(data);
				break;
			case 'object':
				$el.html($.alopex.widget.dropdown._htmlGenerator(data));
				break;
			default:
				break;
			}
			$(el).refresh();
		},

		_inputBaseKeyDownHandler: function(e) {
			var base = this;
			var el = base.dropdown;

			if (typeof el !== 'undefined') {
				if (e.which === 40) {// down
					if (el.curstate === 'closed') {
						$(el).open();
					}
					$.alopex.widget.dropdown._focusNext(el);
					e.preventDefault();
				} else if (e.which === 38) { // up
					$.alopex.widget.dropdown._focusPrev(el);
					e.preventDefault();
				} else if (e.which === 27) { // esc
					$(el).close();
				} else if (e.which === 39) { // right
					$.alopex.widget.dropdown._focusChild(el);
				} else if (e.which === 37) { // left
					$.alopex.widget.dropdown._focusParent(el);
				} else if (e.which === 13) { // enter
					var $focused = $(el).find('.af-focused');
					if ($focused.length > 0) {
						//            $focused.attr('tabindex', '0')[0].focus();
						$(el).find('.af-focused').trigger('click');
					}

				}
			}
		},

		_select: function(el) {

		},

		_focus: function(el, li) {
			$(el).find('.af-focused').removeClass('af-focused');
			$(li).addClass('af-focused');
			if (el.focusmove === 'true') {
				li.focus();
			}
		},

		_isValidMenu: function($li) {
			if ($li.length <= 0) {
				return true;
			}
			var li = $li[0];
			if (!li.className) {
				return false;
			}
			if (li.className.indexOf('af-menuitem') === -1) {
				return false;
			}
			if (li.className.indexOf('af-disabled') !== -1) {
				return false;
			}
			if (li.className.indexOf('af-group-header') !== -1) {
				return false;
			}
			return true;
		},

		_focusPrev: function(el) {
			if (typeof el === undefined) {
				el = this;
			}
			var $el = $(el);
			var $focused = $el.find('.af-focused');
			var $prev = $focused.prev('li');
			while (!$.alopex.widget.dropdown._isValidMenu($prev)) {
				$prev = $prev.prev('li');
			}
			if ($focused.length !== 0 && $prev.length > 0) {
				$.alopex.widget.dropdown._focus(el, $prev[0]);
			}
		},

		_focusNext: function(el) {
			if (typeof el === undefined) {
				el = this;
			}
			var $el = $(el);
			var $focused = $el.find('.af-focused');
			var $next = $focused.next('li');
			while (!$.alopex.widget.dropdown._isValidMenu($next)) {
				$next = $next.next('li');
			}
			if ($focused.length === 0 && $el.find('li').length > 0) {
				$.alopex.widget.dropdown._focus(el, $el.find('li')[0]);
			} else if ($next.length !== 0) {
				$.alopex.widget.dropdown._focus(el, $next[0]);
			}
		},

		_focusChild: function(el) {
			if (typeof el === undefined) {
				el = this;
			}
			var $el = $(el);
			var $focused = $el.find('.af-focused');
			var $submenu = $focused.find('.af-submenu');
			if ($submenu.length > 0 && $submenu.find('li.af-menuitem').length > 0) {
				$.alopex.widget.dropdown.openSubmenu($focused[0]);
				$.alopex.widget.dropdown._focus(el, $submenu.find('li.af-menuitem')[0]);
			}
		},

		_focusParent: function(el) {
			if (typeof el === undefined) {
				el = this;
			}
			var $el = $(el);
			var $focused = $el.find('.af-focused');
			var $parent = $focused.parents('.af-expandable').eq(0);

			if ($parent.length > 0) {
				$.alopex.widget.dropdown.closeSubmenu($parent[0]);
				$.alopex.widget.dropdown._focus(el, $parent[0]);
			}
		},

		activeList: [],

		open: function(el) {
			var $el = $(el);

			$el.css({
				'display': 'block'
			});
			var dropdownWidth = el.offsetWidth;
			var dropdownHeight = el.offsetHeight;
			var baseWidth = el.base.offsetWidth;
			var baseHeight = el.base.offsetHeight;

			// 팝업 띄우는 거
			var parent = el.offsetParent;
			while(parent) {
				if($(parent).css('position') === 'relative' || $(parent).css('position') === 'absolute') {
					break;
				}
				parent = el.offsetParent;
			}
			var basePosition = $.alopex.util.getRelativePosition(el.base); // base엘리먼트의 화면 포지션..
			var coorPosition = $.alopex.util.getRelativePosition(parent); // 엘리먼트 기준.
			var baseLeft = basePosition.left - coorPosition.left;
			var baseTop = basePosition.top - coorPosition.top;
			
			var top = 0;
			var left = 0;
			switch (el.position) {
			case 'top':
				left = baseLeft;
				top = baseTop - dropdownHeight - el.margin;
				break;
			case 'left':
				left = baseLeft - dropdownWidth - el.margin;
				top = baseTop;
				break;
			case 'right':
				left = baseLeft + baseWidth + el.margin;
				top = baseTop;
				break;
			case 'bottom':
				/* falls through */
			default:
				left = baseLeft;
				top = baseTop + baseHeight + el.margin;
				break;
			}
			$el.css({
				'left': left + 'px',
				'top': top + 'px'
			});
			$.alopex.widget.dropdown.activeList.push(el);
			el.curstate = 'opened';
			$(document).bind('pressed', $.alopex.widget.dropdown._closeByKey);
		},

		close: function(el) {
			var $el = $(el);
			for ( var i = 0; i < $.alopex.widget.dropdown.activeList.length; i++) {
				if ($.alopex.widget.dropdown.activeList[i] === el) {
					$.alopex.widget.dropdown.activeList.splice(i, 1);
					break;
				}
			}
			el.curstate = 'closed';
			$el.hide();

			$el.find('.af-focused').removeClass('af-focused');
			$(document).unbind('pressed', $.alopex.widget.dropdown._closeByKey);
		}

	});

})(jQuery);
(function($) {

	$.alopex.widget.dropdownbutton = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'dropdownbutton',
		defaultClassName: 'af-button',
		setters: ['dropdownbutton', 'setText', 'addHandler', 'setDataSource'],
		getters: ['getText'],

		properties: {
			dropdown: null,
			update: 'true'
		},

		init: function(el, options) {
			var $el = $(el);

			var $menu = $el.next().add($(options.menu));
			if ($menu.length === 0 || $menu[0].tagName.toLowerCase() !== 'ul') {
				return;
			}

			$.extend(el, $.alopex.widget.dropdownbutton.properties, options);
			el.dropdown = $menu[0];
			// 변환
			$(el).button();
			$menu.attr('data-type', 'dropdown').dropdown();

			// 스타일링.
			$el.add($menu).addClass('af-dropdownbutton');

			el.dropdown.base = el;
		},

		defer: function(el, options) {
			var $el = $(el);
			var $menu = $(el.dropdown);
			$menu.addHandler($.alopex.widget.dropdownbutton._defaultHandler);
		},

		_defaultHandler: function(e) {
			var menu = e.data.element;
			var li = e.currentTarget;
			var text = $(li).text();
			if (menu.base.update !== 'false') {
				$(menu.base).text(text);
			}
		},

		setText: function(el, text) {
			$(el).text(text);
		},

		getText: function(el) {
			return $(el).text();
		},

		addHandler: function(el, handler) {
			$(el.dropdown).addHandler(handler);
		},

		setDataSource: function(el, data) {
			$(el.dropdown).setDataSource(data);
		},

		addData: function(el, data) {
		},

		removeData: function(el, data) {
		}

	});

})(jQuery);

(function($) {

	function FileSelector(options) {
		this.form;
		this.input;
		this.files;
		this.iframe;
		this.selected = [];
		this.options = options; // file options : multiple , success
	}

	FileSelector.prototype.addForm = function(element) {
		var iframe_id = '_iframe_' + Math.random();
		this.iframe = document.createElement('iframe');
		this.iframe.setAttribute('id', iframe_id);
		this.iframe.setAttribute('name', iframe_id);
		this.form = document.createElement('form');
		this.form.setAttribute('method', 'post');
		this.form.setAttribute('enctype', 'multipart/form-data');
		this.form.setAttribute('target', iframe_id);

		$(this.iframe).css('display', 'none');
		$(this.iframe).appendTo('body');
		$(this.form).appendTo(element);
		$(element).css('overflow', 'hidden');
	};

	FileSelector.prototype.addInput = function() {
		if(this.input) {
			this.selected.push(this.input);
		}
		// 기존 input이 있을 경우,
		$(this.input).css({
			height: '0px',
			width: '0px'
		});

		this.input = document.createElement('input');
		this.input.setAttribute('type', 'file');
		this.input.setAttribute('name', 'file');

		if (this.options.multiple) {
			this.input.setAttribute('multiple', true);
		}
		$(this.input).css({
			display: 'block',
			top: 0,
			right: 0,
			height: '100%',
			width: '100%',
			'font-size': '1000px'
		});
		$(this.input).css({
			position: 'absolute',
			right: '0px',
			top: '0px',
			height: '40px',
			width: '200px',
			opacity: 0
		});

		var that = this;
		$(this.input).on('change', function(e) {
			if (e.target.files) { // file api가 있는경우, IE는 10+
				that.files = e.target.files;
			} else {
				that.files = [{
					name: e.target.value
				}];
			}
			if (that.options.success) {
				that.options.success.apply(this, [that]);
			}
		});
		$(this.input).appendTo(this.form);
	};

	FileSelector.prototype.upload = function(options) {
		if (this.isDesktop) { // PC
			__ALOG('uplaod === ', this);
			this.form.action = options.url;
			var $inputs = $(this.form).find('input[type="file"]');
			$(this.form).trigger('submit');
		} else {

		}
	};

	FileSelector.prototype.removeSelected = function(filename) {
		for(var i=0; i<this.selected.length; i++) {
			if(this.selected[i].value == filename) {
				$(this.selected[i]).remove();
				this.selected.splice(i, 1);
				break;
			}
		}
	};
	
	$.fn.fileselect = function(options) {
		var element = this[0];
		var file = new FileSelector(options);
		file.addForm(element);
		file.addInput();
		return file;
	}

})(jQuery);

// constructor : markup, style, init, event, defer: timing issue에 사용.
(function($) {
  
  /*********************************************************************************************************
   * group
   *********************************************************************************************************/
  $.alopex.widget.group = $.alopex.inherit($.alopex.widget.object, {
    widgetName: 'group',
    defaultClassName: 'af-group af-horizontal',
    setters: ['group', 'setOrient'],
    getters: [],
    
    init: function(el) {
      var $el = $(el);
      if ($.alopex.util.isValid($el.attr('data-orient'))) {
        el.orient = $el.attr('data-orient');
        if (el.orient === 'vertical') {
          $(el).removeClass('af-horizontal');
          
          $(el).addClass('af-vertical');
        }
      }
      
      var inputs = $el.find('input');
      if(inputs.length < 1) {
        return ;
      }
      
      if(inputs[0].type === 'radio' || inputs[0].type === 'checkbox') {
        $(el).on('change', this._changeEventHandler);
      }
      $(el).trigger('change');
    },
    
    _changeEventHandler: function(e) {
      var $inputs = $(e.currentTarget).find('input');
      $inputs.each(function() {
        var $label;
        if(this.id) {
          $label = $('label[for="' + this.id + '"]');
        } else {
          $label = $(this).parent('label');
        }
        if($(this).is(':checked')) {
          $label.addClass('af-checked');
        } else {
          $label.removeClass('af-checked');
        }
      });
    },
    
    setOrient: function(el, orientation) {
      $(el).removeClass('af-horizontal');
      $(el).removeClass('af-vertical');
      
      $(el).addClass('af-'+orientation);
    }
  });
})(jQuery);
(function($) {

	/*********************************************************************************************************
	 * button
	 *********************************************************************************************************/
	$.alopex.widget.groupbutton = $.alopex.inherit($.alopex.widget.group, {
		widgetName: 'groupbutton',
		defaultClassName: 'af-groupbutton af-horizontal',
		setters: ['groupbutton'],
		getters: [],
		
		init: function(el) {
		}
	});

})(jQuery);


(function($) {

	$.alopex.widget.icon = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'icon',
		defaultClassName: 'af-icon',

		setters: ['icon', 'setIcon'],

		setIcon: function(el, icon) {
			$(el).addClass(icon);
		},

		properties: {
			position: 'default',
			size: 14
		},

		init: function(el, options) {
			var $el = $(el);
			if ($.alopex.util.isValid(el.display)) {
				$(el).css('display', el.display);
			} else {
				$(el).css('display', 'inline-block');
			}
			var $parent = $(el.parentNode);
			if($parent.attr('class') && $parent.attr('class').indexOf('button') != -1) { // button 클래스 하위에 적용. // alopex component만 적용?? TODO 추후 결정.
				$el.css('position', 'absolute');
				
				var position = this._getProperty(el, 'position');
				var size = this._getProperty(el, 'size');
				switch (position) {
				case 'top':
					$el.css({
						'top': '10px',
						'left': '50%',
						'margin-left': '-' + parseInt(size, 10) / 2 + 'px'
					});
					$parent.prepend($el);
					$parent.addClass('af-icon-top');
					$parent.css({
						'padding-top': (parseInt(size, 10) * 5 / 4) + 'px'
					});
					break;
				case 'bottom':
					$el.css({
						'bottom': '10px',
						'left': '50%',
						'margin-left': '-' + parseInt(size, 10) / 2 + 'px'
					});
					$parent.append($el);
					$parent.addClass('af-icon-bottom');
					$parent.css({
						'padding-bottom': (parseInt(size, 10) * 5 / 4) + 'px'
					});
					break;
				case 'right':
					$el.css({
						'right': '10px',
						'top': '50%',
						'margin-top': '-' + parseInt(size, 10) / 2 + 'px'
					});
					$parent.append($el);
					$parent.addClass('af-icon-right');
					$parent.css({
						'padding-right': (20 + parseInt(size, 10) * 5 / 4) + 'px'
					});
					break;
				case 'left':
					/*falls through*/
				default:
					$el.css({
						'left': '10px',
						'top': '50%',
						'margin-top': '-' + parseInt(size, 10) / 2 + 'px'
					});
					$parent.prepend($el);
					$parent.addClass('af-icon-left');
					$parent.css('padding-left', (20 + parseInt(size, 10) * 5 / 4) + 'px');
					break;
				}
			}
		}
	});

})(jQuery);
(function($) {

	$.alopex.widget.list = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'list',
		defaultClassName: 'af-list',
    setters: ['list', 'refresh'],
    
		eventHandlers: {
			hover: {
				event: 'mouseover',
				handler: ''
			}
		},

		event: function(el) {
			this.addHoverHighlight(el, 'li');
			this.addPressHighlight(el, 'li');
		},

		init: function(el) {
			this.refresh.call(this, el);
		},

		refresh: function(el) {
			var i, j;
			var that = this;
			$(el).find('>li').each(function() {
				var row = this;
				if ($(row).attr('data-converted') === 'true') {
					return;
				}

				$(row).bind('singletap', function(e) {
					var target = e.currentTarget;
					$(target).siblings('li').removeClass('af-pressed');
					$(target).addClass('af-pressed');
				});

				if ($(row).attr('data-type') === 'divider') {
					$(row).addClass('af-list-divider');
				} else {
					$(row).addClass('af-list-row');
				}

				// 이미지(thumbnail 처리)
				var img;
				if ($(row).find('img').length === 1) {
					img = $(row).find('img')[0];
					$(img).addClass('af-list-thumbnail');
					if ($.alopex.util.parseBoolean($(img).attr('data-icon'))) {
						//						$(img).addClass('af-list-thumbnail-icon');
					} else {

					}
				}

				// Title
				$(row).find('h1, h2, h3').each(function() {
					$(this).addClass('af-list-title');
				});

				//				var icon = $(row).find('[data-icon]');
				//				if (icon.length > 0) {
				//					icon.each(function() {
				//						$(this).addClass('af-list-icon af-list-icon-' + $(this).attr('data-icon'));
				//					});
				//				}

				var btn = $(row).find('a');
				if (btn.length > 0) {
					that.addHoverHighlight(row);
					that.addPressHighlight(row);
				}
				if (btn.length === 1) {
					$(btn[0]).addClass('af-list-btn');
				} else if (btn.length === 2) {
					$(btn[0]).addClass('af-list-btn first');
					$(btn[1]).addClass('af-list-btn split');
					that.addHoverHighlight(btn[1]);
					that.addPressHighlight(btn[1]);
				}

				// accordian code
				if (row.getAttribute('data-id')) {
					row.className += ' af-accordion';
					var accordianId = row.getAttribute('data-id');
					$(el).find('#' + accordianId).css('display', 'none');
					$(row).bind('click', function(e) {
						var row = e.currentTarget;
						that.toggle(row);
					});
				}

				//				var rowHeight = row.offsetHeight;
				//				var textblock = document.createElement('div'); // text 영역 wrapper.
				//				$(textblock).attr('class', 'af-list-text');
				//				var children;
				//				if (img) {
				//					var siblings = img.parentNode.childNodes;
				//					for (j = 0; j < siblings.length;) {
				//						if (siblings[j] === img) {
				//							j++;
				//							return;
				//						}
				//						$(siblings[j]).appendTo(textblock);
				//					}
				//					$(textblock).insertAfter(img);
				//				} else if (btn && btn.length > 0) {
				//					children = btn[0].childNodes;
				//					for (j = 0; j < children.length; j) {
				//						$(children[j]).appendTo(textblock);
				//					}
				//					$(textblock).appendTo(btn[0]);
				//				} else {
				//					children = row.childNodes;
				//					for (j = 0; j < children.length; j) {
				//						$(children[j]).appendTo(textblock);
				//					}
				//					$(textblock).appendTo(row);
				//				}
				$(row).attr('data-converted', 'true');
			});
		}

	});

})(jQuery);
//(function($) {
//	if ($.alopex.widget.navigationbar) {
//		return;
//	}
//	$.alopex.widget.navigationbar = {
//		navigationbar: function() {
//			var el = this;
//			$(el).css('position', 'fixed');
//			if ($(el.parentNode).find('[data-type="page"]').length > 0) {
//				el.page = $(el.parentNode).find('[data-type="page"]')[0];
//				$(el.page).css('transform', 'translateX(0px)');
//				$(el.page).css('transition', 'all 0.2s ease-in-out');
//			}
//		},
//
//		showNaviBar: function() {
//			var el = this;
//			if ($.alopex.util.isValid(el.page)) {
//				$(el.page).css('transform', 'translateX(240px)');
//			}
//		},
//
//		dismissNaviBar: function() {
//			var el = this;
//			if ($.alopex.util.isValid(el.page)) {
//				$(el.page).css('transform', 'translateX(0px)');
//			}
//		}
//	};
//
//	$.alopex.chainapi.push('dismissNaviBar');
//})(jQuery);

(function($) {

	$.alopex.widget.navmenu = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'navmenu',
		defaultClassName: 'af-navmenu',
		setters: ['navmenu'],
		getters: [],
		
		properties: {},

		init: function(el) {
			var that = this;
			el.eventState = 'init';
			$(el).find('ul').addClass('af-navmenu-sub').css('display', 'none');
			$(el).find('li').each(function() {
				var li = this;
				for ( var i = 0; i < li.children.length; i++) {
					if (li.children[i].tagName.toLowerCase() === 'ul') {
						// li button화 하여 focus가게 하기.
						that.addHoverHighlight(li);
						that.addPressHighlight(li);

						$(li).addClass('af-expandable');
						$(li).append($(document.createElement('span')).addClass('af-navmenu-icon')[0]);
						break;
					}
				}
			});
			$(el).bind('dragstart selectstart', function(e) {
				return false;
			});
			$.alopex.widget.navmenu.resizeHandler();
			$(window).bind('resize', $.alopex.widget.navmenu.resizeHandler);
		},
		
		

		_setTabIndex: function(el) {
			var i;
			if (el && el.children) {
				var liButtons = el.children;
				for (i = 0; i < liButtons.length; i++) {
					if (i === 0) {
						$(liButtons[i]).attr('tabindex', '0');
					} else {
						$(liButtons[i]).attr('tabindex', '-1');
					}
				}
			}

			if ($(el).children().length > 0) {
				for (i = 0; i < $(el).children().length; i++) {
					$($(el).children()[i]).find('li').attr('tabindex', -1);
				}
			}
		},

		setDataSource: function(el, jsonArray) {
			$(el).empty();
			//var ul = $('<ul></ul>').appendTo(el)[0];
			$.alopex.widget.navmenu._createNode(el, jsonArray);
			el.phase = undefined;
			$(el).navmenu();
		},

		_createNode: function(el, jsonArray) {
			for ( var i = 0; i < jsonArray.length; i++) {
				var item = jsonArray[i];
				var li = $('<li></li>').appendTo(el)[0];
				if ($.alopex.util.isValid(item.id)) {
					$(li).attr('data-id', item.id);
				}
				var a = $('<a></a>').appendTo(li)[0];
				if ($.alopex.util.isValid(item.linkUrl)) {
					$(a).attr('href', item.linkUrl);
				}
				if ($.alopex.util.isValid(item.iconUrl)) {
					$('<img/>').attr('src', item.iconUrl).appendTo(li);
				}
				//        $('<span></span>').html(item.text).appendTo(a);
				$(a).text(item.text);

				if ($.alopex.util.isValid(item.items)) {
					var subul = $('<ul></ul>').appendTo(li)[0];
					$.alopex.widget.navmenu._createNode(subul, item.items);
				}
			}
		},

		resizeHandler: function() {
			var menus = $('ul[data-type="navmenu"]');
			var clientWidth = document.documentElement.clientWidth;
			if (clientWidth <= 600) { // mobile
				menus.removeClass('af-desktop').addClass('af-mobile').each(function() {
					$.alopex.widget.navmenu.removeMobileEvent(this);
					$.alopex.widget.navmenu.removeDesktopEvent(this);
					$.alopex.widget.navmenu.addMobileEvent(this);
				});

			} else {
				menus.addClass('af-desktop').removeClass('af-mobile').each(function() {
					$.alopex.widget.navmenu.removeMobileEvent(this);
					$.alopex.widget.navmenu.removeDesktopEvent(this);
					$.alopex.widget.navmenu.addDesktopEvent(this);
				});
			}
			menus.find('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
		},

		addDesktopEvent: function(el) {
			var tempEl = el;

			$(el).bind('keydown', function(e) {
				var target = e.target;

				var code = (e.keyCode ? e.keyCode : e.which);
				switch (code) {
				case 27: // ESC
					var parentNav = $(target).closest('ul');

					while ($(parentNav).attr('data-type') !== 'navmenu') {
						parentNav.find('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
						parentNav = $(parentNav.parent()).closest('ul');
					}
					$(parentNav.find('[class~=af-navmenu-expand]').find('> a')).focus();
					parentNav.find('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					break;
				default:
					return;
				}
				e.stopPropagation();
				e.preventDefault();
			});

			$(el).bind('focusin', function(e) {
				var target = e.target;
				var parentNav = $(target).closest('ul');
				var li;
				if (parentNav !== undefined && parentNav[0] === tempEl) {
					li = $(target).closest('li')[0];
					if ($(li).attr('class') !== undefined && $(li).attr('class').indexOf('af-expandable') !== -1) {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
						$(li).addClass('af-navmenu-expand').find('> ul').css('display', 'inline-block');
					} else {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					}
				} else {
					//$(tempEl).find('li').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					li = $(target).closest('li')[0];
					if ($(li).attr('class') !== undefined && $(li).attr('class').indexOf('af-expandable') !== -1) {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
						$(li).addClass('af-navmenu-expand').find('> ul').css('display', 'inline-block');
					} else {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					}
				}
			});

			$(el).focusout(function(e) {
				var target = e.target;
				var parentNav = $(target).closest('ul');
				var isParent = false;
				if (target !== undefined && $(parentNav).attr('class') !== undefined && $(parentNav).attr('class').indexOf('af-navmenu') !== -1) {
					isParent = false;
				} else {
					isParent = true;
				}

				if (isParent && parentNav[0] !== tempEl) {
					$(tempEl).find('li').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
				}
			});

			$(el).bind('mouseleave', function(e) { // hoverend to mousemove
				var target = e.target;
				var parentNav = $(target).closest('ul');

				while ($(parentNav).attr('data-type') !== 'navmenu') {
					parentNav.find('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					parentNav = $(parentNav.parent()).closest('ul');
				}
				parentNav.find('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
			});

			$(el).bind('mousemove', function(e) { // hoverend to mousemove
				var target = e.target;
				var parentNav = $(target).closest('ul');
				var li;
				if (parentNav !== undefined && parentNav[0] === tempEl) {
					li = $(target).closest('li')[0];
					if ($(li).attr('class') !== undefined && $(li).attr('class').indexOf('af-expandable') !== -1) {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
						$(li).addClass('af-navmenu-expand').find('> ul').css('display', 'inline-block');
					} else {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					}
				} else {
					//$(tempEl).find('li').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					li = $(target).closest('li')[0];
					if ($(li).attr('class') !== undefined && $(li).attr('class').indexOf('af-expandable') !== -1) {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
						$(li).addClass('af-navmenu-expand').find('> ul').css('display', 'inline-block');
					} else {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					}
				}
			});
		},

		removeDesktopEvent: function(el) {
			$(el).unbind('tap').unbind('keydown');
		},

		addMobileEvent: function(el) {
			var tempEl = el;
			$(el).find('li').bind('tap', function(e) {
				var target = e.target;
				var parentNav = $(target).closest('ul');
				var li;
				if (parentNav !== undefined && parentNav[0] === tempEl) {
					li = $(target).closest('li')[0];
					if ($(li).attr('class') !== undefined && $(li).attr('class').indexOf('af-expandable') !== -1) {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
						$(li).addClass('af-navmenu-expand').find('> ul').css('display', 'inline-block');
					} else {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					}
				} else {
					//$(tempEl).find('li').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					li = $(target).closest('li')[0];
					if ($(li).attr('class') !== undefined && $(li).attr('class').indexOf('af-expandable') !== -1) {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
						$(li).addClass('af-navmenu-expand').find('> ul').css('display', 'inline-block');
					} else {
						$(li).siblings('[class~=af-navmenu-expand]').removeClass('af-navmenu-expand').find('> ul').css('display', 'none');
					}
				}
			});
		},

		removeMobileEvent: function(el) {
			$(el).find('li').unbind('tap');
		}
	});

})(jQuery);



(function($) {
  if(window['AlopexOverlay']) {
    return ;
  }
  var defaultOverlayOption = {
      bgColor  : '#fff',
      duration : 0,
      durationOff : 200,
      opacity  : 0.7,
      progress : false,
      createProgress : null,
      resizeProgress : null,
      removeProgress : null,
      appendIn : false,
      complete : null
  };
  
//해당 element에 맞는 크기의 overlay용 div를 만들어서 리턴한다.
  var AlopexOverlay = function(elem, option){
    if(!elem) {
      return null;
    }
    this.option = $.extend({}, defaultOverlayOption, option);
    if(elem === document || elem === document.body) {
      this.option.appendIn = true;
    }
    this.target = elem === document ? document.body : elem;
    this.overlay = null;
    this.ptimer = null;
    this.progress = null;
    this.on = false;
    
    this.init = function(complete) {
      this.remove();
      this.on = true;
      var css = {};
      var jelem = $(this.target);
      if(jQuery.support.opacity) {
         css['opacity'] = this.option.opacity;
      } else {
        css['filter'] = 'Alpha(opacity=' + (this.option.opacity * 100) + ')';
      }
      css['background-color'] = this.option.bgColor;
      css['z-index'] = 99990;
      css['position'] = 'absolute';
      css['border-radius'] = jelem.css('border-radius');
      css = $.extend(css, this.generateSize());
      
      this.overlay = $('<div></div>').css(css).addClass('alopex_overlay')[0];
      var cfunc = complete || this.option.complete;
      jelem[this.option.appendIn ? 'append' : 'after']( $(this.overlay).fadeIn(
          this.option.duration,
          function() {
            if(typeof cfunc === 'function') {
              cfunc();
            }
          }) );
      if(this.option.progress) {
        if(typeof this.option.createProgress === 'function') {
          //내부 함수에서는 this.target과 this.overlay를 가지고 제어를 할 수 있게 된다.
          //custom progress는 생성한 progress element의 root를 리턴한다. 
          //타이머 사용시 this.ptimer를 사용하도록 한다. 
          //생성한 프로그레스 element는 alopex_progress클래스를 가지도록 한다.
          this.option.createProgress.call(this);
        }
      }
      return this;
    };
    this.extendOption = function(option) {
      if(option) {
        this.option = $.extend({}, this.option, option);
      }
    };
    this.generateSize = function() {
      var css = {};
      var jelem = $(this.target);
      if(this.target === document || this.target === document.body) {
        this.target = document.body;
        jelem = $(document.body);
        css['width'] = css['height'] = '100%';
        css['top'] = css['left'] = 0;
        css['position'] = 'fixed';
      } else if(jelem.css('position') === 'relative' && this.option.appendIn) {
        css['width'] = css['height'] = '100%';
        css['top'] = css['left'] = 0;
      } else {
        var relparent = false;
        $(this.target).parents().each(function(i,el) {
          if($(this).css('position') === 'relative') {
            relparent = true;
          }
        });
        if(relparent) {
          var poffset = $(this.target.parentElement).offset();
          css['width'] = jelem.outerWidth();
          css['height'] = jelem.outerHeight();
          css['top'] = jelem.offset().top - poffset.top;
          css['left'] = jelem.offset().left - poffset.left;
        } else {
          css['width'] = jelem.outerWidth();
          css['height'] = jelem.outerHeight();
          css['top'] = jelem.offset().top;
          css['left'] = jelem.offset().left;
        }
      }
      return css;
    };
    this.resize = function() {
      //this.overlay.animate(this.generateSize());
      $(this.overlay).css(this.generateSize());
      if(this.option.progress) {
        if(typeof this.option.resizeProgress === 'function') {
          this.option.resizeProgress.call(this);
        }
      }
      return this;
    };
    this.remove = function(complete) {
      var dur = this.option.durationOff;
      this.on = false;
      if(typeof this.option.removeProgress === 'function') {
        this.option.removeProgress.call(this);
      }
      $(this.target).find('.alopex_progress').remove();
      $(this.target).find('.alopex_overlay').add(this.overlay)
      .fadeOut(dur, function() {
        if(typeof complete === 'function') {
          complete();
        }
        $(this).remove();
      });
      return this;
    };
    this.init();
  };
  
  AlopexOverlay.defaultOption = defaultOverlayOption;
  
  var defaultOverlayProgress = function() {
    var dur = this.option.duration;
    var pcss = {
      position:'absolute',
      margin:'0 auto',
      //overflow:'hidden',
      display:'inline-block',
      '*display':'inline',
      zoom:1,
      'text-align':'center',
      'z-index':99991
    };
    var bcss = {
      display:'block',
      float:'left',
      width:'12px',
      height:'12px',
      margin:'4px',
      'border-radius':'3px'
    };
    var p = this.progress = $('<div></div>').css(pcss)
      .addClass('alopex_progress');
    var b = [];
    var blocknum = 3;
    for(var i=0; i<blocknum; i++) {
      b.push($('<div></div>').css(bcss).addClass('alopex_progress_block'));
      p.append(b[i]);
    }
    //this.progress.insertAfter(this.overlay);
    this.progress.fadeIn(dur).insertAfter(this.overlay);
    p.css('left', this.generateSize().left + $(this.overlay).innerWidth()/2 - p.width()/2);
    p.css('top', this.generateSize().top + $(this.overlay).innerHeight()/2 - p.height()/2);
    var pcolor = ['#68838B', '#BFEFFF', '#BFEFFF'];
    var intervalFunc = function() {
      for(var i=0; i<b.length; i++) {
        b[i].css('background-color', pcolor[i]);
      }
      pcolor.unshift(pcolor.pop());
    };
    intervalFunc();
    this.ptimer = setInterval(intervalFunc,150);
    return p;
  };
  var defaultOverlayProgressResize = function() {
    var p = this.progress, size = this.generateSize();
    p.css('left', size.left + $(this.overlay).innerWidth()/2 - p.width()/2);
    p.css('top', size.top + $(this.overlay).innerHeight()/2 - p.height()/2);
  };
  var defaultOverlayProgressRemove = function() {
    var dur = this.option.durationOff;
    var that = this;
    if(this.progress) {
      $(this.progress).fadeOut(dur, function() {
        if(that.ptimer) {
          clearInterval(that.ptimer);
          that.ptimer = null;
        }
        $(that.progress).remove();
        that.progress = null;
      });
    }
  };
  
  defaultOverlayOption['createProgress'] = defaultOverlayProgress;
  defaultOverlayOption['resizeProgress'] = defaultOverlayProgressResize;
  defaultOverlayOption['removeProgress'] = defaultOverlayProgressRemove;
  defaultOverlayOption['stepProgress'] = null;
  
  window['AlopexOverlay'] = AlopexOverlay;
  $.each(['progress', 'overlay'], function(i,v) {
    $.fn[v] = function(op) {
      if(!this.length) {
        return;
      }
      var overlay = $(this[0]).data('alopexOverlay');
      var option = $.extend({progress:(v==='progress')}, op);
      if(!overlay || !overlay.on) {
        overlay = new AlopexOverlay(this[0], option);
        $(this[0]).removeData('alopexOverlay');
        $(this[0]).data('alopexOverlay', overlay);
      }
      overlay.extendOption(op);
      return overlay;
    };
  });
  
})(jQuery);


//(function($) {
//	if ($.alopex.widget.pager) {
//		return;
//	}
//	$.alopex.widget.pager = {
//		defaultOptions: {},
//		pager: function(options) {
//			var el = this;
//			var $el = $(el);
//			$.alopex.widget.object.addDefaultStyleClass(el, 'af-pager');
//
//			$.extend(el, {
//				pages: null,
//				nextbutton: $el.find('[data-dest*="next"]').eq(0),
//				selectedPage: null,
//				pagingType: null,
//				maxpage: 10,
//				totalpage: 10,
//				startpage: 1,
//				endpage: 10
//			}, options);
//
//			// data-_generateLink : 이 플래그 있을 시 page 링크 자동 추가.
//			el.pagingType = $el.attr('data-generateLink');
//			if (el.pagingType) {
//				$.alopex.widget.pager._generateLink(el);
//			}
//
//			el.pages = $(el).find('a:not([data-dest])');
//			for (i = 0; i < el.pages.length; i++) {
//				el.pages[i].page = i + 1;
//				el.pages[i].index = i;
//				el.pages[i].container = el;
//				$.alopex.widget.object.addDefaultStyleClass(el.pages[i], 'af-pager-link');
//			}
//
//			if ($el.attr('data-maxpage')) {
//				el.maxpage = parseInt($el.attr('data-maxpage'), 10);
//				$(el).attr('data-maxpage', el.maxpage);
//			}
//
//			if ($el.attr('data-totalpage')) {
//				el.totalpage = parseInt($el.attr('data-totalpage'), 10);
//				$(el).attr('data-totalpage', el.totalpage);
//			}
//
//		},
//
//		followup: function(options) {
//			var el = this;
//			var $el = $(el);
//
//			var $obj = $.alopex.widget.object;
//			$el.bind('selectstart', function(e) {
//				return false;
//			});
//			$.alopex.widget.pager._addEventHandler(el);
//			var selectedPgae = ($el.attr('data-selected') !== undefined) ? $el.attr('data-selected') : 1;
//			$.alopex.widget.pager.setSelectedPage.apply(el, [selectedPgae, true]);
//
//		},
//
//		_first: function(e) {
//			var el = e.currentTarget.element;
//			if (el.selectedPage !== 1) {
//				var targetpage = el.selectedPage - 1;
//				p
//				$.alopex.widget.pager.setSelectedPage.apply(el, [targetpage]);
//				$(el).trigger('pagechange', [targetpage]);
//			}
//		},
//
//		_prev: function(e) {
//			var el = e.currentTarget.element;
//			if (el.selectedPage !== 1) {
//				var targetpage = el.selectedPage - 1;
//				$.alopex.widget.pager.setSelectedPage.apply(el, [targetpage]);
//				$(el).trigger('pagechange', [targetpage]);
//			}
//		},
//
//		_prevgroup: function(e) {
//			var el = e.currentTarget.element;
//			var targetpage;
//			if (el.startpage !== 1) {
//				targetpage = el.startpage - el.maxpage;
//			} else {
//				targetpage = 1;
//			}
//			$.alopex.widget.pager.setSelectedPage.apply(el, [targetpage]);
//			$(el).trigger('pagechange', [targetpage]);
//		},
//
//		_next: function(e) {
//			var el = e.currentTarget.element;
//			if (el.selectedPage !== el.totalpage) {
//				var targetpage = el.selectedPage + 1;
//				$.alopex.widget.pager.setSelectedPage.apply(el, [targetpage]);
//				$(el).trigger('pagechange', [targetpage]);
//			}
//		},
//
//		_nextgroup: function(e) {
//			var el = e.currentTarget.element;
//			var targetpage;
//			if (el.endpage !== el.totalpage) {
//				targetpage = el.startpage + el.maxpage;
//			} else {
//				targetpage = el.totalpage;
//			}
//			$.alopex.widget.pager.setSelectedPage.apply(el, [targetpage]);
//			$(el).trigger('pagechange', [targetpage]);
//		},
//
//		_addEventHandler: function(el) {
//			var $el = $(el);
//			var $obj = $.alopex.widget.object;
//			$(el.pages).each(function() {
//				$(this).bind('tap', function(e) {
//					var alink = e.currentTarget;
//					$.alopex.widget.pager.setSelectedPage.apply(alink.container, [alink.page]);
//					var el = $(alink).closest('[data-type="pager"]');
//					$(el).trigger('pagechange', [alink.page]);
//				});
//			});
//			// 이동 버튼 관련 코드.
//			var buttons = $el.find('[data-dest]');
//			var handler = null;
//			for ( var i = 0; i < buttons.length; i++) {
//				var dest = $(buttons[i]).attr('data-dest');
//				buttons[i].element = el;
//				switch (dest) {
//				case 'first-page':
//					$obj.addDefaultStyleClass(buttons[i], 'af-pager-prev');
//					handler = $.alopex.widget.pager._first;
//					break;
//				case 'previous':
//				case 'prev':
//					$obj.addDefaultStyleClass(buttons[i], 'af-pager-prev');
//					handler = $.alopex.widget.pager._prev;
//					break;
//				case 'previouspages':
//				case 'prev-group':
//					$obj.addDefaultStyleClass(buttons[i], 'af-pager-prevgroup');
//					handler = $.alopex.widget.pager._prevgroup;
//					break;
//				case 'next':
//					$obj.addDefaultStyleClass(buttons[i], 'af-pager-next');
//					handler = $.alopex.widget.pager._next;
//					break;
//				case 'nextpages':
//				case 'next-group':
//					$obj.addDefaultStyleClass(buttons[i], 'af-pager-nextgroup');
//					handler = $.alopex.widget.pager._nextgroup;
//					break;
//
//				case 'last-page':
//					break;
//				}
//				$(buttons[i]).attr('data-type', 'button').button().bind('tap', handler);
//			}
//		},
//
//		_removeLink: function(el) {
//			for ( var i = 0; i < el.pages.length; i++) {
//				if (el.tagName.toLowerCase() === 'ul') { // NH custom
//					$(el.pages).parents('li').remove();
//				} else {
//					$(el.pages).remove();
//				}
//			}
//
//		},
//
//		_generateLink: function(el) {
//			var i;
//			if ($(el).find('a:not([data-dest])').length === 0) {
//				for (i = 0; i < el.maxpage; i++) {
//					var alink = document.createElement('a');
//					if (el.pagingType !== 'mobile') {
//						alink.innerHTML = i + 1 + '';
//					}
//
//					if (el.tagName.toLowerCase() === 'ul') { // NH custom
//						var li = document.createElement('li');
//						$(alink).appendTo(li);
//						$(li).css('display', 'none');
//						if (el.nextbutton.length > 0) {
//							$(li).insertBefore($(el.nextbutton).parents('li'));
//						} else {
//							$(li).appendTo(el);
//						}
//					} else {
//						$(alink).css('display', 'none');
//						if (el.nextbutton.length > 0) {
//							$(alink).insertBefore(el.nextbutton);
//						} else {
//							$(alink).appendTo(el);
//						}
//					}
//				}
//			}
//
//		},
//
//		/**
//		 * 페이지 indicator 내에 페이지 정보 수정.
//		 * @param {integer} page 페이지 그룹 내에 들어갈 특정 페이지.
//		 */
//		_changePageGroup: function(el, page) {
//			el.startpage = 1;
//			el.endpage = el.maxpage;
//			while (page > el.endpage) {
//				el.startpage += el.maxpage;
//				el.endpage += el.maxpage;
//			}
//			if (el.endpage > el.totalpage) {
//				el.endpage = el.totalpage;
//			}
//			for ( var i = 0; i < el.pages.length; i++) {
//				if (el.startpage + i <= el.totalpage) {
//					if (el.tagName.toLowerCase() === 'ul') { // NH custom
//						$(el.pages[i]).parents('li').css('display', '');
//					} else {
//						$(el.pages[i]).css('display', '');
//					}
//
//					el.pages[i].page = el.startpage + i;
//					if (el.pagingType !== 'mobile') {
//						el.pages[i].innerHTML = el.startpage + i;
//					}
//				} else {
//					if (el.tagName.toLowerCase() === 'ul') { // NH custom
//						$(el.pages[i]).parents('li').css('display', 'none');
//					} else {
//						$(el.pages[i]).css('display', 'none');
//					}
//					el.pages[i].page = NaN;
//				}
//			}
//		},
//
//		_enableAllButton: function(el) {
//			$(el).find('[data-dest]').setEnabled(true);
//			$(el).find('[data-dest]').css('visibility', 'visible');
//		},
//
//		_disableButton: function(el, btnType) {
//			var $button = $(el).find('[data-dest="' + btnType + '"]');
//			if ($(el).attr('data-button-behavior') === 'disable') {
//				$button.setEnabled(false);
//				__ALOG('$button.setEnabled ==== ', $button.setEnabled)
//			} else if ($(el).attr('data-button-behavior') === 'hide') {
//				$button.css('visibility', 'hidden');
//			}
//		},
//
//		getSelectedPage: function() {
//			var el = this;
//			return el.selectedPage;
//		},
//
//		setTotalPage: function(page, destpage) {
//			var el = this;
//			page = parseInt(page, 10);
//			el.totalpage = page;
//			$(el).attr('data-totalpage', page);
//			$.alopex.widget.pager._changePageGroup(el, el.selectedPage);
//			if ($.alopex.util.isValid(destpage)) {
//				$.alopex.widget.pager.setSelectedPage.apply(el, [destpage]);
//			}
//		},
//
//		setSelectedPage: function(page) {
//			var el = this;
//			page = parseInt(page, 10);
//			$.alopex.widget.pager._changePageGroup(el, page);
//
//			var strong = $(el).find('strong');
//			if (strong.length !== 0) {
//				$(strong[0]).replaceWith(strong[0].children);
//			}
//			for ( var i = 0; i < el.pages.length; i++) {
//				el.pages[i].className = el.pages[i].className.replace('af-selected', '');
//				if (el.startpage + i === page) {
//					el.pages[i].className += ' af-selected';
//					$(el.pages[i]).wrap('<strong></strong>');
//				}
//			}
//			el.selectedPage = page;
//
//			$.alopex.widget.pager._enableAllButton(el);
//			if (el.selectedPage === 1) { // disable prev button
//				$.alopex.widget.pager._disableButton(el, 'prev');
//				$.alopex.widget.pager._disableButton(el, 'prev-group');
//			}
//			if (el.selectedPage === el.totalpage) { // disable next button
//				$.alopex.widget.pager._disableButton(el, 'next');
//			}
//			if (el.endpage === el.totalpage) { // disable next group button
//				$.alopex.widget.pager._disableButton(el, 'next-group');
//			}
//		},
//
//		setMaxPage: function(page, destpage) {
//			var el = this;
//			page = parseInt(page, 10);
//			el.maxpage = page;
//			$(el).attr('data-maxpage', page);
//			$.alopex.widget.pager._removeLink(el);
//			$.alopex.widget.pager._generateLink(el);
//			$.alopex.widget.pager._changePageGroup(el, el.selectedPage);
//			if ($.alopex.util.isValid(destpage)) {
//				$.alopex.widget.pager.setSelectedPage.apply(el, [destpage]);
//			} else {
//				$.alopex.widget.pager.setSelectedPage.apply(el, [el.selectedPage]);
//			}
//
//		}
//	};
//
//	$.alopex.chainapi.push('setTotalPage');
//	$.alopex.chainapi.push('setMaxPage');
//	$.alopex.chainapi.push('setSelectedPage');
//
//	$.alopex.getterapi.push('getSelectedPage');
//})(jQuery);

(function($) {

	/*********************************************************************************************************
	 * button
	 *********************************************************************************************************/
	$.alopex.widget.pagination = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'pagination',
		/**
		 * property 
		 */
		// class property
		defaultClassName: 'af-paging',

		setters: ['pagination', 'setTotalPage', 'setMaxPage', 'setSelectedPage'],
		getters: ['getSelectedPage'],

		// button widget common options
		widgetOptions: {

		},

		// element options
		options: {

		},

		// 엘리먼트 내 이벤트 바인딩 해야 되는 부분
		// selector가 없는 경우에는 element에 등록됨.
		eventHandlers: {
		},

		event: function(el) {
//			this.addHoverHighlight(el);
//			this.addPressHighlight(el);
		},

		init: function(el, options) {
			var $el = $(el);

			$.extend(el, {
				pages: null,
				nextbutton: $el.find('[data-dest*="next"]').eq(0),
				selectedPage: null,
				pagingType: null,
				maxpage: 10,
				totalpage: 10,
				startpage: 1,
				endpage: 10
			}, options);

			// data-_generateLink : 이 플래그 있을 시 page 링크 자동 추가.
			el.pagingType = $el.attr('data-generateLink');
			this._generateLink(el);

			el.maxpage = parseInt($el.attr('data-maxpage'), 10) | 0;
			$(el).attr('data-maxpage', el.maxpage);

			el.totalpage = ($el.attr('data-totalpage')) ? parseInt($el.attr('data-totalpage'), 10) : 0;
			$(el).attr('data-totalpage', el.totalpage);

			var selectedPgae = ($el.attr('data-selected') !== undefined) ? $el.attr('data-selected') : 1;
			this.setSelectedPage(el, selectedPgae, true);
			$el.bind('selectstart', function(e) {
				return false;
			});
			this._addPageEventHandler(el);
			this._addButtonEventHandler(el);
		},
		
		_first: function(e) {
			var el = e.currentTarget.element;
			if (el.selectedPage !== 1) {
  			var targetpage = 1;
  			$.alopex.widget.pagination.setSelectedPage(el, targetpage);
  			$(el).trigger('pagechange', [targetpage]);
			}
		},

		_last: function(e) {
		  var el = e.currentTarget.element;
		  if (el.selectedPage !== el.totalPage) {
		    var targetpage = el.totalpage;
		    $.alopex.widget.pagination.setSelectedPage(el, targetpage);
		    $(el).trigger('pagechange', [targetpage]);
		  }
		},

		_prev: function(e) {
			var el = e.currentTarget.element;
			if (el.selectedPage !== 1) {
				var targetpage = el.selectedPage - 1;
				$.alopex.widget.pagination.setSelectedPage(el, targetpage);
				$(el).trigger('pagechange', [targetpage]);
			}
		},

		_prevgroup: function(e) {
			var el = e.currentTarget.element;
			var targetpage;
			if (el.startpage !== 1) {
				targetpage = el.startpage - el.maxpage;
			} else {
				targetpage = 1;
			}
			$.alopex.widget.pagination.setSelectedPage(el, targetpage);
			$(el).trigger('pagechange', [targetpage]);
		},

		_next: function(e) {
			var el = e.currentTarget.element;
			if (el.selectedPage !== el.totalpage) {
				var targetpage = el.selectedPage + 1;
				$.alopex.widget.pagination.setSelectedPage(el, targetpage);
				$(el).trigger('pagechange', [targetpage]);
			}
		},

		_nextgroup: function(e) {
			var el = e.currentTarget.element;
			var targetpage;
			if (el.endpage !== el.totalpage) {
				targetpage = el.startpage + el.maxpage;
			} else {
				targetpage = el.totalpage;
			}
			$.alopex.widget.pagination.setSelectedPage(el, targetpage);
			$(el).trigger('pagechange', [targetpage]);
		},

		_addPageEventHandler: function(el) {
		  var $el = $(el);
      var $obj = $.alopex.widget.object;
      __ALOG('pages === ', el.pages)
      var that = this;
      $(el.pages).on('tap', function(e) {
        var alink = e.currentTarget;
        that.setSelectedPage(alink.container, alink.page);
        var el = $(alink).closest('[data-type="pagination"]');
        $(el).trigger('pagechange', [alink.page]);
      });
		},
		
		_addButtonEventHandler: function(el) {
		  var $el = $(el);
			// 이동 버튼 관련 코드.
			var buttons = $el.find('[data-dest]');
			var handler = null;
			for ( var i = 0; i < buttons.length; i++) {
				var dest = $(buttons[i]).attr('data-dest');
				buttons[i].element = el;
				switch (dest) {
				case 'first-page':
					$(buttons[i]).addClass('af-paging-prev');
					handler = this._first;
					break;
				case 'previous':
				case 'prev':
					$(buttons[i]).addClass('af-paging-prev');
					handler = this._prev;
					break;
				case 'previouspages':
				case 'prev-group':
					$(buttons[i]).addClass('af-paging-prevgroup');
					handler = this._prevgroup;
					break;
				case 'next':
					$(buttons[i]).addClass('af-paging-next');
					handler = this._next;
					break;
				case 'nextpages':
				case 'next-group':
					$(buttons[i]).addClass('af-paging-nextgroup');
					handler = this._nextgroup;
					break;
				case 'last-page':
				  $(buttons[i]).addClass('af-paging-next');
				  handler = this._last;
					break;
				}
				$(buttons[i]).attr('data-type', 'button').button().bind('tap', handler);
			}
		},

		_removeLink: function(el) {
			for ( var i = 0; i < el.pages.length; i++) {
				if (el.tagName.toLowerCase() === 'ul') { // NH custom
					$(el.pages).parents('li').remove();
				} else {
					$(el.pages).remove();
					break;
				}
			}

		},

		_generateLink: function(el) {
			var i;
			if ($(el).find('a:not([data-dest])').length === 0) {
				for (i = 0; i < el.maxpage; i++) {
					var alink = document.createElement('a');
					if (el.pagingType !== 'mobile') {
						alink.innerHTML = i + 1 + '';
					}

					if (el.tagName.toLowerCase() === 'ul') { // NH custom
						var li = document.createElement('li');
						$(alink).appendTo(li);
						$(li).css('display', 'none');
						if (el.nextbutton.length > 0) {
							$(li).insertBefore($(el.nextbutton).parents('li'));
						} else {
							$(li).appendTo(el);
						}
					} else {
						$(alink).css('display', 'none');
						if (el.nextbutton.length > 0) {
							$(alink).insertBefore(el.nextbutton);
						} else {
							$(alink).appendTo(el);
						}
					}
				}
			}

			el.pages = $(el).find('a:not([data-dest])');
			for (i = 0; i < el.pages.length; i++) {
				el.pages[i].page = i + 1;
				el.pages[i].index = i;
				el.pages[i].container = el;
				if (el.pagingType === 'mobile') {
					$(el.pages[i]).addClass('af-paging-mobile');
				} else {
					$(el.pages[i]).addClass('af-paging-number');
				}
			}
		},

		/**
		 * 페이지 indicator 내에 페이지 정보 수정.
		 * @param {integer} page 페이지 그룹 내에 들어갈 특정 페이지.
		 */
		_changePageGroup: function(el, page) {
			el.startpage = 1;
			el.endpage = el.maxpage;
			while (page > el.endpage) {
				el.startpage += el.maxpage;
				el.endpage += el.maxpage;
			}
			if (el.endpage > el.totalpage) {
				el.endpage = el.totalpage;
			}
			for ( var i = 0; i < el.pages.length; i++) {
				if (el.startpage + i <= el.totalpage) {
					if (el.tagName.toLowerCase() === 'ul') { // NH custom
						$(el.pages[i]).parents('li').css('display', '');
					} else {
						$(el.pages[i]).css('display', '');
					}

					el.pages[i].page = el.startpage + i;
					if (el.pagingType !== 'mobile') {
						el.pages[i].innerHTML = el.startpage + i;
					}
				} else {
					if (el.tagName.toLowerCase() === 'ul') { // NH custom
						$(el.pages[i]).parents('li').css('display', 'none');
					} else {
						$(el.pages[i]).css('display', 'none');
					}
					el.pages[i].page = NaN;
				}
			}
		},

		_enableAllButton: function(el) {
			$(el).find('[data-dest]').setEnabled(true);
			$(el).find('[data-dest]').css('visibility', 'visible');
		},

		_disableButton: function(el, btnType) {
			var $button = $(el).find('[data-dest="' + btnType + '"]');
			if ($(el).attr('data-button-behavior') === 'disable') {
				$button.setEnabled(false);
			} else {
				$button.css('visibility', 'hidden');
			}
		},

		getSelectedPage: function(el) {
			return el.selectedPage;
		},

		setTotalPage: function(el, page, destpage) {
			page = parseInt(page, 10);
			el.totalpage = page;
			$(el).attr('data-totalpage', page);
			if (el.selectedPage > page) {
			  el.selectedPage = page;
			}
			//this._changePageGroup(el, el.selectedPage);
			if ($.alopex.util.isValid(destpage)) {
				this.setSelectedPage(el, destpage);
			} else {
			  this.setSelectedPage(el, el.selectedPage);
			}
		},

		setSelectedPage: function(el, page) {
			page = parseInt(page, 10);
			this._changePageGroup(el, page);

			var strong = $(el).find('strong');
			if (strong.length !== 0) {
				$(strong[0]).replaceWith(strong[0].children);
			}
			for ( var i = 0; i < el.pages.length; i++) {
				el.pages[i].className = el.pages[i].className.replace('af-paging-selected', '');
				if (el.startpage + i === page) {
					el.pages[i].className += ' af-paging-selected';
					$(el.pages[i]).wrap('<strong></strong>');
				}
			}
			el.selectedPage = page;

			this._enableAllButton(el);
			if (el.selectedPage === 1) { // disable prev button
				this._disableButton(el, 'prev');
			}
			if (el.startpage === 1) { // disable prev group button
				this._disableButton(el, 'prev-group');
			}
			if (el.selectedPage === el.totalpage) { // disable next button
				this._disableButton(el, 'next');
			}
			if (el.endpage === el.totalpage) { // disable next group button
				this._disableButton(el, 'next-group');
			}
		},

		setMaxPage: function(el, page, destpage) {
			page = parseInt(page, 10);
			el.maxpage = page;
			$(el).attr('data-maxpage', page);
			this._removeLink(el);
			this._generateLink(el);
			this._addPageEventHandler(el);
			if ($.alopex.util.isValid(destpage)) {
				this.setSelectedPage(el, destpage);
			} else {
				this.setSelectedPage(el, el.selectedPage);
			}
		}
		
	});

})(jQuery);

// constructor : markup, style, init, event, defer: timing issue에 사용.
(function($) {

	$.alopex.widget.panel = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'panel',
		defaultClassName: 'af-panel',

		setters: ['panel', 'refresh', 'scrollToElement'],
		getters: [],

		properties: {

		},

		eventHandlers: {},

		init: function(el, options) {
			var $el = $(el);
			if (el.getAttribute('data-fill') !== undefined) {
				$.alopex.widget.panel._fill(el);
			}
			if ($.alopex.util.parseBoolean(el.getAttribute('data-scroll'))) {
				this._makeScrollable(el);
			}
			$(window).bind('resize', $.alopex.widget.panel._resize);

			if ($el.attr('data-responsive') !== undefined) {
				$el.css('float', 'left').css('width', '100%');
				$(window).bind('resize', $.alopex.widget.panel._responsive);
				this._responsive();
			}
		},

		_responsive: function() {
			$('[data-responsive]').each(function() {
				var el = this;
				var width = 100;
				var parentWidth = parseFloat($(el).attr('data-responsive').split('-')[0]);
				var panelWidth = parseFloat($(el).attr('data-responsive').split('-')[1]);
				var clientWidth = document.documentElement.clientWidth;

				if (clientWidth <= $.alopex.responsive.threshold) {

				} else if (clientWidth > $.alopex.responsive.threshold && clientWidth <= 900) {
					width = panelWidth / parentWidth * 100;
				} else {
					width = panelWidth / parentWidth * 100;
				}
				$(el).css('width', width + '%');
			});
		},

		_makeScrollable: function(el) {
			try {
				//        var el = this;
				if (window.browser === 'mobile' && typeof iScroll !== 'undefined') {
					var iScrollOption = {};
					if ((/iphone|ipad/gi).test(navigator.appVersion)) {
						iScrollOption.useTransform = true;
					} else {

						if ($(el).find('input').length > 0 || $(el).find('textarea').length > 0) {
							iScrollOption.useTransform = false;
						} else {
							iScrollOption.useTransform = true;
						}
					}
					iScrollOption.onBeforeScrollStart = function(e) {
						var target = e.target;
						while (target.nodeType !== 1) {
							target = target.parentNode;
						}

						if (target.tagName !== 'SELECT' && target.tagName !== 'INPUT' && target.tagName !== 'TEXTAREA') {
							e.preventDefault();
						}
					};
					iScrollOption.checkDOMChanges = true;
					el.style.position = 'relative';
					el.scroll = new iScroll(el, iScrollOption);
					el.scroll.onScrollEnd = function(e) {
						$(el).trigger('scrollend', e);
					};
				} else {
					// For IE7.
					$(el).css('position', 'relative');
					$(el).css('overflow', 'auto');
					if (el.children.length >= 1) {
						if (el.offsetHeight < el.children[0].offsetHeight) {
							$(el).css('overflow-y', 'scroll');
						}
						if (el.offsetWidth < el.children[0].offsetWidth) {
							$(el).css('overflow-x', 'scroll');
						}
					}
				}
			} catch (e) {
				throw new Error('[makeScrollable] ' + e);
			}
		},

		scrollToElement: function(el, selector, time) {
			if (window.browser === 'mobile') {
				el.scroll.scrollToElement(selector, time);
			} else {
				if ($(el).find(selector).length > 0) {
					el.scrollTop = $(el).find(selector)[0].offsetHeight;
				}

			}
		},

		_resize: function(e) {
			$('[data-type="panel"]').refresh();
		},

		refresh: function(el) {
			if (el.getAttribute('data-fill') !== undefined) {
				$.alopex.widget.panel._fill(el);
			}
			if ($.alopex.util.parseBoolean(el.getAttribute('data-scroll'))) {
				$.alopex.widget.panel._scroll_refresh(el);
			}
		},

		_scroll_refresh: function(el) {
			if (el.scroll) {
				el.scroll.refresh();
			} else {
				$(el).css('overflow', 'auto');
				if (el.children.length >= 1) {
					if (el.offsetHeight < el.children[0].offsetHeight) {
						$(el).css('overflow-y', 'scroll');
					}
					if (el.offsetWidth < el.children[0].offsetWidth) {
						$(el).css('overflow-x', 'scroll');
					}
				}
			}
		},

		_fill: function(el) {
			var setting = el.getAttribute('data-fill');
			var tmp = el.style.display;
			el.style.display = 'none';
			switch (setting) {
				case 'vertical':
					this.fillVertical(el);
					break;
				case 'horizontal':
					this.fillHorizontal(el);
					break;
				case 'both':
					this.fillVertical(el);
					this.fillHorizontal(el);
					break;
				default:
					break;
			}
			el.style.display = tmp;
		},

		fillVertical: function(el) {
			var parentHeight = $(el.parentNode).height() - (el.parentNode.offsetHeight - el.parentNode.clientHeight);
			var siblingHeight = 0;
			var children = el.parentNode.children;
			for ( var i = 0; i < children.length; i++) {
				if (children[i] !== el) {
					// check floated element
					if (children[i].style.position !== 'absolute') {
						siblingHeight += $(children[i]).height();
						if (!isNaN(parseInt($(children[i]).css('margin-top'), 10))) {
							siblingHeight += parseInt($(children[i]).css('margin-top'), 10);
						}
						if (!isNaN(parseInt($(children[i]).css('margin-bottom'), 10))) {
							siblingHeight += parseInt($(children[i]).css('margin-bottom'), 10);
						}
					}
				}
			}

			$(el).css('height', (parentHeight - siblingHeight) + 'px');
		},

		fillHorizontal: function(el) {
			var parentWidth = $(el.parentNode).width() - (el.parentNode.offsetWidth - el.parentNode.clientWidth);
			var siblingWidth = 0;
			var children = el.parentNode.children;
			for ( var i = 0; i < children.length; i++) {
				if (children[i] !== el) {
					if (children[i].style.position !== 'absolute') {
						siblingWidth += $(children[i]).width();
						if (!isNaN(parseInt($(children[i]).css('margin-left'), 10))) {
							siblingWidth += parseInt($(children[i]).css('margin-left'), 10);
						}
						if (!isNaN(parseInt($(children[i]).css('margin-right'), 10))) {
							siblingWidth += parseInt($(children[i]).css('margin-right'), 10);
						}
					}
				}
			}
			$(el).css('width', (parentWidth - siblingWidth) + 'px');
		}
	});

})(jQuery);

// constructor : markup, style, init, event, defer: timing issue에 사용.
(function($) {

	$.alopex.widget.progressbar= $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'progressbar',
		/**
		 * property 
		 */
		// class property
		defaultClassName: 'af-progressbar',

		setters: ['progressbar', 'setValue', 'setOptions'],
		getters: ['getValue'],

		properties: {

		},

		eventHandlers: {
		},
		
		init: function(el, option) {
			var progEl = document.createElement('div');
			progEl.minValue = 0;
			progEl.maxValue = 100;
			progEl.value = 0;
			$(progEl).attr('style', 'position:relative; left:0px; top:0px; width:0px');
			el.appendChild(progEl);
			$(progEl).css('height', $(el).css('height'));
			progEl.maxWidth = $(el).css('width').split('px')[0];

			var defaultVal = $(el).attr('data-default');
			if ($.alopex.util.isValid(defaultVal)) {
				progEl.value = defaultVal;
				$(progEl).css('border', $(el).css('border'));
				$(progEl).css('width', (progEl.maxWidth * (defaultVal / progEl.maxValue)) + 'px');
			}

			var overlayEl = document.createElement('div');
			$(overlayEl).attr('style',
					'position:relative; ' + 'opacity: 0.3; filter: progid:DXImageTransform.Microsoft.Alpha(opacity=60); ' + '-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(opacity=30)";');
			$(overlayEl).css('height', $(progEl).css('height'));
			$(overlayEl).css('background-color', $(progEl).css('height'));
			progEl.appendChild(overlayEl);
		},
		
		setOptions: function(el, options) {
			var progEl = el.children[0];
			var overlayEl = progEl.children[0];

			// background color
			if ($.alopex.util.isValid(options.bgColor)) {
				$(progEl).css('background-color', options.bgColor);
			}
			if ($.alopex.util.isValid(options.bgUrl)) {
				$(progEl).css('background-image', 'url(' + options.bgUrl + ')');
			}
			if ($.alopex.util.isValid(options.overlayColor)) {
				$(overlayEl).css('background-color', options.overlayColor);
			}
			if ($.alopex.util.isValid(options.showText) && options.showText) {
				var textEl = document.createElement('span');
				$(textEl).attr('style', 'position: absolute; top: -2px;');
				$(textEl).css('height', ($(el).css('height')));
				$(textEl).css('left', ($(el).css('width').split('px')[0] / 2 - 35) + 'px');
				if ($.alopex.util.isValid(options.textArray) && options.textArray) {
					textEl.startProg = options.textArray[0];
					textEl.endProg = options.textArray[1];
					$(textEl).text(textEl.startProg);
				}

				if ($.alopex.util.isValid(options.textColor) && options.textColor) {
					$(textEl).css('color', options.textColor);
				}

				$(textEl).appendTo(progEl);
			}
		},
		setValue: function(el, value) {
			var progEl = el.children[0];
			var overlayEl = progEl.children[0];

			progEl.value = value;
			$(progEl).css('border', $(el).css('border'));
			$(progEl).css('width', (progEl.maxWidth * (value / progEl.maxValue)) + 'px');

			$(overlayEl).css('width', $(progEl).css('width'));

			var textEl = $(progEl).children('span')[0];
			if (textEl !== undefined) {
				if (value === 100) {
					$(textEl).text(textEl.endProg);
				} else if (value === 0) {
					$(textEl).text(textEl.startProg);
				} else {
					$(textEl).text(value + '%');
				}
			}
		},
		getValue: function(el) {
			var progEl = el.children[0];
			var value = progEl.value;
			if (value > progEl.maxValue) {
				value = progEl.maxValue;
			} else if (value < progEl.minValue) {
				value = progEl.minValue;
			}
			return value;
		}
	});

})(jQuery);


(function($) {
	/***************************************************************************
	 * radio
	 **************************************************************************/
	$.alopex.widget.radio = $.alopex.inherit($.alopex.widget.baseinput, {
		widgetName : 'radio',
		defaultClassName : 'af-radio',
		defaultTextClassName : 'af-radio-text',
		setters : ['radio', 'setSelected'],
		getters : ['getValue', 'getText'],

		style : function(el) {
			if (el.id) {
				$('label[for="' + el.id + '"]').addClass(this.defaultTextClassName);
			} else {
				$(el).parent('label').addClass(this.defaultTextClassName);
			}
		},

		setSelected : function(el) {
			if (el.tagName === 'INPUT') {
				el.checked = true;
			}
			$(el).trigger('change');
		},

		getValue : function(el) {
			var radioList = $('input[name=' + el.name + ']:checked');
			if (radioList.length > 0) {
				return $(radioList[0]).val();
			}
			return null;
		},

		getText : function(el) {
			var radioList = $('input[name=' + el.name + ']:checked');
			if (radioList.length > 0) {
				var obj = radioList[0];
				var elId = $(obj).attr('id');
				var el_label = $(el).parent().find('label[for="' + elId + '"]');

				return $(el_label).text();
			}
			return null;
		}
	});

})(jQuery);
//(function($) {
//	if ($.alopex.widget.scrollview) {
//		return;
//	}
//	$.alopex.widget.scrollview = {
//		scrollview: function(options) {
//			try {
//				var el = this;
//
//				$.alopex.widget.panel.refresh.apply(el);
//
//				if (window.browser === 'mobile' && typeof iScroll !== 'undefined') {
//
//					var iScrollOption = {};
//					if ((/iphone|ipad/gi).test(navigator.appVersion)) {
//						iScrollOption.useTransform = true;
//					} else {
//
//						if ($(el).find('input').length > 0 || $(el).find('textarea').length > 0) {
//							iScrollOption.useTransform = false;
//						} else {
//							iScrollOption.useTransform = true;
//						}
//					}
//					iScrollOption.onBeforeScrollStart = function(e) {
//						var target = e.target;
//						while (target.nodeType !== 1) {
//							target = target.parentNode;
//						}
//
//						if (target.tagName !== 'SELECT' && target.tagName !== 'INPUT' && target.tagName !== 'TEXTAREA') {
//							e.preventDefault();
//						}
//					};
//					iScrollOption.checkDOMChanges = true;
//					el.style.position = 'relative';
//					el.scroll = new iScroll(el, iScrollOption);
//					$(window).bind('resize', function(e) {
//						try {
//							el.scroll.refresh();
//						} catch (event) {
//							throw new Error(event);
//						}
//					});
//				} else {
//					// TO fix IE7 Bug. Without this statement,
//					// scroll content will be visible.
//					$(el).css('position', 'relative');
//					$(el).css('overflow', 'hidden');
//					if (el.children.length >= 1) {
//						if (el.offsetHeight < el.children[0].offsetHeight) {
//							$(el).css('overflow-y', 'scroll');
//						}
//						if (el.offsetWidth < el.children[0].offsetWidth) {
//							$(el).css('overflow-x', 'scroll');
//						}
//					}
//				}
//			} catch (e) {
//				throw new Error('scroll create ==== ' + e);
//			}
//		},
//
//		refresh: function() {
//			var el = this;
//			if (el.scroll) {
//				el.scroll.refresh();
//			} else {
//				if (el.offsetHeight < el.children[0].offsetHeight) {
//					$(el).css('overflow-y', 'scroll');
//				}
//				if (el.offsetWidth < el.children[0].offsetWidth) {
//					$(el).css('overflow-x', 'scroll');
//				}
//			}
//			$.alopex.widget.panel.refresh.apply(el);
//
//		}
//	};
//
//	$.alopex.chainapi.push('setEnabled');
//
//})(jQuery);

(function($) {

  /*********************************************************************************************************
   * search input
   *********************************************************************************************************/
  $.alopex.widget.searchinput = $.alopex.inherit($.alopex.widget.object, {
    widgetName: 'searchinput',
    defaultClassName: 'af-searchinput',
    defaultClearClassName: 'af-clear-button',
    setters: ['searchinput'],
    
    /**
     * markup은 ui 컴퍼넌트가 
     */
    markup: function() {
      return '<div>' +
              '<span af-dynamic class="af-icon af-default search"></span>' +
              '<input class="af-textinput af-default" />' +
              '<span af-dynamic class="af-icon af-default remove-sign"></span>' +
            '</div>';
    },
    
    properties: {
      clear: null
    },
    
    eventHandlers: {
      keydown: {event: 'keyup', handler: '_keyupHandler'},
      change: {event: 'change', handler: '_changeHandler'},
      clearclick: {event: 'click', selector: '[data-clear]', handler: '_clear'}
    },
    
    _clear: function(e) {
      
    },
    
    
    style: function(el) {
      /**
       * 하위 노드부터 스타일을 변경되어야 하는데, 이부분에서 막힘.
       * 아이콘들은 현재 알로펙스로 변경되지 않은 상태.
       * 
       */
    }
  });

})(jQuery);
(function($) {
	$.alopex.widget.select = $.alopex.inherit($.alopex.widget.baseselect, {
		widgetName: 'select',
		defaultClassName: 'af-select',
		getters: ['getValues', 'getTexts'],
		setters: ['select', 'setPlaceholder', 'setSelected', 'clear', 'refresh'],

		init: function(el) {
			var $el = $(el);
			if ($.alopex.util.parseBoolean(el.alopexoptions.wrap)) {
				$el.attr('data-type', 'divselect').divselect();
			}
			if ($el.attr('data-select-multiple') == 'true') {
				$el.attr('multiple', 'multiple');
				defaultStyleClass = 'af-multiselect';
				$el.bind('selectstart click', function(e) {
					return false;
				});
			}
		}
	});
})(jQuery);
(function($) {
  
  
})(jQuery);
(function($) {

	$.alopex.widget.spinner = $.alopex.inherit($.alopex.widget.baseinput, {
		widgetName: 'spinner',
		defaultClassName: 'af-spinner',
		setters: ['spinner', 'setEnabled'],
		getters: [],
		
		properties: {
			min: 'default',
			max: 'default',
			step: 1
		},

		init: function(el, options) {
			var $el = $(el);
			el.type = 'text';
			
			$(el).wrap('<div class="' + el.className + ' af-spinner-wrapper"></div>');
			var wrapper = el.parentNode;
			$wrapper = $(wrapper);
//			$wrapper.append(el);
			$wrapper.append('<a class="af-spinner-button-up"></a>');
			$wrapper.append('<a class="af-spinner-button-down"></a>');
			
			var $wrapper = $el.closest('.af-spinner-wrapper');
			var $up = $el.siblings('.af-spinner-button-up');
			var $down = $el.siblings('.af-spinner-button-down');
			
			$.extend(el, $.alopex.widget.spinner.properties, options);
			$up.on('tap', $.alopex.widget.spinner._upHandler);
			$down.on('tap', $.alopex.widget.spinner._downHandler);
			$el.on('keydown', $.alopex.widget.spinner._keydownHandler);
//			$el.on('keyup', $.alopex.widget.spinner._keyupHandler);
			$wrapper.css({
				position: 'relative',
				display: 'inline-block'
			});
			$up.add($down).css({
				position:'absolute',
				display:'block',
				height:'50%',
				width:'15px',
				right:'0'
			});
			$up.css({
				top:'0'
			});
			$down.css({
				bottom:'0'
			});
			
			$up.data('element', el);
			$down.data('element', el);
		},
		
		_upHandler: function(e){
			var el = $(e.currentTarget).data('element');
			$.alopex.widget.spinner.valueUp(el);
		},
		
		_downHandler: function(e) {
			var el = $(e.currentTarget).data('element');
			$.alopex.widget.spinner.valueDown(el);
		},
		
		_keydownHandler: function(e){
			var el = e.currentTarget;
			if(e.which === 38) { // up
				$.alopex.widget.spinner.valueUp(el);
			} else if(e.which === 40) { // down
				$.alopex.widget.spinner.valueDown(el);
//			} else if(e.which >= 48 && e.which <= 57){ // other key
//				el.prevValue = $(el).val();
//				$(el).off('keydown', $.alopex.widget.spinner._keydownHandler);
//			} else if(e.shiftKey == false){
			}
		},
		
//		_keyupHandler: function(e){
//			var el = e.currentTarget;
//			if(e.which >= 48 && e.which <= 57){ // other key
//				var newval = $(el).val();
//				if(newval < parseFloat(el.min) || newval > parseFloat(el.max)) {
//					$(el).val(el.prevValue);
//				}
//				$(el).on('keydown', $.alopex.widget.spinner._keydownHandler);
//				
//			}
//		},
		
		valueUp: function(el) {
			var value = parseFloat(el.value);
			var max = 0;
			var min = 0;
			if(!isNaN(value)) { // valid number
				var split = el.value.split('.');
				var result = 0;
				
				if(el.max != 'default') {
					max = parseFloat(el.max);
				}
				if(el.min != 'default') {
					min = parseFloat(el.min);
				}
				if(max && value > max) { // typed-in value is greater than data-max value
					result = max;
				} else if(min && value < min) {
					result = min;
				} else {
					result = $.alopex.util.addFloat(el.value, el.step);
				}
				if(el.max == 'default' || result <= parseFloat(el.max)) {
					el.value = result;
				}
				$(el).trigger('change');
			}
		},
		
		valueDown: function(el) {
			var value = parseFloat(el.value);
      var max = 0;
      var min = 0;
			if(!isNaN(value)) { // valid number
				var split = el.value.split('.');
				var result = 0;
				
				if(el.max != 'default') {
					max = parseFloat(el.max);
				}
				if(el.min != 'default') {
					min = parseFloat(el.min);
				}
				if(max && value > max) { // typed-in value is greater than data-max value
					result = max;
				} else if(min && value < min) {
					result = min;
				} else {
					result = $.alopex.util.addFloat(el.value, el.step*-1);
				}
				if(el.min == 'default' || result >= parseFloat(el.min)) {
					el.value = result;
				}
				$(el).trigger('change');
			}
		},
		
		setEnabled: function(el, flag) {
			var $el = $(el);
			var $wrapper = $el.closest('.af-spinner-wrapper');
			var $up = $el.siblings('.af-spinner-button-up');
			var $down = $el.siblings('.af-spinner-button-down');
			$up.off('tap', $.alopex.widget.spinner._upHandler);
			$down.off('tap', $.alopex.widget.spinner._downHandler);
			if(flag) {
				$up.on('tap', $.alopex.widget.spinner._upHandler);
				$down.on('tap', $.alopex.widget.spinner._downHandler);
				$el.removeAttr('readonly');
				$wrapper.removeClass('af-disabled');
			} else {
				$el.attr('readonly', true);
				$wrapper.addClass('af-disabled');
			}
		}
		
	});
})(jQuery);



(function($) {
	$.alopex.widget.table = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'table',

		defaultClassName: 'af-table',
		wrapperClassName: 'af-table-wrapper af-default',
		scrollerClassName: 'af-table-scroller',

		renderTo: function() {
			return '<div class="' + this.wrapperClassName + '" af-dynamic>' + 
						'<div class="' + this.scrollerClassName + '" af-dynamic>' + 
							'<table></table>' + 
						'</div>' + 
					'</div>';
		},

		setters: ['table'],
		resizeThreshold: 10,
		resizing: false,
		resizeReady: true,

		properties: {},

		style: function(el) {
		},

		event: function(el) {

		},

		init: function(el) {
			var $el = $(el);
			$.extend(el, {
				scroller: null,
				hscroller: null,
				resizingHeader: null,
				scrolling: false,
				sorting: false,
				resizing: false,
				editing: false,
				highlighting: false,
				theme: null
			});
			this._addColgroup(el);
			$el.css({
				'table-layout': 'fixed'
			});
			if ($el.css('min-width') === '0px') {
				$el.css({
					'min-width': '100%'
				});
			}
			if (!$.alopex.util.isValid(el.style.width)) {
				$el.css({
					'width': '100%'
				}); // 과연 진짜 답은?
			}

			var $wrapper = $el.closest('.af-table-wrapper');
			$wrapper.css({
				'overflow': 'hidden',
				'position': 'relative'
			});
			el.wrapper = ($wrapper.length > 0) ? $wrapper[0] : null;
			el.head = $.alopex.widget.table.getTableHead(el);
			if ($.alopex.util.isValid(el.head)) {
				el.head.table = el; // 헤더가 나눠지더라도 테이블 참조할 수 있도록.
				$(el.head).addClass('af-table-head');
			}
			if ($.alopex.util.isValid($(el).attr('data-height'))) {
				$(el.wrapper).css('height', $(el).attr('data-height')); // data-height 사이즈에 따라 wrapper 결정.
			}
			if ($.alopex.util.isValid($(el).attr('data-width'))) {
				var target = el.hscroller ? el.hscroller : el.wrapper;
				$(target).css('width', $(el).attr('data-width')); // data-width는 너비결정.
			}
			$.alopex.widget.table.refresh(el);
		},

		refresh: function(el) {
			var $el = $(el);
			$.alopex.convert(el);

			if (navigator.userAgent.indexOf('MSIE 7') !== -1) {
				$el.removeAttr('data-scroll');
			}

			if (!el.sorting && $el.find('[data-sortable]').length > 0) {
				this._enableSorting(el);
				el.sorting = true;
			}
			if (!el.resizing && $el.find('[data-resizable="true"]').length > 0) {
				this._enableResizing(el);
				el.resizing = true;
			} else if (el.resizing) {
				this._refreshColgroup(el);
			}
			$(el).find('[data-editable="true"]').addClass('af-table-editor');
			if (!el.editing && $el.find('[data-editable="true"]').length > 0) {
				this._enableEditing(el);
				el.editing = true;
			}
			if (!el.highlighting && $el.attr('data-highlight')) {
				var allow = 'td,th';
				if ($el.attr('data-highlight') === 'body') {
					allow = 'tbody td, tbody th';
				}
				$el.find(allow).css('cursor', 'pointer');
				$(el.wrapper).on('click', allow, this._addTableHighlight);
				el.highlighting = true;
			}

			if (!$(el).is(':hidden')) {
				if (!el.scrolling && $el.attr('data-scroll') !== undefined) {
					this._enableScrolling(el);
					el.scrolling = true;
				}
				
				this._refreshTableHead(el);

				if ($(el).attr('data-scroll') !== undefined) {
					// table의 크기는 cell의 내용에 따라 내벼려 두고, 
					// scroll refresh
					this._refreshTableScroll(el);
				}
				
			}
		},

		/**
		 * Add div for scrolling functionality
		 * @param el
		 */
		_enableScrolling: function(el) {
			// 모바일에서는 세로 스크롤, 데스크탑에서는 가로&세로 스크롤로 사용.
			var $el = $(el);
			var $scroller = $el.closest('.' + this.scrollerClassName);
			el.scroller = ($scroller.length > 0) ? $scroller[0] : null;
			el.scroller.el = el;
			$(el.wrapper).css({
				'overflow': 'hidden'
			}); // 가로 스크롤의 경우, 
			var $colgroup = $(el).find('colgroup').clone(true);

			// body 영역 스크롤의 경우, 헤더부분 absolute으로 띄우기.
			if ($(el).attr('data-scroll') === 'body') {
				if (window.browser === 'mobile') {
					$(el.scroller).css({
						'overflow': 'hidden',
						'overflow-y': 'auto'
					});
					// 헤더 분리.
					if (el.head) {
						var $dummyHeader = $(el.head).clone(true).appendTo(el);
						el.clone = $(el).clone(true).removeAttr('id').removeAttr('data-type').empty()[0];
						$(el.wrapper).prepend(el.clone);
						$(el.head).prepend($colgroup);
						$(el.head).appendTo(el.clone);
						$(el.head).css({
							'z-index': '1',
							'position': 'absolute',
							'display': 'table',
							'table-layout': 'fixed'
						}); // head가 2개이상의 row로 구성된 경우.
						$dummyHeader.remove();
						//              this._refreshTableHead(el);
						//              dummyHeader.css('visibility', 'hidden');
					}

					// 가로 스크롤러 추가. (세로와 가로 스크롤러 분리)
					var $hscroller = $('<div></div>').attr('class', el.theme + ' af-table-hscroller');
					$hscroller.css({
						'overflow': 'hidden',
						'overflow-x': 'auto',
						'-webkit-overflow-scrolling': 'touch'
					});
					$(el.wrapper).wrap($hscroller[0]);
					el.hscroller = el.wrapper.parentNode;
					el.hscroller.el = el;
				} else {
					// 헤더 absolute로 띄우기.
					if (el.head) {
						$(el.head).css({
							'float': 'left',
							'position': 'absolute',
							'top': '0px',
							'display': 'table',
							'table-layout': 'fixed'
						});
						$(el.head).prepend($colgroup);
					}
					$(el.scroller).css({
						'overflow': 'auto'
					});
					$(el).css({
						'overflow': 'hidden'
					});
					$(el.scroller).bind('scroll', function(e) { // 가로 스크롤 시, 헤더 너비 조정.
						var target = e.currentTarget;
						var el = target.children[0];
						$(el.head).css({
							'left': (target.scrollLeft * -1) + 'px'
						});
					});
				}

				$(el.head).find('tr').css('display', 'table-row');

				if (navigator.userAgent.toLowerCase().indexOf('android') !== -1) {
					// 안드로이드 경우, 이벤트 처리.
					$(el.hscroller).bind('touchstart', function(e) {
						var el = e.currentTarget.el;
						el.started = true;
						el.x = e.originalEvent.touches[0].clientX;
						el.y = e.originalEvent.touches[0].clientY;
					});
					$(el.hscroller).bind('touchmove', function(e) {
						var el = e.currentTarget.el;
						if (el.started) {
							el.x = Math.abs(e.originalEvent.touches[0].clientX - el.x);
							el.y = Math.abs(e.originalEvent.touches[0].clientY - el.y);
							if (el.x > el.y) {
								$(el.hscroller).css({
									'overflow': 'hidden',
									'overflow-x': 'auto'
								});
								$(el.scroller).css('overflow', 'hidden');
							} else {
								$(el.hscroller).css('overflow-x', 'hidden');
								$(el.scroller).css({
									'overflow': 'hidden',
									'overflow-y': 'auto'
								});
							}
							el.started = false;
						}
					});
				}
			} else {
				$(el.scroller).css({
					'overflow': 'auto',
					'overflow-scrolling': 'touch'
				});
			}
		},

		_refreshTableHead: function(el) {
			if (!$.alopex.util.isValid(el.head)) {
				return;
			}

			var tbodyrow = $(el).find('tbody > tr');
			var tbody = $(el).find('tbody');
			var twidth = el.offsetWidth;
			if (tbodyrow.length > 0) {
				// in case the databind is used, table row in index 0 is template
				twidth = tbodyrow[tbodyrow.length-1].offsetWidth;  
			} else if (tbody.length > 0) {
				twidth = tbody[0].offsetWidth;
			}

			var $head = $(el.head);
			$head.css({
				'table-layout': '',
				'width': twidth+'px' // 100% cannot be used, scroll in IE take few pixels 
			});
			if(twidth == 0) {
				$head.css({
					'width': '100%'
				});
			}
//			if (el.offsetWidth === el.wrapper.offsetWidth) {
//				$head.css({
//					'width': '100%'
//				});
//			} else {
//				$head.css({
//					'width': twidth + 'px'
//				});
//			}

			var element = el;
			setTimeout(function() { // webkit 버그로 인하여, 'table-layout' 속성이 제대로 적용되지 않음.
				var $el = $(element);
				$head.css({
					'table-layout': 'fixed'
				});

				// table head와 body의 보더 맞추는 코드
				// thead와 tr 너비 크기가 틀린 경우 발견. 테이블내 tr 엘리먼트 너비 값을 조회한 후 틀린경우, 헤더에서 너비 조정.
				//        var prev = null;
				//        var $temprow = null;
				//        var $tr = $el.closest('.af-table-wrapper').find('tr');
				//        if($tr.length < 5) {
				//          var columnCount = $.alopex.table.getColumnCount(element.wrapper);
				//          var str = '<tr>';
				//          for(var i=0; i<columnCount; i++) { str += '<td></td>'; }
				//          str += '</tr>';
				//          $temprow = $(str);
				//          $(el).find('tbody').append($temprow);
				//          $tr = $el.closest('.af-table-wrapper').find('tr');
				//        }
				//        
				//        for ( var i = 0; i < $tr.length; i++) {
				//          if (prev === null) {
				//            prev = $tr[i].offsetWidth;
				//          } else {
				//            if (prev !== $tr[i].offsetWidth) {
				//              $head.css('width', (headerWidth - (prev - $tr[i].offsetWidth)) + 'px');
				//              break;
				//            }
				//          }
				//        }
				//        
				//        if($temprow !== null) {
				//          $temprow.remove();
				//        }

			}, 10);
		},

		/**
		 * todo
		 * 1. header size adjustment
		 * 2. scroller height adjustment
		 */
		_refreshTableScroll: function(el) {
			var $scroller = $(el.scroller);
			var scrollerHeight = el.wrapper.offsetHeight;
			if ($(el).attr('data-scroll') === 'all') {
				$scroller.css('margin-top', '0');

			} else {
				if (window.browser === 'mobile') {
					// 모바일 경우, hscroller가 추가로 생성됨. 이 떄문에 wrapper의 width를 조정해줘야 가로 스크롤이 동작함.
					$(el.wrapper).css('width', el.offsetWidth + 'px');
				}
				// header size adjustment
				if ($.alopex.util.isValid(el.head)) {
					scrollerHeight -= el.head.offsetHeight;
					$scroller.css('margin-top', el.head.offsetHeight + 'px');
				}
			}
			$scroller.css('height', scrollerHeight + 'px');
		},

		hideColumn: function(index) {
			var el = this;
			$(el).find('col:nth-child(' + (index + 1) + ')').addClass('af-hidden');
		},

		showColumn: function(index) {
			var el = this;
			$(el).find('col:nth-child(' + (index + 1) + ')').removeClass('af-hidden');
		},

		clear: function(el) {
			$(el).find('tr').each(function() {
				if ($(this).closest('thead').length > 0) {
					return;
				}
				if ($(this).find('th').length > 0) {
					return;
				}
				$(this).remove();
			});
		},

		_addTableHighlight: function(e) {
			var cell = e.target;
			cell = $(cell).closest('tr,td, th')[0];
			var row = $(cell).closest('tr')[0];
			var head = $(cell).closest('th')[0];
			var table = $(cell).closest('table')[0];

			var isHeader = false;
			if (head !== undefined) {
				isHeader = true;
			}

			$(table).find('.af-table-row').removeClass('af-table-row');
			$(table).find('.af-table-cell').removeClass('af-table-cell');
			$(table).find('.af-table-column').removeClass('af-table-column');

			if (isHeader) {
				var index = $.alopex.widget.table.getColumnIndex(cell);
				$(table).find('td:nth-child(' + (index + 1) + '),' + 'th:nth-child(' + (index + 1) + ')').addClass('af-table-column');
			} else {
				$(row).addClass('af-table-row');
				$(cell).addClass('af-table-cell');
			}
		},

		/**
		 * table 헤더 리턴. 밑에 일치가 안된다.
		 *  1. <thead>태그가 존재할 경우, thead리턴. 
		 *  2. <thead> 없을 시, <th>태그의 부모<tr> 리턴.
		 *  3. null 리턴. 
		 * 
		 * @param el
		 * @returns
		 */
		getTableHead: function(el) {
			var thead = null;
			if ($(el).find('thead').length > 0) {
				thead = $(el).find('thead')[0];
			} else if ($(el).find('th').length > 0) {
				thead = $(el).find('th')[0].parentNode;
			}
			return thead;
		},

		getTableBody: function(el) {
			var tbody;
			if ($(el).find('tbody').length > 0) {
				tbody = el.tBody ? el.tBody : $(el).find('tbody')[0];
			} else {
				tbody = el;
			}
			return tbody;
		},

		getRowIndex: function(td) {
			var tr = td.parentNode;
			var table = tr;
			while (table.tagName.toLowerCase() !== 'table') {
				table = table.parentNode;
			}
			var tbody = table.tableBody;
			var cnt = 0;
			for ( var i = 0; i < tbody.rows.length; i++) {
				if (tbody.rows[i] === table.tableHead) {
					continue;
				} else if (tbody.rows[i] === tr) {
					return cnt;
				}
				cnt++;
			}
			return cnt;
		},

		getColumnIndex: function(td) {
			var tr = td.parentNode;
			if ($.alopex.util.isValid(tr.cells)) {
				for ( var i = 0; tr.cells.length; i++) {
					if (tr.cells[i] === td) {
						return i;
					}
				}
			}
			return -1;
		},

		_enableEditing: function(el) {
			$(el.wrapper).on('click', '[data-editable="true"]', $.alopex.widget.table._editHandler);
		},

		_disableEdit: function(el) {
			var thead = el.tableHead;
			var tbody = el.tableBody;

			$(thead).find('[data-editable="true"]').each(function() {
				var th = this;
				var columnIndex = $.alopex.widget.table.getColumnIndex(th);

				for ( var i = 0; i < tbody.rows.length; i++) {
					if (tbody.rows[i] === thead) {
						continue;
					}
					$(tbody.rows[i]).find('td:nth-child(' + (columnIndex + 1) + ')').unbind('click', $.alopex.widget.table._editHandler);
				}
			});
		},

		_editHandler: function(e) {
			var cell = $(e.target).closest('td')[0];
			var table = $(cell).closest('table')[0];

			// td 안에 textnode 말고 다른
			if (cell.children !== undefined && cell.children.length > 0) {
				return;
			}

			var input = document.createElement('input');
			$(input).val(cell.text = $(cell).text());
			$.alopex.widget.table.tmpInput = input;
			$.alopex.widget.table.tmp = cell;
			$(cell).text('').append(input).addClass('af-editing');

			//        var temp = cell.style.height;
			$(input).focus();
			$.alopex.widget.table._disableEdit(table);

			function focusout(e) {
				e.stopImmediatePropagation();
				e.preventDefault();

				var input = $.alopex.widget.table.tmpInput;
				var text = $(input).val();
				if (input.parentNode.text !== text) {
					$(input.parentNode).addClass('af-edited');
					table.edited = true;
				}
				$(input.parentNode).text(text).removeClass('af-editing');
				$(input).remove();
				$.alopex.widget.table._enableEditing(table);
			}

			$(input).bind('focusout', function(e) {
				focusout(e);
			});
			$(input).bind('keydown', function(e) {
				if (e.keyCode !== 13 && e.keyCode !== 27) {
					return;
				}
				focusout(e);
			});
		},

		/**
		 * colgroup 태그가 없을 시 추가한다. (사이즈 조정에 사용됨)
		 * @param el
		 */
		_addColgroup: function(el) {
			// colgroup
			var rowgroups = $(el).find('tr');
			rowgroups = rowgroups[rowgroups.length - 1];
			var colgroup = $(el).find('colgroup');
			if (colgroup.length === 0) {
				colgroup = document.createElement('colgroup');
				for ( var i = 0; i < rowgroups.children.length; i++) {
					var temp = document.createElement('col');
					$(temp).appendTo(colgroup);
				}
				$(colgroup).insertBefore(el.children[0]);
			} else {
				colgroup = colgroup[0];
			}
		},

		_refreshColgroup: function(el) {
			var rowgroups = $(el).find('tr');
			if (rowgroups.length > 0) {
				var maxtd = 0, i;
				rowgroups.each(function(idx, elem) {
					var len = $(elem).children('td').length;
					maxtd = len > maxtd ? len : maxtd;
				});
				var dummytr = $('<tr>').css('height', '0px');
				for (i = 0; i < maxtd; i++) {
					dummytr.append('<td>&nbsp;</td>');
				}
				dummytr.insertAfter(rowgroups.last());
				var colgroup = $(el).find('colgroup');
				var tempArr = [];
				var len;
				for (i = 0, len = maxtd; i < len; i++) {
					var width = (dummytr.children('td').eq(i).offsetWidth);
					tempArr.push(width);
				}
				for (i = 0; i < tempArr.length; i++) {
					$(el).find('col:nth-child(' + (i + 1) + ')').css('width', tempArr[i]);
				}
				dummytr.remove();
			}
		},

		/**
		 * 컬럼이 리사이즈 가능 하도록 한다.
		 * @param el
		 */
		_enableResizing: function(el) {
			if (window.browser !== 'mobile') { // Desktop Only Function
				// register event handler
				$(el.wrapper).on('mousedown', '[data-resizable="true"]', this._resizeStartHandler).on('mousemove', '[data-resizable="true"]', this._checkResizeCondition);
				$(el.wrapper).find('[data-resizable="true"]').each(function() {
					this.table = el;
					var btn = document.createElement('div');
					$(btn).addClass('af-table-resize').appendTo(this);
				});
				$(el.rows[0].cells).each(function(index) {
					this.index = index;
				});
				$(el).on('selectstart', function(e) {
					return false;
				});
				$(el).on('dragstart', function(e) {
					return false;
				});
			}

		},

		_resizeStartHandler: function(e) {
			var target = e.currentTarget;
			var el = target.table;
			var tableWidth = el.offsetWidth;
			$(el).css({
				'width': tableWidth + 'px',
				'min-width': ''
			});
			if ($.alopex.widget.table.resizeready) {
				$.alopex.widget.table.resizing = true;
				$.alopex.widget.table.resizingEl = target;
				$(document).bind('mousemove', $.alopex.widget.table._resizeMoveHandler);
				$(document).bind('mouseup', $.alopex.widget.table._resizeEndHandler);
				if ($.alopex.util.isValid($('body').css('cursor'))) {
					$('body').data('cursor', $('body').css('cursor'));
				}
				$('body').css('cursor', 'col-resize').css('text-overflow', 'ellipsis');
			}
		},

		_resizeMoveHandler: function(e) {
			if ($.alopex.widget.table.resizing) {
				var col = $.alopex.widget.table.resizingEl;
				var el = col.table;
				var pos = $.alopex.util.getScrolledPosition(col);
				var left = pos.left;
				var width = e.pageX - left;

				if (col.width && width < col.width && Math.abs(col.width - col.offsetWidth) > 3) {
					$.alopex.widget.table._resizeColumn(col, col.offsetWidth);
					col.width = col.offsetWidth;
				} else {
					$.alopex.widget.table._resizeColumn(col, width);
					col.width = width;
				}
				$.alopex.widget.table._refreshTableScroll(el);
			}
		},

		_resizeEndHandler: function(e) {
			if ($.alopex.widget.table.resizing) {
				var target = $.alopex.widget.table.resizingEl;
				$.alopex.widget.table.resizing = false;
				$.alopex.widget.table.resizingEl = null;
				$(document).unbind('mousemove', $.alopex.widget.table._resizeMoveHandler);
				$(document).unbind('mouseup', $.alopex.widget.table._resizeEndHandler);
				if ($.alopex.util.isValid($('body').data('cursor'))) {
					$('body').css('cursor', $('body').data('cursor'));
				} else {
					$('body').css('cursor', '').css('background', '');
				}
			}
		},

		_checkResizeCondition: function(e) {
			var el = $(e.target).closest('[data-resizable="true"]')[0];
			var pos = $.alopex.util.getScrolledPosition(el);
			var curright = pos.left + el.offsetWidth;
			if ($(el).css('cursor') !== 'col-resize') {
				$(el).data('cursor', '');
			}
			if (e.pageX >= curright - $.alopex.widget.table.resizeThreshold) {
				$(el).css('cursor', 'col-resize');
				$.alopex.widget.table.resizeready = true;
			} else {
				$(el).css('cursor', $(el).data('cursor'));
				$.alopex.widget.table.resizeready = false;
			}
		},

		/**
		 * @param {HTMLCellElement} th target header td element.
		 * @param {integer} width width of td element;
		 */
		_resizeColumn: function(th, width) {
			var table = th.table;
			var $table = $(table);
			var head = table.head;
			$(th).css('width', width + 'px');
			//        $(th.table.wrapper).css({'display':'inline-block', 'width':''})
			$($table).find('colgroup > col:nth-child(' + (th.index + 1) + ')').each(function() {
				var colWidth = $($table).find('tr:first-child').find('td,th')[th.index].offsetWidth;
				var oldColWidth = this.width ? this.width : colWidth;
				var oldTableWidth = this.tableWidth ? this.tableWidth : parseInt($table.css('width').replace('px', ''), 10);
				var diff = width - oldColWidth;
				this.width = width;
				this.style.width = width + 'px'; // for ie7
				$(this).css('width', width + 'px'); // for ie8, ie9
				this.tableWidth = (oldTableWidth + diff);
				$table.css('width', this.tableWidth + 'px');
				$(head).css('width', this.tableWidth + 'px');
			});
		},

		// 
		_enableSorting: function(el) {
			var rows = el.head;
			$(rows).find('th, td').each(function(index) {
				if ($(this).attr('data-sortable') === undefined && $(this).attr('data-sort-function') === undefined) {
					return;
				}
				this.columnIndex = index;
				this.table = el;
				var icon = document.createElement('span');
				$(icon).addClass('af-icon');
				$(this).append(icon).css('cursor', 'pointer');
			});
			$(el.wrapper).on('click', '[data-sortable], [data-sort-function]', $.alopex.widget.table._sort);
		},

		_sort: function(e) {
			var headColumn = e.currentTarget;
			$.alopex.widget.table.sort(headColumn);
		},

		sort: function(target) {
			if (target === undefined) {
				target = this;
			}

			var table = target.table;
			if (table) {
				var index = target.columnIndex;
				var tbody = table.tBodies[0];
				var array = [];
				var valArr = [];
				for ( var i = 0; i < tbody.rows.length; i++) {
					if (tbody.rows[i].cells.length > 0 && tbody.rows[i].cells[0].tagName.toLowerCase() === 'th') {
						continue;
					}
					array.push([this._getInnerText(tbody.rows[i].cells[index]), tbody.rows[i]]);
				}
				var sort_function;
				if ($(target).attr('data-sort-function') !== undefined) {
					sort_function = window[$(target).attr('data-sort-function')];
				} else {
					var type = $(target).attr('data-sortable');
					switch (type) {
					case 'number':
						sort_function = $.alopex.util.sort_numeric;
						break;
					case 'date':
						valArr = $.alopex.util.formatDate(valArr);
						sort_function = $.alopex.util.sort_date;
						break;
					default:
						sort_function = $.alopex.util.sort_default;
						break;
					}
				}
				$(target).siblings().removeClass('af-table-ascending').removeClass('af-table-descending');
				if (target.className.indexOf('af-table-ascending') !== -1) {
					$(target).removeClass('af-table-ascending');
					$(target).addClass('af-table-descending');
					array = $.alopex.util.mergeSort(array, sort_function, false);
				} else {
					$(target).removeClass('af-table-descending');
					$(target).addClass('af-table-ascending');
					array = $.alopex.util.mergeSort(array, sort_function, true);
				}
				for (i = 0; i < array.length; i++) {
					tbody.appendChild(array[i][1]);
				}
			}

		},

		_getInnerText: function(node) {
			// 현재 alopex UI Framework componenet value를 가져와야 함.
			// node가 정의되지 않앗거나, 복합 구조일 경우 빈 스트링 리턴.
			if (!node) {
				return '';
			}

			return node.innerHTML;
		},

		getColumnCount: function(el) {
			var $el = $(el);
			var count = 0;

			var $tr = $el.find('tr');
			for ( var i = 0; i < $tr.length; i++) {
				var colCount = $tr.find('td, th').length;
				if (colCount > count) {
					count = colCount;
				}
			}
			return count;
		}
	});

})(jQuery);
(function($) {
	$.alopex.widget.tabs = $.alopex.inherit($.alopex.widget.object, {
		widgetName: 'tabs',
		defaultClassName: 'af-tabs',
		setters: ['tabs', 'setTabIndex','setTabByContent', 'setEnabled', 'setEnabledByContent', 'reload', 'clear'],
		getters: ['getCurrentTabIndex', 'getCurrentTabContent', 'getButtons', 'getContent', 'getActiveButtons', 'getLength', 'isEnabled'],

		requestButton: null,
		
		properties: {
			buttons: null,
			buttonGroup: null,
			tabstrigger: 'tap',
			eventState: 'init',
			carousel: false, // indicate if carousel function is used.
			wrapper: null // tab content wrapper: necessary for carousel
		},
		getLength: function(el) {
			if(el.buttons) {
				return el.buttons.length;
			}
			return 0;
		},
		getButtons: function(el) {
			return el.buttons;
		},
		getContent: function(el, index) {
			if(el.buttons && el.buttons[index]) {
				return el.buttons[index].content;
			}
		},
//		isEnabled: function(el, index) {
//			if(el.buttons[index].className.indexOf('af-disabled') == -1) {
//				return false;
//			}
//			return true;
//		},
		
		reload: function(el, index, callback) {
			if(el.buttons && el.buttons[index]) {
				// 현재 페이지에 구성된 탭이 아닌경우에만 적용.
				// local tab content는 제외.
				if($(el.buttons[index]).attr('data-content').indexOf('#') != 0) { 
					this._loadHTML(el.buttons[index], el, callback);
				}
				
			}
		},

		init: function(el, options) {
			var $el = $(el);
			$.extend(el, this.properties, options);
			el._currentTabIndex = -1;

			// lazy loading : data-lazy-load 속성이 들어간 경우, 선택된 탭 이외의 탭 컨텐트는 나중에 converting 한다. 
			// loading 시간 단축.
			if (el.lazyload === 'true') {
				$el.find('[data-type]').each(function() {
					this.phase = 'pending';
				});
			}

			var eventAttr = $(el).attr('data-event');
			if (eventAttr === 'hover' || eventAttr === 'hovering') {
				el.tabstrigger = 'hovering';
			}

			el.buttonGroup = $el.find('> ul');
			if (el.buttonGroup.length === 0) {
				el.buttonGroup = $el.find('.af-tabs-button-group');
			} else {
				el.buttonGroup.addClass('af-tabs-button-group');
			}
			el.buttons = el.buttonGroup.find('> li');
			if (el.buttons.length > 0) {
				el.buttons.on('click', function(e) { // default 이벤트 무시.
					e.preventDefault(); // stop navigating to 'ajax loding page'
				});
				var prevContent = el.buttonGroup;
				for ( var i = 0; i < el.buttons.length; i++) {
					var tabButton = el.buttons[i];
					var $tabButton = $(tabButton);
					tabButton.element = el;
					tabButton.index = i;
					//          $.alopex.widget.object.addHighlight(tabButton);
					$tabButton.appendTo(el.buttonGroup);
					$tabButton.addClass('af-tabs-button');
					$tabButton.find('img').addClass('af-tabs-button-icon');

					var linktabButton = (tabButton.tagName.toLowerCase() === 'li') ? $tabButton : $tabButton.find('li');
					var address = linktabButton.attr('data-content').split('#');
					if (address.length === 1) {
						tabButton.loadType = 'ajax';
					} else if (address.length === 2) { //
						if (address[0] === '' || address[0] === document.URL.split('#')[0]) {
							tabButton.loadType = 'local';
							tabButton.hashAddr = address[1];
						} else {
							tabButton.loadType = 'ajax';
						}
					}

					switch (tabButton.loadType) {
					case 'local':
						var $content = $(el).find('#' + tabButton.hashAddr);
						if ($content.length > 0) {
							tabButton.content = $content[0];
						} else {
							// #id.ddd 이런 아이디 경우 jquery selector 작업시 오류 발생.
							var content = document.getElementById(tabButton.hashAddr);
							if($.alopex.util.isValid(content)){
								tabButton.content = content;
							} else {
								tabButton.content = document.createElement('div');
								$(tabButton.content).insertAfter(prevContent);
							}
						}
						break;
					case 'ajax': // ajax 요청으로 지정 시 동적으로 content 영역 insert.
						tabButton.content = document.createElement('div');
						$(tabButton.content).insertAfter(prevContent);
						break;
					default:
						break;
					}
					prevContent = tabButton.content;
					$(tabButton.content).addClass('af-tabs-content');
				}
				$.alopex.widget.tabs.setTabIndex(el, 0);
				$(el).on('keydown', $.alopex.widget.tabs._keyEventHandler);
			}
			
			this._bindEvent(el);
		},
		
		defer: function(el, options){
			var that = this;
//			if(false) {
////			if(el.carousel) {
//				if (el.buttonGroup.length > 0) { // request for Content HTML
//					var buttons = el.buttonGroup.children();
//					$(buttons).each(function(i, v) {
//						if (v.loadType === 'ajax') {
//							that._loadHTML(v, el);
//						}
//					});
//				}
//			}
			if(el.carousel) {
				var timer = setInterval(function() { // waiting for all contents rendered
					if(!$(el).is(':hidden')) {
						clearInterval(timer);
						if(el.carousel) {
							$(el).find('> .af-tabs-content').attr('data-role', 'page');
							$(el).attr('data-type', 'carousel').carousel();
						}
					}
				}, 200);
			}
		},
		
		_evt_swipe: function(e, c) {
			__ALOG('swipe')
			var el = $(e.currentTarget).parent('[data-type="carousel"]')[0];
			var duration = (el.width - Math.abs(c.distanceX)) / c.speed * 1000;
			if (duration > 500) {
				duration = 500;
			}
			var destindex = el._currentTabIndex;
			if (c.distanceX < 0) { // 좌측 이동
				do {
					destindex ++;
				}while(!$.alopex.widget.tabs.isEnabled(el, destindex) && destindex < el.buttons.length);
			} else { // 우측 이동
				do {
					destindex --;
				}while(!$.alopex.widget.tabs.isEnabled(el, destindex) && destindex >= 0);
			}
			if(destindex == -1 || destindex >= el.buttons.length) {
				$.alopex.widget.tabs.setTabIndex(el, el._currentTabIndex);
			} else {
				$.alopex.widget.tabs.setTabIndex(el, destindex);
			}
			el.press = false;
			$(el).trigger('swipechange', [el._currentTabIndex]);
		},
		
		_keyEventHandler: function(e) {
			var target = e.target;
			var originalTarget = target;
			var el = e.currentTarget;
			if ($(el.buttons).filter(target).length <= 0) {
				return;
			}
			var found = false;

			while ($.alopex.util.isValid(target) && !found) {
				var code = e.keyCode !== null ? e.keyCode : e.which;
				switch (code) {
				case 9: // tab
					return;
				case 37: // left
				case 38: // up
					if ($(target).prev().length !== 0) {
						target = $(target).prev()[0];
					} else {
						target = $(target).siblings().last()[0];
					}
					e.preventDefault();
					break;
				case 39: // right
				case 40: // down
					if ($(target).next().length !== 0) {
						target = $(target).next()[0];
					} else {
						target = $(target).siblings().first()[0];
					}
					e.preventDefault();
					break;
				default:
					return;
				}
				var that = $.alopex.widget.tabs;
				if(that.isEnabled(el, target.index) || target == originalTarget ) {
					found = true;
				}
			}
			
			$.alopex.widget.tabs.setTabIndex(target.element, target.index);
			e.preventDefault();
		},

		_loadCallback: function(response, status, xhr) {
			var button = $.alopex.widget.tabs.requestButton;
			if (status === 'error') {
				var msg = '<p>Sorry, there was an ERROR!</p>' + '<p style="color:red;">' + xhr.status + '<br/>' + xhr.statusText + '</p>';
				$(button.content).html(msg);
			} else {
				button.loadType = 'local';
				$(button.content).convert();
			}
		},
		
		refreshButtons: function(el, index) {
			el.buttonGroup.children().attr('aria-selected', 'false').attr('tabindex', '-1').removeClass('af-selected');
			el.buttonGroup.children().eq(index).attr('aria-selected', 'true').attr('tabindex', '0').addClass('af-selected').focus();
		},
		
		_loadHTML: function(button, el, callback) {
			var tmpContent = button.content;
			this.requestButton = button;
			$.ajax({
				url: $(button).attr('data-content'),
				cache: false,
				async: false
			}).done(function(html) {
				button.loadType = 'local';
				$(button.content).html(html).convert();
				$(document).trigger('alopexuiready'); // -> init
				if(callback) {
					callback(); // tabchange
				}
			});
		},
		
		getCurrentTabIndex: function(el) {
			return el._currentTabIndex;
		},
		
		getCurrentTabContent: function(el) {
      return el._currentTabContent;
    },
		
		setTabByContent: function(el, conName) {
		  if (el.buttonGroup.length > 0) {
		    var index = el.buttonGroup.find('[data-content=' + conName + ']').index();
        if(!this.isEnabled(el, index)) {
          return;
        }
        this.setTabIndex(el, index);
      }
		},
		
		setTabIndex: function(el, index, eventFlag) {
			if(!this.isEnabled(el, index)) {
				return;
			}
			el._currentTabIndex = index;
			var that = this;
			var contents = [];
			var isAjax = false;
			if (el.buttonGroup.length > 0) {
				var buttons = el.buttonGroup.children();
				el._currentTabContent = $(buttons[index]).attr('data-content');
				$(buttons).each(function(i, v) {
					var button = v;
					$(button.content).css('height', '5px'); // unselected content must not affect the height of the tabs
					if (i === index) {
						if ($(el).attr('data-flexbox') === 'true') {
							$(button.content).css({
								'display': '-webkit-box'
							});
						} else {
							$(button.content).css('display', 'block');
						}
						$(button.content).css('height', '');
						
						if (button.loadType === 'ajax') {
							isAjax = true;
							that._loadHTML(button, el, function() {
								// ajax 로드 완료된 이후 tabchange 이벤트 발생.
								$.alopex.convert(button.content, true); // 강제 변환.
								$(el).trigger('tabchange', [index]);
							});
						} else {
							// 탭이 바뀔때 tabchange 이벤트 발생. 인자로는 index 넘겨줌.
							$.alopex.convert(button.content, true); // 강제 변환.
							$(el).trigger('tabchange', [index]);
						}
					} else {
						contents.push(button.content);
					}
				});
				if(el.carousel) {
					$(el).setIndex(index, {animationDuration: 0}); // carousel 인덱스 선택.
//					for(var i=0; i<contents.length; i++) {
//						$(contents[i]).css('height', '10px');
//					}
				} else {
					for(var i=0; i<contents.length; i++) {
						$(contents[i]).css('display', 'none');
					}
				}
				this.refreshButtons(el, index);
			}
		},
		
		clear: function(el, index) {
			var $content = $(this.getContent(el, index));
			if($.alopex && $.alopex.page) {
				for(var i in $.alopex.page) {
		    		if($.alopex.page.hasOwnProperty(i) && i.indexOf('#') == 0 && $content.find(i).length > 0) {
		    			delete $.alopex.page[i];
		    		}
		    	}
			}
			$content.empty();
			if(this.getButtons(el) && this.getButtons(el)[index]) {
				this.getButtons(el)[index].loadType = 'ajax';
			}
		},
		
		setEnabledByContent: function(el, flag, conName) {
		  if (el.buttonGroup.length > 0) {
		    var index = el.buttonGroup.find('[data-content=' + conName + ']').index();
		    if(!this.isEnabled(el, index)) {
	        return;
	      }
		    
		    this.setEnabled(el, flag, index);
		  }
		},
		
		// index가 있을 경우, 
		setEnabled: function(el, flag, index) {
			if(index) {
				if(index instanceof Array) { // 
					for(var i=0; i<index.length; i++) {
						this._setEnabled(el, flag, index[i]);
					}
				} else {
					this._setEnabled(el, flag, index);
				}
			} else { // index가 존재 하지 않는 경우, 전체 탭버튼이 다 적용.
				
			}
			
		},
		
		_addDisabledStyle: function(el, index) {
			$(el.buttons).eq(index).addClass('af-disabled');
		},
		
		_removeDisabledStyle: function(el, index) {
			$(el.buttons).eq(index).removeClass('af-disabled');
		},
		
		isEnabled: function(el, index) {
		  if (index < 0 || el.buttons.length <= index) {
		    return false;
		  }
			return !$(el.buttons).eq(index).hasClass('af-disabled');
		},
		
		/**
		 * @arg
		 */
		_setEnabled: function(el, flag, index) {
			
			if(flag) {
				if(!this.isEnabled(el, index)) {
					this._bindEvent(el, index);
					this._removeDisabledStyle(el, index);
				}
			} else {
				this._unbindEvent(el, index);
				this._addDisabledStyle(el, index);
			}
		},
		
		_bindEvent: function(el, index) {
			var that = this;
			var $button;
			if(index) {
				$button = $(el.buttons).eq(index);
			} else {
				$button = $(el.buttons);
			}
			
			$button.each(function() {
				that.addHoverHighlight(this);
				that.addPressHighlight(this);
			})
			
			// add event handler for tab change
			$button.on(el.tabstrigger, this._selectCallback);
		},
		
		_selectCallback: function(e) {
			var that = $.alopex.widget.tabs;
			var tabBtn = e.currentTarget;
			var el = tabBtn.element;
			while (tabBtn.index === undefined) {
				tabBtn = tabBtn.parentNode;
			}
			tabBtn.defaultStyleClass = $(tabBtn).attr('class');
			that.setTabIndex(el, tabBtn.index); // 계속 되겠ㄴ
			el.eventState = 'focused';
		},
		
		_unbindEvent: function(el, index) {
			var that = this;
			var $button = $(el.buttons).eq(index);
			$button.each(function() {
				that.removeHoverHighlight(this);
				that.removePressHighlight(this);
			})
			
			// add event handler for tab change
			$button.off(el.tabstrigger, this._selectCallback);
		}
  });
})(jQuery);

(function($) {

	$.alopex.widget.textarea = $.alopex.inherit($.alopex.widget.object, {
		widgetName : 'textarea',
		defaultClassName : 'af-textarea',
		setters : ['textarea'],

		init : function(el, options) {

		}
	});

})(jQuery);
(function($) {

	/***************************************************************************
	 * textinput
	 **************************************************************************/
	$.alopex.widget.textinput = $.alopex.inherit($.alopex.widget.baseinput, {
		widgetName : 'textinput',
		defaultClassName : 'af-textinput',
		setters : ['textinput']
	});

})(jQuery);
(function($) {
	/*********************************************************************************************************
	 * togglebutton
	 *********************************************************************************************************/
	$.alopex.widget.togglebutton = $.alopex.inherit($.alopex.widget.basebutton, {
		widgetName: 'togglebutton',
		eventHandlers: {
			toggle: {
				event: 'click',
				handler: '_toggleHandler'
			}
		},

		triggerEvent: {},

		properties: {
			checked: false
		},

		getters: ['isChecked'],
		setters: ['togglebutton', 'setChecked', 'toggleChecked'],

		_toggleHandler: function(el) {
      var that = $.alopex.widget.togglebutton;
      if (that._getProperty(el, 'enabled')) {
        if (that._getProperty(el, 'checked')) {
          $(el).removeClass('af-checked');
          that._setProperty(el, 'checked', false)
        } else {
          $(el).addClass('af-checked');
          that._setProperty(el, 'checked', true)
        }
      }
    },

		isChecked: function(el) {
			return this._getProperty(el, 'checked');
		},

		setChecked: function(el, checked) {
			var $el = $(el);
			if (checked) {
				this._setProperty(el, 'checked', true);
				$el.addClass('af-checked');
			} else {
				this._setProperty(el, 'checked', false);
				$el.removeClass('af-checked');
			}
		},

		toggleChecked: function(el) {
      this._toggleHandler(el);
    },

		init: function(el) {
		}

	});
})(jQuery);
(function($) {

	$.alopex.widget.tooltip = $.alopex.inherit($.alopex.widget.object, {

		defaultClassName: 'af-tooltip',

		getters: [],
		setters: ['tooltip', 'open', 'close', 'toggle'],

		style: function(el, options) {
			var $el = $(el);
			if ($el.attr('data-type') !== 'tooltip') {
				var tooltip = document.createElement('div');
				var $tooltip = $(tooltip);
				$tooltip.attr({
					'data-type': 'tooltip'
				});
				$tooltip.html($el.attr('title'));
				$tooltip.insertAfter(el);
				$tooltip.tooltip();
				return;
			}

			// default property
			$.extend(el, {
				tooltiptrigger: 'default',
				opentrigger: 'mouseenter',
				closetrigger: 'mouseleave',
				animation: 'none',
				animationtime: '300',
				track: 'false',
				base: $(el).prev(),
				position: 'auto',
				cssstyle: {
					'position': 'absolute',
					'top': '0px',
					'left': '0px'
				},
				currentstate: 'closed',
				opencallback: null,
				closecallback: null,
				margin: 10
			}, options);
			$el.css(el.cssstyle);
			$el.css('display', 'none');
		},

		pre: function(el, options) {
			var title = $(el).attr('title');
			var $tooltip = $('<div data-type="tooltip">' + title + '</div>').insertAfter(el);
			$tooltip.tooltip();
		},

		init: function(el, options) {
			var $base = $(el.base);
			if ($base.length === 0) {
				return;
			}
			el.base = $base[0];
			$base.each(function() {
				this.tooltip = el;
			});
			if (el.tooltiptrigger === 'default') {
				$base.off('.alopexuitooltip');
				$base.on(el.opentrigger+'.alopexuitooltip', $.alopex.widget.tooltip._show);
				$base.on(el.closetrigger+'.alopexuitooltip', $.alopex.widget.tooltip._hide);
			} else if(el.tooltiptrigger) {
				$base.off('.alopexuitooltip');
				el.opentrigger = el.closetrigger = el.tooltiptrigger;
				$base.on(el.opentrigger+'.alopexuitooltip', $.alopex.widget.tooltip._toggle);
			}
		},

		_show: function(e) {
			var el = e.currentTarget.tooltip;
			$(el).open(el.opencallback);
		},

		_hide: function(e) {
			var el = e.currentTarget.tooltip;
			$(el).close(el.closecallback);
		},

		_toggle: function(e) {
			var el = e.currentTarget.tooltip;
			$(el).toggle();
		},

		open: function(el, callback) {
			var rop = $.alopex.util.getOptions(el);
			if($(rop.base).length) {
				el.base = rop.base;
				this.init(el, rop);
			}
			if(rop.position && rop.position !== el.position) {
				el.position = rop.position;
			}
			var $el = $(el);

			$el.css({
				'display': 'block'
			});
			var tooltipWidth = el.offsetWidth;
			var tooltipHeight = el.offsetHeight;
			var baseWidth = el.base.offsetWidth;
			var baseHeight = el.base.offsetHeight;
			var parent = el.offsetParent;
			while(parent) {
				if(parent == document.body || $(parent).css('position') === 'relative' || $(parent).css('position') === 'absolute') {
					break;
				}
				parent = parent.offsetParent;
			}
			var basePosition = $.alopex.util.getRelativePosition(el.base); // base엘리먼트의 화면 포지션..
			var coorPosition = $.alopex.util.getRelativePosition(parent); // 엘리먼트 기준.
			var baseLeft = basePosition.left - coorPosition.left;
			var baseTop = basePosition.top - coorPosition.top;
			
			var top = 0;
			var left = 0;
			switch (el.position) {
			case 'top':
				left = baseLeft + (baseWidth / 2) - (tooltipWidth / 2);
				top = baseTop - tooltipHeight - el.margin;
				$el.addClass('top');
				break;
			case 'bottom':
				left = baseLeft + (baseWidth / 2) - (tooltipWidth / 2);
				top = baseTop + baseHeight + el.margin;
				$el.addClass('bottom');
				break;
			case 'left':
				left = baseLeft - tooltipWidth - el.margin;
				top = baseTop + (baseHeight / 2) - (tooltipHeight / 2);
				$el.addClass('left');
				break;
			case 'right':
				left = baseLeft + baseWidth + el.margin;
				top = baseTop + (baseHeight / 2) - (tooltipHeight / 2);
				$el.addClass('right');
				break;
			default:
				//bottom
				left = baseLeft + (baseWidth / 2) - (tooltipWidth / 2);
				top = baseTop + baseHeight + el.margin;
				if (left < 0) {
					// right
					left = baseLeft + baseWidth + el.margin;
					top = baseTop + (baseHeight / 2) - (tooltipHeight / 2);
					$el.addClass('right');
				} else if (top + tooltipHeight > screen.Height) {
					left = baseLeft + (baseWidth / 2) - (tooltipWidth / 2);
					top = baseTop - tooltipHeight - el.margin;
					$el.addClass('top');
				} else if (left + tooltipWidth > screen.width) {
					left = baseLeft - tooltipWidth - el.margin;
					top = baseTop + (baseHeight / 2) - (tooltipHeight / 2);
					$el.addClass('left');
				} else {
					$el.addClass('bottom');
				}
			}
			$el.css({
				'left': left + 'px',
				'top': top + 'px'
			});

			switch (el.animation) {
			case 'slide':
				var height = el.offsetHeight;
				$(el).css('height', '0px');
				$(el).animate({
					'height': height + 'px'
				}, parseInt(el.animationtime, 10));
				$(el).css('height', 'auto');
				break;
			case 'fade':
				$(el).css('opacity', '0');
				$(el).animate({
					'opacity': '1'
				}, parseInt(el.animationtime, 10));
				break;
			default:
				$(el).css('display', 'block');
				break;
			}

			el.currentstate = 'opened';

			if ($.alopex.util.isValid(callback)) {
				if (typeof callback === 'string') {
					window[callback].apply();
				} else {
					callback.apply();
				}
			}
		},

		close: function(el, callback) {
			var $el = $(el);
			var $base = $(el.base);

			$el.removeClass('top bottom left right');
			switch (el.animation) {
			case 'slide':
				$(el).animate({
					'height': '0px'
				}, parseInt(el.animationtime, 10), function() {
					$(el).css({
						'height': 'auto',
						'display': 'none'
					});
				});
				break;
			case 'fade':
				$(el).fadeOut(el.animationtime, function(e) {
					$(el).css('display', 'none');
				});
				break;
			default:
				$(el).css('display', 'none');
				break;
			}
			el.currentstate = 'closed';

			if ($.alopex.util.isValid(callback)) {
				if (typeof callback === 'string') {
					window[callback].apply();
				} else {
					callback.apply();
				}
			}
		},

		toggle: function(el, callback) {
			if (el.currentstate === 'opened') {
				$(el).close(callback);
			} else {
				$(el).open(callback);
			}
		}

	});

})(jQuery);
(function($) {
  
  $.alopex.widget.tree = $.alopex.inherit($.alopex.widget.object, {
    widgetName: 'tree',
    defaultClassName: 'af-tree',
    eventHandlers: {
      cancelEvent: {event: 'selectstart', handler: '_cancelEventHandler'}
    },
    setters: ['tree', 'createNode', 'expand', 'collapse', 'expandAll', 'collapseAll', 
              'deleteNode', 'editNode', 'setSelected', 'toggleCheckbox', 
              'toggleExpand', 'setDataSource'],
    getters: ['getNode', 'getSelectedNode', 'getCheckedNodes'],
    
    init: function(el, options) {
      this.refresh(el);
    },
    
    
    toggleExpand: function(el, node) {
      if(node === undefined) {
        node = el;
      } else {
        node = node.node;
      }
      $.alopex.widget.tree._toggle(node);
    },
    
    _toggle: function(li) {
      if(!$.alopex.util.parseBoolean($(li).attr('data-expand'))){
        if ($(li).find('ul').length > 0) {
          $.alopex.widget.tree._expand(li);
        }
      }else{
        $.alopex.widget.tree._collapse(li);
      }
    },
    
    toggleCheckbox: function(el) {
      if($(el).attr('data-checkbox') !== 'visible') {
        $(el).attr('data-checkbox', 'visible');
        $(el).find('input[type="checkbox"]').css('display', 'inline-block');
      } else {
        $(el).removeAttr('data-checkbox');
        $(el).find('input[type="checkbox"]').css('display', 'none');
      }
    },
    
    expand: function(el, node) {
      if(node === undefined) {
        node = el;
      }
      var li = node.node;
      $.alopex.widget.tree._expand(li);
    },
    
    _expand: function(li) {
      var el = $(li).closest('ul');
      $(li).attr('data-expand', 'true').addClass('af-tree-expanded');
      $(li).find('> ul').css('display', 'block');
      $.alopex.widget.tree._triggerEvent(el, li, 'expand');
    },
    
    collapse: function(el, node) {
      if(node === undefined) {
        node = el;
      }
      var li = node.node;
      $.alopex.widget.tree._collapse(li);
    },
    
    _collapse: function(li) {
      if(li === undefined) {
        li = this;
      }
      var el = $(li).closest('ul');
      $(li).attr('data-expand', 'false').removeClass('af-tree-expanded');
      $(li).find('> ul').css('display', 'none');
      $.alopex.widget.tree._triggerEvent(el, li, 'collapse');
    },
    
    setSelected: function (el, node) {
      var selectedNode = node.node;
      $(selectedNode).closest('[data-type="tree"]').find('[class~=af-pressed]').removeClass('af-pressed');
      $(selectedNode).parents('li').each(function() {
        $.alopex.widget.tree._expand(this);
      });
      $(selectedNode).find('> a').addClass('af-pressed');
    },
    
    expandAll: function(el) {
      $(el).find('.af-tree-node').each(function() {
        $.alopex.widget.tree._expand(this);
      });
    },
    
    collapseAll: function(el) {
      $(el).find('.af-tree-node').each(function() {
        $.alopex.widget.tree._collapse(this);
      });
    },
    
    createNode: function(el, node, data){
      var ul = null;
      if(!$.alopex.util.isValid(node)) {
        ul = node = el;
      } else {
        node = node.node;
        
        ul = $(node).find('ul');
        if(ul.length > 0) {
          ul = ul[0];
        } else {
          ul = $('<ul></ul>').appendTo(node)[0];
        }
      }
      var jsonArray = [data];
      $.alopex.widget.tree._createNode(ul, jsonArray); // same structure
      
      $.alopex.widget.tree.refresh($(node).closest('ul')[0]);
    },

    deleteNode: function(el, node){
      node = node.node;
      var $checkbox = $(node).find('input[type="checkbox"]');
      $checkbox.removeAttr('checked');
      $.alopex.widget.tree._traverseUp($checkbox[0]);
      $(node).remove();
    },
    
    editNode: function(el, node, data){
      node = node.node;
      $(node).find('> a').text(data.text);
      $(node).find('> a > img.af-tree-img').attr('src', data.iconUrl);
      $(node).attr('id', data.id);
    },
    
    getNode: function (el, text, type) {
      if (text !== undefined) {
        text = $.alopex.util.trim(text);
      }
      var node = null;
      if(type === 'id') {
        node = $(el).find('[id="' + text + '"]')[0];
      } else {
        $(el).find('a').each(function () {
          if($.alopex.util.trim($(this).text()) === text) {
            node = $(this).closest('li')[0];
          }
        });
      }
      return $.alopex.widget.tree._getTreeNodeObj(node);
    },
    
    getSelectedNode: function(el) {
      var node = $(el).find('.af-pressed').closest('li')[0];
      return $.alopex.widget.tree._getTreeNodeObj(node);
    },
    
    getCheckedNodes: function(el) {
      var array = [];
      $(el).find('input[type="checkbox"]:checked').each(function() {
        var node = $(this).closest('li')[0];
        array.push($.alopex.widget.tree._getTreeNodeObj(node));
      });
      return array;
    }, 
    
    setDataSource: function(el, data) {
      $(el).empty();
      $.alopex.widget.tree._createNode(el, data); // same structure
      $(el).refresh();
    },
    
    _getTreeNodeObj: function(node) {
      return { text: $.alopex.util.trim($(node).find('> a').text()),
        iconUrl: $(node).find('> a > img.af-tree-img').attr('src'),
        id: $(node).attr('id'), 
        node: node
      };
    },
    
    _createNode: function(ul, jsonArray) {
        for(var i=0; i<jsonArray.length; i++) {
          var item = jsonArray[i];
          var li = $('<li></li>').appendTo(ul)[0];
          if($.alopex.util.isValid(item.id)) {
            $(li).attr('id', item.id);
          }
          var a = $('<a></a>').appendTo(li)[0];
          if($.alopex.util.isValid(item.linkUrl)) {
            $(a).attr('href', item.linkUrl);
          }
          if($.alopex.util.isValid(item.iconUrl)) {
            
            $('<img/>').attr('src', item.iconUrl).appendTo(a);
          }
          $(a).append(item.text);
          
          if($.alopex.util.isValid(item.items)) {
            var subul = $('<ul></ul>').appendTo(li)[0];
            $.alopex.widget.tree._createNode(subul, item.items);
          }
        }
      
    },
    
    refresh: function(el) {
      $.alopex.widget.tree._structure(el);
      $.alopex.widget.tree._removeEvent(el);
      $.alopex.widget.tree._addBasicEvent(el);
      $.alopex.widget.tree._addKeydownEvent(el);
      $.alopex.widget.tree._addCheckbox(el);
      $(el).find('.af-tree-node').each(function() {
        if(!$.alopex.util.parseBoolean($(this).attr('data-expand'))) {
          $.alopex.widget.tree._collapse(this);
        }
      });
      //2depth 이상 하위 li 중 leaf가 아닌 것에는 list-style:none 적용
      $(el).find('li:has(ul)').each(function() {
        $(this).css('list-style', 'none');
      });
    },

    _structure: function(ul) {
      var i;
      if ($(ul).attr('data-type') !== undefined && $(ul).attr('data-type').indexOf('tree') !== -1) {
        if ($(ul).children().length > 0) {
          for (i=0; i < $(ul).children().length; i++) {
            if (i === 0) {
              $($(ul).children()[i]).find('> a').attr('tabindex', 0);
            } else {
              $($(ul).children()[i]).find('> a').attr('tabindex', -1);
            }
          }
        }
      } else {
        if ($(ul).children().length > 0) {
          for (i=0; i < $(ul).children().length; i++) {
            $($(ul).children()[i]).find('> a').attr('tabindex', -1);
          }
        }
      }
      $(ul).find('> li').addClass('af-tree-node').each(function() {
        var $link = $(this).find('> a').addClass('af-tree-link');
        $link.find('> img').addClass('af-tree-img');

        var children = $(this).find('> ul').addClass('class', 'af-tree-group');
        var isExpandable = (children.length > 0);
        if(isExpandable) {
          if($link.siblings('span').length === 0) {
            $('<span></span>').attr('class', 'af-tree-icon').attr('data-expand', 'false')
            .insertBefore($(this).find('> a')[0]);
          }
          $.alopex.widget.tree._structure(children[0]);
        } 
      });
    },
    
    _removeEvent: function(el) {
      $(el).find('.af-tree-icon').unbind('click');
      $(el).find('.af-tree-link').unbind('click')
        .unbind('dbclick').unbind('hoverstart').unbind('focusin');
    },
    
    _triggerEvent: function(el, link, event) {
      var _id= $(link).closest('li').attr('id');
      var _text = $.alopex.widget.tree._getNodeText(link); 
      var _path = $.alopex.widget.tree._getNodePath(link);
      
      var param = {
          id: _id,
          text: _text,
          path: _path
      };
      
      $(el).trigger(event, [param]);
    },

    _addBasicEvent: function(el) {
      $(el).find('.af-tree-icon').bind('click', function(e) {
        var li = e.target.parentNode;
        $.alopex.widget.tree._toggle(li);
      });
      $(el).find('.af-tree-link').bind('dbclick', function(e) {
        var leaf = e.target;
        $.alopex.widget.tree._triggerEvent(el, leaf, 'doubleselect');
        $.alopex.widget.tree._triggerEvent(el, leaf, 'dbclick');
      });
      $(el).find('.af-tree-link').bind('click', function(e) {
        var target = e.currentTarget;
        $(el).find('[class~=af-pressed]').removeClass('af-pressed');
        $(target).addClass('af-pressed');
        $.alopex.widget.tree._triggerEvent(el, target, 'select');
      });
      $(el).find('.af-tree-link').bind('hoverstart', function(e) {
        var target = e.currentTarget;
        $(el).find('[class~=af-hover]').removeClass('af-hover');
        $(target).addClass('af-hover');
        $.alopex.widget.tree._triggerEvent(el, target, 'hover');
      });
      $(el).find('.af-tree-link').bind('hoverend', function(e) {
        var target = e.currentTarget;
        $(target).removeClass('af-hover');
      });
      
//      $(el).find('.af-tree-link').bind('focusin', function(e) {
//        var target = e.target;
//        __ALOG('focusin select');
//        $.alopex.widget.tree._triggerEvent(el, target, 'select');
//      });
    },
    
    _getNodeText: function(leaf) {
      return $.alopex.util.trim($(leaf).text());
    },
    
    _getNodePath: function(leaf) {
      var path = '/' + $.alopex.widget.tree._getNodeText(leaf);
      try{
        while($(leaf).closest('ul').siblings('a').length > 0) {
          leaf = $(leaf).closest('ul').siblings('a')[0];
          path = '/' + $.alopex.widget.tree._getNodeText(leaf) + path;
        }
        return path;
      } catch(e) {
        return path;
      }
      
    },

    _addKeydownEvent: function(el) {
      var i, parent, pass;
      $(el).find('.af-tree-link').bind('focusin click', function(e) {
        $.alopex.widget.tree.currentTree = el;
        $(window).bind('mousedown', function(e) {
          var target = e.target;
          var ul = $(target).closest('ul');
          if(ul.length === 0 || ul[0] !== el) {
            $(document.body).unbind('keydown');
            $(window).unbind('mousedown');
          }
        });
        $(el).unbind('keydown');
        $(el).bind('keydown', function(e) {
          var target = e.target;
          var $selecttarget = $(target), $ul, $leaves;
          var code = e.keyCode !== null ? e.keyCode : e.which;
          switch(code) {
            case 36:  // home
              $selecttarget.removeClass('af-pressed');
              $selecttarget = $($.alopex.widget.tree.currentTree).find('[class~="af-tree-link"]')[0];
              $selecttarget.focus();
              break;
            case 35: // end
              $selecttarget.removeClass('af-pressed');
              target = $($.alopex.widget.tree.currentTree).children('li').last();
              while ($(target).attr('data-expand') === 'true') {
                target = $(target).children('ul').children('li').last();
              }
              $selecttarget = target.find('> [class="af-tree-link"]').focus();
              break;
            case 37: // Left
              if($selecttarget.parent().attr('data-expand') !== 'true') {
                var $parent = $selecttarget.closest('ul').siblings('[class~="af-tree-link"]');
                if($parent.length > 0) {
                  $selecttarget.removeClass('af-pressed');
                  $parent.focus();
                }
              } else {
                $.alopex.widget.tree._toggle($selecttarget.parent()[0]);
              }
              break;
            case 38: // Up
              $ul = $selecttarget.closest('ul');
              $leaves = $ul.find('[class~="af-tree-link"]');
              
              if ($($selecttarget.parent().prev()).attr('data-expand') === 'false') {
                if ($selecttarget.parent().prev().length !== 0){
                  $($selecttarget.parent().prev().find('[class~="af-tree-link"]')[0]).focus();
                  break;
                }
              }
              
              if ($selecttarget[0] === $leaves.first()[0]) {
                $($ul.siblings('a')).focus();
              } else if ($selecttarget[0] === $leaves.last()[0] && $($selecttarget.parent().siblings()[0]).attr('data-expand') === 'false') {
                $($selecttarget.parent().prev().find('[class~="af-tree-link"]')[0]).focus();
              } else {
                pass = false;
                i=$leaves.length-1;
                for(; i>=0; i--) {
                  if(!pass) {
                    if($leaves[i] === $selecttarget[0]) {
                      pass = true;
                    }
                  } else {
                    if($($leaves[i]).closest('ul').css('display') !== 'none') {
                      break;
                    }
                  }
                }
                if(i>=0) {
                  $leaves.removeClass('af-pressed');
                  $($leaves[i]).focus();
                }
              }
              break;
            case 39: // Right
              if($selecttarget.parent().attr('data-expand') !== 'true') {
                $.alopex.widget.tree._toggle($selecttarget.parent()[0]);
              } else {
                if($selecttarget.siblings('ul').find('[class~="af-tree-link"]').length > 0) {
                  $selecttarget.removeClass('af-pressed');
                  $($selecttarget.siblings('ul').find('[class~="af-tree-link"]').first()).focus();
                }
              }
              break;
            case 40: // Down
              $ul = $selecttarget.closest('ul');
              $leaves = $ul.find('[class~="af-tree-link"]');
              
              if ($($selecttarget.parent()).attr('data-expand') === 'false') {
                if ($selecttarget.parent().next().length !== 0){
                  $($selecttarget.parent().next().find('[class~="af-tree-link"]')[0]).focus();
                  break;
                }
              } 
              
              if ($selecttarget[0] === $leaves.last()[0]) {
                parent = $ul.parent();
                while (parent.next().length === 0) {
                  parent = parent.closest('ul').parent();
                  if (parent[0] === undefined) {
                    return;
                  }
                }
                $(parent.next().find('[class~="af-tree-link"]')[0]).focus();
              } else if ($selecttarget[0] === $leaves.first()[0] && $($leaves.first().parent()).attr('data-expand') === 'false'
                  && $leaves.first().siblings('span').length > 0 && $selecttarget.parent().siblings().length === 0) {
                if ($($ul).attr('data-type') !== 'tree') {
                  parent = $ul.parent();
                  while (parent.next().length === 0) {
                    parent = parent.closest('ul').parent();
                  }
                  $(parent.next().find('[class~="af-tree-link"]')[0]).focus();
                } else {
                  if ($selecttarget.parent().next().length > 0) {
                    $($selecttarget.parent().next().find('[class~="af-tree-link"]')[0]).focus();
                  }
                }
              } else {  
                pass = false;
                i=0;
                for(; i<$leaves.length; i++) {
                  if(!pass) {
                    if($leaves[i] === $selecttarget[0]) {
                      pass = true;
                    }
                  } else {
                    if($($leaves[i]).closest('ul').css('display') !== 'none') {
                      break;
                    }
                  }
                }
                if(i<$leaves.length) {
                  $leaves.removeClass('af-pressed');
                  $($leaves[i]).focus();
                }
              }
              break;
            default:
              return;
          }
          e.stopPropagation();
          e.preventDefault();
        });
      });
    },
    
    _addCheckbox: function(el) {
      $(el).find('.af-tree-link').each(function () {
        if($(this).siblings('input[type="checkbox"]').length === 0) {
          var $checkbox = $('<input type="checkbox"/>').insertBefore(this);
          $checkbox.attr('data-type', 'checkbox')
          .css('display', 'none').checkbox()
          .bind('change click', $.alopex.widget.tree._checkboxHandler);
          $checkbox.attr('style', $checkbox.attr('style') + ';');
        }
      });
      if($(el).attr('data-checkbox') === 'visible') {
        $(el).find('input[type="checkbox"]').css('display', 'inline-block');
      }
    },
    
    _checkboxHandler: function (e) {
      var checkbox = e.currentTarget;
      // 이전 버전에서는 change 이벤트로 처리하였으나, 오페라 브라우져에서 checked attribute 조작시 change 이벤트가 발생안하는 버그로 
      // click 이벤트 사용. setTimeout 사용은 디폴트 액션(상태값 변화) 이후 처리하기 위해서. 
      setTimeout(function() {
        if($(checkbox).is(':checked')) {
          $(checkbox.parentNode).find('input[type="checkbox"]').each(function() {
            this.indeterminate = false;
            this.setAttribute('checked', true);
            this.checked = true;
          });
        } else {
          $(checkbox.parentNode).find('input[type="checkbox"]').removeAttr('checked').each(function() {
            this.indeterminate = false;
            this.removeAttribute('checked');
          });
        }
        $.alopex.widget.tree._traverseUp(checkbox.parentNode);
      }, 100);
    },

    _traverseUp: function(checkbox) {
      var numCheckbox = $(checkbox).closest('ul').find('> li > input').length;
      var numChecked = 0;
      var numIndeterminate = 0;
      $(checkbox).closest('ul').find('> li > input').each(function() {
        if(this.indeterminate) {
          numIndeterminate ++;
        } else if ( $(this).is(':checked')) {
          numChecked ++;
        }
      });
      var parentCheckbox = $(checkbox).closest('ul').siblings('input[type="checkbox"]');
      if(parentCheckbox.length > 0) {
        if(numChecked === 0 && numIndeterminate === 0) {
          parentCheckbox.prop('indeterminate', false);
          parentCheckbox.removeAttr('checked');
          parentCheckbox.each(function() {
            this.indeterminate = false;
            this.removeAttribute('checked');
          });
        } else if(numChecked === numCheckbox) {
          parentCheckbox.prop('indeterminate', false);
          parentCheckbox.attr('checked', 'true');
          parentCheckbox.each(function() {
            this.indeterminate = false;
            this.setAttribute('checked', 'true');
            this.checked = true;
          });
          
        } else { // indeterminate
          parentCheckbox.prop('indeterminate', true);
          parentCheckbox.removeAttr('checked');
          parentCheckbox.each(function() {
            this.indeterminate = true;
            this.removeAttribute('checked');
          });
        }
        $.alopex.widget.tree._traverseUp(parentCheckbox[0]);
      }
    }
  });
  
})(jQuery);
/*!
* Copyright (c) 2012 SK C&C Co., Ltd. All rights reserved.
*
* This software is the confidential and proprietary information of SK C&C.
* You shall not disclose such confidential information and shall use it
* only in accordance with the terms of the license agreement you entered into
* with SK C&C.
*
* Alopex UI Javascript Event Module.
*
* Date : 20140212
*/
(function($) {
  var useClickFallback = true;
  var eventns = '.alopexUiEventModel';
  function _dbg(msg) {
	  $('.alopex-event-debug').text(msg)
  }
  //__ALOG('loaded');
  var state = {}, currentState = {}, istouch, statecount = 0, trigger = {},
  timeoutTrigger = [], threshold = {}, event = {}, eventCancelPair = {},
  allEvent = [], movingEvent = [], processor = {},
  startevent, moveevent, endevent, name;

  function createState() {
    var obj = {};
    obj.id = statecount++;
    obj.entry = obj.doing = obj.exit = null;
    obj.transition = [];
    return obj;
  }

  function createTransition(to, trigger, guard, effect) {
    var obj = {};
    obj.to = to || null;
    obj.trigger = trigger || null;
    obj.guard = guard || null;
    obj.effect = effect || null;
    return obj;
  }

  //system base setup
  istouch = 'ontouchstart' in window;
  if(istouch) {
	  useClickFallback = false;
  }
  if(false) {
    startevent = (istouch ? 'touchstart' : 'mousedown')+eventns;
    moveevent = (istouch ? 'touchmove' : 'mousemove')+eventns;
    endevent = istouch ? 'touchend'+eventns+' touchcancel'+eventns : 'mouseup'+eventns;
  } else {
    startevent = istouch ? 'touchstart' : 'mousedown';
    startevent += eventns;
    startevent += ' keydown' + eventns;
    moveevent = istouch ? 'touchmove' : 'mousemove';
    moveevent += eventns;
    endevent = istouch ? 'touchend'+eventns+' touchcancel'+eventns : 'mouseup'+eventns;
    endevent += ' keyup' + eventns;
  }
  //define state transition trigger
  trigger.down = null;
  trigger.move = null;
  trigger.up = null;
  trigger.timeout = null;

  for (name in trigger) {
    trigger[name] = name;
  }

  //define supported event
  event.pressed = null;
  event.unpressed = null;
  event.move = null;
  //hover event
  event.hoverstart = null;
  event.hoverend = null;
  event.hovering = null;
  //tap event
  event.tap = null;
  event.singletap = null;
  event.doubletap = null;
  event.tripletap = null;
  event.longtap = null;
  //drag event(based on HTML5 drag&drop api behavior)
  event.drag = null;
  event.dragend = null;
  event.dragstart = null;
  event.dragenter = null;
  event.dragleave = null;
  event.dragover = null;
  event.drop = null;
  //swipe event
  event.swipe = null;
  event.swipemove = null;
  event.swipecancel = null;
  event.swipeleft = null;
  event.swiperight = null;
  event.swipedown = null;
  event.swipeup = null;
  //transform event
  event.pinch = null;
  event.rotate = null;
  event.transform = null;
  event.transformmove = null;
  //general gesture event
  event.gesturestart = null;
  event.gesturechange = null;
  event.gestureend = null;

  for (name in event) {
    event[name] = name;
  }

  //20121108 tap과 singletap에 대한 개발자 가이드의 문제 ->
  //tap의 이름을 singletap으로 하고, singletap을 onetimetap이름으로 정의한다.
  event.tap = 'singletap';
  event.singletap = 'onetimetap';

  for (name in event) {
    allEvent.push(event[name]);
  }
  //tap-singletap 이벤트 처리 관련 문제.
  allEvent.push('tap');

  movingEvent = [event.drag, event.dragenter, event.dragleave, event.dragover,
      event.dragstart, event.dragend, event.drop, event.swipe, event.swipemove,
      event.swipecancel, event.pinch, event.rotate, event.transform,
      event.transformmove, event.gesturestart, event.gesturechange,
      event.gestureend];

  //이벤트 비정상 종료시, 이벤트 시작-종료 처리를 위해 사용.
  eventCancelPair[event.swipe] = event.swipecancel;
  eventCancelPair[event.swipemove] = event.swipecancel;
  eventCancelPair[event.swiperight] = event.swipecancel;
  eventCancelPair[event.swipeleft] = event.swipecancel;
  eventCancelPair[event.swipedown] = event.swipecancel;
  eventCancelPair[event.swipeup] = event.swipecancel;
  eventCancelPair[event.pressed] = event.unpressed;
  eventCancelPair[event.hoverstart] = event.hoverend;
  eventCancelPair[event.hovering] = event.hoverend;

  threshold.move_d = 5; // 단위 : px
  threshold.swipe_d = 100; // 단위 : px
  threshold.swipe_v = 100; // 단위 : px/sec
  threshold.longtap_t = 750; // 단위 : ms
  threshold.ntap_t = 250; // 단위 : ms.
  threshold.hover_v = 100;// 단위 : px/sec

  /****************************************************
   * 엘리먼트에 직접 가해지는 raw 이벤트 및 해당 엘리먼트 처리에 대한 low-level함수
   ***************************************************/
  //특정 element로 부터 data-event 값을 이용하여 이벤트 핸들러를 생성한다.
  var attrEventHandler = function(elem, name) {
    if(!elem || !name) {
      return null;
    }
    if(!$(elem).attr('data-'+name)) {
      return null;
    }
    var func = new Function('event, aevent', ''+ $(elem).attr('data-'+name) + ';');
    return func;
  };
  
  var downHandler = function(e) {
    var returnValue = true;
    var actualtrigger = trigger.down;

    if (e.which && !(e.which === 1 || e.which === 13 || e.which === 32)) {
      return;
    }
    
//    if(e.type == 'keydown' && e.target.tagName == "A") {
//      $(e.target).one('click', function(ev){ev.preventDefault();});
//    }
    
    if (e.type === 'touchstart' && e.originalEvent.touches.length > 1) {
      //touch 손가락 증가에 대해서 move로 처리.
      actualtrigger = trigger.move;
    }
    advanceState(actualtrigger, e);
    return returnValue;
  };
  var lp = null; 
  var moveHandler = function(e) {
    //IE7-8에서 mousemove가 무한히 발생.
	if(!istouch) {
	    if(!lp) {
	      lp = {};
	      lp.x = e.pageX;
	      lp.y = e.pageY;
	    } else {
	      if(lp.x === e.pageX && lp.y === e.pageY) {
	        return;
	      }
	      lp.x = e.pageX;
	      lp.y = e.pageY;
	    }
	}
    advanceState(trigger.move, e);
  };

  var upHandler = function(e) {
    var actualtrigger = trigger.up;
    if (e.which && !(e.which === 1 || e.which === 13 || e.which === 32)) {
      //__ALOG(e.which);
      return;
    }
    if (e.type === 'touchend' && e.originalEvent.touches.length > 0) {
      //touch 손가락 감소에 대해서 move로 처리.
      actualtrigger = trigger.move;
    }
    advanceState(actualtrigger, e);
  };

  var isStayingStill = function(e) {
    if ($(currentState.pressedElement)[0] === $(e.target)[0]) {
      return true;
    }
    return false;
  };

  var isMovedOverElement = function(e) {
    if (!currentState.currentElement) {
      return false;
    }
    if (currentState.currentElement !== currentState.previousElement) {
      return true;
    }
    return false;
  };
  
  var _preventDefault = function (e){
    e.preventDefault();
  };

  var extendEventObject = function(eobj, origin) {
    $.each(['target','pageX','pageY','which','metakey',
            'relatedTarget', 'clientX', 'clientY','offsetX','offsetY'], 
      function(idx, val) {
        eobj[val] = origin[val];
      }
    );
    eobj.originalEvent = origin;
    eobj.isOriginalDefaultPrevented = function() {
      return !!this.originalDefaultPrevented;
    };
    eobj.preventOriginalDefault = function() {
      this.originalDefaultPrevented = true;
    };
    eobj.isOriginalPropagationStopped = function() {
      return !!this.originalPropagationStopped;
    };
    eobj.stopOriginalPropagation = function() {
      this.originalPropagationStopped = true;
    };
  };

  //마우스/키보드 외의 수단에서 인위적으로 .click()을 실행하는 경우에 대한 우회책 구현. 
  //data-tap attribute를 가진 엘리먼트에 대한 click에서 이를 처리. 
  $(function(){
    if(!useClickFallback) return;
    $(document.body)
      .off('.alopexworkaround')
      .on('click.alopexworkaround', '[data-tap]', function(e) {
        //label과 input[type="checkbox|radio"] 에 대해서는 우회책을 적용하지 않는다.
        var tagName = String(this.tagName).toUpperCase();
        if(tagName === "LABEL") return;
        if(tagName === "INPUT") {
          var type = String(this.type).toLowerCase();
          if(type === "checkbox" || type === "radio") return;
        }
        //data-tap에 의해 이벤트가 발생했을경우에는 실행할 필요가 없다.
        var $this = $(this);
        var tapped = $this.data('alopex-ui-data-tap');
        $this.data('alopex-ui-data-tap',null);
        if(tapped) { 
          return;
        }
        $this.data('alopex-ui-data-tap-keyup', true);
        var attrEvent = attrEventHandler(this, event.tap);
        if($.isFunction(attrEvent)) {
          e.type = event.tap;
          return attrEvent.call(this, e);
        }
        if(event.tap !== "tap") {
          attrEvent = attrEventHandler(this, "tap");
          if($.isFunction(attrEvent)) {
            e.type = "tap";
            return attrEvent.call(this, e);
          }
        }
      });
  });
  
  var triggerEvent = function(e, elem, eventname) {
    var arg = Array.prototype.slice.call(arguments, 3),
        el = $(elem), eobj = $.Event(eventname);
    if (arg.length && typeof arg[0] === typeof [] && arg[0].length > 0) {
      arg = arg[0];
    }
    //touchcancel이 호출된 경우 무조건 현재 이벤트의 cancelpair를 호출하도록 한다.
    if(e.type==='touchcancel') {
      triggerCancel(e);
      return;
    }
    //data attribute event handler를 생성하고, 일회용으로 bind 함.
    var attrEvent = attrEventHandler(elem, eventname);
    if(attrEvent && $ === window['jQuery']) { //20130323 attribute custom event의 이중실행 방지
      el.one(eventname, attrEvent);
      if(useClickFallback && eventname === "tap") {
        el.data('alopex-ui-data-tap', true);
        if(e.type === "keyup" && el.data('alopex-ui-data-tap-keyup')) {
          el.off(eventname, attrEvent);
          el.data('alopex-ui-data-tap-keyup', null);
          el.data('alopex-ui-data-tap', null);
        }
      }
    }
    
    //singletap-tap 구분에 대한 문제 처리 위한 임시 코드.
    //event.tap이 singletap으로 정의되어 있을 경우 tap이벤트도 같이 발생시키도록 한다.
    if(eventname === event.tap && event.tap === 'singletap') {
      var targ = $.makeArray(arguments);//Array.prototype.slice.call(arguments, 0);
      targ[2] = 'tap';
      triggerEvent.apply(null, targ);
    }
    extendEventObject(eobj, e);
    //event extension에서 우회처리하기 위한 이벤트발생시점의 original type 정보 지정
    if(eventname === "tap" || eventname === "singletap") {
      eobj.origType = e.type;
    }
    el.trigger(eobj, arg);

    if (eobj.isOriginalDefaultPrevented()) {
      try {
        e.preventDefault();
      } catch (err) {
      }
    }
    if (eobj.isDefaultPrevented()) {
      //anchor에 대해서 preventDefault가 지정된 경우,
      //click핸들러에 일회용 preventDefault핸들러를 연결한다.
      for (var i = 0; i < el.length; i++) {
        if (el[i].tagName === 'A' ||
            (el[i].tagName === 'BUTTON' && el[i].type === 'submit')) {
          $(el[i]).one('click', _preventDefault);
        }
      }
    }
    if (eobj.isOriginalPropagationStopped()) {
      try { //originalEvent가 invalidated된 경우 IE에서 Exception 발생
        e.stopPropagation();
      } catch (err) {
      }
    }

    if (eventCancelPair[eventname]) {
      var c = eventCancelPair[eventname];
      arg[0] = c;
      currentState.needCancel[c] = {
        elem: elem,
        arg: arg
      };
    }
  };

  var triggerCancel = function(e) {
    for (var prop in currentState.needCancel) {
      var c = currentState.needCancel[prop];
      var eobj = $.Event(c.arg[0]);
      extendEventObject(eobj, e);
      $(c.elem).trigger(eobj, c.arg.slice(1));
    }
    delete currentState.needCancel;
    currentState.needCancel = {};
  };

  /****************************************************
   * Timeout Trigger와 관련된 함수.
   ***************************************************/
  var registerTimeoutFromState = function(st, e) {
    for (var i = 0; i < st.transition.length; i++) {
      var item = st.transition[i];
      if (item.trigger && item.trigger.indexOf(trigger.timeout) !== -1) {
        registerTimeout(item, e);
      }
    }
  };

  var registerTimeout = function(tran, e) {
    var t = tran.trigger.split(trigger.timeout)[1], tvar = null;

    tvar = setTimeout(function() {
      advanceState(tran.trigger, e);
    }, t);
    timeoutTrigger.push(tvar);
  };

  var unregisterTimeout = function() {
    if (timeoutTrigger.length > 0) {
      for (var i = 0; i < timeoutTrigger.length; i++) {
        clearTimeout(timeoutTrigger[i]);
      }
//      delete timeoutTrigger; // commented out by jsHinit
    }
    timeoutTrigger = [];
  };

  /****************************************************
   * 좌표계와 관련된 함수
   ***************************************************/
  var isMoved = function(e) {
    var x = getPageX(e), y = getPageY(e), //XXX multitouch에 대응되지 않음
    dx = currentState.startX - x, dy = currentState.startY - y;

    if (Math.sqrt(dx * dx + dy * dy) >= threshold.move_d) {
      return true;
    }
    return false;
  };

  var getPageX = function(e, trace) {
    var eobj = e;
    trace = trace || currentState.trace;
    if (e.originalEvent && e.originalEvent.touches && e.originalEvent.touches.length > 0) {
      eobj = e.originalEvent;
    }

    if (istouch && eobj.touches && eobj.touches.length > 0) {
      return eobj.touches[0].pageX;
    } else if (eobj.pageX !== undefined && eobj.pageX !== null) {
      return eobj.pageX;
    } else {
      var idx = trace.length - 1;
      if (idx < 0) {
        return 0;
      }
      return trace[idx].x;
    }
  };

  var getPageY = function(e, trace) {
    var eobj = e;
    trace = trace || currentState.trace;
    if (e.originalEvent && e.originalEvent.touches && e.originalEvent.touches.length > 0) {
      eobj = e.originalEvent;
    }

    if (istouch && eobj.touches && eobj.touches.length > 0) {
      return eobj.touches[0].pageY;
    } else if (eobj.pageY !== undefined && eobj.pageY !== null) {
      return eobj.pageY;
    } else {
      var idx = trace.length - 1;
      if (idx < 0) {
        return 0;
      }
      return trace[idx].y;
    }
  };

  var getDistance = function(x1, y1, x2, y2) {
    var dx = x1 - x2, dy = y1 - y2;
    return Math.floor(Math.sqrt(dx * dx + dy * dy));
  };

  var getCurrentSpeed = function(e, trace) {
    trace = trace || currentState.trace;
    var obj = {
      value: 0,
      valueX: 0,
      valueY: 0
    };
    if (trace.length > 2) {
      var tr1 = trace.length - 2, tr2 = trace.length - 1, d, dt;

      //마지막과 차마지막 엘리먼트의 좌표값이 완전 동일할 경우 move후 up일 수 있으므로
      //바로 앞의 trace와 비교하도록 한다.
      if (trace[tr1].x === trace[tr2].x && trace[tr1].y === trace[tr2].y) {
        tr1 = trace.length - 3;
      }
      //500ms이내에 기록된 다른 trace가 있을 경우 기록에 사용한다.
      if (trace[tr1 - 1] && (trace[tr1].time - trace[tr1 - 1].time) < 500) {
        tr1--;
      }

      d = getDistance(trace[tr2].x, trace[tr2].y, trace[tr1].x, trace[tr1].y);
      dt = trace[tr2].time - trace[tr1].time;

      var dx = trace[tr2].x - trace[tr1].x, dy = trace[tr2].y - trace[tr1].y;

      obj.value = Math.floor((d / dt) * 1000);
      obj.valueX = Math.floor((dx / dt) * 1000);
      obj.valueY = Math.floor((dy / dt) * 1000);
    } else {

    }
    $.each(['value', 'valueX', 'valueY'], function(i, v) {
      if (obj[v] === Infinity || isNaN(obj[v])) {
        obj[v] = 0;
      }
    });

    return obj;
  };

  var getCurrentMilli = function(t) {
    return new Date().getTime();
  };

  var getCoordinate = function(e, trace) {
    var obj = {}, speed;
    trace = trace || currentState.trace;
    obj.startX = currentState.startX;
    obj.startY = currentState.startY;

    // XXX multitouch에 대응하지 못함.
    obj.pageX = getPageX(e, trace);
    obj.pageY = getPageY(e, trace);

    obj.distance = getDistance(obj.startX, obj.startY, obj.pageX, obj.pageY);
    obj.distanceX = obj.pageX - obj.startX;
    obj.distanceY = obj.pageY - obj.startY;

    speed = getCurrentSpeed(e, trace);
    obj.speed = speed.value;
    obj.speedX = speed.valueX;
    obj.speedY = speed.valueY;

    obj.alignment = '';
    obj.direction = '';

    if (obj.distance < threshold.move_d) {
      obj.alignment = 'stay';
      obj.direction = 'none';
    } else {
      var sin = obj.distanceY / obj.distance;
      if (-0.5 <= sin && sin <= 0.5) {
        //-30~30도, 150~210도
        obj.alignment = 'horizontal';
      } else if (0.866 <= sin || sin <= -0.866) {
        //60~120도, 240~300도
        obj.alignment = 'vertical';
      } else {
        obj.alignment = 'diagonal';
      }

      if (sin <= -0.5 || sin >= 0.5) { //30~150도, 210~330도. down or up
        if (obj.distanceY > 0) {
          obj.direction += 'down';
        } else {
          obj.direction += 'up';
        }
      }
      if (-0.866 <= sin && sin <= 0.866) { //-60~60, 120~240도. right or left
        if (obj.distanceX > 0) {
          obj.direction += 'right';
        } else {
          obj.direction += 'left';
        }
      }
    }

    return obj;
  };

  /****************************************************
   * 이벤트 핸들러 존재여부와 관련된 함수.
   ***************************************************/
  var hasAnyHandler = function(elem, list) {
    var result = false, arr = list || allEvent;
    $.each(arr, function(index, value) {
      if (hasHandler(elem, value)) {
        result = true;
        return false;
      }
    });
    //data-attribute
    var dataevents = ['tap', event.singletap, event.doubletap, event.tripletap,
                      event.longtap];
    $.each(dataevents, function(i,name) {
      if($(elem).attr('data-'+name)) {
        //__ALOG(name);
        result = true;
      }
    });
    return result;
  };

  var hasHandler = function(elem, eventname,toparent) {
    var handler = null;

    if (!elem) {
      return false;
    }
    var $elem = elem.jquery ? elem : $(elem);

    elem = elem.jquery ? $elem[0] : elem;

    if ($._data) {
      handler = $._data($elem[0], 'events');
    } else {
      handler = $elem.data('events');
    }
    //data attribute
    var attr = $elem.attr('data-' + eventname);
    if(attr) {
      handler = {};
      handler[eventname] = attr;
    }
    if (handler && handler[eventname]) {
      return true;
    }
    if(toparent===true) {
	    var $parent = $elem.parent();
	    if($parent.length && $elem.prop('tagName') !== 'BODY') {
	    	return hasHandler($parent, eventname,true);
	    }
    }
    return false;
  };

  var getHandlerOwner = function(e, eventname) {
    var owner = e.target, name = (typeof eventname === typeof '') ?
        [eventname] : eventname,
    hasit = hasAnyHandler(owner, name);
    while (!hasit && !!owner.parentElement) {
      owner = owner.parentElement;
      hasit = hasAnyHandler(owner, name);
    }
    if (eventname && !hasit) {
      return null;
    }
    return owner;
  };

  /****************************************************
   * 이벤트의 실제 판별 및 트리거링 로직을 담은 함수
   ***************************************************/
  processor.swipe = function(e) {
    var coor = getCoordinate(e);
    var el = getHandlerOwner(e, [event.swipe, event.swipeleft,
        event.swiperight, event.swipeup, event.swipedown, event.swipemove,
        event.swipecancel]);
    var condition = $(el).data('swipecondition');

    var currentDistance, conditionDistance;
    var currentSpeed, conditionSpeed;

    if (condition && (condition.direction || condition.alignment)) {
      if (condition.alignment &&
          condition.alignment.indexOf(coor.alignment) === -1) {
        currentDistance = -1;
        currentSpeed = -1;
      } else if (condition.alignment &&
                 condition.alignment.indexOf(coor.alignment) !== -1) {
        if (coor.alignment === 'vertical') {
          currentDistance = Math.abs(coor.distanceY);
          currentSpeed = Math.abs(coor.speedY);
        } else if (coor.alignment === 'horizontal') {
          currentDistance = Math.abs(coor.distanceX);
          currentSpeed = Math.abs(coor.speedX);
        } else {
          currentDistance = Math.abs(coor.distance);
          currentSpeed = Math.abs(coor.speed);
        }
      } else if (condition.direction &&
          condition.direction.indexOf(coor.direction) !== -1) {
        if (coor.direction === 'up') {
          currentDistance = -coor.distanceY;
          currentSpeed = -coor.speedY;
        } else if (coor.direction === 'down') {
          currentDistance = coor.distanceY;
          currentSpeed = coor.speedY;
        } else if (coor.direction === 'left') {
          currentDistance = -coor.distanceX;
          currentSpeed = -coor.speedX;
        } else if (coor.direction === 'right') {
          currentDistance = coor.distanceX;
          currentSpeed = coor.speedX;
        } else {
          currentDistance = -1;
          currentSpeed = -1;
        }
      } else {
        currentDistance = -1;
        currentSpeed = -1;
      }
    } else {
      currentDistance = coor.distance;
      currentSpeed = coor.speed;
    }

    conditionDistance = (condition && condition.distance) ?
        condition.distance : threshold.swipe_d;
    conditionSpeed = (condition && condition.speed) ?
        condition.speed : threshold.swipe_v;

    if (condition && condition.distance && !condition.speed) {
      currentSpeed = -1;
    }
    if (condition && condition.speed && !condition.distance) {
      currentDistance = -1;
    } //조건이 둘다 제시되거나 default를 하는 경우에는 or조건으로 적용하기 위함.

    //distanceX/Y조건 우선.
    if (condition && condition.distanceX) {
      currentDistance = Math.abs(coor.distanceX);
      currentSpeed = -1;
      conditionDistance = Math.abs(condition.distanceX);
      conditionSpeed = 0;
    }
    if (condition && condition.distanceY) {
      currentDistance = Math.abs(coor.distanceY);
      currentSpeed = -1;
      conditionDistance = Math.abs(condition.distanceY);
      conditionSpeed = 0;
    }

    if (currentDistance >= conditionDistance ||
        currentSpeed >= conditionSpeed) {
      $.each(['up', 'down', 'left', 'right'], function(i, v) {
        if (coor.direction === v) {
          triggerEvent(e, currentState.pressedElement,
              'swipe' + coor.direction, coor);
        }
      });
      triggerEvent(e, currentState.pressedElement, event.swipe, coor);
    } else {
      triggerEvent(e, currentState.pressedElement, event.swipecancel, coor);
    }
  };

  processor.ntap = function(e) {
    var ntapevent = [event.tap, event.singletap, event.doubletap,
        event.tripletap], tapcount = currentState.tapcount;
    if (tapcount > 3) {
      tapcount = 3;
    }
    triggerEvent(e, currentState.pressedElement, ntapevent[tapcount]);
    currentState.tapcount = 0;
  };

  //TODO Drag&Drop
  processor.dragstart = function(e) {};
  processor.dragmove = function(e) {};
  processor.dragend = function(e) {};

  /****************************************************
   * State전진을 위한 함수들
   ***************************************************/
  var initCurrentState = function() {
    for(var prop in currentState) {
      if(currentState.hasOwnProperty(prop) &&
          (prop !== 'pointer' && prop !== 'tapcount')) {
        delete currentState[prop];
      }
    }
    currentState.pressedElement = null;
    currentState.currentElement = null;
    currentState.previousElement = null;
    currentState.startX = null;
    currentState.startY = null;
    currentState.trace = [];
    //currentState.tapcount = 0;
    currentState.needCancel = {};
  };

  var enterState = function(st, e) {
    if (!st) { return false; }
    if (st.entry) { st.entry(e); }
    if (st.doing) { st.doing(e); }
  };

  var hasNullTransition = function() {
    var curr = currentState.pointer;
    for (var i = 0; i < curr.transition.length; i++) {
      if (!curr.transition[i].trigger) {
        return true;
      }
    }
    return false;
  };

  var advanceState = function(inputtrigger, e) {
    function _triggerCancel() {
      triggerCancel(e);
    }
    do {
      var curr = currentState.pointer, appliedTransition = null;

      currentState.previousElement = currentState.currentElement;
      currentState.currentElement = e.target;

      var tmptrace = {};
      tmptrace.time = getCurrentMilli();
      tmptrace.x = getPageX(e);
      tmptrace.y = getPageY(e);
      if( currentState.trace.length === 0 ||
          (tmptrace.x !== currentState.trace[currentState.trace.length-1].x ||
          tmptrace.y !== currentState.trace[currentState.trace.length-1].y) ) {
        currentState.trace.push(tmptrace);
      }
      //__ALOG(inputtrigger + ','+currentState.pointer.name+','+currentState.trace.length);
      
      for (var i = 0; i < curr.transition.length; i++) {
        var item = curr.transition[i];

        if (item.trigger !== inputtrigger && item.trigger !== null) {
          continue;
        }

        if (item.guard === null || (typeof item.guard === 'function' && item.guard(e))) {
          appliedTransition = item;
          break;
        }
      }

      if (!appliedTransition) {
        //현재 state에서 적용가능한 state transition이 없는데 down 이 일어났다면
        //state 진행의 에러로 간주하고 최초 state로 이동하도록 한다.
        if (inputtrigger === trigger.down) {
          appliedTransition = {
            to: state.pressedinitial,
            effect: _triggerCancel
          };
        } else if (inputtrigger.indexOf(trigger.timeout) !== -1) {
          //timeout이벤트에 의해서 들어오긴 했는데 가드조건을 통과하지 못할 경우.
          unregisterTimeout();
          registerTimeoutFromState(curr, e);
          return false;
        } else {
          return false;
        }
      }

      unregisterTimeout();
      if (curr.exit) {
        curr.exit(e);
      }

      if ((!!appliedTransition) && appliedTransition.effect) {
        appliedTransition.effect(e);
      }

      currentState.pointer = appliedTransition.to;
      curr = currentState.pointer;

      enterState(curr, e);
      registerTimeoutFromState(curr, e);
      inputtrigger = null;
    } while (hasNullTransition());
  };

  /*************************************************************
   * State정의
   *************************************************************/
  state.idle = createState();
  state.hover = createState();
  state.pressedinitial = createState();
  state.unpressed = createState();
  state.pressedinter = createState();
  state.moving = createState();
  state.endmove = createState();

  //iOS6에서 unpressed handler가 alert창 띄운뒤 승인 누를시 down trigger 발생.
  //이를 막기 위해 unpressed로 진입 전 약간의 딜레이를 준다.
  state.unpressedwait = createState();

  state.idle.entry = function(e) {
    initCurrentState();
    $(document).unbind(eventns);
    $(document).bind(startevent, downHandler);
    $(document).bind(moveevent, moveHandler);
    //20130617 tap과 연계한 event state machine관리 문제로 hover를 
    //기본 state machine에서 분리하여 별도 state machine으로 구성한다.
    //handleIdleHover();
  };
  var detectDisabled = function(e) {
    var el = getHandlerOwner(e);
    if ($(el).attr('disabled')) {
      return true;
    }
    return false;
  };
  state.idle.transition.push({
    to: state.pressedinitial,
    trigger: trigger.down,
    guard: function(e) {
      return !detectDisabled(e);
    },
    effect: function(e) {
    }
  });
  var handleIdleHover = function(e) {
    if(!e || !e.target) {
      return;
    }
    var hel = getHandlerOwner(e, [event.hoverstart, event.hovering,
                                  event.hoverend]);
    if(hel && !istouch) {
      addTohover(state.idle.transition);
    } else {
      removeTohover(state.idle.transition);
    }
  };
  var addTohover = function(transition) {
    removeTohover(transition);
    transition.push({
      to: state.hover,
      trigger: trigger.timeout + '25',//과도한 overhead 방지.
      guard: function(e) {
        var el = getHandlerOwner(e, [event.hoverstart, event.hovering,
            event.hoverend]);
        if (el) {
          var cond = $(el).data('hovercondition');
          if (cond && cond.delay) {
            var dt = getCurrentMilli() - currentState.lastHoverTime;
            if (dt > cond.delay) {
              return true;
            } else {
              return false;
            }
          }
          return true;
        }
        return false;
      },
      effect: function(e) {
        currentState.pressedElement = getHandlerOwner(e, [event.hoverstart,
            event.hovering, event.hoverend]);
        currentState.currentElement = getHandlerOwner(e);
        triggerEvent(e, currentState.pressedElement, event.hoverstart,
            getCoordinate(e));
      }
    });
  };
  var removeTohover = function(transition) {
    for(var i=transition.length-1; i >=0; i--) {
      if(transition[i].to === state.hover) {
        transition.splice(i,1);
      }
    }
  };
  state.idle.transition.push({
    to: state.idle,
    trigger: trigger.move,
    guard: function(e) {
      var coor = getCoordinate(e);
      currentState.lastHoverTime = getCurrentMilli();
      //state.idle.entry 항목 참조.
      //handleIdleHover(e);
      if (coor.speed > threshold.hover_v || isMovedOverElement(e)) {
        return true;
      }
      return false;
    },
    effect: function(e) {
    }
  });

  //IE 더블클릭 처리 버그로 인해 idle state에서 down 없이 up 만 발생하는 경우,
  //pressedinitial의 entry와 do를 수행하도록 한다.
  state.idle.transition.push({
    to: state.unpressed,
    trigger: trigger.up,
    guard: function(e) {
      //down없이 keyup이 일어나는 경우에 대해서는 처리하지 않음.
      return !detectDisabled(e) && !(e.which === 13 || e.which === 32);
    },
    effect: function(e) {
      state.pressedinitial.entry(e);
      state.pressedinitial.doing(e);
    }
  });

  state.hover.transition.push({
    to: state.hover,
    trigger: trigger.move,
    guard: function(e) {
      var elem = getHandlerOwner(e, [event.hoverstart, event.hovering,
          event.hoverend]);
      if (currentState.pressedElement !== elem) {
        return false;
      }
      return true;
    },
    effect: function(e) {
      triggerEvent(e, currentState.pressedElement, event.hovering,
          getCoordinate(e));
    }
  });
  state.hover.transition.push({
    to: state.idle,
    trigger: trigger.move,
    guard: function(e) {
      var elem = getHandlerOwner(e, [event.hoverstart, event.hovering,
          event.hoverend]);
      if (currentState.pressedElement !== elem) {
        return true;
      }
      return false;
    },
    effect: function(e) {
      triggerEvent(e, currentState.pressedElement, event.hoverend,
          getCoordinate(e));
    }
  });
  state.hover.transition.push({
    to: state.pressedinitial,
    trigger: trigger.down,
    guard: function(e) {
      return !detectDisabled(e);
    },
    effect: function(e) {
      triggerEvent(e, currentState.pressedElement, event.hoverend,
          getCoordinate(e));
    }
  });

  state.pressedinitial.entry = function(e) {
    //__ALOG('pressedinitial'+e.type+','+currentState.tapcount);
    initCurrentState();
    currentState.tapcount = 0;
    currentState.pressedElement = e.target;//getHandlerOwner(e);
    currentState.currentElement = getHandlerOwner(e);
    currentState.startX = getPageX(e);
    currentState.startY = getPageY(e);//XXX multitouch에 대응하지 못함.

    $(document).unbind(moveevent);
    $(document).unbind(endevent);
    $(document).bind(moveevent, moveHandler);
    $(document).bind(endevent, upHandler);
  };
  state.pressedinitial.doing = function(e) {
    triggerEvent(e, currentState.pressedElement, event.pressed,
        getCoordinate(e));
  };
  state.pressedinitial.transition.push({
    to: state.moving,
    trigger: trigger.move,
    guard: function(e) {
      var result = isMoved(e);
      return result;
    },
    effect: function(e) {

    }
  });
  state.pressedinitial.transition.push({
    //to : state.unpressed,
    to: state.unpressedwait,
    trigger: trigger.up,
    guard: function(e) {
      return !detectDisabled(e);
    },
    effect: function(e) {
    }
  });
  state.pressedinitial.transition.push({
    to: state.idle,
    trigger: trigger.timeout + threshold.longtap_t,
    guard: function(e) {
      return hasHandler(currentState.pressedElement, event.longtap,true);
    },
    effect: function(e) {
      triggerEvent(e, currentState.pressedElement, event.longtap,
          getCoordinate(e));
      triggerEvent(e, currentState.pressedElement, event.unpressed,
          getCoordinate(e));
    }
  });

  var unpressedwait_tr = {
    to: state.unpressed,
    trigger: null,
    guard: null,
    effect: null
  };
  if (istouch) {
    unpressedwait_tr.trigger = trigger.timeout + 50;
  }

  state.unpressedwait.transition.push(unpressedwait_tr);

  state.unpressed.entry = function(e) {
    triggerEvent(e, currentState.pressedElement, event.unpressed,
        getCoordinate(e));
  };
  state.unpressed.doing = function(e) {
    currentState.tapcount++;
    triggerEvent(e, currentState.pressedElement, event.tap);
  };
  state.unpressed.transition.push({
    to: state.idle,
    trigger: trigger.timeout + threshold.ntap_t,
    guard: null,
    effect: function(e) {
      processor.ntap(e);
    }
  });
  state.unpressed.transition.push({
    to: state.pressedinter,
    trigger: trigger.down,
    guard: function(e) {
      return isStayingStill(e) && !isMoved(e);
    },
    effect: null
  });
  state.unpressed.transition.push({
    to: state.pressedinitial,
    trigger: trigger.down,
    guard: function(e) {
      return !isStayingStill(e) || isMoved(e);
    },
    effect: null
  });
  //IE7~9 호환성 문제 - 더블클릭시 mousedown과 click이 생략되는 문제.
  //webbugtrack.blogspot.kr/2008/01/bug-263-beware-of-doubleclick-in-ie.html
  state.unpressed.transition.push({
    to: state.unpressed,
    trigger: trigger.up,
    guard: function(e) {
      //down 없이 keyup 발생시 처리하지 않음. 
      return !(e.which === 13 || e.which === 32);
    },
    effect: function(e) {}
  });

  state.pressedinter.entry = function(e) {
    triggerEvent(e, currentState.pressedElement, event.pressed,
        getCoordinate(e));
  };
  state.pressedinter.transition.push({
    //to : state.unpressed,
    to: state.unpressedwait,
    trigger: trigger.up,
    guard: function(e) {
      return true;
    },
    effect: null
  });
  state.pressedinter.transition.push({
    to: state.pressedinitial,
    trigger: trigger.timeout + threshold.ntap_t,
    guard: null,
    effect: function(e) {
      processor.ntap(e);
    }
  });
  state.pressedinter.transition.push({
    to: state.moving,
    trigger: trigger.move,
    guard: function(e) {
      var result = isMoved(e);
      return result;
    },
    effect: function(e) {
      processor.ntap(e);
    }
  });

  state.moving.doing = function(e) {
    var coor = getCoordinate(e);
    triggerEvent(e, currentState.pressedElement, event.move, coor);
    triggerEvent(e, currentState.pressedElement, event.swipemove, coor);
  };
  state.moving.transition.push({
    to: state.endmove,
    trigger: trigger.up,
    guard: null,
    effect: null
  });
  state.moving.transition.push({
    to: state.moving,
    trigger: trigger.move,
    guard: null,
    effect: null
  });

  state.endmove.doing = function(e) {
    triggerEvent(e, currentState.pressedElement, event.unpressed,
        getCoordinate(e));
    processor.swipe(e);
  };
  state.endmove.transition.push({
    to: state.idle,
    trigger: null,
    guard: null,
    effect: function(e) {}
  });

  for (name in state) {
    state[name].name = name;
  }

  /**************************************************
   * special event 정의 영역. event parameter등을 처리한다.
   *************************************************/

  var specialEventsRegister = function() {
    var specialswipe = ['', 'left', 'right', 'up', 'down'];
    $.each(specialswipe, function(i, v) {
      $.event.special['swipe' + v] = {
        setup: function(data, namespaces, eventHandle) {
          if (!!data) {
            $(this).data('swipecondition', data);
          }
        },
        teardown: function(namespaces) {
          $(this).removeData('swipecondition');
        }
      };
    });

    if(!istouch) {
    var specialhover = [event.hoverend, event.hovering, event.hoverstart];
    var hovertrace = [];
    var hoverhandler = function(e) {
      var ct = {};
      ct.time = getCurrentMilli();
      ct.x = getPageX(e, hovertrace);
      ct.y = getPageY(e, hovertrace);
      hovertrace.push(ct);
      if(hovertrace.length > 5) {
        hovertrace.shift();
      }
      var coor = getCoordinate(e, hovertrace);
      var el = this;
      var data = $(el).data('hovercondition');
      if(e.type === 'mousedown' || e.type === 'mouseout') {
        $(el).trigger('hoverend', coor);//__ALOG('end1');
      } else if(e.type === 'mouseup' || e.type === 'mouseover') {
        $(el).trigger('hoverstart', coor);//__ALOG('start2');
      } else if(e.type === 'mousemove' && e.which === 0) {
        $(el).trigger('hovering', coor);//__ALOG('ing');
      }
    };
    //$(document).on('mousedown mouseup mouseover mousemove mouseout', hoverhandler);
    var rawhover = ['mousedown','mouseup','mouseover','mousemove','mouseout',''];
    $.each(specialhover, function(i, v) {
      $.event.special[v] = {
        setup: function(data, namespaces, eventHandle) {
          if (!!data) {
            $(this).data('hovercondition', data);
          }
        },
        add : function(handleObj) {
          if(handleObj.data) {
            $(this).data('hovercondition', handleObj.data);
          }
          $(this).on(rawhover.join('.alopexeventhover'+v+' '), handleObj.selector || null, hoverhandler);
        },
        teardown: function(namespaces) {
          $(this).removeData('hovercondition');
          $(this).off(rawhover.join('.alopexeventhover'+v+' '), hoverhandler);
        }
      };
    });
    }
    
    //tap계열 이벤트에 대한 jQuery Plugin 구현
    var taps = ['tap', 'singletap'];
    $.each(taps, function(i,v) {
      $.fn[v] = function(handler) {
        if(handler) {
          return this.bind(v, handler);
        } else {
          //tap과 singletap은 동일. 향후 singletap은 제거한다.
          return this.trigger('tap').trigger('singletap');
        }
      };
    });
    if(useClickFallback) {
      //마우스/키보드 외의 수단에서 인위적으로 .click()을 실행하는 경우에 대한 우회책을 
      //jQuery event extension 으로 구현. 
      var f = ["tap","singletap"];
      var fpos = {x:null,y:null};
      $.each(f, function(idx,eventname) {
        $.event.special[eventname] = {
            setup : function(data, eventHandle) {
              //label과 input[type="checkbox|radio"] 에 대해서는 우회책을 적용하지 않는다.
              var tagName = String(this.tagName).toUpperCase();
              if(tagName === "LABEL") return;
              if(tagName === "INPUT") {
                var type = String(this.type).toLowerCase();
                if(type === "checkbox" || type === "radio") return;
              }
              var $this = $(this);
              $this.on('click.alopexuitapworkaround'+eventname, function(e) {
                var tapped = $this.data('alopex-ui-tap-wtapped'+eventname);
                $this.data('alopex-ui-tap-wtapped'+eventname,null);
                if(tapped) {
                  return; 
                }
                var prevd = false;
                var stopp = false;
                
                var eobj = $.Event(eventname);
                //eobj.stopPropagation();
                $this.each(function(){
                  $(this).triggerHandler(eobj,[true]);
                });
                prevd = prevd || eobj.isDefaultPrevented();
                //stopp = stopp || eobj.isPropagationStopped();
                
                $this.data('alopex-ui-tap-wtapped-keyup'+eventname,true);
              })
              .on('mousedown.alopexuitapworkaround'+eventname, function(e) {
                fpos.x = e.pageX;
                fpos.y = e.pageY;
              })
              .on('mouseup.alopexuitapworkaround'+eventname, function(e) {
                var thr = threshold.move_d;
                if(Math.abs(fpos.x - e.pageX) > thr || Math.abs(fpos.y - e.pageY) > thr) {
                	$(this).data('alopex-ui-tap-wtapped'+eventname,true);
                }
              });
            },
            teardown : function() {
              var $this = $(this);
              $this.off('.alopexuitapworkaround'+eventname);
            },
            _default : function(event, data) {
              $(this).data('alopex-ui-tap-wtapped-keyup'+eventname,null);
            },
            handle : function(event,noinc) {
              var $this = $(this);
              var handleObj = event.handleObj;
              var targetData = jQuery.data( event.target );
              var ret = null;
              event.type = handleObj.origType;
              if(!(event.origType === "keyup" && $this.data('alopex-ui-tap-wtapped-keyup'+eventname))) {
                ret = handleObj.handler.apply(this, arguments);
                if(noinc !== true) {
                  $this.data('alopex-ui-tap-wtapped'+eventname, true);
                }
              }
              event.type = handleObj.type;
              return ret;
            }
        };
      });
      
    }
    var tapevents = [event.singletap, event.doubletap, event.tripletap,
                     event.longtap];
    $.each(tapevents, function(i,v) {
      $.fn[v] = function(handler,realHandler) {
        if($.isFunction(handler)) {
          this.on(v, handler);
        } else if($.isPlainObject(handler) && $.isFunction(realHandler)) {
          this.on(v, handler, realHandler);
        } else {
          this.trigger(v);
        }
      };
    });
  };

  //drag & drop 구현.
  // http://api.jquery.com/category/events/event-object/
  //$.event.props.push('dataTransfer');

  /**************************************************
   * 이벤트모듈 초기화
   *************************************************/
  var unbindme = function() {
    $(document).unbind(eventns);
    $(document).unbind(startevent);
    $(document).unbind(moveevent);
    $(document).unbind(endevent);
  };

  function init() {
    unbindme();
    initCurrentState();
    currentState.tapcount = 0;
    currentState.pointer = state.idle;
    enterState(currentState.pointer, {});
  }

  specialEventsRegister();
  init();
})(jQuery);

+(function($){
    //initial convert worker. should run after alopex object has properly constructed.
    $(function() {
        // add jQuery Plugin
        var apis = {};
        for ( var name in $.alopex.widget) {
            for ( var i = 0; i < $.alopex.widget[name].getters.length; i++) {
                var api = $.alopex.widget[name].getters[i];
                apis[api] = null;
            }
        }

        for ( var name in apis) {// Register Alopex UI Getter API
            $.fn[name] = new Function('return $.alopex._getter.call(this, "' + name + '", arguments)');
        }

        apis = {};
        for ( var name in $.alopex.widget) {
            for ( var i = 0; i < $.alopex.widget[name].setters.length; i++) {
                var api = $.alopex.widget[name].setters[i]
                apis[api] = null;
            }
        }

        for ( var name in apis) { // Register Alopex UI Setter API
            $.fn[name] = new Function('return $.alopex._setter.call(this, "' + name + '", arguments)');
        }
        $.alopex.checkBrowser();
        $.alopex.convert('body');

    });
})(jQuery);
