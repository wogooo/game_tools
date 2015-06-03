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
	public dynamic final class CUpSale extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ITEM_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.CUpSale.item_pos", "itemPos", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var item_pos$field:int;

		private var hasField$0:uint = 0;

		public function clearItemPos():void {
			hasField$0 &= 0xfffffffe;
			item_pos$field = new int();
		}

		public function get hasItemPos():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set itemPos(value:int):void {
			hasField$0 |= 0x1;
			item_pos$field = value;
		}

		public function get itemPos():int {
			return item_pos$field;
		}

		/**
		 *  @private
		 */
		public static const MONEY_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.CUpSale.money_type", "moneyType", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var money_type$field:int;

		public function clearMoneyType():void {
			hasField$0 &= 0xfffffffd;
			money_type$field = new int();
		}

		public function get hasMoneyType():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set moneyType(value:int):void {
			hasField$0 |= 0x2;
			money_type$field = value;
		}

		public function get moneyType():int {
			return money_type$field;
		}

		/**
		 *  @private
		 */
		public static const UNIT_PRICE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.CUpSale.unit_price", "unitPrice", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var unitPrice:int;

		/**
		 *  @private
		 */
		public static const PRICE_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.CUpSale.price_type", "priceType", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var priceType:int;

		/**
		 *  @private
		 */
		public static const SALE_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.CUpSale.sale_number", "saleNumber", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var saleNumber:int;

		/**
		 *  @private
		 */
		public static const SEND_WORLD:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.market_pro.CUpSale.send_world", "sendWorld", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var send_world$field:String;

		public function clearSendWorld():void {
			send_world$field = null;
		}

		public function get hasSendWorld():Boolean {
			return send_world$field != null;
		}

		public function set sendWorld(value:String):void {
			send_world$field = value;
		}

		public function get sendWorld():String {
			return send_world$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasItemPos) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, item_pos$field);
			}
			if (hasMoneyType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, money_type$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.unitPrice);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.priceType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.saleNumber);
			if (hasSendWorld) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, send_world$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var item_pos$count:uint = 0;
			var money_type$count:uint = 0;
			var unit_price$count:uint = 0;
			var price_type$count:uint = 0;
			var sale_number$count:uint = 0;
			var send_world$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (item_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CUpSale.itemPos cannot be set twice.');
					}
					++item_pos$count;
					this.itemPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (money_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: CUpSale.moneyType cannot be set twice.');
					}
					++money_type$count;
					this.moneyType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (unit_price$count != 0) {
						throw new flash.errors.IOError('Bad data format: CUpSale.unitPrice cannot be set twice.');
					}
					++unit_price$count;
					this.unitPrice = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (price_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: CUpSale.priceType cannot be set twice.');
					}
					++price_type$count;
					this.priceType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (sale_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: CUpSale.saleNumber cannot be set twice.');
					}
					++sale_number$count;
					this.saleNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (send_world$count != 0) {
						throw new flash.errors.IOError('Bad data format: CUpSale.sendWorld cannot be set twice.');
					}
					++send_world$count;
					this.sendWorld = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
