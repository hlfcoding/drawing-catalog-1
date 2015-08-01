var SketchElementary,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

SketchElementary = (function() {
  var ADD=ALIGN_CENTER=ALIGN_LEFT=ALIGN_RIGHT=ALPHA=ALPHA_MASK=ALT=AMBIENT=ARGB=ARROW=BACKSPACE=BASELINE=BEVEL=BLEND=BLUE_MASK=BLUR=BOTTOM=BURN=CENTER=CHATTER=CLOSE=CMYK=CODED=COMPLAINT=COMPONENT=COMPOSITE=CONCAVE_POLYGON=CONTROL=CONVEX_POLYGON=CORNER=CORNERS=CROSS=CUSTOM=DARKEST=DEGREES=DEG_TO_RAD=DELETE=DIAMETER=DIFFERENCE=DIFFUSE=DILATE=DIRECTIONAL=DISABLED=DODGE=DOWN=DXF=ENTER=EPSILON=ERODE=ESC=EXCLUSION=GIF=GRAY=GREEN_MASK=GROUP=HALF=HALF_PI=HAND=HARD_LIGHT=HINT_COUNT=HSB=IMAGE=INVERT=JAVA2D=JPEG=
  LEFT=LIGHTEST=LINES=LINUX=MACOSX=MAX_FLOAT=MAX_INT=MITER=MODEL=MOVE=MULTIPLY=NORMAL=NORMALIZED=NO_DEPTH_TEST=NTSC=ONE=OPAQUE=OPEN=OPENGL=ORTHOGRAPHIC=OVERLAY=P2D=P3D=PAL=PDF=PERSPECTIVE=PI=PIXEL_CENTER=POINT=POINTS=POSTERIZE=PROBLEM=PROJECT=QUADS=QUAD_STRIP=QUARTER_PI=RADIANS=RADIUS=RAD_TO_DEG=RED_MASK=REPLACE=RETURN=RGB=RIGHT=ROUND=SCREEN=SECAM=SHIFT=SOFT_LIGHT=SPECULAR=SQUARE=SUBTRACT=SVIDEO=TAB=TARGA=TEXT=TFF=THIRD_PI=THRESHOLD=TIFF=TOP=TRIANGLES=TRIANGLE_FAN=TRIANGLE_STRIP=TUNER=TWO=TWO_PI=UP=
  WAIT=WHITESPACE=XML=ArrayList=BufferedReader=Character=HashMap=Integer=PFont=PGraphics=PImage=PShader=PShape=PVector=PrintWriter=StringBuffer=abs=acos=addChild=alpha=ambient=ambientLight=append=applyMatrix=arc=asin=atan=atan2=background=beginCamera=beginContour=beginRaw=beginRecord=beginShape=bezier=bezierDetail=bezierPoint=bezierTangent=bezierVertex=binary=bind=blend=blendColor=blendMode=blue=box=breakShape=brightness=cache=camera=ceil=clip=color=colorMode=concat=constrain=copy=cos=createFont=createGraphics=
  createImage=createInput=createOutput=createPath=createReader=createShape=createWriter=cursor=curve=curveDetail=curvePoint=curveTangent=curveTightness=curveVertex=day=degrees=directionalLight=dist=draw=ellipse=ellipseMode=emissive=end=endCamera=endContour=endRaw=endRecord=endShape=exit=exp=expand=fill=filter=floor=focused=frustum=get=green=hex=hint=hour=hue=image=imageMode=join=keyPressed=keyReleased=keyTyped=lerp=lerpColor=lightFalloff=lightSpecular=lights=line=loadBytes=loadFont=loadImage=loadMatrix=
  loadPixels=loadShader=loadShape=loadStrings=loadType=log=doLoop=mag=map=match=matchAll=max=millis=min=minute=modelX=modelY=modelZ=month=mouseButton=mouseClicked=mouseDragged=mouseMoved=mousePressed=mouseReleased=nf=nfc=nfp=nfs=noClip=noCursor=noFill=noHint=noLights=noLoop=noSmooth=noStroke=noTint=noise=noiseDetail=noiseSeed=norm=normal=open=openStream=ortho=parseByte=perspective=point=pointLight=popMatrix=popStyle=pow=print=printCamera=printMatrix=printProjection=println=pushMatrix=pushStyle=quad=
  quadraticVertex=radians=random=randomSeed=rect=rectMode=red=redraw=requestImage=resetMatrix=resetShader=reverse=rotate=rotateX=rotateY=rotateZ=round=saturation=save=saveBytes=saveFile=saveFrame=savePath=saveStream=saveStrings=saveType=scale=screenX=screenY=screenZ=second=selectFolder=selectInput=selectOutput=set=setup=shader=shape=shapeMode=shearX=shearY=shininess=shorten=sin=sketchFile=sketchPath=smooth=sort=specular=sphere=sphereDetail=splice=split=splitTokens=spotLight=sq=sqrt=start=stop=stroke=
  strokeCap=strokeJoin=strokeWeight=subset=tan=text=textAlign=textAscent=textDescent=textFont=textLeading=textMode=textSize=textWidth=texture=textureMode=tint=translate=triangle=trim=unbinary=unhex=updatePixels=vertex=year=null,injectProcessingApi=function(a){ADD=a.ADD;ALIGN_CENTER=a.ALIGN_CENTER;ALIGN_LEFT=a.ALIGN_LEFT;ALIGN_RIGHT=a.ALIGN_RIGHT;ALPHA=a.ALPHA;ALPHA_MASK=a.ALPHA_MASK;ALT=a.ALT;AMBIENT=a.AMBIENT;ARGB=a.ARGB;ARROW=a.ARROW;BACKSPACE=a.BACKSPACE;BASELINE=a.BASELINE;BEVEL=a.BEVEL;BLEND=a.BLEND;
  BLUE_MASK=a.BLUE_MASK;BLUR=a.BLUR;BOTTOM=a.BOTTOM;BURN=a.BURN;CENTER=a.CENTER;CHATTER=a.CHATTER;CLOSE=a.CLOSE;CMYK=a.CMYK;CODED=a.CODED;COMPLAINT=a.COMPLAINT;COMPONENT=a.COMPONENT;COMPOSITE=a.COMPOSITE;CONCAVE_POLYGON=a.CONCAVE_POLYGON;CONTROL=a.CONTROL;CONVEX_POLYGON=a.CONVEX_POLYGON;CORNER=a.CORNER;CORNERS=a.CORNERS;CROSS=a.CROSS;CUSTOM=a.CUSTOM;DARKEST=a.DARKEST;DEGREES=a.DEGREES;DEG_TO_RAD=a.DEG_TO_RAD;DELETE=a.DELETE;DIAMETER=a.DIAMETER;DIFFERENCE=a.DIFFERENCE;DIFFUSE=a.DIFFUSE;DILATE=a.DILATE;
  DIRECTIONAL=a.DIRECTIONAL;DISABLED=a.DISABLED;DODGE=a.DODGE;DOWN=a.DOWN;DXF=a.DXF;ENTER=a.ENTER;EPSILON=a.EPSILON;ERODE=a.ERODE;ESC=a.ESC;EXCLUSION=a.EXCLUSION;GIF=a.GIF;GRAY=a.GRAY;GREEN_MASK=a.GREEN_MASK;GROUP=a.GROUP;HALF=a.HALF;HALF_PI=a.HALF_PI;HAND=a.HAND;HARD_LIGHT=a.HARD_LIGHT;HINT_COUNT=a.HINT_COUNT;HSB=a.HSB;IMAGE=a.IMAGE;INVERT=a.INVERT;JAVA2D=a.JAVA2D;JPEG=a.JPEG;LEFT=a.LEFT;LIGHTEST=a.LIGHTEST;LINES=a.LINES;LINUX=a.LINUX;MACOSX=a.MACOSX;MAX_FLOAT=a.MAX_FLOAT;MAX_INT=a.MAX_INT;MITER=a.MITER;
  MODEL=a.MODEL;MOVE=a.MOVE;MULTIPLY=a.MULTIPLY;NORMAL=a.NORMAL;NORMALIZED=a.NORMALIZED;NO_DEPTH_TEST=a.NO_DEPTH_TEST;NTSC=a.NTSC;ONE=a.ONE;OPAQUE=a.OPAQUE;OPEN=a.OPEN;OPENGL=a.OPENGL;ORTHOGRAPHIC=a.ORTHOGRAPHIC;OVERLAY=a.OVERLAY;P2D=a.P2D;P3D=a.P3D;PAL=a.PAL;PDF=a.PDF;PERSPECTIVE=a.PERSPECTIVE;PI=a.PI;PIXEL_CENTER=a.PIXEL_CENTER;POINT=a.POINT;POINTS=a.POINTS;POSTERIZE=a.POSTERIZE;PROBLEM=a.PROBLEM;PROJECT=a.PROJECT;QUADS=a.QUADS;QUAD_STRIP=a.QUAD_STRIP;QUARTER_PI=a.QUARTER_PI;RADIANS=a.RADIANS;RADIUS=
  a.RADIUS;RAD_TO_DEG=a.RAD_TO_DEG;RED_MASK=a.RED_MASK;REPLACE=a.REPLACE;RETURN=a.RETURN;RGB=a.RGB;RIGHT=a.RIGHT;ROUND=a.ROUND;SCREEN=a.SCREEN;SECAM=a.SECAM;SHIFT=a.SHIFT;SOFT_LIGHT=a.SOFT_LIGHT;SPECULAR=a.SPECULAR;SQUARE=a.SQUARE;SUBTRACT=a.SUBTRACT;SVIDEO=a.SVIDEO;TAB=a.TAB;TARGA=a.TARGA;TEXT=a.TEXT;TFF=a.TFF;THIRD_PI=a.THIRD_PI;THRESHOLD=a.THRESHOLD;TIFF=a.TIFF;TOP=a.TOP;TRIANGLES=a.TRIANGLES;TRIANGLE_FAN=a.TRIANGLE_FAN;TRIANGLE_STRIP=a.TRIANGLE_STRIP;TUNER=a.TUNER;TWO=a.TWO;TWO_PI=a.TWO_PI;UP=a.UP;
  WAIT=a.WAIT;WHITESPACE=a.WHITESPACE;XML=a.XML;ArrayList=a.ArrayList;BufferedReader=a.BufferedReader;Character=a.Character;HashMap=a.HashMap;Integer=a.Integer;PFont=a.PFont;PGraphics=a.PGraphics;PImage=a.PImage;PShader=a.PShader;PShape=a.PShape;PVector=a.PVector;PrintWriter=a.PrintWriter;StringBuffer=a.StringBuffer;abs=a.abs;acos=a.acos;addChild=a.addChild;alpha=a.alpha;ambient=a.ambient;ambientLight=a.ambientLight;append=a.append;applyMatrix=a.applyMatrix;arc=a.arc;asin=a.asin;atan=a.atan;atan2=a.atan2;
  background=a.background;beginCamera=a.beginCamera;beginContour=a.beginContour;beginRaw=a.beginRaw;beginRecord=a.beginRecord;beginShape=a.beginShape;bezier=a.bezier;bezierDetail=a.bezierDetail;bezierPoint=a.bezierPoint;bezierTangent=a.bezierTangent;bezierVertex=a.bezierVertex;binary=a.binary;bind=a.bind;blend=a.blend;blendColor=a.blendColor;blendMode=a.blendMode;blue=a.blue;box=a.box;breakShape=a.breakShape;brightness=a.brightness;cache=a.cache;camera=a.camera;ceil=a.ceil;clip=a.clip;color=a.color;
  colorMode=a.colorMode;concat=a.concat;constrain=a.constrain;copy=a.copy;cos=a.cos;createFont=a.createFont;createGraphics=a.createGraphics;createImage=a.createImage;createInput=a.createInput;createOutput=a.createOutput;createPath=a.createPath;createReader=a.createReader;createShape=a.createShape;createWriter=a.createWriter;cursor=a.cursor;curve=a.curve;curveDetail=a.curveDetail;curvePoint=a.curvePoint;curveTangent=a.curveTangent;curveTightness=a.curveTightness;curveVertex=a.curveVertex;day=a.day;degrees=
  a.degrees;directionalLight=a.directionalLight;dist=a.dist;draw=a.draw;ellipse=a.ellipse;ellipseMode=a.ellipseMode;emissive=a.emissive;end=a.end;endCamera=a.endCamera;endContour=a.endContour;endRaw=a.endRaw;endRecord=a.endRecord;endShape=a.endShape;exit=a.exit;exp=a.exp;expand=a.expand;fill=a.fill;filter=a.filter;floor=a.floor;focused=a.focused;frustum=a.frustum;get=a.get;green=a.green;hex=a.hex;hint=a.hint;hour=a.hour;hue=a.hue;image=a.image;imageMode=a.imageMode;join=a.join;keyReleased=a.keyReleased;
  keyTyped=a.keyTyped;lerp=a.lerp;lerpColor=a.lerpColor;lightFalloff=a.lightFalloff;lightSpecular=a.lightSpecular;lights=a.lights;line=a.line;loadBytes=a.loadBytes;loadFont=a.loadFont;loadImage=a.loadImage;loadMatrix=a.loadMatrix;loadPixels=a.loadPixels;loadShader=a.loadShader;loadShape=a.loadShape;loadStrings=a.loadStrings;loadType=a.loadType;log=a.log;doLoop=a.loop;mag=a.mag;map=a.map;match=a.match;matchAll=a.matchAll;max=a.max;millis=a.millis;min=a.min;minute=a.minute;modelX=a.modelX;modelY=a.modelY;
  modelZ=a.modelZ;month=a.month;mouseButton=a.mouseButton;mouseClicked=a.mouseClicked;mouseDragged=a.mouseDragged;mouseMoved=a.mouseMoved;mouseReleased=a.mouseReleased;nf=a.nf;nfc=a.nfc;nfp=a.nfp;nfs=a.nfs;noClip=a.noClip;noCursor=a.noCursor;noFill=a.noFill;noHint=a.noHint;noLights=a.noLights;noLoop=a.noLoop;noSmooth=a.noSmooth;noStroke=a.noStroke;noTint=a.noTint;noise=a.noise;noiseDetail=a.noiseDetail;noiseSeed=a.noiseSeed;norm=a.norm;normal=a.normal;open=a.open;openStream=a.openStream;ortho=a.ortho;
  parseByte=a.parseByte;perspective=a.perspective;point=a.point;pointLight=a.pointLight;popMatrix=a.popMatrix;popStyle=a.popStyle;pow=a.pow;print=a.print;printCamera=a.printCamera;printMatrix=a.printMatrix;printProjection=a.printProjection;println=a.println;pushMatrix=a.pushMatrix;pushStyle=a.pushStyle;quad=a.quad;quadraticVertex=a.quadraticVertex;radians=a.radians;random=a.random;randomSeed=a.randomSeed;rect=a.rect;rectMode=a.rectMode;red=a.red;redraw=a.redraw;requestImage=a.requestImage;resetMatrix=
  a.resetMatrix;resetShader=a.resetShader;reverse=a.reverse;rotate=a.rotate;rotateX=a.rotateX;rotateY=a.rotateY;rotateZ=a.rotateZ;round=a.round;saturation=a.saturation;save=a.save;saveBytes=a.saveBytes;saveFile=a.saveFile;saveFrame=a.saveFrame;savePath=a.savePath;saveStream=a.saveStream;saveStrings=a.saveStrings;saveType=a.saveType;scale=a.scale;screenX=a.screenX;screenY=a.screenY;screenZ=a.screenZ;second=a.second;selectFolder=a.selectFolder;selectInput=a.selectInput;selectOutput=a.selectOutput;set=
  a.set;setup=a.setup;shader=a.shader;shape=a.shape;shapeMode=a.shapeMode;shearX=a.shearX;shearY=a.shearY;shininess=a.shininess;shorten=a.shorten;sin=a.sin;size=a.size;sketchFile=a.sketchFile;sketchPath=a.sketchPath;smooth=a.smooth;sort=a.sort;specular=a.specular;sphere=a.sphere;sphereDetail=a.sphereDetail;splice=a.splice;split=a.split;splitTokens=a.splitTokens;spotLight=a.spotLight;sq=a.sq;sqrt=a.sqrt;start=a.start;stop=a.stop;stroke=a.stroke;strokeCap=a.strokeCap;strokeJoin=a.strokeJoin;strokeWeight=
  a.strokeWeight;subset=a.subset;tan=a.tan;text=a.text;textAlign=a.textAlign;textAscent=a.textAscent;textDescent=a.textDescent;textFont=a.textFont;textLeading=a.textLeading;textMode=a.textMode;textSize=a.textSize;textWidth=a.textWidth;texture=a.texture;textureMode=a.textureMode;tint=a.tint;translate=a.translate;triangle=a.triangle;trim=a.trim;unbinary=a.unbinary;unhex=a.unhex;updatePixels=a.updatePixels;vertex=a.vertex;year=a.year;this.__defineGetter__("displayHeight",function(){return a.displayHeight});
  this.__defineGetter__("displayWidth",function(){return a.displayWidth});this.__defineGetter__("frameCount",function(){return a.frameCount});this.__defineGetter__("frameRate",function(){return a.frameRate});this.__defineGetter__("height",function(){return a.height});this.__defineGetter__("key",function(){return a.key});this.__defineGetter__("keyCode",function(){return a.keyCode});this.__defineGetter__("keyPressed",function(){return a.keyPressed});this.__defineGetter__("mousePressed",function(){return a.mousePressed});
  this.__defineGetter__("mouseX",function(){return a.mouseX});this.__defineGetter__("mouseY",function(){return a.mouseY});this.__defineGetter__("online",function(){return!0});this.__defineGetter__("pixels",function(){return a.pixels});this.__defineGetter__("pmouseX",function(){return a.pmouseX});this.__defineGetter__("pmouseY",function(){return a.pmouseY});this.__defineGetter__("screenHeight",function(){return a.screenHeight});this.__defineGetter__("screenWidth",function(){return a.screenWidth});this.__defineGetter__("width",
  function(){return a.width})};


  var Node, Wrap, sketch;

  SketchElementary.name = 'SketchElementary';

  function SketchElementary() {}

  sketch = null;

  SketchElementary.prototype.setup = function() {
    (function(processing){injectProcessingApi(processing);size=function csModeApiInjectIffy (){processing.size.apply(processing,arguments);injectProcessingApi(processing);}})(this);

    var h, w, _ref;
    sketch = this;
    this.state = {
      frozen: false,
      speedFactor: 0
    };
    this._setupConstants();
    this._setupExtensions();
    this.state.frameRate = frameRate.FILM;
    this._updateSpeedFactor();
    this._setupClasses();
    colorMode(RGB, 255);
    noStroke();
    _ref = size.MEDIUM, w = _ref[0], h = _ref[1];
    size(w, h);
    background(color.WHITE);
    this._setupStage();
    this._setupScreens();
    return this._setupGUI();
  };

  SketchElementary.prototype._setupConstants = function() {
    /*
        Constants, when possible, are attached to the Processing (sketch) API methods.
        This is because scope globals are of limited use in CS mode, and globalized
        methods are conveniently fitting as namespaces, despite being a little risky
        to modify.
    */
    color.BLACK = color(0);
    color.WHITE = color(255);
    color.RED = color(255, 0, 0);
    frameRate.DEBUG = 1;
    frameRate.ANIMATION = 12;
    frameRate.FILM = 24;
    frameRate.VIDEO = 30;
    frameRate.REAL = 60;
    size.SMALL = [300, 300];
    size.MEDIUM = [720, 480];
    return size.TWITTER = [1252, 626];
  };

  SketchElementary.prototype._setupExtensions = function() {
    /*
        PVector extension to add helper constants and methods for the sketch. The main
        addition is the concept of a vector type.
    */

    var _this = this;
    PVector.G = 0.01;
    PVector.GENERIC = 0;
    PVector.POSITION = 1;
    PVector.VELOCITY = 2;
    PVector.ACCELERATION = 3;
    PVector.GRAVITY = 1 << 0;
    PVector.ATTRACTION = 1 << 1;
    PVector.createGravity = function() {
      var vec;
      vec = new PVector(0, _this.state.speedFactor / 2);
      vec.type = PVector.GRAVITY;
      return vec;
    };
    PVector.prototype.randomize = function() {
      if (this.type !== PVector.POSITION) {
        return;
      }
      this.x = random(width);
      return this.y = random(height);
    };
    /*
        Add helpers to the color API methods, mainly for conversion.
    */

    color.ensure = function(c) {
      if (c > 0) {
        return c - 16777216;
      } else {
        return c;
      }
    };
    color.transparentize = function(c, ratio) {
      return color(red(c), green(c), blue(c), alpha(c) * ratio);
    };
    /*
        Add helpers to number methods, mainly for macro-calculations.
    */

    random.dualScale = function(n) {
      return random(1, n) / random(1, n);
    };
    random.item = function(list) {
      return list[_.random(list.length - 1)];
    };
    random.signed = function() {
      return random(-1, 1);
    };
    /*
        Add core helpers.
    */

    return Processing.isKindOfClass = function(obj, aClass) {
      var test;
      test = obj.constructor === aClass;
      if (!bool && (obj.constructor.__super__ != null)) {
        test = isKindOfClass(obj.constructor.__super__, aClass);
      }
      return test;
    };
  };

  SketchElementary.prototype._setupClasses = function() {
    Node.setup();
    return Wrap.setup();
  };

  SketchElementary.prototype._setupGUI = function() {
    /*
        The sketch has state and the datGUI library builds an interface to manipulate
        and tune that state for various results.
    */

    var button, colorPicker, createNodeParamsUpdater, folder, gui, range, select, toggle,
      _this = this;
    gui = new dat.GUI();
    folder = gui.addFolder('sketch');
    toggle = folder.add(this.state, 'frozen');
    toggle.onFinishChange(function(toggled) {
      return _this.freeze(toggled);
    });
    select = folder.add(this.state, 'frameRate', {
      'Debug': frameRate.DEBUG,
      'Animation': frameRate.ANIMATION,
      'Film': frameRate.FILM,
      'Video': frameRate.VIDEO,
      'Real': frameRate.REAL
    });
    select.onFinishChange(function(option) {
      return _this.state.frameRate = parseInt(option, 10);
    });
    button = folder.add(this, 'exportScreen');
    folder = gui.addFolder('colors');
    colorPicker = folder.addColor(this.stage, 'fill');
    colorPicker.onChange(function(color) {
      return _this.stage.fillColor(color);
    });
    colorPicker.onFinishChange(function(color) {
      return _this.stage.fillColor(color);
    });
    folder = gui.addFolder('stage');
    createNodeParamsUpdater = function(attribute) {
      return function(value) {
        var n, _i, _len, _ref, _results;
        _ref = _this.stage.nodes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          n = _ref[_i];
          _results.push(n[attribute] = value);
        }
        return _results;
      };
    };
    range = folder.add(this.stage, 'frictionMag', 0.001, 0.1);
    range = folder.add(this.stage, 'entropy', 0, 2);
    range = folder.add(this.stage, 'nodeCount', 0, 500);
    range.onFinishChange(function(count) {
      return _this.stage.updateNodeCount(count);
    });
    range = folder.add(this.stage.nodeParams, 'vMax', 0, this.stage.nodeParams.vMax * 2);
    range.onFinishChange(createNodeParamsUpdater('vMax'));
    toggle = folder.add(this.stage, 'gravity');
    toggle.onFinishChange(function(toggled) {
      _this.stage.containment = toggled ? Wrap.REFLECTIVE : Wrap.TOROIDAL;
      return _this.stage.toggleForce(PVector.GRAVITY, toggled);
    });
    toggle = folder.add(this.stage.nodeParams, 'collide');
    toggle.onFinishChange(createNodeParamsUpdater('collide'));
    toggle = folder.add(this.stage.nodeParams, 'varyMass');
    toggle.onFinishChange(createNodeParamsUpdater('varyMass'));
    select = folder.add(this.stage, 'containment', {
      'Reflective': Wrap.REFLECTIVE,
      'Toroidal': Wrap.TOROIDAL
    });
    select.onFinishChange(function(option) {
      return _this.stage.containment = parseInt(option, 10);
    });
    select = folder.add(this.stage.nodeParams, 'viewMode', {
      'Ball': Node.BALL,
      'Line': Node.LINE
    });
    select.onFinishChange(function(option) {
      return _this.stage.onNodeViewModeChange(parseInt(option, 10));
    });
    button = folder.add(this.stage, 'clear');
    dat.GUI.shared = gui;
    return gui.open();
  };

  SketchElementary.prototype._setupScreens = function() {
    /*
        Screens can store and restore canvas state when switching between different
        draw modes.
    */
    this._screenStacks = {};
    this._screenStacks[Wrap.TRACE] = [];
    return this._screenStacks[Wrap.DEFAULT] = [];
  };

  SketchElementary.prototype._setupStage = function() {
    /*
        The sketch only has one Wrap, and filling the sketch, it acts like a 'stage'.
    */

    var wind;
    wind = new PVector(0.001, 0);
    this.stage = new Wrap({
      id: 1,
      containment: Wrap.TOROIDAL,
      customForces: [wind],
      h: height,
      w: width
    });
    this.stage.updateNodeCount();
    this.stage.ready(true);
    return this.canvasElement().focus();
  };

  SketchElementary.prototype.draw = function() {
    return this.stage.draw();
  };

  SketchElementary.prototype.freeze = function(frozen) {
    /*
        One of the first things we need to do is to be able to control the cycle-
        expensive run state without stopping the server. This is especially handy when
        LiveReload is used.
    */

    var n, _i, _len, _ref;
    if (frozen == null) {
      frozen = this.state.frozen;
    }
    _ref = this.stage.nodes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      n = _ref[_i];
      n.move = !frozen;
    }
    if (frozen) {
      noLoop();
    } else {
      this.loop();
    }
    return this.state.frozen = frozen;
  };

  SketchElementary.prototype._updateSpeedFactor = function() {
    this.state.speedFactor = frameRate.REAL / this.state.frameRate;
    return frameRate(this.state.frameRate);
  };

  SketchElementary.prototype.canvasElement = function() {
    return this.contentElement().querySelector('canvas');
  };

  SketchElementary.prototype.contentElement = function() {
    return document.getElementById('content');
  };

  SketchElementary.prototype.exportScreen = function() {
    var img;
    img = document.createElement('img');
    img.src = this.canvasElement().toDataURL();
    if (this._imgPrev != null) {
      this.contentElement().insertBefore(img, this._imgPrev);
    } else {
      this.contentElement().appendChild(img);
    }
    return this._imgPrev = img;
  };

  SketchElementary.prototype.pushScreen = function(customStack) {
    var context, screen, stack, _ref;
    _ref = this._screenUpdateVars(), context = _ref[0], stack = _ref[1];
    if (customStack != null) {
      stack = customStack;
    }
    screen = context.getImageData(0, 0, width, height);
    return this._screenStacks[stack].push(screen);
  };

  SketchElementary.prototype.popScreen = function() {
    var context, stack, _ref;
    _ref = this._screenUpdateVars(), context = _ref[0], stack = _ref[1];
    if (!this._screenStacks[stack].length) {
      return;
    }
    return context.putImageData(this._screenStacks[stack].pop(), 0, 0);
  };

  SketchElementary.prototype._screenUpdateVars = function() {
    var context, stack;
    context = this.canvasElement().getContext('2d');
    stack = this.stage.trace === true ? Wrap.TRACE : Wrap.DEFAULT;
    return [context, stack];
  };

  SketchElementary.prototype.mouseClicked = function() {
    return this.stage.mouseClicked();
  };

  Node = (function() {

    Node.name = 'Node';

    function Node(params) {
      var accessor, attribute, value, x, y, z;
      if (params == null) {
        params = Node.defaults;
      }
      /*
            Node constructs as dynamically as possible, and has a large set of default
            params. Vectors are auto-constructed and typed. Size and mass are calculated
            automatically if possible.
      */

      if (params !== Node.defaults) {
        _.defaults(params, Node.defaults);
      }
      for (attribute in params) {
        value = params[attribute];
        if (value instanceof Array && value.length === 3) {
          x = value[0], y = value[1], z = value[2];
          value = new PVector(x, y, z);
        }
        accessor = this.getAccessor(attribute);
        if (accessor != null) {
          accessor(value);
        } else {
          this[attribute] = value;
        }
      }
      this.p.type = PVector.POSITION;
      this.v.type = PVector.VELOCITY;
      this.a.type = PVector.ACCELERATION;
      if (this.m == null) {
        this.mass(Node.AUTO_MASS);
      }
      this._aCached = null;
      this._pFill = null;
      this._repellent = null;
      this._repellentSelectedAt = 0;
      this.attractorDist = null;
      this.repellentCandidates = [];
      this.tempRepulsion = null;
      this.isAttractor(this.attract);
    }

    Node.prototype.destroy = function() {
      var _ref;
      if ((_ref = this.wrap) != null) {
        _ref.removeNode(this);
      }
      this._repellent = null;
      return this.repellentCandidates = null;
    };

    /*
        Node can render using one or more different view modes.
    */


    Node.FORMLESS = 0;

    Node.BALL = 1 << 0;

    Node.LINE = 1 << 1;

    Node.AUTO_MASS = 1;

    Node.ATTRIBUTE_TO_ACCESSOR = {
      w: 'width',
      h: 'height',
      m: 'mass'
    };

    Node.defaults = {
      id: -1,
      wrap: null,
      p: [0, 0, 0],
      v: [0, 0, 0],
      a: [0, 0, 0],
      w: 10,
      h: 10,
      m: null,
      mMax: 100,
      vMax: 1,
      density: 1,
      attractFieldMin: 40,
      attractFieldMax: 80,
      attractDecayRate: 0.01,
      evadeLifespan: 5,
      tempRepulsionDecayRate: 0.05,
      attract: false,
      autoMass: true,
      autoSize: true,
      collide: true,
      move: true,
      varyMass: false
    };

    Node.setup = function() {
      /*
            This needs to be called for the class to be ready for use. Some default
            attributes reference other values not ready on initial declaration.
      */
      this.defaults.fill = color.BLACK;
      this.defaults.stroke = color.BLACK;
      this.defaults.viewMode = this.BALL;
      return this.defaults.attractConst = PVector.G;
    };

    Node.prototype.draw = function() {
      if (this.move) {
        this.updateMovement();
      }
      if (this.attract) {
        this.updateAttraction();
      }
      if (this.viewMode & Node.BALL) {
        noStroke();
        if (this.fill !== false) {
          fill(this.fillColor());
        }
        ellipse(this.x(), this.y(), this.w, this.h);
      }
      if (this.viewMode & Node.LINE && this.shouldDrawLine()) {
        noFill();
        strokeWeight(0.1);
        stroke(color.transparentize(this.strokeColor(), 0.33));
        line(this.x(), this.y(), this.px(), this.py());
      }
      return this.updateStorage();
    };

    Node.prototype.drawBoundsRect = function() {
      return rect(this.top(), this.left(), this.width(), this.height());
    };

    Node.prototype.shouldDrawLine = function() {
      return (this.pPrev != null) && this.p.dist(this.pPrev) < this.w;
    };

    Node.prototype.updateAttraction = function() {
      var updateRepellent,
        _this = this;
      if (this._attractLifespan <= 0) {
        return this.isAttractor(false);
      }
      this.withNeighbors(function(n) {
        return _this.attractNode(n);
      });
      this._attractLifespan -= this.attractDecayRate * this._attractLifespan;
      updateRepellent = this.repellentCandidates.length && millis() - this._repellentSelectedAt > this.evadeLifespan * 1000;
      if (updateRepellent) {
        this._repellent = random.item(this.repellentCandidates);
        this._repellentSelectedAt = millis();
      }
      if (this._repellent != null) {
        return this.evadeNode(this._repellent);
      }
    };

    Node.prototype.updateMovement = function() {
      var _ref;
      this.v.add(this.a);
      this.refineVelocity();
      this.p.add(this.v);
      this.resetAcceleration();
      return (_ref = this.wrap) != null ? _ref.nodeMoved(this) : void 0;
    };

    Node.prototype.updateStorage = function() {
      if (this.viewMode & Node.LINE) {
        if (this.shouldDrawLine()) {
          return this.pPrev.set(this.p);
        } else {
          return this.pPrev = this.p.get();
        }
      }
    };

    Node.prototype.log = function() {
      return console.info(this);
    };

    Node.prototype.overlapsWith = function(x, y) {
      return abs(this.x() - x) < (this.w / 2) && abs(this.y() - y) < (this.h / 2);
    };

    Node.prototype.applyForce = function(vec, toggled) {
      var mutableVec;
      if (toggled == null) {
        toggled = true;
      }
      mutableVec = vec.get();
      if (vec.type !== PVector.GRAVITY) {
        mutableVec.div(this.m);
      }
      if (toggled === true) {
        return this.a.add(vec);
      } else {
        return this.a.sub(vec);
      }
    };

    Node.prototype.attractNode = function(n) {
      var d, f, strength;
      if (n.tempRepulsion != null) {
        n.applyForce(n.tempRepulsion);
        n.attractorDist = PVector.dist(this.p, n.p);
        n.tempRepulsion.mult(1 - this.tempRepulsionDecayRate);
        if (n.tempRepulsion.mag() < 0.01) {
          n.tempRepulsion = null;
        }
        return false;
      }
      f = PVector.sub(this.p, n.p);
      f.type = PVector.ATTRACTION;
      d = constrain(f.mag(), this.attractFieldMin, this.attractFieldMax);
      strength = (this.attractConst * this.mass() * n.mass()) / sq(d);
      f.normalize();
      f.mult(strength);
      n.applyForce(f);
      n.attractorDist = PVector.dist(this.p, n.p);
      return n.onAttract(this, f);
    };

    Node.prototype.evadeNode = function(n) {
      var f, variance;
      f = n.a.get();
      variance = new PVector(random.signed(), random.signed());
      variance.div(10);
      f.add(variance);
      return this.applyForce(f);
    };

    Node.prototype.refineVelocity = function() {
      return this.v.limit(this.vMax);
    };

    Node.prototype.resetAcceleration = function() {
      if (this._aCached != null) {
        return this.a = this._aCached.get();
      } else {
        return this.a.mult(0);
      }
    };

    /*
        Caching allows the resulting acceleration to be committed into cache and
        reused later as base.
    */


    Node.prototype.cacheAcceleration = function() {
      return this._aCached = this.a.get();
    };

    /*
        Use accessors for public access when possible instead of the attributes, which
        are generally private outside of construction. Also note accessor names are
        adjusted, so they don't conflict with their respective attributes. Lastly, the
        main reason to wrap attributes in accessors is to allow for will-set and
        did-set behaviors, as well as additional transformations.
    */


    Node.prototype.getAccessor = function(attribute) {
      var accessor;
      accessor = this[attribute];
      if (accessor == null) {
        accessor = this[Node.ATTRIBUTE_TO_ACCESSOR[attribute]];
      }
      if (accessor == null) {
        accessor = this["" + attribute + "Color"];
      }
      if (typeof accessor === 'function') {
        return accessor.bind(this);
      }
      return;
    };

    Node.prototype.width = function(w) {
      var wPrev;
      if (w != null) {
        wPrev = this.w;
        this.w = w;
        this.mass(Node.AUTO_MASS);
        this.attractFieldMin *= this.w / wPrev;
        this.attractFieldMax *= this.w / wPrev;
      }
      return this.w;
    };

    Node.prototype.height = function(h) {
      if (h != null) {
        this.h = h;
        this.mass(Node.AUTO_MASS);
      }
      return this.h;
    };

    Node.prototype.radius = function(r) {
      if (r != null) {
        this.width(r * 2);
        this.h = this.w;
      }
      return this.w / 2;
    };

    Node.prototype.mass = function(m) {
      if (m != null) {
        if (m !== Node.AUTO_MASS) {
          this.m = m;
        } else if (this.autoMass === true) {
          this.m = this.w * this.h * this.density;
        }
        if (this.varyMass === true) {
          this.m *= sqrt(random.dualScale(this.mMax));
        }
        if (this.autoSize === true && (this.m != null)) {
          this.w = this.h = this.m / this.w / this.density;
        }
      }
      return this.m;
    };

    Node.prototype.isAttractor = function(bool) {
      if (bool != null) {
        this.attract = bool;
        if (this._pFill == null) {
          this._pFill = this.fill;
        }
        this.fillColor(this.attract === true ? color.RED : this._pFill);
        if (this.attract === true) {
          this._attractLifespan = 1.0;
        }
        this.evade = bool;
      }
      return this.attract;
    };

    /*
        As an exception, try to always use the position accessors, since they wrap a
        complex object.
    */


    Node.prototype.x = function(x) {
      if (x != null) {
        this.p.x = x;
      }
      return this.p.x;
    };

    Node.prototype.y = function(y) {
      if (y != null) {
        this.p.y = y;
      }
      return this.p.y;
    };

    Node.prototype.z = function(z) {
      if (z != null) {
        this.p.z = z;
      }
      return this.p.z;
    };

    Node.prototype.px = function() {
      return this.pPrev.x;
    };

    Node.prototype.py = function() {
      return this.pPrev.y;
    };

    Node.prototype.pz = function() {
      return this.pPrev.z;
    };

    /*
        Note these assume ellipseMode or rectMode is CENTER.
    */


    Node.prototype.top = function(t) {
      if (t != null) {
        this.y(t + this.h / 2);
      }
      return this.y() - this.h / 2;
    };

    Node.prototype.bottom = function(b) {
      if (b != null) {
        this.y(b - this.h / 2);
      }
      return this.y() + this.h / 2;
    };

    Node.prototype.left = function(l) {
      if (l != null) {
        this.x(l + this.w / 2);
      }
      return this.x() - this.w / 2;
    };

    Node.prototype.right = function(r) {
      if (r != null) {
        this.x(r - this.w / 2);
      }
      return this.x() + this.w / 2;
    };

    Node.prototype.fillColor = function(fc) {
      if (fc != null) {
        this.fill = color.ensure(fc);
      }
      return this.fill;
    };

    Node.prototype.strokeColor = function(sc) {
      if (sc != null) {
        this.stroke = color.ensure(sc);
      }
      return this.stroke;
    };

    Node.prototype.withNeighbors = function(fn) {
      var n, _i, _len, _ref, _results;
      _ref = this.wrap.nodes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        n = _ref[_i];
        if (n !== this) {
          _results.push(fn(n));
        }
      }
      return _results;
    };

    Node.prototype.handleClick = function(c) {
      var should;
      should = this.overlapsWith(c.mouseX, c.mouseY);
      if (!should) {
        return false;
      }
      this.isAttractor(!this.attract);
      return true;
    };

    Node.prototype.onAttract = function(attractor, f) {
      var d, _base, _name;
      d = this.p.dist(attractor.p);
      if (d < this.attractFieldMin) {
        this.tempRepulsion = f.get();
        this.tempRepulsion.mult(-1);
      } else {
        if (attractor.mass() < this.m) {
          if ((_base = attractor.repellentCandidates)[_name = this.id] == null) {
            _base[_name] = this;
          }
        } else if (attractor.repellentCandidates[this.id] != null) {
          delete attractor.repellentCandidates[this.id];
        }
      }
      if (this.collide === false || (d > this.radius() && d > attractor.radius())) {
        return;
      }
      if (this.isAttractor() && this.m > attractor.mass) {
        return attractor.destroy();
      } else {
        return this.destroy();
      }
    };

    return Node;

  })();

  Wrap = (function(_super) {

    __extends(Wrap, _super);

    Wrap.name = 'Wrap';

    function Wrap(params) {
      if (params == null) {
        params = Wrap.defaults;
      }
      if (params !== Wrap.defaults) {
        _.defaults(params, Wrap.defaults);
      }
      Wrap.__super__.constructor.call(this, params);
      this._allForces = null;
      this._isReady = false;
      this._needsClear = false;
      this.nodes = [];
    }

    /*
        Wrap can contain its nodes using distinct modes.
    */


    Wrap.UNCONTAINED = 0;

    Wrap.REFLECTIVE = 1;

    Wrap.TOROIDAL = 2;

    /*
        Wrap can render its nodes to screen in distinct states.
    */


    Wrap.DEFAULT = 0;

    Wrap.TRACE = 1;

    /*
        Wrap can layout its nodes in distinct patterns.
    */


    Wrap.UNIFORM = 0;

    Wrap.RANDOM = 1;

    Wrap.defaults = {
      entropy: 1,
      autoReplace: true,
      contain: true,
      drainAtEdge: true,
      forceOptions: 0,
      customForces: [],
      autoMass: false,
      gravity: false,
      move: false,
      trace: false,
      varyMass: false,
      nodeDensity: 1 / 10,
      nodeParams: {
        collide: true,
        varyMass: true
      }
    };

    Wrap.setup = function() {
      /*
            This needs to be called for the class to be ready for use. Some default
            attributes reference other values not ready on initial declaration.
      */
      _.defaults(this.defaults, Node.defaults);
      this.defaults.fill = color.WHITE;
      this.defaults.traceFill = this.traceFillColor(this.defaults.fill);
      this.defaults.containment = Wrap.REFLECTIVE;
      this.defaults.layoutPattern = Wrap.RANDOM;
      this.defaults.viewMode = Node.FORMLESS;
      this.defaults.nodeParams.viewMode = Node.BALL;
      this.defaults.nodeParams.vMax = Node.defaults.vMax;
      return this.defaults.frictionMag = 0.01 * sketch.state.speedFactor;
    };

    Wrap.traceFillColor = function(fc) {
      return color.transparentize(fc, 0.01);
    };

    Wrap.prototype.draw = function() {
      var isTraceFrame, n, tracePrev, _i, _len, _ref, _results;
      tracePrev = this.trace;
      this.trace = this.nodeParams.viewMode === Node.LINE;
      if (tracePrev === true && this.trace !== tracePrev) {
        sketch.pushScreen(Wrap.TRACE);
      }
      isTraceFrame = millis() % (sketch.state.frameRate * 10) === 0;
      if (this.trace === true && isTraceFrame) {
        fill(this.getTraceFillColor());
        this.drawBoundsRect();
        noFill();
      }
      if (this.trace === false || this._needsClear) {
        fill(this.fillColor());
        this.drawBoundsRect();
        if (this._needsClear) {
          this._needsClear = false;
          sketch.popScreen();
        }
      }
      _ref = this.nodes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        n = _ref[_i];
        _results.push(n != null ? n.draw() : void 0);
      }
      return _results;
    };

    Wrap.prototype.radius = function() {
      return false;
    };

    Wrap.prototype.left = function() {
      return this.x();
    };

    Wrap.prototype.top = function() {
      return this.y();
    };

    Wrap.prototype.right = function() {
      return this.w + this.left();
    };

    Wrap.prototype.bottom = function() {
      return this.h + this.top();
    };

    Wrap.prototype.fillColor = function(fc) {
      if (fc != null) {
        this.traceFill = Wrap.traceFillColor(fc);
      }
      return Wrap.__super__.fillColor.call(this, fc);
    };

    Wrap.prototype.clear = function() {
      fill(this.fillColor());
      return this.drawBoundsRect();
    };

    Wrap.prototype.removeNode = function(n) {
      n.wrap = null;
      this.nodes.splice(this.nodes.indexOf(n), 1);
      if (this.autoReplace) {
        return this.updateNodeCount(this.nodes.length);
      }
    };

    Wrap.prototype.updateNodeCount = function(count, customNodeParams) {
      var currentCount, gravity, hasGravity, i, _fn, _i, _ref, _ref1,
        _this = this;
      if (count == null) {
        count = parseInt(this.width() * this.nodeDensity);
      }
      currentCount = this.nodes.length;
      if (count < currentCount) {
        return (function() {
          var _i, _ref, _results;
          _results = [];
          for (i = _i = _ref = currentCount - 1; _ref <= count ? _i < count : _i > count; i = _ref <= count ? ++_i : --_i) {
            _results.push(this.nodes.pop());
          }
          return _results;
        }).call(this);
      }
      hasGravity = !!(this.forceOptions & PVector.GRAVITY);
      if (hasGravity) {
        gravity = PVector.createGravity();
      }
      _fn = function(ordinal) {
        var f, n, nodeParams, _j, _len, _ref1;
        nodeParams = _.extend({}, _this.nodeParams, customNodeParams, {
          id: currentCount + ordinal,
          wrap: _this
        });
        n = new Node(nodeParams);
        if (_this.layoutPattern === Wrap.RANDOM && !((customNodeParams != null ? customNodeParams.p : void 0) != null)) {
          n.p.randomize();
        }
        if (hasGravity) {
          n.applyForce(gravity);
        }
        _ref1 = _this.customForces;
        for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
          f = _ref1[_j];
          n.applyForce(f);
        }
        n.cacheAcceleration();
        return _this.nodes.push(n);
      };
      for (i = _i = 0, _ref = count - currentCount; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        _fn(i + 1);
      }
      return (_ref1 = this.nodeCount) != null ? _ref1 : this.nodeCount = this.nodes.length;
    };

    Wrap.prototype.updateNodeContainment = function(n) {
      var contained, shift,
        _this = this;
      shift = this.gravity === true ? 1 : 1 - this.entropy;
      if (this.containment === Wrap.REFLECTIVE) {
        return (function(v) {
          if (n.right() > _this.right()) {
            n.right(_this.right());
            if (v.x > 0) {
              v.x *= -shift;
            }
          } else if (n.left() < _this.left()) {
            n.left(_this.left());
            if (v.x < 0) {
              v.x *= -shift;
            }
          }
          if (n.bottom() > _this.bottom()) {
            n.bottom(_this.bottom());
            if (v.y > 0) {
              return v.y *= -shift;
            }
          } else if (n.y() < _this.top()) {
            n.top(_this.top());
            if (v.y < 0) {
              return v.y *= -shift;
            }
          }
        })(n.v);
      } else if (this.containment === Wrap.TOROIDAL) {
        contained = {
          x: true,
          y: true
        };
        if (n.left() > this.right()) {
          n.right(this.left());
        } else if (n.right() < this.left()) {
          n.left(this.right());
        } else {
          contained.x = false;
        }
        if (n.top() > this.bottom()) {
          n.bottom(this.top());
        } else if (n.bottom() < this.top()) {
          n.top(this.bottom());
        } else {
          contained.y = false;
        }
        if (this.drainAtEdge === true && (contained.x || contained.y)) {
          n.v.normalize();
          return n.a.normalize();
        }
      }
    };

    Wrap.prototype.applyNodeFriction = function(n) {
      var friction;
      friction = n.v.get();
      friction.normalize();
      friction.mult(-1 * this.frictionMag);
      return n.applyForce(friction);
    };

    Wrap.prototype.toggleForce = function(f, toggled) {
      var isForceName, isForceOption, n, vec, _i, _len, _ref, _results;
      if (toggled == null) {
        return false;
      }
      if (this._allForces == null) {
        this._allForces = this.customForces;
      }
      isForceOption = typeof f === 'number';
      isForceName = __indexOf.call(this._allForces, f) >= 0;
      if (isForceOption) {
        if (f === PVector.GRAVITY) {
          vec = PVector.createGravity();
        }
        if (toggled === true) {
          this.forceOptions |= f;
        } else {
          this.forceOptions ^= f;
        }
      } else if (isForceName) {
        vec = this._allForces[f];
        if (toggled === true) {
          this.customForces.push(vec);
        } else {
          this.customForces.splice(this.customForces.indexOf(vec), 1);
        }
      }
      if (vec != null) {
        _ref = this.nodes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          n = _ref[_i];
          n.applyForce(vec, toggled);
          _results.push(n.cacheAcceleration());
        }
        return _results;
      }
    };

    Wrap.prototype.getTraceFillColor = function() {
      return this.traceFill;
    };

    Wrap.prototype.ready = function(r) {
      if (r != null) {
        this._ready = r;
      }
      if (r) {
        this.onReady();
      }
      return this._ready;
    };

    Wrap.prototype.mouseClicked = function() {
      var handled;
      handled = _.any(this.nodes, function(n) {
        return n.handleClick({
          mouseX: mouseX,
          mouseY: mouseY
        });
      }, this);
      if (handled) {
        return;
      }
      return this.updateNodeCount(this.nodes.length, {
        attract: true,
        p: [mouseX, mouseY, 0]
      });
    };

    Wrap.prototype.nodeMoved = function(n) {
      this.applyNodeFriction(n);
      if (this.contain === true) {
        return this.updateNodeContainment(n);
      }
    };

    Wrap.prototype.onNodeViewModeChange = function(vm) {
      var n, _i, _len, _ref;
      if (vm != null) {
        this.nodeParams.viewMode = vm;
        _ref = this.nodes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          n = _ref[_i];
          n.viewMode = vm;
        }
      }
      this._needsClear = this.nodeParams.viewMode === Node.LINE;
      return this.draw();
    };

    Wrap.prototype.onReady = function() {
      this.onNodeViewModeChange();
      return this.log();
    };

    return Wrap;

  })(Node);

  return SketchElementary;

}).call(this);
