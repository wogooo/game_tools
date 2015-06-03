package com.msg.hero {
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
	public dynamic final class CBeginPay extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PFKEY:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.hero.CBeginPay.pfkey", "pfkey", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var pfkey:String;

		/**
		 *  @private
		 */
		public static const PAY_ITEM:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.hero.CBeginPay.pay_item", "payItem", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var payItem:String;

		/**
		 *  @private
		 */
		public static const GOODS_URL:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.hero.CBeginPay.goods_url", "goodsUrl", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var goodsUrl:String;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.pfkey);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.payItem);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.goodsUrl);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var pfkey$count:uint = 0;
			var pay_item$count:uint = 0;
			var goods_url$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (pfkey$count != 0) {
						throw new flash.errors.IOError('Bad data format: CBeginPay.pfkey cannot be set twice.');
					}
					++pfkey$count;
					this.pfkey = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (pay_item$count != 0) {
						throw new flash.errors.IOError('Bad data format: CBeginPay.payItem cannot be set twice.');
					}
					++pay_item$count;
					this.payItem = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (goods_url$count != 0) {
						throw new flash.errors.IOError('Bad data format: CBeginPay.goodsUrl cannot be set twice.');
					}
					++goods_url$count;
					this.goodsUrl = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
