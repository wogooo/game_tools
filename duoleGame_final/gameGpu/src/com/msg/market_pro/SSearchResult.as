package com.msg.market_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.market_pro.Record;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SSearchResult extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TOTAL_PAGE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.SSearchResult.total_page", "totalPage", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var totalPage:int;

		/**
		 *  @private
		 */
		public static const RECORD_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.market_pro.SSearchResult.record_arr", "recordArr", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.market_pro.Record; });

		[ArrayElementType("com.msg.market_pro.Record")]
		public var recordArr:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.totalPage);
			for (var recordArr$index:uint = 0; recordArr$index < this.recordArr.length; ++recordArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.recordArr[recordArr$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var total_page$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (total_page$count != 0) {
						throw new flash.errors.IOError('Bad data format: SSearchResult.totalPage cannot be set twice.');
					}
					++total_page$count;
					this.totalPage = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					this.recordArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.market_pro.Record()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
