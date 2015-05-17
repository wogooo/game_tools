package com.msg.item {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.enumdef.BindingType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CharacterEquip extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const EQUIP_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.equip_id", "equipId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var equipId:int;

		/**
		 *  @private
		 */
		public static const TEMPLATE_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.template_id", "templateId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var templateId:int;

		/**
		 *  @private
		 */
		public static const BINDING_ATTR:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.item.CharacterEquip.binding_attr", "bindingAttr", (3 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.BindingType);

		public var bindingAttr:int;

		/**
		 *  @private
		 */
		public static const CUR_DURABILITY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.cur_durability", "curDurability", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var curDurability:int;

		/**
		 *  @private
		 */
		public static const ENHANCE_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.enhance_level", "enhanceLevel", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var enhanceLevel:int;

		/**
		 *  @private
		 */
		public static const GEM_1_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_1_id", "gem_1Id", (6 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const GEM_2_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_2_id", "gem_2Id", (7 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const GEM_3_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_3_id", "gem_3Id", (8 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const GEM_4_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_4_id", "gem_4Id", (9 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const GEM_5_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_5_id", "gem_5Id", (10 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const GEM_6_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_6_id", "gem_6Id", (11 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const GEM_7_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_7_id", "gem_7Id", (12 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const GEM_8_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_8_id", "gem_8Id", (13 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const OBTAIN_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.obtain_time", "obtainTime", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var obtain_time$field:int;

		public function clearObtainTime():void {
			hasField$0 &= 0xfffffeff;
			obtain_time$field = new int();
		}

		public function get hasObtainTime():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set obtainTime(value:int):void {
			hasField$0 |= 0x100;
			obtain_time$field = value;
		}

		public function get obtainTime():int {
			return obtain_time$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.equipId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.templateId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.bindingAttr);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.curDurability);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.enhanceLevel);
			if (hasGem_1Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_1_id$field);
			}
			if (hasGem_2Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_2_id$field);
			}
			if (hasGem_3Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_3_id$field);
			}
			if (hasGem_4Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_4_id$field);
			}
			if (hasGem_5Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_5_id$field);
			}
			if (hasGem_6Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_6_id$field);
			}
			if (hasGem_7Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_7_id$field);
			}
			if (hasGem_8Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_8_id$field);
			}
			if (hasObtainTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, obtain_time$field);
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
			var template_id$count:uint = 0;
			var binding_attr$count:uint = 0;
			var cur_durability$count:uint = 0;
			var enhance_level$count:uint = 0;
			var gem_1_id$count:uint = 0;
			var gem_2_id$count:uint = 0;
			var gem_3_id$count:uint = 0;
			var gem_4_id$count:uint = 0;
			var gem_5_id$count:uint = 0;
			var gem_6_id$count:uint = 0;
			var gem_7_id$count:uint = 0;
			var gem_8_id$count:uint = 0;
			var obtain_time$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (equip_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.equipId cannot be set twice.');
					}
					++equip_id$count;
					this.equipId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (template_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.templateId cannot be set twice.');
					}
					++template_id$count;
					this.templateId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (binding_attr$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.bindingAttr cannot be set twice.');
					}
					++binding_attr$count;
					this.bindingAttr = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 4:
					if (cur_durability$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.curDurability cannot be set twice.');
					}
					++cur_durability$count;
					this.curDurability = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (enhance_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.enhanceLevel cannot be set twice.');
					}
					++enhance_level$count;
					this.enhanceLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (gem_1_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_1Id cannot be set twice.');
					}
					++gem_1_id$count;
					this.gem_1Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (gem_2_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_2Id cannot be set twice.');
					}
					++gem_2_id$count;
					this.gem_2Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (gem_3_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_3Id cannot be set twice.');
					}
					++gem_3_id$count;
					this.gem_3Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (gem_4_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_4Id cannot be set twice.');
					}
					++gem_4_id$count;
					this.gem_4Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 10:
					if (gem_5_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_5Id cannot be set twice.');
					}
					++gem_5_id$count;
					this.gem_5Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 11:
					if (gem_6_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_6Id cannot be set twice.');
					}
					++gem_6_id$count;
					this.gem_6Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 12:
					if (gem_7_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_7Id cannot be set twice.');
					}
					++gem_7_id$count;
					this.gem_7Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 13:
					if (gem_8_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_8Id cannot be set twice.');
					}
					++gem_8_id$count;
					this.gem_8Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 14:
					if (obtain_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.obtainTime cannot be set twice.');
					}
					++obtain_time$count;
					this.obtainTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
