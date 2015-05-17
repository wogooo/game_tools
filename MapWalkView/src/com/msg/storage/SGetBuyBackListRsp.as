package com.msg.storage {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.storage.Cell;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SGetBuyBackListRsp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CELL:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.storage.SGetBuyBackListRsp.cell", "cell", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.storage.Cell; });

		[ArrayElementType("com.msg.storage.Cell")]
		public var cell:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var cell$index:uint = 0; cell$index < this.cell.length; ++cell$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.cell[cell$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.cell.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.storage.Cell()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
