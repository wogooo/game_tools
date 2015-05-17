package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.core.ui.container.OneChildContainer;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**按钮 不具备文字的按钮  
	 * 2012-8-9 上午10:24:26
	 *@author yefeng
	 */
	public class YFSimpleButton extends YFComponent
	{
		protected var _upMc:DisplayObject;
		protected var _overMc:DisplayObject;
		protected var _downMc:DisplayObject;
		protected var _disableMC:DisplayObject;
		protected var _skinContainer:OneChildContainer;
		protected var _disable:Boolean;

		protected var _select:Boolean;
		public function YFSimpleButton(skinId:int=2,autoRemove:Boolean=false)
		{
			this._skinId=skinId;
			super( autoRemove);
			onMouseEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
			mouseChildren=false;
			buttonMode=true;
			_select=false;
		}
		
		override protected function initUI():void
		{
			_skinContainer=new OneChildContainer();
			addChild(_skinContainer);
			initSkin();
		}
		
	
		
		private function initSkin():void
		{
			//	_style=YFSkin.Instance.getStyle(YFSkin["Btn"+_skinId]);
			switch(_skinId)
			{
				
				case 1:
				//游戏常用按钮皮肤
					_style=YFSkin.Instance.getStyle(YFSkin.Button1);
					break;
				case 2:
					//游戏常用按钮皮肤
					_style=YFSkin.Instance.getStyle(YFSkin.Button2);
					break;
				case 3:
					//加号按钮
					_style=YFSkin.Instance.getStyle(YFSkin.AddBtn);
					break;
				case 5: ////菜单下拉列表 按钮皮肤
					_style=YFSkin.Instance.getStyle(YFSkin.MenuListBtn2);
					break;
				/// scroller 按钮
				case 6:
					_style=YFSkin.Instance.getStyle(YFSkin.ScrollerUpBtn);
					break;
				/// scroller 按钮
				case 7:
					_style=YFSkin.Instance.getStyle(YFSkin.ScrollerDownBtn);
					break;
				case 8:
					////菜单下拉列表 按钮皮肤
					_style=YFSkin.Instance.getStyle(YFSkin.MenuListBtn);
					break;
				case 9:
					///下拉菜单按钮皮肤
					_style=YFSkin.Instance.getStyle(YFSkin.ComboBoxBtn);
					break;
				case 10:
				///关闭按钮皮肤 
					_style=YFSkin.Instance.getStyle(YFSkin.CloseBtn);
					break;
				case 11:
					/// numberStepper
					_style=YFSkin.Instance.getStyle(YFSkin.NumberStepperUpBtn);
					break;
				case 12:
					/// numberStepper
					_style=YFSkin.Instance.getStyle(YFSkin.NumberStepperDownBtn);
					break;
				case 13:
					/// tabBtn
					_style=YFSkin.Instance.getStyle(YFSkin.TabBtn1);
					break;
				case 14:
					/// _tabBtn
					_style=YFSkin.Instance.getStyle(YFSkin.TabBtn2);
					break;
				case 15: /// _tabBtn
					_style=YFSkin.Instance.getStyle(YFSkin.TabBtn3);
					break;
				case 16:
					///向左翻页按钮
					_style=YFSkin.Instance.getStyle(YFSkin.PageLeftButton1);
					break;
				case 17:
					//向右翻页按钮
					_style=_style=YFSkin.Instance.getStyle(YFSkin.PageRightButton1);
					break;
			}
			_upMc=(_style.link.up);
			_downMc=(_style.link.down);
			_overMc=(_style.link.over);
			_disableMC=(_style.link.disable);
		}
		
		
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_UP,onMouseEvent);
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
		}
		
		protected function onMouseEvent(e:MouseEvent):void
		{
			if(!_select)
			{
				switch(e.type)
				{
					case MouseEvent.MOUSE_UP:
						_skinContainer.addChild(_overMc);
						//			_label.setColor(_style.overColor);
						break;
					case MouseEvent.MOUSE_DOWN:
						_skinContainer.addChild(_downMc);
						//			_label.setColor(_style.downColor);
						break;
					case MouseEvent.MOUSE_OVER:
						_skinContainer.addChild(_overMc);
						//				_label.setColor(_style.overColor);
						break;
					case MouseEvent.MOUSE_OUT:
						_skinContainer.addChild(_upMc);
						//			_label.setColor(_style.upColor);
						break;
				}
			}
		}
		
		
		public function set select(value:Boolean):void
		{
			_select=value;
			if(_select)
			{
				_skinContainer.addChild(_downMc);
			}
			else 
			{
				_skinContainer.addChild(_upMc);
			}
			
		}
		public function get select():Boolean
		{
			return _select;
		}
		
		
		public function set disabled(value:Boolean):void
		{
			_disable=value;
			if(_disable)
			{
				_skinContainer.addChild(_disableMC);
				mouseChildren=mouseEnabled=false;
			}
			else 
			{
				_skinContainer.addChild(_upMc);
				mouseChildren=false;
				mouseEnabled=true;
			}
		}
		
		
		
		public function get disabled():Boolean
		{
			return _disable;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_upMc=null;
			_upMc=null;
			_overMc=null;
			_downMc=null;
			_disableMC=null;
			_skinContainer=null;
	//		_text=null;
	//		_label=null;
		}
		
		
		override public function set width(value:Number):void
		{
			_upMc.width=value;
			_downMc.width=value;
			_overMc.width=value;
		}
		override public function set height(value:Number):void
		{
			_upMc.height=value;
			_downMc.height=value;
			_overMc.height=value;
		}


	}
}