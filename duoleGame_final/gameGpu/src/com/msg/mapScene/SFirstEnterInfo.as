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
	public dynamic final class SFirstEnterInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const EQUIP_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.mapScene.SFirstEnterInfo.equip_info", "equipInfo", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.mapScene.EquipInfo; });

		public var equipInfo:com.msg.mapScene.EquipInfo;

		/**
		 *  @private
		 */
		public static const STATE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SFirstEnterInfo.state", "state", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var state:int;

		/**
		 *  @private
		 */
		public static const MOUNT_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SFirstEnterInfo.mount_id", "mountId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mount_id$field:int;

		private var hasField$0:uint = 0;

		public function clearMountId():void {
			hasField$0 &= 0xfffffffe;
			mount_id$field = new int();
		}

		public function get hasMountId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set mountId(value:int):void {
			hasField$0 |= 0x1;
			mount_id$field = value;
		}

		public function get mountId():int {
			return mount_id$field;
		}

		/**
		 *  @private
		 */
		public static const NAME_COLOR:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SFirstEnterInfo.name_color", "nameColor", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var nameColor:int;

		/**
		 *  @private
		 */
		public static const COMPETE_TARGET:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SFirstEnterInfo.compete_target", "competeTarget", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var compete_target$field:int;

		public function clearCompeteTarget():void {
			hasField$0 &= 0xfffffffd;
			compete_target$field = new int();
		}

		public function get hasCompeteTarget():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set competeTarget(value:int):void {
			hasField$0 |= 0x2;
			compete_target$field = value;
		}

		public function get competeTarget():int {
			return compete_target$field;
		}

		/**
		 *  @private
		 */
		public static const HP_POOL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SFirstEnterInfo.hp_pool", "hpPool", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var hpPool:int;

		/**
		 *  @private
		 */
		public static const MP_POOL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SFirstEnterInfo.mp_pool", "mpPool", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mpPool:int;

		/**
		 *  @private
		 */
		public static const PET_HP_POOL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SFirstEnterInfo.pet_hp_pool", "petHpPool", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		public var petHpPool:int;

		/**
		 *  @private
		 */
		public static const MAGIC_SOUL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SFirstEnterInfo.magic_soul", "magicSoul", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		public var magicSoul:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.equipInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.state);
			if (hasMountId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mount_id$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.nameColor);
			if (hasCompeteTarget) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, compete_target$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.hpPool);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mpPool);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.petHpPool);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.magicSoul);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var equip_info$count:uint = 0;
			var state$count:uint = 0;
			var mount_id$count:uint = 0;
			var name_color$count:uint = 0;
			var compete_target$count:uint = 0;
			var hp_pool$count:uint = 0;
			var mp_pool$count:uint = 0;
			var pet_hp_pool$count:uint = 0;
			var magic_soul$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (equip_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFirstEnterInfo.equipInfo cannot be set twice.');
					}
					++equip_info$count;
					this.equipInfo = new com.msg.mapScene.EquipInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.equipInfo);
					break;
				case 2:
					if (state$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFirstEnterInfo.state cannot be set twice.');
					}
					++state$count;
					this.state = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (mount_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFirstEnterInfo.mountId cannot be set twice.');
					}
					++mount_id$count;
					this.mountId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (name_color$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFirstEnterInfo.nameColor cannot be set twice.');
					}
					++name_color$count;
					this.nameColor = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (compete_target$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFirstEnterInfo.competeTarget cannot be set twice.');
					}
					++compete_target$count;
					this.competeTarget = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (hp_pool$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFirstEnterInfo.hpPool cannot be set twice.');
					}
					++hp_pool$count;
					this.hpPool = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (mp_pool$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFirstEnterInfo.mpPool cannot be set twice.');
					}
					++mp_pool$count;
					this.mpPool = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (pet_hp_pool$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFirstEnterInfo.petHpPool cannot be set twice.');
					}
					++pet_hp_pool$count;
					this.petHpPool = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 10:
					if (magic_soul$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFirstEnterInfo.magicSoul cannot be set twice.');
					}
					++magic_soul$count;
					this.magicSoul = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
