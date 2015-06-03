package com.YFFramework.game.core.module.demon.view
{
	/** 副本场景的 触发技能的按钮 
	 * @author yefeng
	 * 2013 2013-10-11 下午3:50:21 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.module.demon.event.DemonEvent;
	import com.YFFramework.game.core.module.demon.model.DemonSKillVo;
	import com.YFFramework.game.core.module.demon.model.DemonSkillType;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DemonSkillIconView extends AbsView
	{

		/**副本特殊技能的类型        1  表示  大炮   2  表示月井  值 在 RaidSkillType里
		 */
		public var radiSkillVo:DemonSKillVo;

		
		private var _mc:MovieClip;
		public function DemonSkillIconView()
		{
			super(false);
		}
		override protected function addEvents():void
		{
			super.addEvents();
			addEventListener(MouseEvent.CLICK,onClick);
			buttonMode=true;
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.CLICK,onClick);
		}
		private function onClick(e:MouseEvent):void
		{
			YFEventCenter.Instance.dispatchEventWith(DemonEvent.TriggerDemonRaidSkill,radiSkillVo.raidSkillType);
		} 
		
		
		/**单纯的更新UI 
		 */
		public function  updateUIView():void
		{
			if(!_mc)
			{
				switch(radiSkillVo.raidSkillType)
				{
					case DemonSkillType.YueJing:  //月井 
						_mc=ClassInstance.getInstance("skin__YueJing");  //资源在 skin.fla文件里 spcialButton文件夹下
						Xtip.registerTip(this,"月井 ");
						break;
					case DemonSkillType.DaPao: // 大炮 
						_mc=ClassInstance.getInstance("skin__daPao");
						Xtip.registerTip(this,"魔神大炮");
						break;
				}
				addChild(_mc);
			}
			MovieClip(_mc.numMC).gotoAndStop(radiSkillVo.leftTimes);  //播放还剩余的次数
		}
		
		public function updateView():void
		{
			radiSkillVo.leftTimes--;
			if(radiSkillVo.leftTimes==0)
			{
				if(this.parent)
				{
					this.parent.removeChild(this);
				}
				dispose();
			}
			else 
			{
				updateUIView();
			}
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			radiSkillVo=null;
			_mc=null;
		}
	}
}