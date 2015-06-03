package com.YFFramework.game.core.module.forge.view.simpleView
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.manager.ConstMapBasicManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.manager.PropsDyManager;
	import com.YFFramework.game.core.global.model.EquipBasicVo;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.NoticeUtil;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.module.ModuleManager;
	import com.YFFramework.game.core.module.forge.data.EquipAttrBasicManager;
	import com.YFFramework.game.core.module.forge.events.ForgeEvents;
	import com.dolo.ui.controls.Button;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 装备洗练单条属性类
	 * @author jina;
	 * @version 1.0.0
	 * creation time：2013-11-6 下午5:14:38
	 */
	public class SophisticationItem
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		/** 属性名称 */		
		private var _attr:TextField;
		/** 属性值 */
		private var _attrV:TextField;
		/** 属性锁定 */
		private var _btn:Button;
		
		private var _lock:Boolean;
		private var _index:int;
		private var _curEquip:EquipDyVo;
		private var _curAttr:int;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function SophisticationItem(index:int,attr:TextField,attrV:TextField,btn:Button)
		{
			_attr=attr;
			_attrV=attrV;
			_btn=btn;
			_index=index;
			_btn.label='锁定';
			_btn.enabled=false;
			_btn.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		
		//======================================================================
		//        public function
		//======================================================================
		public function init(dyVo:EquipDyVo):void
		{
			if(dyVo.app_attr_t1 != 0)
			{
				_curEquip=dyVo;
				var bsVo:EquipBasicVo=EquipBasicManager.Instance.getEquipBasicVo(dyVo.template_id);
				var len:int=bsVo.level/10;
				var a:int;//就是公式里的参数a
				for(var i:int=1;i<=len;i++)
				{
					a += i*10;
				}
				var c:int;//品质参数，太tm贱了，叫这个名字！
				if(bsVo.quality == TypeProps.QUALITY_BLUE)
					c=2;
				else if(bsVo.quality == TypeProps.QUALITY_PURPLE)
					c=3;
				else if(bsVo.quality == TypeProps.QUALITY_ORANGE)
					c=4;
				var value:int;
				var b:int;//就是公式里的参数b
				switch(_index)
				{
					case 1:
						_attr.text=TypeProps.getAttrName(dyVo.app_attr_t1);
						_attr.textColor=dyVo.app_attr_color1;
						_attrV.textColor=dyVo.app_attr_color1;
						b=EquipAttrBasicManager.Instance.getRatioForEquipSophi(dyVo.app_attr_t1)
						value=Math.ceil(b*a*0.05*c);
						_attrV.text=dyVo.app_attr_v1+"/"+value;
						_lock = dyVo.app_attr_lock1;
						
						_curAttr=dyVo.app_attr_t1;
						break;
					case 2:
						_attr.text=TypeProps.getAttrName(dyVo.app_attr_t2);
						_attr.textColor=dyVo.app_attr_color2;
						_attrV.textColor=dyVo.app_attr_color2;
						b=EquipAttrBasicManager.Instance.getRatioForEquipSophi(dyVo.app_attr_t2);
						value=Math.ceil(b*a*0.05*c);
						_attrV.text=dyVo.app_attr_v2+"/"+value;
						_lock = dyVo.app_attr_lock2;
						
						_curAttr=dyVo.app_attr_t2;
						break;
					case 3:
						_attr.text=TypeProps.getAttrName(dyVo.app_attr_t3);
						_attr.textColor=dyVo.app_attr_color3;
						_attrV.textColor=dyVo.app_attr_color3;
						b=EquipAttrBasicManager.Instance.getRatioForEquipSophi(dyVo.app_attr_t3);
						value=Math.ceil(b*a*0.05*c);
						_attrV.text=dyVo.app_attr_v3+"/"+value;
						_lock = dyVo.app_attr_lock3;
						
						_curAttr=dyVo.app_attr_t3;
						break;
					case 4:
						_attr.text=TypeProps.getAttrName(dyVo.app_attr_t4);
						_attr.textColor=dyVo.app_attr_color4;
						_attrV.textColor=dyVo.app_attr_color4;
						b=EquipAttrBasicManager.Instance.getRatioForEquipSophi(dyVo.app_attr_t4);
						value=Math.ceil(b*a*0.05*c);
						_attrV.text=dyVo.app_attr_v4+"/"+value;
						_lock = dyVo.app_attr_lock4;
						
						_curAttr=dyVo.app_attr_t4;
						break;
				}
				_btn.enabled=true;
				updateLockTxt();
			}
			
		}
		
		public function get lock():Boolean
		{
			return _lock;
		}
		
		public function set lock(value:Boolean):void
		{
			_lock = value;
			updateLockTxt();	
		}
		
		public function get curAttr():int
		{
			return _curAttr;
		}
		
		public function enabledBtn(enabled:Boolean):void
		{
			_btn.enabled=enabled;
		}
		
		public function clearAttr():void
		{
			_attr.text='';
			_attrV.text='';
		}
		//======================================================================
		//        private function
		//======================================================================
		private function updateLockTxt():void
		{
			if(_lock)
				_btn.label='解锁';
			else
				_btn.label='锁定';
//			trace("改变按钮文字：",TypeProps.getAttrName(_curAttr),_btn.label)
		}
		
		private function checkLock():Boolean
		{
			var count:int=0;
			var canLock:Boolean=true;
			if(_curEquip.app_attr_lock1)
				count++;
			if(_curEquip.app_attr_lock2)
				count++;
			if(_curEquip.app_attr_lock3)
				count++;
			if(_curEquip.app_attr_lock4)
				count++;
			if(count == 3)
				canLock = false;
			return canLock;
		}
		//======================================================================
		//        event handler
		//======================================================================
		private function onClick(e:MouseEvent):void
		{
//			updateLockTxt();
			var pos:int;
			pos=EquipDyManager.instance.getEquipPosFromRole(_curEquip.equip_id);
			if(pos == 0)
				pos=EquipDyManager.instance.getEquipPosFromBag(_curEquip.equip_id);
			
//			trace("*************************************************")
			var items:Array=new Array();
			var tmpId:int=ConstMapBasicManager.Instance.getTempId(TypeProps.CONST_EQUIP_SOPHI);	
			items=PropsDyManager.instance.getPropsPosArray(tmpId,1);
			if(_lock)//发送解锁命令
			{
				ModuleManager.forgetModule.equipSophiUnlockEquipReq(pos,_curAttr);
//				trace("发送：",TypeProps.getAttrName(_curAttr),"解锁")
			}
			else
			{				
				if(_curEquip.deft_lock_num == 0)
				{
					ModuleManager.forgetModule.equipSophiLockEquipReq(pos,_curAttr,items);
				}
				else if(checkLock())
				{								
					if(items.length == 0)
						NoticeUtil.setOperatorNotice("魔法锁扣不足，无法锁定");
					else
						ModuleManager.forgetModule.equipSophiLockEquipReq(pos,_curAttr,items);
//					trace("发送：",TypeProps.getAttrName(_curAttr),"锁定")
				}
				else
					NoticeUtil.setOperatorNotice("已经锁定三个属性，不能继续锁定了");
				
			}
		}

		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 