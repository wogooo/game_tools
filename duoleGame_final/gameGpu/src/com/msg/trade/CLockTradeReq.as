package com.msg.trade {
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
	public dynamic final class CLockTradeReq extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ITEM_POS_ARRAY:RepeatedFieldDescriptor$TYPE_INT32 = new RepeatedFieldDescriptor$TYPE_INT32("com.msg.trade.CLockTradeReq.item_pos_array", "itemPosArray", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("int")]
		public var itemPosArray:Array = [];

		/**
		 *  @private
		 */
		public static const DIAMOND_NUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.trade.CLockTradeReq.diamond_num", "diamondNum", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var diamond_num$field:int;

		private var hasField$0:uint = 0;

		public function clearDiamondNum():void {
			hasField$0 &= 0xfffffffe;
			diamond_num$field = new int();
		}

		public function get hasDiamondNum():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set diamondNum(value:int):void {
			hasField$0 |= 0x1;
			diamond_num$field = value;
		}

		public function get diamondNum():int {
			return diamond_num$field;
		}

		/**
		 *  @private
		 */
		public static const SILVER_NUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.trade.CLockTradeReq.silver_num", "silverNum", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var silver_num$field:int;

		public function clearSilverNum():void {
			hasField$0 &= 0xfffffffd;
			silver_num$field = new int();
		}

		public function get hasSilverNum():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set silverNum(value:int):void {
			hasField$0 |= 0x2;
			silver_num$field = value;
		}

		public function get silverNum():int {
			return silver_num$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var itemPosArray$index:uint = 0; itemPosArray$index < this.itemPosArray.length; ++itemPosArray$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.itemPosArray[itemPosArray$index]);
			}
			if (hasDiamondNum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, diamond_num$field);
			}
			if (hasSilverNum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, silver_num$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var diamond_num$count:uint = 0;
			var silver_num$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_INT32, this.itemPosArray);
						break;
					}
					this.itemPosArray.push(com.netease.protobuf.ReadUtils.read$TYPE_INT32(input));
					break;
				case 2:
					if (diamond_num$count != 0) {
						throw new flash.errors.IOError('Bad data format: CLockTradeReq.diamondNum cannot be set twice.');
					}
					++diamond_num$count;
					this.diamondNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (silver_num$count != 0) {
						throw new flash.errors.IOError('Bad data format: CLockTradeReq.silverNum cannot be set twice.');
					}
					++silver_num$count;
					this.silverNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
