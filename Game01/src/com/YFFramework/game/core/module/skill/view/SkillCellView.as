package com.YFFramework.game.core.module.skill.view
{
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.ui.yfComponent.controls.YFSimpleButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFTextInput;
	import com.YFFramework.game.core.global.lang.Lang;
	import com.YFFramework.game.core.global.manager.SkillBasicManager;
	import com.YFFramework.game.core.global.model.SkillBasicVo;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.module.skill.model.SkillDyVo;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**2012-10-18 下午4:26:05
	 *@author yefeng
	 */
	public class SkillCellView extends AbsUIView
	{
		
		private static const Width:int=281;
		
		private static const Height:int=50;
		/**技能宽
		 */		
		private static const IconWidth:int=32;
		/**技能高
		 */		
		private static const IconHeight:int=32;

		
		protected var _skillDyVo:SkillDyVo;
		/** 技能图标
		 */
		private var _skillCDView:SKillCDView;
		/**技能名称
		 */		
		protected var _skillNameLabel:YFLabel;
		/** 技能等级
		 */		
		protected var _skillLevelLabel:YFLabel;
		/**当前技能点等级百分比  例如     1/5000 表示 当前已经使用的技能点为 1     需要添加 到达5000技能才能升到下一级
		 */		
		protected var _SkillPtPercentLabel:YFLabel;
		/**技能点增加 增加技能点数
		 */		
		protected var _addBtn:YFSimpleButton;
		/** 输入文本框
		 */		
		protected var _textInput:YFTextInput;
		
		/** 鼠标按下
		 */		
		private var _mouseDown:Boolean;
		/** 背景
		 */		
		private var _bg:Shape;
		
		/**技能动态vo 
		 */		
		public function SkillCellView(skillDyVo:SkillDyVo)
		{
			_skillDyVo=skillDyVo;
			super(false);
		}
		
		override protected function initUI():void
		{
			super.initUI();
			_mouseDown=false;
			initBg();
			_skillCDView=new SKillCDView();
			_skillCDView.initSkillId(_skillDyVo.skillId);
			addContent(_skillCDView,5,8);
			_skillNameLabel=new YFLabel();
			addContent(_skillNameLabel,50,5);
			_skillLevelLabel=new YFLabel();
			addContent(_skillLevelLabel,115,5);
			 var skillBasicVo:SkillBasicVo=SkillBasicManager.Instance.getSkillBasicVo(_skillDyVo.skillId);
			_skillNameLabel.text=skillBasicVo.skillName.toString();
			_skillLevelLabel.text=getDengJi(_skillDyVo.skillLevel);
			_skillNameLabel.setColor(0x66FFCC);
			_skillLevelLabel.setColor(0x6699FF);
			///技能点说明
			_SkillPtPercentLabel=new YFLabel();
			_SkillPtPercentLabel.width=80;
			_SkillPtPercentLabel.setColor(0xFFFF00);
			addContent(_SkillPtPercentLabel,50,28);
			_SkillPtPercentLabel.text="10000/30000";
			_SkillPtPercentLabel.toolTip=Lang.DangQianJiNengDian;
			
			_textInput=new YFTextInput("1",3);
			addChild(_textInput);
			_textInput.x=_SkillPtPercentLabel.x+120;
			_textInput.y=_SkillPtPercentLabel.y;
			_textInput.width=40;
			_textInput.setRestrictNum();
			_textInput.setMaxChar(5);
			_addBtn=new YFSimpleButton(3);
			addChild(_addBtn);
			_addBtn.x=_textInput.x+42;
			_addBtn.y=_textInput.y+1;
			_addBtn.toolTip=Lang.TianJiaJiNengDian;
			
		}
		/**获取等级
		 * @param leve
		 * @return 
		 */		
		private function getDengJi(level:int):String
		{
			return Lang.JiNengDengJI+level;
		}
		
		public function updateView(skillDyVo:SkillDyVo):void
		{
			
		}
		override protected function addEvents():void
		{
			super.addEvents();
			_skillCDView.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			_skillCDView.addEventListener(MouseEvent.MOUSE_MOVE,onMouseEvent);
			StageProxy.Instance.mouseUp.regFunc(mouseUpFunc);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			_skillCDView.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			_skillCDView.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseEvent);
			StageProxy.Instance.mouseUp.delFunc(mouseUpFunc);

		}
		/**
		 */		
		private function onMouseEvent(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_mouseDown=true;
					break;
				case MouseEvent.MOUSE_MOVE:
					if(_mouseDown)	
					{
						if(DragManager.Instance.dragVo==null)	DragManager.Instance.startDragSkill(_skillCDView);
					}
					break;
			}
		}
		/**鼠标弹起来
		 */		
		private function mouseUpFunc():void
		{	
			DragManager.Instance.stopDrag();
			_mouseDown=false;
		}
		/**初始化背景 
		 */		
		private function initBg():void
		{
			_bg=new Shape();
			addChildAt(_bg,0);
			Draw.DrawRect(_bg.graphics,Width,Height,0xFFFFFF);
			_bg.alpha=0.3;
		}
		override public function get visualHeight():Number
		{
			return Height;
		}		
		/**释放内存
		 */		
		override public function dispose(e:Event=null):void
		{
			_bg.graphics.clear();
			super.dispose(e);
			_skillDyVo=null;
			_skillCDView=null;
			_skillNameLabel=null;
			_skillLevelLabel=null;
			_SkillPtPercentLabel=null;
			_addBtn=null;
			_textInput=null;
			_bg=null;
		}
		
		
		
		
	}
}