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
	public dynamic final class Condition extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Condition.level", "level", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var level$field:int;

		private var hasField$0:uint = 0;

		public function clearLevel():void {
			hasField$0 &= 0xfffffffe;
			level$field = new int();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set level(value:int):void {
			hasField$0 |= 0x1;
			level$field = value;
		}

		public function get level():int {
			return level$field;
		}

		/**
		 *  @private
		 */
		public static const QUALITY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Condition.quality", "quality", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var quality$field:int;

		public function clearQuality():void {
			hasField$0 &= 0xfffffffd;
			quality$field = new int();
		}

		public function get hasQuality():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set quality(value:int):void {
			hasField$0 |= 0x2;
			quality$field = value;
		}

		public function get quality():int {
			return quality$field;
		}

		/**
		 *  @private
		 */
		public static const MONEY_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Condition.money_type", "moneyType", (3 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const MIN_MONEY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Condition.min_money", "minMoney", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var min_money$field:int;

		public function clearMinMoney():void {
			hasField$0 &= 0xfffffff7;
			min_money$field = new int();
		}

		public function get hasMinMoney():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set minMoney(value:int):void {
			hasField$0 |= 0x8;
			min_money$field = value;
		}

		public function get minMoney():int {
			return min_money$field;
		}

		/**
		 *  @private
		 */
		public static const MAX_MONEY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Condition.max_money", "maxMoney", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var max_money$field:int;

		public function clearMaxMoney():void {
			hasField$0 &= 0xffffffef;
			max_money$field = new int();
		}

		public function get hasMaxMoney():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set maxMoney(value:int):void {
			hasField$0 |= 0x10;
			max_money$field = value;
		}

		public function get maxMoney():int {
			return max_money$field;
		}

		/**
		 *  @private
		 */
		public static const SUB_CLASSIC_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Condition.sub_classic_type", "subClassicType", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var sub_classic_type$field:int;

		public function clearSubClassicType():void {
			hasField$0 &= 0xffffffdf;
			sub_classic_type$field = new int();
		}

		public function get hasSubClassicType():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set subClassicType(value:int):void {
			hasField$0 |= 0x20;
			sub_classic_type$field = value;
		}

		public function get subClassicType():int {
			return sub_classic_type$field;
		}

		/**
		 *  @private
		 */
		public static const ITEM_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Condition.item_type", "itemType", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var item_type$field:int;

		public function clearItemType():void {
			hasField$0 &= 0xffffffbf;
			item_type$field = new int();
		}

		public function get hasItemType():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set itemType(value:int):void {
			hasField$0 |= 0x40;
			item_type$field = value;
		}

		public function get itemType():int {
			return item_type$field;
		}

		/**
		 *  @private
		 */
		public static const ITEM_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Condition.item_id", "itemId", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var item_id$field:int;

		public function clearItemId():void {
			hasField$0 &= 0xffffff7f;
			item_id$field = new int();
		}

		public function get hasItemId():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set itemId(value:int):void {
			hasField$0 |= 0x80;
			item_id$field = value;
		}

		public function get itemId():int {
			return item_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, level$field);
			}
			if (hasQuality) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, quality$field);
			}
			if (hasMoneyType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, money_type$field);
			}
			if (hasMinMoney) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, min_money$field);
			}
			if (hasMaxMoney) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, max_money$field);
			}
			if (hasSubClassicType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, sub_classic_type$field);
			}
			if (hasItemType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, item_type$field);
			}
			if (hasItemId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, item_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var level$count:uint = 0;
			var quality$count:uint = 0;
			var money_type$count:uint = 0;
			var min_money$count:uint = 0;
			var max_money$count:uint = 0;
			var sub_classic_type$count:uint = 0;
			var item_type$count:uint = 0;
			var item_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: Condition.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (quality$count != 0) {
						throw new flash.errors.IOError('Bad data format: Condition.quality cannot be set twice.');
					}
					++quality$count;
					this.quality = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (money_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: Condition.moneyType cannot be set twice.');
					}
					++money_type$count;
					this.moneyType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (min_money$count != 0) {
						throw new flash.errors.IOError('Bad data format: Condition.minMoney cannot be set twice.');
					}
					++min_money$count;
					this.minMoney = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (max_money$count != 0) {
						throw new flash.errors.IOError('Bad data format: Condition.maxMoney cannot be set twice.');
					}
					++max_money$count;
					this.maxMoney = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (sub_classic_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: Condition.subClassicType cannot be set twice.');
					}
					++sub_classic_type$count;
					this.subClassicType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (item_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: Condition.itemType cannot be set twice.');
					}
					++item_type$count;
					this.itemType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: Condition.itemId cannot be set twice.');
					}
					++item_id$count;
					this.itemId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
