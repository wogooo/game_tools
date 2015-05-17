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
	public dynamic final class SChangeMoney extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const MONEY_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SChangeMoney.money_type", "moneyType", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var moneyType:int;

		/**
		 *  @private
		 */
		public static const MONEY_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SChangeMoney.money_value", "moneyValue", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var moneyValue:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.moneyType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.moneyValue);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var money_type$count:uint = 0;
			var money_value$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (money_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SChangeMoney.moneyType cannot be set twice.');
					}
					++money_type$count;
					this.moneyType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (money_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: SChangeMoney.moneyValue cannot be set twice.');
					}
					++money_value$count;
					this.moneyValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
