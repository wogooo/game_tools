package com.YFFramework.game.core.module.preview.view
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.game.core.global.DataCenter;
	import com.YFFramework.game.core.global.manager.CharacterDyManager;
	import com.YFFramework.game.core.global.model.EquipDyVo;
	import com.YFFramework.game.core.global.util.TypeProps;
	import com.YFFramework.game.core.global.view.player.SimplePlayer;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.preview.event.PreviewEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/***
	 *角色预览
	 *@author ludingchang 时间：2014-1-11 下午1:40:54
	 */
	public class RolePreview extends PreviewBase
	{
		private var _sex:int;
		private var _career:int;
		private var _clothId:int=-1;
		private var _wingId:int=-1;
		private var _weaponId:int=-1;
		private var _clothLevel:int=-1;
		private var _weaponLevel:int=-1;
		
		private var _avatar:SimplePlayer;
		
		private static var _inst:RolePreview;
		public static function get Instence():RolePreview
		{
			return _inst||=new RolePreview;
		}
		public function RolePreview(backgroundBgId:int=0)
		{
			super(backgroundBgId);
			
			_avatar=new SimplePlayer;
			ui.addChild(_avatar);
			_avatar.y=200;
			_avatar.x=175;
			_avatar.mouseChildren=false;
			_avatar.mouseEnabled=false;
		}
		
		protected override function onClick(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _right:
					_avatar.turnLeft();
					break;
				case _left:
					_avatar.turnRight();
					break;
			}
		}
		
		/**
		 *新翅膀预览 
		 * @param wingId
		 * 
		 */		
		public function previewWithWing(wingId:int,p:Point=null):void
		{
			getCurrentData();
			_wingId=wingId;
			update();
			open();
			if(p)
			{
				x=p.x;
				y=p.y;
			}
		}
		
		/**
		 *新衣服预览 
		 * @param clothId
		 * 
		 */		
		public function previewWithCloth(clothId:int):void
		{
			getCurrentData();
			_clothId=clothId;
			update();
			open();
		}
		
		/**
		 *新武器预览 
		 * @param weaponId
		 * 
		 */		
		public function previewWithWeapon(weaponId:int):void
		{
			getCurrentData();
			_weaponId=weaponId;
			update();
			open();
		}
		
		public override function open():void
		{
			_avatar.start();
			super.open();
		}
		
		public override function close(event:Event=null):void
		{
			super.close();
			_avatar.stop();
			YFEventCenter.Instance.dispatchEventWith(PreviewEvent.CloseRole);
		}
		
		public override function update():void
		{
			if(_clothId>0)
				_avatar.updateClothId(_clothId,_sex,_career,_clothLevel);
			else
				_avatar.initDefaultCloth(_sex,_career);
			
			_avatar.updateWingId(_wingId,_sex);
			
			_avatar.updateWeaponId(_weaponId,_sex,_career,_weaponLevel);
		}
		
		private function getCurrentData():void
		{
			var roleDyVo:RoleDyVo=DataCenter.Instance.roleSelfVo.roleDyVo;
			var _cloth:EquipDyVo;
			var _wing:EquipDyVo;
			var _weapon:EquipDyVo;
			_sex=roleDyVo.sex;
			_career=roleDyVo.career;
			_cloth=CharacterDyManager.Instance.getEquipInfoByPos(TypeProps.EQUIP_TYPE_CLOTHES);
			_wing=CharacterDyManager.Instance.getEquipInfoByPos(TypeProps.EQUIP_TYPE_WINGS);
			_weapon=CharacterDyManager.Instance.getEquipInfoByPos(TypeProps.EQUIP_TYPE_WEAPON);
			_clothId=roleDyVo.clothBasicId;
			if(_cloth)
				_clothLevel=_cloth.enhance_level;
			else
				_clothLevel=-1;
			if(_wing)
				_wingId=_wing.template_id;
			else
				_wingId=-1;
			if(_weapon)
			{
				_weaponId=_weapon.template_id;
				_weaponLevel=_weapon.enhance_level;
			}
			else
			{
				_weaponId=-1;
				_weaponLevel=-1;
			}
		}
		
	}
}