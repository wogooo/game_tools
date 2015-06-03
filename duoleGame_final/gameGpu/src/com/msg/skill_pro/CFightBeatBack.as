package com.msg.skill_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.skill_pro.BeatBackTarget;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CFightBeatBack extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SKILL_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.CFightBeatBack.skill_id", "skillId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var skillId:int;

		/**
		 *  @private
		 */
		public static const SKILL_TAG_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.CFightBeatBack.skill_tag_pos", "skillTagPos", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var skill_tag_pos$field:int;

		private var hasField$0:uint = 0;

		public function clearSkillTagPos():void {
			hasField$0 &= 0xfffffffe;
			skill_tag_pos$field = new int();
		}

		public function get hasSkillTagPos():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set skillTagPos(value:int):void {
			hasField$0 |= 0x1;
			skill_tag_pos$field = value;
		}

		public function get skillTagPos():int {
			return skill_tag_pos$field;
		}

		/**
		 *  @private
		 */
		public static const TAG_INFO_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.skill_pro.CFightBeatBack.tag_info_arr", "tagInfoArr", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.skill_pro.BeatBackTarget; });

		[ArrayElementType("com.msg.skill_pro.BeatBackTarget")]
		public var tagInfoArr:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.skillId);
			if (hasSkillTagPos) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, skill_tag_pos$field);
			}
			for (var tagInfoArr$index:uint = 0; tagInfoArr$index < this.tagInfoArr.length; ++tagInfoArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.tagInfoArr[tagInfoArr$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var skill_id$count:uint = 0;
			var skill_tag_pos$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (skill_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CFightBeatBack.skillId cannot be set twice.');
					}
					++skill_id$count;
					this.skillId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (skill_tag_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CFightBeatBack.skillTagPos cannot be set twice.');
					}
					++skill_tag_pos$count;
					this.skillTagPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					this.tagInfoArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.skill_pro.BeatBackTarget()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
