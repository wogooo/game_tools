package com.msg.market_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.common.ItemConsume;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CSaleToWant extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RECORD_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.CSaleToWant.record_id", "recordId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var recordId:int;

		/**
		 *  @private
		 */
		public static const SALE_ITEMS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.market_pro.CSaleToWant.sale_items", "saleItems", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.ItemConsume; });

		[ArrayElementType("com.msg.common.ItemConsume")]
		public var saleItems:Array = [];

		/**
		 *  @private
		 */
		public static const MONEY_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.CSaleToWant.money_number", "moneyNumber", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var money_number$field:int;

		private var hasField$0:uint = 0;

		public function clearMoneyNumber():void {
			hasField$0 &= 0xfffffffe;
			money_number$field = new int();
		}

		public function get hasMoneyNumber():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set moneyNumber(value:int):void {
			hasField$0 |= 0x1;
			money_number$field = value;
		}

		public function get moneyNumber():int {
			return money_number$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.recordId);
			for (var saleItems$index:uint = 0; saleItems$index < this.saleItems.length; ++saleItems$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.saleItems[saleItems$index]);
			}
			if (hasMoneyNumber) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, money_number$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var record_id$count:uint = 0;
			var money_number$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (record_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSaleToWant.recordId cannot be set twice.');
					}
					++record_id$count;
					this.recordId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					this.saleItems.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.ItemConsume()));
					break;
				case 3:
					if (money_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSaleToWant.moneyNumber cannot be set twice.');
					}
					++money_number$count;
					this.moneyNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
