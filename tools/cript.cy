(function(exports) {
	var invalidParamStr = 'Invalid parameter';
	var missingParamStr = 'Missing parameter';

	// app id
	bundleId = [NSBundle mainBundle].bundleIdentifier;

	// mainBundlePath
	bundlePath = [NSBundle mainBundle].bundlePath;

	// document path
	docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

	// caches path
	cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]; 

	// 加载系统动态库
	loadFramework = function(name) {
		var head = "/System/Library/";
		var foot = "Frameworks/" + name + ".framework";
		var bundle = [NSBundle bundleWithPath:head + foot] || [NSBundle bundleWithPath:head + "Private" + foot];
  		[bundle load];
  		return bundle;
	};

	// keyWindow
	keyWindow = function() {
		return UIApp.keyWindow;
	};

	// 根控制器
	rootVc =  function() {
		return UIApp.keyWindow.rootViewController;
	};

	// 找到显示在最前面的控制器
	var _topVc = function(vc) {
		if (vc.presentedViewController) {
        	return _topVc(vc.presentedViewController);
	    }else if ([vc isKindOfClass:[UITabBarController class]]) {
	        return _topVc(vc.selectedViewController);
	    } else if ([vc isKindOfClass:[UINavigationController class]]) {
	        return _topVc(vc.visibleViewController);
	    } else {
	    	var count = vc.childViewControllers.count;
    		for (var i = count - 1; i >= 0; i--) {
    			var childVc = vc.childViewControllers[i];
    			if (childVc && childVc.view.window) {
    				vc = _topVc(childVc);
    				break;
    			}
    		}
	        return vc;
    	}
	};

	topVc = function() {
		return _topVc(UIApp.keyWindow.rootViewController);
	};

	// 递归打印UIViewController view的层级结构
	vcSubviews = function(vc) { 
		if (![vc isKindOfClass:[UIViewController class]]) throw new Error(invalidParamStr);
		return vc.view.recursiveDescription().toString(); 
	};

	// 递归打印最上层UIViewController view的层级结构
	topVcSubViews = function() {
		return vcSubviews(_topVc(UIApp.keyWindow.rootViewController));
	};

	// 获取按钮绑定的所有TouchUpInside事件的方法名
	btnTouchUpEvent = function(btn) { 
		var events = [];
		var allTargets = btn.allTargets().allObjects()
		var count = allTargets.count;
    	for (var i = count - 1; i >= 0; i--) { 
    		if (btn != allTargets[i]) {
    			var e = [btn actionsForTarget:allTargets[i] forControlEvent:UIControlEventTouchUpInside];
    			events.push(e);
    		}
    	}
	   return events;
	};

	// CG函数
	PointMake = function(x, y) { 
		return {0 : x, 1 : y}; 
	};

	SizeMake = function(w, h) { 
		return {0 : w, 1 : h}; 
	};

	RectMake = function(x, y, w, h) { 
		return {0 : PointMake(x, y), 1 : SizeMake(w, h)}; 
	};

	// 递归打印controller的层级结构
	childVcs = function(vc) {
		if (![vc isKindOfClass:[UIViewController class]]) throw new Error(invalidParamStr);
		return [vc _printHierarchy].toString();
	};

	


	// 递归打印view的层级结构
	subviews = function(view) { 
		if (![view isKindOfClass:[UIView class]]) throw new Error(invalidParamStr);
		return view.recursiveDescription().toString(); 
	};

	// 判断是否为字符串 "str" @"str"
	isString = function(str) {
		return typeof str == 'string' || str instanceof String;
	};

	// 判断是否为数组 []、@[]
	isArray = function(arr) {
		return arr instanceof Array;
	};

	// 判断是否为数字 666 @666
	isNumber = function(num) {
		return typeof num == 'number' || num instanceof Number;
	};

	var _Class = function(className) {
		if (!className) throw new Error(missingParamStr);
		if (IsString(className)) {
			return NSClassFromString(className);
		} 
		if (!className) throw new Error(invalidParamStr);
		// 对象或者类
		return className.class();
	};

	// 打印所有的子类
	subClasses = function(className, reg) {
		className = _Class(className);

		return [c for each (c in ObjectiveC.classes) 
		if (c != className 
			&& class_getSuperclass(c) 
			&& [c isSubclassOfClass:className] 
			&& (!reg || reg.test(c)))
			];
	};

	// 打印所有的方法
	var _GetMethods = function(className, reg, clazz) {
		className = _Class(className);

		var count = new new Type('I');
		var classObj = clazz ? className.constructor : className;
		var methodList = class_copyMethodList(classObj, count);
		var methodsArray = [];
		var methodNamesArray = [];
		for(var i = 0; i < *count; i++) {
			var method = methodList[i];
			var selector = method_getName(method);
			var name = sel_getName(selector);
			if (reg && !reg.test(name)) continue;
			methodsArray.push({
				selector : selector, 
				type : method_getTypeEncoding(method)
			});
			methodNamesArray.push(name);
		}
		free(methodList);
		return [methodsArray, methodNamesArray];
	};

	var _Methods = function(className, reg, clazz) {
		return _GetMethods(className, reg, clazz)[0];
	};

	// 打印所有的方法名字
	var _MethodNames = function(className, reg, clazz) {
		return _GetMethods(className, reg, clazz)[1];
	};

	// 打印所有的对象方法
	instanceMethods = function(className, reg) {
		return _Methods(className, reg);
	};

	// 打印所有的对象方法名字
	instanceMethodNames = function(className, reg) {
		return _MethodNames(className, reg);
	};

	// 打印所有的类方法
	classMethods = function(className, reg) {
		return _Methods(className, reg, true);
	};

	// 打印所有的类方法名字
	classMethodNames = function(className, reg) {
		return _MethodNames(className, reg, true);
	};

	// 打印所有的成员变量
	ivars = function(obj, reg){ 
		if (!obj) throw new Error(missingParamStr);
		var x = {}; 
		for(var i in *obj) { 
			try { 
				var value = (*obj)[i];
				if (reg && !reg.test(i) && !reg.test(value)) continue;
				x[i] = value; 
			} catch(e){} 
		} 
		return x; 
	};

	// 打印所有的成员变量名字
	ivarNames = function(obj, reg) {
		if (!obj) throw new Error(missingParamStr);
		var array = [];
		for(var name in *obj) { 
			if (reg && !reg.test(name)) continue;
			array.push(name);
		}
		return array;
	};
})(exports);