package com.YFFramework.game.core.module.mount.view
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
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.event.BagEvent;
	import com.YFFramework.game.core.module.mount.events.MountEvents;
	import com.YFFramework.game.core.module.mount.manager.MountBasicManager;
	import com.YFFramework.game.core.module.mount.manager.MountDyManager;
	import com.YFFramework.game.core.module.mount.model.MountBasicVo;
	import com.YFFramework.game.core.module.mount.model.MountDyVo;
	import com.YFFramework.game.core.module.mount.view.render.MountRender;
	import com.YFFramework.game.core.module.shop.controller.ModuleShop;
	import com.YFFramework.game.core.module.shop.data.ShopBasicManager;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.common.ItemConsume;
	import com.msg.mount_pro.CAddSoul;
	import com.msg.mount_pro.CAddSoulConfirm;
	import com.msg.storage.CSellItemReq;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-25 下午2:19:08
	 * 坐骑附灵面板
	 */
	public class MountAdd{
		
		private var _mc:MovieClip;
		private var _mountList:List;
		
		private var add_button:Button;
		private var iconImg:IconImage;
		private var iconImg2:IconImage;

		private var _itemTemplateId:int=-1;
		
		public function MountAdd(mc:MovieClip){
			_mc = mc;
			AutoBuild.replaceAll(_mc);
		}
		
		/**初始化窗口
		 */		
		public function initWin():void{
			_mountList = Xdis.getChild(_mc,"mount_list");
			_mountList.itemRender = MountRender;
			_mountList.addEventListener(Event.CHANGE,onSelectUpdate);
			
			add_button = Xdis.getChildAndAddClickEvent(onAdd,_mc,"add_button");

			iconImg = Xdis.getChild(_mc,"img_iconImage");
			iconImg2 = Xdis.getChild(_mc,"img2_iconImage");
		}
		
		/**切换界面更新
		 */		
		public function onTabUpdate():void{
			updateMountList();
			updateCrtMount();
			updateMoneyTxt();
			updateBtn();
		}
		
		/**切换坐骑更新
		 * @param e
		 */		
		public function onSelectUpdate(e:Event):void{
			MountDyManager.crtMountId = (e.currentTarget as List).selectedItem.dyId;
			updateCrtMount();
			updateBtn();
		}
		
		/**更新坐骑列表
		 */		
		public function updateMountList():void{
			_mountList.removeAll();
			
			var item:ListItem;
			var arr:Array = MountDyManager.Instance.getMountsIdArr();
			var len:int=arr.length;
			for(var i:int=0;i<len;i++){
				item = new ListItem();
				var mount:MountDyVo = MountDyManager.Instance.getMount(arr[i]);
				item.name = MountBasicManager.Instance.getMountBasicVo(mount.basicId).mount_type;
				//item.lv = mount.level;
				item.dyId = mount.dyId;
				item.quality = MountBasicManager.Instance.getMountBasicVo(mount.basicId).quality;
				if(mount.dyId==MountDyManager.fightMountId)	item.status="出战";
				else	item.status="休息";
				item.url = MountBasicManager.Instance.getMountIconURL(mount.basicId);
				_mountList.addItem(item);
				if(mount.dyId==MountDyManager.crtMountId)	_mountList.selectedIndex=i;
			}
		}
		
		/**更新选中的坐骑信息 
		 */	
		public function updateCrtMount():void{		
			if(MountDyManager.crtMountId!=-1){
				var mount:MountDyVo = MountDyManager.Instance.getCrtMount();
				var mountBvo:MountBasicVo = MountBasicManager.Instance.getMountBasicVo(mount.basicId);
				//_mc.mountTypeTxt.text = "坐骑类型："+MountBasicManager.Instance.getMountBasicVo(mount.basicId).mount_type;
				//_mc.mountLvTxt.text = "坐骑阶数："+mount.level;
				_mc.t0.text="【附灵属性】";

				if(mount.addPhy!=0){
					_mc.t1.text="+"+(mountBvo.physique);
					_mc.t2.text="+"+(mountBvo.strength);
					_mc.t3.text="+"+(mountBvo.agility);
					_mc.t4.text="+"+(mountBvo.intell);
					_mc.t5.text="+"+(mountBvo.spirit);
					
					_mc.t6.text = "+"+mount.addPhy;
					_mc.t7.text = "+"+mount.addStr;
					_mc.t8.text = "+"+mount.addAgi;
					_mc.t9.text = "+"+mount.addInt;
					_mc.t10.text = "+"+mount.addSpi;
					
				}else{
					_mc.t1.text="+"+mount.addPhy;
					_mc.t2.text="+"+mount.addStr;
					_mc.t3.text="+"+mount.addAgi;
					_mc.t4.text="+"+mount.addInt;
					_mc.t5.text="+"+mount.addSpi;
					
					_mc.t6.text = "";
					_mc.t7.text = "";
					_mc.t8.text = "";
					_mc.t9.text = "";
					_mc.t10.text = "";
				}
				
				iconImg.url = MountBasicManager.Instance.getMountIconURL(mount.basicId);
				
				var arr:Array = PropsBasicManager.Instance.getAllBasicVoByType(TypeProps.PROPS_TYPE_MOUNT_ADD);
				var len:int = arr.length;
				for(var i:int=0;i<arr.length;i++){
					if(mountBvo.quality==PropsBasicVo(arr[i]).quality){
						_itemTemplateId = PropsBasicVo(arr[i]).template_id;
						iconImg2.url = PropsBasicManager.Instance.getURL(_itemTemplateId);
						Xtip.registerLinkTip(iconImg2,PropsTip,TipUtil.propsTipInitFunc,0,_itemTemplateId);
						var quantity:int = PropsDyManager.instance.getPropsQuantity(_itemTemplateId);
						if(quantity<=0){
							iconImg2.filters=FilterConfig.dead_filter;
							_mc.numTxt.textColor=TypeProps.COLOR_RED;
							_mc.numTxt.text = "0";
						}else{
							iconImg2.filters = null;
							_mc.numTxt.text = quantity;
							_mc.numTxt.textColor=TypeProps.COLOR_WHITE;
						}
					}
				}
			}else{
				for(i=0;i<11;i++){
					_mc["t"+i].text="";
				}
				iconImg.clear();
				iconImg2.clear();
			}
		}
		
		/**更新金钱
		 */
		public function updateMoneyTxt():void{
			if(MountDyManager.crtMountId!=-1)	_mc.moneyTxt.text="消耗银锭：5000";
			else	_mc.moneyTxt.text="";
			if(DataCenter.Instance.roleSelfVo.note<5000)	_mc.moneyTxt.textColor=TypeProps.COLOR_RED;
			else	_mc.moneyTxt.textColor=TypeProps.Cfff3a5;
		}
		
		/**更新按钮状态
		 */		
		public function updateBtn():void{
			if(DataCenter.Instance.roleSelfVo.note>5000 && MountDyManager.crtMountId!=-1 && PropsDyManager.instance.getPropsQuantity(_itemTemplateId)>0){
				add_button.enabled=true;
			}else{
				add_button.enabled=false;
			}
		}
		
		/**清除对象 
		 */		
		public function dispose():void{
			_mountList.removeAll();
			_mountList.removeEventListener(Event.CHANGE,onSelectUpdate);
			_mountList=null;
			add_button.removeEventListener(MouseEvent.CLICK,onAdd);
			add_button=null;
			iconImg=null;
		}
	
		/**附灵按钮点击 
		 * @param e
		 */		
		private function onAdd(e:MouseEvent):void{
			if(DataCenter.Instance.roleSelfVo.roleDyVo.level<30){
				NoticeUtil.setOperatorNotice("30级以上才能进行附灵操作~");
			}else{
				var msg:CAddSoul = new CAddSoul();
				msg.mountId = MountDyManager.crtMountId;
				msg.useItem = PropsDyManager.instance.getPropsPosArray(_itemTemplateId,1);
				YFEventCenter.Instance.dispatchEventWith(MountEvents.AddSoulReq,msg);
			}
		}
	}
} 