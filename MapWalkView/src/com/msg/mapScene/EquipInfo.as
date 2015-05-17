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
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.clothId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.weaponId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.wingId);
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
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
