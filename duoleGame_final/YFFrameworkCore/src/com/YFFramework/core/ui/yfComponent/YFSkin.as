package com.YFFramework.core.ui.yfComponent
{
	import com.YFFramework.core.ui.abs.Scale9Bitmap;
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	
	import flashx.textLayout.elements.BreakElement;

	/**  812-6-8
	 *	@author yefeng
	 */
	public class YFSkin
	{
		
		/** tab Button按钮
		 */		
		public static const TabBtn1:String="TabBtn1";
		
		public static const TabBtn2:String="TabBtn2";
		public static const TabBtn3:String="TabBtn3";
		
		/** numberStepper
		 */		
		public static const NumberStepperUpBtn:String="NumberStepperUpBtn";
		public static const NumberStepperDownBtn:String="NumberStepperDownBtn";
		public static const NumberStepperTextBg:String="NumberStepperTextBg";
		
		
		/**
		 *   窗口面板上的关闭按钮
		 */		
		public static const CloseBtn:String="CloseBtn";
		
		/**程序常用按钮  皮肤   基本按钮
		 */		
		public static const Button1:String="Button1";
		
		public static const Button2:String="Button2";
		/** addBtn 添加 按钮  加号形状
		 */		
		public static const AddBtn:String="AddBtn";
		
		
		
		/**好友面板按钮的 的背景皮肤 两种状态 选中与不选中
		 */		
		public static const FriendPaneBtn:String="FriendPaneBtn";
		
		/** 向左翻页的按钮 1  
		 */		
		public static const PageLeftButton1:String="PageLeftButton1";
		/**向右翻页的按钮1 
		 */		
		public static const PageRightButton1:String="PageRightButton1";
		/**文本背景
		 */
		public static const LabelBg1:String="LabelBg1";
		
		/**下拉菜单  按钮组件
		 */		
		public static const ComboBoxBtn:String="ComboBoxBtn";
		/**  下拉菜单皮肤
		 */
		public static const ComboBox:String="ComboBox";

		/**  list Menu 按钮皮肤
		 */		
		public static const MenuListBtn:String="MenuList";
		
		/** list Menu 按钮皮肤
		 */		
		public static const MenuListBtn2:String="MenuListBtn2";
		
		
		/**菜单列表的背景
		 */		
		public static const MenuListBg:String="MenuListBg";
		
		/** 组件tips 
		 */		
		public static const YFComponentTips:String="YFComponentTips";
		/**  滚动条的皮肤 
		 */
		public static const Scroller:String="Scroller";
		/**
		 *  滚动条按钮 皮肤
		 */		
		public static const ScrollerUpBtn:String="ScrollerBtn";
		/**
		 *  滚动条按钮 皮肤
		 */		
		public static  const ScrollerDownBtn:String="ScrollerDownBtn";
		
		/** check Box 
		 */		
		public static const CheckBox:String="CheckBox";
		
		/**RadioButton
		 */		
		public static const RadioButton:String="RadioButton";
		/**
		 *pane 面板皮肤  
		 */		
		public static const panelBgSkin:String="panelBgSkin";
		
		public static const WindowSkin:String="WindowSkin";

		/**树皮肤组件按钮  打开或者关闭状态
		 */		
		public static const TreeSkin1:String="TreeSkin1";
		public static const TreeCellBgSkin:String="TreeSkin2";
		///背包 仓库的 物品背景 
		/** 图标 1   背包仓库 的 物品图标背景 没有锁住的格子图标  开启的格子
		 */		
		public static const GridsOpen:String="GridsOpen";
		
		/**  图标2  锁住的格子图标
		 */
		public static const GridsLock:String="GridsLock";
		/**技能框
		 */		
		public static const SkillFrame:String="skillFrame";
		
		
		
		/**金币图标
		 */		
		public static const YFMoneyJinbi:String="YFMoneyJinbi";
		
		public static const YFMoneyYuanbao:String="YFMoneyYuanbao";
		
		/**人物血量警告提示 人物血量提示  当人物血量过少时    游戏界面四周 会泛红  提示玩家 血量 过少
		 */		
		public static const HpTips:String="YFHpTips";
		/** 移动箭头  主角移动箭头 用于小地图
		 */		
		public static const MoveArrow:String="MoveArrow";
		/**小地图 npc 
		 */		
		public static const SmallMapNPC:String="SmallMapNPC";
		/**小地图上显示的队友图标
		 */		
		public static const SmallMapTeamPic:String="SmallMapTeamPic";
		/**小地图上显示的传送点图标
		 */		
		public static const SmallMapExitPic:String="smallMapExitPic";
		/**小地图上的怪物点
		 */		
		public static const SmallMapMonsterPic:String="SmallMapMonsterPic";
		/**小地图上的 怪物区域 
		 */		
		public static const SmallMapMonsterZonePic:String="SmallMapMonsterZonePic";
		/**小飞鞋
		 */
		public static const SMallMapFlyBoot:String="SMallMapFlyBoot";
		
		/**  聊天冒泡皮肤
		 */		
		/** 左边冒泡聊天的皮肤
		 * 
		 */		
		public static const YFChatArrowLeft:String="YFChatArrowLeft";
		/**右边冒泡的皮肤
		 */		
		public static const YFChatArrowRight:String="YFChatArrowRight";
		
		////影片剪辑 类型的 mc  皮肤
		
		/** CD动画
		 */		
		public static const CD:String="CD";
		/**
		 * progressbar 进度条 
		 */		
		public static const ProgressBarSkin1:String="ProgressBarSkin1";
		
		private static var _instance:YFSkin;
		public function YFSkin()
		{
		}
		public static function get Instance():YFSkin
		{
			if(!_instance) _instance=new YFSkin();
			return _instance;
		}
		
		/**  获取 皮肤样式
		 */		
		public function getStyle(type:String):YFStyle
		{
			var style:YFStyle=new YFStyle();
					
			var up:Scale9Bitmap;
			var over:Scale9Bitmap;
			var down:Scale9Bitmap;
			var disable:Scale9Bitmap;
			
			var upBitmapData:BitmapData;
			var downBitmapData:BitmapData;
			var overBitmapData:BitmapData;
			var disableBitmapData:BitmapData;
			switch(type)
			{
				
				
				case CloseBtn:
					upBitmapData=ClassInstance.getInstance("close_skin") as BitmapData;
					overBitmapData=ClassInstance.getInstance("close_overSkin") as BitmapData;
					downBitmapData=ClassInstance.getInstance("close_downSkin") as BitmapData;
					style.scale9L=0;
					style.scale9R=0;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);
					style.link={up:up,over:over,down:down,disable:null}
					break;
				
				case Button1:  ///游戏常用btn
					upBitmapData=ClassInstance.getInstance("redBtn_skin") as BitmapData;
					overBitmapData=ClassInstance.getInstance("redBtn_overSkin") as BitmapData;
					downBitmapData=ClassInstance.getInstance("redBtn_downSkin") as BitmapData;
					disableBitmapData=ClassInstance.getInstance("redBtn_disableSkin") as BitmapData;
					style.scale9L=0;
					style.scale9R=0;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);
					disable=getScale9Bitmap(disableBitmapData,style);
					style.fontSize=12;
					style.upColor=0xFFFFFF;
					style.overColor=0x00FF00;
					style.downColor=0x33dd33;
					style.disableColor=0x999999;
					style.link={up:up,over:over,down:down,disable:disable}
					break;
				case Button2:  ///游戏常用btn
					upBitmapData=ClassInstance.getInstance("button_skin2") as BitmapData;
					overBitmapData=ClassInstance.getInstance("button_overSkin2") as BitmapData;
					downBitmapData=ClassInstance.getInstance("button_downSkin2") as BitmapData;
					disableBitmapData=ClassInstance.getInstance("redBtn_disableSkin") as BitmapData;
					style.scale9L=0;
					style.scale9R=0;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);
					disable=getScale9Bitmap(disableBitmapData,style);
					style.fontSize=12;
					style.upColor=0xFFFFFF;
					style.overColor=0x00FF00;
					style.downColor=0x33dd33;
					style.disableColor=0x999999;
					style.link={up:up,over:over,down:down,disable:disable}
					break;
				case AddBtn:   ///加号形状的btn 
					upBitmapData=ClassInstance.getInstance("addBtn_upSkin") as BitmapData;
					overBitmapData=ClassInstance.getInstance("addBtn_overSkin") as BitmapData;
					downBitmapData=ClassInstance.getInstance("addBtn_downSkin") as BitmapData;
					disableBitmapData=ClassInstance.getInstance("addBtn_unenable") as BitmapData;
					style.scale9L=0;
					style.scale9R=0;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);
					disable=getScale9Bitmap(disableBitmapData,style);
					style.fontSize=12;
					style.upColor=0xFFFFFF;
					style.overColor=0x00FF00;
					style.downColor=0x33dd33;
					style.disableColor=0x999999;
					style.link={up:up,over:over,down:down,disable:disable}
					break;
				case PageLeftButton1:
					///向左翻页 按钮 1
					upBitmapData=ClassInstance.getInstance("page_left_up_1") as BitmapData;
					overBitmapData=ClassInstance.getInstance("page_let_over_1") as BitmapData;
					downBitmapData=ClassInstance.getInstance("page_left_down_1") as BitmapData;
					style.scale9L=0;
					style.scale9R=0;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);
					style.link={up:up,over:over,down:down,disable:null}
					break;
				case PageRightButton1:
					//向右翻页按钮2  
					upBitmapData=ClassInstance.getInstance("page_right_up_1") as BitmapData;
					overBitmapData=ClassInstance.getInstance("page_right_over_1") as BitmapData;
					downBitmapData=ClassInstance.getInstance("page_right_down_1") as BitmapData;
					style.scale9L=0;
					style.scale9R=0;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);
					style.link={up:up,over:over,down:down,disable:null}
					break;
				case MenuListBtn:
					///菜单列表的 按钮皮肤
					upBitmapData=ClassInstance.getInstance("menuItemSkin") as BitmapData;
					overBitmapData=ClassInstance.getInstance("menuItemOverSkin") as BitmapData;
					style.scale9L=2;
					style.scale9R=2;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=over;
					style.fontSize=12;
					style.upColor=0xFFFFFF;
					style.overColor=0x00FF00;
					style.downColor=0x33dd33;
					style.disableColor=0x999999;
					style.link={up:up,over:over,down:down,disable:null}
					break;
				case MenuListBtn2:
					///菜单列表的 按钮皮肤
					upBitmapData=ClassInstance.getInstance("menuItemUp2") as BitmapData;
					overBitmapData=ClassInstance.getInstance("menuItemOver2") as BitmapData;
					downBitmapData=ClassInstance.getInstance("menuItemDown2") as BitmapData
					style.scale9L=2;
					style.scale9R=2;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);;
					style.fontSize=12;
					style.upColor=0xFFFFFF;
					style.overColor=0x00FF00;
					style.downColor=0x33dd33;
					style.disableColor=0x999999;
					style.link={up:up,over:over,down:down,disable:null}
					break;
				case MenuListBg:
					///菜单列表的 按钮皮肤
					var menuBgData:BitmapData=ClassInstance.getInstance("tooltipsBg") as BitmapData;
					style.scale9L=4;
					style.scale9R=4;
					style.scale9T=4;
					style.scale9B=4;
					var menuBg:Scale9Bitmap=getScale9Bitmap(menuBgData,style);
					style.link=menuBg;
					break;

				case ComboBoxBtn:
					///下拉框皮肤	
					upBitmapData=ClassInstance.getInstance("comboxSkin") as BitmapData;
					overBitmapData=ClassInstance.getInstance("comboxOverSkin") as BitmapData;
					style.scale9L=3;
					style.scale9R=20;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=over;
					disable=up;
					style.upColor=0xFFFFFF;
					style.overColor=0x00FF00;
					style.downColor=0x33dd33;
					style.disableColor=0x999999;
					style.link={up:up,over:over,down:down,disable:disable}
					break;
				case ComboBox: ///菜单皮肤
					///设置 按钮皮肤  使用9切片 
					style.backgroundColor=0xFFFFFF;
					style.link={space:0};//两个listItem之间的垂直间距
					break;
				
				///滚动条按钮
				case ScrollerUpBtn:
					upBitmapData=ClassInstance.getInstance("upArrowSkin1") as BitmapData;
					overBitmapData=ClassInstance.getInstance("upArrowOverSkin1") as BitmapData;
					downBitmapData=ClassInstance.getInstance("upArrowDownSkin1") as BitmapData;
					style.scale9L=0;
					style.scale9R=0;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);
					disable=up;
					style.link={up:up,over:over,down:down,disable:disable}
					break;
				///滚动条按钮
				case ScrollerDownBtn:
					upBitmapData=ClassInstance.getInstance("downArrowSkin1") as BitmapData;
					overBitmapData=ClassInstance.getInstance("downArrowOverSkin1") as BitmapData;
					downBitmapData=ClassInstance.getInstance("downArrowDownSkin1") as BitmapData;
					style.scale9L=0;
					style.scale9R=0;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);
					disable=down;
					style.link={up:up,over:over,down:down,disable:disable}
					break;
				case Scroller:  ///滚动条的皮肤 
					var trackData:BitmapData=ClassInstance.getInstance("trackSkin1") as BitmapData;
					style.scale9L=2;
					style.scale9R=2;
					style.scale9T=2;
					style.scale9B=2;
					var scrollerTrack:Scale9Bitmap=getScale9Bitmap(trackData,style);
					var barData:BitmapData=ClassInstance.getInstance("handlerSkin") as BitmapData;
					var bar:Scale9Bitmap=getScale9Bitmap(barData,style);
					style.link={v:scrollerTrack,b:bar}
					break;

				
				//NumberStepper上下组件皮肤 
				case NumberStepperUpBtn:
					upBitmapData=ClassInstance.getInstance("NumericStepperUpArrow_upSkin") as BitmapData;
					overBitmapData=ClassInstance.getInstance("NumericStepperUpArrow_overSkin") as BitmapData;
					downBitmapData=ClassInstance.getInstance("NumericStepperUpArrow_downSkin") as BitmapData;
					style.scale9L=0;
					style.scale9R=0;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);
					style.link={up:up,over:over,down:down,disable:null}
					break;
				case NumberStepperDownBtn:
					upBitmapData=ClassInstance.getInstance("NumericStepperDownArrow_upSkin") as BitmapData;
					overBitmapData=ClassInstance.getInstance("NumericStepperDownArrow_overSkin") as BitmapData;
					downBitmapData=ClassInstance.getInstance("NumericStepperDownArrow_downSkin") as BitmapData;
					style.scale9L=0;
					style.scale9R=0;
					style.scale9T=0;
					style.scale9B=0;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=getScale9Bitmap(downBitmapData,style);
					style.link={up:up,over:over,down:down,disable:null}
					break;
				case NumberStepperTextBg:
					var  textBg:BitmapData=ClassInstance.getInstance("numericStepper_Text") as BitmapData;
					style.scale9L=2;
					style.scale9R=2;
					style.scale9T=2;
					style.scale9B=2;
					style.link=getScale9Bitmap(textBg,style);
					break;
				/// tabButton皮肤 
				case TabBtn1:
					upBitmapData=ClassInstance.getInstance("Tab_unselect1") as BitmapData;
					overBitmapData=ClassInstance.getInstance("Tab_select1") as BitmapData;
			//		downBitmapData=ClassInstance.getInstance("tab_selectedSkin") as BitmapData;
					style.scale9L=3;
					style.scale9R=3;
					style.scale9T=4;
					style.scale9B=0;
					style.fontSize=12;
					style.upColor=0xFFFFFF;
					style.overColor=0x00FF00;
					style.downColor=0x33dd33;
					style.disableColor=0x999999;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=over;//getScale9Bitmap(downBitmapData,style);
					style.link={up:up,over:over,down:down,disable:null}
					break;	
				case TabBtn2:
					upBitmapData=ClassInstance.getInstance("Tab_unSelect2") as BitmapData;
					overBitmapData=ClassInstance.getInstance("Tab_select2") as BitmapData;
					//		downBitmapData=ClassInstance.getInstance("tab_selectedSkin") as BitmapData;
					style.scale9L=3;
					style.scale9R=3;
					style.scale9T=4;
					style.scale9B=0;
					style.fontSize=12;
					style.upColor=0xFFFFFF;
					style.overColor=0x00FF00;
					style.downColor=0x33dd33;
					style.disableColor=0x999999;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=over;//getScale9Bitmap(downBitmapData,style);
					style.link={up:up,over:over,down:down,disable:null}
					break;
				case TabBtn3:
					upBitmapData=ClassInstance.getInstance("Tab_unSelect3") as BitmapData;
					overBitmapData=ClassInstance.getInstance("Tab_select3") as BitmapData;
					//		downBitmapData=ClassInstance.getInstance("tab_selectedSkin") as BitmapData;
					style.scale9L=3;
					style.scale9R=3;
					style.scale9T=4;
					style.scale9B=0;
					style.fontSize=12;
					style.upColor=0xFFFFFF;
					style.overColor=0x00FF00;
					style.downColor=0x33dd33;
					style.disableColor=0x999999;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=over;//getScale9Bitmap(downBitmapData,style);
					style.link={up:up,over:over,down:down,disable:null}
					break;
				case YFComponentTips:///组件tips 
					var yfComponentTipsBgData:BitmapData=ClassInstance.getInstance("tooltipsBg") as BitmapData;
					style.scale9L=4;
					style.scale9R=4;
					style.scale9T=4;
					style.scale9B=4;
					var yfComponentBgSkin:Scale9Bitmap=getScale9Bitmap(yfComponentTipsBgData,style);
					style.link={bg:yfComponentBgSkin};
					break;
				case LabelBg1:////文本背景
					var  textBgData:BitmapData=ClassInstance.getInstance("textBg") as BitmapData;
					style.link=textBgData;
					break;
				case CheckBox:
					//选中图片  
					var selectMC:BitmapData=ClassInstance.getInstance("checkBox_unselect") as BitmapData;
					//未选中的图片
					var unSelectMc:BitmapData=ClassInstance.getInstance("checkBox_select") as BitmapData;
					//checkbox文字的几个状态
					style.upColor=0xFFFFFF;
					style.fontSize=12;
					style.overColor=0xdddddd;
					style.downColor=0xdddddd;
					style.link={select:new Bitmap(selectMC),unSelect:new Bitmap(unSelectMc),iconW:unSelectMc.width,iconH:unSelectMc.height};
					break;
				///单选
				case RadioButton:
					var selectbmData:BitmapData=ClassInstance.getInstance("RadioButton_select") as BitmapData;
					//未选中的图片
					var unSelectBmData:BitmapData=ClassInstance.getInstance("RadioButton_unselect") as BitmapData;
					//checkbox文字的几个状态
					style.upColor=0xFFFFFF;
					style.overColor=0xFFFFFF;
					style.downColor=0xFFFFFF;
					style.fontSize=12;
					style.overColor=0xdddddd;
					style.downColor=0xdddddd;
					style.link={select:new Bitmap(selectbmData),unSelect:new Bitmap(unSelectBmData),iconW:selectbmData.width,iconH:unSelectBmData.height};
					break;
				case FriendPaneBtn:
					upBitmapData=ClassInstance.getInstance("friend_select") as BitmapData;
					overBitmapData=ClassInstance.getInstance("friend_unselect") as BitmapData;
					style.scale9L=10;
					style.scale9R=10;
					style.scale9T=5;
					style.scale9B=5;
					up=getScale9Bitmap(upBitmapData,style);
					over=getScale9Bitmap(overBitmapData,style);
					down=over;
					disable=down;
					style.fontSize=12;
					style.upColor=0xFFFFFF;
					style.overColor=0x00FF00;
					style.downColor=0x33dd33;
					style.disableColor=0x999999;
					style.link={select:up,unSelect:over,down:down,disable:disable,iconW:up.width,iconH:up.height}
					break;
	 
				///树组件
				case TreeSkin1:
					var closeData:BitmapData=ClassInstance.getInstance("tree_close") as BitmapData;
					var openData:BitmapData=ClassInstance.getInstance("tree_open") as BitmapData;
					style.fontSize=12;
					style.upColor=0xFFFFFF;
					style.overColor=0x99ffcc;
					style.downColor=0x99ffcc;
					style.link={select:new Bitmap(closeData),unSelect:new Bitmap(openData),iconW:openData.width,iconH:openData.height};
					break;
				case TreeCellBgSkin:
					var treeunselectData2:BitmapData=ClassInstance.getInstance("tree_toggle_unselect") as BitmapData;
					var treeSelectData2:BitmapData=ClassInstance.getInstance("tree_toggle_select") as BitmapData;
					style.link={select:new Bitmap(treeSelectData2),unSelect:new Bitmap(treeunselectData2)};
					break;
				////面板背景皮肤
				case panelBgSkin:
					var paneSkin:BitmapData=ClassInstance.getInstance("panelBgSkin") as BitmapData;
					style.scale9L=10;
					style.scale9R=10;
					style.scale9T=30;
					style.scale9B=5;
					style.link=getScale9Bitmap(paneSkin,style);
					break;
				case WindowSkin:
					var windowTopData:BitmapData=ClassInstance.getInstance("windowTop") as BitmapData;
					var windowBodyData:BitmapData=ClassInstance.getInstance("windowBody") as BitmapData;
					style.scale9L=12;
					style.scale9R=12;
					style.scale9T=0;
					style.scale9B=0;
					var windowTopSkin:Scale9Bitmap=getScale9Bitmap(windowTopData,style);
					var windowBodySkin:Scale9Bitmap=getScale9Bitmap(windowBodyData,style);
					style.link={top:windowTopSkin,body:windowBodySkin};
					break;
				case YFChatArrowLeft:
					///聊天冒泡皮肤
					var chatArrowLeftData:BitmapData=ClassInstance.getInstance("ChatArrowLeft") as BitmapData;
					style.scale9L=10;
					style.scale9R=10;
					style.scale9T=10;
					style.scale9B=23;
					var chatArrowLeftBitmap:Scale9Bitmap=getScale9Bitmap(chatArrowLeftData,style);
					style.link=chatArrowLeftBitmap;
					break;
				case YFChatArrowRight:
					///聊天冒泡皮肤
					var chatArrowRightData:BitmapData=ClassInstance.getInstance("ChatArrowRight") as BitmapData;
					style.scale9L=14;
					style.scale9R=12;
					style.scale9T=10;
					style.scale9B=22;
					var chatArrowRightBitmap:Scale9Bitmap=getScale9Bitmap(chatArrowRightData,style);
					style.link=chatArrowRightBitmap;
					break;
				///背包仓库 背景图片 
				case GridsOpen:
					var bgIcon1Data:BitmapData=ClassInstance.getInstance("backpack_unlock_UI") as BitmapData;
					style.link=bgIcon1Data;
					break;
				case GridsLock:
					var bgIcon2Data:BitmapData=ClassInstance.getInstance("backpack_lockUI") as BitmapData;
					style.link=bgIcon2Data;
					break;
				case YFMoneyJinbi:///金币图标 用于背包
					var moneyJingbiData:BitmapData=ClassInstance.getInstance("moneyJingbi") as BitmapData;
					style.link=moneyJingbiData;
					break;
				case YFMoneyYuanbao:  ///元宝 用于 背包
					var moneyYuanbaoData:BitmapData=ClassInstance.getInstance("moneyYuanbao") as BitmapData;
					style.link=moneyYuanbaoData;
					break;
				case HpTips:
					var hpTips:BitmapData=ClassInstance.getInstance("hpTips") as BitmapData;
					style.link=hpTips;
					 break;
				case MoveArrow:  ///小地图 移动箭头图标
					///移动箭头  cursorUI 	
					var moveArrow:BitmapData=ClassInstance.getInstance("jiantou2") as BitmapData;
					style.link=moveArrow;
					break;	
				case SmallMapNPC: //小地图 npc 图标
					var smallPicNPC:BitmapData=ClassInstance.getInstance("smallMapNPCPic") as BitmapData;
					style.link=smallPicNPC;
					break;
				case SmallMapTeamPic:  ///小地图队友图标
					var smallMapTeamPic:BitmapData=ClassInstance.getInstance("teamPic") as BitmapData;
					style.link=smallMapTeamPic;
					break;
				case SmallMapExitPic: ///小地图  地图跳转点图标
					var exitPic:BitmapData=ClassInstance.getInstance("exitPic") as BitmapData;
					style.link=exitPic;
					break;
				case SmallMapMonsterPic:  ///怪物小图标
					var monsterPic:BitmapData=ClassInstance.getInstance("monsterPic") as BitmapData;
					style.link=monsterPic;
					break;
				case SmallMapMonsterZonePic: ///怪物区域 图标
					var monsterZonePic:BitmapData=ClassInstance.getInstance("monsterZonePic") as BitmapData;
					style.link=monsterZonePic;
					break;
				case SMallMapFlyBoot:  ///小飞鞋图标  在cursor文件夹里面
					var smallMapFlyFootData:BitmapData=ClassInstance.getInstance("flyBoot") as BitmapData;
					style.link=smallMapFlyFootData;
					break;
				case SkillFrame:
					///技能框
					var skillFrameData:BitmapData=ClassInstance.getInstance("skillFrame") as BitmapData;
					style.link=skillFrameData;
					break;
				///////////影片剪辑    mc 皮肤
				case CD:
					/// cd 动画 
					var cdMC:MovieClip=ClassInstance.getInstance("ItemCD") as MovieClip;
					style.link=cdMC;
					break;
				case ProgressBarSkin1:
					//// 进度条       角色血量槽
					var progressBarSkin1:MovieClip=ClassInstance.getInstance("progressBarSkin1") as MovieClip;
					style.link=progressBarSkin1;
					break;

			}
				
			
			return style;
		}
		
		
		private function getScale9Bitmap(skin:IBitmapDrawable,_skinStyle:YFStyle):Scale9Bitmap
		{
			if(skin==null) return null;
			return Scale9Bitmap.getInstance(skin ,_skinStyle.scale9T,_skinStyle.scale9B,_skinStyle.scale9L,_skinStyle.scale9R);
		}

		
		
	}
}