package com.YFFramework.game.ui.imageText.scrollNum
{
	/**@author yefeng
	 * 2013 2013-7-16 下午3:56:16 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.util.GlowFilterUtil;
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**     图像数字播放器
	 */	
	public class NumTextPlayer extends AbsView
	{
		/**	 每一个数字的宽度
		 */		
		private var _cellWidth:int;
		/**每一个数字的高度
		 */		
		private var _cellHeight:int;
		/**存储数字 0--9
		 */		
		private var _bitmapDataArr:Vector.<BitmapData>;
		/**是否 有前缀
		 */		
		private var _hasPre:Boolean;
		
		/**发光颜色
		 */		
		private var _glowColor:uint;
		
		public function NumTextPlayer()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			
		}
		/**初始化数据 
		 * dataArr 数据   0----9       hasPre 表示是否有前缀    flase表示没有 也就是 dataArr 是 0---9 长度为10 ,      如果 为true  表示有前缀 也就是  +/- 然后是  0---9 长度 为 11
		 */		
		public function initData(dataArr:Vector.<BitmapData>,cellWidth:int,cellHeight:int,hasPre:Boolean=false):void
		{
			_hasPre=hasPre;
			_cellWidth=cellWidth;
			_cellHeight=cellHeight;
			_bitmapDataArr=dataArr.concat();
			var len:int=_bitmapDataArr.length;
			if(hasPre) _bitmapDataArr.shift();//如果有前缀
		}
		
		public function defaultShowNum(num:int):void
		{
			
		}
		
		/**从 数字  fromNum  滚动到数字  toNum
		 * time消耗的时间 单位为秒
		 * 
		 * completeCall  TweenLite 完成的方法
		 * 
		 * completeParam  TweenLite 完成的 方法的参数
		 */
		public function playTo(fromNum:int,toNum:int,time:Number,glowColor:uint=0xFFFF00,completeCall:Function=null,completeParam:Array=null):void
		{
			_glowColor=glowColor;
		 	var fromNumStr:String=fromNum.toString();
			var toNumStr:String=toNum.toString();
			var fromLen:int=fromNumStr.length;
			var toLen:int=toNumStr.length;
			var maxlen:int=toLen>=fromLen?toLen:fromLen;
			
			var fromDif:int=maxlen-fromLen;
			while(fromDif)
			{
				fromNumStr="0"+fromNumStr;
				fromDif--;
			}
			var toDif:int=maxlen-toLen;
			while(toDif)
			{
				toNumStr="0"+toNumStr;
				toDif--;
			}
			createText(fromNumStr,toNumStr);
			playInit(time,completeCall,completeParam);
		}
		/**
		 * @param toNum   要显示的数字
		 * @param time  滚动的时间 单位为秒
		 * @param glowColor   最终发光的颜色
		 * 
		 * completeCall  TweenLite 完成的方法
		 * completeParam  TweenLite 完成的 方法的参数
		 */		
		public function playNum(toNum:int,time:Number=0,glowColor:uint=0xFFFF00,completeCall:Function=null,completeParam:Array=null):void
		{
			playTo(0,toNum,time,glowColor,completeCall,completeParam);
		}
		
		/**缩放文字 然后放大消失
		 * @param toNum   要显示的数字
		 * @param time  滚动的时间 单位为秒
		 * @param glowColor   最终发光的颜色
		 * 
		 * completeCall  TweenLite 完成的方法
		 * completeParam  TweenLite 完成的 方法的参数
		 */		
		public  function playNumToScaleDisappear(toNum:int,time:Number,glowColor:uint=0xFFFF00,completeCall:Function=null,completeParam:Array=null):void
		{
			playTo(0,toNum,time,glowColor,playNumScaleDisappearComplete,[glowColor,completeCall,completeParam]);
		}
		/**播放放大然后消失
		 */		
		private  function playNumScaleDisappearComplete(color:uint,completeCall:Function,completeParam:Array):void
		{
			GlowFilterUtil.GlowDisplayToScaleBigDisappear(this,color,playNumScaleDisappearComplete2,[completeCall,completeParam]);
		}
		private function playNumScaleDisappearComplete2(completeCall:Function,completeParam:Array):void
		{
			if(parent)parent.removeChild(this);
			dispose();
			if(completeCall!=null)
			{
				completeCall.apply(this,completeParam);
//				completeCall(completeParam);
			}
		}
		
		
			
		
		
		
		private function createText(fromNumStr:String,toNumStr:String):void
		{
			removeAllContent(true);
			var len:int=fromNumStr.length;
			var vScrollText:VScrollText;
//			var textView:AbsView=new AbsView(false);
			var lastX:int=0;
			for(var i:int=0;i!=len;++i)
			{
				vScrollText=new VScrollText(_cellWidth,_cellHeight,_bitmapDataArr);
				vScrollText.x=lastX;
				lastX +=_cellWidth;
				vScrollText.fromNum=int(fromNumStr.charAt(i));
				vScrollText.toNum=int(toNumStr.charAt(i));
				addChild(vScrollText);
			}
		}
		private function playInit(time:Number,completeCall:Function,completeParam:Array):void
		{
			var len:int=numChildren;
			var vScrollText:VScrollText;
			for(var i:int=0;i!=len;++i)
			{
				vScrollText=getChildAt(i) as VScrollText;
				if(i<len-1)
				{
					vScrollText.scrollIt(time);
				}
				else 
				{
					vScrollText.scrollIt(time,completeItCall,[completeCall,completeParam]);
				}
			}
		}

		private function completeItCall(completeCall:Function,completeParam:Array):void
		{
			GlowFilterUtil.GlowDisplay(this,_glowColor,completeCall,completeParam);
		}
		
		
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_bitmapDataArr=null;
		}
		
	}
}