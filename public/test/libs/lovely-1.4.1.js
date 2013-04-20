/**
 * lovely.io 'core' module v1.2.0
 *
 * Copyright (C) 2012 Nikolay Nemshilov
 */
(function(undefined) {
  var global = this;
  var A, Array_every, Array_filter, Array_forEach, Array_map, Array_proto, Array_reject, Array_slice, Array_some, Array_splice, Class, Events, Function_bind, H, Hash, L, List, List_call, Lovely, Object_toString, Options, String_trim, bind, check_all_waiting_loaders, ensure_Array, exports, ext, find_host_url, find_module, isArray, isFunction, isNumber, isObject, isString, modules_load_listener_for, modules_load_listeners, trim,
    __hasProp = {}.hasOwnProperty;

  Lovely = function() {
    var args, callback, check_modules_load, current, header, i, module, modules, name, options, script, url, _i, _j, _len, _len1;
    args = A(arguments);
    current = isString(args[0]) ? args.shift() : null;
    options = isObject(args[0]) ? args.shift() : {};
    modules = isArray(args[0]) ? args.shift() : [];
    callback = isFunction(args[0]) ? args.shift() : function() {};
    'hostUrl' in options || (options.hostUrl = Lovely.hostUrl || find_host_url());
    'baseUrl' in options || (options.baseUrl = Lovely.baseUrl || options.hostUrl);
    'waitSeconds' in options || (options.waitSeconds = Lovely.waitSeconds);
    options.hostUrl[options.hostUrl.length - 1] === '/' || (options.hostUrl += '/');
    options.baseUrl[options.baseUrl.length - 1] === '/' || (options.baseUrl += '/');
    for (i = _i = 0, _len = modules.length; _i < _len; i = ++_i) {
      name = modules[i];
      if (name in Lovely.bundle) {
        modules[i] = "" + name + "-" + Lovely.bundle[name];
      }
    }
    check_modules_load = modules_load_listener_for(modules, callback, current);
    if (!check_modules_load()) {
      modules_load_listeners.push(check_modules_load);
      header = document.getElementsByTagName('head')[0];
      for (i = _j = 0, _len1 = modules.length; _j < _len1; i = ++_j) {
        module = modules[i];
        url = (module[0] === '.' ? options.baseUrl : options.hostUrl) + module + ".js";
        module = modules[i] = modules[i].replace(/^[\.\/]+/, '');
        if (!(find_module(module) || find_module(module, Lovely.loading)) && module.indexOf('~') === -1) {
          script = document.createElement('script');
          script.src = url.replace(/([^:])\/\//g, '$1/');
          script.async = true;
          script.type = "text/javascript";
          script.onload = check_all_waiting_loaders;
          header.appendChild(script);
          Lovely.loading[module] = script;
        }
      }
    }
  };

  modules_load_listeners = [];

  check_all_waiting_loaders = function() {
    return global.setTimeout(function() {
      var clean_list, i, listener, _i, _len;
      clean_list = [];
      for (i = _i = 0, _len = modules_load_listeners.length; _i < _len; i = ++_i) {
        listener = modules_load_listeners[i];
        if (!listener()) {
          clean_list.push(listener);
        }
      }
      if (clean_list.length !== modules_load_listeners.length) {
        modules_load_listeners = clean_list;
        check_all_waiting_loaders();
      }
    }, 0);
  };

  modules_load_listener_for = function(modules, callback, name) {
    return function() {
      var module, packages, result, _i, _len;
      packages = [];
      for (_i = 0, _len = modules.length; _i < _len; _i++) {
        module = modules[_i];
        if ((module = find_module(module))) {
          packages.push(module);
        } else {
          return false;
        }
      }
      if ((result = callback.apply(global, packages)) && name) {
        Lovely.modules[name] = result;
        delete Lovely.loading[name];
        check_all_waiting_loaders();
      }
      return true;
    };
  };

  find_module = function(module, registry) {
    var key, match, name, version, versions;
    registry = registry || Lovely.modules;
    module = module.replace(/~/g, '');
    version = (module.match(/\-\d+\.\d+\.\d+.*$/) || [''])[0];
    name = module.substr(0, module.length - version.length);
    version = version.substr(1);
    if (!(module = registry[module])) {
      versions = [];
      for (key in registry) {
        if ((match = key.match(/^(.+?)-(\d+\.\d+\.\d+.*?)$/))) {
          if (match[1] === name) {
            versions.push(key);
          }
        }
      }
      module = registry[versions.sort()[versions.length - 1]];
    }
    return module;
  };

  find_host_url = function() {
    var match, re, script, scripts, _i, _len;
    if (global.document) {
      scripts = document.getElementsByTagName('script');
      re = /^(.*?\/?)core(-.+)?\.js/;
      for (_i = 0, _len = scripts.length; _i < _len; _i++) {
        script = scripts[_i];
        if ((match = (script.getAttribute('src') || '').match(re))) {
          return match[1];
        }
      }
    }
    return Lovely.hostUrl;
  };

  Object_toString = Object.prototype.toString;

  Array_slice = Array.prototype.slice;

  Function_bind = Function.prototype.bind || function() {
    var args, context, method;
    args = A(arguments);
    context = args.shift();
    method = this;
    return function() {
      return method.apply(context, args.concat(A(arguments)));
    };
  };

  String_trim = String.prototype.trim || function() {
    var i, re, str;
    str = this.replace(/^\s\s*/, '');
    i = str.length;
    re = /\s/;
    while (re.test(str.charAt(--i))) {};

    return str.slice(0, i + 1);
  };

  A = function(it) {
    return Array_slice.call(it, 0);
  };

  L = function(it) {
    return new List(it);
  };

  H = function(object) {
    return new Hash(object);
  };

  ext = function(one, another) {
    another == null && (another = {});

    var key;
    for (key in another) {
      if (!__hasProp.call(another, key)) continue;
      one[key] = another[key];
    }
    return one;
  };

  bind = function() {
    var args;
    args = A(arguments);
    return Function_bind.apply(args.shift(), args);
  };

  trim = function(string) {
    return String_trim.call(string);
  };

  isString = function(value) {
    return typeof value === 'string';
  };

  isNumber = function(value) {
    return typeof value === 'number' && !isNaN(value);
  };

  isFunction = function(value) {
    return typeof value === 'function' && Object_toString.call(value) !== '[object RegExp]';
  };

  isArray = function(value) {
    return Object_toString.call(value) === '[object Array]' || value instanceof List;
  };

  isObject = function(value) {
    return Object_toString.call(value) === '[object Object]';
  };

  ensure_Array = function(value) {
    if (isArray(value)) {
      return value;
    } else {
      return [value];
    }
  };

  Class = function(parent, params) {
    var Klass, Super, name, value;
    if (!isFunction(parent)) {
      params = parent;
      parent = Class;
    }
    params || (params = {});
    if (__hasProp.call(params, 'constructor')) {
      Klass = params.constructor;
    } else {
      Klass = function() {
        if (this.$super === undefined) {
          return this;
        } else {
          return this.$super.apply(this, arguments);
        }
      };
    }
    Super = function() {};
    Super.prototype = parent.prototype;
    Klass.prototype = new Super();
    if (parent !== Class) {
      for (name in parent) {
        if (!__hasProp.call(parent, name)) continue;
        value = parent[name];
        Klass[name] = value;
      }
      Klass.prototype.$super = function() {
        this.$super = parent.prototype.$super;
        return parent.apply(this, arguments);
      };
      if (isFunction(parent.prototype.whenInherited)) {
        parent.prototype.whenInherited.call(parent, Klass);
      }
    }
    Klass.__super__ = parent;
    Klass.prototype.constructor = Klass;
    (Klass.include = Class.include).apply(Klass, ensure_Array(params.include || []));
    (Klass.extend = Class.extend).apply(Klass, ensure_Array(params.extend || []));
    Klass.inherit = Class.inherit;
    delete params.extend;
    delete params.include;
    delete params.constructor;
    return Klass.include(params);
  };

  ext(Class, {
    include: function() {
      var key, method, module, parent, super_method, _i, _len;
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        module = arguments[_i];
        module || (module = {});
        for (key in module) {
          if (!(super_method = this.prototype[key] || false)) {
            parent = this.__super__;
            while (parent) {
              if (key in parent.prototype) {
                if (isFunction(parent.prototype[key])) {
                  super_method = parent.prototype[key];
                }
                break;
              }
              parent = parent.__super__;
            }
          }
          method = module[key];
          this.prototype[key] = (function(method, super_method) {
            if (super_method) {
              return function() {
                this.$super = super_method;
                return method.apply(this, arguments);
              };
            } else {
              return method;
            }
          })(method, super_method);
        }
      }
      return this;
    },
    extend: function() {
      var module, _i, _len;
      for (_i = 0, _len = arguments.length; _i < _len; _i++) {
        module = arguments[_i];
        ext(this, module);
      }
      return this;
    },
    inherit: function(methods) {
      return new Class(this, methods);
    }
  });

  List = new Class(Array, {
    constructor: function List(items) {
      if (items !== undefined) {
        Array_splice.apply(this, [0, 0].concat(items));
      }
      return this;
    },
    slice: function() {
      return new this.constructor(Array_slice.apply(this, arguments));
    },
    concat: function(items) {
      return new this.constructor(A(this).concat(A(items)));
    },
    forEach: function() {
      List_call(Array_forEach, this, arguments);
      return this;
    },
    map: function() {
      return new List(List_call(Array_map, this, arguments));
    },
    filter: function() {
      return new this.constructor(List_call(Array_filter, this, arguments));
    },
    reject: function() {
      return new this.constructor(List_call(Array_reject, this, arguments));
    },
    some: function() {
      return List_call(Array_some, this, arguments);
    },
    every: function() {
      return List_call(Array_every, this, arguments);
    },
    toArray: function() {
      return A(this);
    },
    toString: function() {
      return "#<List [" + (A(this)) + "]>";
    }
  });

  Array_proto = Array.prototype;

  Array_slice = Array_proto.slice;

  Array_splice = Array_proto.splice;

  Array_forEach = Array_proto.forEach;

  Array_map = Array_proto.map;

  Array_filter = Array_proto.filter;

  Array_reject = function(callback, scope) {
    return Array_filter.call(this, function() {
      return !callback.apply(scope, arguments);
    });
  };

  Array_some = Array_proto.some;

  Array_every = Array_proto.every;

  List_call = function(method, list, args) {
    var attr_name, call_args;
    if (typeof args[0] === 'string') {
      call_args = A(args);
      attr_name = call_args.shift();
      if (list.length !== 0 && typeof list[0][attr_name] === 'function') {
        args = [
          function(item) {
            return item[attr_name].apply(item, call_args);
          }
        ];
      } else {
        args = [
          function(item) {
            return item[attr_name];
          }
        ];
      }
    }
    return method.apply(list, args);
  };

  Hash = new Class({
    _: null,
    constructor: function Hash(object) {
      this._ = object || {};
      return this;
    }
  });

  Hash.include = function(params) {
    var name, _results;
    Class.include.apply(Hash, arguments);
    _results = [];
    for (name in params) {
      _results.push((function(name) {
        return Hash[name] = function() {
          var args, hash;
          args = A(arguments);
          hash = new Hash(args.shift());
          args = hash[name].apply(hash, args);
          if (args instanceof Hash) {
            args = args._;
          }
          return args;
        };
      })(name));
    }
    return _results;
  };

  Hash.include({
    keys: function() {
      var key, _ref, _results;
      _ref = this._;
      _results = [];
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        _results.push(key);
      }
      return _results;
    },
    values: function() {
      var key, value, _ref, _results;
      _ref = this._;
      _results = [];
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        value = _ref[key];
        _results.push(value);
      }
      return _results;
    },
    empty: function() {
      var key, _ref;
      _ref = this._;
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        return false;
      }
      return true;
    },
    clone: function() {
      return this.merge();
    },
    forEach: function(callback, scope) {
      var key, object, value;
      object = this._;
      for (key in object) {
        if (!__hasProp.call(object, key)) continue;
        value = object[key];
        callback.call(scope, key, value, object);
      }
      return this;
    },
    map: function(callback, scope) {
      var key, object, result, value;
      object = this._;
      result = [];
      for (key in object) {
        if (!__hasProp.call(object, key)) continue;
        value = object[key];
        result.push(callback.call(scope, key, value, object));
      }
      return result;
    },
    filter: function(callback, scope) {
      var data, key, object, value;
      object = this._;
      data = {};
      for (key in object) {
        if (!__hasProp.call(object, key)) continue;
        value = object[key];
        if (callback.call(scope, key, value, object)) {
          data[key] = object[key];
        }
      }
      return new Hash(data);
    },
    reject: function(callback, scope) {
      var data, key, object, value;
      object = this._;
      data = {};
      for (key in object) {
        if (!__hasProp.call(object, key)) continue;
        value = object[key];
        if (!callback.call(scope, key, value, object)) {
          data[key] = object[key];
        }
      }
      return new Hash(data);
    },
    merge: function() {
      var args, data, key, object, value;
      args = A(arguments);
      data = {};
      args.unshift(this._);
      while (args.length > 0) {
        object = args.shift();
        if (object instanceof Hash) {
          object = object._;
        }
        for (key in object) {
          if (!__hasProp.call(object, key)) continue;
          value = object[key];
          data[key] = isObject(value) && !(value instanceof Class) ? Hash.merge((key in data ? data[key] : {}), value) : object[key];
        }
      }
      return new Hash(data);
    },
    toObject: function() {
      return this._;
    }
  });

  Events = {
    _listeners: null,
    on: function() {
      var args, by_name, callback, event, events, listeners, _i, _len, _ref;
      args = Array_slice.call(arguments, 2);
      events = arguments[0];
      callback = arguments[1];
      by_name = false;
      if (typeof callback === 'string') {
        callback = this[callback];
        by_name = true;
      }
      listeners = this._listeners === null ? (this._listeners = []) : this._listeners;
      if (typeof events === 'string') {
        _ref = events.split(',');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          event = _ref[_i];
          listeners.push({
            e: event,
            c: callback,
            a: args,
            n: by_name
          });
        }
      } else if (typeof events === 'object') {
        for (event in events) {
          this.on(event, events[event]);
        }
      }
      return this;
    },
    no: function() {
      var args, callback, event, events, index, listeners, _i, _len, _ref;
      args = Array_slice.call(arguments, 2);
      events = arguments[0];
      callback = arguments[1];
      if (typeof callback === 'string') {
        callback = this[callback];
      }
      listeners = this._listeners === null ? (this._listeners = []) : this._listeners;
      switch (typeof events) {
        case 'string':
          _ref = events.split(',');
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            event = _ref[_i];
            index = 0;
            while (index < listeners.length) {
              if (listeners[index].e === event && (listeners[index].c === callback || callback === undefined)) {
                listeners.splice(index--, 1);
              }
              index++;
            }
          }
          break;
        case 'function':
          index = 0;
          while (index < listeners.length) {
            if (listeners[index].c === events) {
              listeners.splice(index--, 1);
            }
            index++;
          }
          break;
        case 'object':
          for (event in events) {
            this.no(event, events[event]);
          }
      }
      return this;
    },
    ones: function() {
      var args, callback, entry, event, events, listeners, result, _i, _j, _k, _len, _len1, _len2, _ref;
      result = 0;
      args = Array_slice.call(arguments, 2);
      events = arguments[0];
      callback = arguments[1];
      if (typeof callback === 'string') {
        callback = this[callback];
      }
      listeners = this._listeners === null ? (this._listeners = []) : this._listeners;
      switch (typeof events) {
        case 'string':
          _ref = events.split(',');
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            event = _ref[_i];
            for (_j = 0, _len1 = listeners.length; _j < _len1; _j++) {
              entry = listeners[_j];
              result |= entry.e === event && (entry.c === callback || callback === undefined);
            }
          }
          break;
        case 'function':
          for (_k = 0, _len2 = listeners.length; _k < _len2; _k++) {
            entry = listeners[_k];
            result |= entry.c === events;
          }
          break;
        case 'object':
          for (event in events) {
            result |= this.ones(event, events[event]);
          }
      }
      return result === 1;
    },
    emit: function() {
      var args, entry, event, _i, _len, _ref;
      args = A(arguments);
      event = args.shift();
      _ref = this._listeners || [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        entry = _ref[_i];
        if (entry.e === event) {
          entry.c.apply(this, entry.a.concat(args));
        }
      }
      return this;
    }
  };

  Options = {
    options: {},
    setOptions: function(options) {
      var defaults, klass;
      klass = this.constructor;
      defaults = {};
      while (klass) {
        if ('Options' in klass) {
          defaults = klass.Options;
          break;
        }
        klass = klass.__super__;
      }
      this.options = Hash.merge(defaults, options);
      return this;
    }
  };

  exports = ext(Lovely, {
    version: '1.2.0',
    modules: {},
    loading: {},
    baseUrl: '',
    hostUrl: '',
    module: find_module,
    bundle: {},
    A: A,
    L: L,
    H: H,
    ext: ext,
    bind: bind,
    trim: trim,
    isString: isString,
    isNumber: isNumber,
    isFunction: isFunction,
    isArray: isArray,
    isObject: isObject,
    Class: Class,
    List: List,
    Hash: Hash,
    Events: Events,
    Options: Options
  });

  Lovely.modules["core-" + Lovely.version] = Lovely;

  global.Lovely = Lovely;

}).apply(this)


/**
 * lovely.io 'dom' module v1.4.1
 *
 * Copyright (C) 2012 Nikolay Nemshilov
 */
Lovely("dom-1.4.1", [], function() {
  var global = this;
  var exports = {};

  var $, A, Browser, Class, Document, Element, Element_clean_style, Element_computed_styles, Element_create_fragment, Element_events, Element_fragment, Element_insert, Element_make_listeners, Element_parse_style, Element_read_styles, Element_recursively_collect, Element_tmp_cont, Element_wraps, Event, Events_delegation, Form, HTML, Input, L, NodeList, Ready_documents, Style, UID_KEY, UID_NUM, Window, Wrapper, Wrapper_Cache, bind, camelize, core, current_Document, dasherize, delegation_listeners, dimensions_hash, document, elements_cache, ensure_array, exports, ext, extract_scripts, focusio_boobler, global_eval, isArray, isElement, isObject, isString, mouseio_activate, mouseio_emit, mouseio_handler, mouseio_inactive, mouseio_index, mouseio_reset, trim, uid, window, wrap;

  core = this.Lovely.module('core');

  A = core.A;

  L = core.L;

  ext = core.ext;

  trim = core.trim;

  bind = core.bind;

  Class = core.Class;

  isArray = core.isArray;

  isObject = core.isObject;

  isString = core.isString;

  window = global;

  document = window.document;

  HTML = document.documentElement;

  isElement = function(value) {
    return value != null && value.nodeType === 1;
  };

  camelize = function(string) {
    if (string.indexOf('-') === -1) {
      return string;
    } else {
      return string.replace(/\-([a-z])/g, function(match, letter) {
        return letter.toUpperCase();
      });
    }
  };

  dasherize = function(string) {
    return string.replace(/([a-z\d])([A-Z]+)/g, '$1-$2').toLowerCase();
  };

  dimensions_hash = function(args) {
    var hash;
    hash = {};
    if (args.length === 1 && isObject(args[0])) {
      hash = args[0];
    } else {
      if (args[0] !== null) {
        hash.x = args[0];
      }
      if (!(args[1] === null || args[1] === undefined)) {
        hash.y = args[1];
      }
    }
    return hash;
  };

  extract_scripts = function(content) {
    var scripts;
    scripts = "";
    content = content.replace(/<script[^>]*>([\s\S]*?)<\/script>/img, function(match, source) {
      return scripts += source + "\n";
    });
    return [content, scripts];
  };

  global_eval = function(script) {
    if (script) {
      new Element('script', {
        text: script
      }).insertTo(HTML);
    }
  };

  if ('execScript' in window) {
    global_eval = function(script) {
      if (script) {
        window.execScript(script);
      }
    };
  }

  ensure_array = function(value) {
    if (isArray(value)) {
      return value;
    } else {
      return [value];
    }
  };

  UID_KEY = "__lovely_dom_uid_" + (new Date().getTime());

  UID_NUM = 1;

  uid = function(node) {
    return node[UID_KEY] || (node[UID_KEY] = UID_NUM++);
  };

  wrap = function(value) {
    var key;
    if (!(value == null || value instanceof Wrapper)) {
      key = value[UID_KEY];
      if (key && key in Wrapper_Cache) {
        value = Wrapper_Cache[key];
      } else if (value.nodeType === 1) {
        value = new Element(value);
      } else if (value.nodeType === 9) {
        value = new Document(value);
      } else if (value.target != null) {
        value = new Event(value);
      } else if (value.window != null && value.window === value.window.window) {
        value = new Window(value);
      }
    }
    return value;
  };

  Browser = navigator.userAgent;

  if ('attachEvent' in document && !/Opera/.test(Browser)) {
    Browser = 'IE';
  } else if (/Opera/.test(Browser)) {
    Browser = 'Opera';
  } else if (/Gecko/.test(Browser) && !/KHTML/.test(Browser)) {
    Browser = 'Gecko';
  } else if (/Apple.*Mobile.*Safari/.test(Browser)) {
    Browser = 'MobileSafari';
  } else if (/Konqueror/.test(Browser)) {
    Browser = 'Konqueror';
  } else if (/AppleWebKit/.test(Browser)) {
    Browser = 'WebKit';
  } else {
    Browser = 'Unknown';
  }

  NodeList = new Class(core.List, {
    constructor: function NodeList(raw_list, raw_only) {
      if (raw_only === true) {
        for (var i=0, l=this.length=raw_list.length, key; i < l; i++) {
          this[i] = Wrapper_Cache[raw_list[i][UID_KEY]] || new Element(raw_list[i]);
        };

      } else {
        for (var i=0, l=this.length=raw_list.length, key; i < l; i++) {
          this[i] = raw_list[i] instanceof Element ? raw_list[i] : (Wrapper_Cache[raw_list[i][UID_KEY]] || new Element(raw_list[i]));
        };

      }
      return this;
    }
  });

  Wrapper = new Class({
    extend: {
      Cache: [],
      Tags: {},
      set: function(tag, wrapper) {
        Wrapper.Tags[tag.toUpperCase()] = wrapper;
        return Wrapper;
      },
      get: function(tag) {
        return Wrapper.Tags[tag.toUpperCase()];
      },
      remove: function(tag) {
        delete Wrapper.Tags[tag.toUpperCase()];
        return Wrapper;
      },
      Cast: function(element) {
        return Wrapper.Tags[element.tagName];
      }
    },
    _: null,
    constructor: function Wrapper(dom_unit) {
      this._ = dom_unit;
      return Wrapper_Cache[uid(dom_unit)] = this;
    },
    cast: function(Klass) {
      if (this instanceof Klass) {
        return this;
      } else {
        return new Klass(this._);
      }
    }
  });

  NodeList.prototype.cast = function(Klass) {
    return this[0].cast(Klass);
  };

  Wrapper_Cache = Wrapper.Cache;

  Wrapper_Cache[undefined] = false;

  Element = new Class(Wrapper, {
    constructor: function Element(element, options) {
      var cast, key;
      if (typeof element === 'string') {
        element = elements_cache[element] || (elements_cache[element] = document.createElement(element));
        element = element.cloneNode(false);
      }

      if (this.constructor === Element) {
        cast = Wrapper.Cast(element)
      }

      if (cast !== undefined) {
        return new cast(element, options);
      }
      Wrapper.call(this, element);
      if (options != null) {
        for (key in options) {
          switch (key) {
            case 'id':
              this._.id = options[key];
              break;
            case 'html':
              this._.innerHTML = options[key];
              break;
            case 'class':
              this._.className = options[key];
              break;
            case 'style':
              this.style(options[key]);
              break;
            case 'on':
              this.on(options[key]);
              break;
            default:
              this.attr(key, options[key]);
          }
        }
      }
      return this;
    }
  });

  Element.include = function(hash) {
    var method, name, _results;
    Class.include.apply(this, arguments);
    _results = [];
    for (name in hash) {
      method = hash[name];
      _results.push((function(name) {
        if (!(name in core.List.prototype)) {
          return NodeList.prototype[name] = function() {
            var element, i, result, _i, _len;
            for (i = _i = 0, _len = this.length; _i < _len; i = ++_i) {
              element = this[i];
              result = element[name].apply(element, arguments);
              if (i === 0 && result !== element) {
                return result;
              }
            }
            if (this.length === 0) {
              return null;
            } else {
              return this;
            }
          };
        }
      })(name));
    }
    return _results;
  };

  Element.resolve = function(element) {
    if (typeof element === 'string' || (element && element.nodeType === 1)) {
      element = $(element);
    }
    if (element instanceof NodeList) {
      element = element[0];
    }
    return element || null;
  };

  elements_cache = {};

  Element.include(Element_events = {
    _listeners: null,
    on: function() {
      this._listeners === null && Element_make_listeners(this);
      return Lovely.Events.on.apply(this, arguments);
    },
    no: function() {
      this._listeners === null && Element_make_listeners(this);
      return Lovely.Events.no.apply(this, arguments);
    },
    ones: Lovely.Events.ones,
    emit: function(event, options) {
      var args, hash, parent, _i, _len, _ref;
      parent = wrap(this._.parentNode);
      if (!(event instanceof Event)) {
        event = new Event(event, ext({
          target: this._
        }, options));
      }
      event.currentTarget = this;
      _ref = this._listeners || [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hash = _ref[_i];
        if (hash.e === event.type) {
          args = (hash.n ? [] : [event]).concat(hash.a);
          if (hash.c.apply(this, args) === false) {
            event.stop();
          }
        }
      }
      if (!event.stopped && parent) {
        parent.emit(event);
      }
      return this;
    },
    stopEvent: function() {
      return false;
    }
  });

  Element_make_listeners = function(instance) {
    var list;
    list = [];
    list.push = function(hash) {
      var e;
      e = hash.e;
      if (e === 'mouseenter' || e === 'mouseleave') {
        mouseio_activate();
        hash.r = hash.e;
        hash.w = function() {};
      } else {
        hash.r = hash.e;
        if (e === 'contextmenu' && Browser === 'Konqueror') {
          hash.r = 'rightclick';
        }
        if (e === 'mousewheel' && Browser === 'Gecko') {
          hash.r = 'DOMMouseScroll';
        }
        hash.w = function(event) {
          var args;
          event = new Event(event);
          args = (hash.n ? [] : [event]).concat(hash.a);
          if (hash.c.apply(instance, args) === false) {
            event.stop();
          }
        };
        instance._.addEventListener(hash.r, hash.w, false);
      }
      return this[this.length] = hash;
    };
    list.splice = function(position) {
      var hash;
      hash = this[position];
      instance._.removeEventListener(hash.r, hash.w, false);
      return Array.prototype.splice.call(this, position, 1);
    };
    return instance._listeners = list;
  };

  Element.include({
    getClass: function() {
      return this._.className;
    },
    setClass: function(name) {
      this._.className = name;
      return this;
    },
    hasClass: function(name) {
      return (" " + this._.className + " ").indexOf(" " + name + " ") !== -1;
    },
    addClass: function(name) {
      var testee, _i, _len, _ref;
      if (name.indexOf(' ') === -1) {
        testee = " " + this._.className + " ";
        if (testee.indexOf(" " + name + " ") === -1) {
          this._.className += (testee === '  ' ? '' : ' ') + name;
        }
      } else {
        _ref = name.split(' ');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          name = _ref[_i];
          this.addClass(name);
        }
      }
      return this;
    },
    removeClass: function(name) {
      var _i, _len, _ref;
      if (name.indexOf(' ') === -1) {
        this._.className = trim((" " + this._.className + " ").replace(" " + name + " ", ' '));
      } else {
        _ref = name.split(' ');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          name = _ref[_i];
          this.removeClass(name);
        }
      }
      return this;
    },
    toggleClass: function(name) {
      if (this.hasClass(name)) {
        return this.removeClass(name);
      } else {
        return this.addClass(name);
      }
    },
    radioClass: function(name) {
      this.siblings().forEach('removeClass', name);
      return this.addClass(name);
    },
    style: function(name, value) {
      if (typeof name === 'string') {
        if (name.indexOf(':') !== -1) {
          return this.style(Element_parse_style(name));
        } else if (name.indexOf(',') !== -1) {
          return Element_read_styles(this, name);
        } else if (value === undefined) {
          return Element_clean_style(this._.style, name) || Element_clean_style(Element_computed_styles(this._), name);
        } else {
          if (name === 'float') {
            name = 'cssFloat';
          }
          this._.style[camelize(name)] = value;
        }
      } else {
        for (value in name) {
          this.style(value, name[value]);
        }
      }
      return this;
    }
  });

  Element_read_styles = function(element, names) {
    var hash, name, _i, _len, _ref;
    hash = {};
    _ref = names.split(',');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      name = _ref[_i];
      name = camelize(name);
      hash[name] = element.style(name);
    }
    return hash;
  };

  Element_parse_style = function(style) {
    var chunk, hash, name, value, _i, _len, _ref, _ref1;
    hash = {};
    _ref = style.split(';');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      chunk = _ref[_i];
      if (!/^\s+$/.test(chunk)) {
        _ref1 = chunk.split(':'), name = _ref1[0], value = _ref1[1];
        hash[trim(name)] = trim(value);
      }
    }
    return hash;
  };

  Element_clean_style = function(style, name) {
    var value;
    name = camelize(name);
    if (name === 'opacity') {
      return style[name].replace(',', '.');
    } else if (name === 'float') {
      name = 'cssFloat';
    }
    value = style[name];
    if (/color/i.test(name) && value) {
      value = value.replace(/"/g, '');
    }
    return value;
  };

  Element_computed_styles = function(element) {
    return element.ownerDocument.defaultView.getComputedStyle(element, null);
  };

  Element.include({
    attr: function(name, value) {
      var element;
      if (typeof name === 'string') {
        if (value === undefined) {
          value = this._[name] || this._.getAttribute(name);
          if (value === '') {
            return null;
          } else {
            return value;
          }
        } else if (value === null) {
          this._.removeAttribute(name);
          delete this._[name];
        } else if (name === 'style') {
          this.style(value);
        } else {
          element = this._;
          if (!(name in element)) {
            element.setAttribute(name, value);
          }
          element[name] = value;
        }
      } else {
        for (value in name) {
          this.attr(value, name[value]);
        }
      }
      return this;
    },
    data: function(key, value) {
      var attr, match, name, result, _i, _len, _ref;
      if (isObject(key)) {
        for (name in key) {
          value = this.data(name, key[name]);
        }
      } else if (value === undefined) {
        key = dasherize('data-' + key);
        result = {};
        match = false;
        _ref = this._.attributes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          attr = _ref[_i];
          value = attr.value;
          try {
            value = JSON.parse(value);
          } catch (e) {

          }
          if (attr.name === key) {
            result = value;
            match = true;
            break;
          } else if (attr.name.indexOf(key) === 0) {
            result[camelize(attr.name.substring(key.length + 1))] = value;
            match = true;
          }
        }
        value = match ? result : null;
      } else {
        key = dasherize('data-' + key);
        if (!isObject(value)) {
          value = {
            '': value
          };
        }
        for (name in value) {
          attr = name == false ? key : dasherize(key + '-' + name);
          if (value[name] === null) {
            this._.removeAttribute(attr);
          } else {
            this._.setAttribute(attr, isString(value[name]) ? value[name] : JSON.stringify(value[name]));
          }
        }
        value = this;
      }
      return value;
    },
    hidden: function() {
      return this.style('display') === 'none';
    },
    visible: function() {
      return !this.hidden();
    },
    hide: function() {
      if (this.visible()) {
        this._old_display = this.style('display');
        this._.style.display = 'none';
      }
      return this;
    },
    show: function() {
      var dummy, element, value;
      if (this.hidden()) {
        element = this._;
        value = this._old_display;
        if (!value || value === 'none') {
          dummy = new Element(element.tagName).insertTo(HTML);
          value = dummy.style('display') || 'none';
          dummy.remove();
        }
        element.style.display = value === 'none' ? 'block' : value;
      }
      return this;
    },
    toggle: function() {
      if (this.hidden()) {
        return this.show();
      } else {
        return this.hide();
      }
    },
    radio: function() {
      this.siblings().forEach('hide');
      return this.show();
    },
    document: function() {
      return wrap(this._.ownerDocument);
    },
    window: function() {
      return this.document().window();
    }
  });

  Element.include({
    size: function(size) {
      var style;
      if (size === undefined) {
        return {
          x: this._.offsetWidth,
          y: this._.offsetHeight
        };
      } else {
        size = dimensions_hash(arguments);
        style = this._.style;
        if ('x' in size) {
          style.width = size.x + 'px';
          style.width = 2 * size.x - this._.offsetWidth + 'px';
        }
        if ('y' in size) {
          style.height = size.y + 'px';
          style.height = 2 * size.y - this._.offsetHeight + 'px';
        }
        return this;
      }
    },
    scrolls: function(scrolls) {
      if (scrolls === undefined) {
        return {
          x: this._.scrollLeft,
          y: this._.scrollTop
        };
      } else {
        scrolls = dimensions_hash(arguments);
        if ('x' in scrolls) {
          this._.scrollLeft = scrolls.x;
        }
        if ('y' in scrolls) {
          this._.scrollTop = scrolls.y;
        }
        return this;
      }
    },
    position: function(position) {
      var html, offset, rect, scrolls;
      if (position === undefined) {
        rect = this._.getBoundingClientRect();
        html = this.document()._.documentElement;
        scrolls = this.window().scrolls();
        return {
          x: rect.left + scrolls.x - html.clientLeft,
          y: rect.top + scrolls.y - html.clientTop
        };
      } else {
        position = dimensions_hash(arguments);
        offset = this.offsetParent().position();
        if ('x' in position) {
          this._.style.left = position.x - offset.x + 'px';
        }
        if ('y' in position) {
          this._.style.top = position.y - offset.y + 'px';
        }
      }
      return this;
    },
    offset: function(position) {
      var offset;
      if (position === undefined) {
        position = this.position();
        offset = this.offsetParent().position();
        return {
          x: position.x - offset.x,
          y: position.y - offset.y
        };
      } else {
        position = dimensions_hash(arguments);
        if ('x' in position) {
          this._.style.left = position.x + 'px';
        }
        if ('y' in position) {
          this._.style.top = position.y + 'px';
        }
        return this;
      }
    },
    offsetParent: function() {
      var parent, _i, _len, _ref, _ref1;
      _ref = this.parents();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        parent = _ref[_i];
        if ((_ref1 = parent.style('position')) === 'relative' || _ref1 === 'absolute' || _ref1 === 'fixed') {
          return parent;
        }
      }
      return wrap(this.document()._.documentElement);
    },
    overlaps: function(target) {
      var pos, size;
      pos = this.position();
      size = this.size();
      target = dimensions_hash(arguments);
      return target.x >= pos.x && target.x <= (pos.x + size.x) && target.y >= pos.y && target.y <= (pos.y + size.y);
    },
    index: function() {
      var index, node;
      node = this._.previousSibling;
      index = 0;
      while (node) {
        if (node.nodeType === 1) {
          index++;
        }
        node = node.previousSibling;
      }
      return index;
    }
  });

  Element.include({
    find: function(css_rule, needs_raw) {
      var result;
      result = this._.querySelectorAll(css_rule || '*');
      if (needs_raw === true) {
        return result;
      } else {
        return new NodeList(result, true);
      }
    },
    first: function(css_rule) {
      var element;
      if (css_rule === undefined && this._.firstElementChild !== undefined) {
        element = this._.firstElementChild;
      } else {
        element = this._.querySelector(css_rule || '*');
      }
      return wrap(element);
    },
    match: function(css_rule) {
      var element, _i, _len, _ref;
      _ref = this.document().find(css_rule, true);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        if (element === this._) {
          return true;
        }
      }
      return false;
    },
    parent: function(css_rule) {
      if (css_rule) {
        return this.parents(css_rule)[0];
      } else {
        return wrap(this._.parentNode);
      }
    },
    parents: function(css_rule) {
      return Element_recursively_collect(this, 'parentNode', css_rule);
    },
    children: function(css_rule) {
      return this.find(css_rule).filter(function(element) {
        return element._.parentNode === this._;
      }, this);
    },
    siblings: function(css_rule) {
      return this.previousSiblings(css_rule).reverse().concat(this.nextSiblings(css_rule).toArray());
    },
    nextSiblings: function(css_rule) {
      return Element_recursively_collect(this, 'nextSibling', css_rule);
    },
    previousSiblings: function(css_rule) {
      return Element_recursively_collect(this, 'previousSibling', css_rule);
    },
    nextSibling: function(css_rule) {
      if (css_rule === undefined && this._.nextElementSibling !== undefined) {
        return wrap(this._.nextElementSibling);
      } else {
        return this.nextSiblings(css_rule)[0];
      }
    },
    previousSibling: function(css_rule) {
      if (css_rule === undefined && this._.previousElementSibling !== undefined) {
        return wrap(this._.previousElementSibling);
      } else {
        return this.previousSiblings(css_rule)[0];
      }
    }
  });

  Element_recursively_collect = function(element, attr, css_rule) {
    var match, no_rule, node, result;
    result = [];
    node = element._;
    no_rule = css_rule === undefined;
    if (!no_rule) {
      css_rule = element.document().find(css_rule, true);
    }
    match = function(node) {
      var _i, _len;
      for (_i = 0, _len = css_rule.length; _i < _len; _i++) {
        element = css_rule[_i];
        if (element === node) {
          return true;
        }
      }
      return false;
    };
    while ((node = node[attr]) !== null) {
      if (node.nodeType === 1 && (no_rule || match(node))) {
        result.push(node);
      }
    }
    return new NodeList(result);
  };

  Element.include({
    clone: function() {
      return new Element(this._.cloneNode(true));
    },
    clear: function() {
      while (this._.firstChild) {
        this._.removeChild(this._.firstChild);
      }
      return this;
    },
    empty: function() {
      return /^\s*$/.test(this.html());
    },
    html: function(content) {
      if (content === undefined) {
        return this._.innerHTML;
      } else {
        return this.update(content);
      }
    },
    text: function(text) {
      if (text === undefined) {
        return this._.textContent;
      } else {
        return this.update(document.createTextNode(text));
      }
    },
    remove: function() {
      this._.parentNode && this._.parentNode.removeChild(this._);
      return this;
    },
    replace: function(content) {
      return this.insert(content, 'instead');
    },
    update: function(content) {
      var scripts, _ref;
      if (typeof content !== 'object') {
        _ref = extract_scripts('' + content), content = _ref[0], scripts = _ref[1];
        try {
          this._.innerHTML = content;
        } catch (e) {
          return this.clear().insert(content);
        }
        global_eval(scripts);
      } else {
        this.clear().insert(content);
      }
      return this;
    },
    append: function(first) {
      return this.insert(typeof first === "string" ? A(arguments).join('') : arguments);
    },
    insertTo: function(element, position) {
      Element.resolve(element).insert(this, position);
      return this;
    },
    insert: function(content, position) {
      var element, scripts, _ref;
      element = this._;
      if (position === undefined) {
        position = 'bottom';
      }
      if (typeof content !== 'object') {
        _ref = extract_scripts('' + content), content = _ref[0], scripts = _ref[1];
      }
      if (content._) {
        content = content._;
      }
      if (content.nodeType === undefined) {
        content = Element_create_fragment((position === 'bottom' || position === 'top' ? element : element.parentNode), content);
      }
      Element_insert[position](element, content);
      global_eval(scripts);
      return this;
    }
  });

  Element_insert = {
    bottom: function(target, content) {
      return target.appendChild(content);
    },
    top: function(target, content) {
      if (target.firstChild === null) {
        return target.appendChild(content);
      } else {
        return target.insertBefore(content, target.firstChild);
      }
    },
    after: function(target, content) {
      var parent, sibling;
      parent = target.parentNode;
      sibling = target.nextSibling;
      if (sibling === null) {
        return parent.appendChild(content);
      } else {
        return parent.insertBefore(content, sibling);
      }
    },
    before: function(target, content) {
      return target.parentNode.insertBefore(content, target);
    },
    instead: function(target, content) {
      return target.parentNode.replaceChild(content, target);
    }
  };

  Element_create_fragment = function(context, content) {
    var block, depth, tag, tmp;
    if (typeof content === 'string') {
      tag = context.tagName;
      tmp = Element_tmp_cont;
      block = tag in Element_wraps ? Element_wraps[tag] : ['', '', 1];
      depth = block[2];
      tmp.innerHTML = block[0] + '<' + tag + '>' + content + '</' + tag + '>' + block[1];
      while (depth-- !== 0) {
        tmp = tmp.firstChild;
      }
      content = tmp.childNodes;
      while (content.length !== 0) {
        Element_fragment.appendChild(content[0]);
      }
    } else {
      for (var i=0, length = content.length, node; i < length; i++) {
        node = content[content.length === length ? i : 0];
        Element_fragment.appendChild(node._ || node);
      };

    }
    return Element_fragment;
  };

  Element_fragment = document.createDocumentFragment();

  Element_tmp_cont = document.createElement('div');

  Element_wraps = {
    TBODY: ['<TABLE>', '</TABLE>', 2],
    TR: ['<TABLE><TBODY>', '</TBODY></TABLE>', 3],
    TD: ['<TABLE><TBODY><TR>', '</TR></TBODY></TABLE>', 4],
    COL: ['<TABLE><COLGROUP>', '</COLGROUP><TBODY></TBODY></TABLE>', 2],
    LEGEND: ['<FIELDSET>', '</FIELDSET>', 2],
    AREA: ['<map>', '</map>', 2],
    OPTION: ['<SELECT>', '</SELECT>', 2]
  };

  Element_wraps.OPTGROUP = Element_wraps.OPTION;

  Element_wraps.THEAD = Element_wraps.TBODY;

  Element_wraps.TFOOT = Element_wraps.TBODY;

  Element_wraps.TH = Element_wraps.TD;

  Document = new Class(Wrapper, {
    include: [Element_events],
    constructor: function Document(document) {
      return Wrapper.call(this, document);
    },
    window: function() {
      return wrap(this._.defaultView || this._.parentWindow);
    },
    find: Element.prototype.find,
    first: Element.prototype.first
  });

  current_Document = new Document(document);

  Window = new Class(Wrapper, {
    include: Element_events,
    constructor: function Window(window) {
      return Wrapper.call(this, window);
    },
    window: function() {
      return this;
    },
    size: function(size) {
      var html, win;
      if (size === undefined) {
        win = this._;
        html = win.document.documentElement;
        if (win.innerWidth) {
          return {
            x: win.innerWidth,
            y: win.innerHeight
          };
        } else {
          return {
            x: html.clientWidth,
            y: html.clientHeight
          };
        }
      } else {
        size = dimensions_hash(arguments);
        if (!('x' in size)) {
          size.x = this.size().x;
        }
        if (!('y' in size)) {
          size.y = this.size().y;
        }
        this._.resizeTo(size.x, size.y);
        this._.resizeTo(2 * size.x - this.size().x, 2 * size.y - this.size().y);
        return this;
      }
    },
    scrolls: function(position) {
      var body, doc, html, win;
      if (position === undefined) {
        win = this._;
        doc = win.document;
        body = doc.body;
        html = doc.documentElement;
        if (win.pageXOffset || win.pageYOffset) {
          return {
            x: win.pageXOffset,
            y: win.pageYOffset
          };
        } else if (body && (body.scrollLeft || body.scrollTop)) {
          return {
            x: body.scrollLeft,
            y: body.scrollTop
          };
        } else {
          return {
            x: html.scrollLeft,
            y: html.scrollTop
          };
        }
      } else {
        position = dimensions_hash(arguments);
        if (!('x' in position)) {
          position.x = this.scrolls().x;
        }
        if (!('y' in position)) {
          position.y = this.scrolls().y;
        }
        this._.scrollTo(position.x, position.y);
        return this;
      }
    }
  });

  Style = new Class(Element, {
    constructor: function Style(options) {
      this.$super('style', {
        type: 'text/css'
      });
      options || (options = {});
      if (typeof options.html === 'string') {
        this._.appendChild(document.createTextNode(options.html));
      }
      return this;
    }
  });

  Style.include = Element.include;

  Form = new Class(Element, {
    constructor: function Form(element, options) {
      var remote;
      if (!element || (!isElement(element) && isObject(element))) {
        options = element || {};
        element = 'form';
        remote = 'remote' in options;
        delete options.remote;
      }
      this.$super(element, options);
      if (remote && this.remotize) {
        this.remotize();
      }
      return this;
    }
  });

  Form.include = Element.include;

  Form.include({
    elements: function() {
      return this.find('input,button,select,textarea');
    },
    inputs: function() {
      return this.elements().filter(function(input) {
        var _ref;
        return !((_ref = input._.type) === 'submit' || _ref === 'button' || _ref === 'reset' || _ref === 'image' || _ref === null);
      });
    },
    input: function(name) {
      return this.first("*[name=\"" + name + "\"]");
    },
    focus: function() {
      var element, _i, _len, _ref;
      _ref = this.inputs();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        element.focus();
        break;
      }
      return this;
    },
    blur: function() {
      this.elements().forEach('blur');
      return this;
    },
    disable: function() {
      this.elements().forEach('disable');
      return this;
    },
    enable: function() {
      this.elements().forEach('enable');
      return this;
    },
    values: function() {
      var values;
      values = {};
      this.inputs().forEach(function(element) {
        var hash, input, key, keys, name, _ref;
        input = element._;
        name = input.name;
        hash = values;
        keys = name.match(/[^\[]+/g);
        if (!input.disabled && name && (!((_ref = input.type) === 'checkbox' || _ref === 'radio') || input.checked)) {
          while (keys.length > 1) {
            key = keys.shift();
            if (key[key.length - 1] === ']') {
              key = key.substr(0, key.length - 1);
            }
            hash = (hash[key] || (hash[key] = (keys[0] === ']' ? [] : {})));
          }
          key = keys.shift();
          if (key[key.length - 1] === ']') {
            key = key.substr(0, key.length - 1);
          }
          if (key === '') {
            hash.push(element.value());
          } else {
            hash[key] = element.value();
          }
        }
      });
      return values;
    },
    submit: function() {
      this._.submit();
      return this;
    },
    reset: function() {
      this._.reset();
      return this;
    }
  });

  Input = new Class(Element, {
    constructor: function Input(element, options) {
      if (!element || (!isElement(element) && isObject(element))) {
        options = element || {};
        if (/textarea|select/.test(options.type || '')) {
          element = options.type;
          delete options.type;
        } else {
          element = 'input';
        }
      }
      return this.$super(element, options);
    }
  });

  Input.include = Element.include;

  Input.include({
    form: function() {
      return wrap(this._.form);
    },
    insert: function(content, position) {
      this.$super(content, position);
      this.find('option').forEach(function(option) {
        return option._.selected = !!option.attr('selected');
      });
      return this;
    },
    update: function(content) {
      return this.clear().insert(content);
    },
    value: function(value) {
      if (value === undefined) {
        value = this._.value;
        if (this._.type === 'select-multiple') {
          value = [];
          this.find('option').forEach(function(option) {
            if (option._.selected) {
              value.push(option._.value);
            }
          });
        }
        return value;
      } else {
        if (this._.type === 'select-multiple') {
          value = L(isArray(value) ? value : [value]);
          this.find('option').forEach(function(option) {
            return option._.selected = value.indexOf(option._.value) !== -1;
          });
        } else {
          this._.value = value;
        }
      }
      return this;
    },
    focus: function() {
      this._.focus();
      this.focused = true;
      return this;
    },
    blur: function() {
      this._.blur();
      this.focused = false;
      return this;
    },
    select: function() {
      this._.select();
      this.focused = true;
      return this;
    },
    disable: function() {
      this._.disabled = true;
      return this.emit('disable');
    },
    enable: function() {
      this._.disabled = false;
      return this.emit('enable');
    },
    disabled: function(value) {
      if (value === undefined) {
        return this._.disabled;
      } else {
        return this[value ? 'disable' : 'enable']();
      }
    },
    checked: function(value) {
      if (value === undefined) {
        return this._.checked;
      } else {
        this._.checked = value;
        return this;
      }
    }
  });

  Event = new Class(Wrapper, {
    type: null,
    which: null,
    keyCode: null,
    target: null,
    currentTarget: null,
    relatedTarget: null,
    pageX: null,
    pageY: null,
    altKey: false,
    ctrlKey: false,
    metaKey: false,
    shiftKey: false,
    stopped: false,
    constructor: function Event(event, options) {
      if (typeof event === 'string') {
        event = ext({
          type: event
        }, options);
        this.stopped = event.bubbles === false;
        if (options !== null) {
          ext(this, options);
        }
      }
      this._ = event;
      this.type = event.type;
      this.which = event.which;
      this.keyCode = event.keyCode;
      this.altKey = event.altKey;
      this.ctrlKey = event.ctrlKey;
      this.metaKey = event.metaKey;
      this.shiftKey = event.shiftKey;
      this.pageX = event.pageX;
      this.pageY = event.pageY;
      this.target = wrap(event.target);
      if (event.target && event.target.nodeType === 3) {
        this.target = wrap(event.target.parentNode);
      }
      this.currentTarget = wrap(event.currentTarget);
      this.relatedTarget = wrap(event.relatedTarget);
    },
    stopPropagation: function() {
      if (this._.stopPropagation) {
        this._.stopPropagation();
      }
      this.stopped = true;
      return this;
    },
    preventDefault: function() {
      if (this._.preventDefault) {
        this._.preventDefault();
      }
      return this;
    },
    stop: function() {
      return this.stopPropagation().preventDefault();
    },
    position: function() {
      return {
        x: this.pageX,
        y: this.pageY
      };
    },
    offset: function() {
      var element_position;
      if (this.target instanceof Element) {
        element_position = this.target.position();
        return {
          x: this.pageX - element_position.x,
          y: this.pageY - element_position.y
        };
      }
      return null;
    },
    find: function(css_rule) {
      var element, search, target, _i, _len;
      if (this.target instanceof Wrapper && this.currentTarget instanceof Wrapper) {
        target = this.target._;
        search = this.currentTarget.find(css_rule, true);
        while (target !== null) {
          for (_i = 0, _len = search.length; _i < _len; _i++) {
            element = search[_i];
            if (element === target) {
              return wrap(target);
            }
          }
          target = target.parentNode;
        }
      }
      return null;
    }
  });

  Events_delegation = {
    delegate: function(css_rule, event) {
      var args, callback;
      if (typeof event === 'string') {
        args = A(arguments).slice(2);
        callback = args.shift();
        this.on(event, function(event) {
          var target;
          target = event.find(css_rule);
          if (target != null) {
            if (typeof callback === 'string') {
              target[callback].apply(target, args);
            } else {
              callback.apply(target, [event].concat(args));
            }
          }
        });
        ext(this._listeners[this._listeners.length - 1], {
          dr: css_rule,
          dc: callback
        });
      } else {
        for (args in event) {
          callback = event[args];
          this.delegate.apply(this, [css_rule, args].concat(ensure_array(callback)));
        }
      }
      return this;
    },
    undelegate: function(event) {
      var hash, _i, _len, _ref;
      _ref = delegation_listeners(arguments, this);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hash = _ref[_i];
        this.no(hash.e, hash.c);
      }
      return this;
    },
    delegates: function() {
      return delegation_listeners(arguments, this).length === 0;
    }
  };

  delegation_listeners = function(args, object) {
    var callback, css_rule, event, hash, result, _i, _len, _ref;
    args = A(args);
    css_rule = args.shift();
    event = args.shift();
    callback = args.shift();
    result = [];
    if (typeof event === 'string') {
      _ref = object._listeners;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hash = _ref[_i];
        if (hash.dr === css_rule && (!event || hash.e === event)) {
          if (!callback || hash.dc === callback) {
            result.push(hash);
          }
        }
      }
    } else {
      for (args in event) {
        callback = event[args];
        result = result.concat(delegation_listeners([css_rule, args].concat(ensure_array(callback)), object));
      }
    }
    return result;
  };

  Element.include(Events_delegation);

  Document.include(Events_delegation);

  mouseio_index = [];

  mouseio_inactive = true;

  mouseio_emit = function(raw, element, enter) {
    var event;
    event = new Event(raw);
    event.type = enter === true ? 'mouseenter' : 'mouseleave';
    event.bubbles = false;
    event.stopped = true;
    event.target = wrap(element);
    event.find = function(css_rule) {
      var _i, _len, _ref;
      _ref = current_Document.find(css_rule, true);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        element = _ref[_i];
        if (element === this.target._) {
          return this.target;
        }
      }
      return null;
    };
    event.target.emit(event);
    return current_Document.emit(event);
  };

  mouseio_handler = function(e) {
    var element, event, from, id, parents, passed, target;
    target = e.target;
    from = e.relatedTarget;
    element = target;
    passed = false;
    parents = [];
    id = null;
    event = null;
    while (element.nodeType === 1) {
      id = uid(element);
      if (mouseio_index[id] === undefined) {
        mouseio_emit(e, element, mouseio_index[id] = true);
      }
      if (element === from) {
        passed = true;
      }
      parents.push(element);
      element = element.parentNode;
    }
    if (from && !passed) {
      while (from !== null && from.nodeType === 1 && parents.indexOf(from) === -1) {
        id = uid(from);
        if (mouseio_index[id] !== undefined) {
          mouseio_emit(e, from, mouseio_index[id] = undefined);
        }
        from = from.parentNode;
      }
    }
  };

  mouseio_reset = function(e) {
    var element, id, _i, _len;
    for (id = _i = 0, _len = mouseio_index.length; _i < _len; id = ++_i) {
      element = mouseio_index[id];
      if (element && id in Wrapper_Cache) {
        mouseio_emit(e, Wrapper_Cache[id]._, false);
      }
    }
  };

  mouseio_activate = function() {
    if (mouseio_inactive) {
      mouseio_inactive = false;
      document.addEventListener('mouseover', mouseio_handler, false);
      window.addEventListener('blur', mouseio_reset, false);
    }
  };

  focusio_boobler = function(raw_event) {
    var event;
    event = new Event(raw_event);
    if (event.target instanceof Element) {
      event.target.parent().emit(event);
    }
  };

  document.addEventListener('focus', focusio_boobler, true);

  document.addEventListener('blur', focusio_boobler, true);

  Document.include({
    on: function(name, callback) {
      var doc, id, _ref;
      this.$super.apply(this, arguments);
      if (name === 'ready') {
        doc = this._;
        id = uid(doc);
        if ((_ref = doc.readyState) === 'interactive' || _ref === 'loaded' || _ref === 'complete') {
          callback.apply(this);
        } else if (!(id in Ready_documents)) {
          Ready_documents[id] = this;
          doc.addEventListener('DOMContentLoaded', function() {
            return Ready_documents[id].emit('ready');
          }, false);
        }
      }
      return this;
    }
  });

  Ready_documents = [];

  $ = function(value, context) {
    switch (typeof value) {
      case 'string':
        if (/^#[^ \.\[:]+$/.test(value)) {
          value = document.getElementById(value.substr(1));
          value = value === null ? [] : [value];
        } else if (value[0] === '<') {
          return new Element('div').html(value).children();
        } else {
          if (context == null) {
            context = current_Document;
          } else if (!(context instanceof Wrapper)) {
            context = wrap(context);
          }
          return context.find(value);
        }
        value = new NodeList(value, true);
        break;
      case 'function':
        value = current_Document.on('ready', value);
        break;
      case 'object':
        value = wrap(value);
    }
    return value;
  };

  Wrapper.set("form", Form).set("input", Input).set("button", Input).set("select", Input).set("textarea", Input).set("optgroup", Input).set("style", Style);

  exports = ext($, {
    version: '1.4.1',
    Browser: Browser,
    Wrapper: Wrapper,
    Document: Document,
    Element: Element,
    Window: Window,
    Event: Event,
    Form: Form,
    Input: Input,
    Style: Style,
    NodeList: NodeList,
    "eval": global_eval,
    uid: uid
  });


  return exports;
});
