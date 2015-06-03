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
	public dynamic final class SPickupItem extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ERRO_INFO:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SPickupItem.erro_info", "erroInfo", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var erroInfo:int;

		/**
		 *  @private
		 */
		public static const ITEM_DY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SPickupItem.item_dy_id", "itemDyId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var item_dy_id$field:int;

		private var hasField$0:uint = 0;

		public function clearItemDyId():void {
			hasField$0 &= 0xfffffffe;
			item_dy_id$field = new int();
		}

		public function get hasItemDyId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set itemDyId(value:int):void {
			hasField$0 |= 0x1;
			item_dy_id$field = value;
		}

		public function get itemDyId():int {
			return item_dy_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.erroInfo);
			if (hasItemDyId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, item_dy_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var erro_info$count:uint = 0;
			var item_dy_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (erro_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPickupItem.erroInfo cannot be set twice.');
					}
					++erro_info$count;
					this.erroInfo = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (item_dy_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPickupItem.itemDyId cannot be set twice.');
					}
					++item_dy_id$count;
					this.itemDyId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
