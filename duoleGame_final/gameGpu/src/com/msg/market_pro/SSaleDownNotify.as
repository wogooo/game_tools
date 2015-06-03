package com.msg.market_pro {
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
	public dynamic final class SSaleDownNotify extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ITEM_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.SSaleDownNotify.item_type", "itemType", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var item_type$field:int;

		private var hasField$0:uint = 0;

		public function clearItemType():void {
			hasField$0 &= 0xfffffffe;
			item_type$field = new int();
		}

		public function get hasItemType():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set itemType(value:int):void {
			hasField$0 |= 0x1;
			item_type$field = value;
		}

		public function get itemType():int {
			return item_type$field;
		}

		/**
		 *  @private
		 */
		public static const ITEM_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.SSaleDownNotify.item_id", "itemId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var item_id$field:int;

		public function clearItemId():void {
			hasField$0 &= 0xfffffffd;
			item_id$field = new int();
		}

		public function get hasItemId():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set itemId(value:int):void {
			hasField$0 |= 0x2;
			item_id$field = value;
		}

		public function get itemId():int {
			return item_id$field;
		}

		/**
		 *  @private
		 */
		public static const MONEY_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.SSaleDownNotify.money_type", "moneyType", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var money_type$field:int;

		public function clearMoneyType():void {
			hasField$0 &= 0xfffffffb;
			money_type$field = new int();
		}

		public function get hasMoneyType():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set moneyType(value:int):void {
			hasField$0 |= 0x4;
			money_type$field = value;
		}

		public function get moneyType():int {
			return money_type$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasItemType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, item_type$field);
			}
			if (hasItemId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, item_id$field);
			}
			if (hasMoneyType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, money_type$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var item_type$count:uint = 0;
			var item_id$count:uint = 0;
			var money_type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (item_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SSaleDownNotify.itemType cannot be set twice.');
					}
					++item_type$count;
					this.itemType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SSaleDownNotify.itemId cannot be set twice.');
					}
					++item_id$count;
					this.itemId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (money_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SSaleDownNotify.moneyType cannot be set twice.');
					}
					++money_type$count;
					this.moneyType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
