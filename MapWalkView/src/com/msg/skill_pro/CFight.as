package com.msg.skill_pro {
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
	public dynamic final class CFight extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SKILL_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.CFight.skill_id", "skillId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var skillId:int;

		/**
		 *  @private
		 */
		public static const TAG_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.CFight.tag_pos", "tagPos", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var tag_pos$field:int;

		private var hasField$0:uint = 0;

		public function clearTagPos():void {
			hasField$0 &= 0xfffffffe;
			tag_pos$field = new int();
		}

		public function get hasTagPos():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set tagPos(value:int):void {
			hasField$0 |= 0x1;
			tag_pos$field = value;
		}

		public function get tagPos():int {
			return tag_pos$field;
		}

		/**
		 *  @private
		 */
		public static const TAG_ID_ARR:RepeatedFieldDescriptor$TYPE_INT32 = new RepeatedFieldDescriptor$TYPE_INT32("com.msg.skill_pro.CFight.tag_id_arr", "tagIdArr", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("int")]
		public var tagIdArr:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.skillId);
			if (hasTagPos) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, tag_pos$field);
			}
			for (var tagIdArr$index:uint = 0; tagIdArr$index < this.tagIdArr.length; ++tagIdArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.tagIdArr[tagIdArr$index]);
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
			var tag_pos$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (skill_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CFight.skillId cannot be set twice.');
					}
					++skill_id$count;
					this.skillId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (tag_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CFight.tagPos cannot be set twice.');
					}
					++tag_pos$count;
					this.tagPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_INT32, this.tagIdArr);
						break;
					}
					this.tagIdArr.push(com.netease.protobuf.ReadUtils.read$TYPE_INT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
