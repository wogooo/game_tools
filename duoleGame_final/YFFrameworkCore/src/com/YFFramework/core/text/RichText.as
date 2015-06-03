/**
 * 
 * 
  	   var myRichText:RichText=new RichText();
	   myRichText.setText("人物系统/94文本/46解析到{#0099ff|地图名}找{#ffff00|aa0}",exeFunc,flyExeFunc);
		addChild(	myRichText);
		myRichText.x=1000;
		myRichText.y=300;
		private function exeFunc(obj:Object):void
		{
			print(this,"文本单击:",	obj);
		}
		
		private function flyExeFunc(obj:Object):void
		{
			print(this,"小飞鞋单击:",	obj);
		}
		 
		 

 * 
 * 格式    :  {color|文字|类型|唯一id}    
 * 
 *  如果 不 向用任何 格式  则 直接写 字符串文字      
 * 
 * {color|文字}  将 会只让文字变色
 * 
 * {color|文字|type}  {color|文字|type|唯一id}  这两种 都会让文字 变色加 下划线 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */

package com.YFFramework.core.text
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.BitmapMovieClip;
	import com.YFFramework.core.ui.movie.MovieClipPlayer;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 * 2012-10-18 下午5:39:16
	 *@author yefeng       /0 ----/72 代表表情       #33$代表小飞鞋
	 * 富文本
	 * 图像用 /和数字表示
	 * 带颜色的文字   数据{color|text|type|id}   // type 的定义在   TypeProps.TaskGoodsType_  
	 * 
	 * 
	 */
	public class RichText extends AbsView
	{
		/** vip单机事件 
		 */
		public static const VipIconClickEvent:String="com.YFFramework.core.text."+"VipIconClickEvent";
		
		/**  图像 资源是否已经加载完成  当没有加载完成时是不会显示图像
		 *  图像的显示 需要 resLoadComplete=true
		 */		
		public static var resLoadComplete:Boolean=false;
		/**字宽
		 */		
		private static const Space:Number=12288;
		/**字宽 字符串   的宽度 
		 */ 
		private static const SpaceStr:String=String.fromCharCode(Space);
		
		private static const SpaceStr2:String=String.fromCharCode(32);  //空格

		
		/**要代替的文字  36大小表示 两个字宽
		 */ 
		private static const RelpaceStr:String=SpaceStr+SpaceStr;//'<font size="12">'+SpaceStr+'</font>';

		//// 931803631  代表空格 也就是没有内容  他的作用是为了空出一个格子来 创建 占两个文字的 图片 
		//// 931803632    931803632     系统   图片文字         需要和 931803631 结合使用
		///  931803633   世界  图片文字    				需要和 931803631 结合使用
		/// 931803634    好友  图片文字					需要和 931803631 结合使用
		///931803630   代表小飞鞋						需要和 931803631 结合使用
		
		/**匹配反斜杠 加上两个数字的 正则     |  代表 或符号   () 没有意思 只是划分范围而已  正则  ：http://www.360doc.com/content/11/0323/13/6351288_103833383.shtml  
		 */		
//		private static const TwoRegExp:RegExp=/(\/[0-6][0-9])|(\/7[0-1])|(\/931803630)|(\/931803631)|(\/931803632)|(\/931803633)|(\/931803634)|(\/931803635)|(\/931803636)|(\/931803637)|(\/931803638)/g;;	//   931803632 931803633 931803634 代表 文本字体 系统		/(\/[0-6][0-9])|(\/7[0-1])/g;  ///匹配 00--69 和   70- 71    94也就是匹配 00-71    \0 \1 \11;   ///匹配    /AB    匹配  / 和两个数字                                 \94 对应的资源 a94代表小飞鞋    代表乌云  该资源在cursorUI里面
		private static const TwoRegExp:RegExp=/(\&0[0-9])|(\&[1-6][0-9])|(\&7[0-1])|(\&931803630)|(\&93180363[1-8])|(\&93180364[0-7])/g;;	//   931803632 931803633 931803634  ...931803638 代表 文本字体 系统		/(\/[0-6][0-9])|(\/7[0-1])/g;  ///匹配 00--69 和   70- 71    94也就是匹配 00-71    \0 \1 \11;   ///匹配    /AB    匹配  / 和两个数字                                 \94 对应的资源 a94代表小飞鞋    代表乌云  该资源在cursorUI里面

		/**没有加载资源时候的匹配
		 */		
//		private static const TwoRegExpWithOutLoaded:RegExp=/(\/931803630)|(\/931803631)|(\/931803632)|(\/931803633)|(\/931803634)|(\/931803635)|(\/931803636)|(\/931803637)|(\/931803638)/g;;	//   931803632 931803633 931803634 代表 文本字体 系统		/(\/[0-6][0-9])|(\/7[0-1])/g;  ///匹配 00--69 和   70- 71    94也就是匹配 00-71    \0 \1 \11;   ///匹配    /AB    匹配  / 和两个数字                                 /931803630 对应的资源 a931803630代表小飞鞋    代表乌云  该资源在cursorUI里面
		private static const TwoRegExpWithOutLoaded:RegExp=/(\&931803630)|(\&93180363[1-8])|(\&93180364[0-7])/g;;	//   931803632 931803633 931803634 代表 文本字体 系统		/(\/[0-6][0-9])|(\/7[0-1])/g;  ///匹配 00--69 和   70- 71    94也就是匹配 00-71    \0 \1 \11;   ///匹配    /AB    匹配  / 和两个数字                                 /931803630 对应的资源 a931803630代表小飞鞋    代表乌云  该资源在cursorUI里面

		
		private static const FlyExp:RegExp= /\#\d*\$/g;///代表小飞鞋        #小飞鞋数字$    /931803630/g;  // 931803630 代表小飞鞋    /#/g
		private static const flyBootMCName:String="&931803630";
		private var _textField:TextField;
		/**经过空格转化后的文字
		 */ 
		private var _outStr:String;
//		private var _overStr:String;
//		private var _downStr:String;
		/**文本文字
		 */			
		private var _text:String;
		
		private var _richTextArr:Array;
		/** 事件触发
		 */		
		private var _eventDict:Dictionary;
		/** 图像链接所在的域
		 */		
		private var _appDomain:ApplicationDomain;
		/**图片容器
		 */		
		private var _faceContainer:AbsView;
		/**实际输入的文本    没有经过转码的文本
		 */		
		private var _realInputText:String;
		
		private var _flyExeFunc:Function;
		private var _data:Object;
		
		public function RichText(appDomain:ApplicationDomain=null)
		{
			_appDomain=appDomain;
			if(_appDomain==null)_appDomain=ApplicationDomain.currentDomain;
			
			super(false);   
			///进行描边
			///进行描边处理
			var glow:GlowFilter=new GlowFilter(0x000000,1,2,2,2);
			_textField.filters=[glow];
		}
		public function set textStyleSheet(value:StyleSheet):void
		{
			_textField.styleSheet=value
		}
		public function get textStyleSheet():StyleSheet
		{
			return _textField.styleSheet;
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_textField=new TextField();
			addChild(_textField);
			_textField.selectable=false;
			_textField.autoSize="left";
			_textField.multiline=true;
			_textField.wordWrap=true;
			_textField.mouseWheelEnabled=false;
			_textField.text="";
			var _tf:TextFormat=new TextFormat();
			_tf.leading=6;//4;
//			_tf.letterSpacing=3;
			_textField.defaultTextFormat=_tf;
			_richTextArr=[];
			///创建图片容器
			_faceContainer=new AbsView(false);
			addChild(_faceContainer);
			_eventDict=new Dictionary();
		}

		override protected function addEvents():void
		{
			super.addEvents();
			_textField.addEventListener(TextEvent.LINK,onLink);
//			_textField.addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
//			_textField.addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
//			_textField.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
		}
		private function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
//				case MouseEvent.MOUSE_OUT:
//					_textField.htmlText=_outStr;
//					break;
//				case MouseEvent.MOUSE_OVER:
//					_textField.htmlText=_overStr;
//					break;
//				case MouseEvent.MOUSE_DOWN:
//					_textField.htmlText=_downStr;
//					break;
			}
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			_textField.removeEventListener(TextEvent.LINK,onLink);
//			_textField.removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
//			_textField.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
//			_textField.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);

		}
		
		/**触发 小飞鞋 
		 */
		public function triggerFlyBoot():Boolean
		{
			var flyView:FlyView;
			var len:int=_faceContainer.numChildren;
			for(var i:int=0;i!=len;++i)
			{
				flyView=_faceContainer.getChildAt(i) as FlyView;
				if(flyView)  // 触发小飞鞋
				{
					flyView.onClick();
					return true;
				}
			}
			return false;
		}
		
//		/**  主动触发 TextEvent
//		 */		
//		public function triggerIt():Boolean
//		{
//			var mEvent:TextEvent=new TextEvent (TextEvent.LINK);
//			var usefulTrigger:Boolean=false;
//			for (var txt:String in _eventDict )
//			{
//				mEvent.text=txt;
//				usefulTrigger=true
//				break;
//			}
//			_textField.dispatchEvent(mEvent);
//			return usefulTrigger;
//		}

		
		/**  主动触发 TextEvent
		 */		
		public function triggerIt():Boolean
		{
			var usefulTrigger:Boolean=false;
			for (var txt:String in _eventDict )
			{
				var func:Function=_eventDict[txt].eventFunc;
				var param:Object=_eventDict[txt].eventParam;
				param.txt=txt;
				func(param); ///执行函数调用
				usefulTrigger=true
				break;
			}
			return usefulTrigger;
		}

		
		/**
		 */		
		private function onLink(e:TextEvent):void
		{
			var txt:String=e.text;
			if(_eventDict[txt]!=null)
			{
				var func:Function=_eventDict[txt].eventFunc;
				var param:Object=_eventDict[txt].eventParam;
				param.txt=txt;
				func(param); ///执行函数调用
			}
		}
		/**设置 文本 :
		 * @param txt  : 格式     人物系统文本解析到{#0099ff|地图名}找{#ffff00|铁匠} 
		 *   回调 函数   单击  带下画框的文本   exeFunc     该方法待有一个Object类型参数   里面 含有 两个参数  {type,id}   type表示类型 是  道具类型 还是npc类型   id  是唯一  id 
		 * 
		 * flyExeFunc  为点击小飞鞋快速传送图标后响应的方法 内部带有一个参数    含有一个参数    也就是  #2$  里面的  id= 2 
		 * 
		 * data  为  传递的参数  最后   响应的 时候 会变为 data属性的值
		 * 
		 * overColor 鼠标滑上变的颜色
		 * 
		 *  downColor 鼠标 按下变的颜色
		 * 
		 * 返回的 是  可以进行新手引导的最后一个文本  {color|name|type|id}里 的  文本  name,   用于  做新手引导
		 */		
		public function setText(txt:String,exeFunc:Function=null,flyExeFunc:Function=null,data:Object=null):String
		{
			_realInputText=txt;
			var arr:Array=RichTextUtil.analysisText(txt,exeFunc,data,"#FF0000","#FF0000");
			return setTextArr(arr,flyExeFunc,data,vipCall);
		}
		private function vipCall(param:Object=null):void
		{
			YFEventCenter.Instance.dispatchEventWith(VipIconClickEvent);
		}
		/**@param arr  [[text,TextObject,eventFunc,eventParam],[text,textObject,eventFunc,eventParam]]  ,   eventFunc,eventParam为可选参数
		 * flyExeFunc 含有一个参数    也就是  #2$  里面  id 2 
		 * 
		 * vipCall  是  点击vip图标响应的消息    该方法带有 1 个Object参数   {data:data,vipLevel:level}vipLevel  指的是 vip等级     目前设置了 3个vip等级
		 * 
		 * 返回的 是  可以进行新手引导的最后一个文本  {color|name|type|id}里 的  文本  name,   用于  做新手引导
		 */		
		private function setTextArr(arr:Array,flyExeFunc:Function=null,data:Object=null,vipCall:Function=null):String
		{
			
			_richTextArr=arr;
			_flyExeFunc=flyExeFunc;
			_data=data;
			_faceContainer.removeAllContent(true);
			_eventDict=new Dictionary();
			var len:int=arr.length;
			var obj:Array;
			var txt:String,textObject:TextObject;
			var eventFunc:Function=null;
			_outStr="";
//			_overStr="";
//			_downStr="";
			var objLen:int; ///每一个单元的长度
			var underLine:Boolean;
			var eventParam:Object;////函数调用的参数
			var lastTxt:String;  // 标记文本   新手引导需要的文本
			for (var i:int=0;i!=len;++i)
			{
				eventFunc=null;
				underLine=false;
				eventParam=null;
				obj=arr[i];
				objLen=obj.length;
				txt=obj[0];
				if(objLen>=2)textObject=obj[1];
				else textObject=new TextObject();
				if(objLen>=3)eventFunc=obj[2];
				if(objLen>=4)
				{
					eventParam=obj[3];
					lastTxt=txt;
				}
				if(eventFunc!=null)underLine=true; 
				_outStr +=HTMLUtil.setFont(txt,textObject.outColor,underLine,underLine);
//				_overStr +=HTMLUtil.setFont(txt,textObject.overColor,underLine,underLine);
//				_downStr +=HTMLUtil.setFont(txt,textObject.downColor,underLine,underLine);
				if(eventFunc!=null)	_eventDict[txt]={eventFunc:eventFunc,eventParam:eventParam};
			}
			_textField.htmlText=_outStr
			_text=_textField.text;
			///////////////////
			///小飞鞋
			///对 文字进行正则匹配检测
			///提取出所有的文字符号
			var flyArr:Array=_outStr.match(FlyExp);
			var checkText:String;
			var index:int;
			var tempPos:Rectangle;
			var className:String;//  face名称 冲   00  ---到  71    94     931803632)|(\/931803633)|(\/931803634)|(\/931803635
			var myNum:Number;
//			var mc:BitmapMovieClip;
//			var actionData:ActionData;
			var mc:MovieClipPlayer;

			var myFlyStr:String;
			
			if(flyArr.length>0)
			{
				//将所有的文字符号换成占位符号
				_outStr=_outStr.replace(FlyExp,flyBootMCName);
//				_overStr=_overStr.replace(FlyExp,flyBootMCName);
//				_downStr=_downStr.replace(FlyExp,flyBootMCName);
				///对空格进行定位
				_textField.htmlText=_outStr;
				checkText=_textField.text;
			}
		/////////////////////////			
			///对 文字进行正则匹配检测
			///提取出所有的文字符号
			var faceArr:Array;
			if(resLoadComplete)
			{
				faceArr=_outStr.match(TwoRegExp);
				//将所有的文字符号换成占位符号
				_outStr=_outStr.replace(TwoRegExp,RelpaceStr);
//				_overStr=_overStr.replace(TwoRegExp,RelpaceStr);
//				_downStr=_downStr.replace(TwoRegExp,RelpaceStr);
			}
			else 
			{
				faceArr=_outStr.match(TwoRegExpWithOutLoaded);
				//将所有的文字符号换成占位符号
				_outStr=_outStr.replace(TwoRegExpWithOutLoaded,RelpaceStr);
//				_overStr=_overStr.replace(TwoRegExpWithOutLoaded,RelpaceStr);
//				_downStr=_downStr.replace(TwoRegExpWithOutLoaded,RelpaceStr);
			}
			

			///对空格进行定位
			_textField.htmlText=_outStr;
			checkText=_textField.text;
			index= 0; 
			var textLen:int=checkText.length;
			var indexArr:Array=[];///空格在 文本中的索引位置  和 getCharBoundaries 结合使用
			var mySpaceIndex:int=-1;
			for (index=0;index != textLen; ++index)
			{
				if (checkText.charAt(index) == SpaceStr)
				{
					++mySpaceIndex;
					if(mySpaceIndex%2==1)indexArr.push(index);
				}
			}
			var spaceLen:int=faceArr.length;

			var flyIndex:int=0; ///小飞鞋递增索引
			var flyView:FlyView;
			for (index= 0; index!=spaceLen; ++index)
			{
				tempPos = _textField.getCharBoundaries(indexArr[index]); ///空格所占的位置   face 是 
				if(tempPos!=null)
				{
					className=faceArr[index].substr(1,faceArr[index].length-1);
					myNum=Number(className);
					className="a"+myNum;
					if(className=="a931803630")///如果为小飞鞋
					{
						eventParam={};
						myFlyStr=flyArr[flyIndex];
						eventParam.id=myFlyStr.substr(1,myFlyStr.length-2)///
						eventParam.data=data;
//						actionData=FaceDataManager.Instance.getActionData(className);
//						mc=new BitmapMovieClip();
//						mc.initData(actionData);
						mc=FaceDataManager.Instance.getMovieClipPlayer(className,30);
						mc.start();
						mc.playDefault();
						mc.x=-mc.width*0.5
						mc.y=-mc.height*0.5
						flyView=new FlyView();
						flyView.doFilter();
						flyView.addChild(mc);
						flyView.x = tempPos.x-0;  //-2
						flyView.y = tempPos.y+8;

						flyView.clickCall=flyExeFunc;
						flyView.clickParam=eventParam;
						_faceContainer.addChild(flyView);	
						++flyIndex;
						continue;
					}
					if(myNum==931803631) continue; ///代表空格 他的作用是来 创建 占两个位置的图片文字的
					else if(myNum>=931803640&&myNum<=931803647)  //为vip
					{
//						actionData=FaceDataManager.Instance.getActionData(className);
//						mc=new BitmapMovieClip();
//						mc.initData(actionData);
						mc=FaceDataManager.Instance.getMovieClipPlayer(className,30);
						mc.start();
						mc.playDefault();
						mc.x=-mc.width*0.5
						mc.y=-mc.height*0.5
						flyView=new FlyView();
						flyView.addChild(mc);
						//						flyView.x = tempPos.x-1;
						//						flyView.y = tempPos.y+1;
						eventParam={};
						eventParam.data=data;
//						if(myNum==931803640)
//						{
//							eventParam.vipLevel=1;
//						}
//						else if(myNum==931803641)
//						{
//							eventParam.vipLevel=2;
//						}
//						else if(myNum==931803642)
//						{
//							eventParam.vipLevel=3;
//						}
						eventParam.vipLevel=myNum-931803640+1;
						flyView.x =tempPos.x-1;// tempPos.x+7;
						flyView.y = tempPos.y+8;
						flyView.clickCall=vipCall;
						flyView.clickParam=eventParam;
						_faceContainer.addChild(flyView);	
					}
					else 
					{
						if(myNum>80) //不为 表情
						{
//							actionData=FaceDataManager.Instance.getActionData(className);
//							mc=new BitmapMovieClip();
//							mc.initData(actionData);
							mc=FaceDataManager.Instance.getMovieClipPlayer(className,30);
							mc.start();
							mc.playDefault();
							mc.x=-mc.width*0.5
							mc.y=-mc.height*0.5

//							mc.setPivotXY(tempPos.x+0,tempPos.y+9);
							mc.x +=tempPos.x+0;
							mc.y +=tempPos.y+9;
							_faceContainer.addChild(mc);	
						}
					}
					if(resLoadComplete)
					{
						if(myNum>=0&&myNum<=80)
						{
//							actionData=FaceDataManager.Instance.getActionData(className);
//							mc=new BitmapMovieClip();
//							mc.initData(actionData);
							mc=FaceDataManager.Instance.getMovieClipPlayer(className,30);
							mc.start();
							mc.playDefault();
							mc.x=-mc.width*0.5
							mc.y=-mc.height*0.5

//							mc.setPivotXY(tempPos.x,tempPos.y+9);
							mc.x +=tempPos.x+0;
							mc.y +=tempPos.y+9;
							_faceContainer.addChild(mc);	
						}
					}
				}
			}
			
			_textField.htmlText=_outStr;	
			
			return lastTxt;
		}
		
		public function getText():String
		{
			return _textField.text;
		}
		/**设置文字  支持图文混排
		 * @param txt
		 * @param color
		 * @param linkFunc
		 * @param funcParam
		 */		
		public function setSimpleText(txt:String,color:String="#FFFFFF",linkFunc:Function=null,funcParam:Object=null):void
		{
			var arr:Array=[[txt,new TextObject(color),linkFunc,funcParam]];
			setTextArr(arr);
		}
		private function setHTMLText(txt:String):void
		{
			_textField.htmlText=txt;
		}
		override public function set width(value:Number):void
		{
			_textField.width=value;
			setTextArr(_richTextArr,_flyExeFunc,_data,vipCall);
		}
		public function exactWidth():void
		{
			_textField.width=_textField.textWidth+15;
		}
		
		public function get textWidth():Number
		{
			return _textField.textWidth;
		}
		
		public function get text():String
		{
			return _text;
		}
		/**返回文本信息
		 */		
		public function getTextField():TextField
		{
			return _textField;
		}
		/**实际输入的文本 没有经过转码的文本
		 */		
		public function get realInputText():String
		{
			return _realInputText;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_faceContainer=null;
			_textField.filters=[];
			_textField=null;
			_eventDict=null;
			_outStr=null;
			_realInputText=null;
			_data=null;
//			_overStr=null;
//			_downStr=null;
			_text=null;		
			_richTextArr=null;
		}
		
		override public function get height():Number
		{
			return _textField.textHeight+2;
		}
		
		
	}
}