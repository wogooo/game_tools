package com.YFFramework.game.debug
{
	import com.YFFramework.core.center.manager.keyboard.KeyBoardItem;
	import com.YFFramework.core.debug.DebugExternal;
	
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 *  在线浏览器调试类，日志类
	 * @author flashk
	 * 
	 * @see kernel.debug.DebugExternal
	 * 
	 */
	public class Debug
	{
		/**
		 * Deubg日志的最大行数，大于此行数前面将被截断，对于String,50万行记录需要100M左右，Number 50M左右。对于Number，最大可以承受4000万行记录 
		 */
		public static var maxLine:uint = 500000;
		/**
		 * 开关整个Debug是否启用（但不包括 isRecordUserOperate 值）
		 */
		public static var isOn:Boolean = true;
		/**
		 * Deubg文字框的宽度
		 */
		public static var width:int= 580;
		/**
		 * Debug 点击小的设定高度 
		 */
		public static var height:int = 300;
		/**
		 * 默认是否打开Firefox的Firebug和Chrome的控制台输出
		 */
		public static var browserConsoleIsOn:Boolean=false;
		/**
		 * 常用颜色，可以用在Debug.traceColor参数中
		 */
		public static var colors:Array = [0xFF9999, 0x99CC99,0x009999];
		/**
		 * trace和traceObject的文本颜色 
		 */
		public static var colorTrace:uint = 0xbcbcbc;
		/**
		 * erro的文本颜色 
		 */
		public static var colorError:uint = 0xe22622 ;
		/**
		 * log的文本颜色 
		 */
		public static var colorLog:uint = 0x119c11;
		/**
		 * warn的文本颜色 
		 */
		public static var colorWarn:uint = 0xe2c43c;
		/**
		 * 时间显示的颜色 
		 */
		public static var colorTime:uint = 0x766060;
		/**
		 * 致命错误的颜色 
		 */
		public static var colorFatal:uint = 0xFF3300;
		/**
		 * state的文本颜色 
		 */
		public static var colorState:uint = 0xe46a81;
		/**
		 *  recordUserOperate的文本颜色
		 */
		public static var colorUserOperate:uint = 0x387edd;
		/**
		 * Debug内存显示的颜色 
		 */
		public static var colorMem:uint = 0xFFCC00;
		/**
		 * 拖动栏和边框颜色 
		 */
		public static var colorDragLine:uint = 0x55BBFF;
		/**
		 * 文本框背景色 
		 */
		public static var backgroundColor:String = "#000000";
		/**
		 * 点击更换背景透明度后背景色 
		 */
		public static var backgroundChangeColor:String = "#000000";
		/**
		 * 文本框背景透明度 
		 */
		public static var backgroundAlpha:Number = 0.93;
		/**
		 * 点击更换背景透明度后文本框背景透明度 
		 */
		public static var backgroundChangeAlpha:Number = 0.1;
		/**
		 * 当前是否在IDE环境中 
		 */
		public static var isIDE:Boolean=false;
		
		public static var stage:Stage;
		/**
		 * 是否记录整个舞台的鼠标事件 
		 */
		public static var isRecordUserOperate:Boolean = false;
		
		public static var htmlCharset:String = "gb2312";
		/**
		 * 按组合快捷键的键位keyCode，默认使用Ctrl+Alt+Y键打开。 
		 */
		public static var openKeyCode:int = 89;
		public static var hideTopTextKeyCode:int =85; 
		public static var viewTextTextFormat :TextFormat = new TextFormat(null,12,0x0);
		public static var isTraceInFlashBuilderIDE:Boolean = true;
		public static var isLogTraceInFlashBuilderIDE:Boolean = true;
		public static var isWarnTraceInFlashBuilderIDE:Boolean = true;
		/**
		 * 是否记录消息的时间，对于极高的数据量，可以将此值设定为false，可以获得接近30%的性能提升 
		 */
		public static var isRecordTime:Boolean = true;
		public static var topTxt:TextField;
		
		private static var isView:Boolean = false;
		private static var _textFilters:Array = null;
		private static var _textChangeFilters:Array = [new GlowFilter(0x0,1,2,2,5,1)];
		private static var bgMode:int = 1;
		private static var info_txt:TextField;
		private static var box:DisplayObjectContainer;
		private static var bg:Shape;
		private static var tools:Sprite;
		private static var btnAble:Sprite;
		private static var btnAlpha:Sprite;
		private static var btnNew:Sprite;
		private static var btnCopy:Sprite;
		private static var btnCopyAll:Sprite;
		private static var btnCopyError:Sprite;
		private static var btnClose:Sprite;
		private static var btnLock:Sprite;
		private static var btnFireBug:Sprite;
		private static var clearBtn:Sprite;
		private static var txtAble:Boolean = true;
		private static var opeCount:int=0;
		private static var isLockScroll:Boolean = false;
		private static var isTopTxtSetStyle:Boolean = false;
		private static var topTxtSet:Object={};
		private static var topTxtData:Array = [];
		private static var lastTopTxtStr:String="";
		private static var alphaNum:Number;
		private static var dragArea:Sprite;
		private static var _view:Sprite;
		private static var btnOnOff:Sprite;
		private static var btnScroll:Sprite;
		private static var btnScrollUp:Sprite;
		private static var btnScrollDown:Sprite;
		private static var btnSize:Sprite;
		private static var scrollSP:Sprite;
		private static var nowScroll:int;
		private static var isDraging:Boolean;
		private static var nowHeight:Number;
		private static var sizeBigMode:Boolean = false;;
		private static var isDebugClick:Boolean = false;
		private static var timer:Timer;
		private static var lastMemText:String;
		private static var nowMem:Number = 0;
		private static var maxMem:Number = 0;
		private static var buttonTextColor:uint = 0x003399;
		private static var mem_txt:TextField;
		private static var buttonTF:TextFormat =  new TextFormat("Arial",12,null,null,null,null,null,null,TextFormatAlign.CENTER);
		private static var isInitText:Boolean=false;
		private static var allMsg:Array = [];
		private static var logArr:Array=[];
		private static var operateArr:Array = [];
		private static var traceArr:Array = [];
		private static var traceColorArr:Array = [];
		private static var allColors:Array = [];
		private static var errorArr:Array=[];
		private static var warnArr:Array = [];
		private static var stateArr:Array = [];
		private static var fatalArr:Array = [];
		private static var timeH:Array = [];
		private static var timeM:Array =[];
		private static var timeS:Array = [];
		private static var timeMS:Array = [];
		private static var showMem:Boolean;
		private static var startHour:Number=0;
		private static var startMin:Number=0;
		private static var startSec:Number=0;
		private static var startMiSec:Number=0;
		private static var startTimer:int;
		private static var trackSP:Sprite;
		private static var isNowScrollUP:Boolean;
		private static var frameCount:uint=0;
		private static var nowFPS:int=-1;
		private static var lastFrameTime:int;
		private static var fpsFrameCount:int;
		private static var isUpdated:Boolean = false;
		private static var updateFrameSpace:int = 0;
		private static var lastFrameCountAt:uint;
		private static var priveMemCount:int=0;
		private static var priveMem:int=0;
		private static var lastUpdateTextFrame:uint;
		private static var updateTextFrame:uint;
		private static var checkLock:Boolean = false;

		public function Debug()
		{
			throw new Error("Debug is static Class,use Debug.init(stage or sprite) 初始化");
		}

		public static function get view():Sprite
		{
			return _view;
		}

		public static function get textChangeFilters():Array
		{
			return _textChangeFilters;
		}
		
		/**
		 * 点击更换透明度后的文本滤镜 
		 * @param value
		 * 
		 */
		public static function set textChangeFilters(value:Array):void
		{
			_textChangeFilters = value;
			if(bgMode == 2 )info_txt.filters = _textChangeFilters;
		}

		public static function get textFilters():Array
		{
			return _textFilters;
		}
		/**
		 * 文本滤镜 
		 * @param value
		 * 
		 */
		public static function set textFilters(value:Array):void
		{
			_textFilters = value;
			if(bgMode == 1 ) info_txt.filters = _textFilters;
		}
		/**
		 *  初始化Debug 
		 * @param showDisplay 要将Debug显示加入到显示列表的容器
		 * @param stage 舞台对象，用来监听键盘事件，如果为空则使用showDisplay的stage属性，如果showDisplay.stage继续为空，则监听showDisplay的键盘事件
		 * 
		 */
		public static function init(showDisplay:DisplayObjectContainer,isShowMem:Boolean=true,isShowFPS:Boolean=false):void
		{
			var date:Date = new Date();
			startTimer = getTimer();
			startHour = date.hours;
			startMin = date.minutes;
			startSec = date.seconds;
			startMiSec = date.milliseconds;
			state("Debug init at:",(new Date() as Date).toString());
			topTxt = new TextField();
			topTxt.multiline = true;
			topTxt.wordWrap = true;
			var stageRef:Stage = showDisplay as Stage;
			if(stageRef){
				Debug.stage = stageRef;
			}else{
				Debug.stage = showDisplay.stage;
			}
			box = showDisplay;
			if(isRecordUserOperate && Debug.stage){
				Debug.stage.addEventListener(MouseEvent.CLICK,logUserMouseClick);
			}
			if(Debug.stage != null){
				Debug.stage.addEventListener(KeyboardEvent.KEY_UP,checkKey);
			}else{
				showDisplay.addEventListener(KeyboardEvent.KEY_UP,checkKey);
			}
			if(showDisplay.loaderInfo.url.slice(0,4) != "http"){
				isIDE = true;
			}
			showMem = isShowMem;
			if(showMem == true){
				timer = new Timer(5000);
				timer.addEventListener(TimerEvent.TIMER,checkMem);
				timer.start();
			}
			if(isShowFPS){
				showDisplay.addEventListener(Event.ENTER_FRAME,checkFPS);
				changeTopTextState("style",0x666666,"R",null,5,15,100,18);
				changeTopTextState("show");
			}
		}
		
		protected static function checkFPS(event:Event):void
		{
			fpsFrameCount++;
			var t:int = getTimer();
			nowFPS = Math.round(1000/(t-lastFrameTime-2));
			if(fpsFrameCount>2){
				fpsFrameCount = 0;
				if(nowFPS>Debug.stage.frameRate) nowFPS = Debug.stage.frameRate;
				if(nowFPS <0 ) nowFPS = 0;
				updateTopText(nowFPS+"/"+Debug.stage.frameRate+" fps");
			}
			lastFrameTime = t;
		}
		
		public static var viewTitleHeight:int = 12;
		
		private static function initUI():void
		{
			_view = new Sprite();
			if(isRecordUserOperate){
				_view.addEventListener(MouseEvent.MOUSE_DOWN,onViewMouseDown);
			}
			info_txt = new TextField();
			info_txt.x = 2;
			info_txt.y = viewTitleHeight+23;
			info_txt.width = width-20;
			info_txt.multiline = true;
			info_txt.wordWrap=true;
			info_txt.defaultTextFormat = viewTextTextFormat;
			info_txt.filters = _textFilters;
			bg = new Shape();
			tools = new Sprite();
			tools.x = 2;
			tools.y = viewTitleHeight+3;
			btnAble = creatBtn("可点");
			btnAble.addEventListener(MouseEvent.CLICK,switchTxtAble);
			tools.addChild(btnAble);
			btnAlpha = creatBtn("透明");
			btnAlpha.addEventListener(MouseEvent.CLICK,switchAlpha);
			tools.addChild(btnAlpha);
			btnNew = creatBtn("▨新");
			btnNew.addEventListener(MouseEvent.CLICK,newWindow);
			tools.addChild(btnNew);
			btnCopyAll = creatBtn("另存");
			tools.addChild(btnCopyAll);
			btnCopyAll.addEventListener(MouseEvent.CLICK,saveLog);
			var esckeyBoard:KeyBoardItem=new KeyBoardItem(Keyboard.I,escFunc);  
			
			
			btnCopy = creatBtn("记录");
			tools.addChild(btnCopy);
			btnCopy.addEventListener(MouseEvent.CLICK,onbtnCopy);
			btnCopyError = creatBtn("错误");
			tools.addChild(btnCopyError);
			btnCopyError.addEventListener(MouseEvent.CLICK,onbtnCopyError);
			clearBtn = creatBtn("清除");
			tools.addChild(clearBtn);
			clearBtn.addEventListener(MouseEvent.CLICK,onCleanBtnClick);
			btnFireBug = creatBtn("Firebug开");
			btnFireBug.addEventListener(MouseEvent.CLICK,onbtnFireBug);
			tools.addChild(btnFireBug);
			btnSize = creatBtn("大");
			btnSize.addEventListener(MouseEvent.CLICK,onbtnSizeClick);
			tools.addChild(btnSize);
			btnLock = creatBtn("sl↓"); 
			tools.addChild(btnLock);
			btnLock.addEventListener(MouseEvent.CLICK,switchScrollLock);
			btnOnOff = creatBtn("开");
			tools.addChild(btnOnOff);
			btnOnOff.addEventListener(MouseEvent.CLICK,onOnOffClick);
			onOnOffClick();
			btnClose = creatBtn("×");
			tools.addChild(btnClose);
			btnClose.addEventListener(MouseEvent.CLICK,switchVisible);
			dragArea = new Sprite();
			dragArea.graphics.beginFill(0xFFFFFF,0);
			dragArea.graphics.drawRect(0,0,width,viewTitleHeight*2+1);
			dragArea.graphics.beginFill(colorDragLine,1);
			dragArea.graphics.drawRect(0,0,width+1,viewTitleHeight);
			dragArea.addEventListener(MouseEvent.MOUSE_DOWN,startDragMe);
			_view.mouseEnabled = false;
			_view.addChild(bg);
			_view.addChild(dragArea);
			_view.addChild(info_txt);
			_view.addChild(tools);
			var nowWidth:int=0;
			for(var i:int=0;i<tools.numChildren;i++){
				tools.getChildAt(i).x = nowWidth;
				nowWidth += tools.getChildAt(i).width+2;
			}
			btnScroll = creatBtn("",18,40);
			btnScrollUp = creatBtn("∴",18,18);
			btnScrollUp.y =2;
			btnScrollDown = creatBtn("∵",18,18);
			btnScrollDown.y = 20;
			btnScroll.y = 38;
			scrollSP = new Sprite();
			trackSP = new Sprite();
			trackSP.graphics.beginFill(0xFFFFFF,0);
			trackSP.graphics.drawRect(0,0,18,40);
			trackSP.y = btnScroll.y;
			scrollSP.addChildAt(trackSP,0);
			scrollSP.addChild(btnScroll);
			scrollSP.addChild(btnScrollUp);
			scrollSP.addChild(btnScrollDown);
			scrollSP.x = width-19;
			scrollSP.y = 32;
			_view.addChild(scrollSP);
			btnScroll.addEventListener(MouseEvent.MOUSE_DOWN,dragScroll);
			btnScrollUp.addEventListener(MouseEvent.MOUSE_DOWN,btnScrollUpClick);
			btnScrollDown.addEventListener(MouseEvent.MOUSE_DOWN,btnScrollDownClick);
			trackSP.addEventListener(MouseEvent.CLICK,onTrackClick);
			if(showMem == true){
				mem_txt = new TextField();
				_view.addChild(mem_txt);
				mem_txt.width = 150;
				mem_txt.height = 20;
				mem_txt.x = width-150;
				mem_txt.mouseEnabled = false;
				mem_txt.y = 12;
				mem_txt.defaultTextFormat = new TextFormat("Arial",12,colorMem,null,null,null,null,null,TextFormatAlign.RIGHT);
			}
		}
		
		protected static function onCleanBtnClick(event:MouseEvent=null):void
		{
				timeH = [];
				timeM = [];
				timeS = [];
				timeMS = [];
				allColors = [];
				allMsg = [];
				logArr=[];
				operateArr = [];
				traceArr = [];
				traceColorArr = [];
				errorArr=[];
				warnArr = [];
				stateArr = [];
				fatalArr = [];
				scrollTo(0);
		}
		
		protected static function onOnOffClick(event:MouseEvent=null):void
		{
			isOn = ! isOn;
			if(isOn == true){
				TextField(btnOnOff.getChildByName("label")).text  = "关";
			}else{
				TextField(btnOnOff.getChildByName("label")).text  = "开";
			}
		}
		
		protected static function onTrackClick(event:MouseEvent):void
		{
			var to:Number =( trackSP.mouseY*trackSP.scaleY-10)/(trackSP.height-20);
			if(to<0) to = 0;
			if(to>1) to = 1;
			scrollTo(messageLength*to);
		}
		
		/**
		 * 获取用户操作数据的内容 
		 * @return 
		 * 
		 */
		public static function get operateString():String
		{
			return operateArr.join("\n");
		}
		/**
		 * 获取日志的内容 
		 * @return 
		 * 
		 */
		public static function get logString():String
		{
			return logArr.join("\n");
		}
		/**
		 * 获取所有错误的内容 
		 * @return 
		 * 
		 */
		public static function get errorString():String
		{
			return errorArr.join("\n");
		}
		/**
		 * 获取整个日志的内容 
		 * @return 
		 * 
		 */
		public static function get allString():String
		{
			return formatHTML(true);
		}
		/**
		 * 更新顶部文本信息
		 * 
		 * @param htmlText 要更新的文本
		 * @param index 索引行，每个索引行为新的一行
		 * @param color 要使用的文本颜色
		 * 
		 */
		public static function updateTopText(htmlText:String,index:uint = 0,color:uint=0xF000000):void
		{
			if(color != 0xF000000){
				htmlText = '<font color="#'+color.toString(16)+'">'+htmlText+'</font>';
			}
			topTxtData[index] = htmlText;
		}
		/**
		 * 输出一个对象的所有动态和固有（非动态类）属性值对 
		 * @param obj
		 * @param frontString
		 * 
		 */
		public static function traceObject(obj:Object,frontString:String=""):void
		{
			var str:String = frontString + obj.toString();
			var count:int = 0;
			var eStr:String = "";
			for(var i:Object in obj){
				count++;
				eStr += i+"="+obj[i]+"  ";
			}
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(obj);
			bytes.position = 0;
			var newObj:Object = bytes.readObject();
			for(var p:String in newObj){
				count++;
				eStr += p+"="+newObj[p]+"  ";
			}
			Debug.trace(str+obj.valueOf()+" "+count+"vars："+eStr);
		}
		/**
		 *  设置顶部文本的样式
		 * @param state "style"修改样式 "show"显示 "hide"隐藏
		 * @param align R 右上角对齐 RB 右下角对齐 LB 左下角对齐
		 * @param textFormat
		 * @param spaceX
		 * @param spaceY
		 * @param textWidth
		 * @param textHeight
		 * @return 
		 * 
		 */
		public static function changeTopTextState(state:String = "show",textColor:uint=0x666666,align:String="R",textFormat:TextFormat=null,spaceX:Number = 10,spaceY:Number = 10,textWidth:uint=200,textHeight:uint =54):TextField
		{
			if(state == "show"){
				if(Debug.stage != null){
					Debug.stage.addChild(topTxt);
					Debug.stage.addEventListener(Event.RESIZE,reAlginTopText);
					Debug.stage.addEventListener(Event.ENTER_FRAME,checkUpdateToText);
				}
				if(isTopTxtSetStyle == false){
					changeTopTextState("style");
				}
				reAlginTopText();
			}else if(state == "hide"){
				if(topTxt.parent != null){
					topTxt.parent.removeChild(topTxt);
					if(Debug.stage != null){
						Debug.stage.removeEventListener(Event.RESIZE,reAlginTopText);
						Debug.stage.removeEventListener(Event.ENTER_FRAME,checkUpdateToText);
					}
				}
			}else	if(state == "style"){
				isTopTxtSetStyle = true;
				topTxt.width = textWidth;
				topTxt.height = textHeight;
				topTxtSet.spaceX = spaceX;
				topTxtSet.spaceY = spaceY;
				topTxtSet.align = align;
				if(textFormat == null){
					textFormat = new TextFormat();
					textFormat.color = textColor;
					textFormat.size = 12;
					textFormat.font ="Verdana";
					if(align == "R" || align =="RB"){
						textFormat.align =TextFormatAlign.RIGHT;
					}
				}
				topTxt.defaultTextFormat = textFormat;
			}
			topTxt.selectable = false;
			topTxt.mouseEnabled = false;
			return topTxt;
		}
		/**
		 * 输出调试信息（白/黑）
		 */ 
		public static function trace(...args):void
		{
			if(isOn == false) return;
			writeIn(colorTrace,traceArr,"**trace**",args);
		}
		/**
		 * 用不同颜色的文本输出调试信息
		 * @param color 颜色
		 * @param args
		 * 
		 */
		public static function traceWithColor(color:uint,...args):void
		{
//			if(isOn == false) return;
//			writeIn(color,traceColorArr,"**traceColor**",args);
		}
		/**
		 * 输出一条错误信息 （红色）
		 * @param args
		 * 
		 */
		public static function error(...args):void
		{
//			if(isOn == false) return;
//			writeIn(colorError,errorArr,"**error**",args);
		}
		/**
		 * 输出一条致命错误 
		 * @param args
		 * 
		 */
		public static function fatal(...args):void
		{
//			if(isOn == false) return;
//			writeIn(colorFatal,fatalArr,"**fatal**",args);
		}
		/**
		 * 输出一条警告信息（黄色） 
		 * @param args
		 * 
		 */
		public static function warn(...args):void
		{
			if(isOn == false) return;
			writeIn(colorWarn,warnArr,"**warn**",args,"","",isWarnTraceInFlashBuilderIDE);
		}
		/**
		 * 加入一条日志 （绿色）
		 * @param args
		 * 
		 */
		public static function log(...args):void
		{
//			if(isOn == false) return;
			writeIn(colorLog,logArr,"**log**",args,"","",isLogTraceInFlashBuilderIDE);
		}
		/**
		 * 加入一条程序状态 
		 * @param args
		 * 
		 */
		public static function state(...args):void
		{
			if(isOn == false) return;
			writeIn(colorState,stateArr,"**state**",args);
		}
		/**
		 * 记录一个用户操作 （蓝色）
		 * @param args
		 * 
		 */
		public static function recordUserOperate(...args):void
		{
			DebugExternal.traceToIDEConsole(isOn);
			if(isOn == false) return;
			opeCount++;
			var str:String;
			str = Debug.stage.mouseX+"/"+Debug.stage.mouseY+"/"+Debug.stage.stageWidth+"/"+Debug.stage.stageHeight+" ";
			writeIn(colorUserOperate,operateArr,"**userOperateope**",args,opeCount+": ",str);
		}
		
		/**
		 * 直接输出信息到浏览器和FlashBuilder控制台
		 * @param args
		 * 
		 */
		public static function traceToConsole(...args):void
		{
			if(isOn == false) return;
			DebugExternal.traceToIDEConsole(getString(args));
			DebugExternal.traceToBrowserConsole(getString(args));
		}
		/**
		 * 清除Firebug的所有信息
		 * 
		 */
		public static function clearFirebug():void
		{
			DebugExternal.clearBrowserConsole();
		}
		/**
		 * 将此函数添加到IOError事件中，将默认在发生IO错误输出一条错误信息
		 * @param event
		 * 
		 */
		public static function defaultIOErrorShow(event:IOErrorEvent):void
		{
			Debug.error(event.currentTarget,event.text);
		}
		/**
		 * 所有消息文本的长度 
		 * @return 
		 * 
		 */
		public static function get messageLength():uint
		{
			return allMsg.length;
		}
		/**
		 * 显示Debug 
		 * 
		 */
		public static function showDebug():void
		{
			isView = false;
			switchVisible();
		}
		
		public static function hideDebug():void
		{
			isView = true;
			switchVisible();
		}
		/**
		 * 保存日志到用户计算机 
		 * @param event
		 * 
		 */
		public static function saveLog(event:MouseEvent=null):void
		{
			var str:String = formatHTML(true);
			System.setClipboard(str);
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(str,"gb2312");
			var fileRef:FileReference = new FileReference();
			var date:Date = new Date();
			var ho:String = date.hours.toString();
			var mi:String = date.minutes.toString();
			var sc:String = date.seconds.toString();
			if(Number(ho) < 10) ho = "0"+ho;
			if(Number(mi) < 10) mi = "0"+mi;
			if(Number(sc) < 10) sc = "0"+sc;
			fileRef.save(bytes,"flashLog_"+date.fullYear+"_"+(date.month+1)+"_"+date.date+"_"+ho+"_"+mi+"_"+sc+".html");
		}
		
		private static function escFunc(e:KeyboardEvent):void
		{
			if(e.ctrlKey)
			{
				saveLog();
			}
		}
		
		
		protected static function checkMem(event:TimerEvent):void
		{
			priveMemCount++;
			if(priveMemCount>10 && isView == true){
				priveMemCount = 0;
				priveMem = System.privateMemory;
			}
			nowMem = System.totalMemory/1024/1024;
			if(priveMem == 0){
				priveMem = nowMem;
			}
			if(nowMem>maxMem){
				maxMem = Math.round(nowMem);
			}
			var str:String = '<font color="#23d700">'+nowMem.toFixed(1)+" "+Number(System.freeMemory/1024/1024).toFixed(1)+' </font><font color="#FF0000">'+maxMem+"</font>"+' </font><font color="#db5801">'+int(priveMem/1024/1024);
			if(lastMemText != str){
				lastMemText = str;
				if(mem_txt){
					mem_txt.htmlText = lastMemText;
				}
			}
		}		
		
		protected static function btnScrollDownClick(event:MouseEvent):void
		{
			isNowScrollUP = false;
			btnScrollUp.addEventListener(Event.ENTER_FRAME,scrollEnterFrame);
			btnScrollUp.stage.addEventListener(MouseEvent.MOUSE_UP,stopScrollEnterFrame);
		}
		
		protected static function btnScrollUpClick(event:MouseEvent):void
		{
			isNowScrollUP = true;
			btnScrollUp.addEventListener(Event.ENTER_FRAME,scrollEnterFrame);
			btnScrollUp.stage.addEventListener(MouseEvent.MOUSE_UP,stopScrollEnterFrame);
		}
		
		protected static function stopScrollEnterFrame(event:MouseEvent):void
		{
			btnScrollUp.removeEventListener(Event.ENTER_FRAME,scrollEnterFrame);
		}
		private static function scrollEnterFrame(event:Event):void
		{
			frameCount++;
			if(frameCount >2){
				frameCount = 0;
				if(isNowScrollUP){
					nowScroll--;
					scrollTo(nowScroll)
				}else{
					nowScroll++;
					scrollTo(nowScroll)
				}
			}
		}
		
		protected static function dragScroll(event:MouseEvent):void
		{
			isDraging = true;
			btnScroll.startDrag(false,new Rectangle(0,38,0,info_txt.height-btnScroll.height-38-2));
			btnScroll.stage.addEventListener(MouseEvent.MOUSE_UP,stopDragScroll);
			btnScroll.stage.addEventListener(MouseEvent.MOUSE_MOVE,updateScrollTo);
			info_txt.mouseEnabled = false;
		}
		
		protected static function updateScrollTo(event:MouseEvent):void
		{
			scrollTo(uint((btnScroll.y-38)/(info_txt.height-btnScroll.height-38-2)*messageLength));
		}
		
		protected static function stopDragScroll(event:MouseEvent):void
		{
			isDraging = false;
			btnScroll.stopDrag();
			btnScroll.stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragScroll);
			btnScroll.stage.removeEventListener(MouseEvent.MOUSE_MOVE,updateScrollTo);
			info_txt.mouseEnabled = txtAble;
		}
		
		protected static function onViewMouseDown(event:MouseEvent):void
		{
			isDebugClick = true;
		}
		
		protected static function startDragMe(event:MouseEvent):void
		{
			if(_view.parent){
				_view.parent.setChildIndex(_view,_view.parent.numChildren-1);
			}
			_view.startDrag();
			_view.parent.setChildIndex(_view,_view.parent.numChildren-1);
			dragArea.stage.addEventListener(MouseEvent.MOUSE_UP,stopDragMe);
			dragArea.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
		}		
		
		protected static function onStageMouseMove(event:MouseEvent):void
		{
			event.updateAfterEvent();
		}
		
		protected static function stopDragMe(event:MouseEvent):void
		{
			_view.stopDrag();
			dragArea.stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragMe);
			dragArea.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			if(sizeBigMode == true){
				sizeBigMode = !sizeBigMode;
				onbtnSizeClick();
				resetTxtSize();
				scrollTo(messageLength);
				checkScrollBar();
			}
		}
		
		private static function checkScrollBar():void
		{
			var maxNum:Number = info_txt.height-38-2;
			var a:Number = messageLength/(info_txt.height/14);
			if(a<1) a=1;
			if(a == 1){
				scrollSP.visible = false;
			}else{
				scrollSP.visible = true;
			}
			btnScroll.height = maxNum/a;
			if(btnScroll.height<15) btnScroll.height=15;
			var maxY:Number = info_txt.height-btnScroll.height-2;
			if(btnScroll.y > maxY){
				btnScroll.y = maxY;
			}
			if(btnScroll.y < 38 ) btnScroll.y = 38;
		}
		
		protected static function logUserMouseClick(event:MouseEvent):void
		{
			if(isDebugClick == true){
					isDebugClick = false;
					return;
			}
			isDebugClick = false;
			if(Debug.stage == null) return;
			var targetInfo:String = " tn:"+DisplayObject(event.target).name+" target:"+event.target;
			var dis:DisplayObject = DisplayObject(event.target);
			var par:DisplayObjectContainer = dis.parent;
			if(par){
				targetInfo += " pn:"+par.name + " p:"+par+" pChild:"+par.numChildren+' px:'+par.x+' py:'+par.y+' pw:'+par.width+' ph:'+par.height;
			}
			var msg:String = "#mouseClick# x:"+Debug.stage.mouseX+" y:"+Debug.stage.mouseY+' w:'+dis.width+' h:'+dis.height+' tx:'+dis.x+' ty:'+dis.y+" sW:"+Debug.stage.stageWidth+" sH:"+Debug.stage.stageHeight+" sChild:"+Debug.stage.numChildren+" softKey:"+Debug.stage.needsSoftKeyboard+targetInfo;
			opeCount++;
			writeIn(colorUserOperate,operateArr,"**userOperateope**",[msg],opeCount+": ");
		}
		
		private static function checkUpdateToText(event:Event=null):void
		{
			if(topTxt.parent == null) return;
			var str:String = topTxtData.join("<br>");
			if(lastTopTxtStr != str){
				lastTopTxtStr =str ;
				topTxt.htmlText = lastTopTxtStr ;
			}
		}
		
		private static function writeIn(color:uint,writeInArray:Array,consoleStr:String,argsArr:Array,AddFrontString:String="",addEndString:String="",isOutputIDE:Boolean=true):void
		{
			var timeStr:String
			var len:uint = argsArr.length-1;
			var newAragsArr:Array = [];
			for(var i:int=0;i<len+1;i++){
				if(argsArr[i] is Number || argsArr[i] is int || argsArr[i] is uint){
					newAragsArr[i] = argsArr[i];
				}else{
					newAragsArr[i] = String(argsArr[i]);
				}
			}
			if(isRecordTime){
				var t:int = getTimer()-startTimer;
				var milli:Number = (startMiSec+t)%1000;
				var sec:Number = int(startSec+t/1000)%60;
				var mini:Number = int(startMin+t/60000)%60;
				var hours:Number = int(startHour+t/3600000)%24;
				timeH.push(hours);
				timeM.push(mini);
				timeS.push(sec);
				timeMS.push(milli);
			}
			allColors.push(color);
			allMsg.push(newAragsArr);
			writeInArray.push(newAragsArr);
			if(allMsg.length > maxLine){
				onCleanBtnClick();
			}
			var conMsg:String;
			if(isIDE == true && isTraceInFlashBuilderIDE==true && isOutputIDE == true) {
				conMsg = consoleStr+"  "+newAragsArr.join(",");
				DebugExternal.traceToIDEConsole(conMsg);
			}
			if(browserConsoleIsOn == true) {
				if(conMsg == null){
					conMsg = consoleStr+"  "+newAragsArr.join(",");;
				}
				DebugExternal.traceToBrowserConsole(conMsg);
			}
			if(info_txt == null) return;
			if(isView == true && isUpdated == false){
				isUpdated = true;
				if(isLockScroll == false && isDraging == false){
					checkScrollBar();
					scrollTo(messageLength);
				}
			}
		}
		
		private static function formatHTML(isAddSystemInfo:Boolean=false):String
		{
			var addStr:String = "";
			if(isAddSystemInfo){
				var date:Date = new Date();
				addStr = '<font color="#'+colorWarn.toString(16)+'">============SystemInfo============<br/><br/>'
					+Capabilities.serverString+'<br/><br/>'+'flash useMemory:'+Number(System.totalMemory/1024/1024).toFixed(6)+' mb   IME:'
					+IME.conversionMode+'<br/><br/>'+date.toString()+'/'+(date.month+1)+'/'
					+date.date+'<br/><br/>'+'============SystemInfo============<br/><br/>'+'</font>';
			}
			var allMsgStr:String = "";
			var len:uint = allMsg.length;
			var istr:String;
			for(var i:int=1;i<len+1;i++){
				if(i<10){
					istr = "000000"+i;
				}else if(i<100){
					istr = "00000"+i;
				}else if(i<1000){
					istr = "0000"+i;
				}else if(i<10000){
					istr = "000"+i;
				}else if(i < 100000){
					istr = "00"+i;
				}else if(i < 1000000){
					istr = "0"+i;
				}else{
					istr = i.toString();
				}
				allMsgStr += '<font color="#'+colorWarn.toString(16)+'">'+istr+". </font>"+getTimeText(i-1)+'<font color="#'+uint(allColors[i-1]).toString(16)+'">'+allMsg[i-1]+"</font><br/>";
			}
			var str:String ='<html><head><meta http-equiv="Content-Type" content="text/html; charset='
				+htmlCharset+'" /></head><body style="font-family:arial,verdana;font-size:10pt;background-color:'+backgroundColor+'">'+ addStr+allMsgStr+'</body></html>';
			return str;
		}
		
		private static function newWindow(event:MouseEvent):void
		{
			var msg:String =formatHTML(true) ;
			msg = msg.split("\t").join("<br>");
			msg = msg.split("\n").join("<br>");
			msg = msg.split("\r").join("<br>");
			msg = msg.split("\\").join("/");
			var cmdStr:String = "asow=window.open('', 'newwin', 'height=500, width=450, toolbar =no, menubar=yes, scrollbars=yes, resizable=yes, location=no, status=no'); asow.document.write('"+msg+"');asow.document.close()";
			try{
				ExternalInterface.call("eval", cmdStr);
			}catch(e:Error){
				navigateToURL(new URLRequest("javascript:"+cmdStr),"_blank");
			}
		}

		private static function checkTraceToConsole(...args):void
		{
			if(isIDE == true) DebugExternal.traceToIDEConsole(getString(args));
			if(browserConsoleIsOn == true) DebugExternal.traceToBrowserConsole(getString(args));
		}
		
		private static function getString(array:Array):String
		{
			var str:String = "";
			var len:uint = array.length;
			for(var i:int=0;i<len;i++){
				str += String(array[i])+",";
			}
			return str;
		}
		
		private static function onbtnCopyError(event:MouseEvent):void
		{
			if(errorArr.length>0){
				System.setClipboard(errorArr.join("\n"));
			}else{
				System.setClipboard("Error Empty");
			}
		}
		
		private static function switchScrollLock(event:MouseEvent):void
		{
			isLockScroll = !isLockScroll;
			if(isLockScroll){
				TextField(btnLock.getChildByName("label")).text = "br|";
			}else{
				TextField(btnLock.getChildByName("label")).text = "sl↓";
				scrollTo(messageLength);
			}
		}
		
		private static function onbtnFireBug(event:MouseEvent = null):void
		{
			browserConsoleIsOn = !browserConsoleIsOn;
			if(browserConsoleIsOn == true){
				TextField(btnFireBug.getChildByName("label")).text = "Firebug关";
			}else{
				TextField(btnFireBug.getChildByName("label")).text = "Firebug开";
			}
		}
		
		private static function onbtnCopy(event:MouseEvent):void
		{
			if(logArr.length>0){
				System.setClipboard(logArr.join("\n"));
			}else{
				System.setClipboard("LogEmpty");
			}
		}
		
		private static function getTimeText(index:uint):String
		{
			var str:String="";
			var hourStr:String;
			var minStr:String;
			var secStr:String;
			var misecStr:String;
			if(isRecordTime){
				if(timeH[index]<10){
					hourStr = "0"+timeH[index];
				}else{
					hourStr = timeH[index];
				}
				if(timeM[index]<10){
					minStr = "0"+timeM[index];
				}else{
					minStr = timeM[index];
				}
				if(timeS[index]<10){
					secStr = "0"+timeS[index];
				}else{
					secStr = timeS[index];
				}
				if(timeMS[index]<10){
					misecStr = "00"+timeMS[index];
				}else if(timeMS[index] < 100){
					misecStr ="0"+timeMS[index];
				}else{
					misecStr = timeMS[index];
				}
				str = '<font color="#'+colorTime.toString(16)+'">'+hourStr+":"+minStr+":"+secStr+"."+misecStr+'</font> ';
			}
			return str;
		}
		
		private static function scrollTo(index:int):void
		{
			if(info_txt == null) return;
			var max:int = info_txt.height/14;
			if(index > messageLength-1) index=messageLength-1;
			if(index < 0) index = 0;
			if(max>messageLength) max = messageLength;
			if(index>messageLength-max){
				index = messageLength -max;
			}
			nowScroll = index;
			var showStr:String="";
			var istr:String;
			for(var i:int=index;i<index+max;i++){
				var countLine:int = i+1;
				if(countLine<10){
					istr = "000000"+countLine;
				}else if(countLine<100){
					istr = "00000"+countLine;
				}else if(countLine<1000){
					istr = "0000"+countLine;
				}else if(countLine<10000){
					istr = "000"+countLine;
				}else if(countLine < 100000){
					istr = "00"+countLine;
				}else if(countLine < 1000000){
					istr = "0"+countLine;
				}else{
					istr = countLine.toString();
				}
				showStr += '<font color="#'+colorWarn.toString(16)+'">'+istr +"</font> "+getTimeText(i)+'<font color="#'+uint(allColors[i]).toString(16)+'">'+Object(allMsg[i]).join(",")+"</font><br/>";
			}
			info_txt.htmlText = showStr;
			if(index>max+3){
				info_txt.scrollV = info_txt.maxScrollV;
			}else{
				info_txt.scrollV = 0;
			}
			if(isDraging == false){
				if(messageLength !=max){
					btnScroll.y = (info_txt.height-2-btnScroll.height)*index/(messageLength -max);
					checkScrollBar();
				}
			}
		}

		private static function switchTxtAble(event:MouseEvent):void
		{
			txtAble = !txtAble;
			info_txt.mouseEnabled = txtAble;
			TextField(btnAble.getChildByName("label")).text = txtAble ? "可点" : "可选";
		}
		
		protected static function onbtnSizeClick(event:MouseEvent=null):void
		{
			sizeBigMode = !sizeBigMode;
			if(sizeBigMode == true){
				nowHeight = info_txt.stage.stageHeight-_view.y-info_txt.y-3;
				TextField(btnSize.getChildByName("label")).text = "小";
			}else{
				nowHeight = height;
				TextField(btnSize.getChildByName("label")).text = "大";
			}
			resetTxtSize();
			info_txt.scrollV = info_txt.maxScrollV;
			checkScrollBar();
		}
		
		private static function switchAlpha(event:MouseEvent):void
		{
			if(bgMode ==1){
				bgMode = 2;
				TextField(btnAlpha.getChildByName("label")).text = "不透";
				info_txt.filters = _textChangeFilters;
				if(mem_txt != null){
					mem_txt.filters = _textChangeFilters;
				}
			}else{
				TextField(btnAlpha.getChildByName("label")).text = "透明";
				bgMode = 1;
				info_txt.filters = _textFilters;
				if(mem_txt != null){
					mem_txt.filters = _textFilters;
				}
			}
			resetTxtSize();
		}
		
		private static function creatBtn(label:String,btnWidth:uint=0,btnHeight:uint=20):Sprite
		{
			var t:int = getTimer();
			var sp:Sprite = new Sprite();
			var txt:TextField = new TextField();
			txt.defaultTextFormat = buttonTF;
			txt.text = label;
			if(btnWidth!=0){
				txt.width = btnWidth;
			}else{
				txt.width = txt.textWidth+13;
			}
			if(btnHeight != 0){
				txt.height = btnHeight;
			}
			txt.name = "label";
			txt.textColor = buttonTextColor;
			sp.graphics.lineStyle(0.1,0x0077CC,1,false,"normal",CapsStyle.NONE,JointStyle.MITER);
			sp.graphics.beginFill(0xE0E0EB,1);
			sp.graphics.drawRect(0,0,txt.width,txt.height);
			sp.graphics.lineStyle(0,0x333333,0);
			sp.graphics.beginFill(0xFAFAF9,0.7);
			sp.graphics.drawRect(0,0,txt.width,int(txt.height/2));
			sp.addChild(txt);
			sp.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			sp.mouseChildren = false;
			return sp;
		}
		
		private static function onMouseOver(event:MouseEvent):void
		{
			Sprite(event.currentTarget).filters = [new GlowFilter(0xFAC150,1,4,4,3.5,1,true)];
			TextField(Sprite(event.currentTarget).getChildByName("label")).textColor = 0xCA6600;
		}
		
		private static function onMouseOut(event:MouseEvent):void
		{
			Sprite(event.currentTarget).filters = null;
			TextField(Sprite(event.currentTarget).getChildByName("label")).textColor = buttonTextColor;
		}
		
		private static function checkKey(event:KeyboardEvent):void{
			if(event.ctrlKey == true && event.altKey == true){
				if(event.keyCode == openKeyCode){
					switchVisible();
				}
				if(event.keyCode == hideTopTextKeyCode){
					if(topTxt.parent){
						changeTopTextState("hide");
					}else{
						changeTopTextState("show");
					}
				}
			}
		}
		
		private static function switchVisible(event:Event=null):void
		{
			if(isInitText == false){
				initUI();
				isInitText = true;
			}
			if(isView == false){
				isView = true;
				box.addChild(_view);
				sizeBigMode = !sizeBigMode;
				onbtnSizeClick();
				resetTxtSize();
				checkScrollBar();
				scrollTo(messageLength);
				box.addEventListener(Event.ENTER_FRAME,checkUpdate);
			}else{
				isView = false;
				box.removeChild(_view);
				box.removeEventListener(Event.RESIZE,resetTxtSize);
				box.removeEventListener(Event.ENTER_FRAME,checkUpdate);
			}
		}
		
		protected static function checkUpdate(event:Event):void
		{
			updateTextFrame++;
			if(isUpdated == true && checkLock == false){
				lastUpdateTextFrame = updateTextFrame;
				checkLock = true;
			}
			if(updateTextFrame-lastUpdateTextFrame > updateFrameSpace){
				isUpdated = false;
				checkLock =false;
			}
		}
		
		private static function getColorUnit(str:String):uint
		{
			return uint("0x"+str.slice(1));
		}
		
		private static function reAlginTopText(event:Event=null):void
		{
			if(topTxtSet.align == "R"){
				topTxt.x = Debug.stage.stageWidth - topTxtSet.spaceX-topTxt.width;
			}
			if(topTxtSet.align == "RB"){
				topTxt.x = Debug.stage.stageWidth - topTxtSet.spaceX - topTxt.width;
				topTxt.y = Debug.stage.stageHeight - topTxtSet.spaceY - topTxt.height;
			}
			if(topTxtSet.align == "LB"){
				topTxt.y = Debug.stage.stageHeight - topTxtSet.spaceY - topTxt.height;
			}
		}
		
		private static function resetTxtSize(event:Event=null):void
		{
			info_txt.height = nowHeight;
			bg.graphics.clear();
			bg.graphics.lineStyle(1,colorDragLine);
			if(bgMode == 1){
				bg.graphics.beginFill(getColorUnit(backgroundColor),backgroundAlpha);
			}else{
				bg.graphics.beginFill(getColorUnit(backgroundChangeColor),backgroundChangeAlpha);
			}
			bg.graphics.drawRect(0,0,width+1,nowHeight+info_txt.y+2);
			trackSP.height = nowHeight+info_txt.y-trackSP.y-scrollSP.y;
		}
		
	}
}