package com.msg.item {
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
	public dynamic final class SModifyEquipCurDurab extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const EQUIP_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipCurDurab.equip_id", "equipId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var equipId:int;

		/**
		 *  @private
		 */
		public static const CUR_DURABILITY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipCurDurab.cur_durability", "curDurability", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var curDurability:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.equipId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.curDurability);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var equip_id$count:uint = 0;
			var cur_durability$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (equip_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipCurDurab.equipId cannot be set twice.');
					}
					++equip_id$count;
					this.equipId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (cur_durability$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipCurDurab.curDurability cannot be set twice.');
					}
					++cur_durability$count;
					this.curDurability = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
