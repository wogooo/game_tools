package com.msg.mapScene {
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
	public dynamic final class EquipInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CLOTH_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.EquipInfo.cloth_id", "clothId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var clothId:int;

		/**
		 *  @private
		 */
		public static const WEAPON_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.EquipInfo.weapon_id", "weaponId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var weaponId:int;

		/**
		 *  @private
		 */
		public static const WING_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.EquipInfo.wing_id", "wingId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var wingId:int;

		/**
		 *  @private
		 */
		public static const CLOTH_ENHANCE_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.EquipInfo.cloth_enhance_level", "clothEnhanceLevel", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var cloth_enhance_level$field:int;

		private var hasField$0:uint = 0;

		public function clearClothEnhanceLevel():void {
			hasField$0 &= 0xfffffffe;
			cloth_enhance_level$field = new int();
		}

		public function get hasClothEnhanceLevel():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set clothEnhanceLevel(value:int):void {
			hasField$0 |= 0x1;
			cloth_enhance_level$field = value;
		}

		public function get clothEnhanceLevel():int {
			return cloth_enhance_level$field;
		}

		/**
		 *  @private
		 */
		public static const WEAPON_ENHANCE_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.EquipInfo.weapon_enhance_level", "weaponEnhanceLevel", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var weapon_enhance_level$field:int;

		public function clearWeaponEnhanceLevel():void {
			hasField$0 &= 0xfffffffd;
			weapon_enhance_level$field = new int();
		}

		public function get hasWeaponEnhanceLevel():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set weaponEnhanceLevel(value:int):void {
			hasField$0 |= 0x2;
			weapon_enhance_level$field = value;
		}

		public function get weaponEnhanceLevel():int {
			return weapon_enhance_level$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.clothId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.weaponId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.wingId);
			if (hasClothEnhanceLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, cloth_enhance_level$field);
			}
			if (hasWeaponEnhanceLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, weapon_enhance_level$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var cloth_id$count:uint = 0;
			var weapon_id$count:uint = 0;
			var wing_id$count:uint = 0;
			var cloth_enhance_level$count:uint = 0;
			var weapon_enhance_level$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (cloth_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipInfo.clothId cannot be set twice.');
					}
					++cloth_id$count;
					this.clothId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (weapon_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipInfo.weaponId cannot be set twice.');
					}
					++weapon_id$count;
					this.weaponId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (wing_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipInfo.wingId cannot be set twice.');
					}
					++wing_id$count;
					this.wingId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (cloth_enhance_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipInfo.clothEnhanceLevel cannot be set twice.');
					}
					++cloth_enhance_level$count;
					this.clothEnhanceLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (weapon_enhance_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: EquipInfo.weaponEnhanceLevel cannot be set twice.');
					}
					++weapon_enhance_level$count;
					this.weaponEnhanceLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
