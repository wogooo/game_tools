package com.msg.black_shop {
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
	public dynamic final class BlackShopItemInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const BUY_INFO:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.black_shop.BlackShopItemInfo.buy_info", "buyInfo", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var buyInfo:int;

		/**
		 *  @private
		 */
		public static const TMP_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.black_shop.BlackShopItemInfo.tmp_id", "tmpId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var tmpId:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.buyInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.tmpId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var buy_info$count:uint = 0;
			var tmp_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (buy_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: BlackShopItemInfo.buyInfo cannot be set twice.');
					}
					++buy_info$count;
					this.buyInfo = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (tmp_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: BlackShopItemInfo.tmpId cannot be set twice.');
					}
					++tmp_id$count;
					this.tmpId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
