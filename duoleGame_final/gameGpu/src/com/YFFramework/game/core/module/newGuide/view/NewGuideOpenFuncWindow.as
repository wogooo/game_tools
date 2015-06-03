package com.YFFramework.game.core.module.newGuide.view
{
	/**@author yefeng
	 * 2013 2013-11-18 下午4:09:44 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.ui.yfComponent.PopUpManager;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.UIPositionUtil;
	import com.YFFramework.game.core.module.feed.event.FeedEvent;
	import com.YFFramework.game.core.module.gameView.view.GameViewPositonProxy;
	import com.YFFramework.game.core.module.newGuide.manager.NewGuideManager;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideFuncOpenConfig;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideOpenFuncBasicVo;
	import com.YFFramework.game.core.module.newGuide.model.NewGuideOpenFuncType;
	import com.YFFramework.game.ui.layer.LayerManager;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/** 新功能开启面板
	 */
	public class NewGuideOpenFuncWindow extends Window
	{
		private var _mc:Sprite;
		private var _btn:Button;
		private var _txt:TextField;
		private var _iconImage:IconImage;
		
		private var _openFuncBasicVo:NewGuideOpenFuncBasicVo;
		/**
		 * @param openFuncId  值在NewGuideOpenFuncType里面
		 */
		public function NewGuideOpenFuncWindow(openFuncId:int)
		{
			_openFuncBasicVo=new NewGuideOpenFuncBasicVo();
			_openFuncBasicVo.open_id=openFuncId;
			super(NewGuideFuncOpenWindowBg);
			initUI();
			addEvents();
		}
		private function initUI():void
		{
			_mc=initByArgument(370,340,"All_newGuideOpenFunc",null);//在 All文件里面
			_closeButton.visible=false;
			_btn=Xdis.getChild(_mc,"btn_button");
			_txt=Xdis.getChild(_mc,"newGuideTxt");
			_txt.mouseEnabled=false;
			_iconImage=Xdis.getChild(_mc,"img_iconImage");
			_iconImage.mouseChildren=_iconImage.mouseEnabled=false;
			setContentXY(7,7);
			switch(_openFuncBasicVo.open_id)  //所有的链接名都在newMainUi里面 
			{
				case NewGuideOpenFuncType.Open_Bag:
					_iconImage.linkage="newMainUI_bag"
					_txt.text="背包功能开启";
					break;
				case NewGuideOpenFuncType.Open_Pet:
					_iconImage.linkage="newMainUI_pet"
					_txt.text="宠物功能开启";
					break;
				case NewGuideOpenFuncType.Open_Skill: //开启技能
					_iconImage.linkage="newMainUI_skill"
					_txt.text="技能功能开启";
					break;
				case NewGuideOpenFuncType.Open_Friend: //开启好友
					_iconImage.linkage="newMainUI_friend"
					_txt.text="好友功能开启";
					break;
				case NewGuideOpenFuncType.Open_Wing: //开启翅膀
					_iconImage.linkage="newMainUI_wing"
					_txt.text="翅膀功能开启";
					break;
				case NewGuideOpenFuncType.Open_Mount: //开启坐骑
					_iconImage.linkage="newMainUI_mount"
					_txt.text="坐骑功能开启";
					break;
				case NewGuideOpenFuncType.Open_Mall:  //开启商城
					_iconImage.linkage="newMainUI_mall"
					_txt.text="商城功能开启";
					break;
				case NewGuideOpenFuncType.Open_Forage:  //开启锻造面板 
					_iconImage.linkage="newMainUI_forage"
					_txt.text="锻造功能开启";
					break;
				case NewGuideOpenFuncType.Open_Guild:  //工会开启
					_iconImage.linkage="newMainUI_guild"
					_txt.text="公会功能开启";
					break;
				case NewGuideOpenFuncType.Open_Team: //组队开启  
					_iconImage.linkage="newMainUI_team"
					_txt.text="组队功能开启";
					break;
				case NewGuideOpenFuncType.Open_Market: //市场开启  
					_iconImage.linkage="newMainUI_marcket"
					_txt.text="市场功能开启";
					break;
			}
		}
		private function addEvents():void
		{
			_btn.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function removeEvents():void
		{
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
		}
		override public function dispose():void
		{
			super.dispose();
			removeEvents();
			_mc=null;
			_btn=null;
			_txt=null;
//			if(parent)parent.removeChild(this);
		}
		
		public function show():void
		{
			PopUpManager.addPopUp(this,LayerManager.PopLayer,0,0,0xFFFFFF,0.1,null);
			PopUpManager.centerPopUp(this);
			NewGuideMovieClipWidthArrow.Instance.initGuideLeft(_btn.x+_btn.width,_btn.y);
			NewGuideMovieClipWidthArrow.Instance.addToContainer(this);
		}
		private function onClick(e:MouseEvent=null):void
		{
			doTween();
			PopUpManager.removePopUp(this);
			dispose();
			_openFuncBasicVo=null;
//			NewGuideManager.DoGuide();
		}
		private function doTween():void
		{
			var icon:IconImage=new IconImage();
			icon.linkage=_iconImage.linkage;
//			icon.url=URLTool.getCommonAssets("diamond.png");
//			print(this,"此处加上图片地址");
			var pos:Point=UIPositionUtil.getPosition(_iconImage,LayerManager.UIViewRoot);
			icon.x=pos.x;
			icon.y=pos.y;
			var endX:Number=0;
			var endY:Number=0;
			switch(_openFuncBasicVo.open_id)
			{
				case NewGuideOpenFuncType.Open_Bag:
					endX=GameViewPositonProxy.BagX;
					endY=GameViewPositonProxy.BagY;
					_txt.text="背包功能开启";
					break;
				case NewGuideOpenFuncType.Open_Pet:
					endX=GameViewPositonProxy.PetX;
					endY=GameViewPositonProxy.PetY;
					_txt.text="宠物功能开启";
					break;
				case NewGuideOpenFuncType.Open_Skill: //开启技能
					endX=GameViewPositonProxy.SKillX;
					endY=GameViewPositonProxy.SkillY;
					_txt.text="技能功能开启";
					break;
				case NewGuideOpenFuncType.Open_Friend: //开启好友
					endX=GameViewPositonProxy.FriendX;
					endY=GameViewPositonProxy.FriendY;
					_txt.text="好友功能开启";
					break;
				case NewGuideOpenFuncType.Open_Wing: //开启翅膀
					endX=GameViewPositonProxy.WingX;
					endY=GameViewPositonProxy.WingY;
					_txt.text="翅膀功能开启";
					break;
				case NewGuideOpenFuncType.Open_Mount: //开启坐骑
					endX=GameViewPositonProxy.MountX;
					endY=GameViewPositonProxy.MountY;
					_txt.text="坐骑功能开启";
					break;
				case NewGuideOpenFuncType.Open_Mall:  //开启商城
					endX=GameViewPositonProxy.MallX;
					endY=GameViewPositonProxy.MallY;
					_txt.text="商城功能开启";
					break;
				case NewGuideOpenFuncType.Open_Forage:  //开启锻造面板 
					endX=GameViewPositonProxy.ForageX;
					endY=GameViewPositonProxy.ForageY;
					_txt.text="锻造功能开启";
					break;
				case NewGuideOpenFuncType.Open_Guild:  //工会开启
					endX=GameViewPositonProxy.GuildX;
					endY=GameViewPositonProxy.GuildY;
					_txt.text="公会功能开启";
					break;
				case NewGuideOpenFuncType.Open_Team: //组队开启  
					endX=GameViewPositonProxy.TeamX;
					endY=GameViewPositonProxy.TeamY;
					_txt.text="组队功能开启";
					break;
				case NewGuideOpenFuncType.Open_Market: //市场开启  
					endX=GameViewPositonProxy.MarketX;
					endY=GameViewPositonProxy.MarketY;
					_txt.text="市场功能开启";
					break;

			}
			LayerManager.DisableLayer.addChild(icon);
			TweenLite.to(icon,0.5,{x:endX,y:endY,onComplete:completeIt,onCompleteParams :[icon,_openFuncBasicVo.open_id],onUpdate:updateIt,onUpdateParams :[icon]});
		}
			
		private function completeIt(icon:IconImage,open_Id:int):void
		{
			var endX:Number=icon.x+30;
			var endY:Number=icon.y+20;
			LayerManager.DisableLayer.removeChild(icon);
			NewGuideManager.DoGuide();
			NoticeUtil.playNewFuncOpenEffect(endX,endY);
			NewGuideFuncOpenConfig.IncreaseGuideValue();
			
			switch(open_Id)
			{
				case NewGuideOpenFuncType.Open_Team:
					YFEventCenter.Instance.dispatchEventWith(FeedEvent.InviteFriends);//邀请好友
					break;
			}
		}
		private function updateIt(icon:IconImage):void
		{
			///此处跟新坐标做例子跟随效果 
		}

		/**如果该面板弹出来 则其他引导无效 
		 */
		override public function getNewGuideVo():*
		{
			return 1;
		}
		
		
		
			
	}
}
