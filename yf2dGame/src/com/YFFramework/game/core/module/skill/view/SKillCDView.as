package com.YFFramework.game.core.module.skill.view
{
	/**@author yefeng
	 *2012-10-26下午11:02:08
	 */
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.core.utils.URLTool;
	import com.YFFramework.game.core.global.manager.FightSkillBasicManager;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.FightSkillBasicVo;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class SKillCDView extends AbsUIView
	{
		/**技能宽
		 */		
		private static const Width:int=32;
		/**技能高
		 */		
		private static const Height:int=32;
		private var _yfCd:YFCD;
		
		private var _skillDyVo:SkillDyVo;
		public function SKillCDView()
		{
			super();
			mouseChildren=false;
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_yfCd=new YFCD(Width,Height);
			addChild(_yfCd);
		}
		/**初始化  
		 *  技能id 
		 */		
		public function initSkillId(skillId:int):void
		{
			_skillDyVo=SkillDyManager.Instance.getSkillDyVo(skillId);
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(skillId);
			var _fightSkillBasicVo:FightSkillBasicVo=FightSkillBasicManager.Instance.getFightSkillBasicVo(skillBasicVo.getFightSkillId(_skillDyVo.skillLevel));
			var url:String=URLTool.getSkillIcon(skillBasicVo.iconId);
			loadIcon(url);
		}
		protected function loadIcon(url:String):void
		{
			var loader:UILoader=new UILoader();
			loader.initData(url);
			loader.loadCompleteCallback=completeCallBack;
		}
		private function completeCallBack(conetent:DisplayObject,data:Object):void
		{
			addChildAt(conetent,0);
		}
				
		override protected function addEvents():void
		{
			super.addEvents();
		//	DBClickManager.Instance.regDBClick(this,dbClick);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
		//	DBClickManager.Instance.delDBClick(this);
		}
		
//		private function dbClick():void
//		{
//			_yfCd.play(_fightSkillBasicVo.CDTime,false);
//		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_yfCd=null;
			_skillDyVo=null;
		}
		
		public function getSkillDyVo():SkillDyVo
		{
			return _skillDyVo;
		}
		
		/**播放技能cd 
		 */ 
		public function playCD():void
		{
			var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(_skillDyVo.skillId);
			var fightSKillId:int=skillBasicVo.getFightSkillId(_skillDyVo.skillLevel);
			var fightSkillBasicVo:FightSkillBasicVo=FightSkillBasicManager.Instance.getFightSkillBasicVo(fightSKillId);
			_yfCd.play(fightSkillBasicVo.CDTime);
			
		}
	}
}