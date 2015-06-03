package com.msg.market_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.item.CharacterEquip;
	import com.msg.item.CharacterProps;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class Record extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RECORD_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Record.record_id", "recordId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var recordId:int;

		/**
		 *  @private
		 */
		public static const PROP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.market_pro.Record.prop", "prop", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.item.CharacterProps; });

		private var prop$field:com.msg.item.CharacterProps;

		public function clearProp():void {
			prop$field = null;
		}

		public function get hasProp():Boolean {
			return prop$field != null;
		}

		public function set prop(value:com.msg.item.CharacterProps):void {
			prop$field = value;
		}

		public function get prop():com.msg.item.CharacterProps {
			return prop$field;
		}

		/**
		 *  @private
		 */
		public static const EQUIP:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.market_pro.Record.equip", "equip", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.item.CharacterEquip; });

		private var equip$field:com.msg.item.CharacterEquip;

		public function clearEquip():void {
			equip$field = null;
		}

		public function get hasEquip():Boolean {
			return equip$field != null;
		}

		public function set equip(value:com.msg.item.CharacterEquip):void {
			equip$field = value;
		}

		public function get equip():com.msg.item.CharacterEquip {
			return equip$field;
		}

		/**
		 *  @private
		 */
		public static const ITEM_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Record.item_type", "itemType", (4 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const ITEM_TMPL_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Record.item_tmpl_id", "itemTmplId", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var item_tmpl_id$field:int;

		public function clearItemTmplId():void {
			hasField$0 &= 0xfffffffd;
			item_tmpl_id$field = new int();
		}

		public function get hasItemTmplId():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set itemTmplId(value:int):void {
			hasField$0 |= 0x2;
			item_tmpl_id$field = value;
		}

		public function get itemTmplId():int {
			return item_tmpl_id$field;
		}

		/**
		 *  @private
		 */
		public static const UNIT_PRICE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Record.unit_price", "unitPrice", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var unitPrice:int;

		/**
		 *  @private
		 */
		public static const PRICE_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Record.price_type", "priceType", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var priceType:int;

		/**
		 *  @private
		 */
		public static const NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Record.number", "number", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		public var number:int;

		/**
		 *  @private
		 */
		public static const PLAYER_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.market_pro.Record.player_name", "playerName", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var playerName:String;

		/**
		 *  @private
		 */
		public static const SALE_MONEY_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.market_pro.Record.sale_money_type", "saleMoneyType", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var sale_money_type$field:int;

		public function clearSaleMoneyType():void {
			hasField$0 &= 0xfffffffb;
			sale_money_type$field = new int();
		}

		public function get hasSaleMoneyType():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set saleMoneyType(value:int):void {
			hasField$0 |= 0x4;
			sale_money_type$field = value;
		}

		public function get saleMoneyType():int {
			return sale_money_type$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.recordId);
			if (hasProp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, prop$field);
			}
			if (hasEquip) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, equip$field);
			}
			if (hasItemType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, item_type$field);
			}
			if (hasItemTmplId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, item_tmpl_id$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.unitPrice);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.priceType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.number);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.playerName);
			if (hasSaleMoneyType) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, sale_money_type$field);
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
			var prop$count:uint = 0;
			var equip$count:uint = 0;
			var item_type$count:uint = 0;
			var item_tmpl_id$count:uint = 0;
			var unit_price$count:uint = 0;
			var price_type$count:uint = 0;
			var number$count:uint = 0;
			var player_name$count:uint = 0;
			var sale_money_type$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (record_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: Record.recordId cannot be set twice.');
					}
					++record_id$count;
					this.recordId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (prop$count != 0) {
						throw new flash.errors.IOError('Bad data format: Record.prop cannot be set twice.');
					}
					++prop$count;
					this.prop = new com.msg.item.CharacterProps();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.prop);
					break;
				case 3:
					if (equip$count != 0) {
						throw new flash.errors.IOError('Bad data format: Record.equip cannot be set twice.');
					}
					++equip$count;
					this.equip = new com.msg.item.CharacterEquip();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.equip);
					break;
				case 4:
					if (item_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: Record.itemType cannot be set twice.');
					}
					++item_type$count;
					this.itemType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (item_tmpl_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: Record.itemTmplId cannot be set twice.');
					}
					++item_tmpl_id$count;
					this.itemTmplId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (unit_price$count != 0) {
						throw new flash.errors.IOError('Bad data format: Record.unitPrice cannot be set twice.');
					}
					++unit_price$count;
					this.unitPrice = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (price_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: Record.priceType cannot be set twice.');
					}
					++price_type$count;
					this.priceType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (number$count != 0) {
						throw new flash.errors.IOError('Bad data format: Record.number cannot be set twice.');
					}
					++number$count;
					this.number = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (player_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: Record.playerName cannot be set twice.');
					}
					++player_name$count;
					this.playerName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 10:
					if (sale_money_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: Record.saleMoneyType cannot be set twice.');
					}
					++sale_money_type$count;
					this.saleMoneyType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
