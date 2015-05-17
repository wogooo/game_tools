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
	public dynamic final class CUseItem extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ITEM_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.CUseItem.item_pos", "itemPos", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var itemPos:int;

		/**
		 *  @private
		 */
		public static const PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.CUseItem.pet_id", "petId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var pet_id$field:int;

		private var hasField$0:uint = 0;

		public function clearPetId():void {
			hasField$0 &= 0xfffffffe;
			pet_id$field = new int();
		}

		public function get hasPetId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set petId(value:int):void {
			hasField$0 |= 0x1;
			pet_id$field = value;
		}

		public function get petId():int {
			return pet_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.itemPos);
			if (hasPetId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, pet_id$field);
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
			var pet_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (item_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CUseItem.itemPos cannot be set twice.');
					}
					++item_pos$count;
					this.itemPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CUseItem.petId cannot be set twice.');
					}
					++pet_id$count;
					this.petId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
