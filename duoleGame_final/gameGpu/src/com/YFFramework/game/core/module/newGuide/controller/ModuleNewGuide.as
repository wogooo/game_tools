package com.YFFramework.game.core.module.newGuide.controller
{
	/**@author yefeng
	 * 2013 2013-7-1 下午7:13:40 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideFuncOpenConfig;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.mapScene.CSaveFuncOpen;
	import com.net.MsgPool;
	
	import flash.events.TimerEvent;

	/**新手引导模块
	 */	
	public class ModuleNewGuide extends AbsModule
	{
		
		public function ModuleNewGuide()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function init():void
		{
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroLevelUp,onLevelUp);
			// 新功能开启开启最新的功能
			YFEventCenter.Instance.addEventListener(GlobalEvent.NewFuncOpen,onNewGuideFuncOpen);
		}
		/** 新功能开启 保存新功能开启
		 */		
		private function onNewGuideFuncOpen(e:YFEvent):void
		{
			var value:int=NewGuideFuncOpenConfig.getGuideValue();
			var cSaveFuncOpen:CSaveFuncOpen=new CSaveFuncOpen();
			cSaveFuncOpen.funcOpen=value;
			MsgPool.sendGameMsg(GameCmd.CSaveFuncOpen,cSaveFuncOpen);
			
		}
		
		private function onGameIn(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
//			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)
//			{
			var timer:TimeOut=new TimeOut(1000,onInit);
			timer.start();
//			}
			
		}
		private function onInit(data:Object):void
		{
//			_newGuideTimer=new Timer(NewGuideManager.NewGuideCD);//3吗
//			_newGuideTimer.addEventListener(TimerEvent.TIMER,onTimer);
//			_newGuideTimer.start();
			NewGuideManager.canGuide=true;
		}
		/**等级超过新手引导阶段
		 */		
		private function onLevelUp(e:YFEvent):void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level==25) //等级 为 25 
			{
				NewGuideStep.MallGuideStep=NewGuideStep.MallGuideFuncOpen; //功能商城开启
				NewGuideManager.DoGuide();
			}
			else if(DataCenter.Instance.roleSelfVo.roleDyVo.level==26) //开启组队
			{
				NewGuideStep.TeamGuideStep=NewGuideStep.TeamGuideFuncOpen; //功能商城开启
				NewGuideManager.DoGuide();
			}
			else if(DataCenter.Instance.roleSelfVo.roleDyVo.level==28) //开启市场
			{
				NewGuideStep.MarketGuideStep=NewGuideStep.MarketGuideFuncOpen; //功能商城开启
				NewGuideManager.DoGuide();
			}
			else if(DataCenter.Instance.roleSelfVo.roleDyVo.level==30) //开启工会
			{
				NewGuideStep.GuildGuideStep=NewGuideStep.GuildGuideFuncOpen; //功能商城开启
				NewGuideManager.DoGuide();
			}

		}
		private function onTimer(e:TimerEvent):void
		{
			NewGuideManager.DoGuide();
		}
		
		
	}
}