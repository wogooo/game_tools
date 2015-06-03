package com.msg.black_shop {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.black_shop.BlackShopItemInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SGetBlackShopList extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const BLACK_ITEM_INFO:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.black_shop.SGetBlackShopList.black_item_info", "blackItemInfo", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.black_shop.BlackShopItemInfo; });

		[ArrayElementType("com.msg.black_shop.BlackShopItemInfo")]
		public var blackItemInfo:Array = [];

		/**
		 *  @private
		 */
		public static const REFRESH:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.black_shop.SGetBlackShopList.refresh", "refresh", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var refresh:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var blackItemInfo$index:uint = 0; blackItemInfo$index < this.blackItemInfo.length; ++blackItemInfo$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.blackItemInfo[blackItemInfo$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.refresh);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var refresh$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.blackItemInfo.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.black_shop.BlackShopItemInfo()));
					break;
				case 2:
					if (refresh$count != 0) {
						throw new flash.errors.IOError('Bad data format: SGetBlackShopList.refresh cannot be set twice.');
					}
					++refresh$count;
					this.refresh = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
