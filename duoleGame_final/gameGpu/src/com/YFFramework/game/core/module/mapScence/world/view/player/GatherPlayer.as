package com.YFFramework.game.core.module.mapScence.world.view.player
{
	/**@author yefeng
	 * 2013 2013-7-9 下午1:20:57 
	 */
	import com.YFFramework.core.yf2d.display.DisplayObject2D;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	
	/**采集物类型
	 */	
	public class GatherPlayer extends NPCPlayer
	{
		public function GatherPlayer(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
		}
		
		override protected function initUI():void
		{
			super.initUI();	
			initCheckAlpha();
		}
		/**是否 进行alpha检测   怪物不进行alpha检测    只有怪物不进行alpha检测
		 */		
		protected function initCheckAlpha():void
		{
			DisplayObject2D(_cloth.mainClip).checkAlpha=false; //怪物不进行alpha检测
		}
		
		override protected function initEffectView():void
		{
			
		}
		/**初始化手势
		 */		
		override protected function initMouseCursor(select:Boolean):void
		{
			if(select)
			{
				MouseManager.changeMouse(MouseStyle.Pick);
			}
			else 
			{
				MouseManager.resetToDefaultMouse();
			}
		}
		
		/**开始采集 
		 */		
		public function beginGather():void
		{
			
		}
		
		
	}
}