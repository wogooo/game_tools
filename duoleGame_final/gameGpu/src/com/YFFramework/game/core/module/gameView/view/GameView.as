package com.YFFramework.game.core.module.gameView.view
{
	/**@author yefeng
	 *2012-4-20下午10:08:10
	 */
	import com.YFFramework.core.center.manager.ResizeManager;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.so.ShareObjectManager;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.util.MovieClipCtrl;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.global.view.ui.IconEffectView;
	import com.YFFramework.game.core.global.view.ui.UIEffectManager;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.chat.controller.ModuleChat;
	import com.YFFramework.game.core.module.gift.manager.GiftManager;
	import com.YFFramework.game.core.module.giftYellow.manager.YellowAPIManager;
	import com.YFFramework.game.core.module.growTask.manager.GrowTaskDyManager;
	import com.YFFramework.game.core.module.guild.manager.GuildInfoManager;
	import com.YFFramework.game.core.module.mapScence.events.MapScenceEvent;
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.mapScence.world.view.player.HeroPositionProxy;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideDrawHoleUtil;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideFuncOpenConfig;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideStep;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideAddPoint;
	import com.YFFramework.game.core.module.newGuide.view.NewGuideMovieClipWidthArrow;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.gameConfig.ConfigManager;
	import com.YFFramework.game.gameConfig.TypePlatform;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.YFFramework.game.ui.sound.GlobalSoundControl;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.tools.FlashEff;
	import com.dolo.ui.tools.Xtip;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class GameView
	{
		
		public var gameViewHandle:GameViewHandle;
		
		/** 左上角 人物图像ui */		
		private var pepleUI:MovieClip;
		
		/** 包括整个雷达地图的元件；修改后分为两个部分：一个是地图名字，一个是map元件 */		
		private var _smallMapUI:MovieClip;
		/** 雷达地图的显示地图部分，及旁边的的按钮：活动、奖励等 (_smallMapUI.map)*/		
		public static var _mapUI:MovieClip;
		/** 雷达地图上的地图名字 */		
		private var _mapName:TextField;
		/** 将雷达地图折叠起来的按钮 */		
		private var _foldSmallMapBtn:MovieClip;
		/** 折叠小地图状态：false折起；true展开(初始值是true) */		
		private var _isFoldMap:Boolean=true;
		/** 雷达地图上的声音控制按钮 */	
		private var _soundBtn:MovieClip;
		
		private var  bottomUI:MovieClip;
		private var topUI:MovieClip;
		
		/**主面板技能UI
		 */ 
		public static var SkillPaneUI:MovieClip;
		/**新手礼包图标特效*/
		private var _giftEff:IconEffectView;
		/**系统奖励图标特效*/
		private var _reward_eff:IconEffectView;
		/**公会有人申请入会时闪烁图标*/
		private var _guild_addMember_eff:FlashEff;
		/**养成任务（天书）特效*/
		private var _growTask_eff:IconEffectView;
		/**黄钻礼包特效*/
		private var _yellowVipEff:IconEffectView;
		private var _giftSP:Sprite;
		private var _yellowVipSp:Sprite;
		public function GameView()
		{
//			initLoadingUI();
			initGameUI();
			YFEventCenter.Instance.addEventListener(GlobalEvent.GameIn,onGameIn);
			YFEventCenter.Instance.addEventListener(GlobalEvent.NewFuncOpen,onNewFuncOpen);
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroLevelUp,onHeroLevelUp);//主角升级，此界面有些按钮需要特定等级才能开启
			
//			YFEventCenter.Instance.addEventListener(NewGuideEvent.GuideMountFightToRectMainUIMountBtn,onNewGuideMount);  //引导
			NewGuideManager.MountGuideFunc=onNewGuideMount;
			
			//新手引导打开背包
			NewGuideManager.BagGuideFunc=onNewGuideBag;
			//引导打开宠物面板
			NewGuideManager.PetMainUIGuideFunc=onNewGuidePet;
			NewGuideManager.CharactorMainUIGuideFunc=onNewGuideCharactor
			NewGuideManager.SkillMainUIGuide=onNewGuideSkill;//引导技能	
			
			NewGuideManager.ForageMainUIGuide=onNewGuideForage;//引导锻造面板
			
					
			ShareObjectManager.Instance.flushSize();
		}
		
		private function onHeroLevelUp(e:YFEvent):void
		{
			var lv:int=DataCenter.Instance.roleSelfVo.roleDyVo.level;
			var show:Boolean=(lv>=3)//所有奖励都需要3级后开启，不然新手引导会出BUG
			topUI.signPackage.visible=show;//新手礼包
			onGiftEffUpdate(null);
			if(ConfigManager.Instance.platform==TypePlatform.PF_pengyou||ConfigManager.Instance.platform==TypePlatform.PF_qzone)
			{
				topUI.yellow_vip.visible=show;//黄钻礼包
				onYellowVipEffUpdate(null);
			}
			else
				topUI.yellow_vip.visible=false;
			
			topUI.onlineReward.visible=show;//在线奖励
		}
		private function onNewFuncOpen(e:YFEvent):void
		{
			var guideValue:int=NewGuideFuncOpenConfig.getGuideValue();
			switch(guideValue)
			{
				case NewGuideFuncOpenConfig.BagOpen: //背包开启
					bottomUI.bts.btn_bag.visible=true;
					break;
				case NewGuideFuncOpenConfig.PetOpen: //宠物开启
					bottomUI.bts.btn_pet.visible=true;
					break;
				case NewGuideFuncOpenConfig.SkillOpen: //技能开启
					bottomUI.bts.btn_skill.visible=true;
					break;
				case NewGuideFuncOpenConfig.FriendOpen: //好友开启
					bottomUI.bts.btn_friend.visible=true;
					break;
				case NewGuideFuncOpenConfig.WingOpen: //翅膀开启
					bottomUI.bts.btn_wing.visible=true;
					break;
				case NewGuideFuncOpenConfig.MountOpen: //坐骑开启
					bottomUI.bts.btn_mount.visible=true;
					break;
				case NewGuideFuncOpenConfig.ForageOpen: //锻造开启
					bottomUI.bts.btn_goodsBuild.visible=true;
					break;
				case NewGuideFuncOpenConfig.MallOpen: //商城开启
					bottomUI.bts.mc_mall.visible=true;
					break;
				case NewGuideFuncOpenConfig.TeamOpen: //组队开启
					_mapUI.teamBtn.visible=true;
					break;
				case NewGuideFuncOpenConfig.MarkcketOpen: //市场开启
					_mapUI.marketBtn.visible=true;
					break;
				case NewGuideFuncOpenConfig.GuildOpen: //工会开启
					bottomUI.bts.btn_guild.visible=true;
					break;
			}
			
		}
		
		/**进入游戏主场景 */		
		private function onGameIn(e:YFEvent):void
		{
			YFEventCenter.Instance.removeEventListener(GlobalEvent.GameIn,onGameIn);
			initFuncOpen();
			initViewMain();
			checkBlackShopBtn();
		}
		/**功能开启测试
		 */
		private function initFuncOpen():void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<NewGuideManager.MaxGuideLevel)  //小于30级 时 进行功能按钮开启与隐藏
			{
				bottomUI.bts.btn_bag.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.BagOpen);
				bottomUI.bts.btn_pet.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.PetOpen);
				bottomUI.bts.btn_skill.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.SkillOpen);
				bottomUI.bts.btn_friend.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.FriendOpen);
				bottomUI.bts.btn_wing.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.WingOpen);
				bottomUI.bts.btn_mount.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.MountOpen);
				bottomUI.bts.btn_goodsBuild.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.ForageOpen);
				bottomUI.bts.mc_mall.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.MallOpen);
				_mapUI.teamBtn.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.TeamOpen);
				_mapUI.marketBtn.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.MarkcketOpen);
				bottomUI.bts.btn_guild.visible=NewGuideFuncOpenConfig.isOpen(NewGuideFuncOpenConfig.GuildOpen);
			}
		}
		/**新手引导 引导坐骑出战  
		 */
		private function onNewGuideMount():Boolean
		{
			if(NewGuideStep.MountGuideStep==NewGuideStep.MountMainUIMountBtn )
			{
				//获取坐骑按钮的坐标
				var mountBtn:DisplayObject=bottomUI.bts.btn_mount;
//				var pt:Point=UIPositionUtil.getPosition(mountBtn,bottomUI);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,mountBtn.width,mountBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(bottomUI);
				var pt:Point=UIPositionUtil.getUIRootPosition(mountBtn);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,mountBtn.width,mountBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down,mountBtn);
				NewGuideStep.MountGuideStep=NewGuideStep.MountWindowRectFightBtn;
				return true;
			}
			return false;
		}
		//背包按钮引导 引导 背包功能按钮
		private function onNewGuideBag():Boolean
		{
			if(NewGuideStep.BagPackGuideStep==NewGuideStep.BagPackMainUIBtn )
			{
				var bagBtn:DisplayObject=bottomUI.bts.btn_bag;
//				var pt:Point=UIPositionUtil.getPosition(bagBtn,bottomUI);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,bagBtn.width,bagBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(bottomUI);
				var pt:Point=UIPositionUtil.getUIRootPosition(bagBtn);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,bagBtn.width,bagBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down,bagBtn);
				NewGuideStep.BagPackGuideStep=NewGuideStep.BagPackOpen;
				return true;
			}
			return false;
		}
		
		//背包按钮引导 引导 背包功能按钮
		private function onNewGuidePet():Boolean
		{
			if(NewGuideStep.PetGuideStep==NewGuideStep.PetMainUIBtn )
			{
				var petbtn:DisplayObject=bottomUI.bts.btn_pet;
//				var pt:Point=UIPositionUtil.getPosition(petbtn,bottomUI);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,petbtn.width,petbtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(bottomUI);
				var pt:Point=UIPositionUtil.getUIRootPosition(petbtn);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,petbtn.width,petbtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down,petbtn);
				NewGuideStep.PetGuideStep=NewGuideStep.PetFight;
				return true;
			}
			return false;
		}
		
		/**人物点击引导
		 */		
		private function onNewGuideCharactor():Boolean
		{
			if(NewGuideStep.CharactorGuideStep==NewGuideStep.CharactorMainUI )
			{
				var charactorBtn:DisplayObject=bottomUI.bts.btn_figure;
//				var pt:Point=UIPositionUtil.getPosition(charactorBtn,bottomUI);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,charactorBtn.width,charactorBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(bottomUI);
				var pt:Point=UIPositionUtil.getUIRootPosition(charactorBtn);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,charactorBtn.width,charactorBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down,charactorBtn);
				NewGuideStep.CharactorGuideStep=NewGuideStep.CharactorGuideTuiJian;
				return true;
			}
			return false;
		}

		/**引导技能
		 */
		private function onNewGuideSkill():Boolean
		{
			if(NewGuideStep.SkillGuideStep==NewGuideStep.SkillMainUI )
			{
				var skillbtn:DisplayObject=bottomUI.bts.btn_skill;
//				var pt:Point=UIPositionUtil.getPosition(skillbtn,bottomUI);
//				NewGuideMovieClipWidthArrow.Instance.initRect(pt.x,pt.y,skillbtn.width,skillbtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down);
//				NewGuideMovieClipWidthArrow.Instance.addToContainer(bottomUI);
				var pt:Point=UIPositionUtil.getUIRootPosition(skillbtn);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,skillbtn.width,skillbtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down,skillbtn);
				NewGuideStep.SkillGuideStep=NewGuideStep.SkillGuideRectStudyBtn;
				return true;
			}
			return false;
		}
		
		
		/**引导锻造面板
		 */		
		private function onNewGuideForage():Boolean
		{
			if(NewGuideStep.EquipLevelUpStep==NewGuideStep.EquipLevelUp_MainUI )
			{
				var forageBtn:DisplayObject=bottomUI.bts.btn_goodsBuild;
				var pt:Point=UIPositionUtil.getUIRootPosition(forageBtn);
				NewGuideDrawHoleUtil.drawHoleByNewGuideMovieClipWidthArrow(pt.x,pt.y,forageBtn.width,forageBtn.height,NewGuideMovieClipWidthArrow.ArrowDirection_Down,forageBtn);
				NewGuideStep.EquipLevelUpStep=NewGuideStep.EquipLevelUp_ToClickEquip;
				return true;
			}
			return false;
		}

		
		/**创建游戏主界面
		 */
		private function initGameUI():void
		{
			var mainUI:MovieClip=ClassInstance.getInstance("mainUI") as MovieClip;
			pepleUI=mainUI.UI_people;
			
			_smallMapUI=mainUI.UI_smallPic;
			_mapUI=_smallMapUI.map;
			_mapName=_smallMapUI.mapName;
			_soundBtn=_mapUI.soundBtn;
			
			_foldSmallMapBtn=mainUI.foldMapBtn;
			_foldSmallMapBtn.buttonMode=true;
			_foldSmallMapBtn.gotoAndStop(1);
			
			bottomUI=mainUI.UI_buttom;
			topUI=mainUI.UI_Top;			
			SkillPaneUI=bottomUI.UI_shortCut;
			
			_smallMapUI.map.reward_eff.gotoAndStop(1);
			_smallMapUI.map.reward_eff.mouseEnabled=false;
			
//			Align.toRightBottom(bottomUI,true,1010,171);
			gameViewHandle=new GameViewHandle(mainUI);
			
			//右上角礼包特效需要再加一层
			
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<3)
			{
				topUI.yellow_vip.visible=false;//隐藏黄钻礼包按钮
				topUI.signPackage.visible=false;//新手礼包
				topUI.onlineReward.visible=false;//在线奖励
			}
			if(ConfigManager.Instance.platform!=TypePlatform.PF_pengyou&&ConfigManager.Instance.platform!=TypePlatform.PF_qzone)
			{
				topUI.yellow_vip.visible=false
			}
		}
		private  function initViewMain():void
		{
			locateUI();
			addEvents();
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.OnlineRewardInit,topUI.onlineReward);
		}
		/**定位ui
		 */		
		protected function locateUI():void
		{
			
			LayerManager.UILayer.addChildAt(pepleUI,0);
			LayerManager.UILayer.addChild(_smallMapUI);
			LayerManager.UILayer.addChild(bottomUI);
			LayerManager.UILayer.addChild(topUI);
			LayerManager.UILayer.addChild(_foldSmallMapBtn);
			
			/// 技能框显示与隐藏
//			bottomUI.UI_shortCut.__shortCutNumber2.visible=false
//			bottomUI.UI_shortCut.__shortCut2.visible=false;
			
			bottomUI.UI_shortCut.quickKeyTxt.visible=false;
			bottomUI.UI_shortCut.skillbar2.visible=false;

			///技能区域面板
			///技能的 数字 1 2 3 4 6  设置不响应鼠标
			bottomUI.UI_shortCut.quickKeyTxt.mouseChildren=bottomUI.UI_shortCut.quickKeyTxt.mouseEnabled=false;
			ResizeManager.Instance.regFunc(resize);
			resize();
			
			//商城特效
			var mall_mc:MovieClip=bottomUI.bts.mc_mall;
			mall_mc.buttonMode=true;
			var mall_eff:MovieClip=bottomUI.bts.mc_mall.eff;
			mall_eff.mouseEnabled=false;
			mall_eff.mouseChildren=false;
			var mcc:MovieClipCtrl=new MovieClipCtrl(mall_eff,15);
			mcc.play();
		}
		
		
		/**定位各个ui
		 */
		private function  resize():void
		{
			pepleUI.x=20;
			pepleUI.y=10;
			
			_foldSmallMapBtn.x=StageProxy.Instance.stage.stageWidth-29;
			_foldSmallMapBtn.y=2;
			if(_isFoldMap)
			{
				_smallMapUI.x=StageProxy.Instance.stage.stageWidth-250;
				_smallMapUI.y=0;
			}
			else
			{
				_smallMapUI.x=StageProxy.Instance.stage.stageWidth+_smallMapUI.width;
				_smallMapUI.y=-_smallMapUI.height;
			}
//			topUI.y = 0;
			topUI.y = 5;//坐标我改过了（by ludingchang）
//			topUI.x = StageProxy.Instance.stage.stageWidth-450;
			topUI.x = StageProxy.Instance.stage.stageWidth-225;
			
			bottomUI.x=StageProxy.Instance.getWidth()-1010;
			bottomUI.y=StageProxy.Instance.getHeight()-171
			
			var bagRootPt:Point=UIPositionUtil.getUIRootPosition(bottomUI.bts.btn_bag);
			GameViewPositonProxy.BagX=bagRootPt.x//+bottomUI.bts.btn_bag.width*0.5;
			GameViewPositonProxy.BagY=bagRootPt.y//+bottomUI.bts.btn_bag.height*0.5;
			
			
			var petRootBtn:Point=UIPositionUtil.getUIRootPosition(bottomUI.bts.btn_pet);
			GameViewPositonProxy.PetX=petRootBtn.x//+bottomUI.bts.btn_pet.width*0.5;
			GameViewPositonProxy.PetY=petRootBtn.y//+bottomUI.bts.btn_pet.height*0.5;
			
			var skillRootBtn:Point=UIPositionUtil.getUIRootPosition(bottomUI.bts.btn_skill);
			GameViewPositonProxy.SKillX=skillRootBtn.x//+bottomUI.bts.btn_skill.width*0.5;
			GameViewPositonProxy.SkillY=skillRootBtn.y//+bottomUI.bts.btn_skill.height*0.5;
			
			//好友
			var friendRootBtn:Point=UIPositionUtil.getUIRootPosition(bottomUI.bts.btn_friend);
			GameViewPositonProxy.FriendX=friendRootBtn.x//+bottomUI.bts.btn_friend.width*0.5;
			GameViewPositonProxy.FriendY=friendRootBtn.y//+bottomUI.bts.btn_friend.height*0.5;
				
			//翅膀
			var wingRootBtn:Point=UIPositionUtil.getUIRootPosition(bottomUI.bts.btn_wing);
			GameViewPositonProxy.WingX=wingRootBtn.x//+bottomUI.bts.btn_wing.width*0.5;
			GameViewPositonProxy.WingY=wingRootBtn.y//+bottomUI.bts.btn_wing.height*0.5;

			//坐骑
			var mountRootBtn:Point=UIPositionUtil.getUIRootPosition(bottomUI.bts.btn_mount);
			GameViewPositonProxy.MountX=mountRootBtn.x//+bottomUI.bts.btn_mount.width*0.5;
			GameViewPositonProxy.MountY=mountRootBtn.y//+bottomUI.bts.btn_mount.height*0.5;
			//商城
			var mallRootBtn:Point=UIPositionUtil.getUIRootPosition(bottomUI.bts.mc_mall);
			GameViewPositonProxy.MallX=mallRootBtn.x//+bottomUI.bts.mc_mall.width*0.5;
			GameViewPositonProxy.MallY=mallRootBtn.y//+bottomUI.bts.mc_mall.height*0.5;
			
			
			//组队
			var TeamRootBtn:Point=UIPositionUtil.getUIRootPosition(_mapUI.teamBtn);
			GameViewPositonProxy.TeamX=TeamRootBtn.x//+_mapUI.teamBtn.width*0.5;
			GameViewPositonProxy.TeamY=TeamRootBtn.y//+_mapUI.teamBtn.height*0.5;

			//市场
			var MarketRootBtn:Point=UIPositionUtil.getUIRootPosition(_mapUI.marketBtn);
			GameViewPositonProxy.MarketX=MarketRootBtn.x//+_mapUI.marketBtn.width*0.5;
			GameViewPositonProxy.MarketY=MarketRootBtn.y//+_mapUI.marketBtn.height*0.5;
			// 工会
			var GuildRootBtn:Point=UIPositionUtil.getUIRootPosition(bottomUI.bts.btn_guild);
			GameViewPositonProxy.GuildX=GuildRootBtn.x//+bottomUI.bts.btn_guild.width*0.5;
			GameViewPositonProxy.GuildY=GuildRootBtn.y//+bottomUI.bts.btn_guild.height*0.5;
		
			//锻造
			var forageRootBtn:Point=UIPositionUtil.getUIRootPosition(bottomUI.bts.btn_goodsBuild);
			GameViewPositonProxy.ForageX=forageRootBtn.x//+bottomUI.bts.btn_goodsBuild.width*0.5;
			GameViewPositonProxy.ForageY=forageRootBtn.y//+bottomUI.bts.btn_goodsBuild.height*0.5;


		}
		
		
		/** 底部按钮各种事件 */
		protected function addEvents():void
		{
//			pepleUI.__AddMoneyBt.addEventListener(MouseEvent.CLICK,onClick);
			bottomUI.extend_btn.addEventListener(MouseEvent.CLICK,onClick);///关闭和伸展隐藏的技能格子
			Sprite(bottomUI.extend_btn).buttonMode = true;
			Xtip.registerTip(bottomUI.extend_btn,"点击展开更多快捷栏");

			///场景单击 ， 统一的场景单击事件派发
			LayerManager.RootView.addEventListener(MouseEvent.MOUSE_DOWN,onRootClick);
			//养成任务
			topUI.btGrowTask.addEventListener(MouseEvent.CLICK,onClick);
			///商城单击
			bottomUI.bts.mc_mall.addEventListener(MouseEvent.CLICK,onClick);
			//新手礼包
			topUI.signPackage.addEventListener(MouseEvent.CLICK,onClick);
			//天命神脉
			bottomUI.bts.btn_divinePulse.addEventListener(MouseEvent.CLICK,onClick);
			//黄钻礼包
			topUI.yellow_vip.addEventListener(MouseEvent.CLICK,onClick);
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.SystemRewardBtnShow,showSystemRewardBtn);
			YFEventCenter.Instance.addEventListener(GlobalEvent.SystemRewardBtnHide,hideSystemRewardBtn);
			
			/*********屏幕下方，点击打开对应的面板**********/
			//背包
			bottomUI.bts.btn_bag.addEventListener(MouseEvent.CLICK,onClick);
			///好友面板 
			bottomUI.bts.btn_friend.addEventListener(MouseEvent.CLICK,onClick);
			///宠物面板
			bottomUI.bts.btn_pet.addEventListener(MouseEvent.CLICK,onClick);
			///坐骑面板
			bottomUI.bts.btn_mount.addEventListener(MouseEvent.CLICK,onClick);
			///技能面板 
			bottomUI.bts.btn_skill.addEventListener(MouseEvent.CLICK,onClick);
			///人物面板 
			bottomUI.bts.btn_figure.addEventListener(MouseEvent.CLICK,onClick);
			///装备打造面板
			bottomUI.bts.btn_goodsBuild.addEventListener(MouseEvent.CLICK,onClick);
			///翅膀面板
			bottomUI.bts.btn_wing.addEventListener(MouseEvent.CLICK,onClick);
			///组队单击
			_mapUI.teamBtn.addEventListener(MouseEvent.CLICK,onClick);	
			//市场单击
			_mapUI.marketBtn.addEventListener(MouseEvent.CLICK,onClick);
			//公会
			bottomUI.bts.btn_guild.addEventListener(MouseEvent.CLICK,onClick);
			
			/*********屏幕右上方，点击打开雷达地图**********/
			//收起、放下雷达地图
			_foldSmallMapBtn.addEventListener(MouseEvent.CLICK,changeSmallMapPos);
			//（姑且叫快捷地图）打开快捷地图，快捷键M
			_mapUI.quickMapBtn.addEventListener(MouseEvent.CLICK,onClick);
			//系统设置
			_mapUI.systemBtn.addEventListener(MouseEvent.CLICK,onClick);
			//黑市商店
			_mapUI.blackShopBtn.addEventListener(MouseEvent.CLICK,onClick);
			//活动
			_mapUI.activityBtn.addEventListener(MouseEvent.CLICK,onClick);
			//排行榜单击
			_mapUI.rankBtn.addEventListener(MouseEvent.CLICK,onClick);
			//系统奖励
			_mapUI.rewardBtn.addEventListener(MouseEvent.CLICK,onClick);
			//挂机设置
			_mapUI.autoBtn.addEventListener(MouseEvent.CLICK,onClick);
			
			_soundBtn.addEventListener(MouseEvent.CLICK,onSoundBtnClick);
			_soundBtn.useHandCursor = true;
			YFEventCenter.Instance.addEventListener(GlobalEvent.BGMControl,soundControl);
			
			//主角移动后，雷达地图上的小地图也要改变
			YFEventCenter.Instance.addEventListener(MapScenceEvent.HeroMoveForSmallMap,onHeroMove);			
			////技能图标面板
			bottomUI.UI_shortCut.addEventListener(MouseEvent.MOUSE_UP,onSkillPaneMouseUP);
			
			//人物转职前黑市商店不能打开
			YFEventCenter.Instance.addEventListener(GlobalEvent.HeroChangeCareerSuccess,heroCareerChange);
			
			/*************************************图标高亮特效***************************************/
			//新手礼包特效
			YFEventCenter.Instance.addEventListener(GlobalEvent.GiftUiUpdate,onGiftEffUpdate);
			//公会图标高亮特效
			YFEventCenter.Instance.addEventListener(GlobalEvent.GuildFlashIconUpdate,onGuildIconFlash);
			//养成任务图标特效
			YFEventCenter.Instance.addEventListener(GlobalEvent.GrowTaskEffUpdate,onGrowTaskEffUpdate);
			//黄钻礼包特效
			YFEventCenter.Instance.addEventListener(GlobalEvent.YellowVipEffUpdate,onYellowVipEffUpdate);
			
			/*****************************************背包满提示**************************************/
			bottomUI.bts.bagFull.visible=false;
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagFull,onBagFull);
					
		} 
		
		private function onBagFull(e:YFEvent):void
		{
			var hide:Boolean=e.param as Boolean;
			if(hide)
				bottomUI.bts.bagFull.visible=true;
			else
				bottomUI.bts.bagFull.visible=false;
		}
		
		private function onYellowVipEffUpdate(e:YFEvent):void
		{
			if(YellowAPIManager.Instence.hasGift()&&DataCenter.Instance.roleSelfVo.roleDyVo.level>=3)
			{
				if(!_yellowVipEff)
				{
					var btn:SimpleButton=topUI.yellow_vip;
					_yellowVipEff=UIEffectManager.Instance.addIconLightTo(topUI,btn.x+btn.width/2,btn.y+btn.height/2);
				}
			}
			else if(_yellowVipEff)
			{
				_yellowVipEff.dispose();
				_yellowVipEff=null;
			}
		}
		
		private function onGrowTaskEffUpdate(e:YFEvent):void
		{
			if(GrowTaskDyManager.Instance.hasFinishGrowTask())
			{
				if(!_growTask_eff)
				{
					var btn:SimpleButton=topUI.btGrowTask;
					_growTask_eff=UIEffectManager.Instance.addIconLightTo(topUI,btn.x+btn.width/2,btn.y+btn.height/2);
				}
				var help:NewGuideAddPoint=NewGuideAddPoint.getInstence(NewGuideAddPoint.GrowTask);
				help.show(LangBasic.Help_GrowTask,LangBasic.Help_Go_Now,GlobalEvent.GrowTaskUIClick);
			}
			else if(_growTask_eff)
			{
				_growTask_eff.dispose();
				_growTask_eff=null;
			}
		}
		
		private function onGuildIconFlash(e:YFEvent):void
		{
			if(GuildInfoManager.Instence.flashAddMemberIcon())
			{
				if(!_guild_addMember_eff)
				{
					_guild_addMember_eff=new FlashEff(URLTool.getCommonAssets("flashEff.swf"),"btn_flash_eff",45);
					_guild_addMember_eff.play();
					var btn:SimpleButton=bottomUI.bts.btn_guild;
					btn.parent.addChild(_guild_addMember_eff);
					_guild_addMember_eff.x=btn.x+btn.width/2-10;
					_guild_addMember_eff.y=btn.y-btn.height/2;
				}
			}
			else if(_guild_addMember_eff)
			{
				_guild_addMember_eff.parent.removeChild(_guild_addMember_eff);
				_guild_addMember_eff.stop();
				_guild_addMember_eff.dispose();
				_guild_addMember_eff=null;
			}
			
		}
		
		private function onGiftEffUpdate(e:YFEvent):void
		{
			if(GiftManager.Instence.hasGift()&&DataCenter.Instance.roleSelfVo.roleDyVo.level>=3)
			{
				if(!_giftEff)
				{
					var btn:SimpleButton=topUI.signPackage;
					_giftEff=UIEffectManager.Instance.addIconLightTo(topUI,btn.x,btn.y);
				}
			}
			else if(_giftEff)
			{
				_giftEff.dispose();
				_giftEff=null;
			}
		}
		
		protected function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case bottomUI.extend_btn://关闭和开启隐藏的技能格子按钮 
					bottomUI.UI_shortCut.quickKeyTxt.visible=bottomUI.UI_shortCut.skillbar2.visible=!bottomUI.UI_shortCut.skillbar2.visible;
					if(bottomUI.UI_shortCut.skillbar2.visible == true){
						MovieClip(bottomUI.extend_btn).gotoAndStop(2);
						ModuleChat(ModuleManager.moduleChat).changeLessY(162);
						Xtip.registerTip(bottomUI.extend_btn,"点击收起更多快捷栏");
					}else{
						MovieClip(bottomUI.extend_btn).gotoAndStop(1);
						ModuleChat(ModuleManager.moduleChat).changeLessY(-1);
						Xtip.registerTip(bottomUI.extend_btn,"点击展开更多快捷栏");
					}
					break;
				case bottomUI.bts.btn_bag://背包 按钮
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BagUIClick);
					break;
				case bottomUI.bts.btn_friend: ///好友面板 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.FriendUIClick);
					break;
				case bottomUI.bts.btn_skill:///技能面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SkillUIClick);
					break;
				case bottomUI.bts.btn_figure: ///人物面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.CharacterUIClick);
					break;
				case bottomUI.bts.btn_goodsBuild: /// 装备打造面板 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ForgeUIClick);
					break;
				case bottomUI.bts.btn_wing: /// 装备翅膀面板 
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.WingUIClick);
					break;
				case bottomUI.bts.btn_pet:///宠物面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.PetUIClick);
					break;
				case bottomUI.bts.btn_mount:///坐骑面板
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MountUIClick);
					break;
				case _mapUI.teamBtn: //组队单击
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.TeamUIClick);
					break;
				/*******************雷达地图相关单击*******************/
				case _mapUI.quickMapBtn: //弹出小地图
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SmallMapUIClick);
					break;
				case bottomUI.bts.mc_mall: //商城单击
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MallUIClick);
					break;
				case _mapUI.marketBtn: //市场单击
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.MarketUIClick);
					break;
				case _mapUI.systemBtn://系统按钮
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SystemUIClick);
					break;
				case _mapUI.blackShopBtn://黑市商店
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BlackShopUIClick);
					break;
				case _mapUI.activityBtn://活动
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ActivityUIClick);
					break;
				case _mapUI.rankBtn: //排行榜单击
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.RankUIClick);
					break;
				case _mapUI.autoBtn://自动挂机
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.AutoUIClick);
					break;
				case _mapUI.rewardBtn://系统奖励
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SystemRewardUIClick);
					break;
				/******************************************/
				case bottomUI.bts.btn_guild://公会
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GuildUIClick);
					break;
				case topUI.btGrowTask://成长任务
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GrowTaskUIClick);
					break;			
				case topUI.signPackage://新手礼包
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.GiftUIClick);
					break;
				case bottomUI.bts.btn_divinePulse://天命神脉
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.DivinePulseClick);
					break;
				case topUI.yellow_vip://黄钻礼包
					YFEventCenter.Instance.dispatchEventWith(GlobalEvent.YellowVipUIClick);
					break;
			}		
		}
		
		private function hideSystemRewardBtn(e:YFEvent):void
		{
			if(_reward_eff)
			{
				_reward_eff.dispose();
				_reward_eff=null;
			}
		}
		
		private function showSystemRewardBtn(e:YFEvent):void
		{
			if(!_reward_eff)
				_reward_eff=UIEffectManager.Instance.addIconLightTo(_mapUI.reward_eff,0,0,35,35);
		}
		
		protected function onSoundBtnClick(event:MouseEvent=null):void
		{
			if(SystemConfigManager.enableBGM)
			{
				mute();
				SystemConfigManager.enableBGM=false;
			}
			else
			{
				unMute();
				SystemConfigManager.enableBGM=true;
			}
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.BGMMute);
		}
		
		private function soundControl(e:YFEvent=null):void
		{
			if(SystemConfigManager.enableBGM)//取消静音
				unMute();
			else//静音
				mute();
		}
		
		private function mute():void
		{
			GlobalSoundControl.getInstance().mute();
			_soundBtn.gotoAndStop(2);
			Xtip.registerTip(_soundBtn,"取消静音");
		}
		
		private function unMute():void
		{
			GlobalSoundControl.getInstance().unMute();
			_soundBtn.gotoAndStop(1);
			Xtip.registerTip(_soundBtn,"静音");
		}
		
		private function changeSmallMapPos(e:MouseEvent=null):void
		{
			var stageWidth:Number= StageProxy.Instance.stage.stageWidth;
			if(_isFoldMap)//如果状态为true，那么就折叠起来
			{
				TweenLite.to(_mapUI, 0.3, {x:_mapUI.width,y:-214.2, alpha:0} );
				_foldSmallMapBtn.gotoAndStop(2);
				Xtip.registerTip(_foldSmallMapBtn,"折起");
			}
			else
			{
				TweenLite.to(_mapUI, 0.3, {x:35,y:27.55, alpha:1} );
				_foldSmallMapBtn.gotoAndStop(1);
				Xtip.registerTip(_foldSmallMapBtn,"展开");
			}
			_isFoldMap=!_isFoldMap;
		}
		
		private function onHeroMove(e:YFEvent):void
		{
			var pt:Point=HeroPositionProxy.getTilePositon();				
			_mapUI.pos.text=pt.x+"/"+pt.y;
		}
		
		/**切换场景,改变地图名字 */
		public function updateChangeMap():void
		{
			_mapName.text=DataCenter.Instance.mapSceneBasicVo.mapDes;
		}
		
		private function onSkillPaneMouseUP(e:MouseEvent):void
		{
			var display:DisplayObject=e.currentTarget as DisplayObject;
			var x:Number=display.mouseX;
			var y:Number=display.mouseY;
			
			YFEventCenter.Instance.dispatchEventWith(GlobalEvent.SkillPaneMouseUp,{x:x,y:y,container:display});
		}
			
		private function onRootClick(e:MouseEvent):void
		{
			//判断ui层是否透明  透明则人物能进行行走检测 
			var myTaret:DisplayObject=e.target as DisplayObject;
			var isNotAlpha:Boolean=false;//
			if(LayerManager.UIViewRoot.contains(myTaret))
				isNotAlpha=BitmapDataUtil.getInsect(LayerManager.UIViewRoot,LayerManager.UIViewRoot.mouseX,LayerManager.UIViewRoot.mouseY);
			if(!isNotAlpha)  ///当uiView层该点 无对象时
			{
				StageProxy.Instance.setNoneFocus();
				YFEventCenter.Instance.dispatchEventWith(GlobalEvent.ScenceClick,myTaret);
			}
		}
		
		private function checkBlackShopBtn():void
		{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.career == TypeRole.CAREER_NEWHAND)
			{
				SimpleButton(_mapUI.blackShopBtn).enabled=false;
				SimpleButton(_mapUI.blackShopBtn).mouseEnabled=false;
			}
			else
			{
				SimpleButton(_mapUI.blackShopBtn).enabled=true;
				SimpleButton(_mapUI.blackShopBtn).mouseEnabled=true;
			}
		}
		
		private function heroCareerChange(e:YFEvent):void
		{
			checkBlackShopBtn();
		}
	}
}