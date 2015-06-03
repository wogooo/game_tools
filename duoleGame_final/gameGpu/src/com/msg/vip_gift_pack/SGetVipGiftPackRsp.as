package com.msg.vip_gift_pack {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.vip_gift_pack.GiftPackType;
	import com.msg.enumdef.RspMsg;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SGetVipGiftPackRsp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const GIFT_PACK_TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.vip_gift_pack.SGetVipGiftPackRsp.gift_pack_type", "giftPackType", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.vip_gift_pack.GiftPackType);

		public var giftPackType:int;

		/**
		 *  @private
		 */
		public static const RSP:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.vip_gift_pack.SGetVipGiftPackRsp.rsp", "rsp", (2 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.RspMsg);

		public var rsp:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.giftPackType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.rsp);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var gift_pack_type$count:uint = 0;
			var rsp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (gift_pack_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SGetVipGiftPackRsp.giftPackType cannot be set twice.');
					}
					++gift_pack_type$count;
					this.giftPackType = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (rsp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SGetVipGiftPackRsp.rsp cannot be set twice.');
					}
					++rsp$count;
					this.rsp = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
