package com.YFFramework.game.core.module.AnswerActivity.dataCenter
{
	/**
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-10-10 上午10:55:21
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.view.ui.IconEffectView;
	import com.YFFramework.game.core.global.view.ui.UIEffectManager;
	import com.YFFramework.game.core.module.ModuleManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ActivityIcon extends AbsView
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _icon:Sprite;
		private var _iconEffect:IconEffectView;
		
		private var _activityType:int;
		//======================================================================
		//        constructor
		//======================================================================
		public function ActivityIcon()
		{		
			_icon=new Sprite();
			_icon.buttonMode=true;
			_icon.addEventListener(MouseEvent.CLICK,onMouseClick);
			addChild(_icon);
			_iconEffect=UIEffectManager.Instance.addIconLightTo(this,30,30);
			addChild(_iconEffect);
		}
//		public function  closeIconEffect():void
//		{
//			_iconEffect.visible=false;
//		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			removeEventListener(MouseEvent.CLICK,onMouseClick);
			_iconEffect=null;
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onMouseClick(e:MouseEvent):void
		{
			//不可能在这里统一处理报名参加活动，因为:1.不知道各个模块已经报名参加了没2.某些活动不需要报名
			_iconEffect.dispose();
			switch(_activityType)
			{
				case ActivityData.ACTIVITY_ANSWER:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.AnswerActivityUIClick);
					break;
				case ActivityData.ACTIVITY_DEMON:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DemonUIClick);
					break;
				case ActivityData.ACTIVITY_BRAVE:
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BraveUIClick);
					break;
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		public function get activityType():int
		{
			return _activityType;
		}

		public function set activityType(value:int):void
		{
			_activityType = value;
		}

		public function set icon(value:Sprite):void
		{
			_icon = value;
		}

		public function get icon():Sprite
		{
			return _icon;
		}


	}
} 