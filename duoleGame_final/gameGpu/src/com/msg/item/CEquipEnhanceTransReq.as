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
	public dynamic final class CEquipEnhanceTransReq extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SOURCE_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CEquipEnhanceTransReq.source_pos", "sourcePos", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var sourcePos:int;

		/**
		 *  @private
		 */
		public static const TARGET_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CEquipEnhanceTransReq.target_pos", "targetPos", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var targetPos:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.sourcePos);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.targetPos);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var source_pos$count:uint = 0;
			var target_pos$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (source_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CEquipEnhanceTransReq.sourcePos cannot be set twice.');
					}
					++source_pos$count;
					this.sourcePos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (target_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CEquipEnhanceTransReq.targetPos cannot be set twice.');
					}
					++target_pos$count;
					this.targetPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
