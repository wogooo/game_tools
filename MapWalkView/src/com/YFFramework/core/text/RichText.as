package com.YFFramework.core.text
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**2012-10-18 下午5:39:16
	 *@author yefeng
	 * 富文本
	 * 图像用 /和数字表示
	 * 带颜色的文字  soxcket数据 [colorId,具体说明文字,数据Vo]
	 */
	public class RichText extends AbsView
	{
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
		/**要代替的文字  36大小表示 两个字宽
		 */ 
		private static const RelpaceStr:String='<font size="33">'+SpaceStr+'</font>';
		/**  一个字 也就是空格 也就是 图像的大小占位 为  24×24 
		 */		
		private static const SpaceWidth:int=24;
		private static const SpaceHeight:int=24;
		/**匹配反斜杠 加上两个数字的 正则     |  代表 或符号   () 没有意思 只是划分范围而已  正则  ：http://www.360doc.com/content/11/0323/13/6351288_103833383.shtml
		 */		
		private static const TwoRegExp:RegExp=/(\/[0-6][0-9])|(\/7[0-1])/g; ///匹配 00--69 和   70- 71 也就是匹配 00-71;   ///匹配    /AB    匹配  / 和两个数字 
		
		private var _textField:TextField;
		/**经过空格转化后的文字
		 */ 
		private var _outStr:String;
		private var _overStr:String;
		private var _downStr:String;
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
		
		
		override protected function initUI():void
		{
			super.initUI();
			_textField=new TextField();
			addChild(_textField);
			_textField.selectable=false;
			_textField.autoSize="left";
			_textField.multiline=true;
			_textField.wordWrap=true;
			var _tf:TextFormat=new TextFormat();
			_tf.leading=6;
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
			_textField.addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			_textField.addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			_textField.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
		}
		private function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_OUT:
					_textField.htmlText=_outStr;
					break;
				case MouseEvent.MOUSE_OVER:
					_textField.htmlText=_overStr;
					break;
				case MouseEvent.MOUSE_DOWN:
					_textField.htmlText=_downStr;
					break;
			}
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			_textField.removeEventListener(TextEvent.LINK,onLink);
			_textField.removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			_textField.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			_textField.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);

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
				func(param); ///执行函数调用
			}
		}
		/**@param arr  [[text,TextObject,eventFunc,eventParam],[text,textObject,eventFunc,eventParam]]  ,   eventFunc,eventParam为可选参数
		 */		
		public function setText(arr:Array):void
		{
			_richTextArr=arr;
			_faceContainer.removeAllContent(true);
			var len:int=arr.length;
			var obj:Array;
			var txt:String,textObject:TextObject;
			var eventFunc:Function=null;
			_outStr="";
			_overStr="";
			_downStr="";
			var objLen:int; ///每一个单元的长度
			var underLine:Boolean;
			var eventParam:Object;////函数调用的参数
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
				if(objLen>=4)eventParam=obj[3];
				if(eventFunc!=null)underLine=true; 
				_outStr +=HTMLUtil.setFont(txt,textObject.outColor,false,underLine);
				_overStr +=HTMLUtil.setFont(txt,textObject.overColor,underLine,underLine);
				_downStr +=HTMLUtil.setFont(txt,textObject.downColor,underLine,underLine);
				if(eventFunc!=null)	_eventDict[txt]={eventFunc:eventFunc,eventParam:eventParam};
			}
			_textField.htmlText=_outStr
			_text=_textField.text;
			if(resLoadComplete)
			{
				///对 文字进行正则匹配检测
				///提取出所有的文字符号
				var faceArr:Array=_outStr.match(TwoRegExp);
				//将所有的文字符号换成占位符号
				_outStr=_outStr.replace(TwoRegExp,RelpaceStr);
				_overStr=_overStr.replace(TwoRegExp,RelpaceStr);
				_downStr=_downStr.replace(TwoRegExp,RelpaceStr);
				///对空格进行定位
				_textField.htmlText=_outStr;
				var checkText:String=_textField.text;
				var index:int = 0; 
				var textLen:int=checkText.length;
				var indexArr:Array=[];///空格在 文本中的索引位置  和 getCharBoundaries 结合使用
				for (index=0;index != textLen; ++index)
				{
					if (checkText.charAt(index) == SpaceStr)
					{
						indexArr.push(index);
					}
				}
				var spaceLen:int=indexArr.length;
				var tempPos:Rectangle;
				var mc:MovieClip;
				var className:String;//  face名称 冲   00  ---到  71 
				var myNum:int;
				for (index= 0; index!=spaceLen; ++index)
				{
					tempPos = _textField.getCharBoundaries(indexArr[index]); ///空格所占的位置   face 是 
					if(tempPos!=null)
					{
						className=faceArr[index].substr(1,2);
						myNum=int(className);
						className="a"+myNum;
						mc=ClassInstance.getInstance2(className,_appDomain) as MovieClip;
						mc.x = tempPos.x-1;
						mc.y = tempPos.y+13;
						_faceContainer.addChild(mc);	
					}
				}
			}			
			_textField.htmlText=_outStr;	
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
			var arr:Array=[[txt,new TextObject(color,color,color),linkFunc,funcParam]];
			setText(arr);
		}
		override public function set width(value:Number):void
		{
			_textField.width=value;
			setText(_richTextArr);
		}
		
		public function get text():String
		{
			return _text;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_textField.filters=[];
			_textField=null;
			_eventDict=null;
			_outStr=null;
			_overStr=null;
			_downStr=null;
			_text=null;		
			_richTextArr=null;
		}
	}
}