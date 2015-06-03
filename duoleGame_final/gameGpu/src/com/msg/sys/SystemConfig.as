package com.msg.sys {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SystemConfig extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SHIELD_EFF:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.shield_eff", "shieldEff", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var shield_eff$field:Boolean;

		private var hasField$0:uint = 0;

		public function clearShieldEff():void {
			hasField$0 &= 0xfffffffe;
			shield_eff$field = new Boolean();
		}

		public function get hasShieldEff():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set shieldEff(value:Boolean):void {
			hasField$0 |= 0x1;
			shield_eff$field = value;
		}

		public function get shieldEff():Boolean {
			if(!hasShieldEff) {
				return false;
			}
			return shield_eff$field;
		}

		/**
		 *  @private
		 */
		public static const SHIELD_HP:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.shield_hp", "shieldHp", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var shield_hp$field:Boolean;

		public function clearShieldHp():void {
			hasField$0 &= 0xfffffffd;
			shield_hp$field = new Boolean();
		}

		public function get hasShieldHp():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set shieldHp(value:Boolean):void {
			hasField$0 |= 0x2;
			shield_hp$field = value;
		}

		public function get shieldHp():Boolean {
			if(!hasShieldHp) {
				return false;
			}
			return shield_hp$field;
		}

		/**
		 *  @private
		 */
		public static const SHIELD_OTHER_HERO:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.shield_other_hero", "shieldOtherHero", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var shield_other_hero$field:Boolean;

		public function clearShieldOtherHero():void {
			hasField$0 &= 0xfffffffb;
			shield_other_hero$field = new Boolean();
		}

		public function get hasShieldOtherHero():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set shieldOtherHero(value:Boolean):void {
			hasField$0 |= 0x4;
			shield_other_hero$field = value;
		}

		public function get shieldOtherHero():Boolean {
			if(!hasShieldOtherHero) {
				return false;
			}
			return shield_other_hero$field;
		}

		/**
		 *  @private
		 */
		public static const SHIELD_OTHER_PET:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.shield_other_pet", "shieldOtherPet", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var shield_other_pet$field:Boolean;

		public function clearShieldOtherPet():void {
			hasField$0 &= 0xfffffff7;
			shield_other_pet$field = new Boolean();
		}

		public function get hasShieldOtherPet():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set shieldOtherPet(value:Boolean):void {
			hasField$0 |= 0x8;
			shield_other_pet$field = value;
		}

		public function get shieldOtherPet():Boolean {
			if(!hasShieldOtherPet) {
				return false;
			}
			return shield_other_pet$field;
		}

		/**
		 *  @private
		 */
		public static const NOT_SELECT_PET:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.not_select_pet", "notSelectPet", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var not_select_pet$field:Boolean;

		public function clearNotSelectPet():void {
			hasField$0 &= 0xffffffef;
			not_select_pet$field = new Boolean();
		}

		public function get hasNotSelectPet():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set notSelectPet(value:Boolean):void {
			hasField$0 |= 0x10;
			not_select_pet$field = value;
		}

		public function get notSelectPet():Boolean {
			if(!hasNotSelectPet) {
				return false;
			}
			return not_select_pet$field;
		}

		/**
		 *  @private
		 */
		public static const SHOW_COMPARE:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.show_compare", "showCompare", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var show_compare$field:Boolean;

		public function clearShowCompare():void {
			hasField$0 &= 0xffffffdf;
			show_compare$field = new Boolean();
		}

		public function get hasShowCompare():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set showCompare(value:Boolean):void {
			hasField$0 |= 0x20;
			show_compare$field = value;
		}

		public function get showCompare():Boolean {
			if(!hasShowCompare) {
				return true;
			}
			return show_compare$field;
		}

		/**
		 *  @private
		 */
		public static const SHOW_TITLE:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.show_title", "showTitle", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var show_title$field:Boolean;

		public function clearShowTitle():void {
			hasField$0 &= 0xffffffbf;
			show_title$field = new Boolean();
		}

		public function get hasShowTitle():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set showTitle(value:Boolean):void {
			hasField$0 |= 0x40;
			show_title$field = value;
		}

		public function get showTitle():Boolean {
			if(!hasShowTitle) {
				return true;
			}
			return show_title$field;
		}

		/**
		 *  @private
		 */
		public static const REJECT_PK:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.reject_pk", "rejectPk", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var reject_pk$field:Boolean;

		public function clearRejectPk():void {
			hasField$0 &= 0xffffff7f;
			reject_pk$field = new Boolean();
		}

		public function get hasRejectPk():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set rejectPk(value:Boolean):void {
			hasField$0 |= 0x80;
			reject_pk$field = value;
		}

		public function get rejectPk():Boolean {
			if(!hasRejectPk) {
				return false;
			}
			return reject_pk$field;
		}

		/**
		 *  @private
		 */
		public static const REJECT_TRADE:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.reject_trade", "rejectTrade", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var reject_trade$field:Boolean;

		public function clearRejectTrade():void {
			hasField$0 &= 0xfffffeff;
			reject_trade$field = new Boolean();
		}

		public function get hasRejectTrade():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set rejectTrade(value:Boolean):void {
			hasField$0 |= 0x100;
			reject_trade$field = value;
		}

		public function get rejectTrade():Boolean {
			if(!hasRejectTrade) {
				return false;
			}
			return reject_trade$field;
		}

		/**
		 *  @private
		 */
		public static const REJECT_TEAM:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.reject_team", "rejectTeam", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var reject_team$field:Boolean;

		public function clearRejectTeam():void {
			hasField$0 &= 0xfffffdff;
			reject_team$field = new Boolean();
		}

		public function get hasRejectTeam():Boolean {
			return (hasField$0 & 0x200) != 0;
		}

		public function set rejectTeam(value:Boolean):void {
			hasField$0 |= 0x200;
			reject_team$field = value;
		}

		public function get rejectTeam():Boolean {
			if(!hasRejectTeam) {
				return false;
			}
			return reject_team$field;
		}

		/**
		 *  @private
		 */
		public static const REJECT_FRIEND:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.reject_friend", "rejectFriend", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var reject_friend$field:Boolean;

		public function clearRejectFriend():void {
			hasField$0 &= 0xfffffbff;
			reject_friend$field = new Boolean();
		}

		public function get hasRejectFriend():Boolean {
			return (hasField$0 & 0x400) != 0;
		}

		public function set rejectFriend(value:Boolean):void {
			hasField$0 |= 0x400;
			reject_friend$field = value;
		}

		public function get rejectFriend():Boolean {
			if(!hasRejectFriend) {
				return false;
			}
			return reject_friend$field;
		}

		/**
		 *  @private
		 */
		public static const REJECT_TALK:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.reject_talk", "rejectTalk", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var reject_talk$field:Boolean;

		public function clearRejectTalk():void {
			hasField$0 &= 0xfffff7ff;
			reject_talk$field = new Boolean();
		}

		public function get hasRejectTalk():Boolean {
			return (hasField$0 & 0x800) != 0;
		}

		public function set rejectTalk(value:Boolean):void {
			hasField$0 |= 0x800;
			reject_talk$field = value;
		}

		public function get rejectTalk():Boolean {
			if(!hasRejectTalk) {
				return false;
			}
			return reject_talk$field;
		}

		/**
		 *  @private
		 */
		public static const REJECT_GUILD:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.reject_guild", "rejectGuild", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var reject_guild$field:Boolean;

		public function clearRejectGuild():void {
			hasField$0 &= 0xffffefff;
			reject_guild$field = new Boolean();
		}

		public function get hasRejectGuild():Boolean {
			return (hasField$0 & 0x1000) != 0;
		}

		public function set rejectGuild(value:Boolean):void {
			hasField$0 |= 0x1000;
			reject_guild$field = value;
		}

		public function get rejectGuild():Boolean {
			if(!hasRejectGuild) {
				return false;
			}
			return reject_guild$field;
		}

		/**
		 *  @private
		 */
		public static const SHOW_ITEM_NAME:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.show_item_name", "showItemName", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var show_item_name$field:Boolean;

		public function clearShowItemName():void {
			hasField$0 &= 0xffffdfff;
			show_item_name$field = new Boolean();
		}

		public function get hasShowItemName():Boolean {
			return (hasField$0 & 0x2000) != 0;
		}

		public function set showItemName(value:Boolean):void {
			hasField$0 |= 0x2000;
			show_item_name$field = value;
		}

		public function get showItemName():Boolean {
			if(!hasShowItemName) {
				return true;
			}
			return show_item_name$field;
		}

		/**
		 *  @private
		 */
		public static const ENABLE_BGM:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.enable_bgm", "enableBgm", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		private var enable_bgm$field:Boolean;

		public function clearEnableBgm():void {
			hasField$0 &= 0xffffbfff;
			enable_bgm$field = new Boolean();
		}

		public function get hasEnableBgm():Boolean {
			return (hasField$0 & 0x4000) != 0;
		}

		public function set enableBgm(value:Boolean):void {
			hasField$0 |= 0x4000;
			enable_bgm$field = value;
		}

		public function get enableBgm():Boolean {
			if(!hasEnableBgm) {
				return true;
			}
			return enable_bgm$field;
		}

		/**
		 *  @private
		 */
		public static const ENABLE_SOUND:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.sys.SystemConfig.enable_sound", "enableSound", (16 << 3) | com.netease.protobuf.WireType.VARINT);

		private var enable_sound$field:Boolean;

		public function clearEnableSound():void {
			hasField$0 &= 0xffff7fff;
			enable_sound$field = new Boolean();
		}

		public function get hasEnableSound():Boolean {
			return (hasField$0 & 0x8000) != 0;
		}

		public function set enableSound(value:Boolean):void {
			hasField$0 |= 0x8000;
			enable_sound$field = value;
		}

		public function get enableSound():Boolean {
			if(!hasEnableSound) {
				return true;
			}
			return enable_sound$field;
		}

		/**
		 *  @private
		 */
		public static const BGM_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.sys.SystemConfig.bgm_value", "bgmValue", (17 << 3) | com.netease.protobuf.WireType.VARINT);

		private var bgm_value$field:int;

		public function clearBgmValue():void {
			hasField$0 &= 0xfffeffff;
			bgm_value$field = new int();
		}

		public function get hasBgmValue():Boolean {
			return (hasField$0 & 0x10000) != 0;
		}

		public function set bgmValue(value:int):void {
			hasField$0 |= 0x10000;
			bgm_value$field = value;
		}

		public function get bgmValue():int {
			if(!hasBgmValue) {
				return 50;
			}
			return bgm_value$field;
		}

		/**
		 *  @private
		 */
		public static const SOUND_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.sys.SystemConfig.sound_value", "soundValue", (18 << 3) | com.netease.protobuf.WireType.VARINT);

		private var sound_value$field:int;

		public function clearSoundValue():void {
			hasField$0 &= 0xfffdffff;
			sound_value$field = new int();
		}

		public function get hasSoundValue():Boolean {
			return (hasField$0 & 0x20000) != 0;
		}

		public function set soundValue(value:int):void {
			hasField$0 |= 0x20000;
			sound_value$field = value;
		}

		public function get soundValue():int {
			if(!hasSoundValue) {
				return 50;
			}
			return sound_value$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasShieldEff) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, shield_eff$field);
			}
			if (hasShieldHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, shield_hp$field);
			}
			if (hasShieldOtherHero) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, shield_other_hero$field);
			}
			if (hasShieldOtherPet) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, shield_other_pet$field);
			}
			if (hasNotSelectPet) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, not_select_pet$field);
			}
			if (hasShowCompare) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, show_compare$field);
			}
			if (hasShowTitle) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, show_title$field);
			}
			if (hasRejectPk) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, reject_pk$field);
			}
			if (hasRejectTrade) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, reject_trade$field);
			}
			if (hasRejectTeam) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, reject_team$field);
			}
			if (hasRejectFriend) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, reject_friend$field);
			}
			if (hasRejectTalk) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, reject_talk$field);
			}
			if (hasRejectGuild) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, reject_guild$field);
			}
			if (hasShowItemName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, show_item_name$field);
			}
			if (hasEnableBgm) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, enable_bgm$field);
			}
			if (hasEnableSound) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 16);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, enable_sound$field);
			}
			if (hasBgmValue) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 17);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, bgm_value$field);
			}
			if (hasSoundValue) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 18);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, sound_value$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var shield_eff$count:uint = 0;
			var shield_hp$count:uint = 0;
			var shield_other_hero$count:uint = 0;
			var shield_other_pet$count:uint = 0;
			var not_select_pet$count:uint = 0;
			var show_compare$count:uint = 0;
			var show_title$count:uint = 0;
			var reject_pk$count:uint = 0;
			var reject_trade$count:uint = 0;
			var reject_team$count:uint = 0;
			var reject_friend$count:uint = 0;
			var reject_talk$count:uint = 0;
			var reject_guild$count:uint = 0;
			var show_item_name$count:uint = 0;
			var enable_bgm$count:uint = 0;
			var enable_sound$count:uint = 0;
			var bgm_value$count:uint = 0;
			var sound_value$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (shield_eff$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.shieldEff cannot be set twice.');
					}
					++shield_eff$count;
					this.shieldEff = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 2:
					if (shield_hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.shieldHp cannot be set twice.');
					}
					++shield_hp$count;
					this.shieldHp = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 3:
					if (shield_other_hero$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.shieldOtherHero cannot be set twice.');
					}
					++shield_other_hero$count;
					this.shieldOtherHero = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 4:
					if (shield_other_pet$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.shieldOtherPet cannot be set twice.');
					}
					++shield_other_pet$count;
					this.shieldOtherPet = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 5:
					if (not_select_pet$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.notSelectPet cannot be set twice.');
					}
					++not_select_pet$count;
					this.notSelectPet = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 6:
					if (show_compare$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.showCompare cannot be set twice.');
					}
					++show_compare$count;
					this.showCompare = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 7:
					if (show_title$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.showTitle cannot be set twice.');
					}
					++show_title$count;
					this.showTitle = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 8:
					if (reject_pk$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.rejectPk cannot be set twice.');
					}
					++reject_pk$count;
					this.rejectPk = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 9:
					if (reject_trade$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.rejectTrade cannot be set twice.');
					}
					++reject_trade$count;
					this.rejectTrade = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 10:
					if (reject_team$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.rejectTeam cannot be set twice.');
					}
					++reject_team$count;
					this.rejectTeam = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 11:
					if (reject_friend$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.rejectFriend cannot be set twice.');
					}
					++reject_friend$count;
					this.rejectFriend = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 12:
					if (reject_talk$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.rejectTalk cannot be set twice.');
					}
					++reject_talk$count;
					this.rejectTalk = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 13:
					if (reject_guild$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.rejectGuild cannot be set twice.');
					}
					++reject_guild$count;
					this.rejectGuild = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 14:
					if (show_item_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.showItemName cannot be set twice.');
					}
					++show_item_name$count;
					this.showItemName = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 15:
					if (enable_bgm$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.enableBgm cannot be set twice.');
					}
					++enable_bgm$count;
					this.enableBgm = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 16:
					if (enable_sound$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.enableSound cannot be set twice.');
					}
					++enable_sound$count;
					this.enableSound = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 17:
					if (bgm_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.bgmValue cannot be set twice.');
					}
					++bgm_value$count;
					this.bgmValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 18:
					if (sound_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: SystemConfig.soundValue cannot be set twice.');
					}
					++sound_value$count;
					this.soundValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
