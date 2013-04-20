/**
 * lovely.io 'core' module v1.4.1
 *
 * Copyright (C) 2013 Nikolay Nemshilov
 */
(function(t){var n,r,e,i,s,o,u,c,l,a,Class,Events,f,h,Hash,p,List,g,Lovely,m,Options,y,d,_,v,b,w,U,j,O,x,A,$,E,k,S,N,L=this,T={}.hasOwnProperty;Lovely=function(){var t,r,e,i,s,o,u,c,l,a,f,h,p,g,m,y;t=n(arguments),i=E(t[0])?t.shift():null,a=$(t[0])?t.shift():{},c=O(t[0])?t.shift():[],r=x(t[0])?t.shift():function(){},"hostUrl"in a||(a.hostUrl=Lovely.hostUrl||U()),"baseUrl"in a||(a.baseUrl=Lovely.baseUrl||a.hostUrl),"waitSeconds"in a||(a.waitSeconds=Lovely.waitSeconds),"/"===a.hostUrl[a.hostUrl.length-1]||(a.hostUrl+="/"),"/"===a.baseUrl[a.baseUrl.length-1]||(a.baseUrl+="/");for(o=p=0,m=c.length;m>p;o=++p)l=c[o],l in Lovely.bundle&&(c[o]=""+l+"-"+Lovely.bundle[l]);if(e=k(c,r,i),!e())for(S.push(e),s=document.getElementsByTagName("head")[0],o=g=0,y=c.length;y>g;o=++g)u=c[o],h=("."===u[0]?a.baseUrl:a.hostUrl)+u+".js",u=c[o]=c[o].replace(/^[\.\/]+/,""),j(u)||j(u,Lovely.loading)||-1!==u.indexOf("~")||(f=document.createElement("script"),f.src=h.replace(/([^:])\/\//g,"$1/"),f.async=!0,f.type="text/javascript",f.onload=_,s.appendChild(f),Lovely.loading[u]=f)},S=[],_=function(){return L.setTimeout(function(){var t,n,r,e,i;for(t=[],n=e=0,i=S.length;i>e;n=++e)r=S[n],r()||t.push(r);t.length!==S.length&&(S=t,_())},0)},k=function(t,n,r){return function(){var e,i,s,o,u;for(i=[],o=0,u=t.length;u>o;o++){if(e=t[o],!(e=j(e)))return!1;i.push(e)}return(s=n.apply(L,i))&&r&&(Lovely.modules[r]=s,delete Lovely.loading[r],_()),!0}},j=function(t,n){var r,e,i,s,o;if(n=n||Lovely.modules,t=t.replace(/~/g,""),s=(t.match(/\-\d+\.\d+\.\d+.*$/)||[""])[0],i=t.substr(0,t.length-s.length),s=s.substr(1),!(t=n[t])){o=[];for(r in n)(e=r.match(/^(.+?)-(\d+\.\d+\.\d+.*?)$/))&&e[1]===i&&o.push(r);t=n[o.sort()[o.length-1]]}return t},U=function(){var t,n,r,e,i,s;if(L.document)for(e=document.getElementsByTagName("script"),n=/^(.*?\/?)core(-.+)?\.js/,i=0,s=e.length;s>i;i++)if(r=e[i],t=(r.getAttribute("src")||"").match(n))return Lovely.hostUrl=t[1];return Lovely.hostUrl},m=Object.prototype.toString,c=Array.prototype.slice,f=Function.prototype.bind||function(){var t,r,e;return t=n(arguments),r=t.shift(),e=this,function(){return e.apply(r,t.concat(n(arguments)))}},y=String.prototype.trim||function(){var t,n,r;for(r=this.replace(/^\s\s*/,""),t=r.length,n=/\s/;n.test(r.charAt(--t)););return r.slice(0,t+1)},n=function(t){return c.call(t,0)},p=function(t){return new List(t)},h=function(t){return new Hash(t)},w=function(t,n){null==n&&(n={});var r;for(r in n)T.call(n,r)&&(t[r]=n[r]);return t},d=function(){var t;return t=n(arguments),f.apply(t.shift(),t)},N=function(t){return y.call(t)},E=function(t){return"string"===typeof t},A=function(t){return"number"===typeof t&&!isNaN(t)},x=function(t){return"function"===typeof t&&"[object RegExp]"!==m.call(t)},O=function(t){return"[object Array]"===m.call(t)||t instanceof List},$=function(t){return"[object Object]"===m.call(t)},v=function(t){return O(t)?t:[t]},Class=function(n,r){var e,i,s,o;if(x(n)||(r=n,n=Class),r||(r={}),e=T.call(r,"constructor")?r.constructor:function(){return this.$super===t?this:this.$super.apply(this,arguments)},i=function(){},i.prototype=n.prototype,e.prototype=new i,n!==Class){for(s in n)T.call(n,s)&&(o=n[s],e[s]=o);e.prototype.$super=function(){return this.$super=n.prototype.$super,n.apply(this,arguments)},x(n.prototype.whenInherited)&&n.prototype.whenInherited.call(n,e)}return e.__super__=n,e.prototype.constructor=e,(e.include=Class.include).apply(e,v(r.include||[])),(e.extend=Class.extend).apply(e,v(r.extend||[])),e.inherit=Class.inherit,delete r.extend,delete r.include,delete r.constructor,e.include(r)},w(Class,{include:function(){var t,n,r,e,i,s,o;for(s=0,o=arguments.length;o>s;s++){r=arguments[s],r||(r={});for(t in r){if(!(i=this.prototype[t]||!1))for(e=this.__super__;e;){if(t in e.prototype){x(e.prototype[t])&&(i=e.prototype[t]);break}e=e.__super__}n=r[t],this.prototype[t]=function(t,n){return n?function(){return this.$super=n,t.apply(this,arguments)}:t}(n,i)}}return this},extend:function(){var t,n,r;for(n=0,r=arguments.length;r>n;n++)t=arguments[n],w(this,t);return this},inherit:function(t){return new Class(this,t)}}),List=new Class(Array,{constructor:function List(n){return n!==t&&a.apply(this,[0,0].concat(n)),this},slice:function(){return new this.constructor(c.apply(this,arguments))},concat:function(t){return new this.constructor(n(this).concat(n(t)))},forEach:function(){return g(i,this,arguments),this},map:function(){return new List(g(s,this,arguments))},filter:function(){return new this.constructor(g(e,this,arguments))},reject:function(){return new this.constructor(g(u,this,arguments))},some:function(){return g(l,this,arguments)},every:function(){return g(r,this,arguments)},toArray:function(){return n(this)},toString:function(){return"#<List ["+n(this)+"]>"}}),o=Array.prototype,c=o.slice,a=o.splice,i=o.forEach,s=o.map,e=o.filter,u=function(t,n){return e.call(this,function(){return!t.apply(n,arguments)})},l=o.some,r=o.every,g=function(t,r,e){var i,s;return"string"===typeof e[0]&&(s=n(e),i=s.shift(),e=0!==r.length&&"function"===typeof r[0][i]?[function(t){return t[i].apply(t,s)}]:[function(t){return t[i]}]),t.apply(r,e)},Hash=new Class({_:null,constructor:function Hash(t){return this._=t||{},this}}),Hash.include=function(t){var r,e;Class.include.apply(Hash,arguments),e=[];for(r in t)e.push(function(t){return Hash[t]=function(){var r,e;return r=n(arguments),e=new Hash(r.shift()),r=e[t].apply(e,r),r instanceof Hash&&(r=r._),r}}(r));return e},Hash.include({keys:function(){var t,n,r;n=this._,r=[];for(t in n)T.call(n,t)&&r.push(t);return r},values:function(){var t,n,r,e;r=this._,e=[];for(t in r)T.call(r,t)&&(n=r[t],e.push(n));return e},empty:function(){var t,n;n=this._;for(t in n)if(T.call(n,t))return!1;return!0},clone:function(){return this.merge()},forEach:function(t,n){var r,e,i;e=this._;for(r in e)T.call(e,r)&&(i=e[r],t.call(n,r,i,e));return this},map:function(t,n){var r,e,i,s;e=this._,i=[];for(r in e)T.call(e,r)&&(s=e[r],i.push(t.call(n,r,s,e)));return i},filter:function(t,n){var r,e,i,s;i=this._,r={};for(e in i)T.call(i,e)&&(s=i[e],t.call(n,e,s,i)&&(r[e]=i[e]));return new Hash(r)},reject:function(t,n){var r,e,i,s;i=this._,r={};for(e in i)T.call(i,e)&&(s=i[e],t.call(n,e,s,i)||(r[e]=i[e]));return new Hash(r)},merge:function(){var t,r,e,i,s;for(t=n(arguments),r={},t.unshift(this._);t.length>0;){i=t.shift(),i instanceof Hash&&(i=i._);for(e in i)T.call(i,e)&&(s=i[e],r[e]=!$(s)||s instanceof Class?i[e]:Hash.merge(e in r?r[e]:{},s))}return new Hash(r)},toObject:function(){return this._}}),Events={_listeners:null,on:function(){var t,n,r,e,i,s,o,u,l;if(t=c.call(arguments,2),i=arguments[0],r=arguments[1],n=!1,"string"===typeof r&&(r=this[r],n=!0),s=null===this._listeners?this._listeners=[]:this._listeners,"string"===typeof i)for(l=i.split(","),o=0,u=l.length;u>o;o++)e=l[o],s.push({e:e,c:r,a:t,n:n});else if("object"===typeof i)for(e in i)this.on(e,i[e]);return this},no:function(){var n,r,e,i,s,o,u,l,a;switch(n=c.call(arguments,2),i=arguments[0],r=arguments[1],"string"===typeof r&&(r=this[r]),o=null===this._listeners?this._listeners=[]:this._listeners,typeof i){case"string":for(a=i.split(","),u=0,l=a.length;l>u;u++)for(e=a[u],s=0;o.length>s;)o[s].e!==e||o[s].c!==r&&r!==t||o.splice(s--,1),s++;break;case"function":for(s=0;o.length>s;)o[s].c===i&&o.splice(s--,1),s++;break;case"object":for(e in i)this.no(e,i[e])}return this},ones:function(){var n,r,e,i,s,o,u,l,a,f,h,p,g,m;switch(u=0,n=c.call(arguments,2),s=arguments[0],r=arguments[1],"string"===typeof r&&(r=this[r]),o=null===this._listeners?this._listeners=[]:this._listeners,typeof s){case"string":for(m=s.split(","),l=0,h=m.length;h>l;l++)for(i=m[l],a=0,p=o.length;p>a;a++)e=o[a],u|=e.e===i&&(e.c===r||r===t);break;case"function":for(f=0,g=o.length;g>f;f++)e=o[f],u|=e.c===s;break;case"object":for(i in s)u|=this.ones(i,s[i])}return 1===u},emit:function(){var t,r,e,i,s,o;for(t=n(arguments),e=t.shift(),o=this._listeners||[],i=0,s=o.length;s>i;i++)r=o[i],r.e===e&&r.c.apply(this,r.a.concat(t));return this}},Options={options:{},setOptions:function(t){var n,r;for(r=this.constructor,n={};r;){if("Options"in r){n=r.Options;break}r=r.__super__}return this.options=Hash.merge(n,t),this}},b=w(Lovely,{version:"1.4.1",modules:{},loading:{},baseUrl:"",hostUrl:"",module:j,bundle:{},A:n,L:p,H:h,ext:w,bind:d,trim:N,isString:E,isNumber:A,isFunction:x,isArray:O,isObject:$,Class:Class,List:List,Hash:Hash,Events:Events,Options:Options}),Lovely.modules["core-"+Lovely.version]=Lovely,L.Lovely=Lovely}).apply(this);
/**
 * lovely.io 'dom' module v1.4.2
 *
 * Copyright (C) 2013 Nikolay Nemshilov
 */
Lovely("dom-1.4.2", [], function() {
  var undefined = [][0];
  var global = this;
  var exports = {};

  var $, A, Browser, Class, Document, Element, Element_clean_style, Element_computed_styles, Element_create_fragment, Element_events, Element_fragment, Element_insert, Element_make_listeners, Element_parse_style, Element_read_styles, Element_recursively_collect, Element_tmp_cont, Element_wraps, Event, Events_delegation, Form, HTML, Input, L, NodeList, Ready_documents, Style, UID_KEY, UID_NUM, Window, Wrapper, Wrapper_Cache, bind, camelize, core, current_Document, dasherize, delegation_listeners, dimensions_hash, document, elements_cache, ensure_array, exports, ext, extract_scripts, focusio_boobler, global_eval, isArray, isElement, isObject, isString, mouseio_activate, mouseio_emit, mouseio_handler, mouseio_inactive, mouseio_index, mouseio_reset, trim, uid, window, wrap;

  core = Lovely.module('core');

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
      scripts += source + "\n";
      return '';
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
        if (raw_list === undefined) {
          raw_list = [];
        }
        for (var i=0, l=this.length=raw_list.length, key; i < l; i++) {
          this[i] = raw_list[i] instanceof Element ? raw_list[i] : (Wrapper_Cache[raw_list[i][UID_KEY]] || new Element(raw_list[i]));
        };

      }
      return this;
    },
    exists: function() {
      return this.length !== 0;
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
        cast = Wrapper.Cast(element);
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
    if (element instanceof Element) {
      return element;
    } else if (typeof element === 'string') {
      element = $(element)[0];
    } else if (element instanceof NodeList) {
      element = element[0];
    } else if (element != null && element.nodeType === 1) {
      return wrap(element);
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
    insert: function(content, position) {
      var element, scripts, _ref;
      element = this._;
      if (position === undefined) {
        position = 'bottom';
      }
      if (typeof content !== 'object') {
        _ref = extract_scripts('' + content), content = _ref[0], scripts = _ref[1];
      }
      if (content._ != null) {
        content = content._;
      }
      if (content.nodeType === undefined) {
        content = Element_create_fragment((position === 'bottom' || position === 'top' ? element : element.parentNode), content);
      }
      Element_insert[position](element, content);
      if (scripts !== null) {
        global_eval(scripts);
      }
      return this;
    },
    insertTo: function(element, position) {
      Element.resolve(element).insert(this, position);
      return this;
    },
    append: function(first) {
      return this.insert(typeof first === "string" ? A(arguments).join('') : arguments);
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
      if (target.nextSibling === null) {
        return target.parentNode.appendChild(content);
      } else {
        return target.parentNode.insertBefore(content, target.nextSibling);
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
      var inputs;
      inputs = this.find("*[name=\"" + name + "\"]");
      if (inputs.length !== 0 && inputs[0]._.type === 'radio') {
        return inputs;
      } else {
        return inputs[0];
      }
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
    version: '1.4.2',
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
