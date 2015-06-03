package com.YFFramework.game.core.module.mapScence.world.view.player
{
	/**@author yefeng
	 * 2013 2013-5-15 下午6:44:18 
	 */
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.global.manager.Trap_ConfigBasicManager;
	
	public class TrapPlayer extends PlayerView
	{
		public function TrapPlayer(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			var url:String=Trap_ConfigBasicManager.Instance.getTrapModelURL(roleDyVo.basicId);
			addDownBuffEffect(url);
			_cloth.initActionDataWalkStand(null);
			_cloth.stop();
			_cloth.resetData();
			mouseChildren=mouseEnabled=false;
		}
		
		override protected function initBloodLayer():void
		{
			
		}
		override public function updateHp():void
		{
			
		}

		override protected  function reLocateBloodName():void
		{
			
		}

		override public function updateName():void
		{
			
		}
		
		override protected function initMouseCursor(select:Boolean):void
		{
			
		}



	}
}