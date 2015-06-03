package com.msg.mapScene {
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
	public dynamic final class SHeroEquipChange extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SHeroEquipChange.dy_id", "dyId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dyId:int;

		/**
		 *  @private
		 */
		public static const PART_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SHeroEquipChange.part_type", "partType", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var partType:int;

		/**
		 *  @private
		 */
		public static const EQUIP_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SHeroEquipChange.equip_id", "equipId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var equipId:int;

		/**
		 *  @private
		 */
		public static const EQUIP_ENHANCE_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mapScene.SHeroEquipChange.equip_enhance_level", "equipEnhanceLevel", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var equip_enhance_level$field:int;

		private var hasField$0:uint = 0;

		public function clearEquipEnhanceLevel():void {
			hasField$0 &= 0xfffffffe;
			equip_enhance_level$field = new int();
		}

		public function get hasEquipEnhanceLevel():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set equipEnhanceLevel(value:int):void {
			hasField$0 |= 0x1;
			equip_enhance_level$field = value;
		}

		public function get equipEnhanceLevel():int {
			return equip_enhance_level$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.dyId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.partType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.equipId);
			if (hasEquipEnhanceLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, equip_enhance_level$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dy_id$count:uint = 0;
			var part_type$count:uint = 0;
			var equip_id$count:uint = 0;
			var equip_enhance_level$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dy_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroEquipChange.dyId cannot be set twice.');
					}
					++dy_id$count;
					this.dyId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (part_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroEquipChange.partType cannot be set twice.');
					}
					++part_type$count;
					this.partType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (equip_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroEquipChange.equipId cannot be set twice.');
					}
					++equip_id$count;
					this.equipId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (equip_enhance_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SHeroEquipChange.equipEnhanceLevel cannot be set twice.');
					}
					++equip_enhance_level$count;
					this.equipEnhanceLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
