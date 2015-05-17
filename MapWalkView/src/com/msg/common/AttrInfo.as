package com.msg.common {
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
	public dynamic final class AttrInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ATTR_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.common.AttrInfo.attr_id", "attrId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var attrId:int;

		/**
		 *  @private
		 */
		public static const ATTR_VALUE:FieldDescriptor$TYPE_FLOAT = new FieldDescriptor$TYPE_FLOAT("com.msg.common.AttrInfo.attr_value", "attrValue", (2 << 3) | com.netease.protobuf.WireType.FIXED_32_BIT);

		public var attrValue:Number;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.attrId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_32_BIT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_FLOAT(output, this.attrValue);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var attr_id$count:uint = 0;
			var attr_value$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (attr_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: AttrInfo.attrId cannot be set twice.');
					}
					++attr_id$count;
					this.attrId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (attr_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: AttrInfo.attrValue cannot be set twice.');
					}
					++attr_value$count;
					this.attrValue = com.netease.protobuf.ReadUtils.read$TYPE_FLOAT(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
