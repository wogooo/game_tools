package com.YFFramework.game.core.module.market.view.window
{
	/**
	 * 筛选物品
	 * @version 1.0.0
	 * creation time：2013-6-1 下午5:38:03
	 * 
	 */
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.DyModuleUIManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.window.WindowTittleName;
	import com.YFFramework.game.core.module.market.data.manager.MarketConfigBasicManager;
	import com.YFFramework.game.core.module.market.data.manager.MarketTypeConfigBasicManager;
	import com.YFFramework.game.core.module.market.data.vo.MarketConfigBasicVo;
	import com.YFFramework.game.core.module.market.event.MarketEvent;
	import com.YFFramework.game.core.module.market.source.MarketSource;
	import com.YFFramework.game.core.module.market.view.simpleView.ConsignItemsCollection;
	import com.YFFramework.game.core.module.market.view.simpleView.ItemIcon;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.dolo.common.ObjectPool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.ComboBox;
	import com.dolo.ui.controls.DoubleDeckTree;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.tools.TextInputUtil;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	public class SiftItemWindow extends Window
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private const NO_SEARCH_SUBTYPE:int=-1;
		
		private var _mc:Sprite;
		/**图标集合  */		
		private var _items:ConsignItemsCollection;
		
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
		/**类别（+筛选）搜索按钮 */		
		private var _searchBtn:Button;
		/**重置按钮  */		
		private var _resetBtn:Button;
		
		private var _curPage:int;
		private var _totalPage:int;

		private var _curSubType:int;//当前小类
		
		private var _curLevel:int;//当前筛选等级
		private var _curQuality:int;//当前筛选品质
		
//		private var _purchaseItemWindow:PurchaseItemWindow;
		private static var _instance:SiftItemWindow;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function SiftItemWindow()
		{
//			_purchaseItemWindow=purWindow;
			_closeButton.removeEventListener(MouseEvent.CLICK,close);
			_closeButton.addEventListener(MouseEvent.CLICK,closeTwoWindow);
			
			_mc=initByArgument(505,378,"siftItemWindow",WindowTittleName.siftTitle);
			setContentXY(22,42);
			
			//初始化图标群
			_items=new ConsignItemsCollection(Xdis.getChild(_mc,"pageList"),ItemIcon);
			
			//初始化分类
			_tree = Xdis.getChild(_mc,"all_tree");
			_tree.canTrunkSelect = true;
			_tree.addEventListener(UIEvent.TREE_TRUNK_CHANGE,onTreeTrunkChange);//选择树干
			_tree.addEventListener(Event.CHANGE,onSelectItem);//选择树枝
			
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
//			_keyWordCombo.dropdown.addEventListener(Event.CHANGE,selectKeyWord);
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
			
			//普通搜索
			_searchBtn=Xdis.getChild(_mc,"search2_button");
			_searchBtn.addEventListener(MouseEvent.CLICK,searchClick);
			
			//重置按钮
			_resetBtn=Xdis.getChild(_mc,"reset_button");
			_resetBtn.addEventListener(MouseEvent.CLICK,onReset);			
			
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function resetPanel():void
		{		
			_levelCombo.selectedIndex=0;//默认显示“全部等级”
			_qualityCombo.selectedIndex=0;//默认显示“全部等级”
			
			_curLevel=MarketSource.LEVEL_ALL;
			_curQuality=MarketSource.QUALITY_ALL;
			
			_keyWordTxt.text='';
			TextInputUtil.initDefautText(_keyWordTxt,NoticeUtils.getStr(NoticeType.Notice_id_100036));		
			
			//把树折回去,并打开第一个树干、选择第一个树枝 
			for(var i:int=0;i<_tree.trunkLength;i++)
			{
				_tree.openTrunk(i,false);
			}
			_tree.clearSelection(false)
				
			_curPage=0;
			_totalPage=0;
			_curSubType=NO_SEARCH_SUBTYPE;
			checkPageBtn();
			updatePageNumView();
				
			initPageView(0,0);
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
			else if(_curPage == 1)//在首页
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
		 * 1.初始化collection里的图标,并显示第一页
		 * 2.计算页数，为当前页数和总页数赋值
		 */		
		private function initPageView(itemType:int=0,itemId:int=0):void
		{	
			_items.disposeIcons();
			
			var itemNum:int=0;
			
			if(itemType == 0 && itemId == 0 && _curSubType > 0)//只找子类及筛选
			{
				_items.initIconsData(_curSubType);
				itemNum=MarketConfigBasicManager.Instance.getSubTypeAry(_curSubType,_curLevel,_curQuality).length;//这里有可能为0
			}
			else if(itemType > 0 && itemId > 0)
			{
				_items.initIconsData(NO_SEARCH_SUBTYPE,itemType,itemId);
				itemNum=1;
			}
			else
			{
				noResult();
			}
			
			if(itemNum > 0)
			{	
				_curPage=1;
				if((itemNum % MarketSource.PAGE_NUM) > 0)
				{
					_totalPage = int(itemNum / MarketSource.PAGE_NUM) + 1;
				}
				else
				{
					_totalPage = itemNum / MarketSource.PAGE_NUM;
				}
				_items.flushIconsPage(0,MarketSource.PAGE_NUM);
			}
			else
			{
				noResult();
			}
			
			checkPageBtn();
			
			updatePageNumView();
		}
		
		/** 
		 * 只更新页数显示
		 */		
		private function updatePageNumView():void
		{
			_curPageView.text=_curPage.toString()+'/'+_totalPage.toString();
		}
		
		private function noResult():void
		{
			_curPage=0;
			_totalPage=0;
			_items.initIconsData(NO_SEARCH_SUBTYPE,0,0);
		}
		//======================================================================
		//        event handler
		//======================================================================
		/**
		 * 和purchaseItemWindow同时调用这个方法 
		 * @param event
		 * 
		 */		
		private function closeTwoWindow(event:Event):void
		{
			this.close();
			resetPanel();
			PurchaseItemWindow.instance.close();
		}
		
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
				
				_curSubType=_tree.selectedItem.subType;
		
				onSelectItem();
			}
			
		}
		
		//选择子类
		private function onSelectItem(e:Event=null):void
		{
//			if(_isReset) return;
			if(_tree.selectedItem)
			{
				_curSubType=_tree.selectedItem.subType;				
				initPageView();
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
					
					_keyWordCombo.addItem(item);
				}
				_keyWordCombo.popList();
			}		
			
		}
		
		private function onKeyWordSearch(e:MouseEvent):void
		{
			var item:Object=_keyWordCombo.selectedItem;
			_curSubType=NO_SEARCH_SUBTYPE;
			if(item)
			{				
				initPageView(item.type,item.id);
			}
			else
			{
				if(MarketConfigBasicManager.Instance.getItemEqualName(_keyWordTxt.text))
				{
					var vo:MarketConfigBasicVo=MarketConfigBasicManager.Instance.getItemEqualName(_keyWordTxt.text);
					initPageView(vo.item_type,vo.item_id);
				}
				else
				{
					noResult();
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
		
		private function firstPage(e:MouseEvent):void
		{
			_curPage=1;
			_items.flushIconsPage((_curPage-1)*MarketSource.PAGE_NUM,_curPage*MarketSource.PAGE_NUM);
			checkPageBtn();
			updatePageNumView();
		}
		
		private function lastPage(e:MouseEvent):void
		{
			_curPage=_totalPage;
			_items.flushIconsPage((_curPage-1)*MarketSource.PAGE_NUM,_curPage*MarketSource.PAGE_NUM);
			checkPageBtn();
			updatePageNumView();
		}
		
		//向上翻页
		private function upPage(e:MouseEvent):void
		{
			_curPage -- ;
			_items.flushIconsPage((_curPage-1)*MarketSource.PAGE_NUM,_curPage*MarketSource.PAGE_NUM);
			checkPageBtn();
			updatePageNumView();
		}
		
		//向下翻页
		private function downPage(e:MouseEvent):void
		{
			_curPage ++;
			_items.flushIconsPage((_curPage-1)*MarketSource.PAGE_NUM,_curPage*MarketSource.PAGE_NUM);
			checkPageBtn();
			updatePageNumView();
		}
		
		private function searchClick(e:MouseEvent):void
		{
			initPageView(0,0);
		}
		
		private function onReset(e:MouseEvent):void
		{
			resetPanel();
		}

		public static function get instance():SiftItemWindow
		{
			if(_instance == null) _instance=new SiftItemWindow();
			return _instance;
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 