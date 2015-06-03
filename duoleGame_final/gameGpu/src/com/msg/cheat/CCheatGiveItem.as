package com.msg.cheat {
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
	public dynamic final class CCheatGiveItem extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ITEM_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.cheat.CCheatGiveItem.item_type", "itemType", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var itemType:int;

		/**
		 *  @private
		 */
		public static const ITEM_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.cheat.CCheatGiveItem.item_id", "itemId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var itemId:int;

		/**
		 *  @private
		 */
		public static const ITEM_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.cheat.CCheatGiveItem.item_number", "itemNumber", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var item_number$field:int;

		private var hasField$0:uint = 0;

		public function clearItemNumber():void {
			hasField$0 &= 0xfffffffe;
			item_number$field = new int();
		}

		public function get hasItemNumber():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set itemNumber(value:int):void {
			hasField$0 |= 0x1;
			item_number$field = value;
		}

		public function get itemNumber():int {
			return item_number$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.itemType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.itemId);
			if (hasItemNumber) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, item_number$field);
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
			var item_number$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (item_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: CCheatGiveItem.itemType cannot be set twice.');
					}
					++item_type$count;
					this.itemType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (item_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CCheatGiveItem.itemId cannot be set twice.');
					}
					++item_id$count;
					this.itemId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (item_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: CCheatGiveItem.itemNumber cannot be set twice.');
					}
					++item_number$count;
					this.itemNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
