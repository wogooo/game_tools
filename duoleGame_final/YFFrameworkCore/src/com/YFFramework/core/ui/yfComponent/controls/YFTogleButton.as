package com.YFFramework.core.ui.yfComponent.controls
{
	/**  该对象只有两种状态
	 * @author yefeng
	 *2012-8-11下午5:13:54
	 */
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.container.OneChildContainer;
	import com.YFFramework.core.ui.yfComponent.YFComponent;
	import com.YFFramework.core.ui.yfComponent.YFSkin;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="SelectChange", type="com.YFFramework.core.ui.yfComponent.events.YFControlEvent")]
	public class YFTogleButton extends YFComponent
	{
		protected var _oneChildContainer:OneChildContainer;
		
		/**选中的mc 
		 */
		protected var _selectMC:DisplayObject;
		/**未选中的mc 
		 */
		protected var _unSelectMC:DisplayObject;
		protected var _iconW:Number;
		protected var _iconH:Number;
		protected var _select:Boolean;
		public function YFTogleButton(skinId:int=1,autoRemove:Boolean=false)
		{
			_skinId=skinId;
			super(autoRemove);
			mouseChildren=false;
		}
		override protected function initUI():void
		{
			super.initUI();
			initSkin();
			_oneChildContainer=new OneChildContainer();
			addChild(_oneChildContainer)
			select=false;	 
		}
		protected function initSkin():void
		{
			switch(_skinId)
			{
				case 1:
					//checkBox
					_style=YFSkin.Instance.getStyle(YFSkin.CheckBox);	
					break;
				case 2:
					//  radionButton
					_style=YFSkin.Instance.getStyle(YFSkin.RadioButton);
					break;
				case 3:
					// treecell  皮肤
					_style=YFSkin.Instance.getStyle(YFSkin.TreeSkin1);
					break;
				case 4:  ///Treecell背景
					_style=YFSkin.Instance.getStyle(YFSkin.TreeCellBgSkin);
					break;
				case 5:   ///好友面板  人物角色两种 状态
					_style=YFSkin.Instance.getStyle(YFSkin.FriendPaneBtn);
					break;
			}
			
			_selectMC=_style.link.select;
			_unSelectMC=_style.link.unSelect;
			_iconW=_style.link.iconW;
			_iconH=_style.link.iconH;
		}
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
	
		
		protected function onMouseUp(e:MouseEvent):void
		{
			select=!select;
			dispatchEvent(new ParamEvent(YFControlEvent.SelectChange,_select));
		}
		public function set select(value:Boolean):void
		{
			_select=value;
			if(_select)
			{
				_oneChildContainer.addChild(_selectMC);
			}
			else 
			{
				_oneChildContainer.addChild(_unSelectMC);	
			}
		}
		public function get select():Boolean
		{
			return _select;
		}
		override public function dispose(e:Event=null):void
		{
			// TODO Auto Generated method stub
			super.dispose(e);
			_selectMC=null;
			_unSelectMC=null;
		}
		override public function set width(value:Number):void
		{
			_iconW=value;
			_selectMC.width=_unSelectMC.width=_iconW;

		}
		override public function set height(value:Number):void
		{
			_iconH=value;
			_selectMC.height=_unSelectMC.height=_iconH;
		}
	}
}