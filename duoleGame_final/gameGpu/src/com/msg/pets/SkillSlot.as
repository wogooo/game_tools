package com.msg.pets {
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
	public dynamic final class SkillSlot extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SLOT_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SkillSlot.slot_id", "slotId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var slotId:int;

		/**
		 *  @private
		 */
		public static const SKILL_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SkillSlot.skill_id", "skillId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var skillId:int;

		/**
		 *  @private
		 */
		public static const SKILL_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SkillSlot.skill_level", "skillLevel", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var skill_level$field:int;

		private var hasField$0:uint = 0;

		public function clearSkillLevel():void {
			hasField$0 &= 0xfffffffe;
			skill_level$field = new int();
		}

		public function get hasSkillLevel():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set skillLevel(value:int):void {
			hasField$0 |= 0x1;
			skill_level$field = value;
		}

		public function get skillLevel():int {
			return skill_level$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.slotId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.skillId);
			if (hasSkillLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, skill_level$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var slot_id$count:uint = 0;
			var skill_id$count:uint = 0;
			var skill_level$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (slot_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SkillSlot.slotId cannot be set twice.');
					}
					++slot_id$count;
					this.slotId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (skill_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SkillSlot.skillId cannot be set twice.');
					}
					++skill_id$count;
					this.skillId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (skill_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SkillSlot.skillLevel cannot be set twice.');
					}
					++skill_level$count;
					this.skillLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
