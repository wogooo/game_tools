package com.YFFramework.game.core.module.character.view
{
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideAddPoint;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**人物面板
	 * @author yefeng
	 *2012-8-21下午9:55:37
	 */
	
	public class CharacterWindow extends Window
	{
		public const ROLE:int=1;
		public const TITLE:int=2;
		
		private var _mc:MovieClip;
		private var _rolePanel:CharacterPanel;
		private var _titlePanel:TitlePanel;
		private var _tabs:TabsManager;
		private var _roleBg:Sprite;
		
		public function CharacterWindow()
		{
			_mc=initByArgument(548,590,"characterWindow",WindowTittleName.CharacterTitle) as MovieClip;
			setContentXY(27.5,40);
			
			_rolePanel=new CharacterPanel(Xdis.getChild(_mc,"tabView1"));
			_titlePanel=new TitlePanel(Xdis.getChild(_mc,"tabView2"));
			
			_tabs=new TabsManager();
			_tabs.initTabs(_mc,"tabSp",2);
			_tabs.addEventListener(TabsManager.INDEX_CHANGE,onTabChange);
			
			_roleBg=Xdis.getChild(_mc,"roleBg");
			_roleBg.mouseChildren=false;
			_roleBg.mouseEnabled=false;
		}

		private function onTabChange(e:Event):void
		{
			if(_tabs.nowIndex == ROLE)
			{
				_roleBg.visible=true;
			}
			else
			{
				_roleBg.visible=false;	
				_titlePanel.initTitleList();
			}
		}
		
		override public function open():void
		{
			super.open();
			if(_roleBg.numChildren == 0)
			{
				var loader:UILoader=new UILoader();
				loader.initData(DyModuleUIManager.characterWinBg,_roleBg);
			}
//			_rolePanel.updateAvatar();
			_rolePanel.updateAllEquips();
			_rolePanel.updatePoint();
			_rolePanel.equipStrengthChange();
			_tabs.switchToTab(1);
			NewGuideAddPoint.closeByType(NewGuideAddPoint.AddPoint);
		}
		
		/** 更新人物各种属性值 */		
		public function updateTextInfo():void
		{
			_rolePanel.updateTextInfo();
		}
		
		/** 玩家vip黄钻图标 */
		public function updateVip():void
		{
			_rolePanel.updateMyVip();
		}
		
		/** 人物转职后：1.装备全部脱下；2.更新人物模型
		 */		
		public function onRoleChangeCareer():void
		{
			_rolePanel.removeAllEquip();
			_rolePanel.updateAvatar();
		}
		
		/** 装备强化后强化星星是否亮起 */		
		public function equipStrengthChange():void
		{
			_rolePanel.equipStrengthChange();
		}
		
		/** 人物加点值改变 */		
		public function updatePoint():void
		{
			_rolePanel.updatePoint();
		}
		
		/** 人物罪恶值（pk产生的） */		
		public function updatePKValue():void
		{
			_rolePanel.updatePKValue();
		}
		
		/** 改变公会名 */		
		public function updateGuildName():void
		{
			_rolePanel.updateGuildName();
		}
		
		/** 改变人物身上装备 */		
		public function updateAllEquips():void
		{
			_rolePanel.updateAllEquips();
//			_rolePanel.updateEquipChange()
		}
		
		/** 删除指定装备 */		
		public function delGrid(pos:int):void
		{
			_rolePanel.delGrid(pos);
		}
		
		/** 更新称号 */	
		public function updateTitle():void
		{
			_rolePanel.updateTitle();
			_titlePanel.updateMyTitle();
		}
		
		public function getTabIndex():int
		{
			return _tabs.nowIndex;
		}
		
		/** 更新某个类别的全部称号 */
		public function updateTitleType(type:int):void
		{
			_titlePanel.updateTitleType(type);
		}
		
		override public function close(event:Event=null):void
		{
			closeTo(UI.stage.stageWidth-500,UI.stage.stageHeight-45,0.02,0.04);
			_rolePanel.stopAvatar();
			
			handlePetNewGuideHideGuide();
		}
		
		/**关闭面板引导
		 */		
		private function handleCloseWindowGuide():Boolean
		{
			if(NewGuideStep.CharactorGuideStep==NewGuideStep.CharactorCloseWindow)
			{
//				var pt:Point=UIPositionUtil.getPosition(_closeButton,this);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,_closeButton.width,_closeButton.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(this);
				
				var pt:Point=UIPositionUtil.getUIRootPosition(_closeButton);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,_closeButton.width,_closeButton.height,NewGuideMovieClipWidthArrow.ArrowDirection_Left,_closeButton);
				NewGuideStep.CharactorGuideStep=NewGuideStep.CharactorNone;
				return true;
			}
			return false;
		}
		
		/**隐藏引导箭头  关闭按钮时候触发
		 */ 
		private function handlePetNewGuideHideGuide():Boolean
		{
			if(NewGuideStep.CharactorGuideStep==NewGuideStep.CharactorNone)
			{
				NewGuideMovieClipWidthArrow.Instance.hide();
				NewGuideStep.CharactorGuideStep=-1;
				NewGuideManager.DoGuide();
				return true;
			}
			return false;
		}
		
		override public function getNewGuideVo():*
		{
			var trigger:Boolean=false;
			trigger=_rolePanel.handleGuideTuiJian();
			if(!trigger)
			{
				trigger=_rolePanel.handleGuideQueDing();
			}
			if(!trigger)
			{
				trigger=handleCloseWindowGuide();
			}
			if(!trigger)
			{
				trigger=handlePetNewGuideHideGuide();
			}
			return trigger;

		}
		
		
		
	}
}