/*! Alopex UI - v2.2.30 - 2014-10-02
* http://ui.alopex.io
* Copyright (c) 2014 alopex.ui; Licensed Copyright. SK C&C. All rights reserved. */
+function($) {
	var attrName = 'data-bind';

	/**
	 * tagname을 소문자 형태로 가져온다. 
	 * @param element
	 * @returns
	 */
	function getTagName(element) {
		return $.trim(element.tagName.toLowerCase());
	}
	
	/**
	 * 
	 * for primitive data.
	 */
	function SimpleData(key, value, parent) {
		this._id = 'SimpleData' + parseInt(Math.random()*1000000);
		this._type = 'SimpleData';
		this._key = key;
		this._value = value;
		this._views = []; // SimpleData에 연결된 view들. //내부적으로 {element: ***, rule: ***}
		this._listeners = []; // set of ComputedData
		this._parent = parent;
	}
	

	SimpleData.prototype.get = function() {
		return this._value;
	};
	SimpleData.prototype.set = function(value) {
		// key가 필요한가? 어짜피 SimpleData 는 viewmodel내에서 특정 키로 매핑되어 있는데, 이게 바뀐다면, viewmodel에서도 변경????
		this._value = value;
		this.updateView();
	};
	
	SimpleData.prototype.reset = function(value) {
		// checkbox 확인 필요.
		for(var i=0; i<this._views.length; i++) {
			var element = this._views[i];
			if(element.tagName.toLowerCase() == 'input' && element.type == 'checkbox') {
				if(element.name) {
					break; // one of group
				} else {
					var value = $(element).attr('value');
					if($.alopex.util.isValid(value)) {
						this._value = formatlist[value][false];
					} else {
						this._value = false;
					}
					return ;
				}
			}
		}
		this._value = '';
	};
	
	SimpleData.prototype.clear = function(exclude) {
		if(exclude && exclude instanceof Array) {
			for(var i=0; i<exclude.length; i++) {
				var selector = 'data-'+exclude[i]+'-model';
				for(var j=0; j<this._views.length; j++) {
					if($(this._views[j]).attr(selector) == this._key) {
						return ;
					}
				}
			}
		}
		this.reset();
		this.updateView();
	};

	SimpleData.prototype.addView = function(element) {
		for ( var i = 0; i < this._views.length; i++) {
			if (element === this._views[i]) {
				return;
			}
		}
		this._views.push(element);
	};

	SimpleData.prototype.removeView = function(element) {
	};

	SimpleData.prototype.emptyView = function() {
		this._views = [];
	};

	SimpleData.prototype.updateView = function() {
		for ( var i = 0; i < this._views.length; i++) {
			var element = this._views[i];
			var rule = new Rule($(element).attr('data-bind'));
			var ctrls = rule.getControls(this._key);
			for ( var j = 0; j < ctrls.length; j++) {
				var ctrl = ctrls[j];
				if (ctrl && Controls[ctrl.control]) {
					if (Controls[ctrl.control].pre) {
						Controls[ctrl.control].pre(ctrl.key, this._value, element, rule, this);
					}
					if (Controls[ctrl.control].render) {
						var result = Controls[ctrl.control].render(this._key, this._value, element, rule, this._parent);
//						if (result) { // with or template case, return datamodel
//							this._parent[this._key] = result;
//						}
					}
				}
			}

		}
		for ( var i = 0; i < this._listeners.length; i++) {
			this._listeners[i].updateView();
		}
	};

	/**
	 * data 지우기. data에 딸린 view를 삭제한다.
	 */
	SimpleData.prototype.remove = function() {
		for ( var i = 0; i < this._views.length; i++) {
			var element = this._views[i];
			element.parentNode.removeChild(element);
		}
	};

	SimpleData.prototype.addListener = function(computed) {
		for ( var i = 0; i < this._listeners.length; i++) {
			if (this._listeners[i] === computed) {
				return;
			}
		}
		this._listeners.push(computed);
	};

	/**
	 * ArrayData는 배열 형태로 다른 데이터 객체를 저장합니다.
	 * 
	 * ArrayData는 data건 viewmodel이건 상관없이 
	 */
	function ArrayData(key, value, parent) {
		this._id = 'ArrayData' + parseInt(Math.random()*1000000);
		this._type = 'ArrayData';
		this._key = key;
		this._views = [];
		this._parent = parent;
		if (value instanceof Array) {
			this._value = value;
		}
	}

	ArrayData.prototype = new SimpleData();
	/**
	 * list값이 셋되면 그 이후 다시 업데이트 븊  
	 */
	ArrayData.prototype.set = function(value) {
		if (value instanceof Array) {
			this._value = value;
			this.updateView();
		}
	};
	
	ArrayData.prototype.reset = function() {
		this._value = [];
	};
	/**
	 * json으로 리턴한다.
	 */
	ArrayData.prototype.get = function() {
		var result = [];
		for ( var i = 0; i < this._value.length; i++) {
			if (this._value[i].get) {
				result.push(this._value[i].get()); // arraydata 내 simpledata
			} else {
				result.push(this._value[i]);
			}
		}
		return result;
	};
	ArrayData.prototype.addItem = function(item) {
		this._value.push(item);
	};
	ArrayData.prototype.removeItem = function(item) {
		for ( var i = 0; i < this._value.length; i++) {
			if (item === this._value[i]) {
				this._value[i].remove(); // SimpleData 이건 viewmodel이건 remove 함수 존재하며, 함수 호출해서 view 없애기.
			}
		}
	};

	//  ArrayData.prototype.remove = function() {
	//    for(var i=0; i<this._value.length; i++) {
	//      // 조건없이 다 없애기.
	//      if(this._value[i] && this._value[i].remove) {
	//        this._value[i].remove();
	//      }
	//       
	//    }
	//  };

	ArrayData.prototype.updateView = function() {
		for ( var i = 0; i < this._views.length; i++) {
			var element = this._views[i];
			var rule = new Rule($(element).attr('data-bind'));
			var ctrls = rule.getControls(this._key);

			for ( var j = 0; j < ctrls.length; j++) {
				var ctrl = ctrls[j];
				if (ctrl && Controls[ctrl.control]) {
					if (Controls[ctrl.control].pre) {
						Controls[ctrl.control].pre(ctrl.key, this._value, element, rule, this);
					}
					
					if (Controls[ctrl.control].render) {
						var result = Controls[ctrl.control].render(this._key, this._value, element, rule, this._parent);
//						if (result) {
//							this._parent[this._key] = result;
//						}
					}
				}
			}

		}
	};

	/**
	 * ComputedData는 한가지 이상의 객체가 함쳐질 경우, 사용됩니다.
	 */
	function ComputedData(key, func, parent) {
		this._id = 'ComputedData' + parseInt(Math.random()*1000000);
		this._type = 'ComputedData';
		this._key = key;
		this._value = func;
		this._views = []; // SimpleData에 연결된 view들. //내부적으로 {element: ***, rule: ***}
		this._parent = parent;
		this.addDependency();
	}
	ComputedData.prototype = new SimpleData();
	ComputedData.prototype.clear = function() {
	};
	ComputedData.prototype.get = function() {
		return value = this._value.apply(this._parent);
	};
	ComputedData.prototype.updateView = function() {
		for ( var i = 0; i < this._views.length; i++) {
			var element = this._views[i];
			var value = this._value.apply(this._parent); // 함수니까 실행 후 binding!!!!
			var rule = new Rule($(element).attr('data-bind'));
			var ctrls = rule.getControls(this._key);
			for ( var j = 0; j < ctrls.length; j++) {
				var ctrl = ctrls[j];
				if (ctrl && Controls[ctrl.control]) {
					if (Controls[ctrl.control].pre) {
						Controls[ctrl.control].pre(this._key, value, element, rule, this);
					}
					if (Controls[ctrl.control].render) {
						var result = Controls[ctrl.control].render(this._key, value, element, rule, this._parent);
					}
				}
			}

		}
	};
	ComputedData.prototype.set = function() {

	};
	ComputedData.prototype.addDependency = function() {
		var regexp = /this.[A-z0-9]+.get/gi;
		var candidate = this._value.toString().match(regexp);
		if (!candidate) {
			return;
		}
		for ( var i = 0; i < candidate.length; i++) {
			var name = $.trim(candidate[i].replace('this.', '').replace('.get', ''));
			if (this._parent[name] && this._parent[name].addListener) {
				this._parent[name].addListener(this);
			}
		}
	};

	/**
	 * 
	 */
	function ObjectData(key, obj, parent, scope) {
		this._id = 'ObjectData' + parseInt(Math.random()*1000000);
		this._type = 'ObjectData';
		this._key = key;
		this._value = obj;
		this._views = [];
		this._scope = scope;
		this._parent = parent;
	}
	ObjectData.prototype = new SimpleData();

	/**
	 * data getter 함수.
	 */
	ObjectData.prototype.get = function() {
		var result = this._value || {};
		for ( var i in this) {
			if(i.indexOf && i.indexOf('_') == 0) {
				continue;
			}
			if (this[i] instanceof SimpleData || this[i] instanceof ArrayData || this[i] instanceof ComputedData || this[i] instanceof ObjectData) {
				result[i] = this[i].get();
			}
		}
		return result;
	}

	ObjectData.prototype.set = function(value) {
		if(typeof value != 'object') {
			return ;
		}
		for(var i in value) {
			if(this[i] && this[i].set) {
				this[i].set(value[i]);
			}
		}
	}
	
	ObjectData.prototype.clear = function(exclude) {
		for(var i in this) {
			if(this[i] && this[i].clear) {
				this[i].clear(exclude);
			}
		}
	}
	
	/**
	 * viewmodel 내에 data, ArrayData, viewmodel 등 다양한 타입의 updateView 함수를 호출.
	 */
	ObjectData.prototype.updateView = function() {
		// SimpleData, ArrayData 같은 경우는 updateView 유무에 따라 처리하지만, ObjectData 경우 하위 자식이 구조화가 안된 경우 존재.
		// 우선 control이 있는지 먼저 찾고, 처리한다.
		
		if (this._views.length > 0) {
			for ( var i = 0; i < this._views.length; i++) {
				var element = this._views[i];
				var rule = new Rule($(element).attr('data-bind'));
				var ctrls = rule.getControls(this._key);
				for ( var j = 0; j < ctrls.length; j++) {
					var ctrl = ctrls[j];
					if (ctrl && Controls[ctrl.control]) {
						if (Controls[ctrl.control].pre) {
							Controls[ctrl.control].pre(ctrl.key, this._value, element, rule, this);
						}
						if (Controls[ctrl.control].render) {
							Controls[ctrl.control].render(this._key, this._value, element, rule, this._parent);
//							if (result) {
//								this._parent[this._key] = result;
//							}
						}
					}
				}

			}
		} else {
			console.log('[ObjectData] no attached view with ', this, '.');
		}
	};
	
	
	
	function generateData(key, value, parent) {
		if(typeof value != 'undefined' && value != null){
			// TODO 이거 undefined 체크 안 해주면 무한루프 돈다.
			
			if(value instanceof Array) { // array data
				return new ArrayData(key, value, parent);
			} else if (typeof value == 'function') {
				return new ComputedData(key, value, parent);
			} else if (typeof value == 'object') {
//				return value; // object일 경우, 나중에 viewmodel로 생성.
				return new ObjectData(key, value, parent);
			} else {
				return new SimpleData(key, value, parent);
			}
		}
		
	}
	
	
	function __function(key, control, element, data, model) {
		var attribute = 'data-'+control+'-model';
		var $element = $(element);
//		if($element.attr(attribute) == key) { // 현재 
//			
//		} else {
		try{
			if(model[key]) { // 이미 다른 뷰에 할당된 모델이 있는 경우,
				if(typeof data[key] == 'function' && model[key]._type != 'ComputedData') {
					model[key] = generateData(key, data[key], model);
				}
				if(model[key]._reset) {
					if(Controls[control].data) {
						value = Controls[control].data(element, key);
						model[key].set(value);
						model[key]._reset = false;
					}
				} else if(data[key] && model[key].get() != data[key]){ // 기존에 모델이 생성되었으나, 새로운 data가 바인드 된 경우,
					model[key].set(data[key])
				}
			} else if (data && data[key]){ // data에 해당 데이터가 존재하는 경우,
				model[key] = generateData(key, data[key], model);
			} else { // re-read from element
				// 해당
				var value;
				if(Controls[control].data) {
					value = Controls[control].data(element, key);
					model[key] = generateData(key, value, model);
				}
			}
			if(model[key] && model[key].addView) {
				model[key].addView(element);
				$element.attr(attribute, key);
				$element.prop(attribute, model[key]);
			}
		}catch(e){
			console.log('[AlopexData] Following control[' + control + '] is not supported');
		}
			
//		}
	}

	/**
	 * ViewModel 과 ObjectData의 차이는 해당 오브젝트의 자식에 대한 처리를 해주는 부분. 
	 */
	function ViewModel(obj, scope, reset, excluded) {
		$.extend(this, {
			_type: "ViewModel",
			_scope: scope || 'body',
			_data: obj,
			_reset: reset
		});
	}
	
	ViewModel.prototype.bindsearch = function(scope) {
		var model = this;
		var data = model._data;
		scope = scope || this._scope;
		
		for(var i in data) {
			var found = false;
			if(!data.hasOwnProperty(i)) {
				continue;
			}
			for(var j in Controls) {
				var selector = 'data-'+j+'-model';
				var predefined = $(scope).find('['+selector+'="'+i+'"]').addBack('['+selector+'="'+i+'"]');
				if(predefined.length > 0) {
					found = true;
					model[i] = $(predefined[0]).prop(selector);
					model[i]._value = (data[i]);
					break;
				}
			}
			if(!found) {
				model[i] = generateData(i, data[i], model);
			};
			var selector = '[' + attrName + '*="' + i + '"]';
			var $target = $(scope).find(selector).addBack(selector);
			$target.each(function() { // search for
				var element = this;
				var $element = $(element);
				var rules = new Rule(element.getAttribute(attrName)); // element.bindrule에 json타입으로 정의 된 rule 정보 assign
				var controls = rules.getControls(i);
				
				for ( var k = 0; k < controls.length; k++) {
					
					var control = controls[k];
					if (control && control.control) { // valid element
						var attribute = 'data-'+control.control+'-model';
//						setRule(element, rules);
						if (model[i] && model[i].addView) { // viewmodel에 해당키로 SimpleData등 다른 키가 있다.
							model[i].addView(element); // data에 view 추가.
							$element.attr(attribute, i);
							$element.prop(attribute, model[i]);
						}
					}
				}
			});
		}
	};
	
	/**
	 * 인자로 주어진 해당 스콥 내에 
	 */
	ViewModel.prototype.search = function(scope) {
		var model = this;
		var excluded = []; // with control 또는 foreach 컨트롤 사용시 제외.
		scope = scope || this._scope;
		$(scope).find('[data-bind*=with]').each(function() {
			var ruleObject = new Rule($(this).attr('data-bind')).object;
			if(ruleObject && ruleObject['with']) {
				excluded.push(this);
			}
		});
		$(scope).find('[data-bind*=foreach]').each(function() {
			var ruleObject = new Rule($(this).attr('data-bind')).object;
			if(ruleObject && ruleObject['foreach']) {
				excluded.push(this);
			}
		});
		
		// 기존에 정의된 모델 탐색.
		// this에 해당 키 밑에 모델을 등록하고, 나중에 활용.
		for(var i in Controls) {
			if(!Controls.hasOwnProperty(i)) {
				return ;
			}
			var selector = ('data-'+i+'-model');
			$(scope).find('['+selector+']').addBack('['+selector+']').each(function() {
				// get Model from this
				var element = this;
				var $element = $(element);
				for(var i=0; i<excluded.length; i++) { // search 할 시 예외 처리.
					if(excluded[i]!=element && $element.closest(excluded[i]).length > 0) {
						return ;
					}
				}
				var predefined = $(element).prop(selector);
				var key = $(element).attr(selector);
				model[key] = predefined;
				if(model._reset) {
					model[key]._reset = true;
				}
			});
		}
		this._reset = false;
		
		$(scope).find('[data-bind]').addBack('[data-bind]').each(function() { // data-model 속성을 가지고 있는 엘리먼트 뽑아서 나머지 엘리먼트 처리.
			// data-bind가 있는 엘리먼트 쭉 돌면서
			var element = this;
			var $element = $(element);
			for(var i=0; i<excluded.length; i++) { // search 할 시 예외 처리.
				if(excluded[i]!=element && $element.closest(excluded[i]).length > 0) {
					return ;
				}
			}
			var ruleObject = new Rule($element.attr('data-bind')).object;
			for(var i in ruleObject) {
				if(!ruleObject.hasOwnProperty(i)) {
					return ;
				}
				var control = i;
				if(control == 'attr' || control == 'css') { // css or attr
					var object = ruleObject[control];
					for(var j in object) {
						if(!object.hasOwnProperty(j)) {
							return ;
						}
						var key = object[j];
						__function(key, control, element, model._data, model);
					}
					
				} else if(control == 'template') {
					var rule = ruleObject[control];
					var key = rule.data || rule.foreach;
					__function(key, control, element, model._data, model);
				} else {
					var key = ruleObject[i];
					__function(key, control, element, model._data, model);
				}
			}
		});
		
		// 화면에는 키는 정의됮 않지만, 데이터를 넣고 뺴는데 사용.
		for(var i in this._data) {
			if(!this._data.hasOwnProperty(i)) {
				return ;
			}
			if(!this[i]) {
				this[i] = generateData(i, this._data[i], this);
			}
		}
	};
	
	ViewModel.prototype.set = function(object) {
		if(typeof object != 'object') {
			return ;
		}
		for(var i in object) {
			if(this[i] && this[i].set) {
				this[i].set(object[i]);
			}
		}
	};
	
	
	/**
	 * data getter 함수.
	 */
	ViewModel.prototype.get = function() {
		var result = {};
		for ( var i in this) {
			if (this[i] instanceof SimpleData || this[i] instanceof ArrayData || this[i] instanceof ComputedData || this[i] instanceof ObjectData) {
				result[i] = this[i].get();
			}
		}
		return result;
	};

	/**
	 * 여기서는 list에 해당하는 viewmodel의 connection은 수행되지 않음.
	 * 현재 이경우, scope이 정해지지 않았기 때문에 수행 불가.
	 */

	//  /**
	//   * viewmodel 내에 data, ArrayData, viewmodel 등 다양한 타입의 updateView 함수를 호출.
	//   */
	ViewModel.prototype.updateView = function() {
		for ( var key in this) {
			if(!this.hasOwnProperty(key)) {
				return ;
			}
			if (key[0] != '_' && this[key] && this[key].updateView) {
				this[key].updateView();
			}
		}
	};
	
	ViewModel.prototype.clear = function (exclude) {
		for(var i in this) {
			if(this[i] && this[i].clear) {
				this[i].clear(exclude);
			}
		}
	};
	//  

	/**
	 * Rule을 내부적으로 구조화해서 관리하도록 한다.
	 * value 프로퍼티에는 data-bind 속성에 정의된 값이 저장.
	 * object 프로퍼티에는 value가 오브젝트로 구조화된 형태로 저장.
	 * 
	 * data-bind 속성을 가지는 모든 엘리먼트의 bindrule 프로퍼티에 해당 룰 객체가 저장.
	 */
	function Rule(value) {
		this.value = value;
		this.object = this.parse(this.value);
	}

	/**
	 * data-bind 속성의 속성값을 넣을 경우, 해당 rule이 json type으로 리턴.
	 * data-bind="value: valuekey, html: htmlkey, attr: {src: srckey, disabled: disablekey}"
	 * {
	 * 	value: valuekey,
	 * 	html: htmlkey
	 * 	attr: {
	 * 		src: srckey,
	 * 		disabled: disablekey
	 * 	}
	 * } 
	 * @param value
	 */
	Rule.prototype.parse = function(value) {
		try {
			if (!value) {
				value = this.value;
			}
			var result = {};
			var ruleRegExp = /[^\s,{}]+\s*:\s*({(\s*[^\s,{}]+\s*:\s*[^\s,{}]+\s*,?)+}|[^\s,{}]+)/gi;
			var bindingRegExp = /[^\s:]+\s*:/i;
			var ruleArray = value.match(ruleRegExp);
			if (ruleArray instanceof Array) {
				for ( var i = 0; i < ruleArray.length; i++) {
					var rule = ruleArray[i];
					var binding = rule.match(bindingRegExp);
					if (binding && binding.length > 0) {
						binding = binding[0];
						rule = $.trim(rule.replace(binding, ''));
						binding = $.trim(binding.replace(':', ''));
						if (rule.indexOf('{') > -1) {
							var index = rule.indexOf('{');
							rule = rule.substring(0, index) + rule.substring(index + 1, rule.length);
							var index = rule.lastIndexOf('}');
							rule = rule.substring(0, index) + rule.substring(index + 1, rule.length);
							result[binding] = this.parse(rule);
							// recursive
						} else {
							result[binding] = rule;
						}
					}
				}
			}
			return result;
		} catch (e) {
			console.log('[AlopexData] Invalid "data-bind" Rule : ' + e);
		}

	};

	/**
	 * 인자로 주어진 키를 가지고 키에 해당하는 컨트롤이 무엇인지 리턴.
	 * 예: 키가 firstname이면, 이 키로 사용되는 컨트롤이 html인지 text인지 리턴.
	 * 사용되는 컨트롤이 하나 이상일 경우, 처리는??????
	 */
	Rule.prototype.getControls = function(key) {
		var candidate;
		var results = [];
		for ( var i in this.object) {
			if (typeof this.object[i] === 'object') { // attribute 나 css
				for ( var j in this.object[i]) {
					if (this.object[i][j] === key) {
						results.push({
							control: $.trim(i),
							key: $.trim(j)
						});
					}
				}
			} else {
				if (this.object[i] === key) {
					results.push({
						control: $.trim(i)
					});
				}
			}
		}
		return results;
	}

	/**
	 * 이 객체는 databind가 지원하는 control 처리 함수의 집합입니다.
	 * 함수의 인자로 다음과 같습니다.
	 * element (필수) 해당 데이터가 사용되는 HTML 엘리먼트.
	 * value (필수) 데이터 바인딩된 데이터.
	 * attribute (옵션)
	 * 
	 * 이 함수가 호출되어야 할 조건은 다음과 같습니다.
	 * 
	 * - 엘리먼트가 해당 컨트롤을 data-bind속성에서 사용하여야 한다.
	 * - 해당 컨트롤 키가 정의되어 있어야 한다.
	 */
	var Controls = {};

	//SimpleData
	Controls["html"] = {
		editable: false, // change 이벤트 시점에 판단하는 기준이 됨.
		data: function(element) {
			return $(element).html();
		},
		render: function(key, value, element, rule, data) {
			element.innerHTML = value;
		}
	};
	Controls["text"] = {
		editable: false,
		data: function(element) {
			return $(element).text();
		},
		render: function(key, value, element, rule, data) {
			element.innerText = value;
		}
	};
	Controls["value"] = {
		editable: true,
		data: function(element) {
			return $(element).val();
		},
		render: function(key, value, element, rule, data) {
			if(typeof value != 'undefined' && value !=null) {
				element.value = value;
			}			
		}
	};

	var formatlist = {
			'y': {
				'true': 'y',
				'false': 'n'
			},
			'n': {
				'true': 'y',
				'false': 'n'
			},
			'yes': {
				'true': 'yes',
				'false': 'no'
			},
			'no': {
				'true': 'yes',
				'false': 'no'
			},
			'Y': {
				'true': 'Y',
				'false': 'N'
			},
			'N': {
				'true': 'Y',
				'false': 'N'
			},
			'YES': {
				'true': 'YES',
				'false': 'NO'
			},
			'NO': {
				'true': 'YES',
				'false': 'NO'
			},
			'0': {
				'true': '1',
				'false': '0'
			},
			'1': {
				'true': '1',
				'false': '0'
			},
			'true': {
				'true': true,
				'false': false
			},
			'false': {
				'true': true,
				'false': false
			},
			'TRUE': {
				'true': 'TRUE',
				'false': 'FALSE'
			},
			'FALSE': {
				'true': 'TRUE',
				'false': 'FALSE'
			}
		};
	Controls["checked"] = {
		editable: true,
		data: function(element, key) {
			var type = $(element).attr('data-type') || element.type;
			var valueAttr = $(element).attr('value');
			var nameAttr = $(element).attr('name');
			if (type === 'checkbox') { // check 박스의 데이터
				if (nameAttr) { // 여러 체크박스가 사용되는 경우,
					//var list = document.getElementsByName(nameAttr);
					var list = $('[name="' + (nameAttr) + '"]');
					var array = [];
					for ( var i=0; i<list.length; i++) {
						if (list[i].checked) {
							array.push(list[i].value);
						}
					}
					return array;
				} else { // 한 체크박스만 사용.
					var model = $(element).prop('data-checked-model');
					var format;
					if(valueAttr) { // 데이터가 있을 경우, input의 value를 확인.
						format = valueAttr;
					} else if(model && model[0] && model[0].get) { // 우선 현재 가지고 있는 데이틀 확인.
						format = model[0].get();
					} 
					if(format != undefined && formatlist[format]) {
						return formatlist[format][element.checked];
					} else {
						// 없으면 true / false
						return element.checked;
					}
				}
			} else { // radio case
				if(element.name) { // radio button은 name이 필수적으로 필요하지만, 없을 경우 발생하는 에러 방지.
					var radioList = $('input[name=' + element.name + ']:checked');
					if (radioList.length > 0) {
						return $(radioList[0]).val();
					}
				}
			}
		},
		render: function(key, value, element, rule, data) {
			var truecheck = false;
			var type = $(element).attr('data-type') || element.type;
			var valueAttr = $(element).attr('value');
			if (type === 'checkbox') { // check 박스의 데이터
				if (value instanceof Array) {
					for ( var i = 0; i < value.length; i++) {
						if (element.value === value[i]) {
							truecheck = true;
							break;
						} else {
							// false
						}
					}
				} else if (typeof value === 'boolean') {
					if (value) {
						truecheck = true;
					} else {
						// false
					}
				} else if (valueAttr){ // value는 array가 아닌데, elemen
					if (valueAttr === value) {
						truecheck = true;
					} else {
						// false
					}
				} else {
					if(formatlist[value] && value == formatlist[value]['true']) {
						truecheck = true;
					} else {
						// false
					}
				}
			} else { // radio case
				if (element.value === value) {
					truecheck = true;
				} else {
					// false
				}
			}
			
			if(truecheck) {
				element.checked = true;
				element.setAttribute('checked', true);
			} else {
				element.checked = false;
				element.removeAttribute('checked');
			}
		}
	};
	// ArrayData
	Controls["options"] = {
		editable: false,
		data: function(element) {
			var ret = [];
			$(element).find('option').each(function() {
				if(!$(this).attr('data-placeholder')) {
					ret.push({
						value : $(this).attr('value'),
						text : $(this).text()
					});
				}
			});
			return ret;
		},
		render : function(key, value, element, rule, data) {
			var $el = $(element);
			var prevVal = $el.val();
			$el.empty();
			if (($el.attr('data-type') == 'select' || $el.attr('data-type') == 'divselect' || $el.attr('data-type') == 'mselect') && $el.attr('data-placeholder')) {
				var text = $el.attr('data-placeholder');
				$el.setPlaceholder(text);
			}
			
			if (value != undefined) {
				for ( var i = 0; i < value.length; i++) {
					var item = value[i];
					var option = document.createElement('option');
					if (typeof item == 'string') {
						option.setAttribute('value', item);
						option.innerHTML = item;
					} else {
						// lowercase and uppercase supported.
						var _value = '';
						if(item.value) {
							_value = item.value;
						} else if(item.VALUE) {
							_value = item.VALUE;
						}
						var _text = '';
						if(item.text) {
							_text = item.text;
						} else if(item.TEXT) {
							_text = item.TEXT;
						} 
						option.setAttribute('value', _value);
						option.innerHTML = _text;
					}
					element.appendChild(option);
				}
			}
			// opitons 리프레쉬 이후 selectedOptions 다시 호출.
			var selectedOptions = $(element).prop('data-selectedOptions-model');
			if (selectedOptions && selectedOptions.get) {
				var selected = selectedOptions.get();
				Controls.selectedOptions.render(key, selected, element, rule, data);
			} else {
				if($.alopex.util.isValid(prevVal)) {
					$(element).val(prevVal);
				}
				
			}
			
			
			if($.fn.multiselect && $(element).is('[data-type="mselect"]')) {
				if($.alopex.util.isConverted(element)) {
					$(element).multiselect('refresh');
				}
			} else {
				$(element).refresh();
			}
			
		}
	};
	
	// ArrayData or SimpleData
	Controls["selectedOptions"] = {
		editable: true,
		data: function(element) {
			return $(element).val() || '';
		},
		render : function(key, value, element, rule, data) {
			if (value instanceof Array) {
				$(element).find("option").prop("selected", false);
				$.each(value, function(i, e) {
					$(element).find("option[value='" + e + "']").prop("selected", true);
				});
			} else {
				$(element).val(value);
			}
			
			if($.fn.multiselect && $(element).is('[data-type="mselect"]')) {
				if($.alopex.util.isConverted(element)) {
					$(element).multiselect('refresh');
				}
			} else {
				$(element).refresh();
			}
		}
	};

	// ObjectData
	Controls["attr"] = {
		editable: false,
		data: function(element, key) {
//			var bind = $(element).attr('data-bind');
//			var rule = new Rule(bind).object.attr;
			
		},
		render: function(key, value, element, rule, data) {
			var ctrls = rule.getControls(key);
			for(var i=0; i<ctrls.length; i++) {
				if(ctrls[i].control == 'attr') {
					$(element).attr(ctrls[i].key, value);
				}
			}
		}
	};

	// ArrayData
	// 이 부분은 value오는 값이 하나라서 쉬운데.
	Controls["foreach"] = {
		editable: false,
		render: function(key, value, element, rule, data) {
			var template = $(element).data('databind-template');
			if (!template) {
				return;
			}
			
			if(data[key]._type == 'ArrayData') {
				$(element).find('[alopex-databind-created=true]').remove();
				for ( var i = 0; i < data[key]._value.length; i++) {
					var newitem = $(template).clone().show();
					newitem.attr('alopex-databind-created', true);
					newitem.appendTo(element);
					if (data[key]._value[i]._type == 'ViewModel') { // ArrayData내의 데이터를 viewmodel로 변
					} else {
						data[key]._value[i] = new ViewModel(data[key]._value[i], newitem, null);
					}
					data[key]._value[i].search(newitem);	// 이 부분 어떻게 풀어 줘야 할것인지....\
					data[key]._value[i].updateView();
				}
			}
			
		},

		/**
		 * render 되기 이전 setting시 호출되는 함수
		 * 
		 */
		pre: function(key, value, element, rule, data) {
			$(element).find('[alopex-databind-created=true]').remove();
//			if (!$(element).data('databind-template')) { // bindtemplate 넣기
				$(element).data('databind-template', element.innerHTML)
//			}
			$(element).find('> *').hide();
		}
	};
	//SimpleData
	Controls["css"] = {
		editable: false,
		render: function(key, value, element, rule, data) {
			var ctrls = rule.getControls(key);
			for(var i=0; i<ctrls.length; i++) {
				if(ctrls[i].control == 'css') {
					$(element).css(ctrls[i].key, value);
				}
			}
		}
	};
	Controls["visible"] = {
		editable: false,
		render: function(key, value, element, rule, data) {
			if (value) {
				$(element).show();
			} else {
				$(element).hide();
			}
		}
	};
	Controls["with"] = {
		editable: false,
		render: function(key, value, element, rule, data) {
			for(var i=0; i<data[key]._views.length; i++) {
				if(data[key]._views[i]) {
					$(data[key]._views[i]).prop('data-with-model', '')
				}
			}
			data[key] = new ViewModel(value, element, false);
			data[key].search(element);
			data[key].updateView();
		}
	};
	Controls["template"] = {
		editable: false,
		pre: function(key, value, element, rule, data) {
			if (!$(element).data('databind-template')) { // bindtemplate 넣기
				var $template = $('#' + rule.object.template.name);
				if ($template.length > 0) {
					$(element).data('databind-template', $('#' + rule.object.template.name).html());
				}
			}
			$(element).empty();
		},

		render: function(key, value, element, rule, data) {
//			var key = rule.object.template[key];
//			data = data[key];
			var template = $(element).data('databind-template');
			if($.alopex.util.isValid(value)) {
				if (value instanceof Array) {
					if(value.length == 0) {
						$(element).remove();
					} else {
						for ( var i = 0; i < value.length; i++) {
							var $each = $(template).appendTo(element);
							data[i] = $.alopex.databind(value[i], $each[0]);
						}
					}
					
				} else {
					var $each = $(template).clone().appendTo(element);
					$.alopex.databind(value, $each[0]);
				}
			}
			
		}
	};

	Controls["if"] = {
		editable: false,
		render: function(key, value, element, rule, data) {
			var valid = true;
			if (!value) {
				valid = false;
			}
			if (value instanceof Array && value.length <= 0) {
				valid = false;
			}
			if (!valid) {
				$(element).hide();
			} else {
			  $(element).show();
			}
		}
	};
	
	
	Controls["grid"] = {
		editable: false,
		render: function(key, value, element, rule, data) {
			var $el = element.jquery? element: $(element);
			if (!$.alopex.util.isValid($(element).attr('data-alopexgrid')) || 
				!$.alopex.util.isValid($.fn.alopexGrid)) {
				return ;
			}
			if($.isPlainObject(value)) {
				// DOTO dataSet을 하면서 pagingObject를 넘기게 되면 이후에는 동적 페이징으로 작동한다.
				// 만일 동적 페이징을 사용하지 않고 한번에 모든 데이터를 로드하여 사용한다면
				// dataSet의 두번째 파라메터로 pagingObject를 넘기지 않는다.
				$el.alopexGrid('dataSet', 
					$.isArray(value.list) ? value.list : [], 
						$el.alopexGrid('readOption').pager? {
						current: value.currentPage,
						total: value.totalRecordCount,
						perPage: value.recordCountPerPage,
						dataLength: value.recordCount
					}:undefined);
			}
		},
		
		data: function(element, key) {
			// grid 체크
			var $el = element.jquery? element: $(element);
			if ($(element).attr('data-alopexgrid')) {
				return ;
			}
			var list = $target.alopexGrid('dataGet');
			for ( var i = 0, l = list.length; i < l; i++) {
				list[i] = AlopexGrid.trimData(list[i]);
			}
			var pageinfo = $target.alopexGrid('pageInfo');
			var data = {
				list: list,
				recordCount: list.length,
				currentPage: pageinfo.current,
				recordCountPerPage: pageinfo.perPage,
				totalRecordCount: pageinfo.dataLength
			};
			data._griddata = true;
			return data;
		}
	};

	/**
	 * 순서를 우선 기술.
	 * 
	 * 1. viewmodel에 object 들어옴.
	 * 2. 아~~ 구조화를 해야 겠구나.
	 * 3. property별로 쭉 돈다.
	 * 4. 만약 value가 SimpleData인 경우, data object 생성후, 해당 view를 찾는다.
	 * 5. 리스트인 경우,
	 * 6. data가 오브젝트 인 경우 무조건 viewmodel 호출.
	 * 7.  
	 */

	/**
	 * 현재 구조에서 추가되어야 할 부분이 어떤 컨트롤에 대한 정의가 더 필요.
	 * 
	 * 
	 * 데이터는 있어, 데이터가 있고, 그에 대한 뷰 매핑은 data-bind로 처리.  
	 * data-bind 내에는 다양한 컨트롤이 있고, 그에 상응하는 로직이 있지
	 * 
	 *  
	 *  
	 */

	if (!$.alopex) {
		$.alopex = {};
	}

	$.alopex.data = {
		control: function(name, method) {
			if(typeof method == 'function') {
				Controls[name] = {
					render: method
				};
			} else if(typeof method == 'object') {
				Controls[name] = {};
				if(method.pre) {
					Controls[name].pre = method.pre;
				}
				if(method.render) {
					Controls[name].render = method.render;
				}
				if(method.data) {
					Controls[name].data = method.data;
				}
				if(method.editable) {
					Controls[name].editable = method.editable;
				}
			}
		},
		bind: function(data, scope) {
			var model = new ViewModel(data, scope, false);
			model.bindsearch();
			model.updateView();
			return model;
		},
		// get the model from the body
		model: function() {
			var scope = 'body';
			var reset = false;
			
			if(typeof arguments[0] == 'undefined') {
				// 아무 인자도 없을 떄.
			} else if(typeof arguments[0] == 'boolean') {
				// reset만 넣는다.
				reset = arguments[0];
			} else {
				scope = arguments[0];
				reset = arguments[1];
			}
			var model = new ViewModel({}, scope, reset);
			model.search();
			model.updateView();
			return model;
		}
	}
	
	function _changeHandler(e) {
		var element = e.currentTarget;
		var $element = $(element);
		var rule = new Rule($(element).attr('data-bind'));
		for ( var i in rule.object) {
			if (Controls[i] && Controls[i].editable && Controls[i].data) {
				var key = rule.object[i];
				var value = Controls[i].data(element, key);
				var attribute = 'data-'+i+'-model';
				if($.alopex.util.isValid($element.attr(attribute))) {
					
					var model = $element.prop(attribute);
					if(model && model.set && model.get() != value) {
						model.set(value);
					}
				}
				$(element).trigger('datachange', [key, value]);
			}
		}
		
	}
	
	$(document).on('change', '[data-bind]', _changeHandler);
	if ((/iphone|ipad/gi).test(navigator.appVersion) || (/android/gi).test(navigator.appVersion)) { // mobile에만 적용.
		$(document).on('input', '[data-bind]', _changeHandler);
	}
	
	$.extend($.alopex, {
		databind: $.alopex.data.bind,
		datamodel: $.alopex.data.model,
		datarule: Rule,
		_rule: $.alopex.datarule
	});
	
	// jQuery Plugin
	$.fn.alopex = function() {
		if(arguments[0] == 'dataSet' || arguments[0] == 'setData') {
			if(typeof arguments[1] == 'object') {
				var data = arguments[1];
				return this.each(function() {
					$.alopex.databind(data, this);
				});
			}
		} else if(arguments[0] == 'dataGet' || arguments[0] == 'getData') {
			return $.alopex.datamodel(this, true).get();
		}
	};
	$.fn.setData = function(object) {
		return this.each(function() {
			$.alopex.databind(object, this);
		});
	};
	$.fn.getData = function() {
		return $.alopex.datamodel(this, true).get();
	};
}(jQuery);



+function($) {
	$.alopex.format = {};
	$.alopex.format.currency = {
		toFormat: function(str) {
			if (str.length > 3) {
				var arr = [];
				if (str.length % 3 !== 0) {
					arr.push(str.substr(0, str.length % 3));
					str = str.substring(str.length % 3);
				}
				while (str.length !== 0) {
					arr.push(str.substr(0, 3));
					str = str.substring(3);
				}
				str = arr.join(',');
			}

			return str;
		},
		toValue: function(formatted) {
			return formatted.replace(new RegExp(',', 'g'), '');
		},
		validate: function(ch) {
			if (ch < 32 || ch >= 48 && ch <= 57 || ch === 127) {
				return true;
			}
			return false;
		}
	};

	$.alopex.format.dollar = {
		toFormat: function(str) {
			if (isNaN(parseInt($.alopex.format.currency.toFormat(str)))) {
				return '';
			} else {
				return '$' + $.alopex.format.currency.toFormat(str);
			}
		},
		toValue: function(formatted) {
			return $.alopex.format.currency.toValue(formatted.replace('$', ''));
		},
		validate: function(ch) {
			return $.alopex.format.currency.validate(ch);
		}
	};

	//  document.addEventListener('keydown', function(e){
	//    var formatStr = e.target.getAttribute('data-bind-format');
	//    if(formatStr) {
	//      var formatList = formatStr.split('|');
	//      for(var i=0; i<formatList.length; i++) {
	//        var format = formatList[i].trim();
	//        if($.alopex.format[format]) {
	//          if(!$.alopex.format[format].validate(e.which)) {
	//            e.preventDefault();
	//          }
	//        }
	//      }
	//    }
	//    
	//  }, false);
	//  
	//  document.addEventListener('keyup', function(e){
	//    var target = e.target;
	//    var formatStr = target.getAttribute('data-bind-format');
	//    
	//    if(formatStr) {
	//      var formatList = formatStr.split('|');
	//      for(var i=0; i<formatList.length; i++) {
	//        var formatName = formatList[i].trim();
	//        if($.alopex.format[formatName]) {
	//          var format = $.alopex.format[formatName];
	//          target.value = format.toFormat(format.toValue(target.value))
	//        }
	//      }
	//    }
	//  }, false);

}(jQuery);
+function($) {
	
	function getParams(serviceId) {
		return $.alopex.datamodel('body').get();
	}

	/**
	 * data source 관련 스펙은 
	 * 
	 * request
	 * 
	 * $.alopex.databind({})
	 * 
	 * $.alopex.datasource.read(serviceId, options)  return response data
	 * $.alopex.datasource.bind(serviceId, options)  return viewmodel object
	 * $.alopex.datasource.update(serviceId, options)
	 * $.alopex.datasource.autosync(serviceId, options)    
	 * 
	 *   
	 */

	// 화면 로딩 시 서비스 로딩 정보를 읽어와서 JS 오브젝트로 들고 있다고 가정.
	//  function Service(obj) {
	//    this.successCallback = obj.success;
	//    this.errorCallback;
	//  
	//    this.requestOption;
	//    this.response; // last response string
	//    this.responseJson; // last response json object
	//  }

	function DataSource() {

		//    this.servicelist = {
		//        key1 : {
		//          "name": "request-name",
		//          "description": "",
		//          "url": "http://localhost:8080/services?id=test&name=test",
		//          "method": "GET",
		//          "headers": "",
		//          "data": "",
		//          "dataMode": "params"
		//        }
		//    };
		//  this.requestlist = {
		//  servicekey: {
		//    data: null,
		//    response : null,
		//    responseObj : null,
		//    datamodel : null
		//  }
		//};

		this.servicelist = {}; // 애는 그냥 설정정보에 있는 내용 다 가져온 것.
		this.requestlist = {}; // already requested.
	}

	DataSource.prototype.loadServiceInfo = function(path, callback) {
		// re-init
		this.servicelist = {};
		this.requestlist = {};

		var that = this;
		$.get(path, function(response) {
			var list = {};
			if (typeof response === 'string') {
				list = JSON.parse(response);
			} else if (typeof response === 'object') {
				list = (response);
			}
			$.extend(that.servicelist, list);
			if(callback && typeof callback == 'function') {
				callback();
			}
			
		});
	};

	DataSource.prototype.isCached = function(serviceId, options) {
		if (!options) {
			return false;
		}
		return (this.requestlist[serviceId] && // requestlist에 해당 서비스 id가 존재함. 
				this.requestlist[serviceId].data === options.data); // 해당 서비스 id의 param data와 동일.
	}

	/**
	 * 추후 filter & sorting 추가 기능 떄문에 제공.
	 * @params options 
	 *  {
	 *  	sucess: function type,
	 *  	error: function type,
	 *  	callback : function type
	 *  } 
	 */
	DataSource.prototype.bind = function(serviceId, options) {
		if(!options) {
			options = {};
		}
		this.successCallback = options.success;
		this.errorCallback = options.error;
		this.callback = options.complete;
		if (this.isCached(serviceId, options)) {
			var responseObj = this.requestlist[serviceId].responseObj;
			this.databinding(serviceId);
		} else {
			// 이전ㅇ
			var serviceInfo = this.servicelist[serviceId];
			if(serviceInfo) {
				
				$.extend(serviceInfo, options, {
					type: serviceInfo.method,
					complete: this._requestCallback,
					error: this._requestErrorCallback,
					success: this._requestSuccessCallback
				});
				if(serviceInfo.staticSchema) {
					serviceInfo.data = $.extend({}, serviceInfo.data, getParams(serviceId));
				}
				
				this.requestlist[serviceId] = {
					data: serviceInfo.data,
					responseText: '',
					responseObject: null
				};
				$.ajax(serviceInfo);
				$.alopex.datasource.object = this;
			}
		}
	};

	DataSource.prototype._requestSuccessCallback = function() {
		// 임시 : 수정할 것...... ㅠ
		var that = $.alopex.datasource.object;
		that.successArguments = arguments;
	};

	DataSource.prototype._requestErrorCallback = function() {
		var that = $.alopex.datasource.object;
		that.errorArguments = arguments;
	};

	DataSource.prototype._requestCallback = function(response, status) {
		var servicekey;
		for ( var i in $.alopex.datasource.servicelist) {
			var url = this.url.split('?')[0].trim();
			if ($.alopex.datasource.servicelist[i].url === url) {
				servicekey = i;
				break;
			}
		}
		var that = $.alopex.datasource.object;

		// response 받아서 this.requestlist 추가 보충.
		try {
			that.requestlist[servicekey].responseText = response.responseText;
			that.requestlist[servicekey].responseObject = JSON.parse(response.responseText);
			var list = that.databinding(servicekey);

			if (status === 'success' && that.successCallback) {
				that.successCallback.apply(this, that.successArguments);
			} else if (status != 'success' && that.errorCallback) {
				that.errorCallback.apply(this, that.errorArguments);
			}

			if (that.callback) {
				that.callback.call(this, arguments[0], arguments[1], list);
			}
		} catch (e) {
		}

	};

	/**
	 * 나중에 data-provider영역 따로 찾는걸로 바꾸기.
	 */
	DataSource.prototype.databinding = function(serviceId) {
		var that = this;
		var viewmodel;
		$candidate = $('[data-provider*="' + serviceId + '"]');
		$candidate.each(function() {
			var providerInfo = this.getAttribute('data-provider');
			var serviceKey = providerInfo.split(':')[0];
			if (serviceId === serviceKey) {
				var datamodel;
				var data;
				if (providerInfo.split(':').length === 1) {
					data = that.requestlist[serviceId].responseObject;
				} else {
					var path = providerInfo.split(':')[1];
					var paths = path.split('.');
					var data = that.requestlist[serviceId].responseObject;

					for ( var i = 0; i < paths.length; i++) {
						data = data[paths[i]];
					}
				}
				viewmodel = $.alopex.databind(data);
				$.alopex.data.servicemodel[serviceId] = viewmodel;
				if(document.createElement) {
					var e = document.createEvent('Events');
					e.initEvent('databind', true, true);
					document.dispatchEvent(e);
				} else {
					$(document).trigger('databind');
				}
				
//				
				//        viewmodels.push(datamodel);
			}
		});

		return viewmodel;
	};

	DataSource.prototype.update = function(serviceId, options, viewmodel) {
		var data = viewmodel.get();
		options.data = data;
		if (options.type) {
			options.method = options.type;
		}

		var serviceInfo = this.servicelist[serviceId];
		$.extend(serviceInfo, options);

		serviceInfo.method = "post";
		$.ajax(serviceInfo);
		$.alopex.datasource.object = this;
	};
	
	/**
	 * data-trigger 속성 정의.
	 */
	DataSource.prototype.search = function(scope) {
		if(!scope) {
			scope = 'body';
		}
		var that = this;
		$(scope).find('[data-trigger]').addBack('[data-trigger]').each(function() {
			var $this = $(this);
			var attr = $this.attr('data-trigger');
			var rule = new $.alopex.datarule(attr);
			
			for(var i in rule.object) {
				if(rule.object[i] == 'load') { // load일 경우 바로 호출.
					that.bind(i);
				} else {
					if(!$this.data('_data_trigger_' + i)) {
						$this.on(rule.object[i], function(e){
							that.bind(i);
						});
						$this.data('_data_trigger_' + i, rule.object[i]);
					}
				}
				
			}
		});
	}
	
	$.alopex.datasource = new DataSource();
//	$.alopex.datasource.loadServiceInfo('/service.json', function() {
//		$.alopex.datasource.search('body');
//	});
	
}(jQuery);