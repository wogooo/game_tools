package com.msg.market_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.market_pro.Condition;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CSearchSaleList extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const COND:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.market_pro.CSearchSaleList.cond", "cond", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.market_pro.Condition; });

		public var cond:com.msg.market_pro.Condition;

		/**
		 *  @private
		 */
		public static const PAGE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.CSearchSaleList.page", "page", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var page:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.cond);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.page);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var cond$count:uint = 0;
			var page$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (cond$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSearchSaleList.cond cannot be set twice.');
					}
					++cond$count;
					this.cond = new com.msg.market_pro.Condition();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.cond);
					break;
				case 2:
					if (page$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSearchSaleList.page cannot be set twice.');
					}
					++page$count;
					this.page = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
