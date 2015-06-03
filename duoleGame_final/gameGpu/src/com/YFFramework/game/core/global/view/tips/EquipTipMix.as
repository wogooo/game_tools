package com.YFFramework.game.core.global.view.tips
{
	/**
	 * @version 1.0.0
	 * creation time：2013-4-22 上午10:53:28
	 * 
	 */
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.manager.EquipBasicManager;
	import com.YFFramework.game.core.global.manager.EquipDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class EquipTipMix extends Sprite
	{
		//======================================================================
		//       public property
		//======================================================================
		
		//======================================================================
		//       private property
		//======================================================================
		private static var equipTip1:EquipTip;//当前装备tip
		private static var equipTip2:EquipTip;//人物身上装备tip
		//======================================================================
		//        constructor
		//======================================================================
		
		public var myEquip1:EquipTip;
		public var myEquip2:EquipTip;
		
		public function EquipTipMix()
		{
		}
		
		//======================================================================
		//        public function
		//======================================================================
		/**
		 * args->[0]动态id,[1]模板id,[2]是否在角色面板,[3]是否显示已装备文字,[4]不在显示列表的equipDyVo,[5]有没有关闭按钮（Boolean）,
		 * 		[6]商店表的绑定性
		 * @param args
		 * 
		 */	
		public static function initTip(args:Array):void
		{	
			var showEquip:Boolean=false;
			
			var equipId1:int=args[0];
			var templateId1:int=args[1];
			var isCharacter:Boolean=args[2];
			var container:Sprite=args[3];
			var otherEquipDyVo:EquipDyVo=args[4];
			var hasCloseBtn:Boolean=args[5];
			var shopBind:int=args[6];
			
			equipTip1=new EquipTip();
			equipTip2=new EquipTip();
			
			if(container is EquipTipMix){
				EquipTipMix(container).myEquip1 = equipTip1;
				EquipTipMix(container).myEquip2 = equipTip2;
			}
			
			equipTip1.setTip([equipId1,templateId1,isCharacter,showEquip,otherEquipDyVo,hasCloseBtn,shopBind]);
			container.addChild(equipTip1);
			container.addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
			
			if(SystemConfigManager.showCompare == false)//如果在系统设里设置不显示装备对比
				return;
			
			if(isCharacter == false)//不在人物面板，显示两个tip
			{
				showEquip=true;
					
				var characterPos:int=EquipBasicManager.Instance.getEquipBasicVo(templateId1).type;
				var roleEquip:EquipDyVo=CharacterDyManager.Instance.getEquipInfoByPos(characterPos);
				
				if(roleEquip)
				{
					equipTip2.setTip([roleEquip.equip_id,roleEquip.template_id,isCharacter,showEquip]);
					container.addChild(equipTip2);
					equipTip2.x=equipTip1.width+3;
				}
				
			}
			
		}
		
		public function dispose():void
		{
			if(myEquip1){
				myEquip1.dispose();
			}
			if(myEquip2){
				myEquip2.dispose();
			}
			while(this.numChildren>0){
				this.removeChildAt(0);
			}
		}
		
		private static function onRemove(event:Event):void
		{
			var sp:Sprite = event.currentTarget as Sprite;
			
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 