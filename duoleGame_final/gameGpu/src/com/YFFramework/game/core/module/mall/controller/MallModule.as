package com.YFFramework.game.core.module.mall.controller
{
	/**
	 * @version 1.0.0
	 * creation time：2013-4-27 下午3:16:00
	 * 
	 */
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.mall.view.MallWindow;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.dolo.ui.managers.UIManager;
	
	public class MallModule extends AbsModule
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mallWindow:MallWindow;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function MallModule()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
			_mallWindow=new MallWindow();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		override public function init():void
		{
			addEvents();
//			addSocketCallback();
		}
		//======================================================================
		//        private function
		//======================================================================
		private function addEvents():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.MoneyChange,moneyChange);
			YFEventCenter.Instance.addEventListener(GlobalEvent.MallUIClick,openMall);
		}
		
		//======================================================================
		//        event handler
		//======================================================================
		/**
		 * 刷新钱 
		 */		
		private function moneyChange(e:YFEvent):void
		{
			_mallWindow.updateMoney();
		}
		
		private function openMall(e:YFEvent):void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.career != TypeRole.CAREER_NEWHAND)
				_mallWindow.switchOpenClose();
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 