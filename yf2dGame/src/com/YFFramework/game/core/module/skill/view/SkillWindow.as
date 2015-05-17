package com.YFFramework.game.core.module.skill.view
{
	/**@author yefeng
	 *2012-8-21下午10:04:26
	 */
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.abs.GameWindow;
	import com.YFFramework.core.ui.container.VContainer;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.ui.yfComponent.controls.YFScroller;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.lang.Lang;
	import com.YFFramework.game.core.module.skill.mamanger.SkillDyManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	
	import flash.events.MouseEvent;
	
	public class SkillWindow extends GameWindow
	{
		private var _vContainer:VContainer;
		private var _scroller:YFScroller;
		
		public var _skillMainUIView:SkillMainUIView;
		/** 剩余技能点
		 */		
		private var _leftSkillPtLabel:YFLabel;
		private var _leftSkillPtValueLabel:YFLabel;
		/**购买技能点
		 */
		private var _buyBtn:YFButton;
		public function SkillWindow()
		{
			super(300, 400);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_skillMainUIView=new SkillMainUIView();

			_vContainer=new VContainer(1);
			_scroller=new YFScroller(_vContainer,_mHeight-_bgTop.height-50,false);
			addChild(_scroller);
			_scroller.y=_bgBody.y;
			
			_leftSkillPtLabel=new YFLabel();
			addChild(_leftSkillPtLabel);
			_leftSkillPtLabel.x=_scroller.x;
			_leftSkillPtLabel.y=_scroller.y+_scroller.visualHeight+5;
			_leftSkillPtLabel.text=Lang.ShengYuJiNengDian;
			_leftSkillPtValueLabel=new YFLabel("",3);
			_leftSkillPtValueLabel.width=150;
			addChild(_leftSkillPtValueLabel);
			_leftSkillPtValueLabel.width=70;
			_leftSkillPtValueLabel.selectable=false;
			_leftSkillPtValueLabel.x=_leftSkillPtLabel.x+_leftSkillPtLabel.textWidth+5;
			_leftSkillPtValueLabel.y=_leftSkillPtLabel.y;
			_leftSkillPtValueLabel.setColor(0xFFFF00);
			_leftSkillPtValueLabel.toolTip=Lang.DangQianKeYongJiNengDianShu;
			_leftSkillPtValueLabel.text="123456789";
			_buyBtn=new YFButton(Lang.GouMai,1);
			_buyBtn.toolTip=Lang.GouMaiJiNengDian;
			addChild(_buyBtn);
			_buyBtn.x=_leftSkillPtValueLabel.x+100;
			_buyBtn.y=_leftSkillPtValueLabel.y;
				
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			//触发技能点			
			_buyBtn.addEventListener(MouseEvent.CLICK,onClick);
			///技能触发
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_1,onKeyDownEvent);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_2,onKeyDownEvent);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_3,onKeyDownEvent);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_4,onKeyDownEvent);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_5,onKeyDownEvent);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_6,onKeyDownEvent);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_7,onKeyDownEvent);
			YFEventCenter.Instance.addEventListener(GlobalEvent.KeyDownNum_8,onKeyDownEvent);
				
		}
		/**触发技能点
		 */
		private function onClick(e:MouseEvent):void
		{
			print(this,"进行技能点购买");
		}
			
		
		
		
		/** 更新技能列表
		 */		
		public function updateSkillList():void
		{
			_vContainer.removeAllContent(true);
			var skillCellView:SkillCellView;
			var arr:Array=SkillDyManager.Instance.getSkillArray();
			for each(var skillDyVo:SkillDyVo in arr)
			{
				skillCellView=new SkillCellView(skillDyVo);
				_vContainer.addChild(skillCellView);
			}
			_vContainer.updateView();
			_scroller.updateView();
		}

		private function onKeyDownEvent(e:YFEvent):void
		{ 				
			
			var grid:int=0;
			switch(e.type)
			{
				case GlobalEvent.KeyDownNum_1:
					grid=1;
					break;
				case GlobalEvent.KeyDownNum_2:  ////闪电术
					grid=2;
					break;
				case GlobalEvent.KeyDownNum_3:
					grid=3;
					break;
				case GlobalEvent.KeyDownNum_4: ///瞬移技能
					grid=4;
					break;
				case GlobalEvent.KeyDownNum_5: ///瞬移技能
					grid=5;
					break;
				case GlobalEvent.KeyDownNum_6:
					grid=6;
					break;
				case GlobalEvent.KeyDownNum_7:
					grid=7;
					break;
				case GlobalEvent.KeyDownNum_8:
					grid=8;
					break;
			}			
			var skillDyVo:SkillDyVo=SkillDyManager.Instance.getSKillDyVoByGrid(grid);
			if(skillDyVo)
			{
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SkillTrigger,{id:skillDyVo.skillId,level:skillDyVo.skillLevel});
			//	print(this,"mapSceneView部分技能觸發待修改");
			}
		}
		
		
		
		
	}
}