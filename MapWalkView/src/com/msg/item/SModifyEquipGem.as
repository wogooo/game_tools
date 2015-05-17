package com.msg.item {
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
	public dynamic final class SModifyEquipGem extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const EQUIP_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipGem.equip_id", "equipId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var equipId:int;

		/**
		 *  @private
		 */
		public static const GEM_1_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipGem.gem_1_id", "gem_1Id", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_1_id$field:int;

		private var hasField$0:uint = 0;

		public function clearGem_1Id():void {
			hasField$0 &= 0xfffffffe;
			gem_1_id$field = new int();
		}

		public function get hasGem_1Id():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set gem_1Id(value:int):void {
			hasField$0 |= 0x1;
			gem_1_id$field = value;
		}

		public function get gem_1Id():int {
			return gem_1_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_2_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipGem.gem_2_id", "gem_2Id", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_2_id$field:int;

		public function clearGem_2Id():void {
			hasField$0 &= 0xfffffffd;
			gem_2_id$field = new int();
		}

		public function get hasGem_2Id():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set gem_2Id(value:int):void {
			hasField$0 |= 0x2;
			gem_2_id$field = value;
		}

		public function get gem_2Id():int {
			return gem_2_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_3_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipGem.gem_3_id", "gem_3Id", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_3_id$field:int;

		public function clearGem_3Id():void {
			hasField$0 &= 0xfffffffb;
			gem_3_id$field = new int();
		}

		public function get hasGem_3Id():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set gem_3Id(value:int):void {
			hasField$0 |= 0x4;
			gem_3_id$field = value;
		}

		public function get gem_3Id():int {
			return gem_3_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_4_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipGem.gem_4_id", "gem_4Id", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_4_id$field:int;

		public function clearGem_4Id():void {
			hasField$0 &= 0xfffffff7;
			gem_4_id$field = new int();
		}

		public function get hasGem_4Id():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set gem_4Id(value:int):void {
			hasField$0 |= 0x8;
			gem_4_id$field = value;
		}

		public function get gem_4Id():int {
			return gem_4_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_5_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipGem.gem_5_id", "gem_5Id", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_5_id$field:int;

		public function clearGem_5Id():void {
			hasField$0 &= 0xffffffef;
			gem_5_id$field = new int();
		}

		public function get hasGem_5Id():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set gem_5Id(value:int):void {
			hasField$0 |= 0x10;
			gem_5_id$field = value;
		}

		public function get gem_5Id():int {
			return gem_5_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_6_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipGem.gem_6_id", "gem_6Id", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_6_id$field:int;

		public function clearGem_6Id():void {
			hasField$0 &= 0xffffffdf;
			gem_6_id$field = new int();
		}

		public function get hasGem_6Id():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set gem_6Id(value:int):void {
			hasField$0 |= 0x20;
			gem_6_id$field = value;
		}

		public function get gem_6Id():int {
			return gem_6_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_7_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipGem.gem_7_id", "gem_7Id", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_7_id$field:int;

		public function clearGem_7Id():void {
			hasField$0 &= 0xffffffbf;
			gem_7_id$field = new int();
		}

		public function get hasGem_7Id():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set gem_7Id(value:int):void {
			hasField$0 |= 0x40;
			gem_7_id$field = value;
		}

		public function get gem_7Id():int {
			return gem_7_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_8_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.SModifyEquipGem.gem_8_id", "gem_8Id", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_8_id$field:int;

		public function clearGem_8Id():void {
			hasField$0 &= 0xffffff7f;
			gem_8_id$field = new int();
		}

		public function get hasGem_8Id():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set gem_8Id(value:int):void {
			hasField$0 |= 0x80;
			gem_8_id$field = value;
		}

		public function get gem_8Id():int {
			return gem_8_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.equipId);
			if (hasGem_1Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_1_id$field);
			}
			if (hasGem_2Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_2_id$field);
			}
			if (hasGem_3Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_3_id$field);
			}
			if (hasGem_4Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_4_id$field);
			}
			if (hasGem_5Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_5_id$field);
			}
			if (hasGem_6Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_6_id$field);
			}
			if (hasGem_7Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_7_id$field);
			}
			if (hasGem_8Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_8_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var equip_id$count:uint = 0;
			var gem_1_id$count:uint = 0;
			var gem_2_id$count:uint = 0;
			var gem_3_id$count:uint = 0;
			var gem_4_id$count:uint = 0;
			var gem_5_id$count:uint = 0;
			var gem_6_id$count:uint = 0;
			var gem_7_id$count:uint = 0;
			var gem_8_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (equip_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipGem.equipId cannot be set twice.');
					}
					++equip_id$count;
					this.equipId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (gem_1_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipGem.gem_1Id cannot be set twice.');
					}
					++gem_1_id$count;
					this.gem_1Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (gem_2_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipGem.gem_2Id cannot be set twice.');
					}
					++gem_2_id$count;
					this.gem_2Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (gem_3_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipGem.gem_3Id cannot be set twice.');
					}
					++gem_3_id$count;
					this.gem_3Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (gem_4_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipGem.gem_4Id cannot be set twice.');
					}
					++gem_4_id$count;
					this.gem_4Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (gem_5_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipGem.gem_5Id cannot be set twice.');
					}
					++gem_5_id$count;
					this.gem_5Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (gem_6_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipGem.gem_6Id cannot be set twice.');
					}
					++gem_6_id$count;
					this.gem_6Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (gem_7_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipGem.gem_7Id cannot be set twice.');
					}
					++gem_7_id$count;
					this.gem_7Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (gem_8_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SModifyEquipGem.gem_8Id cannot be set twice.');
					}
					++gem_8_id$count;
					this.gem_8Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
