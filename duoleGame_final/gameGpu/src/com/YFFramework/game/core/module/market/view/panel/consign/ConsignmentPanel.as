package com.YFFramework.game.core.module.market.view.panel.consign
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.model.ItemDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.market.data.manager.MarketConfigBasicManager;
	import com.YFFramework.game.core.module.market.data.manager.MarketDyManager;
	import com.YFFramework.game.core.module.market.data.manager.MarketTypeConfigBasicManager;
	import com.YFFramework.game.core.module.market.data.vo.MarketConfigBasicVo;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.market.view.simpleView.ConsignItemsCollection;
	import com.YFFramework.game.core.module.market.view.simpleView.ConsignPurchaseItem;
	import com.YFFramework.game.core.module.market.view.window.ConsignItemWindow;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.ComboBox;
	import com.dolo.ui.controls.DoubleDeckTree;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.managers.UIManager;
	import com.dolo.ui.tools.TextInputUtil;
	import com.dolo.ui.tools.Xdis;
	import com.msg.market_pro.CSearchSaleList;
	import com.msg.market_pro.Condition;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/** 市场窗口——寄售面板
	 * @version 1.0.0
	 * creation time：2013-5-28 上午10:07:14
	 * 
	 */
	public class ConsignmentPanel extends EventDispatcher
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var _mc:MovieClip;
//		/**寄售物品窗口  */		
//		private var _consignItemWindow:ConsignItemWindow;
		
		protected var _tree:DoubleDeckTree;
		
		/**关键字下拉框（物品名字联想） */		
		private var _keyWordCombo:ComboBox;
		/**关键字联想  */		
		private var _keyWordTxt:TextField;
		/**关键字(+筛选)搜索按钮  */		
		private var _keyWordSearchBtn:SimpleButton;
		/**等级下拉框 （分三种：全部等级、1-29、30-49、50-69） */		
		private var _levelCombo:ComboBox;
		/** 单击出现等级下拉框 */		
		private var _levelBtn:SimpleButton;
		/** 品质筛选下拉框（分为：全部品质、普通、优秀、精良、史诗、传说、神器）  */		
		private var _qualityCombo:ComboBox;
		/** 单击出现品质下拉框 */		
		private var _qualityBtn:SimpleButton;
//		/** 金钱筛选下拉框（分为：全部货币、银币、魔钻） */		
//		private var _moneyCombo:ComboBox;
//		/**单击出现金钱下拉框  */		
//		private var _moneyBtn:SimpleButton;
		/**类别（+筛选）搜索按钮 */		
		private var _searchBtn:Button;
		/**重置按钮  */		
		private var _resetBtn:Button;
		/**金钱范围下限  */		
		private var _moneyMin:TextField;
		/**金钱范围上限 */		
		private var _moneyMax:TextField;
		
		/**首页  */		
		private var _firstPageBtn:Button;
		/**尾页  */		
		private var _lastPageBtn:Button;
		/**上一页  */		
		private var _upPageBtn:Button;
		/**下一页  */		
		private var _downPageBtn:Button;
		/**当前页/全部页  */		
		private var _curPageView:TextField;
		
		/**热卖按钮  */		
		private var _hotSaleBtn1:Button;
		private var _hotSaleBtn2:Button;
		private var _hotSaleBtn3:Button;
		private var _hotSaleBtn4:Button;
		private var _hotSaleBtn5:Button;
		private var _hotSaleBtn6:Button;
		private var _hotSaleBtn7:Button;
		private var _hotSaleBtn8:Button;
		private var _hotSaleBtns:Array;
		
		/**寄售按钮  */		
		private var _consignBtn:Button;
		/**我的寄售按钮  */		
		private var _myConsignBtn:Button;
		
		/**自定义变量  */		
		private var _curLevel:int;//当前筛选等级
		private var _curQuality:int;//当前筛选品质
//		private var _curMoney:int;//当前货币类型
		
		private var _curPage:int;
		private var _totalPage:int;
		
		private var _curSubType:int;//当前小类
		
		private var _items:ConsignItemsCollection;
//		private var _isCallServer:Boolean = false;
		
		//以下两个变量是为了实时输入文本框
		protected var _inputCheckLaterTime:int = 2000;
		protected var _inputCheckLaterTimeID:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ConsignmentPanel(mc:MovieClip)
		{
			_mc=mc.view;
//			_consignItemWindow=consignItemWin;
			
			//初始化分类树			
			_tree = Xdis.getChild(_mc,"all_tree");
			_tree.canTrunkSelect = true;
			_tree.addEventListener(UIEvent.TREE_TRUNK_CHANGE,onTreeTrunkChange);
			_tree.addEventListener(UIEvent.CHANGE,onSelectItem);
			
			var item:ListItem;
			var trunkAry:Array=MarketTypeConfigBasicManager.Instance.getAllClassicType();
			var nodesAry:Array;
			var len:int=trunkAry.length;
			
			for(var i:int=0;i<len;i++)
			{
				item=new ListItem();
				nodesAry=MarketTypeConfigBasicManager.Instance.getMarketTypeInfo(trunkAry[i]);
				item.label=nodesAry[0].classic_name;
				_tree.addTrunk(item);			
				for each(var node:Object in nodesAry)
				{
					item=new ListItem();
					item.label=node.subClass_name;
					item.subType=node.sub_classic_type;
					_tree.addNote(item,i);
				}
			}
			
			//初始化关键字搜索
			_keyWordCombo=Xdis.getChild(_mc,"search_comboBox");
			_keyWordCombo.rightSpace = 0;
			_keyWordCombo.setSize(_keyWordCombo.compoWidth,_keyWordCombo.compoHeight);
			_keyWordCombo.editable = true;
			_keyWordTxt = _keyWordCombo.inputTextField;
			
			TextInputUtil.initDefautText(_keyWordTxt,NoticeUtils.getStr(NoticeType.Notice_id_100036));
			
			_keyWordTxt.addEventListener(TextEvent.TEXT_INPUT,onInputChnage);
			_keyWordTxt.addEventListener(Event.CHANGE,onInputChnage);
			_keyWordTxt.addEventListener(FocusEvent.FOCUS_IN,onInputChnage);
			
			_keyWordSearchBtn=Xdis.getChild(_mc,"search1_btn");
			_keyWordSearchBtn.addEventListener(MouseEvent.CLICK,onKeyWordSearch);
			
			//初始化等级下拉框
			_levelCombo=Xdis.getChild(_mc,"level_comboBox");
			_levelCombo.rightSpace = 0;
			_levelCombo.setSize(_levelCombo.compoWidth,_levelCombo.compoHeight);
			_levelCombo.dropdown.addEventListener(Event.CHANGE,seleteLevel);//监听选择了什么
			var strAry:Array=MarketSource.getLevelNameAry();
			for each(var level:Object in strAry)
			{
				item=new ListItem();
				item.label=level.name;
				item.type=level.type;
				_levelCombo.addItem(item);
			}
			
			_levelBtn=Xdis.getChild(_mc,"level_btn");
			_levelCombo.addChild(_levelBtn);
			_levelBtn.addEventListener(MouseEvent.CLICK,popUpLevel);
			
			_levelBtn.x = _levelBtn.x - _levelCombo.x;
			_levelBtn.y = _levelBtn.y - _levelCombo.y;
			
			//初始化品质下拉框
			_qualityCombo=Xdis.getChild(_mc,"quality_comboBox");
			_qualityCombo.rightSpace=0;
			_qualityCombo.setSize(_qualityCombo.compoWidth,_qualityCombo.compoHeight);
			_qualityCombo.dropdown.addEventListener(Event.CHANGE,seleteQuality);
			strAry=MarketSource.getQualityNameAry();
			len=strAry.length;
			for(i=0;i<len;i++)
			{
				item=new ListItem();
				if(i > 0)
				{
					item.label=HTMLUtil.createHtmlText(strAry[i],12,TypeProps.getQualityColor(i));
				}
				else
					item.label=strAry[i];
				item.type=i;
				_qualityCombo.addItem(item);
			}
			
			_qualityBtn=Xdis.getChild(_mc,"quality_btn");
			_qualityCombo.addChild(_qualityBtn);
			_qualityBtn.addEventListener(MouseEvent.CLICK,popUpQuality);
			
			_qualityBtn.x = _qualityBtn.x - _qualityCombo.x;
			_qualityBtn.y = _qualityBtn.y - _qualityCombo.y;
			
			//初始化货币下拉框
//			_moneyCombo=Xdis.getChild(_mc,"money_comboBox");
//			_moneyCombo.rightSpace=0;
//			_moneyCombo.setSize(_moneyCombo.compoWidth,_moneyCombo.compoHeight);
//			_moneyCombo.dropdown.addEventListener(Event.CHANGE,seleteMoney);
			
//			strAry=MarketSource.getMoneyNameAry();
//			len=strAry.length;
//			for(i=0;i<len;i++)
//			{
//				item=new ListItem();
//				item.label=strAry[i];
//				if(i == 0)
//					item.type = MarketSource.MONEY_ALL;
//				else if(i == 1)
//					item.type = TypeProps.MONEY_SILVER;
//				else
//					item.type = TypeProps.MONEY_DIAMOND;
//				_moneyCombo.addItem(item);
//			}
			
//			_moneyBtn=Xdis.getChild(_mc,"money_btn");
//			_moneyCombo.addChild(_moneyBtn);
//			_moneyBtn.addEventListener(MouseEvent.CLICK,popUpMoney);
			
//			_moneyBtn.x = _moneyBtn.x - _moneyCombo.x;
//			_moneyBtn.y = _moneyBtn.y - _moneyCombo.y;
			
			_moneyMin=Xdis.getChild(_mc,"moneyMin");
			_moneyMin.restrict="0-9";
			_moneyMin.addEventListener(FocusEvent.FOCUS_OUT,onMoneyMinFocusOut);
			_moneyMin.addEventListener(Event.CHANGE,moneyMinInputChange);
			
			_moneyMax=Xdis.getChild(_mc,"moneyMax");
			_moneyMax.restrict="0-9";
			_moneyMax.addEventListener(FocusEvent.FOCUS_OUT,onMoneyMaxFocusOut);
			_moneyMax.addEventListener(Event.CHANGE,moneyMaxInputChange);
			
			//初始化翻页按钮
			_firstPageBtn=Xdis.getChild(_mc,"firstPage_button");
			_firstPageBtn.addEventListener(MouseEvent.CLICK,firstPage);
			
			_lastPageBtn=Xdis.getChild(_mc,"lastPage_button");
			_lastPageBtn.addEventListener(MouseEvent.CLICK,lastPage);
			
			_upPageBtn=Xdis.getChild(_mc,"prevPage_button");
			_upPageBtn.addEventListener(MouseEvent.CLICK,upPage);
			
			_downPageBtn=Xdis.getChild(_mc,"nextPage_button");
			_downPageBtn.addEventListener(MouseEvent.CLICK,downPage);
			
			_curPageView=Xdis.getChild(_mc,"curPage");
			
			//初始化热销按钮
			_hotSaleBtn1=Xdis.getChild(_mc,"hotSale1_button");
//			_hotSaleBtn1.label=MarketTypeConfigBasicManager.Instance.getHotSaleAry(1).subClass_name;
			
			_hotSaleBtn2=Xdis.getChild(_mc,"hotSale2_button");
//			_hotSaleBtn2.label=MarketTypeConfigBasicManager.Instance.getHotSaleAry(2).subClass_name;
			
			_hotSaleBtn3=Xdis.getChild(_mc,"hotSale3_button");
//			_hotSaleBtn3.label=MarketTypeConfigBasicManager.Instance.getHotSaleAry(3).subClass_name;
			
			_hotSaleBtn4=Xdis.getChild(_mc,"hotSale4_button");
//			_hotSaleBtn4.label=MarketTypeConfigBasicManager.Instance.getHotSaleAry(4).subClass_name;
			
			_hotSaleBtn5=Xdis.getChild(_mc,"hotSale5_button");
//			_hotSaleBtn5.label=MarketTypeConfigBasicManager.Instance.getHotSaleAry(5).subClass_name;
			
			_hotSaleBtn6=Xdis.getChild(_mc,"hotSale6_button");
//			_hotSaleBtn6.label=MarketTypeConfigBasicManager.Instance.getHotSaleAry(6).subClass_name;
			
			_hotSaleBtn7=Xdis.getChild(_mc,"hotSale7_button");
//			_hotSaleBtn7.label=MarketTypeConfigBasicManager.Instance.getHotSaleAry(7).subClass_name;
			
			_hotSaleBtn8=Xdis.getChild(_mc,"hotSale8_button");
//			_hotSaleBtn8.label=MarketTypeConfigBasicManager.Instance.getHotSaleAry(8).subClass_name;
			
			_hotSaleBtns=[,_hotSaleBtn1,_hotSaleBtn2,_hotSaleBtn3,_hotSaleBtn4,_hotSaleBtn5,_hotSaleBtn6,_hotSaleBtn7,_hotSaleBtn8];
			var hotsVo:Array=MarketTypeConfigBasicManager.Instance.getHotSaleAry();
			for(i=1;i<=8;i++)
			{
				_hotSaleBtns[i].label=hotsVo[i].subClass_name;
				_hotSaleBtns[i].addEventListener(MouseEvent.CLICK,onHotSaleClick);
				_hotSaleBtns[i].textField.y=4;
			}
			
//			_hotSaleBtn1.addEventListener(MouseEvent.CLICK,onHotSale1);
//			_hotSaleBtn2.addEventListener(MouseEvent.CLICK,onHotSale2);
//			_hotSaleBtn3.addEventListener(MouseEvent.CLICK,onHotSale3);
//			_hotSaleBtn4.addEventListener(MouseEvent.CLICK,onHotSale4);
//			_hotSaleBtn5.addEventListener(MouseEvent.CLICK,onHotSale5);
//			_hotSaleBtn6.addEventListener(MouseEvent.CLICK,onHotSale6);
//			_hotSaleBtn7.addEventListener(MouseEvent.CLICK,onHotSale7);
//			_hotSaleBtn8.addEventListener(MouseEvent.CLICK,onHotSale8);
			
//			_hotSaleBtn1.textField.y=4;
//			_hotSaleBtn2.textField.y=4;
//			_hotSaleBtn3.textField.y=4;
//			_hotSaleBtn4.textField.y=4;
//			_hotSaleBtn5.textField.y=4;
//			_hotSaleBtn6.textField.y=4;
//			_hotSaleBtn7.textField.y=4;
//			_hotSaleBtn8.textField.y=4;
			
			//普通搜索
			_searchBtn=Xdis.getChild(_mc,"search2_button");
			_searchBtn.addEventListener(MouseEvent.CLICK,searchClick);
			
			//重置按钮
			_resetBtn=Xdis.getChild(_mc,"reset_button");
			_resetBtn.addEventListener(MouseEvent.CLICK,onReset);
			
			//寄售按钮
			_consignBtn=Xdis.getChild(_mc,"action_button");
			_consignBtn.label='寄售';
			_consignBtn.addEventListener(MouseEvent.CLICK,onConsign);
			
			_myConsignBtn=Xdis.getChild(_mc,"my_button");
			_myConsignBtn.label='我的寄售';
			_myConsignBtn.addEventListener(MouseEvent.CLICK,onMyConsign);		
			
			_items=new ConsignItemsCollection(Xdis.getChild(_mc,"items"),ConsignPurchaseItem);
			
			resetPanel();
		}
		
		//======================================================================
		//        public function
		//======================================================================		
		public function resetPanel():void
		{
//			_isCallServer = false;
			
			_levelCombo.selectedIndex=0;//默认显示“全部等级”
			_qualityCombo.selectedIndex=0;//默认显示“全部等级”
//			_moneyCombo.selectedIndex=0;//默认显示“全部货币 ”
			
			_curLevel=MarketSource.LEVEL_ALL;
			_curQuality=MarketSource.QUALITY_ALL;
//			_curMoney=MarketSource.MONEY_ALL;
			_curSubType=0;
			
			_moneyMin.text='';
			_moneyMax.text='';
			_keyWordTxt.text='';
			TextInputUtil.initDefautText(_keyWordTxt,NoticeUtils.getStr(NoticeType.Notice_id_100036));		
			
			//把树折回去
			for(var i:int=0;i<_tree.trunkLength;i++)
			{
				_tree.openTrunk(i,false,false);
			}		
			_tree.clearSelection(false);
					
			updatePageNumView();
			checkPageBtn();
			
//			_isCallServer = true;
			
		}
		
		public function searchToServer(item:Object=null):void
		{		
			var msg:CSearchSaleList =new CSearchSaleList();
			msg.cond=new Condition();
			
			if(_curPage == 0)//如果刚好上次搜索没有结果，会把_curPage设为0，这个时候再搜索就要重置了
			{
				_curPage=1;
			}
			msg.page=_curPage;
			
			if(_curLevel > MarketSource.LEVEL_ALL)
				msg.cond.level=_curLevel;
			if(_curQuality != MarketSource.QUALITY_ALL)
				msg.cond.quality=_curQuality;
			
//			if(_curMoney != MarketSource.MONEY_ALL)
//			{
//				msg.cond.moneyType=_curMoney;
//			}
			
			if(_moneyMax.text.length > 0)
			{
				msg.cond.maxMoney=int(_moneyMax.text);
			}
			if(_moneyMin.text.length > 0)
			{
				msg.cond.minMoney=int(_moneyMin.text);
			}		
			if(item != null)
			{
				msg.cond.itemType=item.type;
				msg.cond.itemId=item.id;
			}
			
			if(_curSubType > 0)
			{
				msg.cond.subClassicType=_curSubType;
				
				//当搜索子类型是魔钻或银币时，单击的筛选条件不能同是魔钻或银币
//				if(_curMoney == TypeProps.MONEY_DIAMOND)
//				{
//					if(_curSubType == MarketSource.SUB_CLASS_DIAMOND)
//					{
//						_items.disposeConsignPurchase();
//						return;
//					}
//				}
//				else if(_curMoney == TypeProps.MONEY_SILVER)
//				{
//					if(_curSubType == MarketSource.SUB_CLASS_SILVER)
//					{
//						_items.disposeConsignPurchase();
//						return;
//					}
//				}
			}
			
			YFEventCenter.Instance.dispatchEventWith(MarketEvent.CSearchSaleList,msg);
			
		}
		
		public function searchResp(totalPage:int):void
		{		
			clearPanel();
			_totalPage=totalPage;
			if(totalPage > 0)//有记录
			{				
				_items.initConsignPurchaseData(MarketSource.CONSIGH);
			}	
			
			if(_curPage > _totalPage || _totalPage == 1)//如果请求的这页不存在，重置当前页数;
				_curPage = _totalPage;
			
			checkPageBtn();
			updatePageNumView();
		}

		//======================================================================
		//        private function
		//======================================================================
		/** 
		 * 检查所有翻页按钮是否可用
		 */		
		private function checkPageBtn():void
		{
			if(_curPage < _totalPage && _curPage > 1)
			{
				_upPageBtn.enabled=true;
				_downPageBtn.enabled=true;
				
				_lastPageBtn.enabled=true;			
				_firstPageBtn.enabled=true;
			}
			else if(_curPage == _totalPage && _totalPage > 1)//翻到末页
			{
				_upPageBtn.enabled=true;
				_firstPageBtn.enabled=true;
				
				_downPageBtn.enabled=false;
				_lastPageBtn.enabled=false;		
				
			}
			else if(_curPage == _totalPage && _totalPage == 1)//只有唯一的一页
			{
				_upPageBtn.enabled=false;
				_firstPageBtn.enabled=false;
				
				_downPageBtn.enabled=false;
				_lastPageBtn.enabled=false;
			}
			else if(_curPage == 1 && _totalPage > 1)//在首页
			{			
				_downPageBtn.enabled=true;				
				_lastPageBtn.enabled=true;
				
				_firstPageBtn.enabled=false;
				_upPageBtn.enabled=false;
			}
			else if(_curPage == 0 && _totalPage == 0)//没有搜索结果
			{
				_upPageBtn.enabled=false;
				_downPageBtn.enabled=false;
				
				_lastPageBtn.enabled=false;	
				_firstPageBtn.enabled=false;
			}
		}
		
		/** 
		 * 只更新页数显示
		 */		
		private function updatePageNumView():void
		{
			_curPageView.text=_curPage.toString()+'/'+_totalPage.toString();
		}	
		
		
		
		/** 
		 * 清除当前界面的数据，也不显示“没有搜索结果”、“表头”
		 */		
		private function clearPanel():void
		{
			_items.disposeConsignPurchase();
		}
		//======================================================================
		//        event handler
		//======================================================================		
		/**
		 * 树干改变调用的函数 ,并且默认选择第一个子类
		 * @param event
		 * 
		 */			
		protected function onTreeTrunkChange(event:Event):void
		{
			var index:int = _tree.selectedTrunkIndex;
			if(_tree.isTrunkOpen(index)==true)
			{
				_tree.selectedTrunkIndex = index;
				_tree.selectedIndex = 0;
			}
			
		}
		
		//选择子类
		private function onSelectItem(e:Event=null):void
		{
//			if(_isCallServer == false) return;
			if(_tree.selectedItem)
			{
				_curSubType=_tree.selectedItem.subType;
				
				//查银币和魔钻的时候，等级和品质要变成全部
//				if(_curSubType == MarketSource.SUB_CLASS_DIAMOND || _curSubType == MarketSource.SUB_CLASS_SILVER)
//				{
//					_levelCombo.selectedIndex=0;//默认显示“全部等级”
//					_qualityCombo.selectedIndex=0;//默认显示“全部等级”
//					
//					_curLevel=MarketSource.LEVEL_ALL;
//					_curQuality=MarketSource.QUALITY_ALL;
//				}
				
				searchToServer();
			}
			
		}
		
		//实时根据输入的字段更新下拉框 	
		private function onInputChnage(e:Event):void
		{
			if(_keyWordTxt.text != '' && _keyWordTxt.text != NoticeUtils.getStr(NoticeType.Notice_id_100036))
			{
				var item:ListItem;
				_keyWordCombo.rowCount = 15;
				_keyWordCombo.removeAll();
				
				var itemAry:Array=MarketConfigBasicManager.Instance.getAllItemContainsNameStr(_keyWordTxt.text);
				for each(var vo:MarketConfigBasicVo in itemAry)
				{
					item = new ListItem();
					
					item.type=vo.item_type;
					item.id=vo.item_id;
					
					if(vo.item_type == TypeProps.ITEM_TYPE_EQUIP)
					{
						item.label=EquipBasicManager.Instance.getEquipBasicVo(vo.item_id).name;
					}
					else
					{
						item.label=PropsBasicManager.Instance.getPropsBasicVo(vo.item_id).name;
					}
					
					item.subType=vo.sub_classic_type;
//					item.classicType=vo.classic_type;
					
					_keyWordCombo.addItem(item);
				}
				_keyWordCombo.popList();
			}		
			
		}
		
		private function onKeyWordSearch(e:MouseEvent):void
		{
			var item:Object=_keyWordCombo.selectedItem;
			if(item)
			{
				_curSubType=item.subType;				
				searchToServer(item);
			}
			else
			{
				if(_keyWordTxt.text != NoticeUtils.getStr(NoticeType.Notice_id_100036) && MarketConfigBasicManager.Instance.getItemEqualName(_keyWordTxt.text))
				{
					_curSubType=item.subType;
					var vo:MarketConfigBasicVo=MarketConfigBasicManager.Instance.getItemEqualName(_keyWordTxt.text);
					item=new Object();
					item.type=vo.item_type;
					item.id=vo.item_id;
					searchToServer(item);
				}
				else
				{
					_items.disposeConsignPurchase();
				}
			}
			
		}
		
		//弹出选择等级的下拉框
		private function popUpLevel(e:MouseEvent):void
		{
			_levelCombo.popList();
		}
		
		//弹出选择品质下拉框		
		private function popUpQuality(e:MouseEvent):void
		{
			_qualityCombo.popList();
		}
		
		//弹出货币类型下拉框
//		private function popUpMoney(e:MouseEvent):void
//		{
//			_moneyCombo.popList();
//		}
		
		private function moneyMinInputChange(e:Event):void
		{
			if(_inputCheckLaterTime > 0){
				clearTimeout(_inputCheckLaterTimeID);
				_inputCheckLaterTimeID = setTimeout(onMoneyMinFocusOut,_inputCheckLaterTime);
			}else{
				onMoneyMinFocusOut();
			}
		}
		
		private function moneyMaxInputChange(e:Event):void
		{
			if(_inputCheckLaterTime > 0){
				clearTimeout(_inputCheckLaterTimeID);
				_inputCheckLaterTimeID = setTimeout(onMoneyMaxFocusOut,_inputCheckLaterTime);
			}else{
				onMoneyMaxFocusOut();
			}
		}
		
		//金钱的最大最小值，只能是0或大于1的数
		private function onMoneyMinFocusOut(e:FocusEvent=null):void
		{
			if(_moneyMin.text.length > 0)
			{
				if(int(_moneyMin.text) == 0)
				{
					_moneyMin.text='1';
				}
				else if(_moneyMax.text != '')
				{
					if(int(_moneyMin.text) > int(_moneyMax.text))
					{
						_moneyMin.text=_moneyMax.text;
					}
				}			
			}
				
		}
		
		//金钱的最大最小值，只能是0或大于1的数
		public function onMoneyMaxFocusOut(e:FocusEvent=null):void
		{
			if(_moneyMax.text != "")//最大值可以为空，不能为0
			{
				if(int(_moneyMax.text) ==0)
				{
					_moneyMax.text="1";
				}
				else if(int(_moneyMax.text) < int(_moneyMin.text))
				{
					_moneyMax.text=_moneyMin.text;
				}
			}
			else if(int(_moneyMax.text) == 1)
			{
				_moneyMin.text='1';
			}
		}
		
		//筛选等级	
		private function seleteLevel(e:Event):void
		{
			_curLevel=_levelCombo.selectedItem.type;
		}
		
		//筛选品质
		private function seleteQuality(e:Event):void
		{
			_curQuality=_qualityCombo.selectedItem.type;
		}
		
		//筛选货币类型
//		private function seleteMoney(e:Event):void
//		{
//			_curMoney=_moneyCombo.selectedItem.type;
//		}
		
		private function firstPage(e:MouseEvent):void
		{
			_curPage=1;
			searchToServer();
		}
		
		private function lastPage(e:MouseEvent):void
		{
			_curPage=_totalPage;
			searchToServer();
		}
		
		private function upPage(e:MouseEvent):void
		{
			_curPage--;
			searchToServer();
		}
		
		private function downPage(e:MouseEvent):void
		{
			_curPage++;
			searchToServer();
		}
		
		private function onHotSaleClick(e:MouseEvent):void
		{
			var hotAry:Array=MarketTypeConfigBasicManager.Instance.getHotSaleAry();
			var subType:int;
			switch(e.currentTarget)
			{
				case _hotSaleBtn1:
					subType=hotAry[1].sub_classic_type;
					break;
				case _hotSaleBtn2:
					subType=hotAry[2].sub_classic_type;
					break;
				case _hotSaleBtn3:
					subType=hotAry[3].sub_classic_type;
					break;
				case _hotSaleBtn4:
					subType=hotAry[4].sub_classic_type;
					break;
				case _hotSaleBtn5:
					subType=hotAry[5].sub_classic_type;
					break;
				case _hotSaleBtn6:
					subType=hotAry[6].sub_classic_type;
					break;
				case _hotSaleBtn7:
					subType=hotAry[7].sub_classic_type;
					break;
				case _hotSaleBtn8:
					subType=hotAry[8].sub_classic_type;
					break;
			}
			var ary:Array=_tree.findDataIndex(subType,"subType");
			hotSaleContrl(ary);
		}
		
		/**
		 * 热卖键控制 
		 * @param ary-两个值，哪个树干下的那个树枝
		 */		
		private function hotSaleContrl(ary:Array):void
		{
			if(ary[0] != -1 && ary[1] != -1)
			{
				_tree.openTrunk(ary[0],true,false);
				_tree.selectedTrunkIndex=ary[0];
				_tree.selectedIndex=ary[1];
			}
		}
		
		/** 这个方法是选择分类后做的查询 */
		private function searchClick(e:MouseEvent):void
		{
			searchToServer();
		}
		
		private function onReset(e:MouseEvent):void
		{
			resetPanel();
		}
		
		private function onConsign(e:MouseEvent):void
		{
			UIManager.switchOpenClose(ConsignItemWindow.instance);
			if(ConsignItemWindow.instance.isOpen)
				ConsignItemWindow.instance.openPanel(1);
		}
		
		private function onMyConsign(e:MouseEvent):void
		{
			if(ConsignItemWindow.instance.isOpen == false)
			{
				ConsignItemWindow.instance.isOpenUseTween = false;
				ConsignItemWindow.instance.open();
				ConsignItemWindow.instance.openPanel(3);
			}
			else
			{
				if(ConsignItemWindow.instance.getTabIndex() != 3)
				{
					ConsignItemWindow.instance.openPanel(3);					
				}
				else
					ConsignItemWindow.instance.close();
			}
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 