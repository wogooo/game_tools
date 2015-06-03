package com.msg.mapScene {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.mapScene.EquipInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class OtherRoleInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DY_ID:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.msg.mapScene.OtherRoleInfo.dy_id", "dyId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dyId:uint;

		/**
		 *  @private
		 */
		public static const MAP_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.map_pos", "mapPos", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mapPos:int;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.mapScene.OtherRoleInfo.name", "name", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var name$field:String;

		public function clearName():void {
			name$field = null;
		}

		public function get hasName():Boolean {
			return name$field != null;
		}

		public function set name(value:String):void {
			name$field = value;
		}

		public function get name():String {
			return name$field;
		}

		/**
		 *  @private
		 */
		public static const EQUIP_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.mapScene.OtherRoleInfo.equip_info", "equipInfo", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.mapScene.EquipInfo; });

		private var equip_info$field:com.msg.mapScene.EquipInfo;

		public function clearEquipInfo():void {
			equip_info$field = null;
		}

		public function get hasEquipInfo():Boolean {
			return equip_info$field != null;
		}

		public function set equipInfo(value:com.msg.mapScene.EquipInfo):void {
			equip_info$field = value;
		}

		public function get equipInfo():com.msg.mapScene.EquipInfo {
			return equip_info$field;
		}

		/**
		 *  @private
		 */
		public static const PLAYER_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.player_type", "playerType", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var playerType:int;

		/**
		 *  @private
		 */
		public static const STATE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.state", "state", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var state$field:int;

		private var hasField$0:uint = 0;

		public function clearState():void {
			hasField$0 &= 0xfffffffe;
			state$field = new int();
		}

		public function get hasState():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set state(value:int):void {
			hasField$0 |= 0x1;
			state$field = value;
		}

		public function get state():int {
			return state$field;
		}

		/**
		 *  @private
		 */
		public static const SEX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.sex", "sex", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var sex$field:int;

		public function clearSex():void {
			hasField$0 &= 0xfffffffd;
			sex$field = new int();
		}

		public function get hasSex():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set sex(value:int):void {
			hasField$0 |= 0x2;
			sex$field = value;
		}

		public function get sex():int {
			return sex$field;
		}

		/**
		 *  @private
		 */
		public static const BASIC_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.basic_id", "basicId", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var basic_id$field:int;

		public function clearBasicId():void {
			hasField$0 &= 0xfffffffb;
			basic_id$field = new int();
		}

		public function get hasBasicId():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set basicId(value:int):void {
			hasField$0 |= 0x4;
			basic_id$field = value;
		}

		public function get basicId():int {
			return basic_id$field;
		}

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.hp", "hp", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var hp$field:int;

		public function clearHp():void {
			hasField$0 &= 0xfffffff7;
			hp$field = new int();
		}

		public function get hasHp():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set hp(value:int):void {
			hasField$0 |= 0x8;
			hp$field = value;
		}

		public function get hp():int {
			return hp$field;
		}

		/**
		 *  @private
		 */
		public static const HP_MAX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.hp_max", "hpMax", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var hp_max$field:int;

		public function clearHpMax():void {
			hasField$0 &= 0xffffffef;
			hp_max$field = new int();
		}

		public function get hasHpMax():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set hpMax(value:int):void {
			hasField$0 |= 0x10;
			hp_max$field = value;
		}

		public function get hpMax():int {
			return hp_max$field;
		}

		/**
		 *  @private
		 */
		public static const MP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.mp", "mp", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mp$field:int;

		public function clearMp():void {
			hasField$0 &= 0xffffffdf;
			mp$field = new int();
		}

		public function get hasMp():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set mp(value:int):void {
			hasField$0 |= 0x20;
			mp$field = value;
		}

		public function get mp():int {
			return mp$field;
		}

		/**
		 *  @private
		 */
		public static const MP_MAX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.mp_max", "mpMax", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mp_max$field:int;

		public function clearMpMax():void {
			hasField$0 &= 0xffffffbf;
			mp_max$field = new int();
		}

		public function get hasMpMax():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set mpMax(value:int):void {
			hasField$0 |= 0x40;
			mp_max$field = value;
		}

		public function get mpMax():int {
			return mp_max$field;
		}

		/**
		 *  @private
		 */
		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.level", "level", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var level$field:int;

		public function clearLevel():void {
			hasField$0 &= 0xffffff7f;
			level$field = new int();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set level(value:int):void {
			hasField$0 |= 0x80;
			level$field = value;
		}

		public function get level():int {
			return level$field;
		}

		/**
		 *  @private
		 */
		public static const BUFF_ID_ARR:RepeatedFieldDescriptor$TYPE_INT32 = new RepeatedFieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.buff_id_arr", "buffIdArr", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("int")]
		public var buffIdArr:Array = [];

		/**
		 *  @private
		 */
		public static const CAREER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.career", "career", (16 << 3) | com.netease.protobuf.WireType.VARINT);

		private var career$field:int;

		public function clearCareer():void {
			hasField$0 &= 0xfffffeff;
			career$field = new int();
		}

		public function get hasCareer():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set career(value:int):void {
			hasField$0 |= 0x100;
			career$field = value;
		}

		public function get career():int {
			return career$field;
		}

		/**
		 *  @private
		 */
		public static const ITEM_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.item_type", "itemType", (17 << 3) | com.netease.protobuf.WireType.VARINT);

		private var item_type$field:int;

		public function clearItemType():void {
			hasField$0 &= 0xfffffdff;
			item_type$field = new int();
		}

		public function get hasItemType():Boolean {
			return (hasField$0 & 0x200) != 0;
		}

		public function set itemType(value:int):void {
			hasField$0 |= 0x200;
			item_type$field = value;
		}

		public function get itemType():int {
			return item_type$field;
		}

		/**
		 *  @private
		 */
		public static const OWNER_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.owner_id", "ownerId", (18 << 3) | com.netease.protobuf.WireType.VARINT);

		private var owner_id$field:int;

		public function clearOwnerId():void {
			hasField$0 &= 0xfffffbff;
			owner_id$field = new int();
		}

		public function get hasOwnerId():Boolean {
			return (hasField$0 & 0x400) != 0;
		}

		public function set ownerId(value:int):void {
			hasField$0 |= 0x400;
			owner_id$field = value;
		}

		public function get ownerId():int {
			return owner_id$field;
		}

		/**
		 *  @private
		 */
		public static const MOUNT_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.mount_id", "mountId", (19 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mount_id$field:int;

		public function clearMountId():void {
			hasField$0 &= 0xfffff7ff;
			mount_id$field = new int();
		}

		public function get hasMountId():Boolean {
			return (hasField$0 & 0x800) != 0;
		}

		public function set mountId(value:int):void {
			hasField$0 |= 0x800;
			mount_id$field = value;
		}

		public function get mountId():int {
			return mount_id$field;
		}

		/**
		 *  @private
		 */
		public static const NAME_COLOR:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.name_color", "nameColor", (21 << 3) | com.netease.protobuf.WireType.VARINT);

		private var name_color$field:int;

		public function clearNameColor():void {
			hasField$0 &= 0xffffefff;
			name_color$field = new int();
		}

		public function get hasNameColor():Boolean {
			return (hasField$0 & 0x1000) != 0;
		}

		public function set nameColor(value:int):void {
			hasField$0 |= 0x1000;
			name_color$field = value;
		}

		public function get nameColor():int {
			return name_color$field;
		}

		/**
		 *  @private
		 */
		public static const IS_STEATH:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.mapScene.OtherRoleInfo.is_steath", "isSteath", (22 << 3) | com.netease.protobuf.WireType.VARINT);

		private var is_steath$field:Boolean;

		public function clearIsSteath():void {
			hasField$0 &= 0xffffdfff;
			is_steath$field = new Boolean();
		}

		public function get hasIsSteath():Boolean {
			return (hasField$0 & 0x2000) != 0;
		}

		public function set isSteath(value:Boolean):void {
			hasField$0 |= 0x2000;
			is_steath$field = value;
		}

		public function get isSteath():Boolean {
			return is_steath$field;
		}

		/**
		 *  @private
		 */
		public static const TITLE_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.title_id", "titleId", (23 << 3) | com.netease.protobuf.WireType.VARINT);

		private var title_id$field:int;

		public function clearTitleId():void {
			hasField$0 &= 0xffffbfff;
			title_id$field = new int();
		}

		public function get hasTitleId():Boolean {
			return (hasField$0 & 0x4000) != 0;
		}

		public function set titleId(value:int):void {
			hasField$0 |= 0x4000;
			title_id$field = value;
		}

		public function get titleId():int {
			return title_id$field;
		}

		/**
		 *  @private
		 */
		public static const CAMP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.camp", "camp", (24 << 3) | com.netease.protobuf.WireType.VARINT);

		private var camp$field:int;

		public function clearCamp():void {
			hasField$0 &= 0xffff7fff;
			camp$field = new int();
		}

		public function get hasCamp():Boolean {
			return (hasField$0 & 0x8000) != 0;
		}

		public function set camp(value:int):void {
			hasField$0 |= 0x8000;
			camp$field = value;
		}

		public function get camp():int {
			return camp$field;
		}

		/**
		 *  @private
		 */
		public static const VIP_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.vip_level", "vipLevel", (25 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_level$field:int;

		public function clearVipLevel():void {
			hasField$0 &= 0xfffeffff;
			vip_level$field = new int();
		}

		public function get hasVipLevel():Boolean {
			return (hasField$0 & 0x10000) != 0;
		}

		public function set vipLevel(value:int):void {
			hasField$0 |= 0x10000;
			vip_level$field = value;
		}

		public function get vipLevel():int {
			return vip_level$field;
		}

		/**
		 *  @private
		 */
		public static const VIP_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.OtherRoleInfo.vip_type", "vipType", (26 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_type$field:int;

		public function clearVipType():void {
			hasField$0 &= 0xfffdffff;
			vip_type$field = new int();
		}

		public function get hasVipType():Boolean {
			return (hasField$0 & 0x20000) != 0;
		}

		public function set vipType(value:int):void {
			hasField$0 |= 0x20000;
			vip_type$field = value;
		}

		public function get vipType():int {
			return vip_type$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.dyId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mapPos);
			if (hasName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, name$field);
			}
			if (hasEquipInfo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, equip_info$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.playerType);
			if (hasState) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, state$field);
			}
			if (hasSex) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, sex$field);
			}
			if (hasBasicId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, basic_id$field);
			}
			if (hasHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, hp$field);
			}
			if (hasHpMax) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, hp_max$field);
			}
			if (hasMp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mp$field);
			}
			if (hasMpMax) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mp_max$field);
			}
			if (hasLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, level$field);
			}
			for (var buffIdArr$index:uint = 0; buffIdArr$index < this.buffIdArr.length; ++buffIdArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.buffIdArr[buffIdArr$index]);
			}
			if (hasCareer) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 16);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, career$field);
			}
			if (hasItemType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 17);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, item_type$field);
			}
			if (hasOwnerId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 18);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, owner_id$field);
			}
			if (hasMountId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 19);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mount_id$field);
			}
			if (hasNameColor) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 21);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, name_color$field);
			}
			if (hasIsSteath) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 22);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, is_steath$field);
			}
			if (hasTitleId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 23);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, title_id$field);
			}
			if (hasCamp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 24);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, camp$field);
			}
			if (hasVipLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 25);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_level$field);
			}
			if (hasVipType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 26);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_type$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dy_id$count:uint = 0;
			var map_pos$count:uint = 0;
			var name$count:uint = 0;
			var equip_info$count:uint = 0;
			var player_type$count:uint = 0;
			var state$count:uint = 0;
			var sex$count:uint = 0;
			var basic_id$count:uint = 0;
			var hp$count:uint = 0;
			var hp_max$count:uint = 0;
			var mp$count:uint = 0;
			var mp_max$count:uint = 0;
			var level$count:uint = 0;
			var career$count:uint = 0;
			var item_type$count:uint = 0;
			var owner_id$count:uint = 0;
			var mount_id$count:uint = 0;
			var name_color$count:uint = 0;
			var is_steath$count:uint = 0;
			var title_id$count:uint = 0;
			var camp$count:uint = 0;
			var vip_level$count:uint = 0;
			var vip_type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dy_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.dyId cannot be set twice.');
					}
					++dy_id$count;
					this.dyId = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 2:
					if (map_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.mapPos cannot be set twice.');
					}
					++map_pos$count;
					this.mapPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 5:
					if (equip_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.equipInfo cannot be set twice.');
					}
					++equip_info$count;
					this.equipInfo = new com.msg.mapScene.EquipInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.equipInfo);
					break;
				case 6:
					if (player_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.playerType cannot be set twice.');
					}
					++player_type$count;
					this.playerType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (state$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.state cannot be set twice.');
					}
					++state$count;
					this.state = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (sex$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.sex cannot be set twice.');
					}
					++sex$count;
					this.sex = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (basic_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.basicId cannot be set twice.');
					}
					++basic_id$count;
					this.basicId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 10:
					if (hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.hp cannot be set twice.');
					}
					++hp$count;
					this.hp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 11:
					if (hp_max$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.hpMax cannot be set twice.');
					}
					++hp_max$count;
					this.hpMax = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 12:
					if (mp$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.mp cannot be set twice.');
					}
					++mp$count;
					this.mp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 13:
					if (mp_max$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.mpMax cannot be set twice.');
					}
					++mp_max$count;
					this.mpMax = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 14:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 15:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_INT32, this.buffIdArr);
						break;
					}
					this.buffIdArr.push(com.netease.protobuf.ReadUtils.read$TYPE_INT32(input));
					break;
				case 16:
					if (career$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.career cannot be set twice.');
					}
					++career$count;
					this.career = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 17:
					if (item_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.itemType cannot be set twice.');
					}
					++item_type$count;
					this.itemType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 18:
					if (owner_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.ownerId cannot be set twice.');
					}
					++owner_id$count;
					this.ownerId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 19:
					if (mount_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.mountId cannot be set twice.');
					}
					++mount_id$count;
					this.mountId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 21:
					if (name_color$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.nameColor cannot be set twice.');
					}
					++name_color$count;
					this.nameColor = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 22:
					if (is_steath$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.isSteath cannot be set twice.');
					}
					++is_steath$count;
					this.isSteath = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 23:
					if (title_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.titleId cannot be set twice.');
					}
					++title_id$count;
					this.titleId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 24:
					if (camp$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.camp cannot be set twice.');
					}
					++camp$count;
					this.camp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 25:
					if (vip_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.vipLevel cannot be set twice.');
					}
					++vip_level$count;
					this.vipLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 26:
					if (vip_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: OtherRoleInfo.vipType cannot be set twice.');
					}
					++vip_type$count;
					this.vipType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
