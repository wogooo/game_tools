package com.YFFramework.core.ui.yfComponent.controls
{
	/**  2012-6-25    内部使用了TweenLite  需要在外部进行update
	 *	@author yefeng
	 */
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	
	/**  只具备垂直方向的滚动
	 */
	public class YFScroller extends YFComponent
	{
			
		//	private const ratio:Number=0.4;
			private var _targetSp:DisplayObject;
			private var _maskShape:Shape;
			private var _heigth:Number;
			private var _upArrow:YFSimpleButton;
			private var _downArrow:YFSimpleButton;
			private var _vTrack:Scale9Bitmap;
			private var _vBar:Scale9Bitmap;
			private var _trackSize:Number;
			private var uiContainer:AbsUIView;
			/** 滚动条的最大高度
			 */
			private var barMaxHeight:Number;
			/** 滚动条滚动区域
			 */
			private var _vScrollRect:Rectangle;
			/**是否按下了鼠标
			 **/
			private var isPress:Boolean;
			/** vBar最后的y坐标 
			 */			
			private var _lastBarY:Number;
			public function YFScroller(sp:DisplayObject,height:Number,autoRemove:Boolean=false)
			{
				_targetSp=sp;
				_heigth=height;
		//		this._trackSize=trackSize;
super(autoRemove);
			}
			override protected function initUI():void
			{
				_maskShape=new Shape();
				addChild(_maskShape);
				addChild(_targetSp);	
				_targetSp.x=0;
				_targetSp.y=0;
				initSkin();
				updateView();
				
				UpdateManager.Instance.framePer.regFunc(scrollIt);
			}
			private function initMask():void
			{
				Draw.DrawRect(_maskShape.graphics,_targetSp.width,_heigth,0xFF0000);
				_targetSp.mask=_maskShape;
			}
			
			
			
			private function initSkin():void
			{
				uiContainer=new AbsUIView(false);
				addChild(uiContainer);
				_style=YFSkin.Instance.getStyle(YFSkin.Scroller);
				
				_vTrack=_style.link.v as Scale9Bitmap;
				_upArrow=new YFSimpleButton(6);
				_downArrow=new YFSimpleButton(7);
				_vBar=_style.link.b as Scale9Bitmap;
				_vBar.buttonMode=true;
//				_vTrack.width=_trackSize;
//				_vBar.width=_trackSize;
				
				_trackSize=_vTrack.width;
				updateXPosition();
			}
			
			public  function get trackSize():Number{ return _trackSize;	}
			/** 重新计算
			 */			
			private function reCaculate():void
			{
				_vBar.height=getDisplayHeight(barMaxHeight);
				_vScrollRect=new Rectangle(_vBar.x,_upArrow.y+_upArrow.height,0,barMaxHeight-_vBar.height);
			}
			
			
			
			/** 当内部对象的x坐标改变时 更新x 坐标位置   当滚动的对象的宽度发生改变时调用 该函数进行更新
			 */
			private function updateXPosition():void
			{
				barMaxHeight=_heigth-_downArrow.height-_upArrow.height;
				_vTrack.height=_heigth;
				_upArrow.y=0;
				_downArrow.y=_heigth-_downArrow.height;
				_vBar.y=_upArrow.y+_upArrow.height;
				_vTrack.x=_targetSp.width;
				_vBar.x=_vTrack.x;
				_upArrow.x=_downArrow.x=_vTrack.x;
				_vScrollRect=new Rectangle(_vBar.x,_upArrow.y+_upArrow.height,0,barMaxHeight-_vBar.height);
				
				if(_lastBarY>_vBar.y) _vBar.y=_lastBarY;

			}
			
			
			override protected function addEvents():void
			{
				super.addEvents();
				_upArrow.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
				_downArrow.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
				addEventListener(MouseEvent.MOUSE_WHEEL,onMouseEvent);

				_vBar.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
				_stage.addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
		//		_vBar.addEventListener(MouseEvent.MOUSE_MOVE,onMouseEvent);
		//		_vBar.addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			}
			override protected function removeEvents():void
			{
				super.removeEvents();
				_upArrow.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
				_downArrow.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);
				removeEventListener(MouseEvent.MOUSE_WHEEL,onMouseEvent);

				_vBar.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
				_stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
		//		_vBar.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseEvent);
			//	_vBar.removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);

			}
			

			
			private function onMouseEvent(e:MouseEvent):void
			{
				switch(e.type)
				{
					case MouseEvent.MOUSE_DOWN:
						isPress=true;
						_vBar.startDrag(false,_vScrollRect);
						scroll();
						break;
					case MouseEvent.MOUSE_UP:
						_vBar.stopDrag();
						isPress=false;
						break;
					case MouseEvent.MOUSE_WHEEL:
						var speed:int=10;
						if(e.delta<0)
							_vBar.y +=speed;
						else _vBar.y -=speed;
						if(_vBar.y<_vScrollRect.top) _vBar.y=_vScrollRect.top;
						if(_vBar.y>_vScrollRect.bottom) _vBar.y=_vScrollRect.bottom;
						scroll();
						break;
				}
			}
			
			/** enterFrame进行滚动侦听
			 */
			private function scrollIt():void
			{
				if(isPress) scroll();
			}
			/**  进行内容滚动
			 */			
			private function scroll():void
			{
				var scrollY:Number;
				scrollY =	moveYTo(_vBar.y);
				_lastBarY=_vBar.y;
				TweenLite.killTweensOf(_targetSp);
				TweenLite.to(_targetSp,0.5,{y:scrollY});
			}
			private function onMouseDownHandler(e:MouseEvent):void
			{
				var speed:Number=10;
				switch(e.currentTarget)
				{
					case _upArrow:
						_vBar.y -=speed;
						if(_vBar.y<_vScrollRect.top) _vBar.y=_vScrollRect.top;
						break;
					case _downArrow:
						_vBar.y +=speed;
						if(_vBar.y>_vScrollRect.bottom) _vBar.y=_vScrollRect.bottom;
						break;
				}
				scroll();
			}
			
			/** 返回要滚动对象的y坐标  滚动条bar 的y 坐标
			 */
			private function moveYTo(barY:Number):Number
			{
				var percent:Number=(barY-_vScrollRect.top)/_vScrollRect.height;
				return -(_targetSp.height-_heigth)*percent;
			}
			private function addUI():void
			{	
				if(!uiContainer.contains(_vBar))
				{
					uiContainer.addChild(_vTrack);
					uiContainer.addChild(_vBar);
					uiContainer.addChild(_upArrow);
					uiContainer.addChild(_downArrow);
				}
			}
			private function removeUI():void
			{
				if(uiContainer.contains(_vBar))
				{
					uiContainer.removeChild(_vTrack);
					uiContainer.removeChild(_vBar);
					uiContainer.removeChild(_upArrow);
					uiContainer.removeChild(_downArrow);
				}
			}
			/**  动态更改内容后 需要updateView 
			 */			
			public function updateView():void
			{	
				updateXPosition();
				reCaculate();	

				//不具备滚动条
				if(_targetSp.height<=_heigth)
				{
					uiContainer.removeAllContent(false);
					_maskShape.graphics.clear();
					_targetSp.mask=null;					
					removeUI();
				}
				else 
				{
					addUI();
					initMask();
				}

			}
			
			/**  得到滚条或者背景的大小
			 */
			private function  getDisplayHeight(maxHeight:Number):Number
			{
				return (_heigth*maxHeight/_targetSp.height);//*ratio;
			}
			
			override public function dispose(e:Event=null):void
			{
				UpdateManager.Instance.framePer.delFunc(scrollIt);
				super.dispose(e);
				_targetSp=null;
				_maskShape=null;
				_upArrow=null;
				_downArrow=null;
				_vTrack=null;
				_vBar=null;
				uiContainer=null;
				_vScrollRect=null;
				
			}
			
			
			override public function set height(value:Number):void
			{
				_heigth=value;
			}
				
	}
}


