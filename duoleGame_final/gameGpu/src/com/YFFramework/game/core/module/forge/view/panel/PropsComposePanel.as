package com.YFFramework.game.core.module.forge.view.panel
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.event.GlobalEvent;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.PropsBasicVo;
	import com.YFFramework.game.core.global.model.PropsDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.forge.data.MergeGemBasicManager;
	import com.YFFramework.game.core.module.forge.data.MergeGemBasicVo;
	import com.YFFramework.game.core.module.forge.events.ForgeEvents;
	import com.YFFramework.game.core.module.forge.view.simpleView.ComposeItemRender;
	import com.YFFramework.game.core.module.forge.view.simpleView.PropsComposeIcon;
	import com.YFFramework.game.core.module.notice.manager.NoticeManager;
	import com.YFFramework.game.core.module.notice.model.NoticeType;
	import com.YFFramework.game.core.module.notice.model.NoticeUtils;
	import com.dolo.common.XFind;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.TileList;
	import com.dolo.ui.managers.TabsManager;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	/**
	 * 宝石合成：只有背包的宝石可以合成
	 * @version 1.0.0
	 * creation time：2013-7-1 下午1:25:25
	 * 
	 */
	public class PropsComposePanel
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private var HOLE_MAX:int = 5;
		private var _ui:Sprite;
		
		private var _itemsList:TileList;
		private var _featherList:TileList;
			
		private var _successRate:TextField;
		private var _combineBtn:Button;
		private var _allConbineBtn:Button;
		private var _money:TextField;		
		private var _update:Boolean;
		private var _tabs:TabsManager;
		
		private var _iconAry:Vector.<PropsComposeIcon>;
		private var _selectedPropsNum:int=0;
		private var _curMergeVo:MergeGemBasicVo;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function PropsComposePanel(targetUI:Sprite)
		{
			_ui = targetUI;
			
			AutoBuild.replaceAll(_ui);
			
			_itemsList = Xdis.getChild(_ui,"equipView1","equipsBox_tileList");
			_itemsList.itemRender = ComposeItemRender;
			_itemsList.addEventListener(Event.CHANGE,onSelectProps);
			
			var icon:PropsComposeIcon;
			_iconAry=new Vector.<PropsComposeIcon>();			
			for(var i:int=0;i<HOLE_MAX;i++)
			{
				icon=new PropsComposeIcon(i,Xdis.getChild(_ui,"gem"+(i+1),"icon_iconImage"),Xdis.getChild(_ui,"lock"+(i+1)));
				_iconAry.push(icon);
			}
			
			_successRate=Xdis.getChild(_ui,"succRate");
			_successRate.selectable=false;
			_successRate.text='';
			
			_combineBtn=Xdis.getChild(_ui,"combine_button");
			_combineBtn.addEventListener(MouseEvent.CLICK,onCombineClick);
			
			_allConbineBtn=Xdis.getChild(_ui,'allCombine_button')
			_allConbineBtn.addEventListener(MouseEvent.CLICK,onAllCombineClick);
			_allConbineBtn.enabled=false;
			
			_money=Xdis.getChild(_ui,'money');
			_money.selectable=false;
			_money.text='';
			
//			_curPropsAry=[];
//			_curMateralInfo=new Object();
			
			YFEventCenter.Instance.addEventListener(GlobalEvent.BagChange,updateBag);
			YFEventCenter.Instance.addEventListener(ForgeEvents.ClearPropsIcon,onClearIcon);
			
			resetPanel();
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public function initPanel(update:Boolean):void
		{
			_update=update;	
			if(_update)
			{
				updatePropsList();
				updateMoney();
			}
		}
		
		public function resetPanel():void
		{
			clearPanel();
			_update=false;
		}
		
		public function composeGemRsp():void
		{
			updatePropsList();
			clearPanel();
			checkComposeBtn();
		}
		
		public function updateMoney():void
		{
			if(_iconAry[0].bsVo)
			{
				var needMoney:int=MergeGemBasicManager.Instance.getBasicVoByMaterialId(_iconAry[0].bsVo.template_id).money;
				if(DataCenter.Instance.roleSelfVo.note >= needMoney)
				{
					_money.text=NoticeUtils.getStr(NoticeType.Notice_id_100060) + needMoney + 
						NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_NOTE);
				}
				else//钱不够，要显示红色
				{
					_money.htmlText=HTMLUtil.setFont(NoticeUtils.getStr(NoticeType.Notice_id_100060) + needMoney + 
						NoticeUtils.getMoneyTypeStr(TypeProps.MONEY_NOTE));
				}
			}
			else
				_money.text='';
		}
		//======================================================================
		//        private function
		//======================================================================
		private function clearPanel():void
		{
			clearAllIcons();
			checkComposeBtn();
			updateMoney();
			_successRate.text='0%';
			_selectedPropsNum=0;
			_curMergeVo=null;
		}
		
		/** 
		 * 更新道具列表
		 */		
		private function updatePropsList():void
		{
			var bags:Array=BagStoreManager.instantce.getAllPropsFromBag();
			var propsDict:Dictionary=new Dictionary();
			var boundAry:Array;
			var propsBsVo:PropsBasicVo;
			var idStr:String;
			var propsNum:int;
			var item:Object;
			for each(var propsDyVo:PropsDyVo in bags)
			{
				if(MergeGemBasicManager.Instance.getBasicVoByMaterialId(propsDyVo.templateId))//先判断这个道具在不在配置表里
				{
					propsNum=PropsDyManager.instance.getBoundPropsQuantity(propsDyVo.templateId,propsDyVo.binding_type);
					if(propsNum>1)
					{
						propsBsVo=PropsBasicManager.Instance.getPropsBasicVo(propsDyVo.templateId);
						idStr=propsDyVo.templateId.toString()+propsDyVo.binding_type.toString();//键值是模板id+绑定性
						item={info:propsBsVo,num:propsNum}
						propsDict[idStr]=item;
					}					
				}
			}
			
			var propsAry:Array=[];
			for(var i:String in propsDict)
			{
				propsAry.push(Number(i));
			}
			propsAry.sort();
			
			_itemsList.removeAll();			
			var len:int=propsAry.length;
			for(var j:int=0;j<len;j++)//如果这里用for each遍历，得到的j会是个负数
			{
				item=new Object();
				idStr=String(propsAry[j]);
				item.vo=Object(propsDict[idStr]).info;//静态vo
				item.num=Object(propsDict[idStr]).num;
				item.bound=idStr.slice(idStr.length-1,idStr.length);			
				_itemsList.addItem(item);
			}
		}

		/**
		 * 检查道具是否用完，true就是用完了
		 * @param vo
		 * @return 
		 */		
		private function checkGemNone(vo:PropsBasicVo,bound:int):Boolean
		{
			var num:int=PropsDyManager.instance.getBoundPropsQuantity(vo.template_id,bound);//某种绑定或不绑定道具有多少个
			var count:int;
			for each(var icon:PropsComposeIcon in _iconAry)
			{
				if(icon.bsVo && icon.bound == bound)//检查已经放上去的该绑定性的有几个
					count++;
			}
			if(count == num)//放上去绑定的属性和选择道具的一样，说明该选择的道具已经全部放上去了
				return true;
			return false;
		}
		
		private function checkComposeBtn():void
		{
			if(_selectedPropsNum >= 2)
			{
				if(DataCenter.Instance.roleSelfVo.note >= _curMergeVo.money)
				{
					_combineBtn.enabled=true;
					var count:int;
					if(_selectedPropsNum == 5)
						_allConbineBtn.enabled=true;
					else
						_allConbineBtn.enabled=false;
				}
				else
				{
					_combineBtn.enabled=false;
					_allConbineBtn.enabled=false;
				}			
			}
			else
			{
				_combineBtn.enabled=false;
				_allConbineBtn.enabled=false;
			}
		}
		
		
		
		/** 清除八个图标 */		
		private function clearAllIcons():void
		{
			for each(var icon:PropsComposeIcon in _iconAry)
			{
				icon.clear();
			}
		}
		
		/** 合成成功率：0,25,50,70,100 */
		private function updateRate():void
		{
			var num:int=_selectedPropsNum;
//			var mergeVo:MergeGemBasicVo=MergeGemBasicManager.Instance.getBasicVoByMaterialId(_curMateralInfo.vo.template_id);
			switch(num)
			{
				case 0:
				case 1:
					_successRate.text="0%";
					break;
				case 2:
					_successRate.text="25%";
					break;
				case 3:
					_successRate.text="50%";
					break;
				case 4:
					_successRate.text="75%";
					break;
				case 5:
					_successRate.text="100%";
					break;
			}
			
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onSelectProps(e:Event):void
		{
			var item:Object=_itemsList.selectedItem;
			
			if(_selectedPropsNum < HOLE_MAX)
			{
				if(_iconAry[0].bsVo != null)
				{
					if(item.vo.template_id != _iconAry[0].bsVo.template_id)//不同道具
					{
						NoticeManager.setNotice(NoticeType.Notice_id_1211);
						return;
					}
					else if(checkGemNone(item.vo,item.bound))//选择的道具已用完
					{
						NoticeManager.setNotice(NoticeType.Notice_id_1222);
						return;
					}
				}
				
				for each(var icon:PropsComposeIcon in _iconAry)
				{
					if(icon.bsVo == null)
					{
						icon.bound=item.bound;
						icon.bsVo=item.vo;
						_selectedPropsNum=icon.index+1;
						break;
					}
				}
				
				_curMergeVo=MergeGemBasicManager.Instance.getBasicVoByMaterialId(_iconAry[0].bsVo.template_id);;
				updateRate();
				checkComposeBtn();
				updateMoney();
				
			}			
			else
			{
				NoticeManager.setNotice(NoticeType.Notice_id_1212);
				return;
			}			
		}
		
		private function onClearIcon(e:YFEvent):void
		{	
			var propsAry:Array=[];
			var obj:Object;
			for each(var icon:PropsComposeIcon in _iconAry)
			{
				if(icon.bsVo)
				{
					obj={vo:icon.bsVo,bound:icon.bound}
					propsAry.push(obj);
				}
			}
			var len:int=propsAry.length;
			for(var i:int=0;i<HOLE_MAX;i++)
			{
				if(propsAry[i])
				{
					_iconAry[i].bsVo=propsAry[i].vo;
					_iconAry[i].bound=propsAry[i].bound;
				}
				else
					_iconAry[i].clear();
			}
			_selectedPropsNum--;
			updateRate();
			updateMoney();
			checkComposeBtn();
		}
		
		
		private function onCombineClick(e:MouseEvent):void
		{
			if(BagStoreManager.instantce.checkBagHasEnoughGrids(_iconAry[0].bsVo.template_id,1,TypeProps.ITEM_TYPE_PROPS))//先检查背包是否有足够的格子
			{
				var needMoney:int=_curMergeVo.money;
				if(DataCenter.Instance.roleSelfVo.note >= needMoney)
				{
					var formId:int=_curMergeVo.form_id;
					var materialAry:Array=getMaterialAry(_iconAry[0].bsVo.template_id);
					ModuleManager.forgetModule.composePropsReq(formId,materialAry);
				}
				else
					NoticeManager.setNotice(NoticeType.Notice_id_332);
			}
			else
				NoticeManager.setNotice(NoticeType.Notice_id_302);
		}
		
		/** 统计五个道具里有几个绑定和不绑定，并返回各自的位置 */
		private function getMaterialAry(templateId:int):Array
		{
			var boundYesCount:int=0;
			var boundNoCount:int=0;
			for each(var icon:PropsComposeIcon in _iconAry)
			{
				if(icon.bsVo)
				{
					if(icon.bound == TypeProps.BIND_TYPE_YES)
						boundYesCount++;
					else
						boundNoCount++;
				}
				else
					break;
			}
			var items:Array=[];
			if(boundNoCount > 0)
				items=PropsDyManager.instance.getPropsPosAryByBound(templateId,TypeProps.BIND_TYPE_NO,boundNoCount);
			if(boundYesCount > 0)
			{
				var bItems:Array=PropsDyManager.instance.getPropsPosAryByBound(templateId,TypeProps.BIND_TYPE_YES,boundYesCount)
				items=items.concat(bItems);
			}
			return items;
		}
		
		private function onAllCombineClick(e:MouseEvent):void
		{
			var propsNum:int=PropsDyManager.instance.getPropsQuantity(_iconAry[0].bsVo.template_id);
			var expectMergeNum:int=propsNum/5;//按背包数量预计能合成几次，间接可以算出需要用多少个道具
			var factMergeNum:int=DataCenter.Instance.roleSelfVo.note/_curMergeVo.money;//实际金钱允许合成的次数
			if(factMergeNum > 0)//钱够合成一次的
			{
				var materialAry:Array=PropsDyManager.instance.getPropsPosArray(_iconAry[0].bsVo.template_id,
					Math.min(expectMergeNum,factMergeNum)*5);
				ModuleManager.forgetModule.composeAllPropsReq(_curMergeVo.form_id,materialAry);
			}
			else
				NoticeManager.setNotice(NoticeType.Notice_id_332);

		}	
		
		/**
		 * 镶嵌宝石更改、背包有任何改变，都刷新背包list和身上装备list
		 * @param event
		 */
		private function updateBag(event:YFEvent):void
		{
			if(_update == false) return;
			updatePropsList();
			checkComposeBtn();
		}
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 