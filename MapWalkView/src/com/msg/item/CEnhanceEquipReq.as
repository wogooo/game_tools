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
	public dynamic final class CEnhanceEquipReq extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CEnhanceEquipReq.pos", "pos", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var pos:int;

		/**
		 *  @private
		 */
		public static const STONE_NUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CEnhanceEquipReq.stone_num", "stoneNum", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var stoneNum:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.pos);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.stoneNum);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var pos$count:uint = 0;
			var stone_num$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CEnhanceEquipReq.pos cannot be set twice.');
					}
					++pos$count;
					this.pos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (stone_num$count != 0) {
						throw new flash.errors.IOError('Bad data format: CEnhanceEquipReq.stoneNum cannot be set twice.');
					}
					++stone_num$count;
					this.stoneNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
