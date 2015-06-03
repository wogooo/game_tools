package com.YFFramework.game.core.module.demon.view
{
	/**@author yefeng
	 * 2013 2013-10-11 下午4:38:39 
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.container.HContainer;
	import com.YFFramework.game.core.module.demon.model.DemonSKillVo;
	import com.YFFramework.game.core.module.demon.model.DemonSkillType;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.events.Event;
	
	/**控制副本技能显示 
	 * 魔族入侵的 
	 */
	public class DemonSkillIconConainer extends HContainer
	{
		/**月井视图
		 */
		private var _yueJingView:DemonSkillIconView;
		/**大炮视图
		 */
		private var _daPaoView:DemonSkillIconView;

		public function DemonSkillIconConainer()
		{
			super(50,false);
			ResizeManager.Instance.regFunc(resize)
		}
		
		public function show():void
		{
			if(!LayerManager.UILayer.contains(this))LayerManager.UILayer.addChild(this);
			resize();
		}
		private function resize():void
		{
			x=StageProxy.Instance.getWidth()-500;
			y=StageProxy.Instance.getHeight()-135;
		}
		
		public function hide():void
		{
			if(LayerManager.UILayer.contains(this))LayerManager.UILayer.removeChild(this);
		}
		
		override protected function initUI():void
		{
			_yueJingView=new DemonSkillIconView();
			var yueJingRaidSkillVo:DemonSKillVo=new DemonSKillVo();
			yueJingRaidSkillVo.leftTimes=3;
			yueJingRaidSkillVo.raidSkillType=DemonSkillType.YueJing;
			_yueJingView.radiSkillVo=yueJingRaidSkillVo;
			_yueJingView.updateUIView();
			
			_daPaoView=new DemonSkillIconView();
			var dapaoRaidSkillVo:DemonSKillVo=new DemonSKillVo();
			dapaoRaidSkillVo.leftTimes=3;
			dapaoRaidSkillVo.raidSkillType=DemonSkillType.DaPao;
			_daPaoView.radiSkillVo=dapaoRaidSkillVo;
			_daPaoView.updateUIView();
			
			addChild(_yueJingView);
			addChild(_daPaoView);
			updateView();
		}
		
		/** 更新UI 
		 * @param type  特殊技能类型
		 */
		public function updateContentView(type:int):void
		{
			switch(type)
			{
				case DemonSkillType.DaPao:
					_daPaoView.updateView();
					break;
				case DemonSkillType.YueJing:
					_yueJingView.updateView();
					break;
			}
			if(numChildren==0)
			{
				if(this.parent)parent.removeChild(this);
				dispose();
			}
		}
		
		override public function dispose(e:Event=null):void
		{
			super.dispose(e);
			_yueJingView=null;
			_daPaoView=null;
			ResizeManager.Instance.delFunc(resize);

		}
		

	}
}