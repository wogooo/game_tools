package com.msg.rank_pro {
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
	public dynamic final class RankInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RANK_ORDER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.rank_order", "rankOrder", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var rankOrder:int;

		/**
		 *  @private
		 */
		public static const PLAYER_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.rank_pro.RankInfo.player_name", "playerName", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var playerName:String;

		/**
		 *  @private
		 */
		public static const RANK_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.rank_value", "rankValue", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var rankValue:int;

		/**
		 *  @private
		 */
		public static const CHARACTER_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.character_id", "characterId", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var character_id$field:int;

		private var hasField$0:uint = 0;

		public function clearCharacterId():void {
			hasField$0 &= 0xfffffffe;
			character_id$field = new int();
		}

		public function get hasCharacterId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set characterId(value:int):void {
			hasField$0 |= 0x1;
			character_id$field = value;
		}

		public function get characterId():int {
			return character_id$field;
		}

		/**
		 *  @private
		 */
		public static const PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.pet_id", "petId", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var pet_id$field:int;

		public function clearPetId():void {
			hasField$0 &= 0xfffffffd;
			pet_id$field = new int();
		}

		public function get hasPetId():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set petId(value:int):void {
			hasField$0 |= 0x2;
			pet_id$field = value;
		}

		public function get petId():int {
			return pet_id$field;
		}

		/**
		 *  @private
		 */
		public static const PET_CONFIG_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.pet_config_id", "petConfigId", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var pet_config_id$field:int;

		public function clearPetConfigId():void {
			hasField$0 &= 0xfffffffb;
			pet_config_id$field = new int();
		}

		public function get hasPetConfigId():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set petConfigId(value:int):void {
			hasField$0 |= 0x4;
			pet_config_id$field = value;
		}

		public function get petConfigId():int {
			return pet_config_id$field;
		}

		/**
		 *  @private
		 */
		public static const PLAYER_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.player_level", "playerLevel", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var player_level$field:int;

		public function clearPlayerLevel():void {
			hasField$0 &= 0xfffffff7;
			player_level$field = new int();
		}

		public function get hasPlayerLevel():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set playerLevel(value:int):void {
			hasField$0 |= 0x8;
			player_level$field = value;
		}

		public function get playerLevel():int {
			return player_level$field;
		}

		/**
		 *  @private
		 */
		public static const PET_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.pet_level", "petLevel", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var pet_level$field:int;

		public function clearPetLevel():void {
			hasField$0 &= 0xffffffef;
			pet_level$field = new int();
		}

		public function get hasPetLevel():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set petLevel(value:int):void {
			hasField$0 |= 0x10;
			pet_level$field = value;
		}

		public function get petLevel():int {
			return pet_level$field;
		}

		/**
		 *  @private
		 */
		public static const PLAYER_CAREER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.player_career", "playerCareer", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var player_career$field:int;

		public function clearPlayerCareer():void {
			hasField$0 &= 0xffffffdf;
			player_career$field = new int();
		}

		public function get hasPlayerCareer():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set playerCareer(value:int):void {
			hasField$0 |= 0x20;
			player_career$field = value;
		}

		public function get playerCareer():int {
			return player_career$field;
		}

		/**
		 *  @private
		 */
		public static const GUILD_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.rank_pro.RankInfo.guild_name", "guildName", (10 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var guildName:String;

		/**
		 *  @private
		 */
		public static const VIP_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.vip_level", "vipLevel", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_level$field:int;

		public function clearVipLevel():void {
			hasField$0 &= 0xffffffbf;
			vip_level$field = new int();
		}

		public function get hasVipLevel():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set vipLevel(value:int):void {
			hasField$0 |= 0x40;
			vip_level$field = value;
		}

		public function get vipLevel():int {
			return vip_level$field;
		}

		/**
		 *  @private
		 */
		public static const VIP_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.vip_type", "vipType", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vip_type$field:int;

		public function clearVipType():void {
			hasField$0 &= 0xffffff7f;
			vip_type$field = new int();
		}

		public function get hasVipType():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set vipType(value:int):void {
			hasField$0 |= 0x80;
			vip_type$field = value;
		}

		public function get vipType():int {
			return vip_type$field;
		}

		/**
		 *  @private
		 */
		public static const TITLE_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.RankInfo.title_id", "titleId", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var title_id$field:int;

		public function clearTitleId():void {
			hasField$0 &= 0xfffffeff;
			title_id$field = new int();
		}

		public function get hasTitleId():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set titleId(value:int):void {
			hasField$0 |= 0x100;
			title_id$field = value;
		}

		public function get titleId():int {
			return title_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.rankOrder);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.playerName);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.rankValue);
			if (hasCharacterId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, character_id$field);
			}
			if (hasPetId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, pet_id$field);
			}
			if (hasPetConfigId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, pet_config_id$field);
			}
			if (hasPlayerLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, player_level$field);
			}
			if (hasPetLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, pet_level$field);
			}
			if (hasPlayerCareer) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, player_career$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 10);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.guildName);
			if (hasVipLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_level$field);
			}
			if (hasVipType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, vip_type$field);
			}
			if (hasTitleId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, title_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var rank_order$count:uint = 0;
			var player_name$count:uint = 0;
			var rank_value$count:uint = 0;
			var character_id$count:uint = 0;
			var pet_id$count:uint = 0;
			var pet_config_id$count:uint = 0;
			var player_level$count:uint = 0;
			var pet_level$count:uint = 0;
			var player_career$count:uint = 0;
			var guild_name$count:uint = 0;
			var vip_level$count:uint = 0;
			var vip_type$count:uint = 0;
			var title_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (rank_order$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.rankOrder cannot be set twice.');
					}
					++rank_order$count;
					this.rankOrder = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (player_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.playerName cannot be set twice.');
					}
					++player_name$count;
					this.playerName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (rank_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.rankValue cannot be set twice.');
					}
					++rank_value$count;
					this.rankValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (character_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.characterId cannot be set twice.');
					}
					++character_id$count;
					this.characterId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.petId cannot be set twice.');
					}
					++pet_id$count;
					this.petId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (pet_config_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.petConfigId cannot be set twice.');
					}
					++pet_config_id$count;
					this.petConfigId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (player_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.playerLevel cannot be set twice.');
					}
					++player_level$count;
					this.playerLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (pet_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.petLevel cannot be set twice.');
					}
					++pet_level$count;
					this.petLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (player_career$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.playerCareer cannot be set twice.');
					}
					++player_career$count;
					this.playerCareer = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 10:
					if (guild_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.guildName cannot be set twice.');
					}
					++guild_name$count;
					this.guildName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 11:
					if (vip_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.vipLevel cannot be set twice.');
					}
					++vip_level$count;
					this.vipLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 12:
					if (vip_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.vipType cannot be set twice.');
					}
					++vip_type$count;
					this.vipType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 13:
					if (title_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RankInfo.titleId cannot be set twice.');
					}
					++title_id$count;
					this.titleId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
