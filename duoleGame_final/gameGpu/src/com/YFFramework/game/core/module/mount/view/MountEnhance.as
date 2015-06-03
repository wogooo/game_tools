package com.YFFramework.game.core.module.mount.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.mount.events.MountEvents;
	import com.YFFramework.game.core.module.mount.manager.*;
	import com.YFFramework.game.core.module.mount.model.MountBasicVo;
	import com.YFFramework.game.core.module.mount.model.MountDyVo;
	import com.YFFramework.game.core.module.mount.view.render.*;
	import com.YFFramework.game.core.module.preview.view.MountPreview;
	import com.YFFramework.game.core.module.wing.view.WingLvUpEffMgr;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.List;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.data.ListItem;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.mount_pro.CAdvanceMount;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-4-25 上午11:29:34
	 * 坐骑进阶面板
	 */
	public class MountEnhance{
		
		private var _mc:MovieClip;
		private var _mountList:List;
		private var iconImg:IconImage;
		private var iconImg2:IconImage;
		private var iconImg3:IconImage;
		private var enhance_button:Button;
		private var _starProgress:ProgressBar;

		private var _itemTempId:int=-1;
		private var _itemNum:int=0;
		private var _preview_button:Button;
		private var _autoEnhance_button:Button;
		private var _window:MountWindow;
		private var _isPreview:Boolean;
		private var _stars:Vector.<Sprite>;
		private var _isAutoEnhance:Boolean=false;
		
		public function MountEnhance(mc:MovieClip,window:MountWindow){
			_mc=mc;
			AutoBuild.replaceAll(_mc);
			_window=window;
		}
		
		/**初始化窗口
		 */		
		public function initWin():void{
			_mountList = Xdis.getChild(_mc,"mount_list");
			_mountList.itemRender = MountRender;
			_mountList.addEventListener(Event.CHANGE,onSelectUpdate);
			
			iconImg = Xdis.getChild(_mc,"img_iconImage");
			iconImg2 = Xdis.getChild(_mc,"img2_iconImage");
			iconImg3 = Xdis.getChild(_mc,"img3_iconImage");
			addMouseInAndOut(iconImg);
			addMouseInAndOut(iconImg3);
			
			_starProgress = Xdis.getChild(_mc, "star_progressBar");
			_stars=new Vector.<Sprite>(10,true);
			for(var i:int=0;i<10;i++)
			{
				_stars[i]=Xdis.getSpriteChild(_mc.stars,"start"+(i+1));
			}
			setStarNum(0);

			enhance_button = Xdis.getChildAndAddClickEvent(onEnhance,_mc,"enhance_button");
			_preview_button = Xdis.getChildAndAddClickEvent(onPreview,_mc,"preview_button");
			_autoEnhance_button = Xdis.getChildAndAddClickEvent(onAutoEnhance,_mc,"auto_enhance_button");
		}
		
		private function setStarNum(num:int):void
		{
			for(var i:int=0;i<10;i++)
			{
				if(i<num)
					_stars[i].filters=null;
				else
					_stars[i].filters=UI.disableFilter;
			}
		}
		
		private function onAutoEnhance(e:MouseEvent):void
		{
			// 自动进阶，模拟点击
			if(!_isAutoEnhance)
			{
				_isAutoEnhance=true;
				onEnhance(null);
			}
			else
			{
				_isAutoEnhance=false;
			}
			updateBtn();
		}
		
		private function addMouseInAndOut(dis:Sprite):void
		{//添加鼠标移入移出
			dis.addEventListener(MouseEvent.ROLL_OVER,onMouseOn);
			dis.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
		}
		
		protected function onMouseOut(event:Event):void
		{
			if(!_isPreview)
				MountPreview.Instence.close();
		}
		
		protected function onMouseOn(event:MouseEvent):void
		{
			var mount:MountDyVo = MountDyManager.Instance.getCrtMount();
			if(mount==null) return;
			var mountBasic:MountBasicVo = MountBasicManager.Instance.getMountBasicVo(mount.basicId);
			var p:Point=_window.getTarget();
			switch(event.currentTarget)
			{
				case iconImg://当前
						MountPreview.Instence.previewMount(mount.basicId,p);
					break;
				case iconImg3://下一级
					if(mountBasic.advanceId>0)
						MountPreview.Instence.previewMount(mountBasic.advanceId,p);
					break;
			}
		}
		
		private function onPreview(e:MouseEvent):void
		{
			var mount:MountDyVo = MountDyManager.Instance.getCrtMount();
			if(mount==null) return;
			var mountBasic:MountBasicVo = MountBasicManager.Instance.getMountBasicVo(mount.basicId);
			if(mountBasic.advanceId>0)
			{
				MountPreview.Instence.previewMount(mountBasic.advanceId,_window.getTarget());
				_isPreview=true;
			}
			else
				NoticeUtil.setOperatorNotice("没有可以预览的坐骑");
		}
		
		/**切换界面更新
		 */
		public function onTabUpdate():void{
			updateMountList();
			updateCrtMount();
			updateBtn();
			WingLvUpEffMgr.Instence.loadEff();
		}
		
		/**切换坐骑更新
		 */
		public function onSelectUpdate(e:Event):void{
			MountDyManager.crtMountId = (e.currentTarget as List).selectedItem.dyId;
			updateCrtMount();
			updateBtn();
		}
		
		/**更新按钮状态 
		 */		
		public function updateBtn():void{
			if(MountDyManager.crtMountId!=-1 && _itemTempId!=-1 && _mc.numTxt.textColor!=TypeProps.COLOR_RED 
				&& MountBasicManager.Instance.getMountBasicVo(MountDyManager.Instance.getCrtMount().basicId).advanceId>0)	
				enhance_button.enabled=true;
			else	
				enhance_button.enabled=false;
			
			_autoEnhance_button.enabled=enhance_button.enabled;
			if(!_isAutoEnhance)
				_autoEnhance_button.label="自动进阶";
			else
				_autoEnhance_button.label="取消";
			
			var currentMount:MountDyVo=MountDyManager.Instance.getCrtMount();
			if(currentMount&&MountBasicManager.Instance.getMountBasicVo(currentMount.basicId).advanceId>0)
				_preview_button.enabled=true;
			else
				_preview_button.enabled=false;
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
		
		/**更新选中的宠物信息 
		 * @param e
		 */	
		public function updateCrtMount():void{
//			_mc.starTxt.text = CharacterDyManager.Instance.mountStarNum;
			setStarNum(CharacterDyManager.Instance.mountStarNum);
			_starProgress.percentUpTo=CharacterDyManager.Instance.mountLuckNum/100;

			if(MountDyManager.crtMountId!=-1){
				var mount:MountDyVo = MountDyManager.Instance.getCrtMount();
				var mountBasic:MountBasicVo = MountBasicManager.Instance.getMountBasicVo(mount.basicId);
				_mc.t0.text="【当前属性】";
				_mc.t1.text=mountBasic.physique;
				_mc.t2.text=mountBasic.strength;
				_mc.t3.text=mountBasic.agility;
				_mc.t4.text=mountBasic.intell;
				_mc.t5.text=mountBasic.spirit;
				
				if(mountBasic.advanceId>0){
					_mc.t6.text="【下一级属性】";
					var nextBvo:MountBasicVo = MountBasicManager.Instance.getMountBasicVo(mountBasic.advanceId);
					_mc.t7.text=nextBvo.physique;
					_mc.t8.text=nextBvo.strength;
					_mc.t9.text=nextBvo.agility;
					_mc.t10.text=nextBvo.intell;
					_mc.t11.text=nextBvo.spirit;
					
					iconImg3.url = MountBasicManager.Instance.getMountIconURL(mountBasic.advanceId);
					
					_itemTempId = mountBasic.advancePropId;
					_itemNum = mountBasic.advancePropNum;
					_mc.numTxt.text = _itemNum;
					iconImg2.url = PropsBasicManager.Instance.getURL(_itemTempId);
					Xtip.registerLinkTip(iconImg2,PropsTip,TipUtil.propsTipInitFunc,0,_itemTempId);
					
					var bagNum:int = PropsDyManager.instance.getPropsQuantity(_itemTempId);
					if(bagNum<_itemNum){
						iconImg2.filters=FilterConfig.dead_filter;
						_mc.numTxt.textColor=TypeProps.COLOR_RED;
					}else{
						iconImg2.filters=null;
						_mc.numTxt.textColor=TypeProps.C8CF213;
					}
					
					for(i=0;i<=4;i++){
						if(_mc["i"+i].numChildren>0)
							_mc["i"+i].removeChildAt(0);
					}
					if(nextBvo.physique>=mountBasic.physique){
						_mc.i0.addChild(ClassInstance.getInstance("upArrow"));
						_mc.t12.text = nextBvo.physique-mountBasic.physique;
						_mc.t12.textColor=TypeProps.C8CF213;
					}else{
						_mc.i0.addChild(ClassInstance.getInstance("downArrow"));
						_mc.t12.text = mountBasic.physique-nextBvo.physique;
						_mc.t12.textColor=TypeProps.COLOR_RED;
					}
					if(nextBvo.strength>=mountBasic.strength){
						_mc.i1.addChild(ClassInstance.getInstance("upArrow"));
						_mc.t13.text = nextBvo.strength-mountBasic.strength;
						_mc.t13.textColor=TypeProps.C8CF213;
					}else{
						_mc.i1.addChild(ClassInstance.getInstance("downArrow"));
						_mc.t13.text = mountBasic.strength-nextBvo.strength;
						_mc.t13.textColor=TypeProps.COLOR_RED;
					}
					if(nextBvo.agility>=mountBasic.agility){
						_mc.i2.addChild(ClassInstance.getInstance("upArrow"));
						_mc.t14.text = nextBvo.agility-mountBasic.agility;
						_mc.t14.textColor=TypeProps.C8CF213;
					}else{
						_mc.i2.addChild(ClassInstance.getInstance("downArrow"));
						_mc.t14.text = mountBasic.agility-nextBvo.agility;
						_mc.t14.textColor=TypeProps.COLOR_RED;
					}
					if(nextBvo.intell>=mountBasic.intell){
						_mc.i3.addChild(ClassInstance.getInstance("upArrow"));
						_mc.t15.text = nextBvo.intell-mountBasic.intell;
						_mc.t15.textColor=TypeProps.C8CF213;
					}else{
						_mc.i3.addChild(ClassInstance.getInstance("downArrow"));
						_mc.t15.text = mountBasic.intell-nextBvo.intell;
						_mc.t15.textColor=TypeProps.COLOR_RED;
					}
					if(nextBvo.spirit>=mountBasic.spirit){
						_mc.i4.addChild(ClassInstance.getInstance("upArrow"));
						_mc.t16.text = nextBvo.spirit-mountBasic.spirit;
						_mc.t16.textColor=TypeProps.C8CF213;
					}else{
						_mc.i4.addChild(ClassInstance.getInstance("downArrow"));
						_mc.t16.text = mountBasic.spirit-nextBvo.spirit;
						_mc.t16.textColor=TypeProps.COLOR_RED;
					}
				}else{
					_mc.t6.text="【已满级】";
					_mc.numTxt.text="";
					for(var i:int=7;i<=16;i++){
						_mc["t"+i].text="";
					}
					iconImg2.clear();
					iconImg3.clear();
					for(i=0;i<=4;i++){
						if(_mc["i"+i].numChildren>0)
							_mc["i"+i].removeChildAt(0);
					}
				}
				
				iconImg.url = MountBasicManager.Instance.getMountIconURL(mount.basicId);
			}else{
				for(i=0;i<=16;i++){
					_mc["t"+i].text="";
				}
				iconImg.clear();
				iconImg2.clear();
				iconImg3.clear();
				for(i=0;i<=4;i++){
					if(_mc["i"+i].numChildren>0)
						_mc["i"+i].removeChildAt(0);
				}
			}
		}
		
		/**清除对象
		 */
		public function dispose():void{
			_mountList.removeAll();
			_mountList.removeEventListener(Event.CHANGE,onSelectUpdate);
			_mountList=null;
			iconImg=null;
			iconImg2=null;
			iconImg3=null;
			_starProgress=null;
			enhance_button.removeEventListener(MouseEvent.CLICK,onEnhance);
			enhance_button=null;
		}
		
		/**如果选中道具数量为0，弹出快速购买窗口 
		 * @param e
		 */		
		private function updateCrtItem(e:Event):void{
			if((e.currentTarget as List).selectedItem.amount==0)	
				ModuleManager.moduleShop.openBuySmallWindowDirect(TypeProps.ITEM_TYPE_PROPS,(e.currentTarget as List).selectedItem.template_id);
		}
		
		/**进阶按钮点击 
		 * @param e
		 */		
		private function onEnhance(e:MouseEvent):void{
			var msg:CAdvanceMount  = new CAdvanceMount();
			msg.mountId = MountDyManager.crtMountId;
			msg.feedItems = PropsDyManager.instance.getPropsPosArray(_itemTempId,_itemNum);
			YFEventCenter.Instance.dispatchEventWith(MountEvents.EnhanceReq,msg);
		}
		
		/**
		 *显示坐骑升级特效 
		 */		
		public function showLvEff():void
		{
			WingLvUpEffMgr.Instence.setTo(_mc,242,55);
		}
		
		/**星运暴击特效*/
		public function showLuckEff():void
		{
			NoticeUtil.setOperatorNotice("暴击！");//这个是临时的
		}
		
		public function onClosePreview():void
		{
			_isPreview=false;
		}
		
		public function checkAuto():void
		{
			if(_isAutoEnhance)
			{
				updateBtn();
				if(enhance_button.enabled)
					onEnhance(null);
				else
				{
					_isAutoEnhance=false;
					updateBtn();
				}
			}
		}
		
		public function onClose():void
		{//界面关闭时，取消自动进阶
			_isAutoEnhance=false;
			updateBtn();
			MountPreview.Instence.close();
		}
		
	}
} 