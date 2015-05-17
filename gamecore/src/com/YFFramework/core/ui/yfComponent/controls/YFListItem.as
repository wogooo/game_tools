package com.YFFramework.core.ui.yfComponent.controls
{
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**  2012-6-21
	 *	@author yefeng
	 */
	internal class YFListItem extends YFButton
	{
		/**  用来保存数据
		 */
		public var data:Object;
		/** 是否处于选中状态
		 */
		private var _select:Boolean;
		public function YFListItem(text:String="按钮", skinId:int=2, textSize:int=-1, alin:String="center",autoRemove:Boolean=false)
		{
			super(text, skinId, textSize, alin,autoRemove);
			_select=false;
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			data=null;
		}
		override protected function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_UP:
					if(!_select)
					{
						_skinContainer.addChild(_overMc);
						_label.setColor(_style.overColor);
					}
					break;
				case MouseEvent.MOUSE_DOWN:
					select=true;
					break;
				case MouseEvent.MOUSE_OVER:
					if(!_select)
					{
						_skinContainer.addChild(_overMc);
						_label.setColor(_style.overColor);
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if(!_select)
					{
						_skinContainer.addChild(_upMc);
						_label.setColor(_style.upColor);
					}
					break;
			}
		}
		
		
		public function toggle():void
		{
			select=!_select;
		}
		
		
		public function set select(value:Boolean):void
		{
			_select=value;
			if(_select&&this.parent)   ///当前选中 其父类中其他的对象都不能选中
			{
				_skinContainer.addChild(_downMc);
				_label.setColor(_style.downColor);
				parent.dispatchEvent(new ParamEvent(YFControlEvent.Select,data,true));
				var parentContainer:DisplayObjectContainer=parent as DisplayObjectContainer;
				var len:int=parentContainer.numChildren;
				var item:YFListItem;
				for(var i:int=0;i!=len;++i)
				{
					item=parentContainer.getChildAt(i) as YFListItem;
					if(item!=this)item.select=false;
				}
			}
			else 
			{     ///正常状态
				_skinContainer.addChild(_upMc);
				_label.setColor(_style.upColor);
			}
		}
		
		public function get select():Boolean
		{
			return _select;	
		}
		
		
	}
}