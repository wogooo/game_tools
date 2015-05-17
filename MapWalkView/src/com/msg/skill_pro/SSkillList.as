package com.msg.skill_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.common.SkillInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SSkillList extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SKILL_LIST_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.skill_pro.SSkillList.skill_list_arr", "skillListArr", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.SkillInfo; });

		[ArrayElementType("com.msg.common.SkillInfo")]
		public var skillListArr:Array = [];

		/**
		 *  @private
		 */
		public static const DEFAULT_SKILL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SSkillList.default_skill", "defaultSkill", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var defaultSkill:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var skillListArr$index:uint = 0; skillListArr$index < this.skillListArr.length; ++skillListArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.skillListArr[skillListArr$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.defaultSkill);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var default_skill$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.skillListArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.SkillInfo()));
					break;
				case 2:
					if (default_skill$count != 0) {
						throw new flash.errors.IOError('Bad data format: SSkillList.defaultSkill cannot be set twice.');
					}
					++default_skill$count;
					this.defaultSkill = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
