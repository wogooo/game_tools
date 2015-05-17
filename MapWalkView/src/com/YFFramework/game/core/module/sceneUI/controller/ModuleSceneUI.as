package com.YFFramework.game.core.module.sceneUI.controller
{
	/**@author yefeng
	 * 2013 2013-4-9 上午11:29:05 
	 */
	import com.CMD.GameCmd;
	import com.YFFramework.core.center.abs.module.AbsModule;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.module.sceneUI.model.SceneUIEvent;
	import com.YFFramework.game.core.module.sceneUI.view.CareerChangeView;
	import com.YFFramework.game.core.scence.TypeScence;
	import com.msg.hero.CChangeCareer;
	import com.net.MsgPool;

	/**场景 界面UI   主要处理 场景界面的 一些小UI     比如  一些图标处理     比如礼包      人物专职ui 等等
	 */	
	public class ModuleSceneUI extends AbsModule
	{

		public function ModuleSceneUI()
		{
			super();
			_belongScence=TypeScence.ScenceGameOn;
		}
		override public function init():void
		{
				
			addEvents();
		}
		
		private function addEvents():void
		{
			////玩家升级到十级  进行选角色
			YFEventCenter.Instance.addEventListener(GlobalEvent.ShowSelectCareerWindow,onEventHandle);
			///主角选职业
			YFEventCenter.Instance.addEventListener(SceneUIEvent.SelectCareer,onEventHandle);
			///检测人物是否转职
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onEventHandle);

		}
		/** 弹出 选职业面板
		 */		
		private function popChangeCareerWindow():void
		{
			var careerChangeView:CareerChangeView=new CareerChangeView();
			careerChangeView.open();
		}
		private function onEventHandle(e:YFEvent):void
		{
			switch(e.type)
			{
				///弹出选职业面板
				case GlobalEvent.ShowSelectCareerWindow:
					popChangeCareerWindow();
					break;
				case SceneUIEvent.SelectCareer:  ///角色选职业
					var career:int=int(e.param); 
					var cChangeCareer:CChangeCareer=new CChangeCareer();  ///转职结果的接受在场景模块ModuleMapScene
					cChangeCareer.newCareer=career;
					MsgPool.sendGameMsg(GameCmd.CChangeCareer,cChangeCareer);
					break;
				case GlobalEvent.GameIn:  //检测人物是否转职 ，没有转职则进行转职
					if(DataCenter.Instance.roleSelfVo.roleDyVo.level>=10&&DataCenter.Instance.roleSelfVo.roleDyVo.career==TypeRole.CAREER_NEWHAND)
					{
						popChangeCareerWindow();
					}
					break;
			}
		}
		
		
	}
}