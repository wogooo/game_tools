package com.YFFramework.game.ui.imageText.scrollNum
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.utils.Draw;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;

	/**数字滚动器  小的在下面 大的在上面    从下往上的顺序是   0--9 
	 * @author yefeng
	 * 2013 2013-7-16 下午4:25:14 
	 */
	public class VScrollText extends AbsView
	{
		
		public var fromNum:int;
		public var toNum:int;
		/**每个图片单元的宽度
		 */		
		private var _cellWidth:int;
		/**每个图片单元的高度
		 */		
		private var _cellHeight:int;
		private var _bitmapDataArr:Vector.<BitmapData>;
		
		private var _container:AbsView;
		
		private var _maskShape:Shape;
		
		/**图片cell的宽度
		 * 图片cell的高度
		 * bitmapDataArr  存储的 是  0--9的  图片
		 */		
		public function VScrollText(cellWidth:int,cellHeight:int,bitmapDataArr:Vector.<BitmapData>)
		{
			_cellWidth=cellWidth;
			_cellHeight=cellHeight;
			_bitmapDataArr=bitmapDataArr;
			super(false);
			cacheAsBitmap=true;
		}
		override protected function initUI():void
		{
			super.initUI();
			_container=new AbsView(false);
			addChild(_container);
			var len:int=_bitmapDataArr.length;
			var bmp:Bitmap;
			var lastY:int=0;
			for(var i:int=0;i!=len;++i)
			{
				bmp=new Bitmap();
				bmp.bitmapData=_bitmapDataArr[i];
				_container.addChild(bmp);
				bmp.y=lastY;
				lastY +=_cellHeight;
			}
			_maskShape=new Shape();
			addChild(_maskShape);
			Draw.DrawRect(_maskShape.graphics,_cellWidth,_cellHeight,0xFFFFFF);
			_container.mask=_maskShape;
		}
		override public function get height():Number
		{
			return _cellHeight;
		}
		
		/** fromSingleNum 是个位数
		 * toSingleNum 是个位数
		 * time  滚动的时间 单位是 秒  s
		 */		
		public function scrollText(fromSingleNum:int,toSingleNum:int,time:Number=0.05,completeFunc:Function=null,completeParams:Array=null):void
		{
			var fromY:int=-fromSingleNum*_cellHeight;
			
			var toY:int =-toSingleNum*_cellHeight;///   实际上要滚到的位置
			_container.y =fromY;  //当前的位置
			
//			TweenLite.to(_container,time,{y:toY,onComplete:completeFunc,onCompleteParams:completeParams});
			
			var endY:int=-9*_cellHeight; 
			var index:int=1;
			
		
			
			var totalNum:int=toSingleNum;
			if(totalNum==0)totalNum=2;
			
			var myStepTime:Number=time/totalNum;
			
//			TweenLite.to(_container,myStepTime,{y:endY,ease:Linear.easeNone,onComplete:onTweenItComplete,onCompleteParams:[toY,endY,myStepTime,totalNum,index,{func:completeFunc,params:completeParams}]});
			
			onTweenItComplete(toY,endY,myStepTime,totalNum,index,{func:completeFunc,params:completeParams});
			
		}
		
		private function onTweenItComplete(realY:int,endY:int,time:Number,totalNum:int,index:int,obj:Object):void
		{
			if(_container)
			{
				_container.y=0;
				if(index<totalNum)
				{
					TweenLite.to(_container,time,{y:endY,ease:Linear.easeNone,onComplete:onTweenItComplete,onCompleteParams:[realY,endY,time,totalNum,++index,obj]});
				}
				else 
				{  //最后一次
					TweenLite.to(_container,time,{y:realY,onComplete:obj.func,onCompleteParams:obj.params});
				}
			}
		}
		
		public function scrollIt(time:Number=0.05,completeFunc:Function=null,completeParams:Array=null):void
		{
			scrollText(fromNum,toNum,time,completeFunc,completeParams);
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_maskShape.graphics.clear();
			_maskShape=null;
			_bitmapDataArr=null;
			_container=null;
		}
		
		
	}
}