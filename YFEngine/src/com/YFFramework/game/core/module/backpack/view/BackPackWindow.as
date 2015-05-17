package com.YFFramework.game.core.module.backpack.view
{
	/**@author yefeng
	 *2012-8-11下午8:18:56
	 */
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.ui.abs.AbsUIView;
	import com.YFFramework.core.ui.abs.GameWindow;
	import com.YFFramework.core.ui.layer.LayerManager;
	import com.YFFramework.core.ui.yfComponent.controls.YFAlert;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFIConYuanbao;
	import com.YFFramework.core.ui.yfComponent.controls.YFIconJingbi;
	import com.YFFramework.core.ui.yfComponent.controls.YFLabel;
	import com.YFFramework.core.ui.yfComponent.controls.YFSimpleButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFTabMenu;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.lang.Lang;
	import com.YFFramework.game.core.global.manager.GoodsBasicManager;
	import com.YFFramework.game.core.global.manager.GoodsDyManager;
	import com.YFFramework.game.core.global.model.GoodsBasicVo;
	import com.YFFramework.game.core.global.model.GoodsDyVo;
	import com.YFFramework.game.core.global.model.GoodsUtil;
	import com.YFFramework.game.core.global.util.DragManager;
	import com.YFFramework.game.core.module.backpack.events.BackpackEvent;
	import com.YFFramework.game.core.module.backpack.model.BackPackUtil;
	import com.YFFramework.game.core.module.backpack.model.DeleteGoodsVo;
	import com.YFFramework.game.core.module.backpack.model.SimpleMoveGoodsResultVo;
	import com.YFFramework.game.core.module.backpack.model.SimpleMoveGoodsVo;
	import com.YFFramework.game.core.module.backpack.model.UseGoodsResultVo;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * yefeng 
	 * 背包窗口 
	 */	
	public class BackPackWindow extends GameWindow
	{
		/** 格子ui 
		 */		
		private var _gridsView:BackPackGridsView;
		/**
		 * tabMenu UI 
		 */	
		private var _tabMenu:YFTabMenu;
		private var _rongLiangLabel:YFLabel;
		/**向左翻页的按钮
		 */		
		private var _pageLeftBtn:YFSimpleButton;
		/** 向右翻页的按钮
		 */
		private var _pageRightBtn:YFSimpleButton;
		
		/** 当前页数 /总页数    总页数默认为4      1/4 
		 */
		private var _pageLabel:YFLabel;
		/** 金币  数字文本
		 */		
		private var _jingBiLabel:YFLabel;
		
		/**元宝文本
		 */
		private var _yuanBaolabel:YFLabel;
		
		/**寄售按钮
		 */
		private var _sellbtn:YFButton;
		/**整理 
		 */		
		private var _tidyBtn:YFButton;
		/**拆分 
		 */		
		private var _splitBtn:YFButton;
		/**丢弃
		 */		
		private var _abandonBtn:YFButton;
		/**物品图标容器
		 */		
		private var _goodsIconContainer:AbsUIView;
		
		/**上一次显示的类型
		 */
		private var _preShowTabIndex:int;
		/**当前要显示的页数
		 */		
		private var _currentpage:int;
		/**鼠标是否处于按下状态
		 */		
		private var _goodsIconMouseDown:Boolean;
		/**保存所有的物品UI
		 */		
		private var _goodsIconDict:Dictionary;
		
		/**物品图标相对于格子位置的偏移量   用于物品定位
		 */		
		private static const GoodsIconOffsetX:int=2;
		private static const GoodsIconOffsetY:int=2;
		/**显示全部
		 */		
		private static const TabAll:int=0;
		public function BackPackWindow()
		{
			super(300,380);
			
		}
		override protected function initUI():void
		{
			super.initUI();
			//  tab menu
			_tabMenu=new YFTabMenu(50,0,13);
			_tabMenu.addItem({name:Lang.QuanBu,index:TabAll},"name"); ///全部
	//		_tabMenu.addItem({name:Lang.YaoShui,index:GoodsUtil.Category_Medicine},"name");///药水
			_tabMenu.addItem({name:Lang.ZhuangBei,index:GoodsUtil.Big_Category_Equip},"name");//装备
			_tabMenu.addItem({name:Lang.BaoShi,index:GoodsUtil.Big_Category_Stone},"name");///宝石
			_tabMenu.addItem({name:Lang.QiTa,index:GoodsUtil.Big_Category_Goods},"name");//其他
			_tabMenu.setSelectIndex(0);
			addChild(_tabMenu);
			_tabMenu.x=15;
			_tabMenu.y=_bgTop.y+_bgTop.height+5;
			
			///grids 
			_gridsView=new BackPackGridsView();
			addChild(_gridsView);
			_gridsView.y=_tabMenu.y+_tabMenu.height+3;
			_gridsView.x=15;
			_gridsView.updateGrids();
			
			/// goodsIcon
			_goodsIconContainer=new AbsUIView();
			addChild(_goodsIconContainer);
			_goodsIconContainer.x=_gridsView.x;
			_goodsIconContainer.y=_gridsView.y;
			
			///下面的文字     包裹容量文字
			var  rongLiangText:YFLabel=new YFLabel(Lang.BaoGuoRongLiang+":");
			addChild(rongLiangText);
			rongLiangText.x=_tabMenu.x;
			rongLiangText.y=_gridsView.y+_gridsView.height+5;
			// 包裹容量的 数字 
			_rongLiangLabel=new YFLabel();
			addChild(_rongLiangLabel);
			_rongLiangLabel.x=rongLiangText.x+rongLiangText.textWidth+5;
			_rongLiangLabel.y=rongLiangText.y;
			_rongLiangLabel.text="0/56";
			
			///整理 按钮
			
			
			/// 上一页  下一页   切换 按钮
			_pageLeftBtn=new YFSimpleButton(16);
			_pageRightBtn=new YFSimpleButton(17);
			//页数文本
			_pageLabel=new YFLabel("1/"+BackPackUtil.MaxPage);
			_pageLabel.mouseChildren=_pageLabel.mouseEnabled=false;
			addChild(_pageLeftBtn);
			addChild(_pageRightBtn);
			addChild(_pageLabel);
			_pageRightBtn.x=_gridsView.x+_gridsView.width-_pageRightBtn.width;
			_pageLeftBtn.x=_pageRightBtn.x-_pageLeftBtn.width-25;
			_pageLabel.y=_pageLeftBtn.y=_pageRightBtn.y=_rongLiangLabel.y;
			_pageLabel.x=_pageLeftBtn.x+_pageLeftBtn.width;
			_pageLeftBtn.toolTip=Lang.ShangYiYe;
			_pageRightBtn.toolTip=Lang.XiaYiYe;
			
			////创建两个 钱币 图标
			var _moneyJingbi:YFIconJingbi=new YFIconJingbi();
			var _moneyYuanbao:YFIConYuanbao=new YFIConYuanbao();
			_moneyJingbi.toolTip=Lang.JingBi;
			_moneyYuanbao.toolTip=Lang.YuanBao;
			addChild(_moneyJingbi);
			addChild(_moneyYuanbao);
			_moneyJingbi.x=_gridsView.x;
			_moneyYuanbao.x=_gridsView.x+_gridsView.width-110;
			_moneyJingbi.y=_moneyYuanbao.y=_rongLiangLabel.y+_rongLiangLabel.height+10;
			
			_jingBiLabel=new YFLabel("0",4,12,0xFFFF00);
			_yuanBaolabel=new YFLabel("0",4,12,0xFFFF00);
			_jingBiLabel.width=80;
			_yuanBaolabel.width=80;
			addChild(_jingBiLabel);
			addChild(_yuanBaolabel);
			_jingBiLabel.x=_moneyJingbi.x+_moneyJingbi.width+5;
			_yuanBaolabel.x=_moneyYuanbao.x+_moneyYuanbao.width+5;
			_yuanBaolabel.y=_jingBiLabel.y=_moneyJingbi.y;
			
			///寄售 拆分 丢弃 整理
			_sellbtn=new YFButton(Lang.JiShou);
			_splitBtn=new YFButton(Lang.Chaifen);
			_abandonBtn=new YFButton(Lang.Diu_Qi);
			_tidyBtn=new YFButton(Lang.ZhengLi);
			addChild(_sellbtn);
			addChild(_tidyBtn);
			addChild(_splitBtn);
			addChild(_abandonBtn);
			_sellbtn.y=_splitBtn.y=_abandonBtn.y=_tidyBtn.y=_jingBiLabel.y+_jingBiLabel.height+10;
			var space:int=10;
			_sellbtn.x=_moneyJingbi.x+33;
			_splitBtn.x=_sellbtn.x+_sellbtn.width+space;
			_abandonBtn.x=_splitBtn.x+_splitBtn.width+space;
			_tidyBtn.x=_abandonBtn.width+_abandonBtn.x+space;
			
			setPageUIVisible(true);
			
			currentpage=1;
			
			_goodsIconDict=new Dictionary(); 

		//	_prePage=1;
		}
		/**事件侦听
		 */		
		override protected function addEvents():void
		{
			super.addEvents();
			/// tab 单击种类
			_tabMenu.addEventListener(YFControlEvent.Select,ontabSelectEvent);
			_pageLeftBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			_pageRightBtn.addEventListener(MouseEvent.CLICK,onMouseClick);
			StageProxy.Instance.mouseUp.regFunc(onGoodsIconMouseUp);///使用注册函数代替
			StageProxy.Instance.mouseDown.regFunc(onMouseDownEvent);///隐藏BackpackMenuList
			_goodsIconContainer.addEventListener(MouseEvent.MOUSE_DOWN,onGoodsIconMouseEvent);
			_goodsIconContainer.addEventListener(MouseEvent.MOUSE_MOVE,onGoodsIconMouseEvent);
			///监听 物品删除请求
			YFEventCenter.Instance.addEventListener(BackpackEvent.NoticeOtherViewDeleteGoodsVo,checkDeleteGoods);
		}  
		/**处理物品拖动 按下物品 物品上按下
		 */		
		private function onGoodsIconMouseEvent(e:MouseEvent):void
		{
			var target:BackpackGoodsIconView=e.target as BackpackGoodsIconView;
			if(target)
			{
				switch(e.type)
				{
					case MouseEvent.MOUSE_DOWN:
						_goodsIconMouseDown=true;
						break;
					case MouseEvent.MOUSE_MOVE:
						if(_goodsIconMouseDown&&_preShowTabIndex==TabAll)///当鼠标按下 并且 tab标签显示为 全部时才具备拖动物品条件
						{
							//当不存在拖动物品时开始拖动
							if(!DragManager.Instance.dragVo)		DragManager.Instance.startDragGoods(target);
						}
						break;
				}
			}
		}
		private function onMouseDownEvent():void
		{
			//  隐藏菜单栏
			BackpackMenuListView.Instance.hide();
		}
		/**释放鼠标  有可能是删除物品 或者是移动 物品或者交换物品
		 */		
		private function onGoodsIconMouseUp():void
		{
			_goodsIconMouseDown=false;
			
			///弹出的窗口数量
			var windowNum:int=LayerManager.WindowLayer.numChildren;
			//当有窗口弹出时
			if(windowNum>0)
			{
				//获取最上层的窗口 
				var  window:GameWindow=LayerManager.WindowLayer.getChildAt(windowNum-1) as GameWindow;
				if(window is BackPackWindow) ///当背包在最上层
				{
					if(DragManager.Instance.dragVo)  ///当物品在进行拖动
					{		
						if(DragManager.Instance.dragVo is GoodsDyVo)////当拖动的物品为背包的物品
						{
							if(DragManager.Instance.dragVo.position==GoodsUtil.Positon_Backpack)
							{
								///如果鼠标在背包窗口范围内
								if(_gridsView.containsPt(_goodsIconContainer.mouseX,_goodsIconContainer.mouseY))
								{
									///执行物品拖动
									//物品图标的 xy 坐标 
									var goodsIconX:int=_goodsIconContainer.mouseX;
									var goodsIconY:int=_goodsIconContainer.mouseY;
									var gridNum:int=BackPackUtil.getGridNum(goodsIconX,goodsIconY);
									gridNum +=BackPackUtil.PageGridsNum*(currentpage-1);
									noticeMoveBackpackGoods(DragManager.Instance.dragVo.dyId,gridNum);
								}
								else  ///执行物品删除 
								{
									var event:YFEvent=new YFEvent(BackpackEvent.NoticeOtherViewDeleteGoodsVo,DragManager.Instance.dragVo.dyId);
									checkDeleteGoods(event);
								}	
								
								DragManager.Instance.stopDrag();
								_goodsIconMouseDown=false;
							}
						}
					}
					
				}
			}
		}
		/**删除物品vo  执行物品删除
		 */		
		private function checkDeleteGoods(e:YFEvent=null):void
		{
			var dyId:String=e.param as String;
			YFAlert.show("确定删除物品?","提示:",2,deleteGoodsVoFunc,null,dyId);
		}
		/**
		 *删除物品
		 */		
		private function deleteGoodsVoFunc(dyId:String):void
		{
			noticeDeleteBackpackGoods(dyId);
		}
		/**通知服务端移动背包物品   dyId 移动的物品   toGridNum移动到的格子位置 
		 */		
		private function noticeMoveBackpackGoods(dyId:String,toGridNum:int):void
		{
			var goodsDyVo:GoodsDyVo=GoodsDyManager.Instance.getGoodsDyVo(dyId);
			if(goodsDyVo.gridNum!=toGridNum)  ///当格子数目发生变化时才发给服务端
			{
				var simpleMoveGoodsVo:SimpleMoveGoodsVo=new SimpleMoveGoodsVo();
				simpleMoveGoodsVo.movingDyId=dyId;
				simpleMoveGoodsVo.toGridNum=toGridNum;
		//		YFEventCenter.Instance.dispatchEvent(new YFEvent(BackpackEvent.C_SimpleMoveGoods,simpleMoveGoodsVo));
				YFEventCenter.Instance.dispatchEventWith(BackpackEvent.C_SimpleMoveGoods,simpleMoveGoodsVo);
			}
		}
		/** 通知服务端删除背包物品 
		 */		
		private function noticeDeleteBackpackGoods(dyId:String):void
		{
			var vo:DeleteGoodsVo=new DeleteGoodsVo();
			vo.dyId=dyId;
		//	YFEventCenter.Instance.dispatchEvent(new YFEvent(BackpackEvent.C_DeleteGoods,vo));
			YFEventCenter.Instance.dispatchEventWith(BackpackEvent.C_DeleteGoods,vo);
		}
		
		
		/**进行翻页
		 */		
		private function onMouseClick(e:MouseEvent):void
		{
			var list:Object;
			switch(e.currentTarget)
			{
				///向左翻页
				case _pageLeftBtn:
					currentpage--;
					if(_currentpage<=0)currentpage=1
					else 
					{
						list=getList(_preShowTabIndex)
						updateContent(list,currentpage);
					}
					break;
				///向右翻页
				case _pageRightBtn:
					currentpage++;
					if(currentpage>=BackPackUtil.MaxPage+1)currentpage=BackPackUtil.MaxPage;
					else 
					{
						list=getList(_preShowTabIndex);
						updateContent(list,currentpage);
					}

					break;
			}
		}
		
		/**设置当前页数
		 */		
		private function set currentpage(value:int):void
		{
			_currentpage=value;
			_pageLabel.text=_currentpage+"/"+BackPackUtil.MaxPage;
		}
		private function get currentpage ():int
		{
			return _currentpage;			
		}
		
		/**更新格子总数
		 */		
		public function updateGridsTotalNum():void
		{
			_gridsView.updateGrids(GoodsDyManager.Instance.backpackManager.size);
			
			_rongLiangLabel.text=GoodsDyManager.Instance.backpackManager.getGoodsNum()+"/"+GoodsDyManager.Instance.backpackManager.size;
		}
		
		/**更新物品使用  服务端返回消耗性物品的使用  具有CD 的消耗性物品
		 */		
		public function updateUseGoodsView(useGoodsResultVo:UseGoodsResultVo):void
		{
				var iconView:BackpackGoodsIconCDView=_goodsIconDict[useGoodsResultVo.dyId];
				
				var basicVo:GoodsBasicVo=GoodsDyManager.Instance.getGoodsBasicVo(iconView.goodsDyVo.dyId);
				var goodsList:Array=GoodsDyManager.Instance.backpackManager.getGoodsSmallCategoryList(basicVo.bigCategory,basicVo.smallCategory);
				var goodsView:BackpackGoodsIconCDView;
				///更新数据
				GoodsDyManager.Instance.updateGoodsNum(useGoodsResultVo.dyId,useGoodsResultVo.num);
				for each (var goodsDyVo:GoodsDyVo in goodsList)
				{
					goodsView=_goodsIconDict[goodsDyVo.dyId] as BackpackGoodsIconCDView;
					goodsView.updateGoodsNumView(goodsDyVo.num);
					goodsView.playCD();
					print(this,"装备部分可能不具备CD，待测试");
				}
				if(iconView.goodsDyVo.num<=0)
				{
					deleteGoodsIcon(iconView.goodsDyVo.dyId);
				}
				
		}
		
		/**设置翻页的ui的隐藏与现实
		 */
		private function setPageUIVisible(value:Boolean):void
		{
			_pageLeftBtn.visible=_pageRightBtn.visible=_pageLabel.visible=value;
		}
		/** _tabMenu
		 */		
		private function ontabSelectEvent(e:ParamEvent):void
		{
			 var data:Object=_tabMenu.getSelectData();
			 if(data.index==_preShowTabIndex)
			 {
				 return ;
			 }
			 _preShowTabIndex=data.index;
			 var list:Object=getList(_preShowTabIndex);
			 if(data.index==TabAll) ///当为全部时
			 {
				 setPageUIVisible(true);///显示左右翻页按钮
				 updateContent(list,currentpage);
			 }
			 else
			 {
				 setPageUIVisible(false);///隐藏左右翻页按钮
				// updateContent(list,1);///只显示第一页
				 updateContent2(list);//只显示第一页
			 }
		}
		
		/** 获得当前 tab 所需要的数据
		 * @param tabShowIndex
		 * 
		 */		
		private function getList(tabShowIndex:int):Object
		{
			var list:Object;
			switch(tabShowIndex)
			{
				case 0:
					///全部
					list=GoodsDyManager.Instance.backpackManager.getList();
					break;
				case GoodsUtil.Big_Category_Equip:
					///装备 
					list=GoodsDyManager.Instance.backpackManager.getGoodsList(GoodsUtil.Big_Category_Equip);
					break;
				case GoodsUtil.Big_Category_Goods:
					///其他
					list=GoodsDyManager.Instance.backpackManager.getGoodsList(GoodsUtil.Big_Category_Goods);
					break;
			}
			return list;

		}
		
		/**更新背包列表
		 */			
		public function updateGoodsList():void
		{
			var dict:Dictionary=GoodsDyManager.Instance.backpackManager.getList();
			_preShowTabIndex=0;//显示全部
			currentpage=1;
			updateContent(dict,currentpage);
			
		}
		
		/** 更新内容  主要是针对  全部 类型进行
		 * @param obj  物品vo数组 
		 * @param pageIndex  当前显示页数 
		 * 
		 */		
		private function updateContent(obj:Object,pageIndex:int=1):void
		{
			_goodsIconContainer.removeAllContent(true);
			var icon:BackpackGoodsIconView;
			var pt:Point;
			var goodsVoPage:int;///物品所在页
			
			

			for each (var goodsVo:GoodsDyVo in obj)
			{
				goodsVoPage=BackPackUtil.getPage(goodsVo.gridNum);
				if(pageIndex==goodsVoPage)
				{
					addGoodsIcon(goodsVo.dyId);
				}
			}
		}
		
		/**针对单一类型进行调用  除了全部  页面默认为1 
		 *  只是单纯的显示
		 * @param obj  物品数组
		 * @param pageIndex
		 */		
		private function updateContent2(obj:Object):void
		{
			_goodsIconContainer.removeAllContent(true);
			var icon:BackpackGoodsIconView;
			var pt:Point;
			var index:int=1;
			for each (var goodsVo:GoodsDyVo in obj)
			{
				icon=new BackpackGoodsIconView();
				icon.initGoodsDyVo(goodsVo.dyId);
				pt=BackPackUtil.getGridPosition(index);
				icon.x=pt.x+GoodsIconOffsetX;  ///图标 32*32大小 所以要加上2 
				icon.y=pt.y+GoodsIconOffsetY;
				_goodsIconContainer.addChild(icon);
				++index;
			}

		}
	
		
		
		/** 背包内物品发生简单移动 更新
		 */		
		public function updateSimpleGoodsMove(simpleMoveGoodsRsultVo:SimpleMoveGoodsResultVo):void
		{
			var movingIcon:BackpackGoodsIconView=_goodsIconDict[simpleMoveGoodsRsultVo.movingDyId]
			var pt:Point=BackPackUtil.getGridPosition(simpleMoveGoodsRsultVo.movingGridNum);
			movingIcon.x=pt.x+GoodsIconOffsetX;
			movingIcon.y=pt.y+GoodsIconOffsetY;
			if(simpleMoveGoodsRsultVo.toGridDyId) 
			{
				///物品位置改变
				var toGridIcon:BackpackGoodsIconView=_goodsIconDict[simpleMoveGoodsRsultVo.toGridDyId];
				pt=BackPackUtil.getGridPosition(simpleMoveGoodsRsultVo.toGridGridNum);
				toGridIcon.x=pt.x+GoodsIconOffsetX;
				toGridIcon.y=pt.y+GoodsIconOffsetY;
			}
		}
		
		/**更新物品删除
		 */		
		public function updateDeleteGoods(dyId:String):void
		{
			deleteGoodsIcon(dyId);
		}
		/**删除物品图标 
		 */		
		private function deleteGoodsIcon(dyId:String):void
		{
			var icon:BackpackGoodsIconView=_goodsIconDict[dyId];
			delete _goodsIconDict[dyId];
			_goodsIconContainer.removeChild(icon);
			icon.dispose();
		}

		/**添加物品
		 */		
		private function addGoodsIcon(dyId:String):void
		{

			var goodsVo:GoodsDyVo=GoodsDyManager.Instance.getGoodsDyVo(dyId);
			var pt:Point=BackPackUtil.getGridPosition(goodsVo.gridNum);
			var icon:BackpackGoodsIconView;
			if(GoodsBasicManager.Instance.isMedicine(goodsVo.basicId))
			{ ////当为药品等 消耗性道具时 具有CD
				icon=new BackpackGoodsIconCDView();
			}
			else 
			{
				icon=new BackpackGoodsIconView(); 
			}
			icon.initGoodsDyVo(goodsVo.dyId);
			_goodsIconContainer.addChild(icon);
			icon.x=pt.x+GoodsIconOffsetX;  ///图标 32*32大小 所以要加上2 
			icon.y=pt.y+GoodsIconOffsetY;
			_goodsIconDict[icon.goodsDyVo.dyId]=icon;
			
		}
		/**更新金币
		 */		
		public function updateGold():void
		{
			_jingBiLabel.text=DataCenter.Instance.roleSelfVo.gold.toString();
		}
		/**更新元宝
		 */		
		public function updateYuanBao():void
		{
			_yuanBaolabel.text=DataCenter.Instance.roleSelfVo.yuanBao.toString();
		}
		
		
		
	}
}