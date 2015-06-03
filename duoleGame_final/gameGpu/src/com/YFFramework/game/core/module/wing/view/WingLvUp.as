package com.YFFramework.game.core.module.wing.view
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsBasicManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.FilterConfig;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.tips.EquipTip;
	import com.YFFramework.game.core.global.view.tips.PropsTip;
	import com.YFFramework.game.core.global.view.tips.TipUtil;
	import com.YFFramework.game.core.module.bag.data.BagStoreManager;
	import com.YFFramework.game.core.module.preview.view.RolePreview;
	import com.YFFramework.game.core.module.wing.event.WingEvent;
	import com.YFFramework.game.core.module.wing.model.WingEnhanceManager;
	import com.YFFramework.game.core.module.wing.model.WingEnhanceVo;
	import com.dolo.lang.LangBasic;
	import com.dolo.ui.controls.Button;
	import com.dolo.ui.controls.CheckBox;
	import com.dolo.ui.controls.IconImage;
	import com.dolo.ui.controls.ProgressBar;
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.Xdis;
	import com.dolo.ui.tools.Xtip;
	import com.msg.item.CEnhanceEquipReq;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @version 1.0.0
	 * creation time：2013-6-20 下午2:18:28
	 */
	public class WingLvUp{
		
		private var _mc:MovieClip;
		private var _lvupBtn:Button;//升级
		private var _mainWing:IconImage;
		private var _material:IconImage;
		private var _nxtWing:IconImage;
		private var _starProgress:ProgressBar;
		
		private var _mainWingDyVo:EquipDyVo;
		private var _selfEquip:Boolean=false;
		private var _wingVo:WingEnhanceVo;
		private var _autoUpBtn:Button;//一键升级
		private var _stars:Vector.<Sprite>;
		
		private var _isAutoUp:Boolean=false;//一键进阶中
		private var _checkBox:CheckBox;//花魔钻，材料减半
		private var _count_txt:TextField;//剩余普通可升阶次数
		private var _count_other_txt:TextField;//额外可升阶次数
		private var _next_change_txt:TextField;//下次改变外观需要的升阶次数
		private var _lookBtn:Button;//预览按钮
		private var _isLooking:Boolean=false;
		private var _window:WingWindow;
		
		public function WingLvUp(mc:MovieClip,window:WingWindow){
			_mc=mc;
			AutoBuild.replaceAll(_mc);
			_window=window;

			_lvupBtn = Xdis.getChildAndAddClickEvent(onLvUp,_mc,"lvup_button");
			_lvupBtn.enabled=false;
			_autoUpBtn=Xdis.getChildAndAddClickEvent(onAutoClick,_mc,"auto_uplv_button");
			_autoUpBtn.enabled=false;
			_lookBtn = Xdis.getChildAndAddClickEvent(onLookClick,_mc,"view_button");

			_count_txt = Xdis.getTextChild(_mc,"count_txt");
			_count_other_txt = Xdis.getTextChild(_mc,"count_other_txt");
			_next_change_txt = Xdis.getTextChild(_mc,"next_change_txt");
			_mainWing = Xdis.getChild(_mc,"wing_iconImage");
			_material = Xdis.getChild(_mc,"material_iconImage");
			_nxtWing = Xdis.getChild(_mc,"wing2_iconImage");
			addInAndOutEvent(_mainWing);
			addInAndOutEvent(_nxtWing);
			_checkBox=Xdis.getChild(_mc,"half_checkBox");
			_checkBox.label=LangBasic.Wing_cast.replace("&&",2);
			_checkBox.textField.width=300;
			_checkBox.addEventListener(UIEvent.USER_CHANGE,onCheckBoxClick);
			_starProgress = Xdis.getChild(_mc, "star_progressBar");
			_stars=new Vector.<Sprite>(10,true);
			for(var i:int=0;i<10;i++)
			{
				_stars[i]=Xdis.getSpriteChild(_mc.starts,"start"+(i+1));
			}
			setStarsNum(0);
		}
		
		private function addInAndOutEvent(sp:Sprite):void
		{
			sp.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			sp.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			// TODO 关闭预览框
			if(!_isLooking)
				RolePreview.Instence.close();
		}
		
		protected function onMouseOver(event:MouseEvent):void
		{
			// TODO 弹出预览框
			if(!_wingVo) return;
			switch(event.currentTarget)
			{
				case _mainWing:
					RolePreview.Instence.previewWithWing(_wingVo.templateId,_window.getTarget());
					break;
				case _nxtWing:
					if(_wingVo.nextId>0)
						RolePreview.Instence.previewWithWing(_wingVo.nextId,_window.getTarget());
					break;
			}
		}
		
		private function onLookClick(e:MouseEvent):void
		{
			if(_wingVo)
			{
				_isLooking=true;
				RolePreview.Instence.previewWithWing(_wingVo.look_id,_window.getTarget());
			}
			else
			{
				NoticeUtil.setOperatorNotice("没有可预览的翅膀...");
			}
		  
		}
		
		protected function onCheckBoxClick(event:Event):void
		{
			updateMainImg();
		}
		
		private function setStarsNum(num:int):void
		{
			for(var i:int=0;i<10;i++)
			{
				if(i<num)
					_stars[i].filters=null;
				else
					_stars[i].filters=UI.disableFilter;
			}
		}
		
		private function onAutoClick(e:MouseEvent):void
		{
			// TODO 一键升级、客服端模拟点击
			if(!_isAutoUp)
			{
				_isAutoUp=true;
				onLvUp(null);
			}
			else
				_isAutoUp=false;
			updateBtn();
			
		}
		
		/**初始化窗口
		 */		
		public function initPanel():void{
			WingLvUpEffMgr.Instence.loadEff();
			updateMainImg();
		}
		
		/**更新主翅膀图标和属性
		 * @param vo	主翅膀动态EquipDyVo
		 * @param basicVO	主翅膀静态Vo
		 */		
		public function updateMainImg(e:YFEvent=null):void{
			setStarsNum( CharacterDyManager.Instance.wingStarNum);
			_starProgress.percentUpTo=CharacterDyManager.Instance.wingLuckNum/100;
			
			_count_txt.text=WingEnhanceManager.Instance.count.toString();
			_count_other_txt.text=WingEnhanceManager.Instance.count_other.toString();
			
			var vo:EquipDyVo = CharacterDyManager.Instance.getEquipInfoByPos(TypeProps.EQUIP_TYPE_WINGS);
			if(vo==null){
				var arr:Array = BagStoreManager.instantce.getAllPackArray();
				var len:int = arr.length;
				for(var i:int=0;i<arr.length;i++){
					if(arr[i].type==TypeProps.ITEM_TYPE_EQUIP){
						vo = EquipDyManager.instance.getEquipInfo(arr[i].id);
						var bvo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(vo.template_id);
						if(bvo.type==TypeProps.EQUIP_TYPE_WINGS){
							_mainWingDyVo = vo;
							_selfEquip = false;
						}
					}
				}
			}else{
				_mainWingDyVo = vo;
				_selfEquip = true;
			}
			
			if(_mainWingDyVo==null){
				_mainWing.clear();
				_material.clear();
				Xtip.clearLinkTip(_mainWing,TipUtil.equipTipInitFunc);
				for(i=0;i<=9;i++){
					_mc["t"+i].text="";
				}
				_mc.numTxt.text="";
				_wingVo=null;
				
			}else{
				_mainWing.url = EquipBasicManager.Instance.getURL(_mainWingDyVo.template_id);
				Xtip.registerLinkTip(_mainWing,EquipTip,TipUtil.equipTipInitFunc,_mainWingDyVo.equip_id,_mainWingDyVo.template_id,_selfEquip);
				bvo = EquipBasicManager.Instance.getEquipBasicVo(_mainWingDyVo.template_id);
				
				var wingEnhanceVo:WingEnhanceVo = WingEnhanceManager.Instance.getWingEnhanceVo(bvo.template_id);
				if(wingEnhanceVo==null){
					_next_change_txt.text="";
					if(bvo.base_attr_t1!=0)	_mc.t0.text = TypeProps.getAttrName(bvo.base_attr_t1)+":+"+bvo.base_attr_v1+"%";//bvo.base_attr_v1*10000*_mainWingDyVo.enhance_level+"%";
					else	_mc.t0.text="";
					if(bvo.base_attr_t2!=0)	_mc.t1.text = TypeProps.getAttrName(bvo.base_attr_t2)+":+"+bvo.base_attr_v2+"%";//bvo.base_attr_v2*10000*_mainWingDyVo.enhance_level+"%";
					else	_mc.t1.text="";
					if(bvo.base_attr_t3!=0)	_mc.t2.text = TypeProps.getAttrName(bvo.base_attr_t3)+":+"+bvo.base_attr_v3+"%";//bvo.base_attr_v3*10000*_mainWingDyVo.enhance_level+"%";
					else	_mc.t2.text="";
					if(bvo.app_attr_t1!=0)	_mc.t3.text = TypeProps.getAttrName(bvo.app_attr_t1)+":+"+bvo.app_attr_v1+"%";//bvo.app_attr_v1*10000*_mainWingDyVo.enhance_level+"%";
					else	_mc.t3.text="";
					if(bvo.app_attr_t2!=0)	_mc.t4.text = TypeProps.getAttrName(bvo.app_attr_t2)+":+"+bvo.app_attr_v2+"%";//bvo.app_attr_v2*10000*_mainWingDyVo.enhance_level+"%";
					else	_mc.t4.text="";
					
					_mc.t5.text="【已满级】";
					_mc.t6.text="";
					_mc.t7.text="";
					_mc.t8.text="";
					_mc.t9.text="";
					_mc.numTxt.text="";
					_material.clear();
					_wingVo=null;
					_nxtWing.clear();
					Xtip.clearLinkTip(_nxtWing);
				}else{
					_wingVo = wingEnhanceVo;
					_next_change_txt.text=LangBasic.Wind_next_look.replace("&&",wingEnhanceVo.count);
					var nbvo:EquipBasicVo = EquipBasicManager.Instance.getEquipBasicVo(wingEnhanceVo.nextId);
					
					if(bvo.base_attr_t1!=0)	_mc.t0.text = TypeProps.getAttrName(bvo.base_attr_t1)+":+"+bvo.base_attr_v1+"%";//bvo.base_attr_v1*10000*_mainWingDyVo.enhance_level+"%";
					else	_mc.t0.text="";
					if(bvo.base_attr_t2!=0)	_mc.t1.text = TypeProps.getAttrName(bvo.base_attr_t2)+":+"+bvo.base_attr_v2+"%";//bvo.base_attr_v2*10000*_mainWingDyVo.enhance_level+"%";
					else	_mc.t1.text="";
					if(bvo.base_attr_t3!=0)	_mc.t2.text = TypeProps.getAttrName(bvo.base_attr_t3)+":+"+bvo.base_attr_v3+"%";//bvo.base_attr_v3*10000*_mainWingDyVo.enhance_level+"%";
					else	_mc.t2.text="";
					if(bvo.app_attr_t1!=0)	_mc.t3.text = TypeProps.getAttrName(bvo.app_attr_t1)+":+"+bvo.app_attr_v1+"%";//bvo.app_attr_v1*10000*_mainWingDyVo.enhance_level+"%";
					else	_mc.t3.text="";
					if(bvo.app_attr_t2!=0)	_mc.t4.text = TypeProps.getAttrName(bvo.app_attr_t2)+":+"+bvo.app_attr_v2+"%";//bvo.app_attr_v2*10000*_mainWingDyVo.enhance_level+"%";
					else	_mc.t4.text="";
					
					if(nbvo.base_attr_t1!=0)	_mc.t5.text = TypeProps.getAttrName(nbvo.base_attr_t1)+":+"+nbvo.base_attr_v1+"%";//bvo.base_attr_v1*(_mainWingDyVo.enhance_level+1)*10000+"%";
					else	_mc.t5.text="";
					if(nbvo.base_attr_t2!=0)	_mc.t6.text = TypeProps.getAttrName(nbvo.base_attr_t2)+":+"+nbvo.base_attr_v2+"%";//bvo.base_attr_v2*(_mainWingDyVo.enhance_level+1)*10000+"%";
					else	_mc.t6.text="";
					if(nbvo.base_attr_t3!=0)	_mc.t7.text = TypeProps.getAttrName(nbvo.base_attr_t3)+":+"+nbvo.base_attr_v3+"%";//bvo.base_attr_v3*(_mainWingDyVo.enhance_level+1)*10000+"%";
					else	_mc.t7.text="";
					if(nbvo.app_attr_t1!=0)	_mc.t8.text = TypeProps.getAttrName(nbvo.app_attr_t1)+":+"+nbvo.app_attr_v1+"%";//bvo.app_attr_v1*(_mainWingDyVo.enhance_level+1)*10000+"%";
					else	_mc.t8.text="";
					if(nbvo.app_attr_t2!=0)	_mc.t9.text = TypeProps.getAttrName(nbvo.app_attr_t2)+":+"+nbvo.app_attr_v2+"%";//bvo.app_attr_v2*(_mainWingDyVo.enhance_level+1)*10000+"%";
					else	_mc.t9.text="";
				
					var needNum:int;
					if(_checkBox.selected)//减半
						needNum=(wingEnhanceVo.ingredientNum/2);
					else
						needNum=wingEnhanceVo.ingredientNum;
					_mc.numTxt.text=needNum.toString();
					
					_material.url=PropsBasicManager.Instance.getURL(wingEnhanceVo.ingredient);
					Xtip.registerLinkTip(_material,PropsTip,TipUtil.propsTipInitFunc,0,wingEnhanceVo.ingredient);
					
					var bagNum:int = PropsDyManager.instance.getPropsQuantity(wingEnhanceVo.ingredient);
					if(bagNum<needNum){
						_material.filters=FilterConfig.dead_filter;
						_mc.numTxt.textColor=TypeProps.COLOR_RED;
					}else{
						_material.filters=null;
						_mc.numTxt.textColor=TypeProps.C8CF213;
					}
					
					_nxtWing.url = EquipBasicManager.Instance.getURL(nbvo.template_id);
					Xtip.registerLinkTip(_nxtWing,EquipTip,TipUtil.equipTipInitFunc,0,nbvo.template_id,false);
				}
			}
			_checkBox.label=LangBasic.Wing_cast.replace("&&",getMoney());
			updateBtn();
		}
		
		private function getMoney():int
		{
			var mm:int=2*(WingEnhanceManager.Instance.money_use_count+1);
			if(mm>50)
				mm=50;
			return 50;
		}
		
		/**重置窗口
		 */		
		public function resetPanel():void{
			_mainWingDyVo = null;
			_mainWing.clear();
			Xtip.clearLinkTip(_mainWing,TipUtil.equipTipInitFunc);
		}
		
		/**进化更新
		 * @param vo
		 * @param bvo
		 */		
		public function onLvUpUpdate(vo:EquipDyVo):void{
			_mainWingDyVo=vo;
			updateMainImg();
		}
		
		/**更新按钮
		 */		
		private function updateBtn():void{
			if(_wingVo)
			{
				var wing:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(_wingVo.nextId);
				if(wing.level>DataCenter.Instance.roleSelfVo.roleDyVo.level
					|| _mc.numTxt.textColor==TypeProps.COLOR_RED
				    || !WingEnhanceManager.Instance.hasCount())
					_lvupBtn.enabled=false;
				else
					_lvupBtn.enabled=true;
			}
			else
				_lvupBtn.enabled=false;
			
			_autoUpBtn.enabled=_lvupBtn.enabled;
			if(!_isAutoUp)
				_autoUpBtn.label="自动进阶";
			else
				_autoUpBtn.label="取消";
			
			if(_wingVo&&_wingVo.nextId>0)
				_lookBtn.enabled=true;
			else
				_lookBtn.enabled=false;
		}
		
		/**进化按钮点击
		 * @param e
		 */		
		private function onLvUp(e:MouseEvent):void{
			var msg:CEnhanceEquipReq = new CEnhanceEquipReq();
			if(_selfEquip==true)	msg.pos = EquipDyManager.instance.getEquipPosFromRole(_mainWingDyVo.equip_id);
			else	msg.pos = EquipDyManager.instance.getEquipPosFromBag(_mainWingDyVo.equip_id);
			msg.stone=PropsDyManager.instance.getPropsPosArray(_wingVo.ingredient,int(_mc.numTxt.text));
			msg.subDiamond=_checkBox.selected;
			YFEventCenter.Instance.dispatchEventWith(WingEvent.LvUpWingReq,msg);
			WingEnhanceManager.Instance.delOneCount();
			if(_checkBox.selected)
				WingEnhanceManager.Instance.money_use_count++;
		}
		
		/**显示翅膀升级特效*/
		public function showLvEff():void
		{
			WingLvUpEffMgr.Instence.setTo(_mc,70,65);
		}
		
		/**显示暴击特效**/
		public function showLuckEff():void
		{
			NoticeUtil.setOperatorNotice("暴击！！");//临时替代
		}
		
		/**检测是否处于一键升级中*/
		public function checkAuto():void
		{
			if(_isAutoUp)
			{
				updateBtn();
				if(_lvupBtn.enabled)
					onLvUp(null);
				else
				{
					_isAutoUp=false;
					updateBtn();
				}
			}
		}
		public function onClosePreview():void
		{
			_isLooking=false;
		}
		public function onClose():void
		{//界面关闭时，取消自动进阶
			_isAutoUp=false;
			updateBtn();
			RolePreview.Instence.close();
		}
	}
} 